default:
	@echo "Dotfiles CLI"
	@echo ""
	@echo "Usage:"
	@echo ""
	@echo "make setup	# First initialization"
	@echo "make link	# Link dotfiles"
	@echo "make pull	# Retrive latest dotfiles (pull from repository)"

setup: link

link:
	@echo "Linking dotfiles..."
	@echo $(shell pwd)
	ln --symbolic --logical --force $(shell pwd)/.zshrc ~/.zshrc
	ln --symbolic --logical --force $(shell pwd)/.gitconfig ~/.gitconfig

gitpull:
	@echo "Pulling updates..."
	git pull

pull: gitpull link

push:
	@echo "Pushing updates..."
	git add .
	git commit
	git push