"{ Package: 'stx:goodies/communication/thrift' }"

Object subclass:#TMessage
	instanceVariableNames:'name seqid type'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Protocol'
!


!TMessage methodsFor:'accessing'!

name
	^ name ifNil: ['']
!

name: aString
	name := aString
!

seqid
	^ seqid ifNil: [0]
!

seqid: anInteger
	seqid := anInteger
!

type
	^ type ifNil: [0]
!

type: anInteger
	type := anInteger
! !

!TMessage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TMessage.st,v 1.1 2013-03-19 14:47:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TMessage.st,v 1.1 2013-03-19 14:47:22 cg Exp $'
! !

