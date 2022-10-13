#!/bin/sh

function config {
	/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME $@
}

git clone --bare git@github.com:araggohnxd/dotfiles.git $HOME/dotfiles/
config checkout
if [ $? = 0 ]; then
	echo "Checked out config"
else
	echo "Backing up pre-existing dot files"
	mkdir -p .config-backup
	config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi
config checkout
config config status.showUntrackedFiles no
curl https://sh.rustup.rs -sSf | sh
cargo install cargo-update zoxide exa bat fd procs ytop
if command -v pacman >/dev/null; then
	yes | sudo pacman -S zsh
elif command -v apt >/dev/null; then
	yes | sudo apt isntall zsh
else
	echo get a real OS ffs && exit 1
fi
exec zsh
