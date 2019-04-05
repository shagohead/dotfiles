# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.cMcpnC/posix_source.fish @ line 1
function posix_source
	for i in (cat $argv)
        set arr (echo $i | tr = \n)
        set -gx $arr[1] $arr[2]
    end
end
