"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXBackend subclass:#DBXPostgresBackend
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:'* obsolete *'
!


!DBXPostgresBackend class methodsFor:'defaults'!

createDataTypesMap
        ^super createDataTypesMap
                at: 16r20 put: String; "CLOB"
                yourself
                
! !

!DBXPostgresBackend methodsFor:'*dbxdatabasemodel'!

allSchemasQuery
        ^'select nspname as database from pg_namespace order by nspname'
!

defaultSchema
        ^'public'
! !

!DBXPostgresBackend methodsFor:'accessing'!

backend
        ^'pgsql'
!

name
        ^'PostgreSQL'
! !

!DBXPostgresBackend methodsFor:'connection'!

setDateStyleOn: aConnection
        aConnection execute:'SET DATESTYLE TO ISO'
! !

!DBXPostgresBackend methodsFor:'encoding'!

queryEncoding:aConnection 
    |result enc|

    [
        [
            result := aConnection execute:'SHOW CLIENT_ENCODING'.
            enc := result nextRow rawValueAt:1 
        ] on:DBXRecoverableError do:[ 
            Error signal:'Querying encoding from Postgresql server failed!!'. 
        ]
    ] ensure:[ 
        result ifNotNil:[ result releaseResult ] 
    ].
    ^ enc
! !

!DBXPostgresBackend methodsFor:'resultSet'!

queryDelimiter
        ^';'
! !

!DBXPostgresBackend class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXPostgresBackend.st,v 1.3 2013-04-15 13:31:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXPostgresBackend.st,v 1.3 2013-04-15 13:31:28 cg Exp $'
! !

