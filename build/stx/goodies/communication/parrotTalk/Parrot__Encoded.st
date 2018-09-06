"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#Encoded
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

Encoded comment:''
!


!Encoded class methodsFor:'as yet unclassified'!

headerType

	^ 5
!

initializeASN1Types

	((ASN1Module name: #Session)
		sequence: #Encoded mapping: Encoded)
			yourself.
	(ASN1Module name: #Session) find: #Encoded.
! !

!Encoded class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Encoded.st,v 1.1 2018-05-14 00:17:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Encoded.st,v 1.1 2018-05-14 00:17:18 cg Exp $'
! !

