#!/bin/bash

set -xueEo pipefail

if [[ "$(</proc/version)" == *[Mm]icrosoft* ]] 2>/dev/null; then
	readonly WSL=1
else
	readonly WSL=0
fi

function install_packages() {
	local packages=(
		bat
		base-devel
		binutils
		bottom
		clang
		gcc
		cmake
		exa
		fd
		ffmpeg
		gdb
		gedit
		git
		go
		inetutils
		lib32-glibc
		libbsd
		libtool
		lsof
		make
		man-db
		man-pages
		nano
		neofetch
		neovim
		npm
		openssh
		pacman-contrib
		php
		procs
		python
		python-pip
		ruby
		rust
		tmux
		tree
		unzip
		valgrind
		vim
		wget
		which
		xf86-video-vesa
		yarn
		yt-dlp
		zip
		zoxide
		zsh
	)

	sudo pacman -Syu --noconfirm
	if (( WSL )); then
		# uninstall fakeroot-tcp and delete fakeroot from ignored packages
		# to avoid conflicts with base-devel installation
		sudo sed -i '/fakeroot/d' /etc/pacman.conf
		sudo pacman -Rns --noconfirm fakeroot-tcp
	fi
	sudo pacman -S --noconfirm "${packages[@]}"
	[[ -n $(pacman -Qtdq) ]] && pacman -Qtdq | sudo pacman -Rns --noconfirm -
	paccache -r
}

function install_yay() {
	[[ -z $(yay --version 2>/dev/null) ]] || return 0
	git clone https://aur.archlinux.org/yay.git
	builtin cd yay
	makepkg -si --noconfirm
	builtin cd ../
	rm -rf yay
}

function install_norminette() {
	! command -v norminette &>/dev/null || return 0
	python3 -m pip install --upgrade pip setuptools
	python3 -m pip install norminette
}

function install_vscode() {
	(( !WSL )) || return 0
	! command -v code &>/dev/null || return 0
	yay -S --no-confirm visual-studio-code-bin
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
install_yay
install_norminette
install_vscode

echo DONE
