"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

Object subclass:#SDSerializer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Store'
!


!SDSerializer methodsFor:'actions'!

materializeFromFile: aFile
	self subclassResponsibility
!

serialize: anObject toFile: aFile
	self subclassResponsibility
! !

!SDSerializer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDSerializer.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDSerializer.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
! !

