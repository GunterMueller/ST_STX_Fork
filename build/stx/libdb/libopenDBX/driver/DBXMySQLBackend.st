"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXBackend subclass:#DBXMySQLBackend
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* obsolete *'
!


!DBXMySQLBackend class methodsFor:'defaults'!

createDataTypesMap
	^super createDataTypesMap
		at: 16r20 put: String; "CLOB"
		at: 16r2F put: ByteArray;  "BLOB"
		yourself
		
! !

!DBXMySQLBackend methodsFor:'*dbxdatabasemodel'!

allConstraintsQuery
	"SQL to obtain all the foreign keys from the given tableName database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^ 'SELECT
			tc.table_schema,
			kcu.table_name,
			NULL as column_name,
			NULL as is_nullable,
			NULL as type,
			NULL as length,
			tc.constraint_name, 
			tc.constraint_type AS constraint_type,
			kcu.column_name AS own_column_name, 
			kcu.referenced_table_name AS foreign_table_name, 
			kcu.referenced_column_name AS foreign_column_name 
	FROM information_schema.table_constraints AS tc 
	JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name'
!

allConstraintsQueryForSchema: aSchema
	"SQL to obtain all the foreign keys from the given tableName database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^self allConstraintsQueryWhere: ('kcu.table_schema = ''{1}''' format: { aSchema }).
!

allConstraintsQueryForTable: aTableName
	"SQL to obtain all the foreign keys from the given tableName database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^self allConstraintsQueryWhere: ('kcu.table_name = ''{1}''' format: { aTableName }).
!

allSchemasQuery
	^'SHOW SCHEMAS'
!

foreignKeysQuery: aTableName
	^'SELECT kcu.constraint_name AS name, 
			kcu.column_name AS column_name, 
			kcu.referenced_table_name AS foreign_table_name, 
			kcu.referenced_column_name AS foreign_column_name 
	FROM information_schema.KEY_COLUMN_USAGE kcu
	WHERE REFERENCED_TABLE_NAME = ''{1}'';' format: { aTableName }
!

int
	^'int'
! !

!DBXMySQLBackend methodsFor:'accessing'!

backend
	^'mysql'
!

name
	^'MySQL'
! !

!DBXMySQLBackend methodsFor:'resultSet'!

queryDelimiter
	^';'
! !

!DBXMySQLBackend class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXMySQLBackend.st,v 1.2 2013-04-15 13:10:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXMySQLBackend.st,v 1.2 2013-04-15 13:10:02 cg Exp $'
! !

