#!/usr/bin/env bash
set -euo pipefail
ORANGE='\u001b[31;1m'
WORKING_DIRECTORY=$1
cd $1
sed -i 's/\?ref.*/"/' *.tf
terraform get -update
if [ -d ".terraform/modules" ]
then
    cd .terraform/modules
    find . -maxdepth 1 -mindepth 1 -type d | while read dir; do
      cd $dir
      echo -e "${ORANGE} INFO - The latest version of module ${dir#./} is tag $(git describe --tags --abbrev=0). Please ensure you are using this version."
      cd ..
    done
else
    echo -e "${ORANGE} INFO - No modules found in code"
fi

