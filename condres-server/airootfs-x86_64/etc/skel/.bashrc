#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
EDITOR=nano
FREETYPE_PROPERTIES="truetype:interpreter-version=35"
exec zsh
#export QT_LOGGING_RULES="*=false"
