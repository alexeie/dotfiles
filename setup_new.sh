#!/bin/bash

# --- 1. ENVIRONMENT SETUP ---

# Define the location of your dotfiles
DOTFILES_DIR="$HOME/.dotfiles"

# Set ZSH_CUSTOM to the standard Oh-My-Zsh custom directory if not already defined
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "🚀 Starting macOS dotfiles setup..."

# --- 2. HOMEBREW INSTALLATION ---

if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Initialize Homebrew for the current session based on processor architecture
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed."
fi

# --- 3. CORE TOOLS ---

echo "📦 Installing core tools (Git, Stow, FZF, UV)..."
# Added 'uv' here to replace virtualenv workflow
brew install git stow fzf uv

# --- 4. SUBMODULE INITIALIZATION ---

echo "🗂️ Initializing Git submodules..."
cd "$DOTFILES_DIR" || exit

# Repair logic: If a submodule directory exists but isn't a git repo, remove it
# so the update command can re-clone it properly.
git submodule status | while read -r status path _; do
    if [ -d "$path" ] && [ ! -f "$path/.git" ] && [ ! -d "$path/.git" ]; then
        echo "⚠️ Repairing invalid submodule directory: $path"
        rm -rf "$path"
    fi
done

git submodule sync
git submodule init
git submodule update --init --recursive --remote --force

# --- 5. OH-MY-ZSH INSTALLATION ---

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🪄 Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh-My-Zsh already installed."
fi

# --- 6. THEMES (External) ---

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "💎 Installing Powerlevel10k engine..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "✅ Powerlevel10k already installed."
fi

# --- 7. PLUGINS (External) ---

echo "🔌 Installing External Zsh plugins..."

# Only external plugins that need to be git cloned are listed here.
external_plugins=(
    "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting"
    "you-should-use:https://github.com/MichaelAquilina/zsh-you-should-use.git"
    "fzf-docker:https://github.com/pierpo/fzf-docker"
)

for item in "${external_plugins[@]}"; do
    name="${item%%:*}"
    url="${item#*:}"

    if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then
        echo "Installing $name..."
        git clone "$url" "$ZSH_CUSTOM/plugins/$name"
    fi
done

# --- 8. CLEANUP & STOW ---

echo "🔗 Linking configurations with Stow..."

# Remove default files to avoid Stow conflicts
files_to_remove=(".zshrc" ".bashrc" ".nanorc" ".p10k.zsh")
for file in "${files_to_remove[@]}"; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        echo "Removing existing $file to prevent link conflict..."
        rm "$HOME/$file"
    fi
done

# Execute Stow from the dotfiles directory
cd "$DOTFILES_DIR" || exit
stow -v --adopt zsh
stow -v --adopt git
stow -v --adopt nano
stow -v --adopt bash

echo "✨ Setup Complete! Please restart your terminal."