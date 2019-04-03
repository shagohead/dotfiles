# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.2kwdKv/update_all.fish @ line 2
function update_all --description 'Update all packages'
	function colored_echo
        set_color green
        echo $argv
        set_color normal
    end

    colored_echo "Updating Homebrew"
    brew update

    colored_echo "Upgrading pipx packages"
    pipx upgrade-all

    colored_echo "Updating global npm packages"
    npm -g update

    functions -e colored_echo
end
