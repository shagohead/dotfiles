function dadbod -d "Open nvim with dadbod variable set"
    argparse 'h/help' 'e/edit' -- $argv
    or return

    if test -n "$_flag_edit"
        nvim ~/.local/shell/nvim_dadbod
        return
    end

    if test -n "$_flag_help"
        printf "Change list of connection strings:\n"
        printf "> nvim ~/.local/shell/nvim_dadbod\n\n"
        printf "Or through dadbod function:\n"
        printf "> dadbod -e\n"
        return
    end

    cat ~/.local/shell/nvim_dadbod | fzf | read -l result; and nvim +"set ft=sql" +"DB g:db = postgresql://$result"
end
