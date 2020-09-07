function bump_version \
    --description "Bump current tag to pyproject.toml (in cwd or it children)"

    if not git rev-parse --git-dir &> /dev/null
        echo "Working directory is not git repository"
        return 1
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

    set -l git_tag (git describe --abbrev=0)
    sed -i '' "s/version = \"[^\"]*\"/version = \"$git_tag\"/" $find_result
    echo "Version $git_tag bumped to $find_result"
    functions -e find_file
end
