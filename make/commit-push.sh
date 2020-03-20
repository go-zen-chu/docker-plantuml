#!/usr/bin/env bash

# if we have changes then commit and push
if git diff-index --quiet HEAD --; then
    echo "No changes. Aborting"
else
    echo "Update detected. git commit and push"
    git config --global user.name "${GIT_USER}"
    git config --global user.email "${GIT_EMAIL}"

    git add --all
    git commit -m "[ci bot] update packages"
    git push origin master
fi

exit 0