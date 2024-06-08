# Add zoxide support
eval "$(zoxide init zsh)"

# Add fancy zsh prompt
eval "$(starship init zsh)"

# FZF Gruvbox dark medium
# https://github.com/tinted-theming/tinted-fzf/blob/main/bash/base16-gruvbox-dark-medium.config
_gen_fzf_default_opts() {
	local color00='#282828'
	local color01='#3c3836'
	local color02='#504945'
	local color03='#665c54'
	local color04='#bdae93'
	local color05='#d5c4a1'
	local color06='#ebdbb2'
	local color07='#fbf1c7'
	local color08='#fb4934'
	local color09='#fe8019'
	local color0A='#fabd2f'
	local color0B='#b8bb26'
	local color0C='#8ec07c'
	local color0D='#83a598'
	local color0E='#d3869b'
	local color0F='#d65d0e'

	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS""\
 --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D""\
 --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C""\
 --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

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
alias cat='bat -pp --theme=gruvbox-dark'
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
prettyjson() {
	cat | jq -Rr '. as $line | fromjson? // $line'
}

# Get my global ip
alias wanip="curl http://ipecho.net/plain; echo"

# check internet access
alias internet_healthcheck="ping 1.1.1.1"

# Upgrade Linux or MacOS
alias upgrade_system='brew update && brew upgrade --no-quarantine --greedy'

# Make port free
killport() {
	lsof -ti:"$1" | xargs kill -9
}

colortest() {
	# https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html

	T='gYw' # The test text

	echo -e "\n                 40m     41m     42m     43m\
         44m     45m     46m     47m"

	for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
		'1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
		'  36m' '1;36m' '  37m' '1;37m'; do
		FG=${FGs// /}
		echo -en " $FGs \033[$FG  $T  "
		for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
			echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m"
		done
		echo
	done
	echo
}

# Extract a variety of file formats
# https://github.com/xvoland/Extract/blob/a33ed16761c8e7a56cc0a637bff19ce13a9a8887/extract.sh#L24-L67
function extract {
	if [ $# -eq 0 ]; then
		# display usage if no parameters given
		echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso|.zst>"
		echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
	fi
	for n in "$@"; do
		if [ ! -f "$n" ]; then
			echo "'$n' - file doesn't exist"
			return 1
		fi

		case "${n%,}" in
		*.cbt | *.tar.bz2 | *.tar.gz | *.tar.xz | *.tbz2 | *.tgz | *.txz | *.tar)
			tar zxvf "$n"
			;;
		*.lzma) unlzma ./"$n" ;;
		*.bz2) bunzip2 ./"$n" ;;
		*.cbr | *.rar) unrar x -ad ./"$n" ;;
		*.gz) gunzip ./"$n" ;;
		*.cbz | *.epub | *.zip) unzip ./"$n" ;;
		*.z) uncompress ./"$n" ;;
		*.7z | *.apk | *.arj | *.cab | *.cb7 | *.chm | *.deb | *.iso | *.lzh | *.msi | *.pkg | *.rpm | *.udf | *.wim | *.xar | *.vhd)
			7z x ./"$n"
			;;
		*.xz) unxz ./"$n" ;;
		*.exe) cabextract ./"$n" ;;
		*.cpio) cpio -id <./"$n" ;;
		*.cba | *.ace) unace x ./"$n" ;;
		*.zpaq) zpaq x ./"$n" ;;
		*.arc) arc e ./"$n" ;;
		*.cso) ciso 0 ./"$n" ./"$n.iso" &&
			extract "$n.iso" && \rm -f "$n" ;;
		*.zlib) zlib-flate -uncompress <./"$n" >./"$n.tmp" &&
			mv ./"$n.tmp" ./"${n%.*zlib}" && rm -f "$n" ;;
		*.dmg)
			hdiutil mount ./"$n" -mountpoint "./$n.mounted"
			;;
		*.tar.zst) tar -I zstd -xvf ./"$n" ;;
		*.zst) zstd -d ./"$n" ;;
		*)
			echo "extract: '$n' - unknown archive method"
			return 1
			;;
		esac
	done
}

# Setup default editor
export EDITOR="nvim"

# Adblock for npm
export DISABLE_OPENCOLLECTIVE=1
export OPEN_SOURCE_CONTRIBUTOR=1
export ADBLOCK=1

# Enforce English as primary lang
export LC_ALL=en_US.UTF-8

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/Users/vlad/.bun/_bun" ] && source "/Users/vlad/.bun/_bun"

# pnpm
export PNPM_HOME="/Users/vlad/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# vim: ts=4 sts=4 sw=4 et
