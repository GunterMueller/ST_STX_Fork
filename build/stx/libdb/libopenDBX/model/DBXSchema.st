"{ Package: 'stx:libdb/libopenDBX/model' }"

Object subclass:#DBXSchema
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXDatabaseModel'
!


!DBXSchema class methodsFor:'instance creation'!

named: aName
	^self new
		name: aName;
		yourself
			
! !

!DBXSchema methodsFor:'accessing'!

name
	^name
!

name: aName
	name := aName
! !

!DBXSchema class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXSchema.st,v 1.2 2013-04-15 13:32:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXSchema.st,v 1.2 2013-04-15 13:32:36 cg Exp $'
! !

