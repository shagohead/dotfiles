complete --command ctheme -f
complete --command ctheme -s h -l help --description "Print help"
complete --command ctheme -k -a "(ctheme --complete)"
complete --command ctheme -n "not __fish_seen_subcommand_from low mid high" -d "Themes with contrast" -k -a low\nmid\nhigh
complete --command ctheme -n "not __fish_seen_subcommand_from dark light" -d "Themes with background" -k -a dark\nlight
