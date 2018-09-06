"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

SimpleTestResource subclass:#SimpleTestResourceA
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!SimpleTestResourceA class methodsFor:'accessing'!

resources
	^Array with: SimpleTestResourceA1 with: SimpleTestResourceA2
! !

!SimpleTestResourceA class methodsFor:'documentation'!

version_SVN
    ^ '§Id: SimpleTestResourceA.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !

