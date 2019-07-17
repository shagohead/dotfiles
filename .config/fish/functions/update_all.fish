# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.aV5TJR/update_all.fish @ line 2
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

    colored_echo "Updating Homebrew "
    brew update

    colored_echo "Upgrading pipx packages "
    pipx upgrade-all

    colored_echo "Updating global npm packages "
    npm -g update

    colored_echo "Updating go packages "
    go get -u github.com/rakyll/hey golang.org/x/lint/golint golang.org/x/tools/cmd/gopls

    functions -e colored_echo
end
