"{ Package: 'stx:goodies/communication/thrift' }"

Object subclass:#TSizedObject
	instanceVariableNames:'size'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Protocol'
!


!TSizedObject methodsFor:'as yet unclassified'!

size
	^ size ifNil: [0]
!

size: anInteger
	size := anInteger
! !

!TSizedObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TSizedObject.st,v 1.1 2013-03-19 14:47:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TSizedObject.st,v 1.1 2013-03-19 14:47:42 cg Exp $'
! !

