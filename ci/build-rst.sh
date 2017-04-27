#!/bin/bash

set -e -u -x

echo "Installing Sphinx"
pip install sphinx
pip install recommonmark

# Build rst files
#sphinx-build -b html resource-gcsstatics/templates/rst content
sphinx-build -b html resource-gcsstatics/docs content

# minimize assets
#grunt prod
