# Dotfiles

Files in subdirs can be easly managed with GNU Stow.


# Installation

## Prerequisites (package / plugin managers):

brew (mac os package manager):

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

vcs, shell, terminal mutliplexer, editor, and software organizer:

```
brew install git fish tmux neovim stow
```

fish plugin manager:

```
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
```

tmux plugin manager:

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

(neo)vim plugin manager:

```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

some usefull stuff:

```
brew install bat fd fzf ripgrep telnet
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
```

## Post installation configs


setting fish as default shell:

```
sudo su
echo '/usr/local/bin/fish' >> /etc/shells
chsh -s /usr/local/bin/fish
```

post stow'ing commands:

- fish plugins: run `fisher`
- tmux plugins: press `prefix + I`
- quicklook plugins: run `qlmanage -r`


## Python stuff

python version manager & python package manager `pipenv`:

```
brew install pipenv pyenv
```

python binaries in isolated envs `pipx`:

```
python3 -m pip install --user pipx
```

some usefull python packges (`pipx install PACKAGE NAME`):

- poetry (another python package manager)
- flake8 (code linting)
- black (code formatting)
- isort (sorting imports)
- httpie (cli rest client)
- http-prompt (httpie wrapper)
- johnnydep (package depenedency graph)
- base16-shell-preview (preview base16 color schemes)
- glances (cli monitoring tool)


some usefull settings:

```
poetry config settings.virtualenvs.in-project true
```


# Recomended packages

## Node packages:

- bash-language-server
- dockerfile-language-server-nodejs

