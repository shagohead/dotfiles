# Key mappings

## fish
`⌃-T` – find a file

`⌃-R` – search through command history

`⌥-C` – cd into sub-directories (recursively searched)

`⌥-⇧-C` – cd into sub-directories, including hidden ones

`⌃-O` – open a file/dir using default editor ($EDITOR)

`⌃-G` – open a file/dir using xdg-open or open command


## neovim
Case-sensetive mappings

### Normal mode
#### One key mappings
- `{` `}` – switch tab to left / right
- `Y` – show documentation (coc.nvim)

##### ..with modifier (⌃ / ⌥)
- `⌃-h` `j` `k` `l` – switch pane

#### Two key mappings
- `]` (forward), `[` (backward) switch through:

  - `a` - arguments (files); `A` first / last
  - `b` - buffers; `B` first / last
  - `c` - SCM changes
  - `d` - diagnostics list (coc.nvim)
  - `l` - location list; `L` first / last
  - `q` - quickfix list; `Q` first / last
  - `t` - tags; `T` first / last
  - `e` - move line above or below
  - `<Space>` - add new line above or below
  - `h` - python highlighted name prev / next (semhi)
  - `H` - python highlighted name first / last (semhi)
  - `]` – `]]` beginning of the next Python class; `[]` end of the previous Python class (vim-pythonsense)
  - `[` – `][` end of the current Python class; `[[` beginning of the current Python class (or beginning of the previous Python class if not currently in a class or already at the beginning of a class) (vim-pythonsense)
  - `m` - beginning of the next Python method or function; beginning of the current Python method or function (or to the beginning of the previous method or function if not currently in a method/function or already at the beginning of a method/function) (vim-pythonsense)
  - `M` - end of the current Python method or function; end of the previous Python method or function (vim-pythonsense)

- `g` GoTo:
  - `d` – definition (coc.nvim)
  - `y` – type definition (coc.nvim)
  - `l` – implementations (coc.nvim)
  - `r` – references (coc.nvim)

#### `<Leader>` prefixed mappings
- `<Delete>` – echo empty message (cleanup message string) 
- `<Enter>` – cleanup search highlights
- `<Tick>` - marks (fzf)
- `b` – buffers (fzf)
- `e` – MRU files (CtrlP)
- `f` – files (fzf)
- `t` - tags (fzf)

- `g` GoTo:
  - `n` - new tab
  - `s` - tab split

- `v` View:
  - `l` - toggle Limelight
  - `r` - toggle RainbowParentheses
  - `s` – syncronize syntax

- `d` Diagnostics (coc.nvim):
  - `l` - list
  - `i` - info

- `q` (Quick)fix:
  - `o` - open quickfix window
  - `c` – close quickfix window
  - `f` - fix current (coc.nvim)

### Insert mode
- `⌃-x` - completion-menu

### Special-cases (in menu shortcuts)
- quickfix
  - `dd` – delete item

### Text objects
- `ac` – outer class (vim-pythonsense)
- `ic` – inner class (vim-pythonsense)
- `af` – outer function (vim-pythonsense)
- `if` – inner function (vim-pythonsense)
- `ad` – outer docstring (vim-pythonsense)
- `id` – inner docstring (vim-pythonsense)


## tmux
`⌘-⇧-[` `]` – switch window

`⌘-⇧-P` – switch to last window

`⌘-⇧-Left` `Right` – move window

`⌘-⇧-\` – window list view

`⌘-T` – new window

`⌘-W` – close window

`⌘-F` – copy mode

`⌘-K` – (Alacritty) send k (clear)

`⌘-R` – send tmux reset command
