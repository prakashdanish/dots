#           _
#   _______| |__  _ __ ___ 
#  |_  / __| '_ \| '__/ __|
#   / /\__ \ | | | | | (__ 
#  /___|___/_| |_|_|  \___
# 




# functions
# ---------

# serve current directory using python HTTP server
function servedir() {
    # TODO: add handling for python3 and python
    ip_addr=$(ifconfig | grep 'broadcast' | awk '{print $2}')
    echo "Serving at: https://$ip_addr:8000"
    python3 -m http.server 8000
}

# show battery percentage and charging state
# source: https://askubuntu.com/questions/69556/how-to-check-battery-status-using-terminal
function battery() { 
    level=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep 'percentage' | awk '{print $2}')
    charging=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep 'state' | awk '{print $2}')
    if [[ $charging == "charging" ]]; then
        echo "Battery level: +$level"
    else
        echo "Battery level: -$level"
    fi
}

function brightness () {
    current=$(xrandr --verbose | grep Brightness | awk '{print $2}')
    if [[ $1 == "-inc" ]]; then
        value=$((current + 0.2))
        xrandr --output eDP-1 --brightness $value
    elif [[ $1 == "-dec" ]]; then
        value=$((current - 0.2))
        xrandr --output eDP-1 --brightness $value
    fi
}

# open fzf window with dirs and cd into it
function quick_find () {
    dir=$(find ~ -not -path '*/\.*' -type d -maxdepth 1 | fzf --layout=reverse)
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
setopt MENU_COMPLETE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EMACS


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
bindkey '^a' vi-beginning-of-line
bindkey '^k' vi-kill-eol
bindkey '^H' backward-kill-word

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/danishprakash/.zshrc'





# source
# ------

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh





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
alias ll='ls -FGal'                              # adds trailing '/' for dirs and -G for colors
alias ez='nvim ~/.zshrc'	                   # open .zshrc for editing
alias sz='source ~/.zshrc'	                   # source .zshrc
alias tree='tree -I '.git''	                   # skip .git dir in trees
alias grep='grep --colour=auto'                # colored output in grep
alias vi='nvim'
alias venv='workon $(workon | fzf --layout=reverse)'

alias blog='bundle exec jekyll serve'	       # deploy blog to localhost

# brightness controls for datagrokr ubuntu
alias bl='sudo brightnessctl s 5%-'
alias bh='sudo brightnessctl s +5%'

autoload -Uz compinit
compinit





# exports
# -------

export PATH=/usr/local/bin:/usr/local/Cellar:/bin:/usr/sbin:/sbin:/usr/bin:/Library/TeX/Root/bin/x86_64-darwin/
export EDITOR="/usr/bin/nvim"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"





# virtualenvwrapper
# -----------------

# export WORKON_HOME=~/virtualenvs
# source /usr/local/bin/virtualenvwrapper.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh



# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/danish/datagrokr/sam-local/sam-app/hello_world/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/danish/datagrokr/sam-local/sam-app/hello_world/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/danish/datagrokr/sam-local/sam-app/hello_world/node_modules/tabtab/.completions/sls.zsh ]] && . /home/danish/datagrokr/sam-local/sam-app/hello_world/node_modules/tabtab/.completions/sls.zsh
