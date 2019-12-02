# TODO: pre-config before all installations

# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Must-have stuff
brew install fish fzf go neovim node pipenv pyenv ripgrep telnet tmux yarn

mkdir -p ~/Sources/opensource/
mkdir -p ~/Sources/projects/

# install rust & cargo
# install alacritty

# TODO: config system
# TODO: organize install dir (or migrate dir)
# TODO: install pyenv (with versions; with virtualenvs for versions; with pip install in virtualenvs)

qlmanage -r
