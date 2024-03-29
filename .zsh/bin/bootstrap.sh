#!/bin/bash

GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# configuration function for dotfiles bare repo
function config()
{
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# make it possible to backup dotfiles inside directories other than $HOME
function mvmk()
{
	dir="$2" # include a '/' at the end to indicate directory (not filename)
	tmp="$2"
	tmp="${tmp: -1}"
	[[ "$tmp" != "/" ]] && dir="$(dirname "$2")"
	[[ -a "$dir" ]] || mkdir -p "$dir" && mv "$@"
}

export -f mvmk

set -uEo pipefail

umask o-w

rm -rf $HOME/.cache

sudo pacman -Syu --noconfirm
[[ -n $(pacman -Qtdq) ]] && pacman -Qtdq | sudo pacman --noconfirm -Rns -

sudo pacman -S --noconfirm git
sudo pacman -S --noconfirm zsh

# clone dotfiles bare repo and checkout to home dir
git clone --bare --quiet https://github.com/araggohnxd/dotfiles.git $HOME/.dotfiles/
config checkout &>/dev/null
if [[ $? != 0 ]]; then # checkout may fail if there are pre-existing dotfiles
	mkdir -p .dotfiles-backup
	config checkout 2>&1 | grep -P "\t" | awk {'print $1'} | xargs -I{} bash -c 'mvmk "$@"' _ {} .dotfiles-backup/{}
	config checkout
fi
config config status.showUntrackedFiles no

mkdir -m 700 -p $HOME/.ssh/s
[[ -f $HOME/.ssh/config ]] && chmod 600 $HOME/.ssh/config

[[ -n $(sudo --version 2>/dev/null) ]] && bash $HOME/.zsh/bin/setup.sh

printf "\n\n${YELLOW}Now run '${GREEN}exec zsh${YELLOW}' to finish the setup!${RESET}\n\n"
