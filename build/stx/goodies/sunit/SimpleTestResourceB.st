"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

SimpleTestResource subclass:#SimpleTestResourceB
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!SimpleTestResourceB class methodsFor:'accessing'!

resources
	^Array with: SimpleTestResourceA1 with: SimpleTestResourceB1
! !

!SimpleTestResourceB class methodsFor:'documentation'!

version_SVN
    ^ '§Id: SimpleTestResourceB.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !

