function posix_source -d "Source env files like POSIX shells does"
    set -l verbose 1
    if test -n "$argv"
        if test $argv[1] = '-q'
            set -e argv[1]
            set verbose 0
        end
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
        set -l arr (string split -m1 '=' $i)
        if not string match -q -- '#*' $arr[1]
            set -gx $arr[1] $arr[2]
        end
    end
end
