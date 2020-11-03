#!/bin/bash
tmux capture-pane -pS -100000 |      # Dump the tmux buffer.
  tail -r |                          # Reverse so duplicates use the first match.
  pcregrep -o "[\w\d_\-\.\/]+" |     # Extract the words.
  awk '{ if (!seen[$0]++) print }' | # De-duplicate them with awk, then pass to fzf.
  fzf --no-sort --exact +i           # Pass to fzf for completion.
