#!/usr/bin/env bash
# Health check for this dotfiles setup. Read-only: it never installs or changes anything.
#
# Usage: bash tools/doctor.sh
# Exit code: 0 when there are no FAIL checks, 1 otherwise.

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=scripts/commons.sh
source "$DOTFILES/tools/scripts/commons.sh"

PASS=0; WARN=0; FAIL=0

ok()   { PASS=$((PASS + 1)); printf "  %s✔%s %s\n" "$C_GREEN" "$C_RESET" "$1"; }
warn() { WARN=$((WARN + 1)); printf "  %s!%s %s\n" "$C_YELLOW" "$C_RESET" "$1"; }
fail() { FAIL=$((FAIL + 1)); printf "  %s✘%s %s\n" "$C_RED" "$C_RESET" "$1"; }
skip() { printf "  %s-%s %s\n" "$C_DIM" "$C_RESET" "$1"; }
section() { printf "\n%s\n" "$1"; }

first_line() { "$@" 2>&1 | head -n 1; }

# --------------------------------------------------------------------------
section "Core commands"
for cmd in git curl vim tmux rg zsh nvim starship; do
  if validate_command "$cmd"; then
    ok "$cmd ($(command -v "$cmd"))"
  else
    fail "$cmd not found"
  fi
done

if validate_command nvim; then
  nvim_version="$(nvim --version | head -n 1 | sed -E 's/^NVIM v([0-9]+\.[0-9]+).*/\1/')"
  if [[ "$(printf '%s\n' 0.11 "$nvim_version" | sort -V | head -n 1)" == "0.11" ]]; then
    ok "nvim version $nvim_version (>= 0.11)"
  else
    fail "nvim version $nvim_version (LazyVim needs >= 0.11)"
  fi
fi

# --------------------------------------------------------------------------
section "Shell"
login_shell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)"
[[ -z "$login_shell" ]] && login_shell="$SHELL"
if [[ "$login_shell" == *zsh ]]; then
  ok "login shell is $login_shell"
else
  fail "login shell is $login_shell (expected zsh, run: chsh -s \"\$(command -v zsh)\")"
fi

if [ -s "$HOME/antigen.zsh" ]; then
  ok "antigen present ($HOME/antigen.zsh)"
else
  fail "antigen missing ($HOME/antigen.zsh)"
fi

# --------------------------------------------------------------------------
section "Symlinks"
check_link() {
  local src="$1" dest="$2"
  case "$(link_status "$src" "$dest")" in
    linked)     ok "$dest -> repo" ;;
    missing)    fail "$dest missing (run: bash tools/link_config.sh / init.sh)" ;;
    conflict)   fail "$dest is not linked to the repo: $(describe_conflict "$dest")" ;;
    broken-src) warn "$src not found in repo" ;;
  esac
}
for item in nvim tmux zsh starship.toml; do
  check_link "$DOTFILES/.config/$item" "$HOME/.config/$item"
done
check_link "$DOTFILES/.zshrc"                   "$HOME/.zshrc"
check_link "$DOTFILES/.config/tmux/tmux.conf"   "$HOME/.tmux.conf"

# Manual: only for IntelliJ users
if [[ "$(link_status "$DOTFILES/.ideavimrc" "$HOME/.ideavimrc")" == "linked" ]]; then
  ok "$HOME/.ideavimrc -> repo"
else
  skip "~/.ideavimrc not linked (manual, only for IntelliJ: bash tools/manual/ideavim.sh)"
fi

# --------------------------------------------------------------------------
section "Git"
git_name="$(git config --global user.name 2>/dev/null)"
if [[ -n "$git_name" ]]; then
  ok "user.name = $git_name"
else
  fail "user.name not set (run: bash tools/gitconfig.sh)"
fi

profile_count=0
while read -r key path; do
  folder="${key#includeif.gitdir:}"; folder="${folder%.path}"
  path_abs="${path/#\~/$HOME}"
  profile_count=$((profile_count + 1))
  if [[ ! -f "$path_abs" ]]; then
    fail "profile for $folder: $path not found"
    continue
  fi
  email="$(git config --file "$path_abs" user.email)"
  ssh_cmd="$(git config --file "$path_abs" core.sshCommand)"
  if [[ -z "$email" ]]; then
    fail "profile $folder: no user.email in $path"
    continue
  fi
  key_file="$(sed -nE 's/.*-i +([^ ]+).*/\1/p' <<<"$ssh_cmd")"
  key_file="${key_file/#\~/$HOME}"
  if [[ -n "$key_file" && ! -f "$key_file" ]]; then
    fail "profile $folder: $email, SSH key $key_file not found"
  elif [[ -n "$key_file" ]]; then
    ok "profile $folder: $email, key $(basename "$key_file")"
  else
    ok "profile $folder: $email (default SSH keys)"
  fi
done < <(git config --global --get-regexp '^includeif\..*\.path$' 2>/dev/null)
((profile_count == 0)) && warn "no git profiles (includeIf) configured (run: bash tools/gitconfig.sh)"

# This repo should resolve its profile's email
repo_email="$(git -C "$DOTFILES" config user.email 2>/dev/null)"
if [[ -n "$repo_email" ]]; then
  ok "this repo commits as $repo_email"
else
  warn "this repo has no user.email (is $DOTFILES inside a profile folder?)"
fi

# --------------------------------------------------------------------------
section "Configs load"

# zsh: start an interactive shell, the same way a terminal does
zsh_err="$(zsh -ic 'printf "%s" "$DOTFILES"' 2>&1 >/dev/null)"
zsh_dotfiles="$(zsh -ic 'printf "%s" "$DOTFILES"' 2>/dev/null)"
if [[ "$zsh_dotfiles" == "$DOTFILES" ]]; then
  ok "zsh resolves DOTFILES=$zsh_dotfiles"
else
  fail "zsh DOTFILES='$zsh_dotfiles' (expected $DOTFILES)"
fi
if [[ -z "$zsh_err" ]]; then
  ok "zsh starts without errors"
else
  fail "zsh prints errors on startup: $(echo "$zsh_err" | head -n 1)"
fi

# nvim: load the config headless and report any startup error
if validate_command nvim; then
  nvim_err="$(timeout 60 nvim --headless "+lua if #vim.v.errmsg > 0 then io.stderr:write(vim.v.errmsg) end" +qa 2>&1)"
  if [[ $? -eq 0 && -z "$nvim_err" ]]; then
    ok "nvim loads its config headless"
  else
    fail "nvim startup: $(echo "$nvim_err" | head -n 1)"
  fi
fi

# tmux: parse the config in an isolated server
if validate_command tmux; then
  tmux_sock="doctor-$$"
  if tmux_err="$(tmux -L "$tmux_sock" -f "$HOME/.tmux.conf" new-session -d true 2>&1)"; then
    ok "tmux config parses"
  else
    fail "tmux config: $(echo "$tmux_err" | head -n 1)"
  fi
  tmux -L "$tmux_sock" kill-server >/dev/null 2>&1
  if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    ok "TPM installed"
  else
    fail "TPM missing ($HOME/.tmux/plugins/tpm)"
  fi
fi

if validate_command starship; then
  if starship_err="$(STARSHIP_CONFIG="$HOME/.config/starship.toml" starship prompt 2>&1 >/dev/null)" && [[ -z "$starship_err" ]]; then
    ok "starship config is valid"
  else
    fail "starship: $(echo "$starship_err" | head -n 1)"
  fi
fi

# --------------------------------------------------------------------------
section "Optional tools (only the ones installed via tools/optional)"

# Run one command inside an interactive zsh, so PATH comes from conf.d
in_zsh() { zsh -ic "$1" 2>/dev/null | tail -n 1; }

check_optional() {
  local fragment="$1" label="$2" cmd="$3"
  if [ ! -f "$ZSH_CONF_D/$fragment.zsh" ]; then
    skip "$label not installed (no conf.d/$fragment.zsh)"
    return
  fi
  local out
  out="$(in_zsh "$cmd")"
  if [[ -n "$out" ]]; then
    ok "$label: $out"
  else
    fail "$label: conf.d/$fragment.zsh exists but '$cmd' fails in zsh"
  fi
}

check_optional fnm       "fnm"       'fnm --version'
check_optional fnm       "node"      'node --version'
check_optional zz-sdkman "java"      'java -version 2>&1 | head -n 1'
check_optional zz-sdkman "maven"     'mvn -v 2>/dev/null | head -n 1'
check_optional bun       "bun"       'bun --version'
check_optional orbstack  "orbstack"  'docker context show'
check_optional go        "go"        'go version'
check_optional pyenv     "pyenv"     'pyenv --version'
check_optional tmuxifier "tmuxifier" 'tmuxifier --version'

# Docker has no zsh fragment: check it directly
if validate_command docker; then
  if docker info >/dev/null 2>&1; then
    ok "docker: daemon reachable without sudo"
  elif id -nG "$USER" | grep -qw docker || getent group docker | grep -qw "$USER"; then
    warn "docker: permission denied in this session (run: newgrp docker, or log out/in)"
  else
    fail "docker: cannot reach daemon (user not in docker group?)"
  fi
else
  skip "docker not installed"
fi

# --------------------------------------------------------------------------
section "Repo scripts"
syntax_errors=0
while IFS= read -r -d '' script; do
  if ! bash -n "$script" 2>/dev/null; then
    fail "syntax error: ${script#"$DOTFILES"/}"
    syntax_errors=$((syntax_errors + 1))
  fi
done < <(find "$DOTFILES/init.sh" "$DOTFILES/tools" -name '*.sh' -print0)
((syntax_errors == 0)) && ok "all .sh files pass bash -n"

if validate_command shellcheck; then
  if shellcheck -S error -x "$DOTFILES/init.sh" "$DOTFILES"/tools/*.sh "$DOTFILES"/tools/*/*.sh >/dev/null 2>&1; then
    ok "shellcheck: no errors"
  else
    warn "shellcheck reports errors (run: shellcheck -S error -x tools/**/*.sh)"
  fi
else
  skip "shellcheck not installed"
fi

# --------------------------------------------------------------------------
printf "\n%s passed, %s warnings, %s failed\n" "$PASS" "$WARN" "$FAIL"
((FAIL == 0))
