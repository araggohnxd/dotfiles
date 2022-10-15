#!/bin/bash

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
function install_it() {
	printf "${YELLOW}Now installing ${GREEN}$@${YELLOW}...${RESET}\n"
	if [[ $@ == "cargo" ]]; then
		curl https://sh.rustup.rs -sSf | sh
	else
		yes | sudo $pm $@ >/dev/null
	fi
}

# configure dotfiles bare repo
function config() {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# this script only works via apt or pacman, sorry
if [[ -x "$(command -v pacman)" ]]; then
	pm="pacman -S"
	printf "${YELLOW}Your package manager is ${GREEN}pacman${YELLOW}!${RESET}\n"
elif [[ -x "$(command -v apt)" ]]; then
	pm="apt install"
	printf "${YELLOW}Your package manager is ${GREEN}apt${YELLOW}!${RESET}\n"
else
	printf "${YELLOW}get a real OS ffs${RESET}\n" && exit 1
fi

# check if these commands are installed, and install them if not
[[ -x "$(command -v git)" ]] || install_it git
[[ -x "$(command -v zsh)" ]] || install_it zsh
[[ -x "$(command -v gcc)" ]] || install_it gcc

printf "${YELLOW}Cloning dotfiles bare repository...${RESET}\n"
# clone dotfiles bare repo and checkout to home dir
git clone --bare https://github.com/araggohnxd/dotfiles.git $HOME/.dotfiles/ >/dev/null
config checkout &>/dev/null
if [ $? != 0 ]; then # checkout may fail if there are pre-existing dotfiles
	printf "${YELLOW}Backing up pre-existing dotfiles...${RESET}\n"
	mkdir -p .dotfiles-backup
	config checkout 2>&1 | grep -P "\t" | awk {'print $1'} | xargs -I{} bash -c 'mvmk "$@"' _ {} .dotfiles-backup/{}
fi
config checkout >/dev/null && printf "${YELLOW}Checked out config!${RESET}\n"
config config status.showUntrackedFiles no

printf "${YELLOW}Setting ssh config permissions...${RESET}\n"
# set safe permissions for ssh files
[[ -d $HOME/.ssh/s ]] && chmod 700 $HOME/.ssh/s
[[ -f $HOME/.ssh/config ]] && chmod 600 $HOME/.ssh/config

# checks if rust/cargo is installed, and install it if not
[[ -x "$(command -v cargo)" ]] || install_it cargo
config reset --hard &>/dev/null # reset any configs cargo installer may have done

# source cargo env if created
[[ -f $HOME/.cargo/env ]] && . $HOME/.cargo/env

# install rust utilities
printf "${YELLOW}Now installing ${GREEN}rust${YELLOW} utilities with ${GREEN}cargo${YELLOW}...${RESET}\n"
cargo install cargo-update zoxide exa bat procs ytop

printf "\n\n${YELLOW}Now run '${GREEN}exec zsh${YELLOW}' to finish the setup!${RESET}\n\n"
