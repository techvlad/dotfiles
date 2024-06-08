#!/usr/bin/env bash
set -euo pipefail

YELLOW='\033[0;33m'
NC='\033[0m'

# TODO: Check for brew else install

taps=(
	"homebrew/cask-fonts"
	"apple/apple"
)

formulaes=(
	"bat"
	"cmatrix"
	"duf"
	"dust"
	"exa"
	"fd"
	"ffmpeg"
	"fzf"
	"gh"
	"git"
	"go"
	"hadolint"
	"htop"
	"jq"
	"lazydocker"
	"lazygit"
	"mas"
	"fastfetch"
	"neovim"
	"ripgrep"
)

casks=(
	"alt-tab"
	"arc"
	"cyberduck"
	"discord"
	"firefox"
	"font-cozette"
	"font-iosevka"
	"font-iosevka-nerd-font"
	"font-iosevka-term-nerd-font"
	"font-jetbrains-mono-nerd-font"
	"google-chrome"
	"hot"
	"iina"
	"imazing"
	"iterm2"
	"keka"
	"mac-mouse-fix"
	"microsoft-remote-desktop"
	"obs"
	"obsidian"
	"orbstack"
	"orion"
	"postman"
	"qbittorrent"
	"raspberry-pi-imager"
	"raycast"
	"shottr"
	"spotify"
	"steam"
	"tailscale"
	"teamviewer"
	"telegram"
	"visual-studio-code"
	"whisky"
	"wireshark"
	"zed"
	"zoom"
)

apps=(
	1352778147 # Bitwarden
	1464122853 # NextDNS
	937984704  # Amphetamine
)

tap_installed=$(brew tap)

for tap in "${taps[@]}"; do
	if [[ $tap_installed == *"$tap"* ]]; then
		echo -e "Brew tap $YELLOW$tap$NC already activated, skipping.."
	else
		echo -e "Activating brew tap $YELLOW${tap}$NC..."
		brew tap "$tap"
	fi
done

echo -e "Update brew index"
brew update

brew_installed=$(brew list -1)

for formulae in "${formulaes[@]}"; do
	if [[ $brew_installed == *"$formulae"* ]]; then
		echo -e "Formulae $YELLOW$formulae$NC already installed, skipping.."
	else
		echo -e "Installing formulae $YELLOW${formulae}$NC..."
		brew install "$formulae"
	fi
done

for cask in "${casks[@]}"; do
	if [[ $brew_installed == *"$cask"* ]]; then
		echo -e "Cask $YELLOW$cask$NC already installed, skipping.."
	else
		echo -e "Installing cask $YELLOW${cask}$NC..."
		brew install "$cask"
	fi
done

echo -e "Update all formulaes/casks..."
brew upgrade --no-quarantine --greedy

mas_installed=$(mas list | cut -d ' ' -f 1)

for app in "${apps[@]}"; do
	if [[ $mas_installed == *"$app"* ]]; then
		echo -e "App $YELLOW$app$NC already installed, skipping.."
	else
		echo -e "Installing $YELLOW${app}$NC from App Store..."
		mas install "$cask"
	fi
done

# TODO:
# add dotfiles linking
# add nvim first init
# nvim --headless "+Lazy! sync" +qa

# vim: ts=4 sts=4 sw=4 et
