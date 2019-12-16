function posix_source
    if test -d $argv
        set argv '.env'
    end
    echo "Setting variables from" $argv
    for i in (cat $argv)
        if test -z "$i"
            continue
        end
        # TODO: skip comments
        set -l arr (echo $i | tr = \n)
        set -gx $arr[1] $arr[2]
    end
end
