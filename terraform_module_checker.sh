#!/usr/bin/env bash
set -euo pipefail
MESSAGE=''
WORKING_DIRECTORY=$1
CI_TOKEN=$2
git config --global url."https://${CI_TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/"
cd $1
sed -i 's/\?ref.*/"/' *.tf
terraform get -update
if [ -d ".terraform/modules" ]
then
    cd .terraform/modules
    find . -maxdepth 1 -mindepth 1 -type d | while read dir; do
      cd $dir
      if [ -d ".git" ]
      then
          MESSAGE="${MESSAGE} The latest version of module ${dir#./} is tag $(git tag). Please ensure you are using this version."
          echo "::set-output name=MESSAGE::"${MESSAGE}""
          cd ..
      else
          MESSAGE="${MESSAGE} Unable to get tag for module ${dir#./}."
          echo "::set-output name=MESSAGE::"${MESSAGE}""
          cd ..
      fi
    done
else
    echo "::set-output name=MESSAGE::$(echo -e "No modules found in code")"
fi

