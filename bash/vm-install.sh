#!/bin/bash
sudo yum install -y cmake zsh
mkdir $HOME/tools || echo tools already exists
mkdir $HOME/.bin || echo .bin alrady exists
mkdir -p $HOME/.config/nvim || echo .config already exists

# neovim
wget https://github.com/neovim/neovim/releases/download/v0.4.4/nvim-linux64.tar.gz
tar -zxf nvim-linux64.tar.gz
mv nvim-linux64 $HOME/.bin/

# starship
curl -fsSL https://starship.rs/install.sh | bash

# rust
curl https://sh.rustup.rs -sSf | sh
export PATH=$HOME/.cargo/bin:$PATH
cargo install ripgrep python-launcher gitui exa

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

# poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

# pyenv
curl https://pyenv.run | bash
export PATH=$HOME/.pyenv/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --completion --no-update-rc --key-bindings

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# curl init.vim, starship.toml, .tmux.conf, .ripgreprc
git clone https://github.com/rafmagns-skepa-dreag/stately-plump-buck $HOME/bootstrap
mv $HOME/bootstrap/bash/init.vim $HOME/.config/nvim/
mv $HOME/bootstrap/bash/python_history.py $HOME/.pythonrc
mv $HOME/bootstrap/bash/ripgreprc $HOME/.ripgreprc
mv $HOME/bootstrap/bash/starship.toml $HOME/.config/starship.toml
mv $HOME/bootstrap/bash/tmux.conf $HOME/.tmux.conf
mv $HOME/bootstrap/bash/zshrc $HOME/.zshrc

rm -rf $HOME/bootstrap
rm -rf dust* bat* fd*

# mkdir -p $HOME/.local/share/fonts
# cd $HOME/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
