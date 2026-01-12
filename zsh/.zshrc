# --- Powerlevel10k Instant Prompt (Must be at the top) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Environment & Path ---
export ZSH="$HOME/.oh-my-zsh"
export PYENV_ROOT="$HOME/.pyenv"
# Added .fzf/bin to the path so the system finds the command
export PATH="$PYENV_ROOT/bin:$PATH:$HOME/.tfenv/bin:$HOME/.fzf/bin:/usr/bin/dot"

# Initialize Pyenv (fail silently if not found)
command -v pyenv >/dev/null && eval "$(pyenv init --path)" && eval "$(pyenv init -)"

# --- OMZ Settings ---
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:update' mode auto
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd.mm.yyyy"

# --- Plugins ---
plugins=(
  git
  colored-man-pages
  you-should-use
  fzf-docker
  terraform
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# --- Source Oh-My-Zsh ---
source $ZSH/oh-my-zsh.sh

# --- User Configuration (Post-OMZ) ---

eval "$(uv generate-shell-completion zsh)"

# 1. Aliases & Locals
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.startup_params ] && source ~/.startup_params

# 2. Correction
unsetopt correct_all
setopt correct

# 3. Autoload Functions
if [ -d "$HOME/.zsh_functions" ]; then
  fpath=("$HOME/.zsh_functions" $fpath)
  autoload -Uz "$HOME/.zsh_functions"/*(:t)
fi

# 4. History Tweaks
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# --- FZF & fd Setup ---

# Use 'fdfind' (Ubuntu) instead of find
export FZF_DEFAULT_COMMAND="fdfind --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fdfind --type-d hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() { fdfind --hidden --exclude .git . "$1"; }
_fzf_compgen_dir() { fdfind --type=d --hidden --exclude .git . "$1"; }

# Initialize FZF
# We check if the manual config exists first.
if [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"
elif command -v fzf >/dev/null; then
  # Fallback for system install (only works on very new FZF versions)
  eval "$(fzf --zsh 2>/dev/null)" || true
fi

# --- Powerlevel10k Config ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
