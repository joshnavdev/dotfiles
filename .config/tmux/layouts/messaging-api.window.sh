# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/workplace/work/disney/anet-messaging-api"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "messaging-api"
run_cmd "nvim"
split_v 30
run_cmd "mvn spring-boot:run"
split_h 50
run_cmd "open -a Docker"
run_cmd "aws-saml-auth"
run_cmd "docker start anet-mysql"
# select_pane 0
