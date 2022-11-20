# dotfiles

## Windows Setup

### Install Nerd Fonts

Nerd fonts are required because it contains some symbols and glyphs that will allow your terminal prompt to look nicer.

- Download these `.ttf` files:
	- [Caskaydia Cove Nerd Font Complete](https://raw.githubusercontent.com/araggohnxd/dotfiles/master/.fonts/Caskaydia%20Cove%20Nerd%20Font%20Complete.ttf)
	- [Caskaydia Cove Nerd Font Complete Mono](https://raw.githubusercontent.com/araggohnxd/dotfiles/master/.fonts/Caskaydia%20Cove%20Nerd%20Font%20Complete%20Mono.ttf)
	- [Caskaydia Cove Nerd Font Complete Mono Windows Compatible](https://raw.githubusercontent.com/araggohnxd/dotfiles/master/.fonts/Caskaydia%20Cove%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf)
- Right-click on each file and click *"Install"*.

### Enable Windows Subsystem for Linux

- Open `PowerShell` as *Administrator* and run:
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
- Reboot if prompted.

### Install `chocolatey` package manager
- Also in your `PowerShell`, as *Administrator*, verify your current execution policy:
```powershell
Get-ExecutionPolicy
```

- If it returns *"Restricted"*, you need to escalate your execution privileges, by running:
```powershell
Set-ExecutionPolicy Bypass -Scope Process
```
- Check your execution policy again and ensure it was succesfully changed.

- Now, simply run this command to finally install `chocolatey`:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
### Install Windows Terminal and XLaunch

- Also in your `PowerShell`, as *Administrator*, run:
```powershell
choco install -y microsoft-windows-terminal vcxsrv
```

- Run *Start* > *Windows Terminal*
	- Press `Ctrl+,`;
	- Click on the bottom left corner to open JSON file;
	- Replace the contents of `settings.json` with [this](https://raw.githubusercontent.com/araggohnxd/dotfiles/master/.config/windows-terminal-settings.json).

- Run *Start* > *XLaunch*
	- Click *"Next"*;
	- Click *"Next"*;
	- Check *"Disable access control"*;
	- Click *"Next"*;
	- Click *"Save Configuration"* and save `config.xlaunch` in your `Startup` folder at `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`;
	- Click *"Finish"*.
- Reboot.

### WSL Installation
This branch is specific for Debian, but will probably work without any problems in Ubuntu as well.

- In your `PowerShell`, run the following command:
```powershell
wsl --install -d Debian
```
- You can change 'Debian' to your desired Debian based distribuition. Of course, it has to be available on WSL installation list. To check it, run:
```powershell
wsl -l -o
```
```powershell
# Output example

The following is a list of valid distributions that can be installed.
Install using 'wsl --install -d <Distro>'.

NAME               FRIENDLY NAME
Ubuntu             Ubuntu
Debian             Debian GNU/Linux
kali-linux         Kali Linux Rolling
SLES-12            SUSE Linux Enterprise Server v12
SLES-15            SUSE Linux Enterprise Server v15
Ubuntu-18.04       Ubuntu 18.04 LTS
Ubuntu-20.04       Ubuntu 20.04 LTS
OracleLinux_8_5    Oracle Linux 8.5
OracleLinux_7_9    Oracle Linux 7.9
```

- You will be prompted to create your user. After setting your username and password, you must install `curl` in order to run the bootstrap script. Start by updating your packages:
```sh
sudo apt-get update
```
```sh
sudo apt-get -y upgrade
```

- Then, install `curl`:
```sh
sudo apt-get -y install curl
```

- Here's everything in a convenient one liner:
```sh
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install curl
```

## You're all set!
- Now, just run the bootstrap script:
```sh
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/araggohnxd/dotfiles/debian/.zsh/bin/bootstrap.sh')"
```
- During the script execution, you will be presented with some confirmation prompts and password prompts for `sudo`, so pay attention.

- When the script is done running, simply run the command below, so `zsh4humans` can properly source everything up.
```sh
exec zsh
```
- This step will also give you some prompts, but once it's done, you can enjoy your fully working environment!
