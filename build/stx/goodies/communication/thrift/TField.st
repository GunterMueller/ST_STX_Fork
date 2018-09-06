"{ Package: 'stx:goodies/communication/thrift' }"

Object subclass:#TField
	instanceVariableNames:'name type id'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Protocol'
!


!TField methodsFor:'accessing'!

id
	^ id ifNil: [0]
!

id: anInteger
	id := anInteger
!

name
	^ name ifNil: ['']
!

name: anObject
	name := anObject
!

type
	^ type ifNil: [TType stop]
!

type: anInteger
	type := anInteger
! !

!TField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TField.st,v 1.1 2013-03-19 14:47:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TField.st,v 1.1 2013-03-19 14:47:10 cg Exp $'
! !

