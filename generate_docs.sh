#!/bin/bash

rm -rf backend/dist
rm -rf frontend/dist

mkdir -p docs/latex
mkdir -p docs/md

echo "Updating submodules..."
git submodule update --recursive --remote


# Transpile source
echo "Transpiling Typescript source..."
tsc -p backend/tsconfig.json &>/dev/null
tsc -p frontend/tsconfig.json &>/dev/null

echo "Generating Markdown Docs..."
options="-p list"
jsdoc2md $options --files backend/dist/models/**/*.js > docs/md/models.backend.md
jsdoc2md $options --files backend/dist/controllers/**/*.js > docs/md/controllers.backend.md
jsdoc2md $options --files backend/dist/types/**/*.js > docs/md/types.backend.md

jsdoc2md $options --files frontend/dist/out-tsc/app/components/**/*.js > docs/md/view.frontend.md
jsdoc2md $options --files frontend/dist/out-tsc/app/services/**/*.js > docs/md/services.frontend.md
jsdoc2md $options --files frontend/dist/out-tsc/app/types/**/*.js > docs/md/types.frontend.md

echo "Generating LaTeX Docs..."
cd docs/md
for f in *.md; do
    python3 ../../repair.py $f
    pandoc --from=markdown --output=../latex/$f.tex $f --to=latex --standalone
    python3 ../../repair.py ../latex/$f.tex
done