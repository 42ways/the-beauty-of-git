#!/usr/bin/env bash

# script to set up demo repository and create shell output and graphics
# for my presentation "The beauty of git"

function create_img()
{
    git-draw --color-scheme paired12 --sha1-length 6 --hide-legend --hide-reflogs -i --image-filename $1 $2
    rm -f git-draw.dot
}

################################################################################
##### MAIN DEMO
################################################################################
# use subshell to collect output 
(

rm -rf repo > /dev/null 2>&1
mkdir repo > /dev/null 2>&1

cd repo

step=init
(
echo "+ #===== INITIALIZE EMPTY REPOSITORY"
cd ..
set -x
git init repo
cd repo
ls -p .git
) 2>&1 | sed -e 's/^+ /$ /' -e 's#/.*/repo#/.../repo#' | tee ../transcript/${step}.shell
create_img ../img/${step}.png

git config --local user.name "T.H."
git config --local user.email "thomas@42ways.de"

step=first-add
(
echo "+ #===== ADD FIRST FILE"
DATE="Wed Jan 15 08:15:20 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
echo "+ echo 'Hello, world!' > hello.txt"
echo 'Hello, world!' > hello.txt
echo "+ echo -e 'blob 14\0Hello, world!' | shasum"
echo -e 'blob 14\0Hello, world!' | shasum
set -x
git add hello.txt
find .git/objects
find .git/refs
) 2>&1 | sed -e 's/^+ /$ /' | tee ../transcript/${step}.shell
create_img ../img/${step}.png

step=first-commit
(
echo "+ #===== COMMIT FIRST FILE"
DATE="Wed Jan 15 09:10:11 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git commit -m 'created hello.txt'
find .git/objects -d 2
find .git/refs
) 2>&1 | sed -e 's/^+ /$ /' | tee ../transcript/${step}.shell
create_img ../img/${step}.png

step=change-first-file
(
echo "+ #===== CHANGE FIRST FILE"
DATE="Fri Jan 17 12:25:46 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
echo "+ echo 'Glad to see you!' >> hello.txt"
echo 'Glad to see you!' >> hello.txt
set -x
git hash-object hello.txt
git status
) 2>&1 | sed -e 's/^+ /$ /' | tee ../transcript/${step}.shell
create_img ../img/${step}.png

step=add-change-first
(
echo "+ #===== ADD FILE CHANGES TO INDEX"
DATE="Fri Jan 17 12:31:22 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git update-index hello.txt
git status
find .git/objects -d 2
find .git/refs -d 2
) 2>&1 | sed -e 's/^+ /$ /' | tee ../transcript/${step}.shell
create_img ../img/${step}.png

step=commit-change-first
(
echo "+ #===== COMMIT CHANGED FILE"
DATE="Fri Jan 17 12:36:54 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git commit -m 'extended hello'
find .git/objects -d 2
find .git/refs -d 2
) 2>&1 | sed -e 's/^+ /$ /' | tee ../transcript/${step}.shell
create_img ../img/${step}.png

step=first-tag
(
echo "+ #===== TIME TO PREPARE OUR RELEASE"
DATE="Fri Jan 17 13:19:24 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git tag 'v0.1'
find .git/refs -d 2
) 2>&1 | sed -e 's/^+ /$ /' | tee ../transcript/${step}.shell
create_img ../img/${step}.png

step=second-file
(
echo "+ #===== CREATE SECOND FILE"
DATE="Tue Jan 21 12:34:56 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
echo "+ echo 'Goodbye and au revoir' > bye.txt"
echo 'Goodbye and au revoir' > bye.txt
set -x
git add bye.txt
git commit -m 'auf wiedersehen'
git tag 'v0.2'
find .git/refs -d 2
) 2>&1 | sed -e 's/^+ /$ /' | tee ../transcript/${step}.shell
create_img ../img/${step}.png

step=second-branch
(
echo "+ #===== CREATE REFACTORING BRANCH"
DATE="Fri Jan 24 09:10:11 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git checkout -b refactoring
find .git/refs -d 2
) 2>&1 | sed -e 's/^+ /$ /' | tee ../transcript/${step}.shell
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
) 2>&1 | sed -e 's/^+ /$ /' | tee ../transcript/${step}.shell
create_img ../img/${step}.png

step=production-tag
(
echo "+ #===== TIME TO ACTUALLY RELEASE OUR SYSTEM"
DATE="Mon Jan 27 06:06:06 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git tag -m 'GO PRODUCTON!' 'v1.0' master
find .git/refs -d 2
) 2>&1 | sed -e 's/^+ /$ /' | tee ../transcript/${step}.shell
create_img ../img/${step}.png

) 2>&1 | tee setup-repo.log

################################################################################
##### ADVANCED DEMO REPOSITORY (REBASE AND MERGE OTHER REPO INTO IT)
################################################################################
# use subshell to collect output 
(

rm -rf repo2 > /dev/null 2>&1
mkdir repo2 > /dev/null 2>&1

cd repo2

step=first-release
(
echo "+ #===== CREATE A SECOND PROJECT"
cd ..
DATE="Sat Feb 01 01:23:45 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git init repo2
cd repo2
set +x
git config --local user.name "thomas" > /dev/null 2>&1
git config --local user.email "mail@thoherr.de" > /dev/null 2>&1
echo "+ echo 'Hello, world!' > hello.txt"
echo 'Hello, world!' > hello.txt
set -x
git hash-object hello.txt
git add hello.txt
git commit -m 'created hello.txt'
set +x
echo "+ echo 'Goodbye and au revoir' > bye.txt"
echo 'Goodbye and au revoir' > bye.txt
set -x
git add bye.txt
git commit -m 'created auf wiedersehen'
git tag '0.1'
) 2>&1 | sed -e '/+ set +x/d' -e 's/^+ /$ /' -e 's#/.*/repo2#/.../repo2#' | tee ../transcript2/${step}.shell
create_img ../img2/${step}.png

step=feature-branch
(
echo "+ #===== CREATE NEW FEATURE"
DATE="Wed Feb 01 11:22:33 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git checkout -b feature/bright-future
sed -i '' -e 's/world/brave new world/' hello.txt
git commit -a -m 'reworded for clarity'
) 2>&1 | sed -e '/+ set +x/d' -e 's/^+ /$ /' | tee ../transcript2/${step}.shell
create_img ../img2/${step}.png

step=further-development
(
echo "+ #===== LET'S IMPROVE MASTER BRANCH"
DATE="Wed Feb 01 17:28:39 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git checkout master
sed -i '' -e 's/ and/, ciao and/' bye.txt
git commit -a -m 'add language'
git tag '0.2'
) 2>&1 | sed -e '/+ set +x/d' -e 's/^+ /$ /' | tee ../transcript2/${step}.shell
create_img ../img2/${step}.png --hide-commitcontent

step=rebase
(
echo "+ #===== REBASE OUR FEATURE BRANCH"
DATE="Wed Feb 01 19:23:45 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git checkout feature/bright-future
git rebase master
) 2>&1 | sed -e '/+ set +x/d' -e 's/^+ /$ /' | tee ../transcript2/${step}.shell
create_img ../img2/${step}.png --hide-commitcontent

step=merge-it
(
echo "+ #===== MERGE OUR BRANCH (IT'S EASY NOW)"
DATE="Wed Feb 02 11:22:44 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git checkout master
git merge feature/bright-future
) 2>&1 | sed -e '/+ set +x/d' -e 's/^+ /$ /' | tee ../transcript2/${step}.shell
create_img ../img2/${step}.png --hide-commitcontent

step=fetch-the-other-repo
(
echo "+ #===== FETCH EVERYTHING FROM THE FIRST DEMO"
DATE="Wed Feb 02 20:20:20 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git fetch ../repo
) 2>&1 | sed -e '/+ set +x/d' -e 's/^+ /$ /' | tee ../transcript2/${step}.shell
create_img ../img2/${step}.png --hide-commitcontent

step=awake-the-other-repo
(
echo "+ #===== MAKE STUFF FROM FIRST DEMO ACCESSIBLE"
DATE="Wed Feb 02 21:21:21 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git branch work-from-the-other-side FETCH_HEAD
) 2>&1 | sed -e '/+ set +x/d' -e 's/^+ /$ /' | tee ../transcript2/${step}.shell
create_img ../img2/${step}.png --hide-commitcontent

step=merge-the-other-repo
(
echo "+ #===== AND EVEN MERGE THE MAKE STUFF FROM FIRST DEMO"
DATE="Wed Feb 02 22:22:22 CET 2020"
export GIT_AUTHOR_DATE=${DATE}
export GIT_COMMITTER_DATE=${DATE}
set -x
git merge --allow-unrelated-histories -s recursive -X ours -m 'merge it' work-from-the-other-side
) 2>&1 | sed -e '/+ set +x/d' -e 's/^+ /$ /' | tee ../transcript2/${step}.shell
create_img ../img2/${step}.png --hide-commitcontent

) 2>&1 | tee setup-repo2.log
