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

GDBDebuggerObject subclass:#GDBFrame
	instanceVariableNames:'thread level addr func file fullname line arch from variables'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBFrame class methodsFor:'documentation'!

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

!GDBFrame class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#level as:Integer;
        define:#func as:String;
        define:#file as:String;
        define:#fullname as:String;
        define:#line as:Integer;
        define:#from as:String;
        define:#addr as:Integer;
        yourself

    "Created: / 16-09-2014 / 23:59:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-02-2018 / 08:27:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBFrame methodsFor:'accessing'!

addr
    ^ addr
!

address
    ^ self addr

    "Created: / 03-07-2018 / 15:10:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

arch
    arch isNil ifTrue:[
        arch := GDBArchitecture named: 'unknown'.
    ].
    arch isString ifTrue:[ 
        arch := GDBArchitecture named: arch
    ].
    ^ arch

    "Created: / 16-08-2018 / 06:59:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 09:04:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

disassemble
    "Return instructions for a function of this frame"

    | disassembly |

    (debugger hasFeature:'data-disassemble-a-option') ifTrue:[
        disassembly := debugger disassembleFunction: '0x', addr hexPrintString.  
    ] ifFalse:[ 
        disassembly := debugger disassembleFile: file  line: line count: nil.
    ].
    disassembly do:[ :each | each setArchitecture: self arch ].  
    ^ disassembly

    "Created: / 22-06-2018 / 12:47:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 09:40:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

file
    "Return filename (path) containing frame's function source."

    | f |

    "/ GDB/MI provides two paths, `file` and `fullname`. 
    "/ 
    "/ However, sometimes GDB gets confused and does not return
    "/ anything directly useful, especially when debug info contains
    "/ relative paths with multiple segments. 
    "/ 
    "/ As a courtesy to the user, in that case try to resolve full
    "/ path here too. Hence the code below.
    "/
    "/ To avoid re-resolving of file each time this method is called,
    "/ cache resolved Filename in `fullname` instvar. 

    fullname isFilename ifTrue:[ 
        "/ Already resolved by the code below
        ^ fullname pathName
    ].

    f := fullname ? file.
    f isNil ifTrue:[ ^ nil ].
    f := f copyReplaceAll: $/ with: Filename separator.
    f := f asFilename.

    "/ check, if GDB returned correctly resolved filename...
    f exists ifTrue:[
        fullname := f.
        ^ fullname pathName
    ].

    "/ ...if not, try to look it up in source directories...
    self debugger directories do:[:d | 
        f := d asFilename / (fullname ? file).
        f exists ifTrue:[ 
            fullname := f.
            ^ fullname pathName.
        ].
    ].

    "/ ...if not found there...
    ^ nil

    "Modified: / 12-03-2018 / 10:32:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-03-2018 / 16:52:52 / jv"
!

from
    ^ from
!

func
    ^ func
!

level
    ^ level
!

line
    ^ line
!

thread
    ^ thread
!

variables
    self ensureIsValid.
    variables isNil ifTrue:[
        variables := GDBTransientDataHolder debugger: debugger factory:[ :old |
            | result new |

            result := debugger send: (GDBMI_stack_list_variables new arguments: (Array with: '--thread' with: thread id with: '--frame' with: level with: '--simple-values')).
            new := (result propertyAt: #variables) ? #().
            old notNil ifTrue:[ 
                old size == new size ifTrue:[
                    1 to: new size do:[:i | 
                        | oldVar newVar |

                        oldVar := old at: i.
                        newVar := new at: i.
                        newVar name = oldVar name ifTrue:[ 
                            new at: i put: (old at: i)
                        ].
                    ].
                ] ifFalse:[ 
                    "/ Sorry for this - but I'm not sure when this may happen
                    "/ so I would like get a debugger to investigate
                    self breakPoint: #jv.
                    new do:[:newVar | newVar setFrame: self ]
                ].
            ] ifFalse:[ 
                new do:[:newVar | newVar setFrame: self ]
            ].
            new
        ].
    ].
    ^ variables value

    "Created: / 27-02-2015 / 14:56:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2018 / 11:10:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBFrame methodsFor:'initialization'!

setAddr: aString
    addr := aString

    "Created: / 31-01-2018 / 09:50:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setLevel: anInteger
    level := anInteger

    "Created: / 15-02-2018 / 08:34:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 02-02-2018 / 12:16:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setLine: anInteger
    line := anInteger

    "Created: / 01-02-2018 / 10:09:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setThread: aGDBThread
    thread := aGDBThread

    "Created: / 30-01-2018 / 15:56:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBFrame methodsFor:'printing & storing'!

displayString
    ^ String streamContents: [ :aStream |
        | f |

        f := self file.
        level printOn:aStream base: 10 size: 2 fill: Character space.
        aStream nextPutAll:' 0x'.
        addr printOn:aStream base: 16 size: (self arch sizeofPointer * 2) fill: $0.
        aStream nextPutAll:' '.
        func notNil ifTrue:[
            func printOn:aStream.
        ] ifFalse:[ 
            aStream nextPutAll: '?'
        ].
        f notNil ifTrue:[
            aStream nextPutAll:' ('.
            aStream nextPutAll: f startingAt: (f lastIndexOf: Filename separator) + 1.
            line notNil ifTrue:[
                aStream nextPutAll:':'.
                line printOn:aStream.
            ].
            aStream nextPutAll:')'.
        ].
    ].

    "Created: / 27-02-2015 / 15:20:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 09:36:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn: aStream.
    aStream nextPutAll:'('.
    level printOn:aStream base: 10 size: 2 fill: Character space.
    aStream nextPutAll:' '.
    addr printOn:aStream.
    aStream nextPutAll:' '.
    func printOn:aStream.
    aStream nextPutAll:' - '.
    file printOn:aStream.
    aStream nextPutAll:':'.
    line printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 27-02-2015 / 15:21:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBFrame methodsFor:'testing'!

isValid
    ^ thread isValid and:[addr notNil]

    "Modified: / 04-02-2018 / 21:30:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBFrame class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

