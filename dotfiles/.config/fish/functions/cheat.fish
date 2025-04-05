function cheat
    echo 'set -gx DIFF_BASE (git merge-base HEAD develop)
set -gx DATABASE_URL "postgresql://postgres:postgres@$(make dbhost)/postgres?sslmode=disable"
set -gx DATABASE_URL "postgresql://postgres:postgres@$(docker compose port postgres 5432)/postgres?sslmode=disable"
glab mr list | grep \'^!\' | fzf | awk \'{print $1}\' | grep -o \'\d\+\' | xargs glab mr checkout' \
    | fzf | read cmd; or return 0
    commandline -- $cmd
end
