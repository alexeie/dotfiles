# pyenv

## Core Commands

**pyenv install <python_version>**
Downloads, compiles, and installs the specified Python version on your system.  
**pyenv uninstall <python_version>**
Removes a specified Python version managed by pyenv.  
**pyenv versions**
Lists all Python versions installed by pyenv.  
**pyenv version**
Displays the currently active Python version (and how it was set).

## Version Management

**pyenv global <python_version>**
Sets the default Python version system-wide for your user when using pyenv.    
**pyenv local <python_version>**
Sets a Python version specifically for a project directory by creating a .python-version file.  
**pyenv shell <python_version>**
Sets a temporary Python version for your current shell session only.  
  
## Additional

**pyenv rehash**
Installs shims for all Python binaries in pyenv's path (useful after installing new plugins or packages)

# Installing pyenv on new machine:

## Using Zsh:
```bash
cd ~
sudo apt update
sudo apt upgrade
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
	libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
	libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
curl https://pyenv.run | bash
```
Add the following lines to your ~/.zshrc file:
```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
```
Then reload zshrc configuration:
```bash
source ~/.zshrc
```
