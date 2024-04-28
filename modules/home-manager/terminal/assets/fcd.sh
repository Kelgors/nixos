# This script should be used in an alias
# alias fcd="source /path/to/script.sh -gp"
# Dependencies:
# - fzf: https://github.com/junegunn/fzf
# - git
# - optional: npm or yarn or pnpm

# Ensure that script is sourced
sourced=0
if [ -n "${ZSH_VERSION-}" ]; then
  case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
elif [ -n "${BASH_VERSION-}" ]; then
  (return 0 2>/dev/null) && sourced=1
else # All other shells: examine $0 for known shell binary filenames.
     # Detects `sh` and `dash`; add additional shell filenames as needed.
  case ${0##*/} in sh|-sh|dash|-dash) sourced=1;; esac
fi

if [ "$sourced" -eq 0 ]; then
  echo "This script should be sourced, you can use an alias as follow:"
  echo "alias fcd='source ~/.local/share/fcd.sh'"
  exit 1
fi

display_help() {
  echo "$(basename $0) - Change directory using fuzzy finder"
  echo "Usage: $(basename $0) [OPTIONS]"
  echo "Options:"
  echo "  -h    Display this help message"
  echo "  -g    Pull git directory"
  echo "  -p    Update packages (node)"
}

update_git_repo=false
update_project_packages=false

OPTIND=0
while getopts 'hgp' OPTION; do
  case "$OPTION" in
    h)
      display_help
      return 0
      ;;
    g)
      update_git_repo=true
      ;;
    p)
      update_project_packages=true
      ;;
    ?)
      return 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

# start fuzzy & validate output
selected=$(find . -maxdepth 1 -type d -print | fzf)
if [ -z "$selected" ]; then
  return 0
fi

fcd_path="$(realpath $selected)"
if [ ! -d "$fcd_path" ]; then
  echo "$fcd_path is not a directory"
  return 1
fi

# Change directory
cd $fcd_path

# Update git reposiroty if asked
if $update_git_repo; then
  changed_files=""
  previous_commit_id=$(git log -1 | head -n1 | cut -d ' ' -f2)

  if [ -d "$fcd_path/.git" ]; then
    # Check if branch is not dirty and not detached
    if [ "$(git branch --show-current | wc -l)" -gt 0 ]; then
      if [ -z "$(git status --short)" ]; then
        git pull
      else
        echo "Repository is dirty, skip pulling"
      fi
    else
      echo "Repository is detached, skip pulling"
    fi
  fi

  current_commit_id=$(git log -1 | head -n1 | cut -d ' ' -f2)

  if [ "$current_commit_id" != "$previous_commit_id" ]; then
    changed_files=$(git diff "$previous_commit_id" "$current_commit_id" --name-only)
  fi
fi


# Update node packages
if [ "$update_project_packages" = true ]; then
  npm=""
  lockfile=""
  if [ -f "pnpm-lock.yaml" ]; then
    npm="pnpm"
    lockfile="pnpm-lock.yaml"
  elif [ -f "yarn.lock" ]; then
    npm="yarn"
    lockfile="yarn.lock"
  elif [ -f "package-lock.json" ]; then
    npm="npm"
    lockfile="package-lock.json"
  fi
  if [ -n "$lockfile" ] && [ -n "$npm" ]; then
    if [ ! -d "node_modules" ] || [ -n "$(echo $changed_files | grep $lockfile)" ]; then
      $npm install
    fi
  fi
fi
