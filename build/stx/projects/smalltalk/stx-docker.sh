#!/bin/bash
set -e

test -f .Xauthority.org && xauth -f .Xauthority.org list | sed -e '/unix/!d' -e "s+.*/unix:+add $(hostname)/unix:+" | xauth 2>/dev/null -
test -z "$1" && exec stx/projects/smalltalk/stx
exec "$@"
