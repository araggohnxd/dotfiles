# dotfiles

## Windows Setup

### Install Nerd Fonts

Nerd fonts are required because it contains some symbols and glyphs that will allow your terminal prompt to look nicer.

- Download this `.ttf` file:
	- [Caskaydia Cove Nerd Font Complete](https://raw.githubusercontent.com/araggohnxd/dotfiles/master/.fonts/Caskaydia%20Cove%20Nerd%20Font%20Complete.ttf)
- Right-click it and click *"Install"*.

### Enable Windows Subsystem for Linux

- Open `PowerShell` as *Administrator* and run:
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
- Reboot if prompted.

### Install Windows Terminal

- Also in your `PowerShell`, as *Administrator*, run:
```powershell
winget install Microsoft.WindowsTerminal
```

- Run *Start* > *Windows Terminal*
	- Press `Ctrl+,`;
	- Click on the bottom left corner to open JSON file;
	- Replace the contents of `settings.json` with [this](https://raw.githubusercontent.com/araggohnxd/dotfiles/master/.config/windows-terminal-settings.json).

### WSL Installation
- Visit [ArchWSL official repository](https://github.com/yuk7/ArchWSL/releases/latest) and get the latest `Arch.zip` file you can find in *Assets*.
- Unzip it in a directory you have write permissions. I personally recommend `C:\` disk root.
- Execute `Arch.exe`.
	- As a side note, the executable name is what is used as the WSL instance name. If you rename it, you can have multiple installs.
- Once the installation is done, you can either run `Arch.exe` again or execute it through Windows Terminal.

- You will be prompted as the root user. Set up it's password by running:
```sh
passwd
```

- Setup sudoers file:
```sh
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
```

- Create your user (replace any occurrences of *araggohnxd* with your username):
```sh
useradd -m -G wheel -s /bin/bash araggohnxd
```

- Setup your user's password:
```sh
passwd araggohnxd
```
- Then exit Arch by running `exit` or pressing `Ctrl+D`.

- Open `PowerShell` and go to the directory you placed the Arch executable, then run this command to set the user you just created as the default user:
```powershell
.\Arch.exe config --default-user araggohnxd
```

### Arch Setup
- Before using `pacman`, I personally like to set the amount of allowed parallel donwloads to 10:
```sh
sudo sed -i 's/ParallelDownloads = [0-9]*/ParallelDownloads = 10/g' /etc/pacman.conf
```

- Excute these commands to initialize the keyring. This step is necessary to use `pacman`.
```sh
sudo pacman-key --init
```

```sh
sudo pacman-key --populate
```

```sh
sudo pacman -Sy --noconfirm archlinux-keyring
```

```sh
sudo pacman -Su --noconfirm
```

- Once all packages are updated, install `curl` to make it possible to run the bootstrap script:
```sh
sudo pacman -S --noconfirm curl
```

## You're all set!
- Now, just run the bootstrap script:
```sh
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/araggohnxd/dotfiles/master/.zsh/bin/bootstrap.sh')"
```
- During the script execution, you will be presented with some confirmation prompts and password prompts for `sudo`, so pay attention.

Everything in a oneliner:
```sh
sudo sed -i 's/ParallelDownloads = [0-9]*/ParallelDownloads = 10/g' /etc/pacman.conf && sudo pacman-key --init && sudo pacman-key --populate && sudo pacman -Sy --noconfirm archlinux-keyring && sudo pacman -Su --noconfirm && sudo pacman -S --noconfirm curl && bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/araggohnxd/dotfiles/master/.zsh/bin/bootstrap.sh')"
```

- When the script is done running, simply run the command below, so `zsh4humans` can properly source everything up.
```sh
exec zsh
```
- This step will also give you some prompts, but once it's done, you can enjoy your fully working environment!
