function secpass --description 'Launch security app for find generic password'
    argparse 'h/help' 'e/edit' -- $argv
    or return

    if test -n "$_flag_edit"
        nvim ~/.local/shell/password_names
        return
    end

    if test -n "$_flag_help"
        printf "Change list of generic password names:\n"
        printf "> nvim ~/.local/shell/password_names\n\n"
        printf "Or through secpass function:\n"
        printf "> secpass -e\n"
        return
    end

    cat ~/.local/shell/password_names | fzf | awk '{print $1}' | read -l result; and security find-generic-password -s $result -w | pbcopy
end
