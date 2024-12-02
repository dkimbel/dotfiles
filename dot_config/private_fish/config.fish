fish_add_path /opt/homebrew/bin
fish_add_path /Users/dk/.cargo/bin

function add_newline_before_all_prompts_except_first --on-event fish_prompt
  # we don't even check the value; if this variable exists, its value is effectively 'true'
  if set -q already_prompted_this_session
    echo
  else
    set -g already_prompted_this_session "true"
  end
end

# disable printed 'greeting' on start
set -g fish_greeting

set -x HOMEBREW_NO_AUTO_UPDATE 1

starship init fish | source
