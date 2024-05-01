# Set shell options
setopt GLOB_DOTS              # no special treatment for file names with a leading dot
setopt NO_AUTO_MENU           # require an extra TAB press to open the completion menu
setopt HIST_EXPIRE_DUPS_FIRST # trim duplicate commands first when history is full
setopt HIST_IGNORE_SPACE      # don't save to history if current command starts with a blankspace
setopt HIST_REDUCE_BLANKS     # trim trailing blankspaces when saving command to history
setopt SHARE_HISTORY          # import and append new commands to history file
setopt IGNORE_EOF             # do not exit on EOF

# Environment variables
export GPG_TTY=$TTY
export VISUAL="nano"
export EDITOR="nano"
export MANPAGER="sh -c 'col -bx | bat -plman'"
export MANROFFOPT="-c"
export YSU_HARDCORE=1

# if [[ "$(</proc/version)" == *[Mm]icrosoft* ]] 2>/dev/null; then # Set XLaunch variables if running in WSL
# 	export DISPLAY="`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0"
# 	export LIBGL_ALWAYS_INDIRECT=1
# fi

# zstyle ':z4h:' start-tmux no
# zstyle ':z4h:' start-tmux command tmux -u new -A -D -t z4h
zstyle ':z4h:' term-vresize top
zstyle ':z4h:' prompt-at-bottom yes
zstyle ':z4h:' term-shell-integration yes
zstyle ':z4h:ssh-agent:' start yes
zstyle ':z4h:ssh-agent:' extra-args -t 20h
zstyle ':z4h:fzf-complete' recurse-dirs yes

zstyle ':z4h:autosuggestions' forward-char 'partial-accept'
zstyle ':z4h:autosuggestions' end-of-line  'accept'

# Additional Git repositories
z4h install marlonrichert/zsh-autocomplete || return
z4h install MichaelAquilina/zsh-you-should-use || return
z4h install romkatv/windows-terminal-zsh-integration || return


# Anything that requires user interaction should be done above this line.
z4h init || return

# Additional sources (should be equivalent to additional repositories)
# z4h source marlonrichert/zsh-autocomplete/zsh-autocomplete.plugin.zsh
z4h source MichaelAquilina/zsh-you-should-use/you-should-use.plugin.zsh
z4h source romkatv/windows-terminal-zsh-integration/windows-terminal-zsh-integration.plugin.zsh
z4h source $HOME/.zsh/aliases
z4h source $HOME/.zsh/functions

eval "$(zoxide init zsh)" # init z
autoload -Uz zmv

# Key bindings
z4h bindkey z4h-backward-kill-word Ctrl+Backspace # delete whole word in command line
z4h bindkey z4h-cd-back Alt+Left                  # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right              # cd into the next directory
z4h bindkey z4h-cd-up Alt+Up                      # cd into the parent directory
z4h bindkey z4h-cd-down Alt+Down                  # open fzf
z4h bindkey z4h-eof Ctrl+D                        # EOF
z4h bindkey z4h-clear-screen-soft-bottom Ctrl+L   # clear terminal and scrollback history
# z4h bindkey z4h-clear-screen-hard-bottom Ctrl+L   # clear terminal and scrollback history

# Define named directories
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home # ~w <=> Windows home directory on WSL

# Set history file path
HISTFILE=$HOME/.zsh/.zsh_history

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
