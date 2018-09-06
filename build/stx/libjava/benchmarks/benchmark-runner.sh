#!/bin/sh

DEBUGGER=
PROFILER=
PROFILER_OPTS=

if [ "$1" = "--gdb" ]
then
    shift
    DEBUGGER=gdb
fi

if [ "$1" = "--cgdb" ]
then
    shift
    DEBUGGER=cgdb
fi

if [ "$1" = "--callgrind" ]
then
    shift
    #PROFILER="/usr/local/bin/valgrind -v -v -d --tool=callgrind --instr-atstart=no"
    PROFILER="/usr/local/bin/valgrind -v --smc-check=all-non-file --tool=callgrind --instr-atstart=no"
    PROFILER="valgrind -v --smc-check=all-non-file --tool=callgrind --instr-atstart=no --branch-sim=yes --cache-sim=yes --collect-jumps=yes"
    #PROFILER_OPTS=--callgrind
fi

if [ "$1" = "--help" ]
then
    echo <<ENDHELP
  --gdb ................... run benchmark under gdb debugger. Start with 
                            (gdb) r -I -f "$DIR/benchmark-runner.st" -b ... 
  --cgdb .................. run benchmark under cgdb debugger
  --callgrind ............. run benchmark under callgrind profiler. 
ENDHELP
    "$DIR/../../projects/smalltalk/stx" -I  -f "$DIR/benchmark-runner.st" ${1+"$@"}
# .........................
fi

DIR=`dirname $0`
if [ ! -z "$DEBUGGER" ]; then
    exec $DEBUGGER $DIR/../../projects/smalltalk/stx 
fi
if [ ! -z "$PROFILER" ]; then
    exec $PROFILER $DIR/../../projects/smalltalk/stx \
        -I -f "$DIR/benchmark-runner.st" \
        ${1+"$@"}    
fi

    
exec "$DIR/../../projects/smalltalk/stx" \
    -I  -f "$DIR/benchmark-runner.st" \
    ${1+"$@"}
