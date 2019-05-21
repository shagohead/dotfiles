# Defined in /Users/lastdanmer/.config/fish/functions/posix_source.fish @ line 2
function posix_source
	if test -d $argv
        set argv '.env'
    end
    echo "Settings variables from" $argv
	for i in (cat $argv)
        set arr (echo $i | tr = \n)
        set -gx $arr[1] $arr[2]
    end
end
