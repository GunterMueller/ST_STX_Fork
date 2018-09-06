"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#RawData
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

RawData comment:''
!


!RawData class methodsFor:'as yet unclassified'!

initializeASN1Types

	((ASN1Module name: #Session)
		sequence: #RawData mapping: RawData)
			yourself.
	(ASN1Module name: #Session) find: #RawData.
! !

!RawData class methodsFor:'asn1der'!

headerType

	^ 4
! !

!RawData class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__RawData.st,v 1.1 2018-05-14 00:16:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__RawData.st,v 1.1 2018-05-14 00:16:46 cg Exp $'
! !

