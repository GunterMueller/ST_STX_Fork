#!/bin/bash
#
# $Header: /cvs/stx/stx/rules/hg-update.sh,v 1.2 2014-07-08 09:01:48 vrany Exp $
#
# Simple script to update code in Mercurial working copy. Called but
# stx/update.sh and expecco/update.sh
#
# Usage: hg-update.sh <packagedir>
#
#

function usage() {
    echo <<USAGE
Usage: hg-update.sh [-r|--tag <revision>] <packagedir>
USAGE
    exit 126
}

function error() {
    echo "ERROR: $1";
    if [ -z "$2" ]; then
        exit 1
    else
        exit "$2"
    fi
}

REVISION=""

if [ "$1" == "--help" ]; then
    usage
fi

if [ "$1" == "-r" ]; then
    REVISION=$2;
    shift;
    shift;
fi

if [ "$1" == "--tag" ]; then
    REVISION=$2;
    shift;
    shift;
fi



PKGDIR=$1

if [ -z "$PKGDIR" ]; then
    error "No directory specified"
fi

if ! hg --version &> /dev/null; then
    echo <<END
Could not find `hg` command, perhaps Mercurial client is not installed.
Please install mercurial and try again. You may find pre-built packages
and installation instruction at:

  http://mercurial.selenic.com/wiki/Download

END
    exit 2
fi

if [ ! -d "$PKGDIR/.hg" ]; then
    if [ ! -d "$PKGDIR/CVS" ]; then
	error "$PKGDIR doesn't look like Mercurial repository"
    else
    	echo "INFO: $PKGDIR is CVS"
    	(cd $PKGDIR && cvs upd -d)
    	exit 0
    fi
fi

# some versions of CVS sometimes recreate CVS directory when doing
# `cvs upd -d`. We have to remove that CVS directory as otherwise
# stc will detect both CVS and HG working copy and will complain.
if [ -d "$PKGDIR/CVS" ]; then
	rm -rf "$PKGDIR/CVS"
fi

if ! hg --cwd "$PKGDIR" pull; then
	error "Cannot pull changes into $PKGDIR"
fi

if [ -z "$REVISION" ]; then
    if ! hg --cwd "$PKGDIR" update; then
	error "Cannot update working copy in $PKGDIR"
    fi
else
    echo "INFO: Updating to revision $REVISION"
    if ! hg --cwd "$PKGDIR" update -r "$REVISION"; then
	error "Cannot update working copy in $PKGDIR"
    fi
fi

echo "** $PKGDIR updated, now at: **"
hg --cwd "$PKGDIR" summary
