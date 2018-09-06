"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXResultDescription
	instanceVariableNames:'rowsAffected'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Description'
!


!DBXResultDescription methodsFor:'accessing'!

rowsAffected
"number of rows that have been changed by the current statement"
	^rowsAffected
!

rowsAffected: aNumber
	rowsAffected := aNumber 
! !

!DBXResultDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXResultDescription.st,v 1.2 2013-04-15 13:10:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXResultDescription.st,v 1.2 2013-04-15 13:10:04 cg Exp $'
! !

