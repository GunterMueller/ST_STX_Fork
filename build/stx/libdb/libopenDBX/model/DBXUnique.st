"{ Package: 'stx:libdb/libopenDBX/model' }"

DBXColumnCluster subclass:#DBXUnique
	instanceVariableNames:'name columnName'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXDatabaseModel'
!


!DBXUnique class methodsFor:'as yet unclassified'!

named: constraintName column: columnName
	^self new
		named: constraintName column: columnName;
		yourself
! !

!DBXUnique methodsFor:'as yet unclassified'!

named: aConstraintName column: aColumnName
	name := aConstraintName.
	columnName := aColumnName 
! !

!DBXUnique class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXUnique.st,v 1.2 2013-04-15 13:32:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXUnique.st,v 1.2 2013-04-15 13:32:37 cg Exp $'
! !

