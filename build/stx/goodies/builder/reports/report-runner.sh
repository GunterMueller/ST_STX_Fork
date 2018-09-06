#!/bin/sh
DIR=`dirname $0`
exec "$DIR/../../../projects/smalltalk/stx" -Mold:64000 -I --abortOnSEGV --execute "$DIR/report-runner.st" "$@"
