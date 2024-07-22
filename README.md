STOW: Symlink Farm Manager
https://youtu.be/y6XCebnB9gs?si=fX-j4_bvG81wgrtE

Stow creates symlinks in root pointing to files in the current folder (~/dotfiles!)

Helpful commands:
stow .
	Creates the symnlinks to files in current folder

stow --adopt .
	Same as above, but if the files already exist in root and ~/dotfiles, 
	the file in ~/dotfiles will be overwritten by the file in root

# Initial setup new machine:

## Install zsh + zplug
sudo apt install zsh zplug -y

## Remove standard zshrc and replace with stow symlink
cp ~/.zshrc ~/.original.zshrc
cp ~/.bashrc ~/.original.bashrc

## Create symlinks, overwriting existing files in parent folder
sudo stow --delete .


