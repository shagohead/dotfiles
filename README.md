# My dotfiles

Files in subdirs can be easly managed with GNU Stow.

## TODO

- [ ] nvim DAP (для python pdb и delve)
- [ ] delta cterm color scheme (чтобы цвета delta зависели от текущей темы терминала)
- [ ] nvim netrw с tpope/vim-vinegar (https://shapeshed.com/vim-netrw/)
- [ ] [SQLS](https://github.com/lighttiger2505/sqls) (SQL LSP) & [nvim plugin](https://github.com/nanotee/sqls.nvim):


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

vim plugin manager:

```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

some usefull stuff:

```
brew install bat fd fzf ripgrep telnet shellcheck hadolint glow
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


some usefull settings:

```
poetry config settings.virtualenvs.in-project true
```

## Homebrewed packages:
- git-flow
- git-delta (update git-config core.pager & interacive.diffFilter)
- pgformatter


## Node packages:

- bash-language-server
- dockerfile-language-server-nodejs
- pyright
- vim-language-server


## Rust development

language server:
`rustup component add rls rust-analysis rust-src`
