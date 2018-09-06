"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractPresenter subclass:#VDBInstructionsAndSourcePresenter
	instanceVariableNames:'instructionsAndSource'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Presentation'
!

!VDBInstructionsAndSourcePresenter class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBInstructionsAndSourcePresenter methodsFor:'accessing'!

address
    instructionsAndSource instructions notEmpty ifTrue:[ 
        ^ instructionsAndSource address.
    ] ifFalse:[ 
        | siblings index |

        siblings := parent children.
        index := siblings identityIndexOf: self.
        index < siblings size ifTrue:[ 
            ^ (siblings at: index + 1) address.
        ].
    ].
    ^ nil.

    "Created: / 26-06-2018 / 12:37:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 11:55:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicBlock
    children isEmptyOrNil ifTrue:[ ^ nil ].
    ^ self children first basicBlock

    "Created: / 26-06-2018 / 12:37:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 11:43:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineDigitsToDisplay
    "Return a number of line digits to display."

    "/ Currently hardcoded but maybe it will be dynamic
    "/ in future...
    ^ 5

    "Created: / 09-08-2018 / 11:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subject
    "Return an instance of GDB object that this presenter displays."

    ^ instructionsAndSource

    "Created: / 22-06-2018 / 15:10:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tooltip
    | source line tooltip |

    source := instructionsAndSource source.
    source isNil ifTrue:[ ^ instructionsAndSource file, ':  ', instructionsAndSource line printString ].
    line := instructionsAndSource line asInteger.
    tooltip := TextStream on: ''.
    tooltip emphasis: #bold;
      nextPutAll: instructionsAndSource file;
      emphasis: nil.
    tooltip cr; cr.
    ((line - 5) max: 1) to: ((line + 10) min: source size) do:[:i | 
        i == line ifTrue:[ tooltip emphasis: #bold ].
        i == line ifTrue:[ tooltip nextPut: $> ] ifFalse:[ tooltip space. ].
        tooltip space.                                                      
        i printOn: tooltip base: 10 size: self lineDigitsToDisplay fill: Character space.
        tooltip space.
        tooltip nextPutLine: (source at: i).
        i == line ifTrue:[ tooltip emphasis: nil ].
    ].
    ^ tooltip contents.

    "Created: / 09-08-2018 / 10:45:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionsAndSourcePresenter methodsFor:'initialization'!

setInstructionsAndSource: aGDBInstructionsAndSourceLine
    instructionsAndSource := aGDBInstructionsAndSourceLine

    "Created: / 22-06-2018 / 12:40:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionsAndSourcePresenter methodsFor:'protocol-accessing'!

fetchChildren
    ^ instructionsAndSource instructions collect:[ :i | VDBInstructionPresenter new setInstruction: i; parent: self ]

    "Created: / 22-06-2018 / 12:19:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    | source line |
    source := instructionsAndSource source.
    line := instructionsAndSource line.
    ^ (source notNil and:[ line notNil and: [ instructionsAndSource line asInteger between: 1 and: source size]]) 
        ifTrue:[ (line printStringRadix: 10 size: self lineDigitsToDisplay fill: Character space) , Character space , (source at: line asInteger) ]
        ifFalse:[ instructionsAndSource file, ':  ', instructionsAndSource line printString ].

    "Created: / 22-06-2018 / 12:22:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-08-2018 / 11:10:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBInstructionsAndSourcePresenter methodsFor:'testing'!

isInstructionsAndSourcePresenter
    ^ true
! !

!VDBInstructionsAndSourcePresenter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

