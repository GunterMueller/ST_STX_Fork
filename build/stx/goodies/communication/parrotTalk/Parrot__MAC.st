"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#MAC
	instanceVariableNames:'mac'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

MAC comment:''
!


!MAC class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!MAC class methodsFor:'initalize-release'!

headerType

	^ 7
!

initializeASN1Types

	((ASN1Module name: #Session)
		sequence: #MAC mapping: MAC)
			add: #mac type: #ASN1ByteArrayType;
			yourself.
	(ASN1Module name: #Session) find: #MAC.
! !

!MAC methodsFor:'accessing'!

mac

	^ mac
!

mac: anObject

	mac := anObject
! !

!MAC methodsFor:'initialize-release'!

initialize

	mac := #[]
! !

!MAC class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__MAC.st,v 1.2 2018-05-14 00:39:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__MAC.st,v 1.2 2018-05-14 00:39:03 cg Exp $'
! !

