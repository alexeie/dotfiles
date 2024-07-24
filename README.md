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

## Install zsh
```bash
sudo apt install zsh -y
```

## Install Oh-my-zsh & plugins
```bash
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" \
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

## Install pyenv
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
curl https://pyenv.run | bash

## Remove standard bashrc & zshrc to replace with stow symlink
```bash
mv ~/.zshrc ~/.original.zshrc \
mv ~/.bashrc ~/.original.bashrc
```

## Create symlinks to the files in dotfiles folder
```bash
cd ~/dotfiles
sudo stow .
stow -n -v . \
```
Dry Run: You can use the -n or --dry-run flag to see what Stow would do without actually creating any symlinks. -v = verbose
```bash
> stow -n -v .
```
