"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#IndexExpression
	instanceVariableNames:'columnName op value'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!IndexExpression class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!IndexExpression methodsFor:'as yet uncategorized'!

columnName
    ^ columnName
!

columnName: aString
    columnName := aString
!

op
    ^ op
!

op: anIndexOperator
    op := anIndexOperator
!

value
    ^ value
!

value: aString
    value := aString
! !

!IndexExpression class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__IndexExpression.st,v 1.3 2013-03-20 15:36:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__IndexExpression.st,v 1.3 2013-03-20 15:36:37 cg Exp $'
! !

