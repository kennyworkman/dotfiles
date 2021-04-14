# reverse-search
bindkey '^r' history-incremental-search-backward

# Vim Mode
bindkey -v

bindkey '^R' history-incremental-search-backward

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# Virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh

# 
# iTerm Integration
#

source ~/.iterm2_shell_integration.zsh

#
# Prompt
#

autoload -U colors
colors

export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '[%b%m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'
zstyle ':vcs_info:hg*:*' formats '[%m%b] '
zstyle ':vcs_info:hg*:*' actionformats '[%b|%a%m] '
zstyle ':vcs_info:hg*:*' branchformat '%b'
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-revision true
zstyle ':vcs_info:hg*:*' get-mq false
zstyle ':vcs_info:hg*+gen-hg-bookmark-string:*' hooks hg-bookmarks
zstyle ':vcs_info:hg*+set-message:*' hooks hg-message

function +vi-hg-bookmarks() {
  emulate -L zsh
  if [[ -n "${hook_com[hg-active-bookmark]}" ]]; then
    hook_com[hg-bookmark-string]="${(Mj:,:)@}"
    ret=1
  fi
}

function +vi-hg-message() {
  emulate -L zsh

  # Suppress hg branch display if we can display a bookmark instead.
  if [[ -n "${hook_com[misc]}" ]]; then
    hook_com[branch]=''
  fi
  return 0
}

function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{blue}●%f"
  fi
}

RPROMPT_BASE="\${vcs_info_msg_0_}%F{blue}%~%f"
setopt PROMPT_SUBST

# Anonymous function to avoid leaking NBSP variable.
function () {
  if [[ -n "$TMUX" ]]; then
    local LVL=$(($SHLVL - 1))
  else
    local LVL=$SHLVL
  fi
  if [[ $EUID -eq 0 ]]; then
    local SUFFIX=$(printf '#%.0s' {1..$LVL})
  else
    local SUFFIX=$(printf '\$%.0s' {1..$LVL})
  fi
  if [[ -n "$TMUX" ]]; then
    # Note use a non-breaking space at the end of the prompt because we can use it as
    # a find pattern to jump back in tmux.
    local NBSP=' '
    export PS1="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b%F{blue}%1~%F{yellow}%B%(1j.*.)%(?..!)%b%f%F{red}%B${SUFFIX}%b%f${NBSP}"
    export ZLE_RPROMPT_INDENT=0
  else
    # Don't bother with ZLE_RPROMPT_INDENT here, because it ends up eating the
    # space after PS1.
    export PS1="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b%F{blue}%1~%F{yellow}%B%(1j.*.)%(?..!)%b%f%F{red}%B${SUFFIX}%b%f "
  fi
}

export RPROMPT=$RPROMPT_BASE
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# Add number of inbox tasks in prompt as a constant reminder
export PS1='$(task +in +PENDING count) '$PS1

#
# Hooks
#

autoload -U add-zsh-hook

# Records start time just after a command has been read and is about to be executed (preexec hook)
typeset -F SECONDS
function record-start-time() {
  emulate -L zsh
  ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}

add-zsh-hook preexec record-start-time

# Reports start time. Executed right before prompt is displayed.
function report-start-time() {
  emulate -L zsh
  if [ $ZSH_START_TIME ]; then
    local DELTA=$(($SECONDS - $ZSH_START_TIME))
    local DAYS=$((~~($DELTA / 86400)))
    local HOURS=$((~~(($DELTA - $DAYS * 86400) / 3600)))
    local MINUTES=$((~~(($DELTA - $DAYS * 86400 - $HOURS * 3600) / 60)))
    local SECS=$(($DELTA - $DAYS * 86400 - $HOURS * 3600 - $MINUTES * 60))
    local ELAPSED=''
    test "$DAYS" != '0' && ELAPSED="${DAYS}d"
    test "$HOURS" != '0' && ELAPSED="${ELAPSED}${HOURS}h"
    test "$MINUTES" != '0' && ELAPSED="${ELAPSED}${MINUTES}m"
    if [ "$ELAPSED" = '' ]; then
      SECS="$(print -f "%.2f" $SECS)s"
    elif [ "$DAYS" != '0' ]; then
      SECS=''
    else
      SECS="$((~~$SECS))s"
    fi
    ELAPSED="${ELAPSED}${SECS}"
    local ITALIC_ON=$'\e[3m'
    local ITALIC_OFF=$'\e[23m'
    export RPROMPT="%F{cyan}%{$ITALIC_ON%}${ELAPSED}%{$ITALIC_OFF%}%f $RPROMPT_BASE"
    unset ZSH_START_TIME
  else
    export RPROMPT="$RPROMPT_BASE"
  fi
}

add-zsh-hook precmd report-start-time

# Version control information to prompt
add-zsh-hook precmd vcs_info

# Run ls automatically after cd, only if shell is a "toplevel" interactive process
function -auto-ls-after-cd() {
  emulate -L zsh
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then 
    ls
  fi
}

add-zsh-hook chpwd -auto-ls-after-cd

#
# PATH
# 
#

# brew python3.8
export PATH="/usr/local/opt/python@3.8/bin:$PATH"

# opt directory keeps latest version of software (so I can upgrade and not worry)
export PATH=/usr/local/opt/ruby/bin:$PATH

# IMPORTANT: update this path when I update ruby
# Because gems are in a separate directory, it can't be linked to the /opt/ 
export PATH=/usr/local/lib/ruby/gems/2.6.0/bin:$PATH
#
# Aliases
#

alias gm='tmux a -t morning'
alias mvi='mpv --config-dir=$HOME/.config/mvi'
alias pg="pgcli"
alias kc="kubectl"
alias d="docker"

alias e='exit'

# Quick source to reload config
alias reload='source ~/.zshrc'

# A quick list of human readable, hidden files (w/ color)
alias l="ls -lAhG"

# Super easy way to add something to my task inbox
alias in='task add +in'

# Add an item to my someday list
alias someday='task add +someday'

# "Tickle" an item so it shows up in my inbox later.
tickle () {
    deadline=$1
    shift
    in +tickle wait:$deadline $@
}
alias tick=tickle

# "Think" about an item so it shows in my inbox one day later.
alias think='tickle +1d'

#
## Theming
#

# Code alias
alias code="base16_tomorrow-night"

# Note alias
alias note="base16_tomorrow"

# Source local stuff
source ~/.zshrc.local
wd() {
  . /Users/kenny/bin/wd/wd.sh
}
export PATH="/usr/local/opt/awscli@1/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kenny/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kenny/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kenny/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kenny/google-cloud-sdk/completion.zsh.inc'; fi

alias dot='/usr/bin/git --git-dir=/Users/kenny/.cfg/ --work-tree=/Users/kenny'

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

[[ -s "/Users/kenny/.gvm/scripts/gvm" ]] && source "/Users/kenny/.gvm/scripts/gvm"
alias pyligand=make
