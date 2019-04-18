# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.HMN1lA/update_all.fish @ line 2
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

    functions -e colored_echo
end
