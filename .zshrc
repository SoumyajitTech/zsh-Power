# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# neofetch

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#set history size
export HISTSIZE=10000
#save history after logout
export SAVEHIST=10000
#history file
export HISTFILE=$HOME/.local/share/zsh/history
#append into history file
setopt INC_APPEND_HISTORY
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY

# Edit line in vim buffer ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line

# Adds `~/.local/bin` to $PATH
export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')"

# Default programs:
export EDITOR="nvim"
export TERMINAL="termite"
export BROWSER="qutebrowser"
export READER="zathura"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Load zsh-syntax-highlighting
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
# Suggest aliases for commands
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh 2>/dev/null
# Search repos for programs that can't be found
source /usr/share/doc/pkgfile/command-not-found.zsh 2>/dev/null
# Theme
source ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme
# Auto-autosuggestions
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null
# Auto-completion
source ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
zstyle ':autocomplete:tab:*' widget-style menu-select
# Color
source ~/.config/zsh/zsh-colored-man-pages/colored-man-pages.plugin.zsh
source ~/.config/zsh/colorize/colorize.plugin.zsh

# Uncomment the following line if you want to change the command execution time
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Use lf to switch directories and bind it to ctrl-o
# lfcd () {
    # tmp="$(mktemp)"
    # lf -last-dir-path="$tmp" "$@"
    # if [ -f "$tmp" ]; then
        # dir="$(cat "$tmp")"
        # rm -f "$tmp"
        # [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    # fi
# }
# bindkey -s '^o' 'lfcd\n'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne '\e[5 q' # Use beam shape cursor on startup.
precmd() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### ALIASES ###

# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias h="cd ~"
alias c="clear"
alias r="ranger"
alias history="fc -l 1"
alias e="exit"
alias fonts="cd /usr/share/fonts"


# Changing "ls" to "exa"
alias ls='exa -a --color=automatic --icons --group-directories-first'  # my preferred listing
alias ll='exa -al --color=automatic --icons --group-directories-first' # long format
alias lt='exa -aT --color=automatic --group-directories-first' # tree listing

# broot
alias br='br -dp' # my preferred listing
alias bl='broot -dpw' #long Format
alias bs='br --sizes'

# adding flags
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias vi='nvim'
alias vim='sudo -E nvim'
# alias sc='sc-im'
alias sp='sudo pacman'

### SETS VI MODE ###
bindkey -v
export KEYTIMEOUT=1

source /home/argha/.config/broot/launcher/bash/br
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
