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
"{ Package: 'jv:libgdbs/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#GDBMIParserTests
	instanceVariableNames:'properties prop1 prop2 prop3'
	classVariableNames:''
	poolDictionaries:'GDBCommandStatus'
	category:'GDB-Private-Tests'
!

!GDBMIParserTests class methodsFor:'documentation'!

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

!GDBMIParserTests methodsFor:'accessing'!

prop1
    ^ prop1
!

prop2
    ^ prop2
!

prop3
    ^ prop3
! !

!GDBMIParserTests methodsFor:'accessing-properties'!

properties
    ^ GDBObject getPropertiesOf: self.

    "Modified: / 20-06-2014 / 09:04:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: name
    ^ GDBObject getProperty: name of: self

    "Created: / 31-05-2014 / 00:00:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 09:05:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: name put: value
    ^ GDBObject setProperty: name of: self to: value

    "Created: / 31-05-2014 / 00:01:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 09:05:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParserTests methodsFor:'running'!

setUp
    Magritte::MADescriptionBuilder default flush.

    "Created: / 11-11-2017 / 12:02:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    properties := nil.

    "Created: / 18-06-2014 / 07:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParserTests methodsFor:'tests - C strings'!

test_c_string_01
    self assert:(GDBMIParser on:'"Hello" xxx') parseCString = 'Hello'.
    self assert:(GDBMIParser on:'"\"Hello\"" xxx') parseCString = '"Hello"'.
    self assert:(GDBMIParser on:'"\H\e\l\l\o" xxx') parseCString = 'Hello'.
    self assert:(GDBMIParser on:'"Hel\nlo" xxx') parseCString = 'Hel
lo'.
    self assert:(GDBMIParser on:'"X\xE1X" xxx') parseCString = ('X', (Character codePoint: 16rE1), 'X').
    self 
        assert:(GDBMIParser 
                on:'"warning: File \"/home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/stx/.gdbinit\" auto-loading has been declined by your `auto-load safe-path'' set to \"$debugdir:$datadir/auto-load\".\n"') 
                    parseCString 
                    = 'warning: File "/home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/stx/.gdbinit" auto-loading has been declined by your `auto-load safe-path'' set to "$debugdir:$datadir/auto-load".
'.

    "Created: / 28-05-2014 / 00:05:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-02-2018 / 08:55:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2018 / 21:59:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParserTests methodsFor:'tests - commands'!

test_command_01
    | command |

    command := (GDBMIParser on:'b factorial') parseCommand.
    self assert:command isCLICommand.
    self assert:command token isNil.
    self assert:command value = 'b factorial'.

    "Created: / 24-06-2014 / 23:21:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_02
    | command |

    command := (GDBMIParser on:'-gdb-exit') parseCommand.
    self assert:command isMICommand.
    self assert:command class == GDBMI_gdb_exit.
    self assert:command arguments isEmpty

    "Created: / 24-06-2014 / 23:29:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParserTests methodsFor:'tests - commands reponses'!

test_command_break_created_01
    | parser  events |

    parser := GDBMIParser 
            on:'=breakpoint-created,bkpt={number="1",type="breakpoint",disp="keep",enabled="y",addr="0xf3416ac0",func="__STX_AddTimeout",file="util.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/stx_8_0_0_x32_lin/build/stx/librun/util.c",line="143",thread-groups=["i1"],times="0",original-location="__STX_AddTimeout"}
'.
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:events first class == GDBBreakpointCreatedEvent.

    "Created: / 11-07-2017 / 10:07:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_break_created_02
    | parser  events |

    parser := GDBMIParser 
            on:'=breakpoint-created,bkpt={number="1",type="breakpoint",disp="keep",enabled="y",addr="<MULTIPLE>",times="0",original-location="stxThinLock"},{number="1.1",enabled="y",addr="0x00007fffeb6a0423",func="stxJ_MONITORENTER",file="../include/thinlocks.h",fullname="/home/jv/Private/Projects/SmalltalkX/sources/feature-94-revamp-thinlocks/build/stx/stc/thinlocks.h",line="127",thread-groups=["i1"]},{number="1.2",enabled="y",addr="0x00007ffff4c3b129",func="stxThinLock",file="../include/thinlocks.h",fullname="/home/jv/Private/Projects/SmalltalkX/sources/feature-94-revamp-thinlocks/build/stx/stc/thinlocks.h",line="128",thread-groups=["i1"]}
'.
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:events first class == GDBBreakpointCreatedEvent.

    "Created: / 03-10-2017 / 11:20:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_break_list_01
    | parser  events |

    parser := GDBMIParser 
            on:'1^done,BreakpointTable={nr_rows="1",nr_cols="6",hdr=[{width="3",alignment="-1",col_name="number",colhdr="Num"},{width="14",alignment="-1",col_name="type",colhdr="Type"},{width="4",alignment="-1",col_name="disp",colhdr="Disp"},{width="3",alignment="-1",col_name="enabled",colhdr="Enb"},{width="10",alignment="-1",col_name="addr",colhdr="Address"},{width="40",alignment="2",col_name="what",colhdr="What"}],body=[bkpt={number="1",type="breakpoint",disp="keep",enabled="y",addr="0x000100d0",func="main",file="hello.c",fullname="/home/foo/hello.c",line="5",thread-groups=["i1"],times="0",ignore="3"}]}
'.
    parser token2CommandMappingBlock:[:token | GDBMI_break_list new ].
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:(events first result propertyAt:'BreakpointTable') notNil.
    self 
        assert:((events first result propertyAt:'BreakpointTable') at:'body') 
                notNil.

    "Created: / 20-06-2014 / 09:08:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_break_modified_01
    | parser  events |

    parser := GDBMIParser 
            on:'=breakpoint-modified,bkpt={number="1",type="breakpoint",disp="keep",enabled="y",addr="0xf33f4daf",func="_mark",file="new.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/stx_8_0_0_x32_lin/build/stx/librun/new.c",line="18538",thread-groups=["i1"],times="0",script={"set $x = $x + 1","c"},original-location="_mark"}
'.
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:events first class == GDBBreakpointModifiedEvent.
    self assert:(events first breakpoints first propertyAt:'script') = ('set $x = $x + 1', Character cr ,  'c')

    "Created: / 06-07-2017 / 07:47:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-11-2017 / 20:18:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_data_read_memory_01
    | parser events result |

    parser := GDBMIParser 
            on:('9^done,addr="0x00001390",nr-bytes="6",total-bytes="6",
next-row="0x00001396",prev-row="0x0000138e",next-page="0x00001396",
prev-page="0x0000138a",memory=[
{addr="0x00001390",data=["0x00","0x01"]},
{addr="0x00001392",data=["0x02","0x03"]},
{addr="0x00001394",data=["0x04","0x05"]}]' asStringCollection asStringWith:'').
    parser token2CommandMappingBlock:[:token | GDBMI_data_read_memory new ].
    events := parser parseOutput.

    self assert:events size == 1.
    result := events first result.

    self assert:((result value) isKindOf: GDBMemoryDump).
    self assert: (result value) addr = '0x00001390'.
    self assert: (result value) memory size = 3.

    "Created: / 24-01-2018 / 08:55:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-01-2018 / 09:07:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_data_read_memory_02
    | parser events result |

    parser := GDBMIParser 
            on:('4^done,addr="0x000013a0",nr-bytes="32",total-bytes="32",
next-row="0x000013c0",prev-row="0x0000139c",
next-page="0x000013c0",prev-page="0x00001380",memory=[
{addr="0x000013a0",data=["0x10","0x11","0x12","0x13"],ascii="xxxx"},
{addr="0x000013a4",data=["0x14","0x15","0x16","0x17"],ascii="xxxx"},
{addr="0x000013a8",data=["0x18","0x19","0x1a","0x1b"],ascii="xxxx"},
{addr="0x000013ac",data=["0x1c","0x1d","0x1e","0x1f"],ascii="xxxx"},
{addr="0x000013b0",data=["0x20","0x21","0x22","0x23"],ascii=" !!\"#"},
{addr="0x000013b4",data=["0x24","0x25","0x26","0x27"],ascii="$%&''"},
{addr="0x000013b8",data=["0x28","0x29","0x2a","0x2b"],ascii="()*+"},
{addr="0x000013bc",data=["0x2c","0x2d","0x2e","0x2f"],ascii=",-./"}]' asStringCollection asStringWith:'').
    parser token2CommandMappingBlock:[:token | GDBMI_data_read_memory new ].
    events := parser parseOutput.

    self assert:events size == 1.
    result := events first result.

    self assert:((result value) isKindOf: GDBMemoryDump).
    self assert: (result value) addr = '0x000013a0'.
    self assert: (result value) memory size = 8.

    "Created: / 25-01-2018 / 22:53:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_gdb_exit
    | parser events result |

    parser := GDBMIParser 
            on:'1^exit'.
    parser token2CommandMappingBlock:[:token | GDBMI_gdb_exit new ].
    events := parser parseOutput.

    self assert:events size == 1.
    result := events first result.

    self assert:result value isNil.

    "Created: / 31-05-2017 / 21:19:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_stack_list_frames_01
    | parser  events |

    parser := GDBMIParser 
            on:'1^done,stack=[frame={level="0",addr="0x00010734",func="callee4",file="../../../devo/gdb/testsuite/gdb.mi/basics.c",fullname="/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c",line="8"},frame={level="1",addr="0x0001076c",func="callee3",file="../../../devo/gdb/testsuite/gdb.mi/basics.c",fullname="/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c",line="17"},frame={level="2",addr="0x0001078c",func="callee2",file="../../../devo/gdb/testsuite/gdb.mi/basics.c",fullname="/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c",line="22"},frame={level="3",addr="0x000107b4",func="callee1",file="../../../devo/gdb/testsuite/gdb.mi/basics.c",fullname="/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c",line="27"},frame={level="4",addr="0x000107e0",func="main",file="../../../devo/gdb/testsuite/gdb.mi/basics.c",fullname="/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c",line="32"}]
'.
    parser token2CommandMappingBlock:[:token | GDBMI_stack_list_frames new ].
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:(events first result propertyAt:'stack') size == 5.

    "Created: / 19-06-2014 / 22:00:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 09:18:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_thread_info_01
    | parser events result |

    parser := GDBMIParser 
            on:'1^done,threads=[{id="2",target-id="Thread 0xb7e14b90 (LWP 21257)",frame={level="0",addr="0xffffe410",func="__kernel_vsyscall",args=[]},state="running"},{id="1",target-id="Thread 0xb7e156b0 (LWP 21254)",frame={level="0",addr="0x0804891f",func="foo",args=[{name="i",value="10"}],file="/tmp/a.c",fullname="/tmp/a.c",line="158"},state="running"}],current-thread-id="1"'.        ''.
    parser token2CommandMappingBlock:[:token | GDBMI_thread_info new ].
    events := parser parseOutput.

    self assert:events size == 1.
    result := events first result.

    self assert: (result propertyAt: 'current-thread-id') = '1'.
    self assert: (result propertyAt:'threads') size == 2.
    self assert:((result propertyAt:'threads') first isKindOf: GDBThreadInfo).
    self assert: (result propertyAt:'threads') first id = 2.
    self assert: (result propertyAt:'threads') first targetId = 'Thread 0xb7e14b90 (LWP 21257)'.
    self assert: (result propertyAt:'threads') first state == GDBThreadStateRunning theOneAndOnlyInstance.

    "Created: / 08-03-2015 / 08:13:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_var_create_01
    | parser events result |

    parser := GDBMIParser 
            on:'14^done,name="var1",numchild="0",value="5",type="int",thread-id="1",has_more="0"'.
    parser token2CommandMappingBlock:[:token | GDBMI_var_create new ].
    events := parser parseOutput.

    self assert:events size == 1.
    result := events first result.

    self assert:((result value) isKindOf: GDBVariableObject).
    self assert: (result value) id = 'var1'.
    self assert:((result value) instVarNamed: #value) = '5'.

    "Created: / 19-03-2015 / 07:46:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-02-2018 / 09:18:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_command_var_create_02
    | parser events result |

    parser := GDBMIParser 
            on:'212^error,msg="Cannot instantiate printer for default visualizer"'.
    parser token2CommandMappingBlock:[:token | GDBMI_var_create new ].
    events := parser parseOutput.

    self assert:events size == 1.
    result := events first result.

    self assert: result isError.
    self assert: (result propertyAt: #msg) = 'Cannot instantiate printer for default visualizer'.
    self assert: result value isNil.

    "Created: / 02-02-2018 / 09:27:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

test_command_var_update_01
    | parser events result changelist |

    parser := GDBMIParser 
            on:('3^done,changelist=[{name="var1",value="3",in_scope="true",
type_changed="false"}]' asStringCollection asStringWith:'').
    parser token2CommandMappingBlock:[:token | GDBMI_var_update new ].
    events := parser parseOutput.

    self assert:events size == 1.
    result := events first result.
    changelist := result propertyAt: #changelist.  

    self assert: changelist size == 1.
    self assert:(changelist first isKindOf: GDBVariableObjectChange).
    self assert:(changelist first id = 'var1').
    self assert:(changelist first value = '3').
    self assert:(changelist first isInvalid = false).
    self assert:(changelist first inScope = true)

    "Created: / 29-01-2018 / 20:21:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2018 / 22:15:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_data_disassemble_01
    | parser  events  result  lines |

    parser := GDBMIParser 
            on:('8^done,asm_insns=[src_and_asm_line={line="3",file="factorial1.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/stx_8_0_0/build/jv/libgdbs/tests/c/factorial1.c",line_asm_insn=[{address="0x000000000000064a",func-name="factorial",offset="0",opcodes="55",inst="push   %rbp"},{address="0x000000000000064b",func-name="factorial",offset="1",opcodes="48 89 e5",inst="mov    %rsp,%rbp"},{address="0x000000000000064e",func-name="factorial",offset="4",opcodes="48 83 ec 10",inst="sub    $0x10,%rsp"},{address="0x0000000000000652",func-name="factorial",offset="8",opcodes="89 7d fc",inst="mov    %edi,-0x4(%rbp)"}]},src_and_asm_line={line="4",file="factorial1.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/stx_8_0_0/build/jv/libgdbs/tests/c/factorial1.c",line_asm_insn=[{address="0x0000000000000655",func-name="factorial",offset="11",opcodes="83 7d fc 01",inst="cmpl   $0x1,-0x4(%rbp)"},{address="0x0000000000000659",func-name="factorial",offset="15",opcodes="75 07",inst="jne    0x662 <factorial+24>"}]},src_and_asm_line={line="5",file="factorial1.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/stx_8_0_0/build/jv/libgdbs/tests/c/factorial1.c",line_asm_insn=[{address="0x000000000000065b",func-name="factorial",offset="17",opcodes="b8 01 00 00 00",inst="mov    $0x1,%eax"},{address="0x0000000000000660",func-name="factorial",offset="22",opcodes="eb 11",inst="jmp    0x673 <factorial+41>"}]},src_and_asm_line={line="6",file="factorial1.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/stx_8_0_0/build/jv/libgdbs/tests/c/factorial1.c",line_asm_insn=[]},src_and_asm_line={line="7",file="factorial1.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/stx_8_0_0/build/jv/libgdbs/tests/c/factorial1.c",line_asm_insn=[{address="0x0000000000000662",func-name="factorial",offset="24",opcodes="8b 45 fc",inst="mov    -0x4(%rbp),%eax"},{address="0x0000000000000665",func-name="factorial",offset="27",opcodes="83 e8 01",inst="sub    $0x1,%eax"},{address="0x0000000000000668",func-name="factorial",offset="30",opcodes="89 c7",inst="mov    %eax,%edi"},{address="0x000000000000066a",func-name="factorial",offset="32",opcodes="e8 db ff ff ff",inst="callq  0x64a <factorial>"},{address="0x000000000000066f",func-name="factorial",offset="37",opcodes="0f af 45 fc",inst="imul   -0x4(%rbp),%eax"}]},src_and_asm_line={line="8",file="factorial1.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/stx_8_0_0/build/jv/libgdbs/tests/c/factorial1.c",line_asm_insn=[]},src_and_asm_line={line="9",file="factorial1.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/stx_8_0_0/build/jv/libgdbs/tests/c/factorial1.c",line_asm_insn=[{address="0x0000000000000673",func-name="factorial",offset="41",opcodes="c9",inst="leaveq "},{address="0x0000000000000674",func-name="factorial",offset="42",opcodes="c3",inst="retq   "}]}]').
    parser token2CommandMappingBlock:[:token | GDBMI_data_disassemble new ].
    events := parser parseOutput.
    self assert:events size == 1.
    result := events first result.
    lines := result propertyAt:#'asm_insns'.
    self assert: lines isSequenceable.
    self assert:(lines first isKindOf:GDBInstructionsAndSourceLine).
    self assert:(lines first instructions isSequenceable).
    self assert:(lines first instructions first isKindOf: GDBInstruction).
    self assert:(lines first instructions first opcodes isByteArray).
    self assert:(lines first instructions first address isInteger).

    "Modified: / 03-07-2018 / 14:44:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_data_disassemble_02
    | parser  events  result  lines |

    parser := GDBMIParser 
            on:('67^done,asm_insns=[{address="0x000000000070b748",func-name="bee!!JITObjectReference>>#sourceOffset:",offset="0",opcodes="48 89 c6",inst="mov    %rax,%rsi"},{address="0x000000000070b74b",func-name="bee!!JITObjectReference>>#sourceOffset:",offset="3",opcodes="48 8b 44 24 08",inst="mov    0x8(%rsp),%rax"}]').
    parser token2CommandMappingBlock:[:token | GDBMI_data_disassemble new ].
    events := parser parseOutput.
    self assert:events size == 1.
    result := events first result.
    lines := result propertyAt:#'asm_insns'.
    self assert: lines isSequenceable.
    self assert:(lines first isKindOf:GDBInstruction).
    self assert:(lines first opcodes isByteArray).
    self assert:(lines first address isInteger).

    "Created: / 03-07-2018 / 17:12:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParserTests methodsFor:'tests - examples'!

test_simple_example_01
    | parser  events |

    parser := GDBMIParser 
            on:'^done,bkpt={number="1",type="breakpoint",disp="keep",enabled="y",addr="0x08048564",func="main",file="myprog.c",fullname="/home/nickrob/myprog.c",line="68",thread-groups=["i1"],times="0"}
(gdb)
'.
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:events first isCommandResultEvent.
    self assert:events first result status == CommandStatusDone.
    self 
        assert:((events first result propertyAt:'bkpt') at:'addr') = '0x08048564'

    "Created: / 30-05-2014 / 23:53:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-06-2014 / 21:55:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_simple_example_02
    | input parser events |


    input := '1234*running
1234^done
(gdb)
' readStream.
    parser := GDBMIParser on: input.
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:events first token == 1234.

    parser := GDBMIParser on: input.
    events := parser parseOutput.  
    self assert:events size == 1.
    self assert:events first isCommandResultEvent.
    self assert:events first result status == CommandStatusDone.
    self assert:events first token == 1234

    "Created: / 03-06-2014 / 00:50:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2015 / 09:24:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_simple_session_01
    | parser  events |

    parser := GDBMIParser 
            on:'~"GNU gdb (GDB) 7.5-ubuntu\n"
~"Copyright (C) 2012 Free Software Foundation, Inc.\n"
~"License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>\nThis is free software: you are free to change and redistribute it.\nThere is NO WARRANTY, to the extent permitted by law.  Type \"show copying\"\nand \"show warranty\" for details.\n"
~"This GDB was configured as \"x86_64-linux-gnu\".\nFor bug reporting instructions, please see:\n"
~"<http://www.gnu.org/software/gdb/bugs/>...\n"
~"Reading symbols from /home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial..."
~"done.\n"
(gdb) 
'.
    events := parser parseOutput.
    self assert:events size == 7.
    self assert:events first isConsoleOutputEvent.
    self assert:events first value = 'GNU gdb (GDB) 7.5-ubuntu
'.
    self assert:events last isConsoleOutputEvent.
    self assert:events last value = 'done.
'.
    parser := GDBMIParser 
            on:'^done,bkpt={number="1",type="breakpoint",disp="keep",enabled="y",addr="0x0000000000400556",func="main",file="factorial.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial.c",line="12",times="0",original-location="main"}
(gdb) 
'.
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:events first result status == CommandStatusDone.
    self assert:((events first result propertyAt:'bkpt') at:'addr') 
                = '0x0000000000400556'.
    parser := GDBMIParser 
            on:'~"Breakpoint 2 at 0x400527: file factorial.c, line 4.\n"
=breakpoint-created,bkpt={number="2",type="breakpoint",disp="keep",enabled="y",addr="0x0000000000400527",func="factorial",file="factorial.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial.c",line="4",times="0",original-location="factorial"}
^done
(gdb)
'.
    events := parser parseOutput.
    self assert:events size == 2.
    self assert:events first isConsoleOutputEvent.
    self assert:events first value 
                = 'Breakpoint 2 at 0x400527: file factorial.c, line 4.
'.
    self assert:events second isNotificationEvent.
    self assert:events second class == GDBBreakpointCreatedEvent.
    self assert:events second type = 'breakpoint-created'.
    self assert:events second breakpoints size == 1.
    self assert:events second breakpoints first class == GDBBreakpoint.
    self assert:events second breakpoints first number = '2'.
    self assert:events second breakpoints first file = 'factorial.c'.
    parser := GDBMIParser 
            on:'&"info break\n"
~"Num     Type           Disp Enb Address            What\n"
~"1       breakpoint     keep y   0x0000000000400556 in main at factorial.c:12\n"
~"2       breakpoint     keep y   0x0000000000400527 in factorial at factorial.c:4\n"
^done
(gdb)
'.
    events := parser parseOutput.
    self assert:events size == 5.
    self assert:events first isLogOutputEvent.
    self assert:events first value = 'info break
'.
    self assert:events second isConsoleOutputEvent.
    self assert:events third isConsoleOutputEvent.
    self assert:events fourth isConsoleOutputEvent.
    self assert:events fifth isCommandResultEvent.
    parser := GDBMIParser 
            on:'&"run\n"
~"Starting program: /home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial \n"
=thread-group-started,id="i1",pid="17240"
=thread-created,id="1",group-id="i1"
^running
*running,thread-id="all"
(gdb)
'.
    "/ Note that parser yields anb output after first async event,
    "/ so to parse all events in the above input we have to call
    "/ parseOutput couple times
    events := parser parseOutput.
    self assert:events size == 3.
    self assert:events first isLogOutputEvent.
    self assert:events second isConsoleOutputEvent.
    self assert:events third type = 'thread-group-started'.
    self assert:events third threadGroupId = 'i1'
.
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:events first type = 'thread-created'.
    self assert:events first threadId = 1.

    events := parser parseOutput.
    self assert:events size == 2.
    self assert:events first isCommandResultEvent.
    self assert:events second type = 'running'.

    "Created: / 01-06-2014 / 22:57:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2017 / 20:29:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_simple_session_01_crlf
    | parser  events |

    parser := GDBMIParser 
            on:('~"GNU gdb (GDB) 7.5-ubuntu\n"
~"Copyright (C) 2012 Free Software Foundation, Inc.\n"
~"License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>\nThis is free software: you are free to change and redistribute it.\nThere is NO WARRANTY, to the extent permitted by law.  Type \"show copying\"\nand \"show warranty\" for details.\n"
~"This GDB was configured as \"x86_64-linux-gnu\".\nFor bug reporting instructions, please see:\n"
~"<http://www.gnu.org/software/gdb/bugs/>...\n"
~"Reading symbols from /home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial..."
~"done.\n"
(gdb) 
' asStringCollection asStringWith: (Character return, Character lf)).
    events := parser parseOutput.
    self assert:events size == 7.
    self assert:events first isConsoleOutputEvent.
    self assert:events first value = 'GNU gdb (GDB) 7.5-ubuntu
'.
    self assert:events last isConsoleOutputEvent.
    self assert:events last value = 'done.
'.
    parser := GDBMIParser 
            on:'^done,bkpt={number="1",type="breakpoint",disp="keep",enabled="y",addr="0x0000000000400556",func="main",file="factorial.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial.c",line="12",times="0",original-location="main"}
(gdb) 
'.
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:events first result status == CommandStatusDone.
    self assert:((events first result propertyAt:'bkpt') at:'addr') 
                = '0x0000000000400556'.
    parser := GDBMIParser 
            on:'~"Breakpoint 2 at 0x400527: file factorial.c, line 4.\n"
=breakpoint-created,bkpt={number="2",type="breakpoint",disp="keep",enabled="y",addr="0x0000000000400527",func="factorial",file="factorial.c",fullname="/home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial.c",line="4",times="0",original-location="factorial"}
^done
(gdb)
'.
    events := parser parseOutput.
    self assert:events size == 2.
    self assert:events first isConsoleOutputEvent.
    self assert:events first value 
                = 'Breakpoint 2 at 0x400527: file factorial.c, line 4.
'.
    self assert:events second isNotificationEvent.
    self assert:events second class == GDBBreakpointCreatedEvent.
    self assert:events second type = 'breakpoint-created'.
    self assert:events second breakpoints size == 1.
    self assert:events second breakpoints first class == GDBBreakpoint.
    self assert:events second breakpoints first number = '2'.
    self assert:events second breakpoints first file = 'factorial.c'.
    parser := GDBMIParser 
            on:'&"info break\n"
~"Num     Type           Disp Enb Address            What\n"
~"1       breakpoint     keep y   0x0000000000400556 in main at factorial.c:12\n"
~"2       breakpoint     keep y   0x0000000000400527 in factorial at factorial.c:4\n"
^done
(gdb)
'.
    events := parser parseOutput.
    self assert:events size == 5.
    self assert:events first isLogOutputEvent.
    self assert:events first value = 'info break
'.
    self assert:events second isConsoleOutputEvent.
    self assert:events third isConsoleOutputEvent.
    self assert:events fourth isConsoleOutputEvent.
    self assert:events fifth isCommandResultEvent.
    parser := GDBMIParser 
            on:'&"run\n"
~"Starting program: /home/jv/Private/Projects/SmalltalkX/sources/branches/jv1/build/jv/libgdbs/tests/c/factorial \n"
=thread-group-started,id="i1",pid="17240"
=thread-created,id="1",group-id="i1"
^running
*running,thread-id="all"
(gdb)
'.
    "/ Note that parser yields anb output after first async event,
    "/ so to parse all events in the above input we have to call
    "/ parseOutput couple times
    events := parser parseOutput.
    self assert:events size == 3.
    self assert:events first isLogOutputEvent.
    self assert:events second isConsoleOutputEvent.
    self assert:events third type = 'thread-group-started'.
    self assert:events third threadGroupId = 'i1'
.
    events := parser parseOutput.
    self assert:events size == 1.
    self assert:events first type = 'thread-created'.
    self assert:events first threadId = 1.

    events := parser parseOutput.
    self assert:events size == 2.
    self assert:events first isCommandResultEvent.
    self assert:events second type = 'running'.

    "Created: / 12-01-2018 / 08:42:15 / jv"
! !

!GDBMIParserTests methodsFor:'tests - values'!

test_bytearray_01
    self assert:(GDBMIParser on:'"48 89 e5"') parseByteArray =#[16r48 16r89 16re5].

    "Created: / 22-06-2018 / 11:22:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_list_01
    | list |

    list := (GDBMIParser on:'[]') parseList.
    self assert:list class == Array.
    self assert:list isEmpty.

    "Created: / 18-06-2014 / 07:13:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_list_02
    | list |

    list := (GDBMIParser on:'["i1","i2"]') parseList.
    self assert:list size == 2.
    self assert:list first = 'i1'.
    self assert:list second = 'i2'.

    "Created: / 19-06-2014 / 09:24:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_list_03
    | list |

    list := (GDBMIParser on:'[["1","2"],"i2"]') parseList.
    self assert:list size == 2.
    self assert:list first size == 2.
    self assert:list first first = '1'.
    self assert:list first second = '2'.
    self assert:list second = 'i2'.

    "Created: / 19-06-2014 / 09:25:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_list_04
    | list |

    list := (GDBMIParser 
            on:'[bkpt={number="1",line="2"},bkpt={number="2",line="10"}]') parseList.
    self assert:list size == 2.
    self assert:list first size == 2.
    self assert:(list first at:'number') = '1'.
    self assert:(list first at:'line') = '2'.
    self assert:list second size == 2.
    self assert:(list second at:'number') = '2'.
    self assert:(list second at:'line') = '10'.

    "Created: / 19-06-2014 / 09:29:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_tuple_01
    | tuple |

    tuple := (GDBMIParser on:'{}') parseTuple.
    self assert:tuple class == Dictionary.
    self assert:tuple isEmpty.

    "Created: / 14-06-2014 / 02:24:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-06-2014 / 07:03:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_tuple_02a
    | tuple |

    tuple := (GDBMIParser on:'{p1="XXX"}') parseTuple.
    self assert:tuple class == Dictionary.
    self assert:tuple size == 1.
    self assert:(tuple at:'p1') = 'XXX'.

    "Created: / 18-06-2014 / 07:12:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_tuple_02b
    | tuple |

    tuple := (GDBMIParser on:'{p1=["i1","i2"]}') parseTuple.
    self assert:tuple class == Dictionary.
    self assert:tuple size == 1.
    self assert:(tuple at:'p1') asArray = #( 'i1' 'i2' )

    "Created: / 18-06-2014 / 07:09:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_tuple_02c
    | tuple |

    tuple := (GDBMIParser on:'{p1={x="10",y="10"}}') parseTuple.
    self assert:tuple class == Dictionary.
    self assert:tuple size == 1.
    self assert:(tuple at:'p1') class == Dictionary.
    self assert:((tuple at:'p1') at:'x') = '10'.
    self assert:((tuple at:'p1') at:'y') = '10'.

    "Created: / 18-06-2014 / 07:12:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_tuple_03a
    | tuple |

    tuple := (GDBMIParser on:'{"c"}') parseTuple.
    self assert:tuple = #('c').

    "Created: / 06-07-2017 / 07:45:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_tuple_03b
    | tuple |

    tuple := (GDBMIParser on:'{"line1","line2"}') parseTuple.
    self assert:tuple = #('line1' 'line2').

    "Created: / 06-07-2017 / 08:21:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParserTests methodsFor:'tests - values - typed'!

test_typed_boolean
    self assert:(GDBMIParser on:'"y"') parseValueAsBoolean = true.
    self assert:(GDBMIParser on:'"n"') parseValueAsBoolean = false.
    self assert:(GDBMIParser on:'"yX"') parseValueAsBoolean = 'yX'.
    self assert:(GDBMIParser on:'"nM"') parseValueAsBoolean = 'nM'.
    self assert:(GDBMIParser on:'"1"') parseValueAsBoolean = true.
    self assert:(GDBMIParser on:'"0"') parseValueAsBoolean = false.
    self assert:(GDBMIParser on:'"1X"') parseValueAsBoolean = '1X'.
    self assert:(GDBMIParser on:'"0M"') parseValueAsBoolean = '0M'.
    self assert:(GDBMIParser on:'"no"') parseValueAsBoolean = 'no'.
    self assert:(GDBMIParser on:'"12xyz"') parseValueAsBoolean = '12xyz'.
    self assert:(GDBMIParser on:'"true"') parseValueAsBoolean = true.
    self assert:(GDBMIParser on:'"false"') parseValueAsBoolean = false.
    self assert:(GDBMIParser on:'"invalid"') parseValueAsBoolean = 'invalid'.
    self assert:(GDBMIParser on:'"truelike"') parseValueAsBoolean = 'truelike'.
    self assert:(GDBMIParser on:'"falselike"') parseValueAsBoolean = 'falselike'.

    "Created: / 18-06-2014 / 23:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2018 / 22:21:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_typed_integer
    self assert:(GDBMIParser on:'"123"') parseValueAsInteger == 123.
    self assert:(GDBMIParser on:'"0"') parseValueAsInteger == 0.
    self assert:(GDBMIParser on:'"no"') parseValueAsInteger = 'no'.
    self assert:(GDBMIParser on:'"12xyz"') parseValueAsInteger = '12xyz'.
    self assert:(GDBMIParser on:'"0xFaB"') parseValueAsInteger == 16rFaB. 
    self assert:(GDBMIParser on:'"0x123"') parseValueAsInteger == 16r123.

    "Created: / 19-06-2014 / 09:39:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2018 / 14:50:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_typed_list_01a
    | object |

    object := (GDBMIParser on:'["123","456"]') parseValueAsListOf:Integer.
    self assert:object size == 2.
    self assert:object first == 123.
    self assert:object second == 456.

    "Created: / 19-06-2014 / 09:40:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_typed_list_02a
    | object |

    object := (GDBMIParser on:'["123","456"]') parseValueAsListOf:String.
    self assert:object size == 2.
    self assert:object first = '123'.
    self assert:object second = '456'.

    "Created: / 19-06-2014 / 09:41:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_typed_list_03a
    | objectDesc stringDesc switchDesc list |

    objectDesc := GDBMAContainer forClass:self class.
    objectDesc define:#prop1 as:Integer.
    objectDesc define:#prop2 as:Boolean.        

    stringDesc := Magritte::MAStringDescription new.

    switchDesc := GDBMADescriptionSwitch forTag: 'object'  use: objectDesc forTag: nil  use: stringDesc.

    list := (GDBMIParser on:'[object={prop1="123",prop2="n"},"xxx"]') parseValueAsListOf: nil describedBy: switchDesc.
    self assert: list size == 2.
    self assert: (list first isKindOf: self class).
    self assert: (list first prop1 = 123).
    self assert: (list first prop2 = false).
    self assert: (list second = 'xxx').

    "Created: / 03-07-2018 / 16:35:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_typed_object_01a
    | descriptor  object |

    descriptor := GDBMAContainer forClass:self class.
    descriptor define:#prop1 as:Integer.
    descriptor define:#prop2 as:Boolean.
    object := (GDBMIParser on:'{prop1="123",prop2="y"}') 
            parseValueAsInstanceOf:self class
            describedBy:descriptor.
    self assert:object class == self class.
    self assert:object prop1 == 123.
    self assert:object prop2.
    self assert:object properties isEmptyOrNil

    "Created: / 18-06-2014 / 09:01:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2014 / 22:37:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_typed_object_01b
    | descriptor  object |

    descriptor := GDBMAContainer forClass:self class.
    descriptor 
        define:#prop1
        as:Array
        of:Integer.
    object := (GDBMIParser on:'{prop1=["123"]}') 
            parseValueAsInstanceOf:self class
            describedBy:descriptor.
    self assert:object class == self class.
    self assert:object prop1 size == 1.
    self assert:object prop1 first = 123.
    self assert:object properties isEmptyOrNil

    "Created: / 19-06-2014 / 09:42:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2014 / 23:01:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_typed_object_02a
    | descriptor  object |

    descriptor := GDBMAContainer forClass:self class.
    descriptor define:#prop1 as:Integer.
    descriptor define:#prop2 as:Boolean.
    object := (GDBMIParser 
            on:'[{prop1="123",prop2="y"},{prop1="789",prop2="n"}]') 
                parseValueAsListOf:self class
                describedBy:descriptor.
    self assert:object size == 2.
    self assert:object first class == self class.
    self assert:object first prop1 == 123.
    self assert:object first prop2.
    self assert:object first properties isEmptyOrNil.
    self assert:object second class == self class.
    self assert:object second prop1 == 789.
    self assert:object second prop2 not.
    self assert:object second properties isEmptyOrNil

    "Created: / 17-09-2014 / 07:42:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2014 / 23:01:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_typed_object_02b
    | descriptor  object |

    descriptor := GDBMAContainer forClass:self class.
    descriptor define:#prop1 as:Integer.
    descriptor define:#prop2 as:Boolean.
    object := (GDBMIParser 
            on:'[object={prop1="123",prop2="y"},object={prop1="789",prop2="n"}]') 
                parseValueAsListOf:self class
                describedBy:descriptor.
    self assert:object size == 2.
    self assert:object first class == self class.
    self assert:object first prop1 == 123.
    self assert:object first prop2.
    self assert:object first properties isEmptyOrNil.
    self assert:object second class == self class.
    self assert:object second prop1 == 789.
    self assert:object second prop2 not.
    self assert:object second properties isEmptyOrNil

    "Created: / 17-09-2014 / 07:43:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2014 / 23:01:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_typed_object_03a
    | descriptor  object |

    descriptor := GDBMAContainer forClass:self class.
    descriptor add: 
        (Magritte::MASingleOptionDescription new
            optionsAndLabels: (Array with: 1 -> 'one' with: 2 -> 'two' with: #more -> 'more');
            accessor: (GDBMAPropertyAccessor forPropertyNamed: 'prop1')).

    object := (GDBMIParser on:'{prop1="one"}') 
                parseValueAsInstanceOf:self class
                describedBy:descriptor.
    self assert:object class == self class.
    self assert:object prop1 == 1.

    object := (GDBMIParser on:'{prop1="more"}') 
                parseValueAsInstanceOf:self class
                describedBy:descriptor.
    self assert:object class == self class.
    self assert:object prop1 == #more.         

    self should: [ 
    object := (GDBMIParser on:'{prop1="fail"}') 
                parseValueAsInstanceOf:self class
                describedBy:descriptor.
    ] raise: Magritte::MAReadError

    "Created: / 25-09-2014 / 08:33:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2017 / 20:30:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParserTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

