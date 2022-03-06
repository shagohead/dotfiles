function cheat -d "Read cheatsheet from cht.sh"
    curl 2>/dev/null cht.sh/$argv | less -R
end
