"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#NotMe
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

NotMe comment:''
!


!NotMe class methodsFor:'as yet unclassified'!

initializeASN1Types

	((ASN1Module name: #Session)
		sequence: #NotMe mapping: NotMe)
			yourself.
	(ASN1Module name: #Session) find: #NotMe.
! !

!NotMe class methodsFor:'asn1der'!

headerType

	^ 15
! !

!NotMe class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__NotMe.st,v 1.1 2018-05-14 00:17:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__NotMe.st,v 1.1 2018-05-14 00:17:50 cg Exp $'
! !

