"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#ProtocolAccepted
	instanceVariableNames:'accepted'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

ProtocolAccepted comment:''
!


!ProtocolAccepted class methodsFor:'as yet unclassified'!

headerType

	^ 3
!

initializeASN1Types

	((ASN1Module name: #Session) sequence: #ProtocolAccepted mapping: ProtocolAccepted)
		add: #accepted type: #ASN1UTF8StringType;
		yourself.
	(ASN1Module name: #Session) find: #ProtocolAccepted.
! !

!ProtocolAccepted methodsFor:'accessing'!

accepted

	^ accepted
!

accepted: anObject

	accepted := anObject
! !

!ProtocolAccepted class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ProtocolAccepted.st,v 1.1 2018-05-14 00:17:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ProtocolAccepted.st,v 1.1 2018-05-14 00:17:22 cg Exp $'
! !

