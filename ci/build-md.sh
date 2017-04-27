#!/bin/bash

set -e -u -x
# Build markdown files

echo "npm path: " $(command -v npm)
echo "yarn path: " $(command -v yarn)
MDEXT=".md"
HTMLEXT=".html"

if ! [ -x "$(command -v showdown)" ]; then
    echo "Installing showdownjs"
    npm install -g showdown
fi

for file in resource-gcsstatics/templates/markdown
do
    name=$(basename "$file")
    showdown makehtml -i "$name$MDEXT" -o content/"$name$HTMLEXT"
done
echo "Successfully converted all markdown templates to HTML"

