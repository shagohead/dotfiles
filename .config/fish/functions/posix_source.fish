# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.jftTfG/posix_source.fish @ line 2
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
