# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.Cyiv7b/cheat.fish @ line 1
function cheat
	curl 2>/dev/null cht.sh/$argv | less -R
end
