"
 COPYRIGHT (c) 2002 by eXept Software AG
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

CompressionStream subclass:#ZipStream
	instanceVariableNames:''
	classVariableNames:'Z_DEFLATED HEAD_OS_CODE HEAD_RESERVED HEAD_EXTRA_FIELD
		HEAD_ORIG_NAME HEAD_COMMENT HEAD_CRC GZ_MAGIC_ID'
	poolDictionaries:''
	category:'Streams-Compressed'
!

!ZipStream primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */
#include "zlib.h"
#include "zutil.h"

typedef enum {
	  e_opmode_unspecified          /* processing done */
	, e_opmode_deflate              /* running deflate */
	, e_opmode_inflate              /* running inflate */
} e_opmode;

typedef struct {
	z_stream        stream;         /* pointer to the external in -stream */
	Bytef *         in_ref;         /* size    of the external in -stream */
	Bytef *         out_ref;        /* pointer to the external out-stream */
	uLong           out_total;      /* size    of the external out-stream */

	e_opmode        op_mode;        /* current operational mode */
	uLong           crc_32;         /* keeps the current crc */

	Bytef           tail_buff[ 8 ]; /* store the tail in the read modus */
	uLong           tail_size;      /* to check the crc and data length */
} zstream_s;

%}
! !

!ZipStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Zip compression and decompression (as used in gzip and zip)

    [author:]
        Claus Atzkern

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
                                                                [exBegin]
    |compressedDataStream zipStream compressedData uncompressedData|

    compressedDataStream := #[] writeStream.
    zipStream := ZipStream writeOpenOn:compressedDataStream.
    zipStream nextPutAll:'hallo Welt'.
    zipStream close.

    compressedData := compressedDataStream contents.

    zipStream := ZipStream readOpenOn:(compressedData readStream).

    zipStream notNil ifTrue:[
        |stream c|

        stream := '' writeStream.

        [ (c := zipStream nextOrNil) notNil ] whileTrue:[
            stream nextPut:c
        ].
        stream close.
        uncompressedData := stream contents.
    ].
    ^ uncompressedData
                                                                [exEnd]


                                                                [exBegin]
    |fstream zipStream c|

    fstream := FileStream newTemporary.
    zipStream := ZipStream writeOpenOn:fstream.
    zipStream nextPutAll:'hallo Welt(1) - test....'.
    zipStream cr.
    zipStream nextPutAll:'hallo Welt(2) - test....'.
    zipStream cr.

    zipStream close.
    fstream close.

    fstream := fstream fileName readStream.
    zipStream := ZipStream readOpenOn:fstream.

    Transcript showCR:zipStream contents.

    zipStream close.
    fstream close.
    fstream fileName delete.
                                                                [exEnd]

"
! !

!ZipStream class methodsFor:'initialization'!

initialize
    "setup class attributes derived from the library"

    |z_deflated os_code|
%{
    z_deflated = __MKSMALLINT( Z_DEFLATED );
    os_code    = __MKSMALLINT( OS_CODE );
%}.

    Z_DEFLATED            := z_deflated.

    HEAD_OS_CODE          := os_code.
    HEAD_RESERVED         := 16rE0.     " bits 5..7:  reserved "
    HEAD_EXTRA_FIELD      := 16r04.     " bit 2 set:  extra field present "
    HEAD_ORIG_NAME        := 16r08.     " bit 3 set:  original file name present "
    HEAD_COMMENT          := 16r10.     " bit 4 set:  file comment present "
    HEAD_CRC              := 16r02.     " bit 1 set:  header CRC present "

    GZ_MAGIC_ID           := #[ 16r1f 16r8b ]
! !

!ZipStream class methodsFor:'instance creation'!

readOpenAsZipStreamOn:aStream
    "open to read data compressed from stream,
     the default readOpenOn: will open ZipStream as gzip stream"

    ^ self
        readOpenAsZipStreamOn:aStream
        suppressHeaderAndChecksum:(self defaultSuppressHeaderAndChecksum)
!

readOpenAsZipStreamOn:aStream suppressFileHeader:suppressFileHeader suppressZipHeaderAndChecksum:suppressZipHeaderAndChecksum
    "open to read data compressed from stream,
     the default readOpenOn: will open ZipStream as gzip stream"

    ^ self basicNew
        openWithMode:#readonly
        on:aStream
        suppressFileHeader:suppressFileHeader suppressZipHeaderAndChecksum:suppressZipHeaderAndChecksum
!

readOpenAsZipStreamOn:aStream suppressHeaderAndChecksum:aBoolean
    "open to read data compressed from stream,
     the default readOpenOn: will open ZipStream as gzip stream"

    ^ self basicNew
        streamOpenWithMode:#readonly
        on:aStream
        suppressHeaderAndChecksum:aBoolean
!

writeOpenAsZipStreamOn:aStream
    "open to write data compressed to stream,
     the default writeOpenOn: will open ZipStream as gzip stream"

    ^ self
        writeOpenAsZipStreamOn:aStream
        suppressHeaderAndChecksum:(self defaultSuppressHeaderAndChecksum)
!

writeOpenAsZipStreamOn:aStream suppressFileHeader:suppressFileHeader suppressZipHeaderAndChecksum:suppressZipHeaderAndChecksum
    "open to write data compressed to stream,
     the default writeOpenOn: will open ZipStream as gzip stream"

    ^ self basicNew
        openWithMode:#writeonly
        on:aStream
        suppressFileHeader:suppressFileHeader suppressZipHeaderAndChecksum:suppressZipHeaderAndChecksum
!

writeOpenAsZipStreamOn:aStream suppressHeaderAndChecksum:aBoolean
    "open to write data compressed to stream,
     the default writeOpenOn: will open ZipStream as gzip stream"

    ^ self basicNew
        streamOpenWithMode:#writeonly
        on:aStream
        suppressHeaderAndChecksum:aBoolean
! !

!ZipStream class methodsFor:'ZipInterface compatibility - compress/uncompress'!

compress: aUncompressedByteArray into: aCompressedByteArray
    ^ self 
        flatBytesIn: aUncompressedByteArray
        from: 1 to: (aUncompressedByteArray size)
        into: aCompressedByteArray
        doCompress: true.
!

flatBytesIn:bytesIn from:start to:stop into:bytesOut doCompress:doCompress
    "compress or uncompress the bytesIn buffer into the bytesOut buffer; returns
     the un/compressed size; on error an exception is raised"

    |errorNr|

    ((start between:1 and:stop) and:[stop <= bytesIn size]) ifFalse:[
        ^ self error:'invalid argument size'
    ].

%{
    if (__bothSmallInteger(start, stop)) {
        uLong __start = __intVal(start);
        uLong __stop = __intVal(stop);
        uLong __countIn = __stop - __start + 1;
        char *__bytesIn;
        char *__bytesOut;
        uLong __countOut;

        if (__isBytes(bytesIn)) {
            __bytesIn = __byteArrayVal(bytesIn);
        } else if (__isStringLike(bytesIn)) {
            __bytesIn = __stringVal(bytesIn);
        }

        if (__isBytes(bytesOut)) {
            __bytesOut = __byteArrayVal(bytesOut);
            __countOut = __byteArraySize(bytesOut);
        } else if (__isString(bytesOut)) {
            __bytesOut = __stringVal(bytesOut);
            __countOut = __stringSize(bytesOut);
        }

        if (__bytesOut && __bytesIn && __countOut > 0) {
            int __result;

            __bytesIn += __intVal(start) - 1;

            __result = (doCompress == true)
                    ? compress  ((Byte *) __bytesOut, &__countOut, (Byte *) __bytesIn, __countIn)
                    : uncompress((Byte *) __bytesOut, &__countOut, (Byte *) __bytesIn, __countIn);

            if (__result == Z_OK) {
                RETURN(__MKSMALLINT(__countOut));
            }

            errorNr = __MKSMALLINT(__result);
        }
    }
%}.

    errorNr isNil ifTrue:[ ^ self error:'invalid arguments' ].
    errorNr ==  1 ifTrue:[ ^ self error:'stream at end' ].
    errorNr == -3 ifTrue:[ ^ self error:'input data are corrupted' ].
    errorNr == -4 ifTrue:[ ^ self error:'not enough memory' ].
    errorNr == -5 ifTrue:[ ^ self error:'not enough memory in the output stream' ].

    self error:('compressing error: ', errorNr printString).
!

uncompress: aCompressedByteArray into: anUncompressedByteArray
    ^ self 
        flatBytesIn: aCompressedByteArray
        from: 1 to: (aCompressedByteArray size)
        into: anUncompressedByteArray
        doCompress: false.
! !

!ZipStream class methodsFor:'ZipInterface compatibility - crc'!

crc32Add:aCharacterOrByte crc:crc
    "Update a running crc with aCharacterOrByte
     and return the updated crc "
%{ /* NOCONTEXT */
    if (__isInteger(crc)) {
        int __int;
        char __byte;
        uLong  __crc;

        if (__isCharacter(aCharacterOrByte)) {
            __int = __smallIntegerVal(__characterVal(aCharacterOrByte));
        } else if (__isSmallInteger(aCharacterOrByte)) {
            __int = __smallIntegerVal(aCharacterOrByte);
        } else{
            goto err;
        }
        if (__int < 0 || __int > 255) goto err;
        __byte = __int;

        __crc  = __unsignedLongIntVal( crc );
        __crc = crc32(__crc, (Byte *) &__byte, 1 );
        RETURN( __MKUINT(__crc) );
    }
err:;
%}.

    ^ self error:'invalid argument'
!

crc32BytesIn:bytesIn from:start to:stop crc:crc
    "Update a running crc with the bytes buf[start.. stop]
     and return the updated crc"

%{ /* NOCONTEXT */
    if (__isInteger(crc) && __bothSmallInteger(start, stop)) {
        char * __bytes  = 0;
        unsigned int __size;
        uLong  __crc  = __unsignedLongIntVal( crc );
        int   __start = __intVal( start );
        int   __stop = __intVal( stop );

        if (__isBytes(bytesIn)) {
            __bytes = __byteArrayVal(bytesIn);
            __size = __byteArraySize(bytesIn);
        } else if (__isStringLike(bytesIn)) {
            __bytes = __stringVal(bytesIn);
            __size = __stringSize(bytesIn);
        } else {
            goto err;
        }

        if (__start < 1 || __start > __stop || __stop > __size) goto err;

        __size = __stop - __start + 1;
        __bytes += __start - 1;
        __crc = crc32(__crc, (Byte *) __bytes, __size );

        RETURN( __MKUINT(__crc) );
    }
err:;
%}.

    ^ self error:'invalid argument size'
! !

!ZipStream class methodsFor:'queries'!

maxDistanceCodes
    ^ 30

    "Created: / 11-09-2011 / 17:11:36 / cg"
!

maxLiteralCodes
    ^ 286

    "Created: / 11-09-2011 / 17:11:15 / cg"
! !

!ZipStream methodsFor:'low level'!

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
		inflateEnd( & _zstream->stream );
	    else
		deflateEnd( & _zstream->stream );
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
	int         _errorNo, _action;
	uLong       _bfsize;
	zstream_s * _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	if( _zstream->op_mode != e_opmode_deflate )
	    RETURN( false );

	_bfsize = _zstream->out_total;

	if( _zstream->stream.state == NULL )
	{
	    /* processing finished; write crc_32 and the total size
	    */
	    uLong   v, i;
	    Bytef * p = _zstream->out_ref;

	    v = _zstream->crc_32;
	    for( i = 0; i < 4; ++i ) { p[i] = v & 0xff; v >>= 8; }

	    v = _zstream->stream.total_in;
	    for( i = 4; i < 8; ++i ) { p[i] = v & 0xff; v >>= 8; }

	    _zstream->op_mode          = e_opmode_unspecified;
	    _zstream->stream.avail_in  = 0;
	    _zstream->stream.next_in   = Z_NULL;
	    _zstream->stream.avail_out = _bfsize - 8;
	    RETURN( true );
	}
	_zstream->stream.avail_out = _bfsize;
	_zstream->stream.next_out  = _zstream->out_ref;

	_action  = (__INST(hitEOF) == true) ? Z_FINISH : Z_NO_FLUSH;
	_errorNo = deflate( & _zstream->stream, _action );

	if( _errorNo == Z_STREAM_END )
	{
	    _zstream->stream.avail_in = 0;
	    _zstream->stream.next_in  = Z_NULL;
	    _errorNo = deflateEnd( & _zstream->stream );
	}

	if( _errorNo == Z_OK )
	{
	    if( _zstream->stream.avail_out == 0 )
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
    "low level - deflateInit"

    |errorNo level windowBits|

    errorNo := nil.
    level   := BlockSize.
    windowBits := self zget_windowBits.

%{
    OBJ _zstreamObj = __INST( zstream );

    if( (_zstreamObj != nil) && __isSmallInteger(level) )
    {
	int         _errorNo;
	zstream_s * _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	_zstream->op_mode = e_opmode_deflate;

	_errorNo = deflateInit2( & _zstream->stream
			       , __intVal( level )
			       , Z_DEFLATED
			       , __intVal( windowBits )
			       , DEF_MEM_LEVEL
			       , Z_DEFAULT_STRATEGY
			       );

	if( _errorNo == Z_OK )
	    RETURN( self );

	errorNo = __MKSMALLINT( _errorNo );
    }
%}.
    errorNo isNil ifTrue:[
	zstream isNil ifTrue:[ self errorNotOpen ].
	self invalidArgument .
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
	uInt        _count;
	zstream_s * _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	_count = _zstream->out_total - _zstream->stream.avail_out;

	RETURN( __MKSMALLINT (_count) );
    }
%}.
    self errorNotOpen.
!

zget_windowBits
    "answer the bits used for inflateInit2 or deflateInit2...
    a negative WindowBits value suppresses the zlib header and the checksum..."

    |windowBits|
%{
    windowBits = __MKSMALLINT( MAX_WBITS );
%}.

    self isHeaderAndChecksumSuppressed ifTrue:[
	"/ undocumented feature.....
	^ windowBits negated
    ].
    ^ windowBits
!

zinflate
    "low level - inflate
    "
    |errorNo tailError|

    tailError := nil.
    errorNo   := nil.
%{
    OBJ _zstreamObj = __INST( zstream );

    if( _zstreamObj != nil )
    {
	int         _errorNo, _count;
	zstream_s * _zstream;
	int         _avail_in;

	_zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	if( _zstream->op_mode != e_opmode_inflate )
	    RETURN( nil );

	_avail_in = _zstream->stream.avail_in;

	if( _zstream->stream.state == NULL )
	{
	    /* processing finished : check crc and data length */
	    Bytef * _next_in;
	    Bytef * _buff;
	    uLong   _tnum;
	    int     _i;

	    _next_in   = _zstream->stream.next_in;
	    _buff = _zstream->tail_buff;
	    _tnum = _zstream->tail_size;

	    while( (_avail_in > 0) && (_tnum < 8) )
	    {
	       _buff[_tnum] = * _next_in;

		++_next_in;
		++_tnum;
		--_avail_in;
	    }
	    _zstream->tail_size = _tnum;

	    if( _tnum < 8 )                     /* test whether tail is read */
		RETURN( __MKSMALLINT (0) );     /* need more data */

	    /* compute and check crc */
	    for( _tnum = 0, _i = 4; --_i >= 0; _tnum = (_tnum << 8) + _buff[_i] );

	    if( _tnum != _zstream->crc_32 )
		{ tailError = __MKSMALLINT( 1 ); goto badTail; }

	    /* compute and check data length */
	    for( _tnum = 0, _i = 8; --_i >= 4; _tnum = (_tnum << 8) + _buff[_i] );

	    if( _zstream->stream.total_out != _tnum )
		{ tailError = __MKSMALLINT( 2 ); goto badTail; }

	    _zstream->op_mode = e_opmode_unspecified;
	    RETURN( nil );
	}
	if( _avail_in == 0 )
	    RETURN( __MKSMALLINT (0) );

	_zstream->stream.avail_out = _zstream->out_total;
	_zstream->stream.next_out  = _zstream->out_ref;

	_errorNo = inflate( & _zstream->stream, Z_NO_FLUSH );

	if( _errorNo == Z_STREAM_END )
	    _errorNo = inflateEnd( & _zstream->stream );

	if( _errorNo == Z_OK )
	{
	    _count = _zstream->out_total - _zstream->stream.avail_out;

	    if( _count > 0 )
		_zstream->crc_32 = crc32( _zstream->crc_32, _zstream->out_ref, _count );

	    RETURN( __MKSMALLINT (_count) );
	}
	errorNo = __MKSMALLINT( _errorNo );
    }
badTail:;
%}.
    errorNo isNil ifTrue:[
	tailError ifNotNil:[
	    tailError == 1 ifTrue:[
		self zerror:'invalid compressed data--crc error'
	    ].
	    self zerror:'invalid compressed data--length error'
	].
	self errorNotOpen
    ].
    self zerror:errorNo.
!

zinflateInit
    "low level - inflateInit
    "
    |errorNo windowBits|

    errorNo := nil.
    windowBits := self zget_windowBits.

%{
    OBJ _zstreamObj = __INST( zstream );

    if( _zstreamObj != nil )
    {
	int         _errorNo;
	zstream_s * _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	_zstream->op_mode = e_opmode_inflate;
	_errorNo = inflateInit2 ( & _zstream->stream
				, __intVal( windowBits )
				);

	if( _errorNo == Z_OK )
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
    zstream_s * _zstream = (zstream_s *) malloc( sizeof(zstream_s) );

    if( _zstream )
    {
	OBJ     _zobj   = __MKEXTERNALADDRESS( _zstream );
	OBJ     _outObj = __INST( outputBytes );
	OBJ     _inpObj = __INST( inputBytes  );

	zmemzero( _zstream, sizeof(zstream_s) );

	_zstream->in_ref           = (Bytef *) __externalBytesAddress( _inpObj );
	_zstream->stream.next_in   = Z_NULL;
	_zstream->stream.avail_in  = 0;
	_zstream->stream.total_in  = 0;

	_zstream->out_total        = __intVal( outTotal );
	_zstream->out_ref          = (Bytef *) __externalBytesAddress( _outObj );
	_zstream->stream.next_out  = _zstream->out_ref;
	_zstream->stream.avail_out = _zstream->out_total;
	_zstream->stream.total_out = 0;

	_zstream->stream.zalloc    = (alloc_func)0;
	_zstream->stream.zfree     = (free_func) 0;
	_zstream->stream.opaque    = (voidpf)    0;

	_zstream->crc_32           = crc32( 0L, Z_NULL, 0 );
	_zstream->op_mode          = e_opmode_unspecified;
	_zstream->tail_size        = 0;

	__INST (zstream) = _zobj;
	__STORE(self, _zobj);
    }
%}.
!

zset_avail_in:count
    "set the 'avail_in' and compute the crc"
%{
    OBJ _zstreamObj = __INST( zstream );

    if( (_zstreamObj != nil) && __isSmallInteger(count) )
    {
	int         _count;
	zstream_s * _zstream = (zstream_s *) __externalBytesAddress( _zstreamObj );

	if( (_count = __intVal( count )) > 0 )
	{
	    Bytef * _in_ref = _zstream->in_ref;

	    _zstream->stream.avail_in = _count;
	    _zstream->stream.next_in  = _in_ref;

	    if( _zstream->op_mode == e_opmode_deflate )
		_zstream->crc_32 = crc32( _zstream->crc_32, _in_ref, _count );
	} else {
	    _zstream->stream.avail_in = 0;
	    _zstream->stream.next_in  = Z_NULL;
	}
	RETURN( self );
    }
%}.
    zstream isNil ifTrue:[ self errorNotOpen ].
    self invalidArgument.
! !

!ZipStream methodsFor:'startup & release'!

openWithMode:aMode on:aStream suppressFileHeader:suppressFileHeader suppressZipHeaderAndChecksum:suppressZipHeaderAndChecksum
    "open stream and write or check gzip header
     suppressFileHeader:
        if true, the gzip header (magic number and a few extra fields) is not written/read
     suppressZipHeaderAndChecksum
        controls if the gzip checksum and 2 header bytes should be written/checked"

    super
        openWithMode:aMode
        on:aStream
        suppressHeaderAndChecksum:suppressZipHeaderAndChecksum.

    suppressZipHeaderAndChecksum ifFalse:[    
        suppressFileHeader ifFalse:[
            self isReadable ifTrue:[
                "Check for the gzip magic id"            
                self readHeader
            ] ifFalse:[
                "write the gzip magic id"
                self writeHeader
            ].
        ].
    ].
!

openWithMode:aMode on:aStream suppressHeaderAndChecksum:aBoolean
    "open stream and write or check gzip header.
     Caveat:
        Backward compatibility: aBoolean controls if the gzip checksum and 2 header bytes should be written/checked
        (i.e. NOT the file header with the zip magic)"

    self
        openWithMode:aMode
        on:aStream
        suppressFileHeader:false
        suppressZipHeaderAndChecksum:aBoolean
!

readHeader
    "Check for the gzip magic id"
    |flags|

    GZ_MAGIC_ID do:[:b|
        onStream nextByte ~~ b ifTrue:[ self zerror:'version error' ]
    ].

    onStream nextByte ~~ Z_DEFLATED ifTrue:[
        self zerror:'invalid method (not deflated)'
    ].

    flags := onStream nextByte.
    (flags bitAnd:HEAD_RESERVED) ~~ 0 ifTrue:[
        self zerror:'wrong data format'
    ].

    "discard time, xflags and OS code"
    onStream skip:6.

    (flags bitAnd:HEAD_EXTRA_FIELD) ~~ 0 ifTrue:[
        |len|
        "skip the extra field"
        len := onStream nextByte + (onStream nextByte bitShift:8).
        "/ len timesRepeat:[ onStream nextByte ].
        "/ faster:
        onStream skip:len.
    ].

    (flags bitAnd:HEAD_ORIG_NAME) ~~ 0 ifTrue:[
        |b|
        "skip the original file name (up to zero byte)"
        [ (b := onStream nextByte) ~~ 0 ] whileTrue.
    ].

    (flags bitAnd:HEAD_CRC) ~~ 0 ifTrue:[
        "skip the header crc"
        onStream skip:2.
    ].
!

writeHeader

    "write the gzip magic id"
    onStream nextPutBytes:GZ_MAGIC_ID.

    "write the method"
    onStream nextPutByte:Z_DEFLATED.

    onStream nextPutBytes:#[
                0                    "write the flags"
                0 0 0 0              "write time"
                0                    "write xflags"
            ].

    "write OS code"
    onStream nextPutByte:HEAD_OS_CODE.
! !

!ZipStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ZipStream initialize!
