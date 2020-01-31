#!/usr/bin/env bash

# script to set up demo repository and create shell output and graphics
# for my presentation "The beauty of git"

function create_img()
{
    git-draw --color-scheme paired12 --sha1-length 6 --hide-legend --hide-reflogs -i --image-filename $1
}

rm -rf repo > /dev/null 2>&1
mkdir repo > /dev/null 2>&1

# use subshell to collect output
(

cd repo

step=init
(
echo "+ #===== INITIALIZE EMPTY REPOSITORY"
set -x
git init
find .git
) 2>&1 | sed -e 's/^+ /$ /'| tee ../transcript/${step}.txt
create_img ../img/${step}.png

git config --local user.name "T.H."
git config --local user.email "thomas@42ways.de"

step=first-file
(
echo "+ #===== CREATE FIRST FILE"
DATE="Wed Jan 15 08:15:20 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
echo "+ echo -n 'Hello, world!' > hello.txt"
echo -n 'Hello, world!' > hello.txt
echo "+ echo -en 'blob 13\0Hello, world!' | shasum"
echo -en 'blob 13\0Hello, world!' | shasum
set -x
find .git/objects
) 2>&1 | sed -e 's/^+ /$ /'| tee ../transcript/${step}.txt
create_img ../img/${step}.png

step=first-add
(
echo "+ #===== ADD FIRST FILE"
DATE="Wed Jan 15 08:45:19 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
echo "+ echo -en 'blob 13\0Hello, world!' | shasum"
echo -en 'blob 13\0Hello, world!' | shasum
set -x
git add hello.txt
find .git/objects
) 2>&1 | sed -e 's/^+ /$ /'| tee ../transcript/${step}.txt
create_img ../img/${step}.png

step=first-commit
(
echo "+ #===== COMMIT FIRST FILE"
DATE="Wed Jan 15 09:10:11 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git commit -m 'created hello.txt'
find .git/objects
find .git/refs
) 2>&1 | sed -e 's/^+ /$ /'| tee ../transcript/${step}.txt
create_img ../img/${step}.png

step=second-commit
(
echo "+ #===== CHANGE FILE"
DATE="Fri Jan 17 12:36:54 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
echo >> hello.txt
echo 'Happy to see you!' >> hello.txt
git add hello.txt
git commit -m 'extended hello'
find .git/objects
) 2>&1 | sed -e 's/^+ /$ /'| tee ../transcript/${step}.txt
create_img ../img/${step}.png

step=first-tag
(
echo "+ #===== TIME TO PREPARE OUR RELEASE"
DATE="Fri Jan 17 13:19:24 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git tag 'v0.1'
find .git/objects
find .git/refs
) 2>&1 | sed -e 's/^+ /$ /'| tee ../transcript/${step}.txt
create_img ../img/${step}.png

step=second-file
(
echo "+ #===== CREATE SECOND FILE"
DATE="Tue Jan 21 12:34:56 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
echo 'Goodbye and au revoir' > bye.txt
git add bye.txt
git commit -m 'auf wiedersehen'
git tag 'v0.2'
find .git/objects
find .git/refs
) 2>&1 | sed -e 's/^+ /$ /'| tee ../transcript/${step}.txt
create_img ../img/${step}.png

step=second-branch
(
echo "+ #===== CREATE ANOTHER BRANCH"
DATE="Fri Jan 24 09:10:11 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git checkout -b refactoring
find .git/objects
) 2>&1 | sed -e 's/^+ /$ /'| tee ../transcript/${step}.txt
create_img ../img/${step}.png

step=refactoring-done
(
echo "+ #===== MOVE AND COPY SOME THINGS"
DATE="Fri Jan 24 12:13:14 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
mkdir happy
git mv hello.txt happy
cp happy/hello.txt happy/welcome-back.txt
git add happy/welcome-back.txt
git commit -m "be happy"
find .git/objects
) 2>&1 | sed -e 's/^+ /$ /'| tee ../transcript/${step}.txt
create_img ../img/${step}.png

step=production-tag
(
echo "+ #===== TIME TO ACTUALLY RELEASE OUR SYSTEM"
DATE="Mon Jan 27 06:06:06 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git tag -m 'GO PRODUCTON!' 'v1.0' master
find .git/objects
find .git/refs
) 2>&1 | sed -e 's/^+ /$ /'| tee ../transcript/${step}.txt
create_img ../img/${step}.png

) 2>&1 | tee setup-repo.log
