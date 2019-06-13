# Key mappings

## fish
- `⌃-T` – find a file
- `⌃-R` – search through command history
- `⌥-C` – cd into sub-directories (recursively searched)
- `⌥-⇧-C` – cd into sub-directories, including hidden ones
- `⌃-O` – open a file/dir using default editor ($EDITOR)
- `⌃-G` – open a file/dir using xdg-open or open command

## tmux
- `⌃-S` - prefix key
- `⌘-⇧-[` `]` – switch window
- `⌘-⇧-P` – switch to last window
- `⌘-⇧-Left` `Right` – move window
- `⌘-⇧-\` – window list view
- `⌘-T` – new window
- `⌘-W` – close window
- `⌘-F` – copy mode
- `⌘-K` – (Alacritty) send k (clear)
- `⌘-R` – send tmux reset command

## neovim
Case-sensetive mappings

### Normal mode

#### One key mappings
- `{` `}` – switch tab to left / right
- `Y` – show documentation

##### ..with modifier (⌃ / ⌥)
- `⌃-h` `j` `k` `l` – switch pane

#### Two key mappings
- `:h surround.txt` Surrounding. Targets may be: (, ), {, }, [, ], <, >, ", ', <Tick>, t (xml or html tag), punctuation marks, words, sentences, paragraphs. `<SurroundObject>` may be any single characer; if `t` or `<` is used vim prompts HTML/XML tag to insert (if `C-T` is used tag will appear on a new line); if `f`, `F` or `C-F` is used vim prompts a function name to insert. Actions:
  - `cs<SurroundObject><SurroundObject>` - change surround object
  - `ys<MotionOrTextObject><SurroundObject>` - wrap motion or text object with surrounding
  - `yss<SurroundObject>` - surround current line ignoring leading whitespace
  - `yS<SurroundObject>` `ySS<SurroundObject>` - indent the surrounded text and place it on a line of its own
  - `ds<SurroundObject>` - delete surround
  - [visual mode] `S` - wrap selected
  - [visual mode] `gS` - wrap selected and place on new line

- `:h unimpaired.txt`  `]` (forward), `[` (backward) switch through (uppercased letter means first / last items):

  - `a` `A` - arguments (files)
  - `b` `B` - buffers
  - `c` - SCM changes
  - `d` - diagnostics list
  - `l` `L` - location list
  - `q` `Q` - quickfix list
  - `t` `T` - tags
  - `e` - move line above or below
  - `<Space>` - add new line above or below
  - `h` `H` - python highlighted name
  - `]` – `]]` beginning of the next Python class; `[]` end of the previous Python class
  - `[` – `][` end of the current Python class; `[[` beginning of the current Python class (or beginning of the previous Python class if not currently in a class or already at the beginning of a class)
  - `m` - beginning of the next Python method or function; beginning of the current Python method or function (or to the beginning of the previous method or function if not currently in a method/function or already at the beginning of a method/function)
  - `M` - end of the current Python method or function; end of the previous Python method or function

- `g` GoTo:
  - `d` – definition
  - `y` – type definition
  - `l` – implementations
  - `r` – references

#### `<Leader>` prefixed mappings
- `<Delete>` – echo empty message (cleanup message string) 
- `<Enter>` – cleanup search highlights
- `<Tick>` - marks
- `e` – MRU files
- `b` – buffers
- `f` – files
- `t` - tags

- `g` GoTo:
  - `n` - new tab
  - `s` - tab split

- `v` View:
  - `l` - toggle Limelight
  - `r` - toggle RainbowParentheses
  - `s` – syncronize syntax

- `d` Diagnostics:
  - `l` - list
  - `i` - info

- `q` (Quick)fix:
  - `o` - open quickfix window
  - `c` – close quickfix window
  - `f` - fix current

### Insert mode
- `⌃-x` - completion-menu

### Special-cases (in menu shortcuts)
- quickfix
  - `dd` – delete item
- crtl.p
  - `⌃-f/b` - cycle between modes
  - `⌃-d` - filename mode or full path
  - `⌃-r` - regexp mode
  - `⌃-t/v/x` - open in new tab or split
  - `⌃-n/p` - cycle prompt history
  - `⌃-y` - create new file and its parents dirs
  - `⌃-z` - mark/unmark files to open with `⌃-o`
- commentary.vim
  - `gcc` - comment line
  - `gc` - comment target of motion (like `gcap`)
  - [visual mode] `gc` - comment selected

### Text objects
- pair of braces: `(`, `{`(`B`), `[`, `<`, or tag: `t`
- pair of quotes: `'`, `"`, ````, `q` (any quote)
- separators: `, . ; : + - = ~ _ * # / | \ & $`
- arguments: `a`
- any of blocks above: `b`

Seeking: `l`, `n` for last and next object.

# VIM Functions
`Commentary` - comment (like `:7,17Commentary` or `:g/TODO/Commentary`)
