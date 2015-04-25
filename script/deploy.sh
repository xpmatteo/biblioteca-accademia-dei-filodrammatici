#!/bin/bash

# with the help of http://stackoverflow.com/questions/1402390/git-push-clone-to-new-server/1402783#1402783
#
# Before deploying for the first time, you should 
#  
#    git clone --bare /path/to/repo /path/to/bare/repo.git  # don't forget the .git!
#
# Then transfer the bare repo to the server, and clone it to the destination directory. 
# In this case, ~/filo
#
# Then do the following on the repo of the DEV machine:
#
#  git remote add deployment matteo@178.79.140.129:filo
#




# see http://www.spinics.net/lists/git/msg142043.html
require_clean_work_tree () {
	# Update the index
	git update-index -q --ignore-submodules --refresh
	err=0

	# Disallow unstaged changes in the working tree
	if ! git diff-files --quiet --ignore-submodules --
	then
		echo >&2 "cannot $1: you have unstaged changes."
		git diff-files --name-status -r --ignore-submodules -- >&2
		err=1
	fi

	# Disallow uncommitted changes in the index
	if ! git diff-index --cached --quiet HEAD --ignore-submodules --
	then
		echo >&2 "cannot $1: your index contains uncommitted changes."
		git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
		err=1
	fi

	if [ $err = 1 ]
	then
	    echo >&2 "Please commit or stash them."
	    exit 1
	fi
}

set -e 
cd "$(dirname "$0")/.."
host="matteo@178.79.140.129"

require_clean_work_tree

# push HEAD of current branch to branch "deployment" of remote "deployment"
git push deployment HEAD:deployment



ssh $host << EOF
	set -e
	cd filo
	git merge deployment
	bundle
	script/server -p 3001
    # [ -f tmp/production.pid ] && kill \$(cat tmp/production.pid)
    # puma config.ru -d -p 4567 -e production --pidfile tmp/production.pid -C config.puma.rb
EOF
