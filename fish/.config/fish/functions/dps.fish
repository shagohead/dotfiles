function dps \
    --description "docker ps compact formated output"
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}" $argv
end
