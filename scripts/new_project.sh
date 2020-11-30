#!/bin/sh
echo "==> New components/$1"

echo "==> Prepare template"
mkdir -p "projects"
rm -rf templates/phoenix_live_no_db_v1/_build
rm -rf templates/phoenix_live_no_db_v1/deps
rm -rf templates/phoenix_live_no_db_v1/assets/node_modules

echo "==> Copy template"
cp -a templates/phoenix_live_no_db_v1 "projects/$1"

echo "==> Rename core directories & files"
mv "projects/$1/lib/sample_app" "projects/$1/lib/$1"
mv "projects/$1/lib/sample_app_web" "projects/$1/lib/$1_web"

mv "projects/$1/lib/sample_app.ex" "projects/$1/lib/$1.ex"
mv "projects/$1/lib/sample_app_web.ex" "projects/$1/lib/$1_web.ex"

echo "==> Find and replace SampleApp with $2"
grep -rl "SampleApp" "projects/$1" | xargs sed -i '' "s/SampleApp/$2/g"

echo "==> Find and replace sample_app with $1"
grep -rl "sample_app" "projects/$1" | xargs sed -i '' "s/sample_app/$1/g"

echo "==> Bundle projects/$1"
cd "projects/$1"

echo "==> Install dependecies"
mix deps.get

echo "==> Install assets"
npm install --prefix assets

echo "==> Run dev server"
PORT=5555 mix phx.server

# sh scripts/new_project.sh my_app MyApp
