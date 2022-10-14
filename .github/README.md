# dotfiles

## Setup
First, you need to update your packages and install `curl`.

Using `apt`, run:
```sh
sudo apt update -y && sudo apt upgrade -y && sudo apt -y install curl
```

Using `pacman`, run:
```sh
sudo pacman -Syyuu --noconfirm && sudo pacman -S --noconfirm curl
```

## You're all set! Just run the install script:
```sh
curl -Lks https://raw.githubusercontent.com/araggohnxd/dotfiles/master/.zsh/install.sh | /bin/bash
```
Note that during the script execution, you will be prompted with some confirmation prompts, so pay attention.

When the script is done running, simply run the command below, so `zsh4humans` can properly source everything up.
```sh
exec zsh
```
Note that this will also give you some prompts, but once it's done, you can enjoy your fully working environment!
