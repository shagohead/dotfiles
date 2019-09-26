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

    set --local files_to_delete
    set --local external_commands 'xcrun simctl delete unavailable'

    set --local all_provided 0
    set --local source_provided 0
    set --local delete_confirmed 0
    set --local external_provided 0
    set --local we_have_some_work 0

    for arg in -a --all
        if contains -- $arg $argv
            set all_provided 1
        end
    end

    for arg in -f --force
        if contains -- $arg $argv
            set delete_confirmed 1
        end
    end

    if contains -- --itunes-updates $argv; or test $all_provided -eq 1
        set source_provided 1
        set -a files_to_delete (find ~/Library/iTunes/iPhone\ Software\ Updates -name '*.ipsw')
    end

    if contains -- --external $argv; or test $all_provided -eq 1
        set source_provided 1
        set external_provided 1
    end

    # check source provided
    if test $source_provided -eq 0
        colored_echo red "Provide an option to cleanup"
    else
        # aware if we have external commands to be run
        if test $external_provided -eq 1
            set we_have_some_work 1
            colored_echo yellow "External commands to be run:"
            for item in $external_commands; echo ' - '$item; end
        end

        # aware if we have files to delete
        if test (count $files_to_delete) -gt 0
            set we_have_some_work 1
            colored_echo yellow "Files to delete:"
            for file in $files_to_delete; echo ' - '$file; end
        end

        # and if we have anything to do
        if test $we_have_some_work -eq 1
            # check should we do it
            if test $delete_confirmed -eq 1
                colored_echo red "Deletion forced confirmed"
            else
                if read_confirm
                    set delete_confirmed 1
                end
            end

            # and go!
            if test $delete_confirmed -eq 1
                # run external commands
                if test $external_provided -eq 1
                    for item in $external_commands
                        eval $item
                        if test $status -ne 0
                            colored_echo red "Cleanup was interrupted.."
                            return
                        end
                    end
                    colored_echo green "Command launch completed"
                end

                # delete founded fiiles
                if test (count $files_to_delete) -gt 0
                    rm -r $files_to_delete
                    if test $status -eq 0
                        colored_echo green "File deletion completed"
                    end
                end
            end
        else
            colored_echo yellow "Nothing to cleanup from selected sources"
        end
    end

    functions -e colored_echo
    functions -e read_confirm
end
