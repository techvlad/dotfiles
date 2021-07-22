default:
	@echo "Dotfiles CLI"
	@echo ""
	@echo "Usage:"
	@echo ""
	@echo "make setup	# First initialization"
	@echo "make link	# Link dotfiles"	

setup: link

link:
	@echo "Linking dotfiles..."
	@echo $(shell pwd)
	ln --symbolic --logical --force $(shell pwd)/.zshrc ~/.zshrc