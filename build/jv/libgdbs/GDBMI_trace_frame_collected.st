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

GDBMICommand subclass:#GDBMI_trace_frame_collected
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_trace_frame_collected class methodsFor:'documentation'!

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
The `-trace-frame-collected' Command
------------------------------------

Synopsis
........

      -trace-frame-collected
         [--var-print-values VAR_PVAL]
         [--comp-print-values COMP_PVAL]
         [--registers-format REGFORMAT]
         [--memory-contents]

   This command returns the set of collected objects, register names,
trace state variable names, memory ranges and computed expressions that
have been collected at a particular trace frame.  The optional
parameters to the command affect the output format in different ways.
See the output description table below for more details.

   The reported names can be used in the normal manner to create
varobjs and inspect the objects themselves.  The items returned by this
command are categorized so that it is clear which is a variable, which
is a register, which is a trace state variable, which is a memory range
and which is a computed expression.

   For instance, if the actions were
     collect myVar, myArray[myIndex], myObj.field, myPtr->field, myCount + 2
     collect *(int*)0xaf02bef0@40

the object collected in its entirety would be `myVar'.  The object
`myArray' would be partially collected, because only the element at
index `myIndex' would be collected.  The remaining objects would be
computed expressions.

   An example output would be:

     (gdb)
     -trace-frame-collected
     ^done,
       explicit-variables=[{name='myVar',value='1'}],
       computed-expressions=[{name='myArray[myIndex]',value='0'},
                             {name='myObj.field',value='0'},
                             {name='myPtr->field',value='1'},
                             {name='myCount + 2',value='3'},
                             {name='$tvar1 + 1',value='43970027'}],
       registers=[{number='0',value='0x7fe2c6e79ec8'},
                  {number='1',value='0x0'},
                  {number='2',value='0x4'},
                  ...
                  {number='125',value='0x0'}],
       tvars=[{name='$tvar1',current='43970026'}],
       memory=[{address='0x0000000000602264',length='4'},
               {address='0x0000000000615bc0',length='4'}]
     (gdb)

   Where:

`explicit-variables'
     The set of objects that have been collected in their entirety (as
     opposed to collecting just a few elements of an array or a few
     struct members).  For each object, its name and value are printed.
     The `--var-print-values' option affects how or whether the value
     field is output.  If VAR_PVAL is 0, then print only the names; if
     it is 1, print also their values; and if it is 2, print the name,
     type and value for simple data types, and the name and type for
     arrays, structures and unions.

`computed-expressions'
     The set of computed expressions that have been collected at the
     current trace frame.  The `--comp-print-values' option affects
     this set like the `--var-print-values' option affects the
     `explicit-variables' set.  See above.

`registers'
     The registers that have been collected at the current trace frame.
     For each register collected, the name and current value are
     returned.  The value is formatted according to the
     `--registers-format' option.  See the `-data-list-register-values'
     command for a list of the allowed formats.  The default is `x'.

`tvars'
     The trace state variables that have been collected at the current
     trace frame.  For each trace state variable collected, the name and
     current value are returned.

`memory'
     The set of memory ranges that have been collected at the current
     trace frame.  Its content is a list of tuples.  Each tuple
     represents a collected memory range and has the following fields:

    `address'
          The start address of the memory range, as hexadecimal literal.

    `length'
          The length of the memory range, as decimal literal.

    `contents'
          The contents of the memory block, in hex.  This field is only
          present if the `--memory-contents' option is specified.



{No value for `GDBN'} Command
.............................

There is no corresponding {No value for `GDBN'} command.

Example
.......

-trace-list-variables
---------------------

Synopsis
........

      -trace-list-variables

   Return a table of all defined trace variables.  Each element of the
table has the following fields:

`name'
     The name of the trace variable.  This field is always present.

`initial'
     The initial value.  This is a 64-bit signed integer.  This field
     is always present.

`current'
     The value the trace variable has at the moment.  This is a 64-bit
     signed integer.  This field is absent iff current value is not
     defined, for example if the trace was never run, or is presently
     running.


{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `tvariables'.

Example
.......

     (gdb)
     -trace-list-variables
     ^done,trace-variables={nr_rows='1',nr_cols='3',
     hdr=[{width='15',alignment='-1',col_name='name',colhdr='Name'},
          {width='11',alignment='-1',col_name='initial',colhdr='Initial'},
          {width='11',alignment='-1',col_name='current',colhdr='Current'}],
     body=[variable={name='$trace_timestamp',initial='0'}
           variable={name='$foo',initial='10',current='15'}]}
     (gdb)

-trace-save
-----------

Synopsis
........

      -trace-save [-r ] FILENAME

   Saves the collected trace data to FILENAME.  Without the `-r'
option, the data is downloaded from the target and saved in a local
file.  With the `-r' option the target is asked to perform the save.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `tsave'.

-trace-start
------------

Synopsis
........

      -trace-start

   Starts a tracing experiments.  The result of this command does not
have any fields.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `tstart'.

-trace-status
-------------

Synopsis
........

      -trace-status

   Obtains the status of a tracing experiment.  The result may include
the following fields:

`supported'
     May have a value of either `0', when no tracing operations are
     supported, `1', when all tracing operations are supported, or
     `file' when examining trace file.  In the latter case, examining
     of trace frame is possible but new tracing experiement cannot be
     started.  This field is always present.

`running'
     May have a value of either `0' or `1' depending on whether tracing
     experiement is in progress on target.  This field is present if
     `supported' field is not `0'.

`stop-reason'
     Report the reason why the tracing was stopped last time.  This
     field may be absent iff tracing was never stopped on target yet.
     The value of `request' means the tracing was stopped as result of
     the `-trace-stop' command.  The value of `overflow' means the
     tracing buffer is full.  The value of `disconnection' means
     tracing was automatically stopped when {No value for `GDBN'} has
     disconnected.  The value of `passcount' means tracing was stopped
     when a tracepoint was passed a maximal number of times for that
     tracepoint.  This field is present if `supported' field is not `0'.

`stopping-tracepoint'
     The number of tracepoint whose passcount as exceeded.  This field
     is present iff the `stop-reason' field has the value of
     `passcount'.

`frames'
`frames-created'
     The `frames' field is a count of the total number of trace frames
     in the trace buffer, while `frames-created' is the total created
     during the run, including ones that were discarded, such as when a
     circular trace buffer filled up.  Both fields are optional.

`buffer-size'
`buffer-free'
     These fields tell the current size of the tracing buffer and the
     remaining space.  These fields are optional.

`circular'
     The value of the circular trace buffer flag.  `1' means that the
     trace buffer is circular and old trace frames will be discarded if
     necessary to make room, `0' means that the trace buffer is linear
     and may fill up.

`disconnected'
     The value of the disconnected tracing flag.  `1' means that
     tracing will continue after {No value for `GDBN'} disconnects, `0'
     means that the trace run will stop.

`trace-file'
     The filename of the trace file being examined.  This field is
     optional, and only present when examining a trace file.


{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `tstatus'.

-trace-stop
-----------

Synopsis
........

      -trace-stop

   Stops a tracing experiment.  The result of this command has the same
fields as `-trace-status', except that the `supported' and `running'
fields are not output.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `tstop'.


"
! !

!GDBMI_trace_frame_collected methodsFor:'accessing'!

operation
	^ 'trace-frame-collected'
! !

