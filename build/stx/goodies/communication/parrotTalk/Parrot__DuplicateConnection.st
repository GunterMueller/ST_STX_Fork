"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#DuplicateConnection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

DuplicateConnection comment:''
!


!DuplicateConnection class methodsFor:'as yet unclassified'!

headerType

	^ 14
!

initializeASN1Types

	((ASN1Module name: #Session)
		sequence: #DuplicateConnection mapping: DuplicateConnection)
			yourself.
	(ASN1Module name: #Session) find: #DuplicateConnection.
! !

!DuplicateConnection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__DuplicateConnection.st,v 1.1 2018-05-14 00:16:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__DuplicateConnection.st,v 1.1 2018-05-14 00:16:54 cg Exp $'
! !

