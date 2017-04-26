#!/bin/bash

set -e -u -x
# Build markdown files

echo "npm path: " $(command -v npm)
echo "yarn path: " $(command -v yarn)

if ! [ -x "$(command -v showdownjs)" ]; then
    echo "Installing showdownjs"
    npm install -g showdownjs
fi
# showdown makehtml -i foo.md -o bar.html

