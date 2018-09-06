"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#OpenDBX
	instanceVariableNames:''
	classVariableNames:'Current'
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverSmalltalk-Dialect'
!


!OpenDBX class methodsFor:'constants'!

current
	^ Current ifNil: [ Current := PharoOpenDBX ffiImplementationForOS ] 
	
!

current: anObject
	^Current := anObject
!

currentOpenDBXVersion
	^'1.4.4'
!

reset
	^Current := nil
!

resultDone
	"ODBX_RES_DONE"
	^0
!

resultTimeout
	^1
!

resultWithRows
	^3
!

resultWithoutRows
	^2
!

rowDone
	"ODBX_ROW_DONE"
	^0
!

rowNext
	"ODBX_ROW_NEXT"
	^1
! !

!OpenDBX methodsFor:'api calls'!

apiBind: handle database: databaseName name: userName password: password method: method
	"int odbx_bind(odbx_t* handle, const char* database, const char* who, const char* cred,int method )"
	^self subclassResponsibility
!

apiError: handle number: err
	"long odbx_error(odbx_t*)"
	^self subclassResponsibility
!

apiErrorType: handle number: err 
	"int odbx_error_type( odbx_t* , int error )"
	^ self subclassResponsibility
!

apiFinalize: handle 
	"long odbx_finish(odbx_t*)"
	^self subclassResponsibility
!

apiGetOption: handle option: anOption value: aValue
	"int odbx_get_option(odbx_t* handle, unsigned int option,void* value)"
	^self subclassResponsibility
!

apiInitialize: handle backend: backend host: host port: port
	"long odbx_init(odbx_t**, char*, char*, char*)"
	^self subclassResponsibility
!

apiOpenLarge: aResultSetHandleNumber handle: aLargeHandleWordArray value: aString
	"int odbx_lo_open(odbx_result_t* result, odbx_lo_t** lo, const char* value)"
	^self subclassResponsibility
!

apiQuery: handle query: query length: length
	"long odbx_query(odbx_t*, char*, ulong)"
	^self subclassResponsibility
!

apiQueryColumnLength: handle index: index
	"unsigned long odbx_field_length( odbx_result_t* result, unsigned long pos ) "
	"IMPORTANT: Index es zero-based"
	^self subclassResponsibility
!

apiQueryColumnName: handle index: index
	"char* odbx_column_name(odbx_result_t* result, unsigned long pos )"
	"IMPORTANT: Index es zero-based"
	^self subclassResponsibility
!

apiQueryColumnType: handle index: index
	"char* odbx_column_type( odbx_result_t* result, unsigned long pos )"
	"IMPORTANT: Index es zero-based"
	^self subclassResponsibility
!

apiQueryColumns: handle
	"int odbx_column_count(odbx_result_t* result )"
	^self subclassResponsibility
!

apiQueryFetchRow: handle 
	"int odbx_row_fetch( odbx_result_t* result )"
	^self subclassResponsibility
!

apiQueryFieldValue: handle index: index
	"const char* odbx_field_value( odbx_result_t* result, unsigned long pos )"
	"IMPORTANT: Index es zero-based"
	^self subclassResponsibility
!

apiQueryFinalize: handle
	"int odbx_result_finish( odbx_result_t* result )"
	^self subclassResponsibility
!

apiQueryResult: connectionHandle handle: handle timeout: timeout chunk: chunk
	"int odbx_result( odbx_t* handle, odbx_result_t** result, struct timeval* timeout, unsigned long chunk )"
	^self subclassResponsibility
!

apiQueryRowsAffected: handle
	"uint64_t odbx_rows_affected(odbx_result_t* result )"
	^self subclassResponsibility
!

apiSetOption: handle option: anOption value: aValue
	"int odbx_set_option(odbx_t* handle, unsigned int option, void* value ) "
	^self subclassResponsibility	
!

apiUnbind: handle 
	"int odbx_unbind(odbx_t*)"
	^self subclassResponsibility
! !

!OpenDBX class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/OpenDBX.st,v 1.2 2013-04-15 13:10:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/OpenDBX.st,v 1.2 2013-04-15 13:10:09 cg Exp $'
! !

