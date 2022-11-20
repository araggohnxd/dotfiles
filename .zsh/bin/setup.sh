#!/bin/bash

set -xueEo pipefail

if [[ "$(</proc/version)" == *[Mm]icrosoft* ]] 2>/dev/null; then
	readonly WSL=1
else
	readonly WSL=0
fi

function install_packages() {
	local packages=(
		apt-transport-https
		binutils
		build-essential
		clang
		gcc
		cmake
		exa
		fd-find
		ffmpeg
		gdb
		gedit
		inetutils-tools
		gcc-multilib
		libbsd-dev
		libglpk-dev
		libncurses-dev
		libtool
		libxext-dev
		libxml2-utils
		lsof
		make
		man-db
		nano
		neofetch
		neovim
		npm
		ssh
		php
		python
		python3-pip
		ruby
		tmux
		tree
		unzip
		valgrind
		vim
		wget
		yarn
		zip
		x11-utils
		xorg
	)

	sudo apt-get update
	sudo bash -c 'DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::options::=--force-confdef -o DPkg::options::=--force-confold upgrade -y'
	sudo apt-get install -y "${packages[@]}"
	sudo apt-get autoremove -y
	sudo apt-get autoclean
}

function install_bat() {
	! command -v batcat &>/dev/null || ! command -v bat &>/dev/null || return 0
	sudo apt install bat -y
	! command -v bat &>/dev/null || return 0
	sudo ln -s /usr/bin/batcat /usr/local/bin/bat
}

function install_zoxide() {
	! command -v zoxide &>/dev/null || return 0
	curl -sS https://webinstall.dev/zoxide | bash
}

function install_bottom() {
	local v="0.6.8"
	! command -v bottom &>/dev/null || [[ "$(btm --version)" != "bottom $v" ]] || return 0
	local deb
	deb="$(mktemp)"
	curl -fsSL "https://github.com/ClementTsang/bottom/releases/download/${v}/bottom_${v}_amd64.deb" > "$deb"
	sudo dpkg -i "$deb"
	rm "$deb"
}

function install_procs() {
	local v="0.13.3"
	! command -v procs &>/dev/null || return 0
	local tmp
	tmp="$(mktemp -d)"
	pushd -- "$tmp"
	curl -fsSLO "https://github.com/dalance/procs/releases/download/v${v}/procs-v${v}-x86_64-linux.zip"
	unzip -- "procs-v${v}-x86_64-linux.zip"
	chmod +x procs
	mv procs ~/.local/bin
	popd
	rm -rf -- "$tmp"
}

function install_rust() {
	! command -v rustc &>/dev/null || return 0
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function install_ytdlp() {
	! command -v yt-dlp &>/dev/null || return 0
	python3 -m pip install -U yt-dlp
}

function install_norminette() {
	! command -v norminette &>/dev/null || return 0
	python3 -m pip install --upgrade pip setuptools
	python3 -m pip install norminette
}

function install_vscode() {
	(( !WSL )) || return 0
	! command -v code &>/dev/null || return 0
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	sudo apt-get update
	sudo apt-get install -y code
}

function add_to_sudoers() {
	# this is to be able to create /etc/sudoers.d/"$USER"
	[[ -n $(grep sudo /etc/group) ]] || return 0
	if [[ "$USER" == *'~' || "$USER" == *.* ]]; then
		>&2 echo "$BASH_SOURCE: invalid username: $USER"
		exit 1
	fi

	sudo usermod -aG sudo "$USER"
	sudo tee /etc/sudoers.d/"$USER" <<<"$USER ALL=(ALL) NOPASSWD:ALL" >/dev/null
	sudo chmod 440 /etc/sudoers.d/"$USER"
}

umask g-w,o-w

add_to_sudoers

install_packages
install_rust
install_bat
install_zoxide
install_bottom
install_procs
install_norminette
install_ytdlp
install_vscode

echo DONE
