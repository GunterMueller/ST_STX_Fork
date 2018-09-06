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

GDBMICommand subclass:#GDBMI_stack_list_frames
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_stack_list_frames class methodsFor:'documentation'!

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
The `-stack-list-frames' Command
--------------------------------

Synopsis
........

      -stack-list-frames [ --no-frame-filters LOW-FRAME HIGH-FRAME ]

   List the frames currently on the stack.  For each frame it displays
the following info:

`LEVEL'
     The frame number, 0 being the topmost frame, i.e., the innermost
     function.

`ADDR'
     The `$pc' value for that frame.

`FUNC'
     Function name.

`FILE'
     File name of the source file where the function lives.

`FULLNAME'
     The full file name of the source file where the function lives.

`LINE'
     Line number corresponding to the `$pc'.

`FROM'
     The shared library where this function is defined.  This is only
     given if the frame's function is not known.

   If invoked without arguments, this command prints a backtrace for the
whole stack.  If given two integer arguments, it shows the frames whose
levels are between the two arguments (inclusive).  If the two arguments
are equal, it shows the single frame at the corresponding level.  It is
an error if LOW-FRAME is larger than the actual number of frames.  On
the other hand, HIGH-FRAME may be larger than the actual number of
frames, in which case only existing frames will be returned.  If the
option `--no-frame-filters' is supplied, then Python frame filters will
not be executed.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} commands are `backtrace' and
`where'.

Example
.......

Full stack backtrace:

     (gdb)
     -stack-list-frames
     ^done,stack=
     [frame={level='0',addr='0x0001076c',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='11'},
     frame={level='1',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='2',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='3',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='4',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='5',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='6',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='7',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='8',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='9',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='10',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='11',addr='0x00010738',func='main',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='4'}]
     (gdb)

   Show frames between LOW_FRAME and HIGH_FRAME:

     (gdb)
     -stack-list-frames 3 5
     ^done,stack=
     [frame={level='3',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='4',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     frame={level='5',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'}]
     (gdb)

   Show a single frame:

     (gdb)
     -stack-list-frames 3 3
     ^done,stack=
     [frame={level='3',addr='0x000107a4',func='foo',
       file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'}]
     (gdb)


"
! !

!GDBMI_stack_list_frames methodsFor:'accessing'!

operation
	^ 'stack-list-frames'
! !

!GDBMI_stack_list_frames methodsFor:'accessing-descriptors'!

resultDescription
    ^ (super resultDescription)
        define:#stack
            as:Array
            of:GDBFrame;
        yourself

    "Created: / 17-09-2014 / 00:00:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

