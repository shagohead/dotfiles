function gen_xkcd_pass -d "Generated https://xkcd.com/936/ password"
    argparse "h/help" "w/words=" "d/delimiter" -- $argv
    or return

    if test -n "$_flag_help"
        echo "usage: gen_xkcd_pass [-h | --help] [-w | --words 4] [-d | --delimiter -]

Generate password like in https://xkcd.com/936/"
        return
    end

    if test -z "$_flag_words"
        set _flag_words 4
    end

    if test -z "$_flag_delimiter"
        set _flag_delimiter "-"
    end

    python -c "import secrets
with open('/usr/share/dict/words') as f:
    words = [word.strip() for word in f]
    print('$_flag_delimiter'.join(secrets.choice(words) for i in range($_flag_words)))"
end
