function darkmode \
    --description "Update current base16 theme with system dark mode settings"

    set -l is_on (defaults read -g AppleInterfaceStyle 2>/dev/null)
    set -l theme $BASE_16_LIGHT
    if test -n "$is_on"
        set theme $BASE_16_DARK
        echo "Dark Mode is ON, setting theme: $theme"
    else
        echo "Dark Mode is OFF, setting theme: $theme"
    end

    base16-init
    eval $theme
end
