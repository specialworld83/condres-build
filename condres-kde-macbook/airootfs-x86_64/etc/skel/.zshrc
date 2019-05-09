source /usr/share/zsh/site-contrib/powerline.zsh
zstyle ':completion:*' menu select
# shell opts
setopt autocd
setopt completealiases
setopt histignorealldups
setopt histfindnodups
# alias
alias l='ls'
alias la='ls -A'
alias ll='ls -lA'
alias ls='ls --color=auto'
alias pac='sudo pacman --color auto'
##############################################################################
# History Configuration
##############################################################################
HISTSIZE=5000 #How many lines of history to keep in memory
HISTFILE=~/.zsh_history #Where to save history to disk
SAVEHIST=5000 #Number of history entries to save to disk
#HISTDUP=erase #Erase duplicates in the history file
setopt appendhistory #Append history to the history file (no overwriting)
setopt sharehistory #Share history across terminals
setopt incappendhistory #Immediately append to the history file, not just when a term is killed
FREETYPE_PROPERTIES="truetype:interpreter-version=35"
#export QT_LOGGING_RULES="*=false"

