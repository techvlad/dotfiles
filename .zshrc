# Add zoxide support
eval "$(zoxide init zsh)"

# Add fancy zsh prompt
eval "$(starship init zsh)"

# FZF Tomorrow Night Bight
_gen_fzf_default_opts() {

local color00='#000000'
local color01='#282a2e'
local color02='#373b41'
local color03='#969896'
local color04='#b4b7b4'
local color05='#c5c8c6'
local color06='#e0e0e0'
local color07='#ffffff'
local color08='#cc6666'
local color09='#de935f'
local color0A='#f0c674'
local color0B='#b5bd68'
local color0C='#8abeb7'
local color0D='#81a2be'
local color0E='#b294bb'
local color0F='#a3685a'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

}

_gen_fzf_default_opts

# Modern replacement for unix utils
alias ls='exa'
alias ll='exa -l'
alias la='exa -la'
alias du='dust'
alias df='duf'
# alias find='fd'
# alias grep='rg'
alias cat='bat -pp --theme=base16'
alias vim='nvim'
alias v='nvim'

# Shorthands
alias lzd='lazydocker'
alias lzg='lazygit'
alias fpn="jq '.scripts | keys[]' -r package.json | fzf | xargs -t pnpm"
alias pn="pnpm"

# Easiest way to reload zsh config
alias reload_config='source ~/.zshrc'

# Pretty JSON
prettyjson () { cat | jq -Rr '. as $line | fromjson? // $line' }

# Get my global ip
alias wanip="curl http://ipecho.net/plain; echo"

# check internet access
alias internet_healthcheck="ping 1.1.1.1"

# Make port free
killport () { lsof -ti:"$1" | xargs kill -9 }

# Upgrade Linux or MacOS
upgrade_system ()
{
	if [[ "$(uname)" == "Linux" ]]; then
		yay -Syu --nocleanmenu --nodiffmenu --noconfirm
	else
		brew update && brew upgrade --no-quarantine --greedy
	fi
}

colortest() {
    # https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html

    T='gYw' # The test text

    echo -e "\n                 40m     41m     42m     43m\
         44m     45m     46m     47m";

    for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
               '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
               '  36m' '1;36m' '  37m' '1;37m';
    do 
        FG=${FGs// /}
        echo -en " $FGs \033[$FG  $T  "
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
        do 
            echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
        done
        echo;
    done
    echo
}

# Alias for Dotfiles CLI
alias dotfiles='make -C ~/dotfiles'

# pnpm
export PNPM_HOME="/Users/vlad/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/vlad/.bun/_bun" ] && source "/Users/vlad/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Adblock for npm
export DISABLE_OPENCOLLECTIVE=1
export OPEN_SOURCE_CONTRIBUTOR=1 
export ADBLOCK=1

# Enforce English as primary llang
export LC_ALL=en_US.UTF-8
