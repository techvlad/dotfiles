eval "$(starship init zsh)"

# Modern replacement for unix utils
alias ls='exa'
alias ll='exa -l'
alias la='exa -la'
alias du='dust'
alias df='duf'
alias find='fd'
alias grep='rg'
alias cat='bat -pp --theme=base16'
alias vim='nvim'

# Shorthands
alias lzd='lazydocker'
alias lzg='lazygit'

# Easiest way to reload zsh config
alias reload_config='source ~/.zshrc'

# Pretty JSON
prettyjson () { cat | jq -Rr '. as $line | fromjson? // $line' }

# Get my global ip
alias myglobalip="curl http://ipecho.net/plain; echo"

# Make port free
killport () { lsof -ti:"$1" | xargs kill -9 }

# Upgrade Linux or MacOS
upgrade_system ()
{
	if [[ "$(uname)" == "Linux" ]]; then
		yay -Syu --nocleanmenu --nodiffmenu --noconfirm
	else
		brew update && brew upgrade --greed
	fi
}

# Alias for Dotfiles CLI
alias dotfiles='make -C ~/dotfiles'

