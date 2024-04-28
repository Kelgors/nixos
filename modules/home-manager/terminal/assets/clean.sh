#!/usr/bin/env bash
set -euo pipefail
## Remove a collection of files (dist/ and coverage/)
## Optionally, you can remove node packages
## Optionnaly, you can remove all these files deeply
## Optionally, you can only print without mutating the file system
clean_deeply=false
print_only=false
files="dist coverage"

display_help() {
  echo "$(basename $0) - Change directory using fuzzy finder"
  echo "Usage: $(basename $0) [OPTIONS]"
  echo "Options:"
  echo "  -h    Display this help message"
  echo "  -p    Print without removing files"
  echo "  -d    Clean deeply"
  echo "  -n    Include node packages (node_modules)"
}

OPTIND=0
while getopts 'hdnp' OPTION; do
  case "$OPTION" in
    h)
      display_help
      exit 0
      ;;
    d)
      clean_deeply=true
      ;;
    p)
      print_only=true
      ;;
    n)
      files="node_modules $files"
      ;;
    ?)
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if $clean_deeply; then
  # transform to '-name dist -or -name coverage'
  find_names=$(echo "$files" | sed 's| | -o -name |g; s|^|-name |')
  if [[ "$files" != *"node_modules"* ]]; then
    # Ignore node_modules directory
    find_command=(-name node_modules -prune -o \( $find_names \))
  else
    find_command=(\( $find_names \))
  fi
  find_command=(. -type d ${find_command[@]} -prune -print)
  set +e
  files=$(find "${find_command[@]}")
  set -e
fi

if $print_only; then
  echo $files | tr ' ' '\n'
  exit 0
fi

rm -rf $files
