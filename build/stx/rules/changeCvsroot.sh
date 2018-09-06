#!/bin/sh

NEWROOT=:pserver:$(id -un)@cvs.bh.exept.de:/cvs/stx

echo -n Change root paths to \'$NEWROOT\' '(y/n)N ? '
read answer
case "$answer" in
y|Y|j|J)
    echo $NEWROOT >/tmp/chcvs.$$
    find . -name CVS -type d  -print | xargs -i cp /tmp/chcvs.$$ {}/Root

    rm /tmp/chcvs.$$
    ;;
*)
    echo "Nothing changed"
    exit 1	
    ;;
esac
