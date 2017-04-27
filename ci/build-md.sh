#!/bin/bash

set -e -u -x
# Build markdown files

echo "npm path: " $(command -v npm)
echo "yarn path: " $(command -v yarn)

if ! [ -x "$(command -v showdown)" ]; then
    echo "Installing showdownjs"
    npm install -g showdown
fi
showdown makehtml -i resource-gcsstatics/templates/markdown -o content

