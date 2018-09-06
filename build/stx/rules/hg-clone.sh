#!/bin/bash
#
# $Header: /cvs/stx/stx/rules/hg-clone.sh,v 1.2 2014-02-28 14:14:05 vrany Exp $
#
# Simple script to clone Mercurial repository. Used from stub entries in CVS
# to automatically fetch code from there.
#
# Usage: hg-clone.sh <repository> <packagedir>
#
#


function usage() {
    echo <<USAGE
Usage: hg-clone.sh <repository> <packagedir>
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

if [ "$" == "--help" ]; then
    usage
fi


REPO=$1
PKGDIR=$2

CLONE="$PKGDIR.tmp"

if [ -z "$REPO" ]; then
    error "No repository specified"
fi

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

if [ -d "$PKGDIR/.hg" ]; then
    error "$PKGDIR is already a Mercurial repository"
fi

trap "rm -rf $CLONE; exit" SIGHUP SIGINT SIGTERM

if [ -d "$CLONE" ]; then
    rm -rf "$CLONE"
fi

if ! hg clone "$REPO" "$CLONE"; then
    echo "ERROR: Cannot clone repository"
    echo "Cleaning up..."
    rm -rf "$CLONE"
    exit 5
fi

mv "$PKGDIR" "${PKGDIR}.old" || error "Cannot move old directory aside"

trap "rm -rf $CLONE; mv \"$PKGDIR.old\" \"$PKGDIR\"; exit" SIGHUP SIGINT SIGTERM

mv "$CLONE" "$PKGDIR" || error "Cannot move clone to $PKGDIR"

#rm -rf "$PKGDIR.old"