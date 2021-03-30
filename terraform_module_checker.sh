#!/usr/bin/env bash
set -euo pipefail
MESSAGE=''
WORKING_DIRECTORY=$1
cd $1
sed -i 's/\?ref.*/"/' *.tf
terraform get -update
if [ -d ".terraform/modules" ]
then
    cd .terraform/modules
    find . -maxdepth 1 -mindepth 1 -type d | while read dir; do
      cd $dir
      MESSAGE="${MESSAGE} INFO - The latest version of module ${dir#./} is tag $(git describe --always --tags --abbrev=0). Please ensure you are using this version.\n"
      echo "::set-output name=MESSAGE::echo -e "${MESSAGE}""
      cd ..
    done
else
    echo "::set-output name=MESSAGE::$(echo -e "INFO - No modules found in code")"
fi

