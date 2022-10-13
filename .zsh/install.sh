#!/bin/sh

# configure dotfiles bare repo
function config {
	/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME $@
}

# this script only works via apt or pacman, sorry
if command -v pacman >/dev/null; then
	pm="pacman -S"
elif command -v apt >/dev/null; then
	pm="apt install"
else
	echo get a real OS ffs && exit 1
fi

# checks if git is installed
if command -v git >/dev/null; then
	yes | sudo $pm git
fi

# checks if zsh is installed
if command -v zsh >/dev/null; then
	yes | sudo $pm zsh
fi

# clone dotfiles bare repo
git clone --bare git@github.com:araggohnxd/dotfiles.git $HOME/dotfiles/
config checkout
if [ $? != 0 ]; then # checkout may fail if there are pre-existing dotfiles
	echo "Backing up pre-existing dotfiles"
	mkdir -p .config-backup
	config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi
config checkout
echo "Checked out config"
config config status.showUntrackedFiles no

# checks if rust/cargo is installed
if command -v cargo >/dev/null; then
	curl https://sh.rustup.rs -sSf | sh
fi

# install rust utilitaries
cargo install cargo-update zoxide exa bat fd procs ytop

# done!
exec zsh
