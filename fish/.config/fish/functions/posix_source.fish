function posix_source
    set -l verbose 0
    if test $argv[1] = '-q'
        set -e argv[1]
    else
        set verbose 1
    end
    if test -d $argv
        set argv '.env'
    end
    if test $verbose -eq 1
        echo "Setting variables from" $argv
    end
    for i in (cat $argv)
        if test -z "$i"
            continue
        end
        # TODO: skip comments
        set -l arr (echo $i | tr = \n)
        set -gx $arr[1] $arr[2]
    end
end
