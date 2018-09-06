"
 COPYRIGHT (c) 2002 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

CompressionStream subclass:#BZip2Stream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Compressed'
!

!BZip2Stream primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#include <stdio.h>
#include <stdlib.h>

#ifdef WIN32
// sigh - bzlib.h includes windows.h, which does not like ST/X definitions
# undef Process
# undef Processor
# undef Context
# undef Array
# undef Date
# undef Method
# undef Delay
# undef Character
# undef String
# undef Time
# undef Signal
# undef Set
# undef Message
# undef Rectangle
# undef Block
# undef Object
# undef Point
# undef INT
# undef UINT
# define NO_STDIO
# if defined(__i386__) || defined(__x86__)
#  define _X86_
# endif
#endif

#include "bzlib.h"

#ifdef WIN32
# define INT  STX_INT
# define UINT STX_UINT
# ifdef STX_Process
#  define Process STX_Process
# endif
# ifdef STX_Processor
#  define Processor STX_Processor
# endif
# ifdef STX_Context
#  define Context STX_Context
# endif
# ifdef STX_Array
#  define Array STX_Array
# endif
# ifdef STX_Date
#  define Date STX_Date
# endif
# ifdef STX_Method
#  define Method STX_Method
# endif
# ifdef STX_Delay
#  define Delay STX_Delay
# endif
# ifdef STX_Character
#  define Character STX_Character
# endif
# ifdef STX_String
#  define String STX_String
# endif
# ifdef STX_Time
#  define Time STX_Time
# endif
# ifdef STX_Signal
#  define Signal STX_Signal
# endif
# ifdef STX_Set
#  define Set STX_Set
# endif
# ifdef STX_Message
#  define Message STX_Message
# endif
# ifdef STX_Rectangle
#  define Rectangle STX_Rectangle
# endif
# ifdef STX_Block
#  define Block STX_Block
# endif
# ifdef STX_Object
#  define Object STX_Object
# endif
# ifdef STX_Point
#  define Point STXPoint
# endif
#endif

typedef enum {
	  e_opmode_unspecified          /* processing done */
	, e_opmode_deflate              /* running deflate */
	, e_opmode_inflate              /* running inflate */
} e_opmode;

typedef struct {
	bz_stream       stream;         /* pointer to the external in -stream */
	char *          in_ref;         /* size    of the external in -stream */
	char *          out_ref;        /* pointer to the external out-stream */
	unsigned int    out_total;      /* size    of the external out-stream */

	e_opmode        op_mode;        /* current operational mode */
} zstream_s;

%}
! !

!BZip2Stream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!BZip2Stream methodsFor:'low level'!

zclose
    "low level close of the zip stream
    "
%{
    OBJ _zstreamObj = __INST( zstream );

    if( _zstreamObj != nil )
    {
	zstream_s * _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	__INST(zstream) = nil;

	if( _zstream->stream.state != NULL )
	{
	    if( _zstream->op_mode == e_opmode_inflate )
		BZ2_bzDecompressEnd( & _zstream->stream );
	    else
		BZ2_bzCompressEnd( & _zstream->stream );
	}
	free( _zstream );
    }
%}.
!

zdeflate
    "low level - deflate"

    |errorNo|
    errorNo := nil.
%{
    OBJ _zstreamObj = __INST( zstream );

    if( _zstreamObj != nil )
    {
	int          _errorNo, _action;
	unsigned int _bfsize;
	zstream_s *  _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	if( _zstream->op_mode != e_opmode_deflate )
	    RETURN( nil );

	_bfsize = _zstream->out_total;

	if( _zstream->stream.state == NULL )
	{
	    _zstream->op_mode = e_opmode_unspecified;
	    RETURN( nil );
	}
	_action = (__INST(hitEOF) == true) ? BZ_FINISH : BZ_RUN;

	_zstream->stream.avail_out = _bfsize;
	_zstream->stream.next_out  = _zstream->out_ref;

	_errorNo = BZ2_bzCompress( & _zstream->stream, _action );

	if( _errorNo == BZ_STREAM_END )
	{
	    _zstream->stream.avail_in = 0;
	    _zstream->stream.next_in  = NULL;
	    _errorNo = BZ2_bzCompressEnd( & _zstream->stream );
	}

	if(   (_errorNo == BZ_OK)
	   || (_errorNo == BZ_RUN_OK)
	   || (_errorNo == BZ_FINISH_OK)
	  )
	{
	    if(   (_zstream->stream.avail_out != _bfsize)
	       || (_zstream->stream.avail_in  != 0)
	      )
	      RETURN( true );

	    RETURN( false );
	}
	errorNo = __MKSMALLINT( _errorNo );
    }
%}.
    errorNo isNil ifTrue:[
	zstream isNil ifTrue:[self errorNotOpen].
	self invalidArgument.
    ].
    self zerror:errorNo.
!

zdeflateInit
    "low level - open for reading"

    |errorNo blockSize100k workFactor|

    errorNo       := nil.
    blockSize100k := BlockSize.
    workFactor    := 30.
%{
    OBJ _zstreamObj = __INST( zstream );

    if( (_zstreamObj != nil) && __bothSmallInteger(blockSize100k, workFactor) )
    {
	int         _errorNo;
	zstream_s * _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	_zstream->op_mode = e_opmode_deflate;

	_errorNo = BZ2_bzCompressInit( & _zstream->stream
				     , __intVal( blockSize100k ), 0, __intVal( workFactor ) );

	if( _errorNo == BZ_OK )
	    RETURN( self );

	errorNo = __MKSMALLINT( _errorNo );
    }
%}.
    errorNo isNil ifTrue:[
	zstream isNil ifTrue:[ self errorNotOpen ].
	self invalidArgument.
    ].
    self zerror:errorNo.
!

zget_avail_out
    "low level - get the number of available out bytes
    "
%{
    OBJ _zstreamObj = __INST( zstream );

    if( _zstreamObj != nil )
    {
	unsigned int _count;
	zstream_s *  _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	_count = _zstream->out_total - _zstream->stream.avail_out;

	RETURN( __MKSMALLINT (_count) );
    }
%}.
    self errorNotOpen.
!

zinflate
    "low level - inflate
    "
    |errorNo|

    errorNo := nil.
%{
    OBJ _zstreamObj = __INST( zstream );

    if( _zstreamObj != nil )
    {
	int         _errorNo, _count;
	zstream_s * _zstream;

	_zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	if( _zstream->op_mode != e_opmode_inflate )
	    RETURN( nil );

	if( _zstream->stream.state == NULL )
	{
	    _zstream->op_mode = e_opmode_unspecified;
	    RETURN( nil );
	}
	if( _zstream->stream.avail_in == 0 )
	    RETURN( __MKSMALLINT (0) );

	_zstream->stream.avail_out = _zstream->out_total;
	_zstream->stream.next_out  = _zstream->out_ref;

	_errorNo = BZ2_bzDecompress( & _zstream->stream );

	if( _errorNo == BZ_STREAM_END )
	    _errorNo = BZ2_bzDecompressEnd( & _zstream->stream );

	if( _errorNo == BZ_OK )
	{
	    _count = _zstream->out_total - _zstream->stream.avail_out;

	    RETURN( __MKSMALLINT (_count) );
	}
	errorNo = __MKSMALLINT( _errorNo );
    }
%}.
    errorNo isNil ifTrue:[ self errorNotOpen ].
    self zerror:errorNo.
!

zinflateInit
    "low level - inflateInit
    "
    |errorNo|

    errorNo := nil.

%{
    OBJ _zstreamObj = __INST( zstream );

    if( _zstreamObj != nil )
    {
	int         _errorNo;
	zstream_s * _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	_zstream->op_mode = e_opmode_inflate;
	_errorNo = BZ2_bzDecompressInit( & _zstream->stream, 0, 1 );

	if( _errorNo == BZ_OK )
	    RETURN( self );

	_zstream->stream.avail_in = 0;
	errorNo = __MKSMALLINT( _errorNo );
    }
%}.
    errorNo isNil ifTrue:[ self errorNotOpen ].
    self zerror:errorNo.
!

zopen
    "low level - opens the zip stream
    "
    |outTotal|

    outTotal := outputBytes size.
%{
    extern void *malloc();

    zstream_s * _zstream = (zstream_s *) malloc( sizeof(zstream_s) );

    if( _zstream )
    {
	OBJ     _zobj   = __MKEXTERNALADDRESS( _zstream );
	OBJ     _outObj = __INST( outputBytes );
	OBJ     _inpObj = __INST( inputBytes  );

	_zstream->in_ref           = (char *) __externalBytesAddress( _inpObj );
	_zstream->stream.next_in   = NULL;
	_zstream->stream.avail_in  = 0;
	_zstream->stream.total_in_lo32  = 0;
	_zstream->stream.total_in_hi32  = 0;

	_zstream->out_total        = __intVal( outTotal );
	_zstream->out_ref          = (char *) __externalBytesAddress( _outObj );
	_zstream->stream.next_out  = _zstream->out_ref;
	_zstream->stream.avail_out = _zstream->out_total;

	_zstream->stream.total_out_lo32 = 0;
	_zstream->stream.total_out_hi32 = 0;

	_zstream->stream.bzalloc   = 0;
	_zstream->stream.bzfree    = 0;
	_zstream->stream.opaque    = 0;

	_zstream->op_mode          = e_opmode_unspecified;

	__INST (zstream) = _zobj;
	__STORE(self, _zobj);
    }
%}.
!

zset_avail_in:count
    "set the 'avail_in'"
%{
    OBJ _zstreamObj = __INST( zstream );

    if( (_zstreamObj != nil) && __isSmallInteger(count) )
    {
	int         _count;
	zstream_s * _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	if( (_count = __intVal( count )) > 0 )
	{
	    char * _in_ref = _zstream->in_ref;

	    _zstream->stream.avail_in = _count;
	    _zstream->stream.next_in  = _in_ref;
	} else {
	    _zstream->stream.avail_in = 0;
	    _zstream->stream.next_in  = NULL;
	}
	RETURN( self );
    }
%}.
    zstream isNil ifTrue:[ self errorNotOpen ].
    self invalidArgument.
! !

!BZip2Stream class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

