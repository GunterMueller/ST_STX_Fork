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

GDBDebuggerObject subclass:#GDBInstructionsAndSourceLine
	instanceVariableNames:'file fullname line line_asm_insn'
	classVariableNames:'SourceCache'
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBInstructionsAndSourceLine class methodsFor:'documentation'!

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

!GDBInstructionsAndSourceLine class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    SourceCache := CacheDictionary new: 16.

    "Modified (format): / 07-08-2018 / 11:37:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstructionsAndSourceLine class methodsFor:'accessing-magritte'!

descriptionContainer
    ^ super descriptionContainer
        define: #line_asm_insn as: Array of: GDBInstruction;
        define: #line as: Integer;
        yourself

    "Created: / 22-06-2018 / 10:58:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2018 / 11:49:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstructionsAndSourceLine methodsFor:'accessing'!

address
    line_asm_insn isEmptyOrNil ifTrue:[ ^ -1 ].
    ^ line_asm_insn first address

    "Created: / 03-07-2018 / 14:51:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

instructions
    ^ line_asm_insn ? #()

    "Created: / 22-06-2018 / 10:58:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-06-2018 / 12:54:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

line
    ^ line
!

source
    "Return the source (as StringCollection !!!!!!) or nil if not available"

    | f |

    f := self file.
    f isNil ifTrue:[ ^ nil "no file, source not available" ].
    ^ SourceCache at: f ifAbsentPut: [ f asFilename contents withTabsExpanded ].

    "Created: / 07-08-2018 / 11:32:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstructionsAndSourceLine methodsFor:'enumerating'!

instructionsDo: aBlock
    line_asm_insn ? #() do: aBlock

    "Created: / 16-08-2018 / 11:31:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstructionsAndSourceLine methodsFor:'initialization & release'!

setArchitecture: aGDBArchitecture
    self instructions do:[:e | e setArchitecture: aGDBArchitecture ]

    "Created: / 16-08-2018 / 09:39:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setDebugger: aGDBDebugger
    super setDebugger: aGDBDebugger.
    self instructions do:[:e | e setDebugger: aGDBDebugger ]

    "Created: / 16-08-2018 / 09:33:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstructionsAndSourceLine methodsFor:'testing'!

isBranch
    ^ false

    "Created: / 03-07-2018 / 14:39:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isReturn
    ^ false

    "Created: / 03-07-2018 / 14:39:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstructionsAndSourceLine class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


GDBInstructionsAndSourceLine initialize!
