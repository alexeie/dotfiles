
STOW: Symlink Farm Manager
https://youtu.be/y6XCebnB9gs?si=fX-j4_bvG81wgrtE

Stow creates symlinks in root pointing to files in the current folder (~/dotfiles!)

Helpful commands:
stow .
	Creates the symnlinks to files in current folder

stow --adopt .
	Same as above, but if the files already exist in root and ~/dotfiles, 
	the file in ~/dotfiles will be overwritten by the file in root

# Initial setup on clean machine:
```bash
sudo apt update
sudo apt upgrade
```

## Clone the repo containing dotfiles:
```bash
git clone https://github.com/alexeie/dotfiles.git ~/dotfiles
```

## Install zsh
```bash
sudo apt install zsh -y
```

## Install Oh-my-zsh & plugins
```bash
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
# Get Oh-my-zsh plugins:
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions  
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat

# Backup virtualenv original file to make room for symbolic link:
mv ~/.oh-my-zsh/plugins/virtualenv/virtualenv.plugin.zsh ./.oh-my-zsh/plugins/virtualenv/virtualenv.plugin.zsh.bak 
```

# Download generate password git submodule and initialize its venv
```bash
git submodule update --init --recursive
cd ~/dotfiles/.zsh_functions/generate_password
python3 -m venv venv
```

## Install stow
```bash
sudo apt install stow -y
```

# Installing pyenv on new machine:
Needed for the python function to generate passwords
```bash
cd ~
sudo apt update
sudo apt upgrade
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
curl https://pyenv.run | bash
```

## Backup standard bashrc & zshrc to replace with stow symlink
```bash
mv ~/.zshrc ~/.original.zshrc  
mv ~/.bashrc ~/.original.bashrc  
```

## Create symlinks to the files in dotfiles folder
```bash
cd ~/dotfiles  
stow -n -v . # Dry run, verbose

# If the changes look OK stow files to save symlinks in Home dir   
cd ~/dotfiles
sudo stow .
```

# Success

# Install secondary terminal apps:
Git dependencies:
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

Other terminal apps:
```bash
sudo apt-get install -y fd-find bat
```
