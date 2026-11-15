# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/workplace/projects/prestifast/prestifast-ui"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "prestifast-ui"
run_cmd "nvm use 18"
run_cmd "nvim"
split_v 20
run_cmd "nvm use 18"
run_cmd "bun run dev"
split_h 50
run_cmd "nvm use 18"
select_pane 0
