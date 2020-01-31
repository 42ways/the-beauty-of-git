#!/usr/bin/env bash

# script to set up demo repository and create shell output and graphics
# for my presentation "The beauty of git"

rm -rf repo > /dev/null 2>&1
mkdir repo > /dev/null 2>&1

# use subshell to collect output
(

cd repo

stdbuf -o0 echo ===== INITIALIZE EMPTY REPOSITORY
(set -x
git init
find .git
); echo

stdbuf -o0 echo ===== CREATE FIRST FILE
(set -x
echo -n 'Hello, world!' > hello.txt
echo -en 'blob 13\0Hello, world!' | shasum
find .git/objects
); echo

stdbuf -o0 echo ===== ADD FIRST FILE
(set -x
git add hello.txt
find .git/objects
); echo

stdbuf -o0 echo ===== COMMIT FIRST FILE
(set -x
git commit -m 'created hello.txt'
find .git/objects
find .git/refs
); echo

## GIT-DRAW

stdbuf -o0 echo ===== CHANGE FILE
(set -x
echo '\nHappy to see you!' >> hello.txt
git add hello.txt
git commit -m 'extended hello'
find .git/objects
); echo

## GIT-DRAW

stdbuf -o0 echo ===== TIME TO RELEASE
(set -x
git tag 'v0.1.0.0'
find .git/objects
find .git/refs
); echo

## GIT-DRAW

stdbuf -o0 echo ===== CREATE SECOND FILE
(set -x
echo 'Goodbye and au revoir' > bye.txt
git add bye.txt
git commit -m 'auf wiedersehen'
find .git/objects
); echo

## GIT-DRAW

stdbuf -o0 echo ===== MOVE AND COPY THINGS
(set -x
mkdir happy
git checkout -b refactoring
git mv hello.txt happy
cp happy/hello.txt happy/welcome-back.txt
git add happy/welcome-back.txt
git commit -m "be happy"
find .git/objects
); echo

## GIT-DRAW

) 2>&1 | sed -e 's/^+ /the-beauty-of-git-demo $ /'| tee setup-repo.log

