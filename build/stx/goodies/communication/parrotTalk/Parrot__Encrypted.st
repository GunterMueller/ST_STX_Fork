"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#Encrypted
	instanceVariableNames:'ivSequence'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

Encrypted comment:''
!


!Encrypted class methodsFor:'as yet unclassified'!

headerType

	^ 6
!

initializeASN1Types

	((ASN1Module name: #Session)
		sequence: #Encrypted mapping: Encrypted)
			add: #ivSequence type: #ASN1ByteArrayType;
			yourself.
	(ASN1Module name: #Session) find: #Encrypted.
!

ivSequence: iv

	^ self new
		ivSequence: iv;
		yourself
! !

!Encrypted methodsFor:'accessing'!

ivSequence

	^ ivSequence
!

ivSequence: anObject

	ivSequence := anObject
! !

!Encrypted class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Encrypted.st,v 1.1 2018-05-14 00:18:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Encrypted.st,v 1.1 2018-05-14 00:18:59 cg Exp $'
! !

