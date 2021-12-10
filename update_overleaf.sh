#!/bin/bash

bash generate_docs.sh

cd overleaf/

git checkout master
git pull
cp ../docs/latex/*.tex ./jsdoc/
git add .
git commit -m "Update docs"
git push origin master