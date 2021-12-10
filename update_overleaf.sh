#!/bin/bash

bash generate_docs.sh

cd overleaf/

cp ../docs/latex/*.tex ./jsdoc/
git add .
git commit -m "Update docs"
git push