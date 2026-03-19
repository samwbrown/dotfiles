# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
 
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
 
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
 
# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
 
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
 
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar
 
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
 
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
 
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
 
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes
 
if [ -n "$force_color_prompt" ]; then
    color_prompt=yes
fi
 
__prompt_command() {
    # Needs to be the first item in command
    local EXIT="$?"
 
    PS1=''
 
    # Show marker for python venv
    if [[ -n "$VIRTUAL_ENV" ]]; then
        PS1+="\033[31m (venv) \033[0m"
    fi
 
    # Add any set chroot
    PS1+='\[\033[01;32m\]\u@\h\[\033[00m\]:\w'
 
    # Show exit status
    if [ $EXIT != 0 ]; then
        PS1+=" \[\e[0;31m\]${EXIT}\[\e[0m\]"
    fi
 
    PS1+=' \n\$ '

    # Save command history immediately, not on exit
    history -a
}
if [ "$color_prompt" = yes ]; then
    PROMPT_COMMAND=__prompt_command
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
 
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
  
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
 
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
 
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
 

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

# Add local executables to path
PATH=$PATH:~/.local/bin

# ignore case when tab completing
bind -s 'set completion-ignore-case on'


# os specific stuff..
if [[ "OSTYPE" == "darwin"* ]]; then

    # Homebrew config
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # prefer coreutils find
    PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"

    # do not auto update homebrew every command
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    export HOMEBREW_NO_AUTO_UPDATE=1

    # Stop terminal from announcing zsh exists
    export BASH_SILENCE_DEPRECATION_WARNING=1


fi
