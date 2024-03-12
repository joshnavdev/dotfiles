# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/workplace/projects/prestifast"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "prestifast"; then

  load_window "prestifast-ui"
  load_window "prestifast-api"
  select_window 0


fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
