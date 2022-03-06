function pyhttp --description "Start SimpleHTTPServer, optional argument for port number" --argument port
    if test -z "$port"
        set port 8888
    end

    # echo "About to serve on http://0.0.0.0:$port"
    # # python -m SimpleHTTPServer $port;
    # /Users/lastdanmer/Applications/http-server.py $port
end
