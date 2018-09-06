"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#KeyRange
	instanceVariableNames:'startKey endKey startToken endToken count'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!KeyRange class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!KeyRange methodsFor:'as yet uncategorized'!

count
    ^ count
!

count: anI32
    count := anI32
!

endKey
    ^ endKey
!

endKey: aString
    endKey := aString
!

endToken
    ^ endToken
!

endToken: aString
    endToken := aString
!

startKey
    ^ startKey
!

startKey: aString
    startKey := aString
!

startToken
    ^ startToken
!

startToken: aString
    startToken := aString
! !

!KeyRange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__KeyRange.st,v 1.3 2013-03-20 15:36:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__KeyRange.st,v 1.3 2013-03-20 15:36:44 cg Exp $'
! !

