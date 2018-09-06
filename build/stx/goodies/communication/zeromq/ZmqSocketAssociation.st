"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZmqSocketAssociation
	instanceVariableNames:'target'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqSocketAssociation comment:''
!


!ZmqSocketAssociation class methodsFor:'as yet unclassified'!

toTarget: aString
	^self new target: aString.
! !

!ZmqSocketAssociation methodsFor:'accessing'!

target
	^ target
!

target: anObject
	target := anObject
! !

!ZmqSocketAssociation methodsFor:'as yet unclassified'!

associationTypeName 
	self subclassResponsibility.
!

printOn: aStream
	aStream nextPutAll: self associationTypeName.
	aStream nextPutAll: ':'.
	aStream nextPutAll: self target.
	
! !

!ZmqSocketAssociation methodsFor:'operations'!

associateSocket: aZmqSocket
	self subclassResponsibility.
! !

!ZmqSocketAssociation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqSocketAssociation.st,v 1.1 2018-05-08 19:44:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqSocketAssociation.st,v 1.1 2018-05-08 19:44:59 cg Exp $'
! !

