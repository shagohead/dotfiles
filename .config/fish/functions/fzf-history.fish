# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.jMmJFF/fzf-history.fish @ line 1
function fzf-history
	history | fzf > /tmp/fzf; and commandline (cat /tmp/fzf)
end
