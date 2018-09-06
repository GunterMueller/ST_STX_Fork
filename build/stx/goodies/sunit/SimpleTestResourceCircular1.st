"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

SimpleTestResource subclass:#SimpleTestResourceCircular1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!SimpleTestResourceCircular1 class methodsFor:'accessing'!

resources
	"Circular prereq:  C wants C1 which wants C."

	^Array with: SimpleTestResourceCircular
! !

!SimpleTestResourceCircular1 class methodsFor:'documentation'!

version_SVN
    ^ '§Id: SimpleTestResourceCircular1.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !

