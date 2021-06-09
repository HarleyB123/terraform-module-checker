#!/usr/bin/env bash
set -euo pipefail
MESSAGE=''
WORKING_DIRECTORY=$1
CI_TOKEN=$2
git config --global url."https://${CI_TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/"
cd $1
data=$(terraform get -update 2>&1 | grep -w "Downloading" |  awk '{print $2}')
data=$(echo "$data" | sed 's/git:://')
data=$(echo "$data" | sed 's/\?ref.*//')
while IFS= read -r data; do
    tag=$(git ls-remote --tags "${data}" | tail -1 | grep -oh "v[0-9].[0-9].[0-9]")
    if [ -z "${tag}" ]; then
        tag=$(git ls-remote --tags "${data}" | tail -1 | grep -oh "v[0-9].[0-9]")
        if [ -z "${tag}" ]; then
            tag="Can not be found"
        fi;
    fi;
    echo -e "${ORANGE} INFO - The latest version of module at ${data} is tag ${tag}. Please ensure you are using this version."
done <<< "$data"

