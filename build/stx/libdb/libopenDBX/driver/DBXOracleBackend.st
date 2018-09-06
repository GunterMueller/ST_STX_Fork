"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXBackend subclass:#DBXOracleBackend
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* obsolete *'
!


!DBXOracleBackend class methodsFor:'defaults'!

createDataTypesMap
	^super createDataTypesMap
		at: 16r20 put: (DBXTypeNotSupported type: #CLOB);
		at: 16r21 put: (DBXTypeNotSupported type: #NCLOB);
		at: 16r22 put: (DBXTypeNotSupported type: #XML);
		at: 16r2F put: (DBXTypeNotSupported type: #BLOB);
		yourself
		
! !

!DBXOracleBackend methodsFor:'*dbxdatabasemodel'!

allColumnsQuery
	^'SELECT
		owner as table_schema,
		table_name,
		column_name, 
		data_type as type, 
		char_length as length, 
		nullable as is_nullable,
		NULL as constraint_name,
		NULL as constraint_type,
		NULL as own_column_name,
		NULL as foreign_table_name,
		NULL as foreign_column_name
		FROM all_tab_columns'
!

allColumnsQueryForSchema: aSchema
	^self allColumnsQueryWhere: ('OWNER = ''{1}''' format: { aSchema asUppercase }).
!

allColumnsQueryForTable: aTableName
	^super allColumnsQueryForTable: aTableName asUppercase
!

allConstraintsQuery	
	^'SELECT
		tc.owner as table_schema,
		tc.table_name,
		NULL as column_name,
		NULL as is_nullable,
		NULL as type,
		NULL as length,
		c.constraint_name, 
		CASE WHEN c.constraint_type = ''C''
		THEN ''CHECK''
		ELSE
			CASE WHEN c.constraint_type = ''P''
			THEN ''PRIMARY KEY''
			ELSE 
				CASE WHEN c.constraint_type = ''R''
				THEN ''FOREIGN KEY''
				ELSE
					CASE WHEN c.constraint_type = ''U''
					THEN ''UNIQUE''
					ELSE NULL
					END
				END
			END
		END AS constraint_type,
		tc.column_name AS own_column_name, 
		uc.table_name foreign_table_name, 
		uc.column_name foreign_column_name
	FROM all_cons_columns tc
	LEFT JOIN all_constraints c ON tc.owner = c.owner
	AND tc.constraint_name = c.constraint_name
	LEFT JOIN all_constraints c_pk ON c.r_owner = c_pk.owner
	AND c.r_constraint_name = c_pk.constraint_name
	LEFT JOIN all_CONS_COLUMNS uc on uc.constraint_name = c.r_constraint_name'
!

allConstraintsQueryForSchema: aSchema
	"SQL to obtain all the foreign keys from the given tableName database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^self allConstraintsQueryWhere: ('tc.owner = ''{1}''' format: { aSchema asUppercase }).
!

allConstraintsQueryForTable: aTableName
	^super allConstraintsQueryForTable: aTableName asUppercase
!

allSchemasQuery
	^'SELECT username as database FROM all_users ORDER BY username'
!

allTableNamesQuery
	^'SELECT table_name FROM all_tables'
!

foreignKeysQuery: aTableName
	^'SELECT 
		c.constraint_name name, 
		a.column_name column_name, 
		uc.table_name 
		foreign_table_name, 
		uc.column_name foreign_column_name
	FROM user_cons_columns a
	JOIN user_constraints c ON a.owner = c.owner
	AND a.constraint_name = c.constraint_name
	JOIN user_constraints c_pk ON c.r_owner = c_pk.owner
	AND c.r_constraint_name = c_pk.constraint_name
	join USER_CONS_COLUMNS uc on uc.constraint_name = c.r_constraint_name
	WHERE  a.table_name=''{1}''' format: { aTableName asUppercase }.
!

int
	^'NUMBER'
!

stringToBool: aBooleanString
	^aBooleanString = 'Y'
! !

!DBXOracleBackend methodsFor:'accessing'!

backend
	^'oracle'
!

name
	^'Oracle'
! !

!DBXOracleBackend methodsFor:'resultSet'!

queryDelimiter
	^';'
! !

!DBXOracleBackend methodsFor:'transactional manage'!

startTransaction
	"This is a general approach for starting a transaction. If other approach is wanted, like SET TRANSACTION READ ONLY, you 	must do it manually like any other query."
	^'SET TRANSACTION READ WRITE'
!

supportsLargeObjects
	^false
! !

!DBXOracleBackend class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXOracleBackend.st,v 1.2 2013-04-15 13:11:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXOracleBackend.st,v 1.2 2013-04-15 13:11:39 cg Exp $'
! !

