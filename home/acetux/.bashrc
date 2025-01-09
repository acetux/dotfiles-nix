# Might want to split these into multiple files in the future: (https://unix.stackexchange.com/a/44619)
export HISTSIZE=2000
export HISTFILESIZE= # Unlimited
export HISTFILE=~/.bash_history_unlimited # Change file name in case anything would truncate .bash_history
export HISTTIMEFORMAT="[%F %T] " # Print ISO 8601 datetime ahead of each history entry
shopt -s histappend # Makes sure the history is appended instead of replaced
PROMPT_COMMAND="history -a;" # Write history after every command so nothing gets lost and is in the correct order when using multiple terminal windows

