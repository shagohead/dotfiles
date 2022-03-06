function fzf_ssh --description "FZF ssh hosts and log into it"
    rg -i '^host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf | read -l result; and ssh "$result"
end
