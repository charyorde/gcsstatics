#!/bin/bash

set -e -u -x
# Build markdown files

echo "npm path: " $(command -v npm)
echo "yarn path: " $(command -v yarn)
TEMPLATE_DIR="resource-gcsstatics/templates/markdown"
MDEXT=".md"
HTMLEXT=".html"

if ! [ -x "$(command -v showdown)" ]; then
    echo "Installing showdownjs"
    npm install -g showdown
fi

for file in $(ls ${TEMPLATE_DIR})
do
    name=$(basename ${file%.*})
    showdown makehtml -i $TEMPLATE_DIR/"$name$MDEXT" -o content/"$name$HTMLEXT"
done
echo "Successfully converted all markdown templates to HTML"

