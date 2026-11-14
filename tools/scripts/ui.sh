#!/usr/bin/env bash
# Output helpers: step banners, spinner for long commands, result summary.
#
#   step "NeoVim" "release-0.11"      big numbered header  ([4/9] NeoVim · release-0.11)
#   run  "Compiling NeoVim" make ...   hides output in $DOTFILES_LOG and shows a spinner
#   print_summary                      what was installed / skipped / failed
#
# VERBOSE=1 (bash init.sh --verbose) shows the real command output instead of the spinner.

DOTFILES_LOG="${DOTFILES_LOG:-$HOME/.dotfiles-install.log}"
VERBOSE="${VERBOSE:-0}"
STEP_TOTAL="${STEP_TOTAL:-0}"
STEP_CURRENT=0
RESULTS_OK=(); RESULTS_SKIP=(); RESULTS_FAIL=()
_RUN_PID=""

if [[ -t 1 ]]; then
  C_BOLD=$'\e[1m'; C_BLUE=$'\e[34m'; C_CYAN=$'\e[36m'
else
  C_BOLD=""; C_BLUE=""; C_CYAN=""
fi

# Ctrl-C: stop the background command and give the cursor back
trap '[[ -n "$_RUN_PID" ]] && kill "$_RUN_PID" 2>/dev/null; tput cnorm 2>/dev/null; printf "\n"; exit 130' INT

function _rule() {
  local width
  width="$(tput cols 2>/dev/null || echo 60)"
  ((width > 60)) && width=60
  printf '%s' "$C_BLUE"
  printf '━%.0s' $(seq 1 "$width")
  printf '%s\n' "$C_RESET"
}

function _duration() {
  local s="$1"
  if ((s >= 60)); then echo "$((s / 60))m $((s % 60))s"; else echo "${s}s"; fi
}

function log_line() {
  printf '%s\n' "$@" >>"$DOTFILES_LOG"
}

# banner "Title" ["subtitle"]: header without counter
function banner() {
  echo ""
  _rule
  printf ' %s%s%s%s\n' "$C_BOLD" "$1" "${2:+  ·  $2}" "$C_RESET"
  _rule
  log_line "" "===== $1${2:+ · $2} ====="
}

# step "Title" ["subtitle"]: numbered header [n/total]
function step() {
  STEP_CURRENT=$((STEP_CURRENT + 1))
  local counter=""
  ((STEP_TOTAL > 0)) && counter="[$STEP_CURRENT/$STEP_TOTAL]  "
  banner "$counter$1" "${2:-}"
}

function record_result() {
  case "$1" in
    ok)   RESULTS_OK+=("$2") ;;
    skip) RESULTS_SKIP+=("$2") ;;
    fail) RESULTS_FAIL+=("$2") ;;
  esac
}

function _spin() {
  local pid="$1" label="$2" start="$3" i=0
  local frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
  while kill -0 "$pid" 2>/dev/null; do
    printf '\r  %s%s%s %s %s(%s)%s\e[K' "$C_CYAN" "${frames[i % 10]}" "$C_RESET" "$label" \
      "$C_DIM" "$(_duration $((SECONDS - start)))" "$C_RESET"
    i=$((i + 1))
    sleep 0.1
  done
  printf '\r\e[K'
}

# run "Label" command [args...]
# Non-interactive commands only: stdin is /dev/null so nothing can block on a prompt.
function run() {
  local label="$1" start=$SECONDS status
  shift
  log_line "" "### $label" "\$ $*"
  local log_start
  log_start="$(wc -l <"$DOTFILES_LOG" 2>/dev/null || echo 0)"

  if [[ "$VERBOSE" == "1" ]]; then
    echo "  ${C_CYAN}▶${C_RESET} $label"
    "$@" </dev/null 2>&1 | tee -a "$DOTFILES_LOG"
    status=${PIPESTATUS[0]}
  elif [[ -t 1 ]]; then
    "$@" </dev/null >>"$DOTFILES_LOG" 2>&1 &
    _RUN_PID=$!
    tput civis 2>/dev/null
    _spin "$_RUN_PID" "$label" "$start"
    wait "$_RUN_PID"
    status=$?
    _RUN_PID=""
    tput cnorm 2>/dev/null
  else
    "$@" </dev/null >>"$DOTFILES_LOG" 2>&1
    status=$?
  fi

  local took
  took="$(_duration $((SECONDS - start)))"
  if ((status == 0)); then
    echo "  ${C_GREEN}✔${C_RESET} $label ${C_DIM}($took)${C_RESET}"
    record_result ok "$label"
  else
    echo "  ${C_RED}✘ $label${C_RESET} ${C_DIM}(exit $status, $took)${C_RESET}"
    if [[ "$VERBOSE" != "1" ]]; then
      echo "  ${C_DIM}── last lines of the log ──${C_RESET}"
      tail -n +"$((log_start + 1))" "$DOTFILES_LOG" | tail -n 15 | sed 's/^/    /'
    fi
    echo "  ${C_DIM}full log: $DOTFILES_LOG${C_RESET}"
    record_result fail "$label"
    log_line "### FAILED: $label (exit $status)"
  fi
  return "$status"
}

function print_summary() {
  banner "Summary"
  local item
  if ((${#RESULTS_OK[@]})); then
    echo "  ${C_GREEN}${C_BOLD}Installed / configured (${#RESULTS_OK[@]})${C_RESET}"
    for item in "${RESULTS_OK[@]}"; do echo "    ${C_GREEN}✔${C_RESET} $item"; done
  fi
  if ((${#RESULTS_SKIP[@]})); then
    echo "  ${C_DIM}${C_BOLD}Already there, skipped (${#RESULTS_SKIP[@]})${C_RESET}"
    for item in "${RESULTS_SKIP[@]}"; do echo "    ${C_DIM}- $item${C_RESET}"; done
  fi
  if ((${#RESULTS_FAIL[@]})); then
    echo "  ${C_RED}${C_BOLD}Failed (${#RESULTS_FAIL[@]})${C_RESET}"
    for item in "${RESULTS_FAIL[@]}"; do echo "    ${C_RED}✘${C_RESET} $item"; done
  fi
  echo ""
  echo "  Log: $DOTFILES_LOG"
}
