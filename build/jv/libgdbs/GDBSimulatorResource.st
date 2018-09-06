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

TestCase subclass:#GDBSimulatorResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Resources'
!

!GDBSimulatorResource class methodsFor:'documentation'!

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
! !

!GDBSimulatorResource class methodsFor:'recorded sessions'!

session_factorial_01

 ^ (GDBSessionRecord new: 15)

<<<
'=thread-group-added,id="i1"
(gdb) 
';

>>>
'1-inferior-tty-set /dev/pts/11';

<<<
'1^done
(gdb) 
';

>>>
'2-gdb-set target-async on';

<<<
'2^done
(gdb)
';

>>>
'3-file-exec-and-symbols /home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial';

<<<
'3^done
(gdb) 
';

>>>
'4b factorial';

<<<
'&"b factorial\n"
~"Breakpoint 1 at 0x400527: file factorial.c, line 4.\n"
=breakpoint-created,bkpt={number="1",type="breakpoint",disp="keep",enabled="y",addr="0x0000000000400527",func="factorial",file="factorial.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial.c",line="4",times="0",original-location="factorial"}
4^done
(gdb) 
';

>>>
'5r';

<<<
'&"r\n"
~"Starting program: /home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial \n"
=thread-group-started,id="i1",pid="7719"
=thread-created,id="1",group-id="i1"
5^running
*running,thread-id="all"
(gdb) 
';

<<<
'=library-loaded,id="/lib64/ld-linux-x86-64.so.2",target-name="/lib64/ld-linux-x86-64.so.2",host-name="/lib64/ld-linux-x86-64.so.2",symbols-loaded="0",thread-group="i1"
=library-loaded,id="/lib/x86_64-linux-gnu/libc.so.6",target-name="/lib/x86_64-linux-gnu/libc.so.6",host-name="/lib/x86_64-linux-gnu/libc.so.6",symbols-loaded="0",thread-group="i1"
=breakpoint-modified,bkpt={number="1",type="breakpoint",disp="keep",enabled="y",addr="0x0000000000400527",func="factorial",file="factorial.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial.c",line="4",times="1",original-location="factorial"}
~"\nBreakpoint "
~"1, factorial (i=5) at factorial.c:4\n"
~"4\t\tif (i == 1) {\n"
*stopped,reason="breakpoint-hit",disp="keep",bkptno="1",frame={addr="0x0000000000400527",func="factorial",args=[{name="i",value="5"}],file="factorial.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial.c",line="4"},thread-id="1",stopped-threads="all",core="0"
(gdb) 
';

>>>
'6-stack-info-depth --thread 1 100';

<<<
'6^done,depth="2"
(gdb) 
';

>>>
'7-stack-list-frames --thread 1 0 1';

<<<
'7^done,stack=[frame={level="0",addr="0x000107a4",func="factorial",file="factorial.c",fullname="/home/foo/bar/factorial.c",line="4"},frame={level="0",addr="0x000107a0",func="main",file="factorial.c",fullname="/home/foo/bar/factorial.c",line="13"}]
(gdb)
';

>>>
'8del 1';

<<<
'&"del 1\n"
=breakpoint-deleted,id="1"
8^done
(gdb) 
';

>>>
'9c';

<<<
'&"c\n"
~"Continuing.\n"
9^running
*running,thread-id="all"
(gdb) 
';

<<<
'~"[Inferior 1 (process 7719) exited with code 023]\n"
=thread-exited,id="1",group-id="i1"
=thread-group-exited,id="i1",exit-code="023"
*stopped
(gdb) 
';

yourself

    "Modified: / 29-09-2014 / 23:35:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

