"
 COPYRIGHT (c) 1998,2010 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

SharedPool subclass:#ZipArchiveConstants
	instanceVariableNames:''
	classVariableNames:'ECREC_SIZE LREC_SIZE CREC_SIZE CENTRAL_DIRECTORY_SIZE
		TOTAL_ENTRIES_CENTRAL_DIR C_COMPRESSED_SIZE
		C_RELATIVE_OFFSET_LOCAL_HEADER C_FILENAME_LENGTH
		C_UNCOMPRESSED_SIZE C_CENTRAL_HEADER_SIGNATURE
		C_LOCAL_HEADER_SIGNATURE C_CENTRAL_END_SIGNATURE
		COMPRESSION_STORED COMPRESSION_SHRUNK COMPRESSION_REDUCED1
		COMPRESSION_REDUCED2 COMPRESSION_REDUCED3 COMPRESSION_REDUCED4
		COMPRESSION_IMPLODED COMPRESSION_TOKENIZED COMPRESSION_DEFLATED
		COMPRESSION_ENHANCED_DEFLATED COMPRESSION_PKWARE
		COMPRESSION_RESERVED11 COMPRESSION_BZIP2 COMPRESSION_RESERVED13
		COMPRESSION_RESERVED14 COMPRESSION_RESERVED15 COMPRESSION_LZMA
		COMPRESSION_RESERVED17 COMPRESSION_IBM_TERSE COMPRESSION_IBM_LZ77
		COMPRESSION_WAVPACK COMPRESSION_PPMD_V1_R1
		EXTERNALFILEATTRIBUTES_ISFILE EXTERNALFILEATTRIBUTES_ISDIRECTORY'
	poolDictionaries:''
	category:'System-Support-FileFormats'
!

!ZipArchiveConstants class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998,2010 by eXept Software AG
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
    refactored shared constants to here

    [author:]
        Claus Gittinger
"
! !

!ZipArchiveConstants class methodsFor:'class initialization'!

initialize
    ECREC_SIZE := 18.
    LREC_SIZE := 26.
    CREC_SIZE := 42.

    TOTAL_ENTRIES_CENTRAL_DIR := 10.
    CENTRAL_DIRECTORY_SIZE := 12.

    C_COMPRESSED_SIZE := 16.
    C_UNCOMPRESSED_SIZE := 20.
    C_FILENAME_LENGTH := 24.
    C_RELATIVE_OFFSET_LOCAL_HEADER := 38.

    C_CENTRAL_HEADER_SIGNATURE := 16r02014b50.
    C_LOCAL_HEADER_SIGNATURE := 16r04034b50.
    C_CENTRAL_END_SIGNATURE := 16r06054b50.

    "/ compression methods

    COMPRESSION_STORED            := 0.
    COMPRESSION_SHRUNK            := 1.
    COMPRESSION_REDUCED1          := 2.
    COMPRESSION_REDUCED2          := 3.
    COMPRESSION_REDUCED3          := 4.
    COMPRESSION_REDUCED4          := 5.
    COMPRESSION_IMPLODED          := 6.
    COMPRESSION_TOKENIZED         := 7.
    COMPRESSION_DEFLATED          := 8.
    COMPRESSION_ENHANCED_DEFLATED := 9.
    COMPRESSION_PKWARE            := 10.
    COMPRESSION_RESERVED11        := 11.
    COMPRESSION_BZIP2             := 12.
    COMPRESSION_RESERVED13        := 13.
    COMPRESSION_RESERVED14        := 14.
    COMPRESSION_RESERVED15        := 15.
    COMPRESSION_LZMA              := 16.
    COMPRESSION_RESERVED17        := 17.
    COMPRESSION_IBM_TERSE         := 18.
    COMPRESSION_IBM_LZ77          := 19.

    COMPRESSION_WAVPACK           := 97.
    COMPRESSION_PPMD_V1_R1        := 98.

    EXTERNALFILEATTRIBUTES_ISFILE := 32.
    EXTERNALFILEATTRIBUTES_ISDIRECTORY := 16.

    "
     ZipArchiveConstants initialize
    "

    "Modified: / 19-11-2010 / 15:54:36 / cg"
! !

!ZipArchiveConstants class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/ZipArchiveConstants.st,v 1.2 2010-11-19 14:54:49 cg Exp $'
! !

ZipArchiveConstants initialize!
