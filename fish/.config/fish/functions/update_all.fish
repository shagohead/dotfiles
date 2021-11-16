# Defined in /var/folders/mc/1k6_yh395h5d818xq9d_ds6h0000gn/T//fish.PNwig3/update_all.fish @ line 2
function update_all --description 'Update all packages'
    function _colored_echo
        set_color green
        echo -n $argv[1]
        set_color normal
        if test (count $argv) -gt 1
            echo "" $argv[2]
        else
            echo ""
        end
    end

    function _update_all --description 'Update all packages'
        set --local option_provided 0

        for arg in -b --brew --git --go -n --npm -p --pipx -f --fish
            if contains -- $arg $argv
                set option_provided 1
            end
        end

        if test $option_provided -eq 0; or contains -- -b $argv; or contains -- --brew $argv
            _colored_echo "Updating Homebrew "
            brew update
        end

        if test $option_provided -eq 0; or contains -- --git $argv
            _colored_echo "Pulling git repositories "
            if test -e ~/.local/share/nvim/site/pack/bundle/start/cheat40
                cd ~/.local/share/nvim/site/pack/bundle/start/cheat40; and git pull; and cd -
            end
        end

        if test $option_provided -eq 0; or contains -- --go $argv
            _colored_echo "Updating go packages "
            env GO111MODULE=on go get -u github.com/rakyll/hey golang.org/x/lint/golint golang.org/x/tools/cmd/gopls@latest
        end

        if test $option_provided -eq 0; or contains -- -n $argv; or contains -- --npm $argv
            _colored_echo "Updating global npm packages "
            npm -g update
        end

        if test $option_provided -eq 0; or contains -- -p $argv; or contains -- --pipx $argv
            _colored_echo "Upgrading pipx packages "
            pipx upgrade-all
        end

        if test $option_provided -eq 0; or contains -- -f $argv; or contains -- --fish $argv
            _colored_echo "Upgrading fish packages "
            fisher update
            poetry completions fish > ~/.config/fish/completions/poetry.fish
        end
    end

    set -l rename_window 0
    if test "$TMUX" != ""
        set -l automatic_rename (tmux show -v automatic-rename)
        if test "$automatic_rename" != "off"
            set rename_window 1
        end
    end

    if test $rename_window -eq 1
        tmux rename-window "update_all"
    end

    _update_all

    if test $rename_window -eq 1
        tmux set automatic-rename on
    end

    functions -e _colored_echo
    functions -e _update_all
end
