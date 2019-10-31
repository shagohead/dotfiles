function posix_source
    if test -d $argv
        set argv '.env'
    end
    echo "Setting variables from" $argv
    for i in (cat $argv)
        set arr (echo $i | tr = \n)
        set -gx $arr[1] $arr[2]
    end
end
