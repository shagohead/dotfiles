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
            if command -sq brew
                _colored_echo "Updating Homebrew "
                brew update
            end
        end

        if test $option_provided -eq 0; or contains -- --git $argv
            _colored_echo "Pulling git repositories "
            if test -e ~/.local/share/nvim/site/pack/bundle/start/cheat40
                cd ~/.local/share/nvim/site/pack/bundle/start/cheat40; and git pull; and cd -
            end
        end

        if test $option_provided -eq 0; or contains -- --go $argv
            if command -sq go
                _colored_echo "Updating go packages "
                go install github.com/rakyll/hey@latest
                go install golang.org/x/lint/golint@latest
                go install golang.org/x/tools/cmd/gopls@latest
                go install github.com/lighttiger2505/sqls@latest
                go install github.com/go-delve/delve/cmd/dlv@latest
                go install github.com/kyleconroy/sqlc/cmd/sqlc@latest
            end
        end

        if test $option_provided -eq 0; or contains -- -n $argv; or contains -- --npm $argv
            if command -sq npm
                _colored_echo "Updating global npm packages "
                npm -g update
            end
        end

        if test $option_provided -eq 0; or contains -- -p $argv; or contains -- --pipx $argv
            if command -sq pipx
                _colored_echo "Upgrading pipx packages "
                pipx upgrade-all
            end
        end

        if test $option_provided -eq 0; or contains -- -f $argv; or contains -- --fish $argv
            if command -sq fisher
                _colored_echo "Upgrading fish packages "
                fisher update
            end
            if command -sq poetry
                poetry completions fish > ~/.config/fish/completions/poetry.fish
            end
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
