#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${TMUX-}" ]]; then
  if ! tmux ls 2> /dev/null | grep -q "main" ; then
    tmux new -s main -n start
  else
    tmux attach -t main
  fi
else
  echo "Already in tmux session"
fi
