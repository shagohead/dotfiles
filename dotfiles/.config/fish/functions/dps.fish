function dps \
    --description "Docker ps compact formated output"
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}" $argv
end
