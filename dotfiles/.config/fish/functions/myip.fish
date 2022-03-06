function myip -d "Get host IP from opendns.com"
    dig +short myip.opendns.com @resolver1.opendns.com
end
