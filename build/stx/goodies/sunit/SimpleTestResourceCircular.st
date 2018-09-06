"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

SimpleTestResource subclass:#SimpleTestResourceCircular
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!SimpleTestResourceCircular class methodsFor:'accessing'!

resources
	^preventAvailability isNil
		ifTrue: [super resources, (Array with: SimpleTestResourceA1)]
		ifFalse: [super resources, (Array with: SimpleTestResourceA1 with: SimpleTestResourceCircular1)]
! !

!SimpleTestResourceCircular class methodsFor:'documentation'!

version_SVN
    ^ '§Id: SimpleTestResourceCircular.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !

