#!/bin/bash

function error {
    echo "ERROR: $1"
    exit 1
}

if [ -z "$1" ]; then
   error "No source build tree specified"
fi

SRCDIR=$1

if [ ! -d "$SRCDIR" ]; then 
    error "Source directory does not exist: $SRCDIR"
fi

if [ -z "$2" ]; then
    DSTDIR=build
else 
    DSTDIR=$2
fi

if [ ! -d "$DSTDIR" ]; then 
    error "Destination directory does not exist: $DSTDIR"
fi

pushd "$SRCDIR"
repos=$(find ./ -name .hg -prune)
popd

set -e

for repo_store in $repos; do
    repo=$(dirname $repo_store)
    if [ -d $DSTDIR/$repo ]; then
    	if [ -f $DSTDIR/$repo/.hg/sharedpath ]; then
    	    echo "Repository $repo already exists and shared"
    	else 
    		echo "Directory $repo already exists."
    		echo -n "Move aside and share (y/N/Ctrl-C)? "
    		read yesOrNo
    		if [ $yesOrNo == 'y' ]; then
    			if ! mv $DSTDIR/$repo $DSTDIR/${repo}_$(date +%Y-%M-%d); then
                    error "Failed to move $DSTDIR/$repo aside to $DSTDIR/${repo}_$(date +%Y-%M-%d)"
                fi
    		fi
    	fi
    fi

    if [ -d $DSTDIR/$repo ]; then
    	if [ ! -d $DSTDIR/$repo/.hg/sharedpath ]; then
            echo "Not sharing $repo - already exists"
    	fi
    else 
        echo "Sharing $repo..."
	if [ ! -d "$DSTDIR/$(dirname $repo)" ]; then 
	    mkdir -p "$DSTDIR/$(dirname $repo)"
	fi
	hg share -U -B "$SRCDIR/$repo" "$DSTDIR/$repo"
	repo_rev=$(hg --cwd "$SRCDIR/$repo" log -r . --template "{node}")
	echo "Updating to $repo_rev"
	hg --cwd "$DSTDIR/$repo" update -r $repo_rev
    fi
    echo 
done
