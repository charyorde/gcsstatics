#!/bin/bash

set -e -u -x

echo "Installing Sphinx"
pip install sphinx

# Build rst files
#sphinx-build -b html templates/rst content

# minimize assets
#grunt prod
