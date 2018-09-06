"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractPresenter subclass:#VDBInstructionPresenter
	instanceVariableNames:'instruction basicBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Presentation'
!

!VDBInstructionPresenter class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBInstructionPresenter methodsFor:'accessing'!

address
    ^instruction address

    "Created: / 26-06-2018 / 12:42:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicBlock
    ^ basicBlock
!

instruction
    ^ instruction
!

subject
    "Return an instance of GDB object that this presenter displays."

    ^ instruction

    "Created: / 22-06-2018 / 15:10:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionPresenter methodsFor:'initialization'!

setBasicBlock: aVDBBasicBLock
    basicBlock := aVDBBasicBLock

    "Created: / 26-06-2018 / 12:37:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setInstruction: aGDBInstruction
    instruction := aGDBInstruction

    "Created: / 22-06-2018 / 12:19:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionPresenter methodsFor:'protocol-accessing'!

label
    ^String streamContents:[ :s |
        (parent notNil and:[ parent askFor: #isInstructionsAndSourcePresenter ]) ifTrue:[
            s next: parent lineDigitsToDisplay put: Character space.   
        ].
        instruction address printOn: s base: 16 size: 16 fill: $0.
        s space.
        s nextPutAll: instruction assembly
    ]

    "Created: / 22-06-2018 / 12:21:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-08-2018 / 11:15:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionPresenter methodsFor:'testing'!

isInstructionPresenter
    ^ true
! !

