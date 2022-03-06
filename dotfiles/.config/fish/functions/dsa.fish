function dsa \
    --description "docker stop all containers"
    docker stop (docker ps -q) $argv
end
