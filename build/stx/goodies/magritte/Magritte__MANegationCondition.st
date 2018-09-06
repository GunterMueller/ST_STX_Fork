"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MACondition subclass:#MANegationCondition
	instanceVariableNames:'condition'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!


!MANegationCondition class methodsFor:'instance creation'!

with: aCondition
	^ self new initializeWith: aCondition
! !

!MANegationCondition methodsFor:'evaluating'!

value: anObject
	^ (condition value: anObject) not
! !

!MANegationCondition methodsFor:'initialization'!

initializeWith: aCondition
	condition := aCondition
! !

!MANegationCondition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MANegationCondition.st,v 1.1 2009-07-29 14:53:01 cg Exp $'
! !
