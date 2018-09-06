"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

Object subclass:#MASortBlock
	instanceVariableNames:'accessor selector'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!


!MASortBlock class methodsFor:'instance-creation'!

accessor: anAccessor selector: aSelector
	^ self basicNew initializeAccessor: anAccessor selector: aSelector
!

selector: aSelector 
	^ self 
		accessor: MAIdentityAccessor new
		selector: aSelector
! !

!MASortBlock methodsFor:'actions'!

fixTemps
! !

!MASortBlock methodsFor:'evaluating'!

value: aFirstObject value: aSecondObject
	^ (accessor read: aFirstObject)
		perform: selector
		with: (accessor read: aSecondObject)
! !

!MASortBlock methodsFor:'initialize-release'!

initializeAccessor: anAccessor selector: aSelector
	accessor := anAccessor asAccessor.
	selector := aSelector
! !

!MASortBlock class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MASortBlock.st,v 1.1 2009-07-29 14:52:55 cg Exp $'
! !
