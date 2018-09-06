"{ Package: 'stx:libdb/libopenDBX/driver/pharo' }"

PharoOpenDBX subclass:#OpenDBXWin32
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverPharo-Dialect'
!


!OpenDBXWin32 methodsFor:'api calls'!

apiBind: handle database: databaseName name: userName password: password method: method
	"int odbx_bind(odbx_t* handle, const char* database, const char* who, const char* cred,int method )"
	<apicall: long 'odbx_bind' (ulong char* char* char* ulong) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiError: handle number: err
	"long odbx_error(odbx_t*)"
	<apicall: char* 'odbx_error' (ulong long) module: 'libopendbx-1.dll' >
	^self externalCallFailed	
!

apiErrorType: handle number: err 
	"int odbx_error_type( odbx_t*, int )"
	<apicall: long 'odbx_error_type' (ulong long) module: 'libopendbx-1.dll'>
	^ self externalCallFailed
!

apiFinalize: handle 
	"long odbx_finish(odbx_t*)"
	<apicall: long 'odbx_finish' (ulong) module: 'libopendbx-1.dll' >
	^self externalCallFailed
!

apiGetOption: handle option: anOption value: aValue
	"int odbx_get_option(odbx_t* handle, unsigned int option,void* value)"
	<apicall: long 'odbx_get_option' (ulong ulong void*) module: 'libopendbx-1.dll' >
	^self externalCallFailed
	
!

apiInitialize: handle backend: backend host: host port: port
	"long odbx_init(odbx_t**, char*, char*, char*)"
	<apicall: long 'odbx_init' (ulong* char* char* char*) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiOpenLarge: aResultSetHandleNumber handle: aLargeHandleWordArray value: aString
	"int odbx_lo_open(odbx_result_t* result, odbx_lo_t** lo, const char* value)"
	<apicall: long 'odbx_lo_open' (ulong ulong* char*) module: 'libopendbx-1.dll' >
	^self externalCallFailed
!

apiQuery: handle query: query length: length
	"long odbx_query(odbx_t*, char*, ulong)"
	<apicall: long 'odbx_query' (ulong char* ulong) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiQueryColumnLength: handle index: index
	"unsigned long odbx_field_length( odbx_result_t* result, unsigned long pos ) "
	"IMPORTANT: Index es zero-based"
	<apicall: long 'odbx_field_length' (ulong ulong) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiQueryColumnName: handle index: index
	"char* odbx_column_name(odbx_result_t* result, unsigned long pos )"
	"IMPORTANT: Index es zero-based"
	<apicall: char* 'odbx_column_name' (ulong short) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiQueryColumnType: handle index: index
	"char* odbx_column_type( odbx_result_t* result, unsigned long pos )"
	"IMPORTANT: Index es zero-based"
	<apicall: short 'odbx_column_type' (ulong short) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiQueryColumns: handle
	"int odbx_column_count(odbx_result_t* result )"
	<apicall: long 'odbx_column_count' (ulong) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiQueryFetchRow: handle 
	"int odbx_row_fetch( odbx_result_t* result )"
	<apicall: long 'odbx_row_fetch' (ulong) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiQueryFieldValue: handle index: index
	"const char* odbx_field_value( odbx_result_t* result, unsigned long pos )"
	"IMPORTANT: Index es zero-based"
	<apicall: char* 'odbx_field_value' (ulong ulong) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiQueryFinalize: handle
	"int odbx_result_finish( odbx_result_t* result )"
	<apicall: long 'odbx_result_finish' (ulong) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiQueryResult: connectionHandle handle: handle timeout: timeout chunk: chunk
	"int odbx_result( odbx_t* handle, odbx_result_t** result, struct timeval* timeout, unsigned long chunk )"
	<apicall: long 'odbx_result' (ulong ulong* DBXTimeSpec* long) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiQueryRowsAffected: handle
	"uint64_t odbx_rows_affected(odbx_result_t* result )"
	<apicall: long 'odbx_rows_affected' (ulong) module: 'libopendbx-1.dll'>
	^self externalCallFailed
!

apiSetOption: handle option: anOption value: aValue
	"int odbx_set_option(odbx_t* handle, unsigned int option, void* value ) "
	<apicall: long 'odbx_set_option' (ulong ulong char*) module: 'libopendbx-1.dll' >
	^self externalCallFailed
	
!

apiUnbind: handle 
	"int odbx_unbind(odbx_t*)"
	<apicall: long 'odbx_unbind' (ulong) module: 'libopendbx-1.dll' >
	^self externalCallFailed
! !

!OpenDBXWin32 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/pharo/OpenDBXWin32.st,v 1.2 2013-04-15 13:15:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/pharo/OpenDBXWin32.st,v 1.2 2013-04-15 13:15:09 cg Exp $'
! !

