"{ Package: 'stx:goodies/communication/thrift' }"

TSizedObject subclass:#TList
	instanceVariableNames:'elemType'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Protocol'
!


!TList methodsFor:'accessing'!

elemType
	^ elemType ifNil: [TType stop]
!

elemType: anInteger
	elemType := anInteger
! !

!TList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TList.st,v 1.1 2013-03-19 14:47:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TList.st,v 1.1 2013-03-19 14:47:14 cg Exp $'
! !

