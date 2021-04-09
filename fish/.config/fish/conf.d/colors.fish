# the default color
set -q fish_color_normal; or set -U fish_color_normal normal
# the color for commands
set -q fish_color_command; or set -U fish_color_command blue
# the color for quoted blocks of text
set -q fish_color_quote; or set -U fish_color_quote green
# the color for IO redirections
set -q fish_color_redirection; or set -U fish_color_redirection brmagenta
# the color for process separators like ';' and '&'
set -q fish_color_end; or set -U fish_color_end magenta
# the color used to highlight potential errors
set -q fish_color_error; or set -U fish_color_error red
# the color for regular command parameters
set -q fish_color_param; or set -U fish_color_param normal
# the color used for code comments
set -q fish_color_comment; or set -U fish_color_comment brblack
# the color used to highlight matching parenthesis
set -q fish_color_match; or set -U fish_color_match --background=cyan
# the color used when selecting text (in vi visual mode)
set -q fish_color_selection; or set -U fish_color_selection green
# used to highlight history search matches and the selected pager item (must be a background)
set -q fish_colorsearch_match; or set -U fish_colorsearch_match --background=brblack
# the color for parameter expansion operators like '*' and '~'
set -q fish_color_operator; or set -U fish_color_operator magenta
# the color used to highlight character escapes like '\n' and '\x70'
set -q fish_color_escape; or set -U fish_color_escape magenta
# the color used for the current working directory in the default prompt
set -q fish_color_cwd; or set -U fish_color_cwd brblue
# the color used for autosuggestions
set -q fish_color_autosuggestion; or set -U fish_color_autosuggestion -d
# the color used to print the current username in some of fish default prompts
set -q fish_color_user; or set -U fish_color_user brcyan
# the color used to print the current host system in some of fish default prompts
set -q fishcolor_host; or set -U fishcolor_host brblue
# the color for the '^C' indicator on a canceled command
set -q fish_color_cancel; or set -U fish_color_cancel brred
# the color of the prefix string, i.e. the string that is to be completed
set -q fish_pager_color_prefix; or set -U fish_pager_color_prefix white --underline
# # the color of the completion itself
# set -q fish_pager_color_completion; or set -U fish_pager_color_completion
# the color of the completion description
set -q fish_pager_color_description; or set -U fish_pager_color_description bryellow
# the color of the progress bar at the bottom left corner
set -q fish_pager_color_progress; or set -U fish_pager_color_progress brcyan
# # the background color of the every second completion
# set -q fish_pager_color_secondary; or set -U fish_pager_color_secondary
