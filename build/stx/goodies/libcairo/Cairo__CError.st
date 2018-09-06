"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

Error subclass:#CError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Exceptions'
!


!CError methodsFor:'printing & storing'!

description
    "return the description string of the signal"

    parameter isInteger ifTrue:[ 
        messageText isNil ifTrue:[ 
            ^ CPrimitives cairo_status_to_string: parameter.
        ].
        ^ messageText , ': ' , (CPrimitives cairo_status_to_string: parameter).
    ].
    ^ super description

    "
      (CError new parameter: 1) description
      (CError new messageText: 'Failed to create Cairo'; parameter: 1) description
      (CError new messageText: 'Failed to create Cairo') description
    "

    "Created: / 23-02-2016 / 16:52:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CError class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

