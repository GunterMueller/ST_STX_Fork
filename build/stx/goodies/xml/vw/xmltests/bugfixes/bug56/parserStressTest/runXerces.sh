#! /bin/bash
#

rm -f *.BOMB

for i in *.xml; do
    BOMB=${i%%.xml}.BOMB
    SAX2Print -v=always $i > /dev/null 2>&1
    RC=$?
    if [ "$RC" -ne 0 ] ; then
        touch $BOMB
    fi
done
