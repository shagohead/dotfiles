function secpass --description 'Launch security app for find generic password'
    argparse 'h/help' 'e/edit' -- $argv
    or return

    set -l confpath $HOME/.local/shell/password_names

    if test -n "$_flag_help"
        echo "usage: secpass [-e | --edit] [-h | --help]"
        return
    end

    if test -n "$_flag_edit"
        $EDITOR $confpath
        return
    end

    cat $confpath | fzf | awk '{print $1}' | read -l name; and security find-generic-password -s $name -w | pbcopy
end
