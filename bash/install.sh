#!/bin/bash
# sudo yum install -y cmake zsh
mkdir $HOME/tools || echo tools already exists
mkdir $HOME/.bin || echo .bin alrady exists
mkdir -p $HOME/.config/nvim || echo .config already exists

# cmake
pushd $HOME/tools
wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0-linux-x86_64.tar.gz
tar -zxvf cmake-3.20.0-linux-x86_64.tar.gz
pushd $HOME/.bin
ln -s $HOME/tools/cmake-3.20*/bin/* $HOME/.bin/
wget https://github.com/eza-community/eza/releases/download/v0.20.21/eza_x86_64-unknown-linux-gnu.tar.gz
tar -zxvf eza_x86_64-unknown-linux-gnu.tar.gz
rm -rf eza_x86_64-unknown-linux-gnu.tar.gz
popd
popd
export PATH=$HOME/.bin:$PATH

# neovim
pushd $HOME/tools
wget https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz
tar -zxvf nvim-linux-x86_64.tar.gz
ln -s $HOME/tools/nvim-linu-x86_64/bin/nvim $HOME/.bin/nvim
popd

# rust
curl https://sh.rustup.rs -sSf | sh
export PATH=$HOME/.cargo/bin:$PATH
cargo install ripgrep python-launcher starship bat fd-find gitui git-delta bore sd du-dust hyperfine zenith

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

# poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

# pyenv
curl https://pyenv.run | bash
export PATH=$HOME/.pyenv/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv install 3.12.1 &
pyenv install 3.8.16 &

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --completion --no-update-rc --key-bindings

# yazi
wget https://github.com/sxyazi/yazi/releases/download/v0.2.1/yazi-x86_64-unknown-linux-gnu.zip
unzip yazi-x86_64-unknown-linux-gnu.zip
mv yazi-x86_64-unknown-linux-gnu/yazi ~/.bin/

# font
mkdir $HOME/.local/share/fonts || echo font dir already exists
pushd $HOME/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.tar.xz
tar --xz -xf RobotoMono.tar.xz
rm RobotoMono.tar.xz
fc-cache $HOME/.local/share/fonts
popd

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# curl init.vim, starship.toml, .tmux.conf, .ripgreprc
# git clone https://github.com/rafmagns-skepa-dreag/stately-plump-buck $HOME/bootstrap
git clone git@github.com:rafmagns-skepa-dreag/stately-plump-buck $HOME/bootstrap

ln -s $HOME/bootstrap/bash/init.vim $HOME/.config/nvim/
ln -s $HOME/bootstrap/bash/plugins.lua $HOME/.config/nvim/
ln -s $HOME/bootstrap/bash/lua $HOME/.config/nvim/
ln -s $HOME/bootstrap/bash/python_history.py $HOME/.pythonrc
ln -s $HOME/bootstrap/bash/ripgreprc $HOME/.ripgreprc
ln -s $HOME/bootstrap/bash/starship.toml $HOME/.config/starship.toml
ln -s $HOME/bootstrap/bash/tmux.conf $HOME/.tmux.conf
ln -s $HOME/bootstrap/bash/zshrc $HOME/.zshrc
