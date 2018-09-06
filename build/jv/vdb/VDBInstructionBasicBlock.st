"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

Object subclass:#VDBInstructionBasicBlock
	instanceVariableNames:'instructions precedessors successor1 successor2'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Support'
!

!VDBInstructionBasicBlock class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBInstructionBasicBlock class methodsFor:'utilities'!

analyze: instructions
    "
    Analyzes `instructions`, create and connect basic blocks and return
    them in a collection.

    `instructions` parameter should be a list of GDBInstruction or 
    polymorphic objects).
    "
    | blocks curBB firstI |

    "/ Pass 1, initial blocks by cutting after each branch
    "/ or return instruction.
    blocks := OrderedCollection new.
    curBB := VDBInstructionBasicBlock new.
    instructions withIndexDo:[:last :lastI | 
        firstI isNil ifTrue:[
            firstI := lastI
        ].
        last isBranch ifTrue:[
            | prevBB |
            curBB setInstructions: (instructions copyFrom: firstI to: lastI).
            blocks add: curBB.
            prevBB := curBB.
            curBB := VDBInstructionBasicBlock new.
            prevBB setSuccessor1: curBB.
            firstI := nil.
        ] ifFalse:[
        last isReturn ifTrue:[
            curBB setInstructions: (instructions copyFrom: firstI to: lastI).
            blocks add: curBB.
            curBB := VDBInstructionBasicBlock new.
            firstI := nil.
        ]].
    ].
    firstI notNil ifTrue:[
        curBB setInstructions: (instructions copyFrom: firstI).
        blocks add: curBB.
    ].

    "/ Pass 2: iterate ober basic blocks and connect successor2 based on
    "/ last instructions #branchTargetAddress. If target address points in
    "/ the middle of basic block, split it.
    blocks copy do:[:bb | 
        bb last isBranch ifTrue:[
            | targetAddress succBB |

            targetAddress := bb last branchTarget.
            targetAddress notNil ifTrue:[
                "/ Find successor block. Note, that we may found none if the branch target is
                "/ outside given coce.
                succBB := blocks detect:[:e | e includesAddress: targetAddress ] ifNone: [ nil ].
                succBB notNil ifTrue:[ 
                    "/ If `targetAddress` points into the middle of `succBB` we have to split
                    "/ succBB into two.
                    succBB firstAddress < targetAddress ifTrue:[ 
                        | succBBs |

                        succBBs := succBB splitAtAddress: targetAddress.
                        blocks remove: succBB; addAll: succBBs.
                        succBB := succBBs last.
                    ].
                    bb setSuccessor2: succBB.
                ].
            ]
        ].
    ].

    "/ Jo done!!
    ^ blocks.



    ^ blocks

    "Created: / 27-06-2018 / 13:03:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2018 / 23:50:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionBasicBlock methodsFor:'accessing'!

first
    ^ instructions first

    "Created: / 27-06-2018 / 15:41:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

firstAddress
    ^ self first address

    "Created: / 27-06-2018 / 15:41:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

last
    ^ instructions last

    "Created: / 27-06-2018 / 15:42:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lastAddress
    ^ self last address

    "Created: / 27-06-2018 / 15:41:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

precedessors
    ^ precedessors ? #()

    "Modified: / 16-08-2018 / 11:47:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

successor1
    ^ successor1
!

successor2
    ^ successor2
! !

!VDBInstructionBasicBlock methodsFor:'initialization'!

addPrecedessor: aVDBInstructionBlock
    precedessors isNil ifTrue:[ 
        precedessors := Array with: aVDBInstructionBlock.
    ] ifFalse:[ 
        precedessors := precedessors copyWith: aVDBInstructionBlock
    ].

    "Created: / 27-06-2018 / 15:29:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setInstructions: aCollection
    instructions := aCollection

    "Created: / 27-06-2018 / 14:59:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSuccessor1: aVDBInstructionBasicBlock
    successor1 := aVDBInstructionBasicBlock.
    successor1 addPrecedessor: self.

    "Created: / 27-06-2018 / 15:28:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSuccessor2: aVDBInstructionBasicBlock
    successor2 := aVDBInstructionBasicBlock.
    successor2 addPrecedessor: self.

    "Created: / 27-06-2018 / 15:28:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionBasicBlock methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut: $(.
    self firstAddress printOn: aStream base: 16 size: 15 fill: $0.
    aStream nextPutAll: ' - '.
    self lastAddress printOn: aStream base: 16 size: 15 fill: $0.
    successor1 notNil ifTrue:[ 
        aStream nextPutAll: ' 1> '.
        successor1 firstAddress printOn: aStream base: 16 size: 15 fill: $0.
    ].
    successor2 notNil ifTrue:[ 
        aStream nextPutAll: ' 2> '.
        successor2 firstAddress printOn: aStream base: 16 size: 15 fill: $0.
    ].

    aStream nextPut: $)

    "Modified: / 16-08-2018 / 13:18:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionBasicBlock methodsFor:'queries'!

includes: instruction
    ^ instructions includes: instruction

    "Created: / 27-06-2018 / 15:37:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesAddress: address
    "Return `true`, if this basic block includes an instruction
     with given address, false otherwise."

    ^ (address between: instructions first address and: instructions last address)

    "Created: / 27-06-2018 / 15:40:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionBasicBlock methodsFor:'utilities'!

splitAtAddress: address
    | splitIdx bb1 bb2 |

    splitIdx := instructions indexOf: (instructions detect:[:e | e address = address ] ifNone:[ nil ]).
    "/ Note, that thhere might not be any instruction with that address, such as
    "/ when ill-code jumps into the middle of instruction...
    splitIdx == 0 ifTrue:[ 
        "/ ...in that case, make no split and return self so this case is 
        "/ transparent to users.
        ^Array with: self.
    ].
    bb1 := self class new setInstructions: (instructions copyTo: splitIdx - 1).
    bb2 := self class new setInstructions: (instructions copyFrom: splitIdx).
    bb1 setSuccessor1: bb2.

    precedessors notEmptyOrNil ifTrue:[
        precedessors do:[:precedessor | 
            precedessor successor1 == self ifTrue:[ 
                precedessor setSuccessor1: bb1.
            ].
            precedessor successor2 == self ifTrue:[ 
                precedessor setSuccessor2: bb1.
            ].
        ].
    ].
    ^ Array with: bb1 with: bb2.

    "Created: / 27-06-2018 / 16:00:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-08-2018 / 10:57:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionBasicBlock class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

