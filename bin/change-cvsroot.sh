#!/bin/sh
#NEWROOT=:pserver:$(id -un)@cvs.bh.exept.de:/cvs/stx

if [ -z "$1" ]; then
    echo "Common CVS roots:"
    # Do not show these to other people, these are useless for them
    # anyway
    if [ "$USER" = "jv" ]; then
	echo " :ext:vrany@exeptn:/cvs/stx       "
	echo
	echo " :ext:vrany@dialin.exept.de:/cvs/stx           "
	echo
    fi
cat <<EOF
 :pserver:cvs@cvs.smalltalk-x.de:/cvs/stx
     (public eXept CVS, synced once a day. Use this if unsure)

 :ext:swing.fit.cvut.cz/var/local/cvs
     (SWING mirror. Use this if you have shell account
      on swing.fit.cvut.cz)

EOF
    echo -n "Enter new CVS root (or Ctrl-C to abort): "
    read answer
else
    answer="$1"
fi

if [ ! -z "$answer" ]; then
    echo "$answer" > /tmp/chcvs.$$
    find . -name CVS -type d -exec cp /tmp/chcvs.$$ {}/Root \;
    rm /tmp/chcvs.$$
else
    echo "Nothing changed"
    exit 1	
fi
