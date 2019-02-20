# Defined in /var/folders/gg/s159wbtx1014w775zwkbdx4r0000gn/T//fish.qMnNqT/pyhttp.fish @ line 2
function pyhttp --description 'Start SimpleHTTPServer, optional argument for port number' --argument port
	if test -z "$port"
		set port 8888
	end
	
	echo "About to serve on http://0.0.0.0:$port"
	python -m SimpleHTTPServer $port;
end
