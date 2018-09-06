"{ Package: 'stx:libdb/libopenDBX/model' }"

Object subclass:#DBXColumnCluster
	instanceVariableNames:'columns'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXDatabaseModel'
!


!DBXColumnCluster class methodsFor:'as yet unclassified'!

baseDescription
	^ MAContainer new.
! !

!DBXColumnCluster methodsFor:'accessing'!

add: aColumn
	self columns add: aColumn.
!

columns
	^ columns.
! !

!DBXColumnCluster methodsFor:'initialize-release'!

initialize 
	super initialize.
	columns := Set new.
! !

!DBXColumnCluster class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXColumnCluster.st,v 1.2 2013-04-15 13:32:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXColumnCluster.st,v 1.2 2013-04-15 13:32:34 cg Exp $'
! !

