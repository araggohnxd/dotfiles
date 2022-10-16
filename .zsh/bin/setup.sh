#!/bin/bash

set -xueE -o pipefail

if [[ "$(</proc/version)" == *[Mm]icrosoft* ]] 2>/dev/null; then
	readonly WSL=1
else
	readonly WSL=0
fi

function install_yay() {
	sudo pacman -Syu --noconfirm
	pacman -S --noconfirm --needed git base-devel
	git clone https://aur.archlinux.org/yay.git /tmp/yay
	cd /tmp/yay
	makepkg -si
	rm -rf /tmp/yay
}

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
		make
		fakeroot
		fd
		ffmpeg
		gdb
		gedit
		git
		glibc-debug
		inetutils
		lib32-glibc
		libbsd
		libtool
		lsof
		man-db
		man-pages
		nano
		neofetch
		neovim
		npm
		openssh
		php
		procs
		python
		python-pip
		ruby
		rust
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

	yay -Syu --noconfirm
	yay -S --noconfirm "${packages[@]}"
	[[ -n $(pacman -Qtdq) ]] && yay -Qtdq | yay -Rns -
	paccache -r
}

function install_vscode() {
	(( !WSL )) || return 0
	! command -v code &>/dev/null || return 0
	yay -S --no-confirm visual-studio-code-bin
}

function add_to_sudoers() {
	# This is to be able to create /etc/sudoers.d/"$username".
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

install_yay
install_packages
install_vscode

echo DONE
