# dotfiles

## Setup
First, you need to install `curl` and `ssh`.

Using `apt`, run:
```sh
sudo apt update -y && sudo apt upgrade -y && sudo apt -y install curl ssh
```

Using `pacman`, run:
```sh
pacman -Syyuu --noconfirm && pacman -S --noconfirm curl openssh
```

Now, copy your `ssh` keys in order to be able to access this repository in the desired machine:
```sh
mkdir -p ~/.ssh
```
```sh
echo "<public-key>" > ~/.ssh/id_rsa.pub
```
```sh
echo "<private-key>" > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
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
