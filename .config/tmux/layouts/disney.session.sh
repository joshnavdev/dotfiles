# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/workplace/work/disney/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "disney"; then

  load_window "messaging-api"
  load_window "messaging-ui"
  select_window 0

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
