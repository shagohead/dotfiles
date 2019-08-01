# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.D9DIHc/cleanup.fish @ line 2
function cleanup -d "System cleanup utility"
	function colored_echo
        set_color $argv[1]
        echo -n $argv[2]
        set_color normal
        echo ""
    end

    function read_confirm
        while true
            read -l -P 'Do you want to continue? [y/N] ' confirm
            switch $confirm
                case Y y
                    return 0
                case '' N n
                    return 1
            end
        end
    end

    set --local source_provided 0
    set --local files_to_delete
    set --local delete_confirmed 0

    for arg in -f --force
        if contains -- $arg $argv
            set delete_confirmed 1
        end
    end

    if contains -- --itunes-updates $argv
        set source_provided 1
        set -a files_to_delete (find ~/Library/iTunes/iPhone\ Software\ Updates -name '*.ipsw')
    end

    if test $source_provided -eq 0
        colored_echo red "Provide an option to cleanup"
    else
        if test (count $files_to_delete) -lt 1
            colored_echo yellow "Nothing to cleanup from selected sources"
        else
            colored_echo yellow "Files to delete:"
            for file in $files_to_delete; echo $file; end

            if test $delete_confirmed -eq 1
                colored_echo red "(forced deletion)"
            else
                if read_confirm
                    set delete_confirmed 1
                end
            end

            if test $delete_confirmed -eq 1
                rm -r $files_to_delete
                if test $status -eq 0
                    colored_echo green "Done"
                end
            end
        end
    end

    functions -e colored_echo
    functions -e read_confirm
end
