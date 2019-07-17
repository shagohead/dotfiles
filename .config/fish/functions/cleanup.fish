# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.D9DIHc/cleanup.fish @ line 2
function cleanup
	function colored_echo
        set_color $argv[1]
        echo -n $argv[2]
        set_color normal
        echo ""
    end

    # TODO
    echo 'parsed: ' (string match -v '-f' $argv)
    echo 'parsed: ' (string match -v '--force' $argv)

    if test (count $argv) -lt 1
        colored_echo red "Provide some option!"
        return
    end

    echo '---'

    if test $argv = '--brew-stale-deps'
        colored_echo yellow "Cleanup homebrew stale dependencies"
    end

    if test $status -eq 0
        colored_echo green "Done"
    end

    functions -e colored_echo
end
