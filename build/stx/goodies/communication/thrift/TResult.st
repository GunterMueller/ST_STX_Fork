"{ Package: 'stx:goodies/communication/thrift' }"

Object subclass:#TResult
	instanceVariableNames:'success oprot iprot exception'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Misc'
!


!TResult methodsFor:'as yet unclassified'!

exception
	^ exception
!

exception: anError
	exception := anError
!

success
	^ success
!

success: anObject
	success := anObject
! !

!TResult class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TResult.st,v 1.1 2013-03-19 14:47:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TResult.st,v 1.1 2013-03-19 14:47:34 cg Exp $'
! !

