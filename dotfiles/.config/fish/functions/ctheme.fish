function ctheme -d "cterm256'based theme changer"
    argparse 'h/help' 'complete' -- $argv
    or return

    set -l bg_list dark light
    set -l contrast_list low mid high

    if test -n "$_flag_help" -a -z "$_flag_complete"
        echo "usage: ctheme [-h | --help] [light|dark] [low|mid|high] [theme_name]

Change color theme and use cterm256 a top of it.

Theme will be choosed randomly accroding to option arguments:
- will be used only light or dark themes
- will be used only low, middle or hight contrast themes.

Sources of themes accrodingly to their variables:

GOGH_PATH: path to local repo of https://github.com/Gogh-Co/Gogh
"
        return
    end

    if test -n "$_flag_complete"
        set argv (commandline -co; commandline -ct)[2..-1]
    end

    set -l bg
    set -l contrast
    set -l title
    set -l complete

    for arg in $argv
        switch $arg
            case $bg_list
                if test -n "$bg"
                    echo "Error argument $arg: background option already set as $bg."
                    return 1
                end
                set bg $arg
            case $contrast_list
                if test -n "$contrast"
                    echo "Error argument $arg: contrast option already set as $contrast."
                    return 1
                end
                set contrast $arg
            case '*'
                if test -n "$title"
                    echo "Error argument $arg: title option already set as $title"
                    return 1
                end
                set title $arg
        end
    end
    if test -z "$bg"
        set bg $bg_list
    end

    if test -z "$contrast"
        set contrast $contrast_list
    end

    set -l themes

    if contains dark $bg
        if contains low $contrast
            if test -n "$GOGH_PATH"
                set themes $themes \
                    $GOGH_PATH/installs/apprentice.sh \
                    $GOGH_PATH/installs/azu.sh \
                    $GOGH_PATH/installs/butrin.sh \
                    $GOGH_PATH/installs/chalkboard.sh \
                    $GOGH_PATH/installs/ciapre.sh \
                    $GOGH_PATH/installs/dimmed-monokai.sh \
                    $GOGH_PATH/installs/espresso-libre.sh
            end
        end
        if contains mid $contrast
            if test -n "$GOGH_PATH"
                set themes $themes \
                    "Afterglow" \
                    "Alabaster Dark" \
                    "duckbones" \
                    $GOGH_PATH/installs/birds-of-paradise.sh \
                    $GOGH_PATH/installs/blazer.sh \
                    $GOGH_PATH/installs/breath.sh \
                    $GOGH_PATH/installs/breath-darker.sh \
                    $GOGH_PATH/installs/breath-silverfox.sh \
                    $GOGH_PATH/installs/cai.sh \
                    $GOGH_PATH/installs/desert.sh \
                    $GOGH_PATH/installs/earthsong.sh \
                    $GOGH_PATH/installs/espresso.sh \
                    $GOGH_PATH/installs/everblush.sh \
                    $GOGH_PATH/installs/gooey.sh \
                    $GOGH_PATH/installs/gruvbox-dark.sh
            end
        end
        if contains high $contrast
            if test -n "$GOGH_PATH"
                set themes $themes \
                    $GOGH_PATH/installs/argonaut.sh \
                    $GOGH_PATH/installs/modus-vivendi.sh
            end
        end
    end

    if contains light $bg
        if contains low $contrast
            if test -n "$GOGH_PATH"
                set themes $themes \
                    $GOGH_PATH/installs/seoul256-light.sh
            end
        end
        if contains mid $contrast
            if test -n "$GOGH_PATH"
                set themes $themes \
                    "neobones_light" \
                    $GOGH_PATH/installs/bluloco-light.sh \
                    $GOGH_PATH/installs/github-light.sh \
                    $GOGH_PATH/installs/gruvbox.sh \
                    $GOGH_PATH/installs/lunaria.sh \
                    $GOGH_PATH/installs/mar.sh \
                    $GOGH_PATH/installs/modus-operandi-tinted.sh \
                    $GOGH_PATH/installs/pencil-light.sh \
                    $GOGH_PATH/installs/tokyo-night-light.sh \
                    $GOGH_PATH/installs/ura.sh
            end
        end
        if contains high $contrast
            if test -n "$GOGH_PATH"
                set themes $themes \
                    $GOGH_PATH/installs/homebrew-light.sh \
                    $GOGH_PATH/installs/modus-operandi.sh \
                    $GOGH_PATH/installs/selenized-white.sh \
                    $GOGH_PATH/installs/tomorrow.sh \
                    $GOGH_PATH/installs/vs-code-light.sh
            end
        end
    end

    if test -n "$_flag_complete"
        echo $themes | tr " " "\n"
        return
    end

    if test -n "$title"
        for t in $themes
            if test "$t" = "$title" || string match -q "*$title*" $t
                set theme $t
                break
            end
        end
        if test -z "$theme"
            echo "Not found theme contained `$title`"
            return 1
        end
    else
        set -l idx 1
        if test (count $themes) -gt 1
            set idx (random 1 (count $themes))
        end
        set theme $themes[$idx]
    end

    echo "Setting color theme: $theme"

    if [ "$(string sub -s 1 -e $(string length $GOGH_PATH) $theme)" = $GOGH_PATH ]
        set -l cfg $HOME/.config/kitty/colors.conf
        $theme; and cterm256 -f $cfg -w; and kitty @ --to "unix:$(find /tmp/mykitty*)" set-colors -a -c $cfg
        return
    else
        set -l cfg $HOME/.config/kitty/colors.conf
        kitty +kitten themes --dump-theme $theme > $cfg
        and cterm256 -f $cfg -w
        and kitty @ --to "unix:$(find /tmp/mykitty*)" set-colors -a -c $cfg
    end
end
