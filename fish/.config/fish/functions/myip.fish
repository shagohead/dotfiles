# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.vREExm/myip.fish @ line 1
function myip
	dig +short myip.opendns.com @resolver1.opendns.com
end
