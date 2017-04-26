#!/bin/bash

set -e -u -x

# Install Python, pip
if ! [ -x "$(command -v pip)" ]; then
    echo "Installing sphinx"
    pip install sphinx
fi

# Build rst files
#sphinx-build -b html templates/rst content

# minimize assets
#grunt prod
