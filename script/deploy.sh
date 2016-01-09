#!/bin/bash

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

bundle-audit update
bundle-audit || true
#require_clean_work_tree

# push HEAD of current branch to branch "deployment" of remote "deployment-sinatra"
git push deployment-sinatra HEAD:deployment

ssh $host << EOF
	set -e
	cd filo-sinatra
	git merge deployment
	bundle
	mkdir tmp 2> /dev/null || true
	[ -f tmp/production.pid ] && kill \$(cat tmp/production.pid) || true
  echo "If the process does not start, ensure that /etc/inittab contains this line:"
  echo "filo:2345:respawn:sudo -u matteo /home/matteo/filo-sinatra/script/run-production.sh"
	sleep 1
	tail log/production.log
EOF
