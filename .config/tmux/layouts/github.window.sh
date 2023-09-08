# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/workplace/projects/github-landing/"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "github"
run_cmd "nvm use 18"
run_cmd "nvim"

split_v 30
run_cmd "nvm use 18"
run_cmd "yarn dev --port 3000"

split_h 50
select_pane 0

# Split window into panes.

#split_v 20
#split_h 50

# Run commands.
#run_cmd "top"     # runs in active pane
#run_cmd "date" 1  # runs in pane 1

# Paste text
#send_keys "top"    # paste into active pane
#send_keys "date" 1 # paste into pane 1

# Set active pane.
#select_pane 0
