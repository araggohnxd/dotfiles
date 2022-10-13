#!/bin/sh

YELLOW="\033[33m"
GREEN="\033[32m"
RESET="\033[0m"

# configure dotfiles bare repo
function config {
	/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME $@
}

# this script only works via apt or pacman, sorry
if command -v pacman >/dev/null; then
	pm="pacman -S"
	printf "$YELLOW Your package manager is$GREEN pacman$YELLOW!$RESET\n"
elif command -v apt >/dev/null; then
	pm="apt install"
	printf "$YELLOW Your package manager is$GREEN apt$YELLOW!$RESET\n"
else
	printf "$YELLOW get a real OS ffs $RESET" && exit 1
fi

# checks if git is installed
if ! command -v git >/dev/null; then
	printf "$YELLOW Now installing$GREEN git$YELLOW...$RESET\n"
	yes | sudo $pm git
fi

# checks if zsh is installed
if ! command -v zsh >/dev/null; then
	printf "$YELLOW Now installing$GREEN zsh$YELLOW...$RESET\n"
	yes | sudo $pm zsh
fi

# checks if gcc is installed
if ! command -v gcc >/dev/null; then
	printf "$YELLOW Now installing$GREEN gcc$YELLOW...$RESET\n"
	yes | sudo $pm gcc
fi

# clone dotfiles bare repo
git clone --bare git@github.com:araggohnxd/dotfiles.git $HOME/dotfiles/
config checkout
if [ $? != 0 ]; then # checkout may fail if there are pre-existing dotfiles
	printf "$YELLOW Backing up pre-existing dotfiles... $RESET\n"
	mkdir -p .config-backup
	config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi
config checkout
printf "$YELLOW Checked out config!$RESET\n"
config config status.showUntrackedFiles no

# checks if rust/cargo is installed
if ! command -v cargo >/dev/null; then
	curl https://sh.rustup.rs -sSf | sh
	config reset --hard
fi
source "$HOME/.cargo/env"

# install rust utilitaries
cargo install cargo-update zoxide exa bat procs ytop

printf "\n\n$YELLOW Now run$GREEN exec zsh$YELLOW to finish the setup!$RESET\n\n"
