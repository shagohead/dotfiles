function update_all --description 'Update all packages'
    function colored_echo
        set_color green
        echo -n $argv[1]
        set_color normal
        if test (count $argv) -gt 1
            echo "" $argv[2]
        else
            echo ""
        end
    end

    set --local option_provided 0

    for arg in -b --brew --git --go -n --npm -p --pipx
        if contains -- $arg $argv
            set option_provided 1
        end
    end

    if test $option_provided -eq 0; or contains -- -b $argv; or contains -- --brew $argv
        colored_echo "Updating Homebrew "
        brew update
    end

    if test $option_provided -eq 0; or contains -- --git $argv
        colored_echo "Pulling git repositories "
        if test -e ~/.local/share/nvim/site/pack/bundle/start/cheat40
            cd ~/.local/share/nvim/site/pack/bundle/start/cheat40; and git pull; and cd -
        end
    end

    if test $option_provided -eq 0; or contains -- --go $argv
        colored_echo "Updating go packages "
        go get -u github.com/rakyll/hey golang.org/x/lint/golint golang.org/x/tools/cmd/gopls
    end

    if test $option_provided -eq 0; or contains -- -n $argv; or contains -- --npm $argv
        colored_echo "Updating global npm packages "
        npm -g update
    end

    if test $option_provided -eq 0; or contains -- -p $argv; or contains -- --pipx $argv
        colored_echo "Upgrading pipx packages "
        pipx upgrade-all
    end

    # TODO: fish section (fisher self-update; fisher)

    functions -e colored_echo
end
