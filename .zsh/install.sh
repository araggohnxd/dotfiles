#!/bin/sh

GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# make it possible to backup dotfiles inside directories other than $HOME
function mvmk () {
	dir="$2" # include a '/' at the end to indicate directory (not filename)
	tmp="$2"
	tmp="${tmp: -1}"
	[[ "$tmp" != "/" ]] && dir="$(dirname "$2")"
	[[ -a "$dir" ]] || mkdir -p "$dir" && mv "$@"
}
export -f mvmk

# show user what is being installed
function now_installing() {
	printf "${YELLOW}Now installing ${GREEN}$@${YELLOW}...${RESET}\n"
}

# configure dotfiles bare repo
function config() {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# this script only works via apt or pacman, sorry
if command -v pacman >/dev/null; then
	pm="pacman -S"
	printf "${YELLOW}Your package manager is ${GREEN}pacman${YELLOW}!${RESET}\n"
elif command -v apt >/dev/null; then
	pm="apt install"
	printf "${YELLOW}Your package manager is ${GREEN}apt${YELLOW}!${RESET}\n"
else
	printf "${YELLOW}get a real OS ffs${RESET}\n" && exit 1
fi

# checks if git is installed
if ! command -v git >/dev/null; then
	now_installing git
	yes | sudo $pm git
fi

# checks if zsh is installed
if ! command -v zsh >/dev/null; then
	now_installing zsh
	yes | sudo $pm zsh
fi

# checks if gcc is installed
if ! command -v gcc >/dev/null; then
	now_installing gcc
	yes | sudo $pm gcc
fi

# clone dotfiles bare repo
git clone --bare https://github.com/araggohnxd/dotfiles.git $HOME/.dotfiles/
config checkout
if [ $? != 0 ]; then # checkout may fail if there are pre-existing dotfiles
	printf "${YELLOW}Backing up pre-existing dotfiles...${RESET}\n"
	mkdir -p .dotfiles-backup
	config checkout 2>&1 | grep -P "\t" | awk {'print $1'} | xargs -I{} bash -c 'mvmk "$@"' _ {} .dotfiles-backup/{}
fi
config checkout
printf "${YELLOW}Checked out config!${RESET}\n"
config config status.showUntrackedFiles no
chmod 700 $HOME/.ssh/s

# checks if rust/cargo is installed
if ! command -v cargo >/dev/null; then
	now_installing cargo
	curl https://sh.rustup.rs -sSf | sh
	config reset --hard
fi
source "$HOME/.cargo/env"

# install rust utilitaries
cargo install cargo-update zoxide exa bat procs ytop

printf "\n\n${YELLOW}Now run '${GREEN}exec zsh${YELLOW}' to finish the setup!${RESET}\n\n"
