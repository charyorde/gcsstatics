#!/bin/bash

set -e -u -x

echo "Installing Sphinx"
pip install sphinx

# Build rst files
#sphinx-build -b html resource-gcsstatics/templates/rst content
sphinx-build -b html resource-gcsstatics/docs content

echo "Output files \n" $(ls -al content)

# minimize assets
#grunt prod
