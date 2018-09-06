"{ Package: 'stx:libdb/libopenDBX/driver' }"

Error subclass:#DBXError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Structure'
!


!DBXError class methodsFor:'exceptionInstantiator'!

signal: signalerText 
	super signal: self header , signalerText
! !

!DBXError class methodsFor:'private'!

header
	self subclassRisponsability
! !

!DBXError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXError.st,v 1.2 2013-04-15 13:11:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXError.st,v 1.2 2013-04-15 13:11:00 cg Exp $'
! !

