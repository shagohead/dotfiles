# TODO: pre-config before all installations

# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Must-have stuff
brew install bat fd fish fzf git go neovim node pipenv pyenv ripgrep telnet tmux yarn

# vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# fisher for fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

mkdir -p ~/Sources/opensource/
mkdir -p ~/Sources/projects/

# rust compiler
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

qlmanage -r

# install alacritty
