"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#ProtocolOffered
	instanceVariableNames:'offered preferred'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

ProtocolOffered comment:''
!


!ProtocolOffered class methodsFor:'as yet unclassified'!

headerType

	^ 1
!

initializeASN1Types

	((ASN1Module name: #Session) sequence: #ProtocolOffered mapping: ProtocolOffered)
		add: #offered type: #ASN1UTF8StringType;
		add: #preferred type: #ASN1UTF8StringType;
		yourself.
	(ASN1Module name: #Session) find: #ProtocolOffered.
! !

!ProtocolOffered methodsFor:'accessing'!

offered

	^ offered
!

offered: anObject

	offered := anObject
!

preferred

	^ preferred
!

preferred: anObject

	preferred := anObject
! !

!ProtocolOffered class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ProtocolOffered.st,v 1.1 2018-05-14 00:17:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ProtocolOffered.st,v 1.1 2018-05-14 00:17:06 cg Exp $'
! !

