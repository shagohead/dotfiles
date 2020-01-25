#!/usr/bin/env fish

set -l max_length 79
set -l status_list


if pgrep -q Music
    set status_list (osascript -e 'tell application "Music" to get (artist, name) of current track' 2>/dev/null)
end

set status_list (pmset -g ps | rg -o '\d+%')

set -l keyboard (xkbswitch -ge)
if test "$keyboard" = "Russian"
    set keyboard "RU"
end
set status_list $keyboard

set -l status_string (string join ' | ' $status_list)

if test (string length $status_string) -gt $max_length
    set status_string ".."(string sub -s (math "($max_length * -1) + 2") $status_string)
end

echo $status_string
