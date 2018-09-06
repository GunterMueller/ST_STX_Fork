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

GDBMICommand subclass:#GDBMI_trace_find
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_trace_find class methodsFor:'documentation'!

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
The `-trace-find' Command
-------------------------

Synopsis
........

      -trace-find MODE [PARAMETERS...]

   Find a trace frame using criteria defined by MODE and PARAMETERS.
The following table lists permissible modes and their parameters.  For
details of operation, see *note tfind::.

`none'
     No parameters are required.  Stops examining trace frames.

`frame-number'
     An integer is required as parameter.  Selects tracepoint frame with
     that index.

`tracepoint-number'
     An integer is required as parameter.  Finds next trace frame that
     corresponds to tracepoint with the specified number.

`pc'
     An address is required as parameter.  Finds next trace frame that
     corresponds to any tracepoint at the specified address.

`pc-inside-range'
     Two addresses are required as parameters.  Finds next trace frame
     that corresponds to a tracepoint at an address inside the
     specified range.  Both bounds are considered to be inside the
     range.

`pc-outside-range'
     Two addresses are required as parameters.  Finds next trace frame
     that corresponds to a tracepoint at an address outside the
     specified range.  Both bounds are considered to be inside the
     range.

`line'
     Line specification is required as parameter.  *Note Specify
     Location::.  Finds next trace frame that corresponds to a
     tracepoint at the specified location.


   If `none' was passed as MODE, the response does not have fields.
Otherwise, the response may have the following fields:

`found'
     This field has either `0' or `1' as the value, depending on
     whether a matching tracepoint was found.

`traceframe'
     The index of the found traceframe.  This field is present iff the
     `found' field has value of `1'.

`tracepoint'
     The index of the found tracepoint.  This field is present iff the
     `found' field has value of `1'.

`frame'
     The information about the frame corresponding to the found trace
     frame.  This field is present only if a trace frame was found.
     *Note GDB/MI Frame Information::, for description of this field.


{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `tfind'.

-trace-define-variable
----------------------

Synopsis
........

      -trace-define-variable NAME [ VALUE ]

   Create trace variable NAME if it does not exist.  If VALUE is
specified, sets the initial value of the specified trace variable to
that value.  Note that the NAME should start with the `$' character.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `tvariable'.


"
! !

!GDBMI_trace_find methodsFor:'accessing'!

operation
	^ 'trace-find'
! !

