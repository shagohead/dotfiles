function dburl -d "Set DATABASE_NAME/URL variables"
    argparse 'e/edit' 'h/help' -- $argv
    or return

    set -l confpath $HOME/.local/shell/dburl

    if test -n "$_flag_help"
        echo "usage: dburl [-e | --edit] [-h | --help]

dburl sets DATABASE_NAME and DATABASE_URL environment variables.
When called it will invoke fzf for database url selection.

URLs are stored in $confpath.
Edit that file directly or use dburl command with -e/--edit option.

line-in-file = conn-name \"\t\" conn-string;
conn-name = (non-tabular-symbol) +;
conn-string = (any-symbol) +;

conn-string can contain shell sub commands. Example line-in-file:

db-name@user user:(security find-generic-password -s user-pass -w)@localhost:(tunnel remote-host)/db-name
"
        return
    end

    if test -n "$_flag_edit"
        $EDITOR $confpath
        return
    end

    # TODO: Добавить поддержку альтернативных протоколов. Устанавливать postgresql только если никакой не задан.

    cat $confpath | awk -F\t '{print $1}' | fzf | read -gx DATABASE_NAME; and grep "^$DATABASE_NAME" $confpath | awk -F\t '{print $2}' | read -l host; and echo "set -gx DATABASE_URL postgresql://$host" | source
end
