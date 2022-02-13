default:
	@echo "Dotfiles CLI"
	@echo ""
	@echo "Usage:"
	@echo ""
	@echo "make setup	# First initialization"
	@echo "make link	# Link dotfiles"
	@echo "make pull	# Retrive latest dotfiles (pull from repository)"
	@echo "make push	# Persist local changes (push to repository)"

setup: link

create_folders:
	@echo "Create missed folders..."
	mkdir -p ~/.config
	mkdir -p ~/.config/nvim
	mkdir -p ~/Sandbox
	mkdir -p ~/Projects

link: create_folders
	@echo "Linking dotfiles..."
	@echo $(shell pwd)
	ln -sf $(shell pwd)/.zshrc ~/.zshrc
	ln -sf $(shell pwd)/.gitconfig ~/.gitconfig
	ln -sf $(shell pwd)/init.vim ~/.config/nvim/init.vim
	ln -sf $(shell pwd)/starship.toml ~/.config/starship.toml

gitpull:
	@echo "Pulling updates..."
	git pull

pull: gitpull link

push:
	@echo "Pushing updates..."
	git add .
	git commit
	git push
