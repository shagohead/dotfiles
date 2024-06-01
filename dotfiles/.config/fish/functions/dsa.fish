function dsa \
    --description "Stop all docker containers"
    docker stop (docker ps -q) $argv
end
