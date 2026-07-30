#!/bin/bash
set -euo pipefail

BREAK='\n===\n'

HOME=/home/rhanson

echo -e "${BREAK}Creating directories...${BREAK}"
mkdir $HOME/tools || echo tools already exists
mkdir $HOME/.bin || echo .bin alrady exists
mkdir -p $HOME/.config/nvim || echo .config already exists
mkdir $HOME/Downloads || echo Downloads already exists

CARGO_BIN=$HOME/.cargo/bin
CUSTOM_BIN=$HOME/.bin
TOOLS_BIN=$HOME/tools/bin
LOCAL_BIN=$HOME/.local/bin
export PATH=$CUSTOM_BIN:$TOOLS_BIN:$CARGO_BIN:$LOCAL_BIN:$PATH

echo -e "${BREAK}Setting up ssh vars...${BREAK}"
eval $(ssh-agent)

echo -e "${BREAK}Installing core utilities...${BREAK}"
# core utilities
sudo apt update
sudo apt install \
  cmake \
  curl \
  dirmngr \
  eza \
  fontconfig \
  fzf \
  gawk \
  git \
  gpg \
  jq \
  man-db \
  ripgrep \
  vim \
  wget \
  xsel \
  xz-utils \
  zip \
  -y

# fish
echo -e "${BREAK}Installing fish...${BREAK}"
which fish || echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/4/Debian_13/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:4.list
which fish || curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:4/Debian_13/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_4.gpg >/dev/null
sudo apt update
sudo apt install fish -y

# install github cli
echo -e "${BREAK}Installing gh cli...${BREAK}"
which gh || sudo mkdir -p -m 755 /etc/apt/keyrings &&
  out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg &&
  cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
  sudo mkdir -p -m 755 /etc/apt/sources.list.d &&
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
  sudo apt update &&
  sudo apt install gh -y

# neovim
echo -e "${BREAK}Installing neovim...${BREAK}"
pushd $HOME/tools
wget https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-linux-x86_64.tar.gz
rm -rf nvim-linux-x86_64
rm -rf $HOME/.bin/nvim
tar -zxf nvim-linux-x86_64.tar.gz
ln -s $HOME/tools/nvim-linux-x86_64/bin/nvim $HOME/.bin/nvim
popd

# rust
echo -e "${BREAK}Installing rust...${BREAK}"
which cargo || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH=$HOME/.cargo/bin:$PATH
echo -e "${BREAK}Installing binstall and then using it...${BREAK}"
BINSTALL_DISABLE_TELEMETRY=true curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
cargo binstall \
  atuin \
  bat \
  bore \
  bottom \
  du-dust \
  fd-find \
  git-delta \
  hyperfine \
  python-launcher \
  resvg \
  sd \
  starship \
  yazi-fm \
  zenith \
  zellij \
  zoxide \
  --no-confirm

cargo binstall --git https://github.com/googleworkspace/cli google-workspace-cli

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

# install uv and python
echo -e "${BREAK}Installing uv and python...${BREAK}"
which uv || curl -LsSf https://astral.sh/uv/install.sh | sh
uv python install --default
uv python upgrade

# TODO evaluate below
# $HOME/.fzf/install --completion --no-update-rc --key-bindings

# font
echo -e "${BREAK}Installing robotomono...${BREAK}"
mkdir $HOME/.local/share/fonts || echo font dir already exists
pushd $HOME/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/RobotoMono.tar.xz
tar --xz -xf RobotoMono.tar.xz
rm RobotoMono.tar.xz
fc-cache $HOME/.local/share/fonts
popd

# configure delta
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.dark true # or `delta.light true`, or omit for auto-detection
git config --global merge.conflictStyle zdiff3

# tmux plugin manager
# git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# claude code
echo -e "${BREAK}Installing Claude code...${BREAK}"
curl -fsSL https://claude.ai/install.sh | bash

# asdf
echo -e "${BREAK}Installing asdf...${BREAK}"
pushd $HOME/Downloads
wget https://github.com/asdf-vm/asdf/releases/download/v0.19.0/asdf-v0.19.0-linux-amd64.tar.gz
tar -zxf asdf-v0.19.0-linux-amd64.tar.gz
mv asdf ~/.bin/
popd

echo -e "${BREAK}Installing nodejs...${BREAK}"
cd $HOME
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf set nodejs latest

# curl init.vim, starship.toml, .tmux.conf, .ripgreprc
echo -e "${BREAK}Logging in to github and pulling bootstrap...${BREAK}"
if ! gh auth status >/dev/null 2>&1; then
  echo "Authentication failed. Logging in now...${BREAK}"
  gh auth login
fi
echo $HOME

[[ -d "$HOME/bootstrap" ]] || gh repo clone rafmagns-skepa-dreag/stately-plump-buck $HOME/bootstrap

# ln -s $HOME/bootstrap/bash/init.lua $HOME/.config/nvim/
# ln -s $HOME/bootstrap/bash/lua $HOME/.config/nvim/
# ln -s $HOME/bootstrap/bash/python_history.py $HOME/.pythonrc
if [[ -L "$HOME/.ripgreprc" ]]; then
  rm $HOME/.ripgreprc
fi
ln -s $HOME/bootstrap/bash/ripgreprc $HOME/.ripgreprc
if [[ -L "$HOME/.config/starship.toml" ]]; then
  rm $HOME/.ripgreprc
fi
ln -s $HOME/bootstrap/bash/starship.toml $HOME/.config/starship.toml
# ln -s $HOME/bootstrap/bash/tmux.conf $HOME/.tmux.conf
ln -s $HOME/bootstrap/bash/zshrc $HOME/.zshrc
