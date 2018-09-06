"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#GiveInfo
	instanceVariableNames:'vatId domain publicKey'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

GiveInfo comment:''
!


!GiveInfo class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!GiveInfo class methodsFor:'as yet unclassified'!

headerType

	^ 10
!

initializeASN1Types

	((ASN1Module name: #Session)
		addImport: (ASN1Module name: #RSA);
		sequence: #GiveInfo mapping: GiveInfo)
			add: #vatId type: #ASN1UTF8StringType;
			add: #domain type: #ASN1UTF8StringType;
			add: #publicKey type: #RSAPublicKey;
			yourself.
	(ASN1Module name: #Session) find: #GiveInfo.
! !

!GiveInfo methodsFor:'accessing'!

domain

	^ domain
!

domain: anObject

	domain := anObject
!

publicKey

	^ publicKey
!

publicKey: anObject

	publicKey := anObject
!

vatId

	^ vatId
!

vatId: anObject

	vatId := anObject
! !

!GiveInfo methodsFor:'initialize-release'!

initialize

	domain := ''.
	vatId := ''.
! !

!GiveInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__GiveInfo.st,v 1.2 2018-05-14 00:39:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__GiveInfo.st,v 1.2 2018-05-14 00:39:01 cg Exp $'
! !

