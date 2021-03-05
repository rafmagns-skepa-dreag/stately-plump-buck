#!/bin/bash
sudo yum install -y cmake zsh
mkdir $HOME/tools || echo tools already exists
mkdir $HOME/.bin || echo .bin alrady exists
mkdir -p $HOME/.config/nvim || echo .config already exists

# neovim
git clone -b v0.4.4 https://github.com/neovim/neovim.git tools/neovim
pushd tools/neovim
CMAKE_BUILD_TYPE=RelWithDebInfo make
sudo make install
popd

# rust
curl https://sh.rustup.rs -sSf | sh
cargo install ripgrep exa python-launcher starship bat fd-find gitui

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

# poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

# pyenv
curl https://pyenv.run | bash
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv install 3.8.8 &
pyenv install 3.9.2 &
pyenv global 3.8.8

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --completion --no-update-rc --key-bindings

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# curl init.vim, starship.toml, .tmux.conf, .ripgreprc
# git clone https://github.com/rafmagns-skepa-dreag/stately-plump-buck $HOME/bootstrap
mv $HOME/bootstrap/bash/init.vim $HOME/.config/nvim/
mv $HOME/bootstrap/bash/python_history.py $HOME/.pythonrc
mv $HOME/bootstrap/bash/ripgreprc $HOME/.ripgreprc
mv $HOME/bootstrap/bash/starship.toml $HOME/.config/starship.toml
mv $HOME/bootstrap/bash/tmux.conf $HOME/.tmux.conf
mv $HOME/bootstrap/bash/zshrc $HOME/.zshrc
