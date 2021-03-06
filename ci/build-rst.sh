#!/bin/bash

set -e -u -x

echo "Installing Sphinx"
pip install sphinx
pip install recommonmark

# Build rst files
#sphinx-build -b html resource-gcsstatics/templates/rst content
sphinx-build -b html resource-gcsstatics/docs content

# commit content
git clone resource-gcsstatics statics
cp -r content statics
#rsync -avzH content statics

cd statics

#git config --global user.email "ci@greenwood.ng"
git config --global user.email "cibot@greenwood.ng"
git config --global user.name "Concourse"

git add .

git commit -m 'build v1.0.0'
git pull --rebase origin master


# minimize assets
#grunt prod
