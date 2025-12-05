#!/bin/bash

# 1:  git clone https://github.com/YOUR_USER/dotfiles.git ~/dotfiles
# 2. chmod +x ~/dotfiles/setup.sh && ~/dotfiles/setup.sh
# 3. cd ~/dotfiles; stow zsh; stow git

# 1. Update and Install System Dependencies (Ubuntu)
echo "Installing system dependencies..."
sudo apt update
sudo apt install -y zsh git curl wget fd-find unzip build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev llvm libncursesw5-dev xz-utils tk-dev \
libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev stow

# 2. Install Oh-My-Zsh (Unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# 4. Install External Zsh Plugins
PLUGIN_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins

check_plugin() {
  NAME=$1
  URL=$2
  if [ ! -d "$PLUGIN_DIR/$NAME" ]; then
    echo "Installing plugin: $NAME..."
    git clone $URL "$PLUGIN_DIR/$NAME"
  fi
}

check_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
check_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
check_plugin "you-should-use" "https://github.com/MichaelAquilina/zsh-you-should-use.git"
check_plugin "fzf-docker" "https://github.com/pierpo/fzf-docker.git"

# 5. Install Pyenv
if [ ! -d "$HOME/.pyenv" ]; then
  echo "Installing Pyenv..."
  curl https://pyenv.run | bash
fi

# 6. Install Tfenv (Terraform Manager)
if [ ! -d "$HOME/.tfenv" ]; then
  echo "Installing Tfenv..."
  git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
fi

# 7. Install FZF (Git method to match your config)
if [ ! -d "$HOME/.fzf" ]; then
  echo "Installing FZF..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --no-update-rc
fi

# 8. Set Default Shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Changing default shell to zsh..."
  chsh -s $(which zsh)
fi

# 9. Prep for Stow (Remove OMZ default config to avoid conflict)
if [ -f "$HOME/.zshrc" ]; then
    echo "Backing up default .zshrc to .zshrc.bak..."
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

# 10. Run Stow
# Sjekk at dotfiles-mappen faktisk er der vi tror den er
DOTFILES_DIR="$HOME/dotfiles"

if [ -d "$DOTFILES_DIR" ]; then
    echo "Applying dotfiles with stow..."
    cd "$DOTFILES_DIR"

    # Stow zsh configuration
    stow zsh

    # Stow git configuration (hvis du har en mappe for det)
    stow git

    echo "Stow complete."
else
    echo "WARNING: $DOTFILES_DIR not found. Skipping stow."
fi

echo "Setup fully complete! Please restart your terminal."
