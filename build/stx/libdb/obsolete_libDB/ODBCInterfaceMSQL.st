"{ NameSpace: DB }"

Object subclass:#ODBCInterfaceMSQL
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Driver'
!

!ODBCInterfaceMSQL primitiveDefinitions!
%{
/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#include <stdio.h>
#include "msql.h"

%}
! !

!ODBCInterfaceMSQL primitiveVariables!
%{

/* 
 * any local C variables
 * come here (please, define as static)
 */

static m_result *       result_handle   = (m_result *) 0;
static m_row *          row_handle      = 0;
static unsigned int     field_index     = 0;
static unsigned int     debugFlag       = 0;

%}
! !


!ODBCInterfaceMSQL methodsFor:'debug'!

sqlDebugOff
   " Purpose:    
     Args: 
     Returns:   
     Notes:     
   "
%{
    debugFlag = 0;
%}

!

sqlDebugOn
   " Purpose:
     Args:
     Returns:
     Notes:
   "
%{
    debugFlag = 1;
%}
! !

!ODBCInterfaceMSQL methodsFor:'low level interface'!

sqlConnect: aHostName
   " Purpose:   Form a connection to a mSQL server 
     Args:      hostname of server
     Returns:   socket for further use.  -1 on error
     Notes:     If host == NULL, localhost is used via UNIX domain socket
   "
%{
    char * hostName = __stringVal (aHostName);
    int    sock     = 0;

    sock = msqlConnect (hostName);

    if ( debugFlag )
    {
	fprintf (stderr, "%d = msqlConnect (hostName = %s)\n", 
			sock, hostName
	);

	if ( sock < 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    result_handle   = (m_result *) 0;
    row_handle      = 0;
    field_index     = 0;
    debugFlag       = 0;

    RETURN (__MKSMALLINT(sock));
%}
!

sqlCreateDB: aDBName onService: aSocketId
   " Purpose:   Create a new database on host identified by aSocketId 
     Args:      name of database should be created, socketId identifies host
     Returns:   'true'  in case of success
		'false' in case of failure
     Notes:     
   "

%{
    char *      dbName = __stringVal(aDBName);
    int         sock   = __intVal(aSocketId);
    int         retVal = 0;

    retVal = msqlCreateDB (sock, dbName);

    if ( debugFlag )
    {
	fprintf (stderr, "%d = msqlCreateDB (sock = %d, dbName = %s)\n", 
			retVal, sock, dbName
	);

	if ( retVal != 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( retVal == 0 )
    {
	RETURN (true);
    }
 
    RETURN (false);
%}
!

sqlDataSeek:  aOffset

   " Purpose : Move the result cursor
     Args    : offset to current cursor position 
     Returns : A result handle.
     Notes   : 
   "

%{
    msqlDataSeek (result_handle, __intVal(aOffset) );
%}.

    ^ nil.
!

sqlDisconnect: aSocketId
   " Purpose:   Send a QUIT to the server and close the connection
     Args:      Server socket
     Returns:   always 'true'
     Notes:   
   "
%{
    if ( debugFlag )
    {
	fprintf (stderr, "msqlClose (aSocketId = %d)\n", 
			__intVal(aSocketId)
	);
    }

    msqlClose (__intVal(aSocketId));

    RETURN (true);
%}.
!

sqlDropDB: aDBName onService: aSocketId
   " Purpose:   Drop a database on host identified by aSocketId 
     Args:      name of database should be droped, socketId identifies host
     Returns:   'true'  in case of success
		'false' in case of failure
     Notes:     
   "

%{
    char *      dbName = __stringVal(aDBName);
    int         sock   = __intVal(aSocketId);
    int         retVal = msqlDropDB (sock, dbName);

    if ( debugFlag )
    {
	fprintf (stderr, "%d = msqlDropDB (sock = %d, dbName = %s)\n", 
			retVal, sock, dbName
	);

	if ( retVal != 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( retVal == 0 )
    {
	RETURN ( true );
    }

    RETURN ( false );
%}
!

sqlErrMsg
%{
    RETURN (__MKSTRING(msqlErrMsg));
%}
!

sqlFetchField
   " Purpose:   Return a field of the query results
     Args:      
     Returns:   a collection ('column data typ', 'column name', 'column length') 
		in case of success
		nil in case of failure
     Notes:     
   "
   |col nm typ size|

   col := OrderedCollection new.

%{
    m_field * field = msqlFetchField (result_handle);

    if ( debugFlag )
    {
	fprintf (stderr, "%x = msqlFetchField (result_handle)\n", field);

	if ( field == 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( field == 0 )
	RETURN (nil);

    nm = __MKSTRING(field->name);

    switch (field->type)
    {
    case INT_TYPE:      typ = __MKSTRING("INT");        break;
    case CHAR_TYPE:     typ = __MKSTRING("CHAR");       break;
    case REAL_TYPE:     typ = __MKSTRING("REAL");       break;
    default:            typ = __MKSTRING("UNKNOWN");    break;
    }

    size = __MKSMALLINT(field->length);
%}.

    col add: typ asSymbol.
    col add: nm.
    col add: size.

    ^ col.
!

sqlFetchRow
   " Purpose:   Return a row of the query results
     Args:      
     Returns:   a string in case of success
		nil in case of failure
     Notes:     
   "
   |col noItems tempRes|

   col :=  OrderedCollection new.

%{
    row_handle = (m_row *) msqlFetchRow (result_handle);

    if ( debugFlag )
    {
	fprintf (stderr, "%x = msqlFetchRow (result_handle)\n", row_handle);
	fprintf (stderr, "no of rows = %d, no of fields = %d\n", 
		  result_handle->numRows
		, result_handle->numFields
	);

	if ( row_handle == 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( row_handle == 0 )
    {
	msqlFreeResult (result_handle);

	RETURN (nil);
    }

    field_index = 0;
    noItems = __MKSMALLINT(result_handle->numFields);
%}.

    [(noItems ~~ 0)] whileFalse: [
%{
	tempRes = __MKSTRING((char *) row_handle [ field_index++ ]);
%}. 
	col add: tempRes.
	noItems := noItems - 1.
    ].

    ^ col.
!

sqlFieldSeek: anOffset
   " Purpose:   Move the result cursor
     Args:      offset
     Returns:   result handle
     Notes:     
   "

%{
    msqlFieldSeek (result_handle, __intVal(anOffset));
%}
!

sqlFreeResult
   " Purpose:   Free the memory allocated to a table returned by a select
     Args:      Nothing
     Returns:   Nothing
     Notes:     
   "
%{
    msqlFreeResult (result_handle);
%}
!

sqlGetHostInfo
   " Purpose:   Return the host Information
     Args:      Nothing
     Returns:   a String containing the host info
     Notes:     
   "
%{
   RETURN (__MKSTRING(msqlGetHostInfo()));
%}
!

sqlGetProtoInfo
   " Purpose:   Return the proto Information
     Args:      Nothing
     Returns:   a integer containing the proto info
     Notes:     
   "
%{
    RETURN (__MKSMALLINT(msqlGetProtoInfo()));
%}
!

sqlGetServerInfo
   " Purpose:   Return the server Information
     Args:      Nothing
     Returns:   a String containing the server info
     Notes:     
   "
%{
    RETURN (__MKSTRING(msqlGetServerInfo()));
%}
!

sqlLastHandle
%{
    RETURN (__MKUINT(result_handle));
%}
!

sqlListDBs: aSocketId
   " Purpose:   return information about existing databases 
     Args:      a SockedId, identifies the host, 
		where the databases are located
     Returns:   'true'  in case of success
		'false' in case of failure
     Notes:     
   "

%{
    int sock = __intVal(aSocketId);

    result_handle = msqlListDBs (sock);

    if ( debugFlag )
    {
	fprintf (stderr, "%x = msqlListDBs (sock = %d)\n", 
			result_handle, sock
	);

	if ( result_handle == 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( result_handle )
    {
	RETURN (true);
    }

    RETURN (false);
%}
!

sqlListFields: aSocketId inTable: aTable
   " Purpose:   return information about existing fields in table 
     Args:      a SockedId, identifies the host, where the db is located
		a table identifier
     Returns:   'true'  in case of success
		'false' in case of failure
     Notes:     
   "
%{
    int    sock  = __intVal(aSocketId);
    char * table = __stringVal(aTable);

    result_handle = msqlListFields (sock, table);

    if ( debugFlag )
    {
	fprintf (stderr, "%x = msqlListFields (sock = %d, table = %s)\n", 
			result_handle, sock, table
	);

	if ( result_handle == 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( result_handle )
    {
	RETURN (true);
    }

    RETURN (false);
%}
!

sqlListTables: aSocketId
   " Purpose:   return information about tables 
     Args:      a SockedId, identifies the host, where the tables are located
     Returns:   'true'  in case of success
		'false' in case of failure
     Notes:     
   "
%{
    int sock = __intVal(aSocketId);

    result_handle = msqlListTables (sock);

    if ( debugFlag )
    {
	fprintf (stderr, "%x = msqlListTables (sock = %d)\n", 
			result_handle, sock
	);

	if ( result_handle == 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( result_handle )
    {
	RETURN (true);
    }

    RETURN (false);
%}
!

sqlQuery: aQuery onService: aSocketId
   " Purpose:   perform a sql query on the server 
     Args:      a SQL query string
		a SockedId, identifies the host, where the dbs are located
     Returns:   'true'  in case of success
		'false' in case of failure
     Notes:     
   "

%{
    int         sock   = __intVal(aSocketId);
    char *      query  = __stringVal(aQuery);
    int         retVal = msqlQuery (sock, query);

    if ( debugFlag )
    {
	fprintf (stderr, "%d = msqlQuery (sock = %d, query = %s)\n", 
			retVal, sock, query
	);

	if ( retVal != 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( retVal == 0 )
    {
	RETURN (true);
    }

    RETURN (false);
%}
!

sqlReloadAcls: aSocketId
   " Purpose:    
     Args:      a SockedId, identifies the host, where the dbs are located
     Returns:   'true'  in case of success
		'false' in case of failure
     Notes:     
   "
%{
    int         sock   = __intVal(aSocketId);
    int         retVal = msqlReloadAcls (sock);

    if ( debugFlag )
    {
	fprintf (stderr, "%d = msqlReloadAcls (sock = %d)\n", 
			retVal, sock
	);

	if ( retVal != 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( retVal == 0 )
    {
	RETURN (true);
    }

    RETURN (false);
%}
!

sqlSelectDB: aDBName onService: aSocketId
   " Purpose:   Tell the server which database we want to use
     Args:      a string identifies the database
		a SockedId, identifies the host, where the dbs are located
     Returns:   'true'  in case of success
		'false' in case of failure
     Notes:     
   "
%{
    char *      dbName = __stringVal(aDBName);
    int         sock   = __intVal(aSocketId);
    int         retVal = msqlSelectDB (sock, dbName);

    if ( debugFlag )
    {
	fprintf (stderr, "%d = msqlSelectDB (sock = %d, dbName = %s)\n", 
			retVal, sock, dbName
	);

	if ( retVal != 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( retVal == 0 )
    {
	RETURN (true);
    }
 
    RETURN (false);
%}
!

sqlShutdown: aSocketId
   " Purpose:   Send a QUIT to the server and close the connection 
     Args:      a SockedId, identifies the host, where the dbs are located
     Returns:   'true'  in case of success
		'false' in case of failure
     Notes:     
   "
%{
    int         sock   = __intVal(aSocketId);
    int         retVal = msqlShutdown (sock);

    if ( debugFlag )
    {
	fprintf (stderr, "%d = msqlShutdown (sock = %d)\n", 
			retVal, sock
	);

	if ( retVal != 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( retVal == 0 )
    {
	RETURN (true);
    }

    RETURN (false);
%}
!

sqlStoreResult
   " Purpose:   Store the data returned from a query
     Args:      None
     Returns:   'true'  in case of success
		'false' in case of failure
     Notes:     
   "
%{
    result_handle = msqlStoreResult();

    if ( debugFlag )
    {
	fprintf (stderr, "%x = msqlStoreResult()\n", result_handle);

	if ( result_handle == 0 )
		{ fprintf (stderr, ">>>>> msqErrMsg = %s\n", msqlErrMsg); }
    }

    if ( result_handle )
    {
	RETURN (true);
    }

    RETURN (false);
%}
! !

!ODBCInterfaceMSQL class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/obsolete_libDB/ODBCInterfaceMSQL.st,v 1.1 1997-01-13 17:52:33 ah Exp $'
! !
