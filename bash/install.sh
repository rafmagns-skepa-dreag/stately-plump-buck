#!/bin/bash
# sudo yum install -y cmake zsh
mkdir $HOME/tools || echo tools already exists
mkdir $HOME/.bin || echo .bin alrady exists
mkdir -p $HOME/.config/nvim || echo .config already exists

# cmake
pushd $HOME/tools
wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0-linux-x86_64.tar.gz
tar -zxvf cmake-3.20.0-linux-x86_64.tar.gz
mv cmake-3.20.0-linux-x86_64/bin/* $HOME/.bin/
popd
export PATH=$HOME/.bin:$PATH

# neovim
pushd $HOME/tools
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar zxvf nvim-linux64.tar.gz
ln -s $HOME/tools/nvim-linu64/bin/nvim $HOME/.bin/nvim
popd

# rust
curl https://sh.rustup.rs -sSf | sh
export PATH=$HOME/.cargo/bin:$PATH
cargo install ripgrep exa python-launcher starship bat fd-find gitui git-delta

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

# poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

# pyenv
curl https://pyenv.run | bash
export PATH=$HOME/.pyenv/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv install 3.10.10 &
pyenv install 3.8.16 &
pyenv global 3.8.16

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --completion --no-update-rc --key-bindings

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
