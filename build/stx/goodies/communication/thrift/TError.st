"{ Package: 'stx:goodies/communication/thrift' }"

Error subclass:#TError
	instanceVariableNames:'code'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Misc'
!


!TError class methodsFor:'as yet unclassified'!

signalWithCode: anInteger
        self new code: anInteger; raiseSignal "signal"
! !

!TError methodsFor:'as yet unclassified'!

code
	^ code
!

code: anInteger
	code := anInteger
! !

!TError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TError.st,v 1.2 2013-03-21 01:16:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TError.st,v 1.2 2013-03-21 01:16:17 cg Exp $'
! !

