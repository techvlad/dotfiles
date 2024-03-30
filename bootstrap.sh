#!/usr/bin/env bash
set -euo pipefail

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
  "neofetch"
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
  "qmk-toolbox"
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

for tap in "${taps[@]}"; do
  echo "Activating tap ${tap}..." 
  (brew tap | grep "$tap") || brew tap $tap
done

echo "Update brew index"
brew update

for formulae in "${formulaes[@]}"; do
  echo "Installing formulae ${formulae}..." 
  brew list --formulae $formulae > /dev/null || brew install $formulae
done

for cask in "${casks[@]}"; do
  echo "Installing cask ${cask}..." 
  brew list --cask $cask > /dev/null || brew install --greedy --no-quarantine $formulae
done

echo "Update all formulaes/casks..."
brew upgrade --no-quarantine --greedy

for app in "${apps[@]}"; do
  echo "Installing ${app} from App Store..." 
  (mas list | grep $app) || mas install $app
done
