"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

GDBMICommand subclass:#GDBMI_stack_list_arguments
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_stack_list_arguments class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
The `-stack-list-arguments' Command
-----------------------------------

Synopsis
........

      -stack-list-arguments [ --no-frame-filters ] [ --skip-unavailable ] PRINT-VALUES
         [ LOW-FRAME HIGH-FRAME ]

   Display a list of the arguments for the frames between LOW-FRAME and
HIGH-FRAME (inclusive).  If LOW-FRAME and HIGH-FRAME are not provided,
list the arguments for the whole call stack.  If the two arguments are
equal, show the single frame at the corresponding level.  It is an
error if LOW-FRAME is larger than the actual number of frames.  On the
other hand, HIGH-FRAME may be larger than the actual number of frames,
in which case only existing frames will be returned.

   If PRINT-VALUES is 0 or `--no-values', print only the names of the
variables; if it is 1 or `--all-values', print also their values; and
if it is 2 or `--simple-values', print the name, type and value for
simple data types, and the name and type for arrays, structures and
unions.  If the option `--no-frame-filters' is supplied, then Python
frame filters will not be executed.

   If the `--skip-unavailable' option is specified, arguments that are
not available are not listed.  Partially available arguments are still
displayed, however.

   Use of this command to obtain arguments in a single frame is
deprecated in favor of the `-stack-list-variables' command.

{No value for `GDBN'} Command
.............................

{No value for `GDBN'} does not have an equivalent command.  `gdbtk' has
a `gdb_get_args' command which partially overlaps with the
functionality of `-stack-list-arguments'.

Example
.......

     (gdb)
     -stack-list-frames
     ^done,
     stack=[
     frame={level='0',addr='0x00010734',func='callee4',
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='8'},
     frame={level='1',addr='0x0001076c',func='callee3',
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='17'},
     frame={level='2',addr='0x0001078c',func='callee2',
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='22'},
     frame={level='3',addr='0x000107b4',func='callee1',
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='27'},
     frame={level='4',addr='0x000107e0',func='main',
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='32'}]
     (gdb)
     -stack-list-arguments 0
     ^done,
     stack-args=[
     frame={level='0',args=[]},
     frame={level='1',args=[name='strarg']},
     frame={level='2',args=[name='intarg',name='strarg']},
     frame={level='3',args=[name='intarg',name='strarg',name='fltarg']},
     frame={level='4',args=[]}]
     (gdb)
     -stack-list-arguments 1
     ^done,
     stack-args=[
     frame={level='0',args=[]},
     frame={level='1',
      args=[{name='strarg',value='0x11940 \'A string argument.\''}]},
     frame={level='2',args=[
     {name='intarg',value='2'},
     {name='strarg',value='0x11940 \'A string argument.\''}]},
     {frame={level='3',args=[
     {name='intarg',value='2'},
     {name='strarg',value='0x11940 \'A string argument.\''},
     {name='fltarg',value='3.5'}]},
     frame={level='4',args=[]}]
     (gdb)
     -stack-list-arguments 0 2 2
     ^done,stack-args=[frame={level='2',args=[name='intarg',name='strarg']}]
     (gdb)
     -stack-list-arguments 1 2 2
     ^done,stack-args=[frame={level='2',
     args=[{name='intarg',value='2'},
     {name='strarg',value='0x11940 \'A string argument.\''}]}]
     (gdb)


"
! !

!GDBMI_stack_list_arguments methodsFor:'accessing'!

operation
	^ 'stack-list-arguments'
! !

