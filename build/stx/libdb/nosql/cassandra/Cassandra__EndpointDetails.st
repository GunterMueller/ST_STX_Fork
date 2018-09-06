"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#EndpointDetails
	instanceVariableNames:'host datacenter rack'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!EndpointDetails class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!EndpointDetails methodsFor:'as yet uncategorized'!

datacenter
    ^ datacenter
!

datacenter: aString
    datacenter := aString
!

host
    ^ host
!

host: aString
    host := aString
!

rack
    ^ rack
!

rack: aString
    rack := aString
! !

!EndpointDetails class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__EndpointDetails.st,v 1.3 2013-03-20 15:36:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__EndpointDetails.st,v 1.3 2013-03-20 15:36:33 cg Exp $'
! !

