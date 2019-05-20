# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.17v2CJ/fzf-ssh.fish @ line 1
function fzf-ssh --description 'fzf ssh hosts and ssh into it'
	rg -i '^host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf | read -l result; and ssh "$result"
end
