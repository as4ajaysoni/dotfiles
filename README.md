# dotfiles

SSH Public Keys: https://github.com/as4ajaysoni.keys

## Bookmarklets

Notepad in Browser Tab
```javascript
data:text/html,<html contenteditable onload="document.body.innerHTML = localStorage['text']" oninput="localStorage['text'] = document.body.innerHTML" style="line-height:1.5;font-size:20px;">
```

```javascript
javascript:(() => {  
    const message = document.getSelection().toString().replace(/(<br>)|(<br\/>)/, '\n');
    fetch('https://ntfy.sh/asext', { method: 'POST', body: message || window.location }); 
})();
```

---

## Installation via Installer

```shell
# with curl
curl -s https://raw.githubusercontent.com/vs4vijay/dotfiles/master/installer.sh | bash -x
sh -c "$(curl -fsSL https://raw.github.com/vs4vijay/dotfiles/master/installer-for-win.sh)"

# with wget
wget https://raw.githubusercontent.com/vs4vijay/dotfiles/master/installer.sh -O - | bash -x
sh -c "$(wget -qO - https://raw.github.com/vs4vijay/dotfiles/master/installer-for-win.sh)"

```

## Installation via Git
- Install Terminator: `sudo apt-get install terminator git`
- Open Terminator and Run following commands:
```shell
git clone git@github.com:vs4vijay/dotfiles.git
cd dotfiles
bash installer.sh
```

## Another way to manage dotfiles

```shell
git init --bare ~/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```

---

## Pre-requisites
- `$TERM` must be `xterm-256color`
- `$SHELL` must be `zsh`

---

## Tools used

- Tools:
  - zsh
  - lsd
  - fzf
  - thefuck
  - tmux
- Zsh:
  - Plugin: Oh-my-zsh
  - Theme: 
    - Powerlevel10k: https://github.com/romkatv/powerlevel10k
- Vim:
  - Plugin Manager: Vundle
  - Theme: https://github.com/vim-airline/vim-airline
  - Other Vim Themes:
    - https://github.com/joshdick/onedark.vim
  - Community Configs:
    - LunarVim
    - NvChad
    - LazyVim
    - AstroNvim
    - SpaceVim
- Tmux:
  - .tmux - https://github.com/gpakosz/.tmux
  - tmuxinator - https://github.com/tmuxinator/tmuxinator
  - Tmux commands and shortcut keys
    - `tmux new -s <session-name>`
    - `tmux ls`
    - `tmux attach -t <session-name>`
    - <prefix> + c - Create a window
    - <prefix> + x - Kill current pane
    - <prefix> + $ - Rename session
    - <prefix> + , - Rename window
    - <prefix> + d - Deattach
    - <prefix> + w - List windows
    - <prefix> + q - Show pane numbers
    - <prefix> + ! - Break a pane to window
- Fonts: 
  - NerdFont: https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono
  - Other Fonts:
    - https://github.com/powerline/fonts.git
    - https://github.com/ryanoasis/nerd-fonts.git
      - https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode
      - https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack
      - https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono/Regular
    - https://github.com/tonsky/FiraCode
    - https://github.com/JetBrains/JetBrainsMono
    - https://github.com/adobe-fonts/source-code-pro
- `pip install -U yt-dlp[default]`
- `pip install -U pyinfra`
- starship prompt - https://github.com/starship/starship

---

## Misc Tasks

- Generate SSH Keys:
```shell
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "abc-keyname"
```
- Adding authorized keys to guest machine:
```shell
mkdir -p ~/.ssh
echo "your_public_key" >> ~/.ssh/authorized_keys

```

- Add to `~/.bashrc` to auto attach to tmux
```bash
if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi
```

- `~/.ssh/config` template
```bash
Host *
    ControlMaster auto
    ControlPersist yes
    ControlPath ~/.ssh/socket-%C
    ServerAliveInterval 60
    ServerAliveCountMax 5

Host zzz
    HostName zzz
    User uuu
    Port 22222
    IdentityFile ~/.ssh/zzz

```

- Configure Locale
```shell
sudo apt-get install locales
sudo dpkg-reconfigure locales
```

- Use patched fonts on terminal
- NerdFont
```shell
sudo apt-get install fonts-powerline

# OR

git clone --depth 1 https://github.com/powerline/fonts.git ~/fonts
bash ~/fonts/install.sh
rm -rf ~/fonts
```

- Change current shell to zsh
```shell
chsh -s $(which zsh)
```

---

## Misc Softwares and Tools

- KDE Plasma Desktop Environment: `sudo apt-get install kde-plasma-desktop plasma-nm`
- Yakuake Drop-down Terminal / Guake Terminal
- Preload tool - `sudo apt-get install preload`
- Clean up Apt - `sudo apt-get clean && sudo apt-get autoremove --purge && sudo apt-get remove`
  
---
  
## Windows Specific
  
- Windows Terminal + Cmder
  - cmd.exe /k M:\\Tools\\Cmder\\vendor\\init.bat
- Winget
  - winget install Git.Git
  - winget install 7zip.7zip
  - winget install Python.Python.3.11
  - winget install OpenJS.NodeJS.LTS
  - winget install CoreyButler.NVMforWindows
  - winget install GoLang.Go.1.19
  - winget install Rustlang.Rustup
  - winget install Microsoft.WSL
  - winget install Microsoft.OpenJDK.17
  - winget install Notepad++.Notepad++
  - winget install Microsoft.VisualStudioCode
  - winget install Microsoft.VisualStudioCode.Insiders
  - winget install Microsoft.VisualStudio.2022.Enterprise
  - winget install Microsoft.VisualStudio.2022.BuildTools
  - winget install MSYS2.MSYS2
    - Add `C:\msys64\usr\bin` and `C:\msys64\ucrt64\bin` to PATH
    - NOT WORKING - `setx PATH "%PATH%;C:\msys64\usr\bin;C:\msys64\ucrt64\bin"`
    - Run commands:
      ```bash
      pacman -Syu
      pacman -Syyuu
      pacman -S zsh vim tmux
      pacman -S net-utils
      pacman -S compression
      pacman -S ncdu tree
      pacman -S pactoys
      pacman -S mingw-w64-ucrt-x86_64-fzf mingw-w64-ucrt-x86_64-lsd mingw-w64-ucrt-x86_64-ag mingw-w64-ucrt-x86_64-jq
      pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
      
      # pacman -S mingw-w64-ucrt-x86_64-SDL2 mingw-w64-ucrt-x86_64-SDL2_mixer
      # pacman -S mingw-w64-ucrt-x86_64-gcc
      # pacman -S mingw-w64-x86_64-toolchain

      # Set MSYS environment variable with Administrative Previledges to make symlinks
      export MSYS=winsymlinks:nativestrict
      ln -sv /s/GitHub ~/GitHub
      ln -sv ~/GitHub/dotfiles/.bashrc ~/.bashrc
      ln -sv ~/GitHub/dotfiles/.zshrc ~/.zshrc

      mkpasswd -l -c > /etc/passwd
      mkgroup -l -c > /etc/group
      sed -i '/^passwd:/ s/.*/passwd:         files/' /etc/nsswitch.conf
      sed -i '/^group:/ s/.*/group:          files/' /etc/nsswitch.conf
      # update /etc/nsswitch.conf with db_home: windows

      # set HOME in environment variable to your user directory
      ```
  - winget install Microsoft.AzureCLI
  - winget install JetBrains.IntelliJIDEA.Community
  - winget install JetBrains.IntelliJIDEA.Ultimate.EAP
  - winget install neovim
    - git clone https://github.com/NvChad/starter --depth 1 $USERPROFILE/AppData/Local/nvchad
    - git clone https://github.com/LunarVim/LunarVim --depth 1 $USERPROFILE/AppData/Local/lunarvim
    - NVIM_APPNAME=nvchad nvim
    - NVIM_APPNAME=lunarvim nvim
  - winget install Microsoft.PowerToys
  - winget install Bruno.Bruno
  - winget install sysinternals
  - winget install VideoLAN.VLC
  - winget install magic-wormhole
  - winget install Google.PlatformTools
  - winget install Google.AndroidStudio
  - winget install RedHat.Podman
  - winget install -e --id RedHat.Podman-Desktop
  - winget install -e --id Adobe.Acrobat.Reader.64-bit
- PowerToys
- DevToys
- Starship
- Microsoft Terminal entry:
  ```json 
    {
      "commandline": "C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64 -use-full-path -shell zsh",
      "guid": "{17da3cac-b318-431e-8a3e-7fcdefe6d115}",
      "icon": "C:/msys64/ucrt64.ico",
      "name": "Terminal",
      "startingDirectory": "C:/Users/%USERNAME%"
    },
  ```

---

## WSL

- Enable WSL - https://www.kali.org/docs/wsl/wsl-preparations/
  
- /etc/wsl.conf
```
[network]
generateResolvConf = false
```
- /etc/resolv.conf
```
nameserver 1.1.1.1
```
- Auto
```bash
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 1.1.1.1" > /etc/resolv.conf'
sudo bash -c 'echo "[network]" > /etc/wsl.conf'
sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
sudo chattr +i /etc/resolv.conf
```
---
  
## Security 
  
- Check if any wifi card supports monitor mode - `iw list | grep -i monitor`
- Enable monitor mode on wifi card (If supported)
```shell
sudo ip dev

sudo ip link set wlan0 down
sudo iw wlan0 set monitor control
sudo ip link set wlan0 up
  
# OR

sudo ifconfig

sudo ifconfig wlan0 down
sudo iwconfig wlan0 mode monitor
sudo ifconfig wlan0 up
  
sudo iwconfig wlan0 mode managed
```

---

# Containers

## Setup Docker

```bash
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $(whoami)
exit

# OR 

sudo apt install docker.io
```

---

# Setup Wireguard VPN
- Using algo
```bash
#!/usr/bin/env bash

export ONDEMAND_CELLULAR=true
export SSH_TUNNELING=true
curl -s https://raw.githubusercontent.com/trailofbits/algo/master/install.sh | sudo -E bash -x
```
  
---
  
# Termux
  
```shell
pkg up -y

pkg install root-repo

pkg install aircrack-ng

pkg install starship
```

---
  
## Troubleshooting

- Add apt source

```shell
sudo apt-add-repository 'deb http://myserver/path/to/repo stable myrepo'

# OR

sudo echo "deb <url>" | sudo tee -a /etc/apt/sources.list.d/<file>
```

- Add gpg keys
```shell
curl -fsSL https://archive.kali.org/archive-key.asc | sudo apt-key add -

# OR

wget -O - https://re4son-kernel.com/keys/http/archive-key.asc | sudo apt-key add -
```

---

### Work in-progress

```

git remote set-url origin <url>

https://github.com/sorin-ionescu/prezto


PyENV


set backspace=indent,eol,start

set nobackup
set nowritebackup
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching


# Source a local zshrc if it exists
test -e "${HOME}/.zshrc.local" && source "${HOME}/.zshrc.local"


ln -sv “~/.dotfiles/git/.gitconfig” ~
ln -v


if [[ "$OSTYPE" != darwin* ]]; then
  echo "Mac"
fi


test -e "${HOME}/file" && source "${HOME}/file"
[[ -f $pub ]] || ssh-keygen -t ed25519


[ "${SHELL##/*/}" != "zsh" ] && echo 'You might need to change default shell to zsh: `chsh -s /bin/zsh`'


# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups:erasedups

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
#         The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls:clear'

# Export hostory to a different file
export HISTFILE="${HOME}/.history/${CURRENT_SHELL}.history.txt"


alias change_tor_ip="printf 'AUTHENTICATE "password"\r\nSIGNAL NEWNYM\r\n' | nc 127.0.0.1 9051"
alias change_tor_ip="sudo killall -HUP tor"


bold=$(tput bold)
norm=$(tput sgr0)


Icons:
https://avatars3.githubusercontent.com/u/11850518?s=200&v=4
https://avatars3.githubusercontent.com/u/65011256?s=200&v=4
  
magic-wormhole

```
