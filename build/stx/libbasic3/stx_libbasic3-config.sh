#!/bin/bash
#
# Simple script to (auto)create libprofiler-config.h
# based on what is available on current system
#

HEADER=stx_libbasic3-config.h
INCLUDE_DIRS="/usr/include /usr/local/include"

function out() {
    echo "$1" >> $HEADER
}

echo -n > $HEADER
out "/* Do not edit! Automatically generated at $(date) */"
out ""
for inc in $INCLUDE_DIRS; do
    if [ -r "$inc/valgrind/valgrind.h" ]; then
    	out "#if !defined(_WIN32) && !defined(_WIN64)"    	
        out "# define HAS_VALGRIND"        
        if [ -r "$inc/valgrind/callgrind.h" ]; then
            out "# define HAS_CALLGRIND"        
        fi        
        out "#endif"
    fi        
done

out ""




