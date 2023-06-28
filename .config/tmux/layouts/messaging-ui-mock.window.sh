window_root "~/workplace/work/disney/anet-messaging-ui/"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "messaging-ui"
run_cmd "nvim"
split_v 20
split_h 50
run_cmd "npm run start:mock"
select_pane 0
