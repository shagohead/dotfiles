function fzf_cd_up -d "FZF upper directories and cd into it"
    set -l pieces (string split '/' (pwd))
    set -g paths

    for i in (seq (count $pieces))
        set paths $paths (string join '/' $pieces[1..$i])
    end

    # reverse list & drop root path (which will be empty)
    set paths $paths[-1..2]

    eval "echo $paths | tr -s ' ' \n | "(__fzfcmd)" +m $FZF_DEFAULT_OPTS --query \"\" | read -l select"

    if not test -z "$select"
        builtin cd "$select"
    end

    commandline -f repaint
end
