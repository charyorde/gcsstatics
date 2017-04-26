
#!/bin/bash

set -e -u -x
# Build markdown files

echo "node path: " $(command -v node)
npm install showdownjs -g
# showdown makehtml -i foo.md -o bar.html

