#!/bin/bash

rm -rf backend/dist
rm -rf frontend/dist
rm -rf livecam/dist

mkdir -p docs/latex
mkdir -p docs/md

echo "Updating submodules..."
git submodule update --recursive --remote


# Transpile source
echo "Transpiling Typescript source..."
tsc -p backend/tsconfig.json &>/dev/null
tsc -p frontend/tsconfig.json &>/dev/null
tsc -p livecam/tsconfig.json &>/dev/null

echo "Generating Markdown Docs..."
options="-d 3"
jsdoc2md $options --files backend/dist/models/**/*.js > docs/md/models.backend.md
jsdoc2md $options --files backend/dist/controllers/**/*.js > docs/md/controllers.backend.md
jsdoc2md $options --files backend/dist/types/**/*.js > docs/md/types.backend.md

viewopts="-d 4"
# jsdoc2md $viewopts --files frontend/dist/out-tsc/app/components/**/*.js > docs/md/view.frontend.md
jsdoc2md $viewopts --files frontend/dist/out-tsc/app/components/appointment-management/**/*.js > docs/md/view.frontend.appointment-management.md
jsdoc2md $viewopts --files frontend/dist/out-tsc/app/components/auth/**/*.js > docs/md/view.frontend.auth.md
jsdoc2md $viewopts --files frontend/dist/out-tsc/app/components/general/**/*.js > docs/md/view.frontend.general.md
jsdoc2md $viewopts --files frontend/dist/out-tsc/app/components/inventory-management/**/*.js > docs/md/view.frontend.inventory-management.md
jsdoc2md $viewopts --files frontend/dist/out-tsc/app/components/livecam/**/*.js > docs/md/view.frontend.livecam.md
jsdoc2md $viewopts --files frontend/dist/out-tsc/app/components/order-management/**/*.js > docs/md/view.frontend.order-management.md
jsdoc2md $viewopts --files frontend/dist/out-tsc/app/components/room-management/**/*.js > docs/md/view.frontend.room-management.md
jsdoc2md $viewopts --files frontend/dist/out-tsc/app/components/settings/**/*.js > docs/md/view.frontend.settings.md
jsdoc2md $viewopts --files frontend/dist/out-tsc/app/components/user-management/**/*.js > docs/md/view.frontend.user-management.md
jsdoc2md $options --files frontend/dist/out-tsc/app/services/**/*.js > docs/md/services.frontend.md
jsdoc2md $options --files frontend/dist/out-tsc/app/types/**/*.js > docs/md/types.frontend.md

jsdoc2md --files livecam/dist/**/*.js > docs/md/livecam.md

echo "Generating LaTeX Docs..."
cd docs/md
for f in *.md; do
    python3 ../../repair.py $f
    pandoc --from=markdown --output=../latex/$f.tex $f --to=latex --standalone
    python3 ../../repair.py ../latex/$f.tex
done