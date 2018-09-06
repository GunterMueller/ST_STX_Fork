"{ Package: 'stx:goodies/communication/thrift' }"

TSizedObject subclass:#TMap
	instanceVariableNames:'keyType valueType'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Protocol'
!


!TMap methodsFor:'accessing'!

keyType
	^ keyType ifNil: [TType stop]
!

keyType: anInteger
	keyType := anInteger
!

valueType
	^ valueType ifNil: [TType stop]
!

valueType: anInteger
	valueType := anInteger
! !

!TMap class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TMap.st,v 1.1 2013-03-19 14:47:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TMap.st,v 1.1 2013-03-19 14:47:18 cg Exp $'
! !

