#!/bin/bash
#
# Simple script to (auto)create stx-config.h
# based on what is available on current system
#

HEADER=stx-config.h
INCLUDE_DIRS="/usr/include /usr/local/include "

function out() {
    echo "$1" >> $HEADER
}

echo -n > $HEADER
out "/* Do not edit! Automatically generated at $(date) */"
out ""
for inc in $INCLUDE_DIRS; do
    if [ -r "$inc/sys/sdt.h" ]; then
       if [ "$(uname -s)" != "Darwin" ]; then 
    	 out "#ifndef WIN32"
         out "# define HAS_SYSTEMTAP"
         out "#endif"
       fi
    fi
done
if [ -r "/usr/include/i386-linux-gnu/sys/sdt.h" ]; then
    if [ "$(uname -s)" != "Darwin" ]; then 
        out "#if !defined(WIN32) && defined(__i386__)"
        out "# define HAS_SYSTEMTAP"
        out "#endif"
    fi
fi

out ""
