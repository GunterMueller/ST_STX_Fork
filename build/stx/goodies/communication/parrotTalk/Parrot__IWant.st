"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#IWant
	instanceVariableNames:'vatId domain'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

IWant comment:''
!


!IWant class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!IWant class methodsFor:'as yet unclassified'!

headerType

	^ 8
!

initializeASN1Types

	((ASN1Module name: #Session)
		sequence: #IWant mapping: IWant)
			add: #vatId type: #ASN1UTF8StringType;
			add: #domain type: #ASN1UTF8StringType;
			yourself.
	(ASN1Module name: #Session) find: #IWant.
! !

!IWant methodsFor:'accessing'!

domain

	^ domain
!

domain: anObject

	domain := anObject
!

vatId

	^ vatId
!

vatId: anObject

	vatId := anObject
! !

!IWant methodsFor:'initialize-release'!

initialize

	self vatId: ''.
	self domain: ''.
! !

!IWant class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__IWant.st,v 1.2 2018-05-14 00:39:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__IWant.st,v 1.2 2018-05-14 00:39:00 cg Exp $'
! !

