#!/bin/bash

# 1:  git clone https://github.com/YOUR_USER/dotfiles.git ~/dotfiles
# 2. chmod +x ~/dotfiles/setup.sh && ~/dotfiles/setup.sh
# 3. cd ~/dotfiles; stow zsh; stow git

# --- Configuration ---
# Automatically get the folder where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
FONTS_DIR="$HOME/.local/share/fonts"

# 1. Update and Install System Dependencies (Ubuntu)
echo "Installing system dependencies..."
sudo apt update
sudo apt install -y zsh git curl wget fd-find unzip build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev llvm libncursesw5-dev xz-utils tk-dev \
libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev stow fontconfig bat

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

# 8. Install Nerd Fonts (MesloLGS NF for Powerlevel10k)
FONT_DIR="$HOME/.local/share/fonts"
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
fi

# Only download if not already present
if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    echo "Downloading MesloLGS NF fonts..."
    wget -P "$FONT_DIR" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget -P "$FONT_DIR" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget -P "$FONT_DIR" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget -P "$FONT_DIR" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    
    echo "Refreshing font cache..."
    fc-cache -fv
else 
    echo "Fonts already installed."
fi

# --- 9. Apply Dotfiles with Stow ---
if [ -d "$DOTFILES_DIR" ]; then
    echo "🔗 Applying dotfiles..."
    cd "$DOTFILES_DIR"

    # A. Pull Submodules (CRITICAL for FZF)
    echo "   - Initializing git submodules..."
    git submodule update --init --recursive

    # B. Backup existing config to prevent conflicts
    [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
    [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ] && mv "$HOME/.gitconfig" "$HOME/.gitconfig.bak"

    # C. Run Stow
    stow zsh
    
    # Stow FZF (Links dotfiles/fzf/.fzf -> ~/.fzf)
    # The '2>/dev/null' silences errors if it's already linked
    stow fzf 2>/dev/null || true

    # Uncomment if you have a git folder
    # stow git

    echo "✅ Stow complete."
else
    echo "❌ Error: Dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

# --- 10. Compile FZF Binary ---
# Since we stowed fzf, ~/.fzf is now a symlink to your submodule.
# We must compile the binary so the executable exists.
if [ -d "$HOME/.fzf" ]; then
    echo "⚙️ Compiling FZF binary..."
    "$HOME/.fzf/install" --bin --no-update-rc
fi

echo "🎉 Setup complete! Restart your terminal to see changes."
