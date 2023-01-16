##
#  My dotfiles
#
# @file
# @version 0.1


# Do not remove this block. It is used by the 'help' rule when
# constructing the help output.
# help:
# help: virtuallane Makefile help
# help:


# help: help                           - display this makefile's help information
.PHONY: help
help:
	@grep "^# help\:" Makefile | grep -v grep | sed 's/\# help\: //' | sed 's/\# help\://'


# help: bootstrap                          - first dotfiles setup
.PHONY: bootstrap
bootstrap:
	./scripts/bootstrap.sh


# help: venv                           - create a virtual environment for development
.PHONY: venv
venv:
	@rm -Rf venv
	@virtualenv venv --prompt "(my) "
	@/bin/bash -c "source venv/bin/activate && pip install pip --upgrade && pip install --upgrade --force-reinstall -r requirements.dev.txt && pip install -e ."
	@echo "Enter virtual environment using:\n\n\t$ source venv/bin/activate\n"


# help: stow                          - create symlink for my dotfiles
.PHONY: stow
stow:
	stow . -t ~/


# help: unstow                          - remove symlink for my dotfiles
.PHONY: unstow
unstow:
	stow -D . -t ~/


# help: init                          - init my dotfiles
.PHONY: install-my
install-my: venv
	rm -f ~/.local/bin/my; ln -s `pwd`/venv/bin/my ~/.local/bin
	rm -f ~/.local/bin/mysync; ln -s `pwd`/venv/bin/mysync ~/.local/bin

# end
