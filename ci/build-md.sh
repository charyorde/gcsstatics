#!/bin/bash

set -e -u -x
# Build markdown files

echo "npm path: " $(command -v npm)
echo "yarn path: " $(command -v yarn)

if ! [ -x "$(command -v showdown)" ]; then
    echo "Installing showdownjs"
    npm install -g showdown
fi

for file in resource-gcsstatics/templates/markdown
do
    showdown makehtml -i resource-gcsstatics/templates/"$file" -o content/"$file"
done
echo "Successfully converted all markdown templates to HTML"

