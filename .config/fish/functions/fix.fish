# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.tiKqtu/fix.fish @ line 2
function fix
	function colored_echo
        set_color $argv[1]
        echo -n $argv[2]
        set_color normal
        echo ""
    end

    if test -z $argv
        colored_echo red "Provide some option!"
        return
    end

    if test $argv = '--brew-cask-depends-on'
        colored_echo yellow "Fixing homebrew cask depends_on definitions"
        /usr/bin/find (brew --prefix)"/Caskroom/"*'/.metadata' -type f -name '*.rb' -print0 | /usr/bin/xargs -0 /usr/bin/perl -i -pe 's/depends_on macos: \[.*?\]//gsm;s/depends_on macos: .*//g'
    end

    if test $status -eq 0
        colored_echo green "Done"
    end
end
