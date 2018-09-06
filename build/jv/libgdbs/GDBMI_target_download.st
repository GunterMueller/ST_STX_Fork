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

GDBMICommand subclass:#GDBMI_target_download
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_target_download class methodsFor:'documentation'!

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
The `-target-download' Command
------------------------------

Synopsis
........

      -target-download

   Loads the executable onto the remote target.  It prints out an
update message every half second, which includes the fields:

`section'
     The name of the section.

`section-sent'
     The size of what has been sent so far for that section.

`section-size'
     The size of the section.

`total-sent'
     The total size of what was sent so far (the current and the
     previous sections).

`total-size'
     The size of the overall executable to download.

Each message is sent as status record (*note GDB/MI Output Syntax:
GDB/MI Output Syntax.).

   In addition, it prints the name and size of the sections, as they are
downloaded.  These messages include the following fields:

`section'
     The name of the section.

`section-size'
     The size of the section.

`total-size'
     The size of the overall executable to download.

At the end, a summary is printed.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `load'.

Example
.......

Note: each status message appears on a single line.  Here the messages
have been broken down so that they can fit onto a page.

     (gdb)
     -target-download
     +download,{section='.text',section-size='6668',total-size='9880'}
     +download,{section='.text',section-sent='512',section-size='6668',
     total-sent='512',total-size='9880'}
     +download,{section='.text',section-sent='1024',section-size='6668',
     total-sent='1024',total-size='9880'}
     +download,{section='.text',section-sent='1536',section-size='6668',
     total-sent='1536',total-size='9880'}
     +download,{section='.text',section-sent='2048',section-size='6668',
     total-sent='2048',total-size='9880'}
     +download,{section='.text',section-sent='2560',section-size='6668',
     total-sent='2560',total-size='9880'}
     +download,{section='.text',section-sent='3072',section-size='6668',
     total-sent='3072',total-size='9880'}
     +download,{section='.text',section-sent='3584',section-size='6668',
     total-sent='3584',total-size='9880'}
     +download,{section='.text',section-sent='4096',section-size='6668',
     total-sent='4096',total-size='9880'}
     +download,{section='.text',section-sent='4608',section-size='6668',
     total-sent='4608',total-size='9880'}
     +download,{section='.text',section-sent='5120',section-size='6668',
     total-sent='5120',total-size='9880'}
     +download,{section='.text',section-sent='5632',section-size='6668',
     total-sent='5632',total-size='9880'}
     +download,{section='.text',section-sent='6144',section-size='6668',
     total-sent='6144',total-size='9880'}
     +download,{section='.text',section-sent='6656',section-size='6668',
     total-sent='6656',total-size='9880'}
     +download,{section='.init',section-size='28',total-size='9880'}
     +download,{section='.fini',section-size='28',total-size='9880'}
     +download,{section='.data',section-size='3156',total-size='9880'}
     +download,{section='.data',section-sent='512',section-size='3156',
     total-sent='7236',total-size='9880'}
     +download,{section='.data',section-sent='1024',section-size='3156',
     total-sent='7748',total-size='9880'}
     +download,{section='.data',section-sent='1536',section-size='3156',
     total-sent='8260',total-size='9880'}
     +download,{section='.data',section-sent='2048',section-size='3156',
     total-sent='8772',total-size='9880'}
     +download,{section='.data',section-sent='2560',section-size='3156',
     total-sent='9284',total-size='9880'}
     +download,{section='.data',section-sent='3072',section-size='3156',
     total-sent='9796',total-size='9880'}
     ^done,address='0x10004',load-size='9880',transfer-rate='6586',
     write-rate='429'
     (gdb)

{No value for `GDBN'} Command
.............................

No equivalent.

Example
.......

N.A.


"
! !

!GDBMI_target_download methodsFor:'accessing'!

operation
	^ 'target-download'
! !

