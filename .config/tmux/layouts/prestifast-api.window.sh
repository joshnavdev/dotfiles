# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/workplace/projects/prestifast/prestifast-api"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "prestifast-api"
run_cmd "nvm use 18"
run_cmd "nvim"
split_v 20
run_cmd "nvm use 18"
run_cmd "yarn run start:dev"
# run_cmd "json-server --watch --port 8080 --delay 1000 db.json"
