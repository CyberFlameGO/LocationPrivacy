#!/bin/bash -ex

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune || true
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public upstream/gh-pages

echo "Removing existing files"
rm -rf public/*

# set github pages domain name
sed -i 's,^baseURL:.*,baseURL: https://guardianproject.github.io/LocationPrivacy/,' config.yaml

echo "Generating site"
hugo

git checkout config.yaml  # reset the file after the sed regex above

echo "Updating gh-pages branch"
cd public
git add --all
git commit -m "Publishing to gh-pages (publish.sh)"
