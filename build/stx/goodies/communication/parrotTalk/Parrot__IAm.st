"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#IAm
	instanceVariableNames:'vatId domain publicKey'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

IAm comment:''
!


!IAm class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!IAm class methodsFor:'as yet unclassified'!

headerType

	^ 9
!

initializeASN1Types

	((ASN1Module name: #Session)
		addImport: (ASN1Module name: #RSA);
		sequence: #IAm mapping: IAm)
			add: #vatId type: #ASN1UTF8StringType;
			add: #domain type: #ASN1UTF8StringType;
			add: #publicKey type: #RSAPublicKey;
			yourself.
	(ASN1Module name: #Session) find: #IAm.
! !

!IAm methodsFor:'accessing'!

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

!IAm methodsFor:'initialize-release'!

initialize

	domain := ''.
	vatId := ''.
! !

!IAm class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__IAm.st,v 1.2 2018-05-14 00:39:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__IAm.st,v 1.2 2018-05-14 00:39:02 cg Exp $'
! !

