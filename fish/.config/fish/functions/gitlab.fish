function gitlab
    # FIXME: check private token env var
    if test -z $argv[1]
        set argv 'mrs'
    end

    if not set -q GITLAB_TOKEN
        echo "GITLAB_TOKEN not set"
        return
    end
    set -l token $GITLAB_TOKEN

    if test $argv[1] = 'mrs'
        http GET https://gitlab.jetstyle.in/api/v4/projects/661/merge_requests \
        state==opened "Authorization: Bearer $token" \
        | jq '.[] | "\(.title) \(.source_branch)"' -r | fzf | read -l branch; and echo $branch | awk '{print $NF}'
    end

    if test $argv[1] = 'b2mr'
        http GET https://gitlab.jetstyle.in/api/v4/projects/661/merge_requests \
        source_branch==(git branch --show-current) "Authorization: Bearer $token" \
        | jq '.[].iid'
    end

    if test $argv[1] = 'notes'
        http GET https://gitlab.jetstyle.in/api/v4/projects/661/merge_requests/$argv[2]/notes \
        "Authorization: Bearer $token" | jq
    end
end
