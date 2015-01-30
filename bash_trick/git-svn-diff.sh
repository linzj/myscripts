#
# git-svn-diff
# Generate an SVN-compatible diff against the tip of the tracking branch
#TRACKING_BRANCH=`git config --get svn-remote.svn.fetch | sed -e 's/.*:refs\/remotes\///'`
#git diff --no-prefix $(git rev-list --date-order --max-count=1 $TRACKING_BRANCH) $* |
#sed -e "s/^+++ .*/&    (working copy)/" -e "s/^--- .*/&    (revision $REV)/" \
#-e "s/^diff --git [^[:space:]]*/Index:/" \
#-e "s/^index.*/===================================================================/"
if [ $# -gt 0 ]
then
    COMMIT=$1
else
    COMMIT=HEAD^
fi     

if [ $# -ge 2 ]
then
    HEAD=$2
else
    HEAD="HEAD"
fi

REV=`git svn find-rev $COMMIT`
git diff $COMMIT $HEAD --no-prefix |
sed -e "s/^+++ .*/&    (working copy)/" -e "s/^--- .*/&    (revision $REV)/" \
-e "s/^diff --git [^[:space:]]*/Index:/" \
-e "s/^index.*/===================================================================/"
