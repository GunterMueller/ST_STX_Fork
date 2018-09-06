"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPContainedElement subclass:#PPCLRPTransition
	instanceVariableNames:'name from to eventname arrowRange keywordEnd'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!


!PPCLRPTransition class methodsFor:'instance creation'!

on: anEvent from: startState to: endState name: aString
    |retval|
    retval := self new.
    retval eventname: anEvent.
    retval from: startState.
    retval to: endState.
    retval name: aString.
    ^ retval.
! !

!PPCLRPTransition methodsFor:'accessing'!

arrowRange
    arrowRange ifNil: [ self halt: 'Error in setting up range info for styling' ].
    ^ arrowRange
!

arrowRange: anObject
    arrowRange := anObject
!

eventname
    ^ eventname
!

eventname: anObject
    eventname := anObject
!

from
    ^ from
!

from: anObject
    from := anObject
!

identifier
    ^self className , self from , self to , self name.
!

keywordEnd
    ^ keywordEnd
!

keywordEnd: anObject
    keywordEnd := anObject
!

name
    ^ name
!

name: anObject
    name := anObject
!

to
    ^ to
!

to: anObject
    to := anObject
! !

!PPCLRPTransition methodsFor:'printing'!

printOn: aStream

    aStream nextPutAll: 'PPCLRPTransition '.
    aStream nextPutAll: self name.
    aStream nextPutAll: ' : '.
    aStream nextPutAll: self from.
    aStream nextPutAll: '->'.
    aStream nextPutAll: self to.
    aStream nextPutAll: ' on '.
    aStream nextPutAll: self eventname.
    
! !

!PPCLRPTransition methodsFor:'visiting'!

acceptVisitor: aPPCLRPNodeVisitor
    aPPCLRPNodeVisitor visitTransitionNode: self.
! !

!PPCLRPTransition class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

