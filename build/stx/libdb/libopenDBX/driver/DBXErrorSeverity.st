"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXErrorSeverity
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-API'
!


!DBXErrorSeverity class methodsFor:'as yet unclassified'!

isFatal: aErrorType
	^ aErrorType < 0
!

isNotAnError: aErrorType
	^ aErrorType = 0
!

isRecoverable: aErrorType
	^ aErrorType > 0
! !

!DBXErrorSeverity class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXErrorSeverity.st,v 1.2 2013-04-15 13:11:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXErrorSeverity.st,v 1.2 2013-04-15 13:11:03 cg Exp $'
! !

