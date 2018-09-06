"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXMySQLBackend subclass:#DBXMySQL4Backend
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* obsolete *'
!


!DBXMySQL4Backend methodsFor:'accessing'!

name
	^'MySQL 4'
! !

!DBXMySQL4Backend methodsFor:'options'!

setNecessarySpecialOptions: aConnection 
	"To get MySQL4 working, you always need to enable a special mode with an empy string"
	aConnection enableSpecialModes: ''. 
! !

!DBXMySQL4Backend class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXMySQL4Backend.st,v 1.2 2013-04-15 13:10:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXMySQL4Backend.st,v 1.2 2013-04-15 13:10:03 cg Exp $'
! !

