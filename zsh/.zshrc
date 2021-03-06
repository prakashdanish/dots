#           _
#   _______| |__  _ __ ___ 
#  |_  / __| '_ \| '__/ __|
#   / /\__ \ | | | | | (__ 
#  /___|___/_| |_|_|  \___
# 




# functions
# ---------

# open fzf window with dirs and cd into it
# TODO: add ability to clear prompt before cd(ing)
function quick_find () {
    dir=$(find ~ ~/programming -not -path '*/\.*' -type d -maxdepth 1 | fzf --layout=reverse)
    cd $dir
    zle reset-prompt
}

zle -N quick_find_widget quick_find # define a widget for the func above
bindkey "^o" quick_find_widget     # remap ^i to the widget -> func

# function to start a timer in bg / pomodoro
alias pomo='doro'
function doro () {
    if [[ $# == 0 ]]; then
        let duration=1500           # no arguments -> 25 minutes
    else
        let duration=$(($1*60))
    fi
    sleep $duration
    (osascript -e 'tell application "System Events" to display dialog "Time for a water break!" buttons "OK" default button "OK"' && say "time up. STOP") &
}

# figuring out current branch while supressing `not git repo` errors
function git_branch () {
    branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
    if [[ $branch == "" ]];
    then
        :
    else
        echo ' ('$branch')'
    fi
}

# open man with `less` pager directly at a given switch
# e.g. mans ls -G -> will open man page for ls at -G option
function mans () {
    man -P "less -p \"^ +$2\"" $1
}

# start tmux on startup
# if [ "$TMUX" = "" ]; then tmux; fi





# options
# -------

setopt auto_cd               # auto cd when writing dir in the shell
setopt correctall            # correct typo(ed) commands
setopt prompt_subst          # allow command, param and arithmetic expansion in the prompt

# lines configured by zsh-newuser-install
export TERM=xterm-256color
HISTSIZE=1000
SAVEHIST=e000
HISTFILE=~/.histfile
PROMPT='%F{yellow}%3~%F{green}$(git_branch) %F{red}$ %F{reset}'





# keybindings
# -----------

bindkey '^p' up-line-or-search
bindkey '^n' down-line-or-search
bindkey '^i' complete-word
bindkey '^f' emacs-forward-word
bindkey '^b' emacs-backward-word

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/danishprakash/.zshrc'





# source
# ------

source ~/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh





# alias
# -----

# git
alias bra='git checkout $(git branch | fzf --layout=reverse) 2> /dev/null'
alias ga='sudo git add'
alias gm='sudo git commit'
alias ss='sudo git status'
alias gc='sudo git checkout'
alias gpu='git push origin'
alias gp='git pull origin'
alias gd='git diff'
alias gac='git add . && git commit'

# general
alias rm='rm -i'                               # ask for confirmation before rm
alias ls='ls -FG'                              # adds trailing '/' for dirs and -G for colors
alias ez='nvim ~/.zshrc'	                   # open .zshrc for editing
alias sz='source ~/.zshrc'	                   # source .zshrc
alias tree='tree -I '.git''	                   # skip .git dir in trees
alias grep='grep --colour=auto'                # colored output in grep
alias vi='nvim'
alias venv='workon $(workon | fzf --layout=reverse)'

alias blog='bundle exec jekyll serve'	       # deploy blog to localhost

autoload -Uz compinit
compinit





# exports
# -------

export PATH=/usr/local/bin:/usr/local/Cellar:/bin:/usr/sbin:/sbin:/usr/bin:/Library/TeX/Root/bin/x86_64-darwin/
export EDITOR="/usr/local/bin/nvim"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"





# virtualenvwrapper
# -----------------

export WORKON_HOME=~/virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

