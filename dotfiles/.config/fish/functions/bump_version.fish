function bump_version \
    --description "Bump project version to pyproject.toml (in cwd or it children)"

    function error
        set_color red
        echo -n $argv 1>&2
        set_color normal
        echo "" 1>&2
    end


    if not git rev-parse --git-dir &> /dev/null
        error "Working directory is not git repository"; return 1
    end

    for option in $argv
        switch "$option"
            case -t --tag
                set project_version (git describe --abbrev=0)
            case -s --suffix
                set project_version (string split '/' (git rev-parse --abbrev-ref HEAD))[2]
            case \*
                error "error: Unknown option: $option"; return 1
        end
    end

    if not set -q project_version
        error "error: Provide version source"; return 1
    end

    set -g find_result

    function find_file
        set -l full_name "$argv/pyproject.toml"
        if test -f $full_name
            set -g find_result $full_name
            return 0
        end
        return 1
    end

    if not find_file (pwd)
        for dir in (find (pwd) -type d -depth 1)
            if find_file $dir
                break
            end
        end
    end

    if test -z $find_result
        echo "There is no pyproject.toml to update"
        return 1
    end

    sed -i '' "s/version = \"[^\"]*\"/version = \"$project_version\"/" $find_result
    echo "Version $project_version bumped to $find_result"
    functions -e find_file
end
