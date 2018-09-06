"{ Package: 'stx:libdb/nosql/cassandra' }"

"{ NameSpace: Cassandra }"

Object subclass:#TokenRange
	instanceVariableNames:'startToken endToken endpoints rpcEndpoints endpointDetails'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Cassandra-Generated'
!

!TokenRange class methodsFor:'documentation'!

documentation
"
    DO NOT EDIT

    automatically generated from cassandra.thrift; see $(TOP)/libdb/nosql/cassandra
    2013-03-18
"
! !

!TokenRange methodsFor:'as yet uncategorized'!

endToken
    ^ endToken
!

endToken: aString
    endToken := aString
!

endpointDetails
    ^ endpointDetails
!

endpointDetails: a
    endpointDetails := a
!

endpoints
    ^ endpoints
!

endpoints: a
    endpoints := a
!

rpcEndpoints
    ^ rpcEndpoints
!

rpcEndpoints: a
    rpcEndpoints := a
!

startToken
    ^ startToken
!

startToken: aString
    startToken := aString
! !

!TokenRange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__TokenRange.st,v 1.3 2013-03-20 15:37:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/cassandra/Cassandra__TokenRange.st,v 1.3 2013-03-20 15:37:04 cg Exp $'
! !

