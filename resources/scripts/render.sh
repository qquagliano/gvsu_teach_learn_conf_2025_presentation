#!/bin/sh

# SECTION: Start logging
rm ./resources/scripts/render_logs/render.log
touch ./resources/scripts/render_logs/render.log
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>./resources/scripts/render_logs/render.log 2>&1

# SECTION: Chromium Bug Fix
export QUARTO_CHROMIUM_HEADLESS_MODE="none"

# SECTION: Remove possible residual dirs
rm -rf _docs _docs-toc _lectures _web _site

# SECTION: Run quarto renders to temp dirs
quarto render --to all --cache-refresh --profile docs --output-dir _docs --verbose
quarto render --to all --cache-refresh --profile docs-toc --output-dir _docs-toc --verbose
quarto render --to all --cache-refresh --profile lectures --output-dir _lectures --verbose
quarto render --to all --cache-refresh --profile web --output-dir _web --verbose

# SECTION: Copy temp render dirs to site
mkdir _site
cp -R _docs/* _site
cp -R _docs-toc/* _site
cp -R _lectures/* _site
cp -R _web/* _site

# SECTION: Remove temp render dirs
rm -rf _docs _docs-toc _lectures _web

# SECTION: Remove residual caches and files
rm -rf ./content/**/*_cache
rm -rf ./_site/**/*_files
rm -rf ./content/**/**/*_cache
rm -rf ./_site/**/**/_files
rm -rf ./content/**/**/**/*_cache
rm -rf ./_site/**/**/**/_files

# SECTION: Remove bins out of content folders
rm -rf ./content/**/*.html
rm -rf ./content/**/*.pdf
rm -rf ./content/**/**/*.html
rm -rf ./content/**/**/*.pdf
rm -rf ./content/**/**/**/*.html
rm -rf ./content/**/**/**/*.pdf
rm -rf ./content/**/**/**/**/*.html
rm -rf ./content/**/**/**/**/*.pdf

# SECTION: Move to public repo for publishing
rm -rf ../PSY-300-Public/docs/*
cp -r ./_site/* ../PSY-300-Public/docs/

# SECTION: Prevent exams and attendence from being published in public
rm -rf ../PSY-300-Public/docs/content/admin/exam_1/test
rm -rf ../PSY-300-Public/docs/content/admin/exam_2/test
rm -rf ../PSY-300-Public/docs/content/admin/attendence
rm -rf ../PSY-300-Public/docs/content/admin/student_reports

# SECTION: Print error log to stout
echo "Printing warning and errors from rendering:" >&3
echo " " >&3

grep -i "error" ./resources/scripts/render_logs/render.log >&3
grep -i "warn" ./resources/scripts/render_logs/render.log >&3
grep -i "fail" ./resources/scripts/render_logs/render.log >&3
