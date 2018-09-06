"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MACondition subclass:#MAConjunctiveCondition
	instanceVariableNames:'conditions'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!


!MAConjunctiveCondition methodsFor:'evaluating'!

value: anObject
	^ conditions allSatisfy: [ :each | each value: anObject ]
! !

!MAConjunctiveCondition methodsFor:'initialization'!

initialize
	conditions := #()
! !

!MAConjunctiveCondition methodsFor:'operators'!

& aCondition
	conditions := conditions copyWith: aCondition
! !

!MAConjunctiveCondition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAConjunctiveCondition.st,v 1.1 2009-07-29 14:51:44 cg Exp $'
! !
