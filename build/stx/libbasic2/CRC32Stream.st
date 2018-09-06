"
 COPYRIGHT (c) 2003 by eXept Software AG
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

HashStream subclass:#CRC32Stream
	instanceVariableNames:'crc generatorPolynom crcTable'
	classVariableNames:'CrcTables'
	poolDictionaries:''
	category:'System-Crypt-Hashing'
!

!CRC32Stream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Standard CRC method as defined by ISO 3309 [ISO-3309] or ITU-T V.42 [ITU-T-V42].
    The default CRC polynomial employed is

        x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x+1
        (or 16r04C11DB7)

    You can also create an instace performing the Castagnioli CRC-32C
    (used in iSCSI & SCTP, G.hn payload, SSE4.2):

        self newCrc32c

        x32 + x28 + x27 + x26 + x25 + x23 + x22 + x20 + x19 + x18 + x14 + x13 + x11 + x10 + x9 + x8 + x6 + 1

    Only use CRC to protect against communication errors;
    do NOT use CRC for cryptography - use SHA1Stream or MD5Stream instead.

    Notice that this CRC is also used with PNG images - therefore, its performance
    directly affects png image processing.

    throughput:
        220 Mb/s on MacBook Pro (2.6Ghz I7)
        157000 Kb/s on a 2.5Ghz 64X2 Athlon 4800+ (64bit)
        150000 Kb/s on 2Ghz Duo

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]
        SHA1Stream
        MD5Stream

"
!

examples
"

  expect 60C1D0A0
                                                                [exBegin]
    self information:(CRC32Stream hashValueOf:'resume') hexPrintString
                                                                [exEnd]

  expect 16r60C1D0A0
                                                                [exBegin]
    self information:(CRC32Stream new
                            nextPut:$r;
                            nextPut:$e;
                            nextPut:$s;
                            nextPut:$u;
                            nextPut:$m;
                            nextPut:$e;
                            hashValue) hexPrintString
                                                                [exEnd]

  expect 16r70E46888:
                                                                [exBegin]
    self information:(CRC32Stream hashValueOf:#[1 2 3 4 5 6 7]) hexPrintString
                                                                [exEnd]

  expect 16r8CD04C73:
                                                                [exBegin]
    self information:((CRC32Stream hashValueOf:#[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF
             16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF
             16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF
             16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF]) hexPrintString)
                                                                [exEnd]

  expect 16r86D7D79A:
  timing throughput:
                                                                [exBegin]
    |hashStream n t|

    hashStream := CRC32Stream new.
    n := 1000000.
    t := Time millisecondsToRun:[
            n timesRepeat:[
                hashStream nextPutAll:'12345678901234567890123456789012345678901234567890'.
            ].
         ].
    t := (t / 1000) asFloat.
    Transcript show:'crc32:'; showCR: hashStream hashValue hexPrintString.
    Transcript show:t; show:' seconds for '; show:(50*n/1024) asFloat; showCR:' Kb'.
    Transcript show:(n*50/1024 / t); showCR:' Kb/s'
                                                                [exEnd]

"
! !

!CRC32Stream class methodsFor:'initialization'!

crcTableFor:generatorPolynomInteger
    |crcTable|

    crcTable := (CrcTables at:generatorPolynomInteger ifAbsent:nil).
    crcTable isNil ifTrue:[
	crcTable := IntegerArray new:256.

	0 to:255 do:[:count| |i|
	    i := count.
	    8 timesRepeat:[
		(i bitTest:1) ifTrue:[
		    i := generatorPolynomInteger bitXor:(i bitShift:-1)
		] ifFalse:[
		    i := i bitShift:-1
		]
	    ].
	    crcTable at:count+1 put:i.
	].
	CrcTables at:generatorPolynomInteger put:crcTable.
    ].
    ^ crcTable.
!

initialize
    CrcTables := Dictionary new.
! !

!CRC32Stream class methodsFor:'instance creation'!

generatorPolynom:anInteger
    ^ self basicNew generatorPolynom:anInteger

    "
       self assert:((self generatorPolynom:16r82F63B78)
				nextPut:'123456789';
				hashValue)    = 16rE3069283
    "
!

newCrc32c
    "return an instance of the Castagnoli CRC-32
	x32 + x28 + x27 + x26 + x25 + x23 + x22 + x20 + x19 + x18 + x14 + x13 + x11 + x10 + x9 + x8 + x6 + 1
     (used in iSCSI & SCTP, G.hn payload, SSE4.2)"

    ^ self basicNew generatorPolynom:16r82F63B78

    "
     Castagnoli crc:
       self assert:((self newCrc32c)
				nextPut:'123456789';
				hashValue) = 3808858755. '16rE3069283'

     default crc:
       self assert:((self new)
				nextPut:'123456789';
				hashValue) = 3421780262. '16rCBF43926'
    "

    "Modified (comment): / 17-05-2012 / 12:48:53 / cg"
! !

!CRC32Stream methodsFor:'accessing'!

generatorPolynom
    "answer the generator polynom"

    ^ generatorPolynom
!

generatorPolynom:anInteger
    "set the generator polynom for this instance.
     Note: you have to set the bit-reversed value, so the LSB must be first"

    generatorPolynom := anInteger.
    crc := 16rFFFFFFFF.
    crcTable := self class crcTableFor:generatorPolynom.
!

reset
    "reset the current crc value"

    crc := 16rFFFFFFFF.

    "Created: / 12-01-2012 / 12:23:03 / cg"
! !

!CRC32Stream methodsFor:'initialization'!

initialize
    "initialize the CRC to CRC-32 ITU-T:
	x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x+1"

    self generatorPolynom:16rEDB88320
! !

!CRC32Stream methodsFor:'queries'!

hashValue
    "return the computed CRC"

    ^ crc bitXor:16rFFFFFFFF.
! !

!CRC32Stream methodsFor:'writing'!

nextPutBytes:count from:anObject startingAt:start
    "add the hash of anObject to the computed hash so far."

%{
    if (__bothSmallInteger(count, start)) {
        int len, offs;
        int objSize;
        unsigned char *extPtr;

        len = __intVal(count);
        offs = __intVal(start) - 1;

        if (__isExternalBytesLike(anObject)) {
            OBJ sz = __externalBytesSize(anObject);

            extPtr = (unsigned char *)__externalBytesAddress(anObject);
            if (__isSmallInteger(sz)) {
                objSize = __intVal(sz);
            } else {
                objSize = 0; /* unknown */
            }
        } else {
            int nInstVars, nInstBytes;
            OBJ oClass = __Class(anObject);

            switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
                case BYTEARRAY:
                case WORDARRAY:
                case LONGARRAY:
                case SWORDARRAY:
                case SLONGARRAY:
                case FLOATARRAY:
                case DOUBLEARRAY:
                    break;
                default:
                    goto bad;
            }
            nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);
            nInstBytes = __OBJS2BYTES__(nInstVars);
            // nInstBytes is the number of bytes occupied by pointer instance variables
            // subtract from size and add to byte-pointer
            objSize = __qSize(anObject) - OHDR_SIZE - nInstBytes;
            extPtr = (unsigned char *)__byteArrayVal(anObject)+nInstBytes;
        }

        if ((offs >= 0) && (len >= 0) && (objSize >= (len + offs))) {
            unsigned int _crc;
            unsigned int *_crcTable = __integerArrayVal( __INST(crcTable) );
            unsigned char *cp = extPtr+offs;
            unsigned int n = len;

            if (sizeof(INT) == 8 || __isSmallInteger(__INST(crc)) ) {
                _crc = (unsigned int) (__intVal( __INST(crc) ));
            } else {
                _crc = __unsignedLongIntVal( __INST(crc) );
            }

#ifdef __LSBFIRST__
            if (((unsigned INT)cp & 3) == 0) {
                // word aligned
                for ( ; n >= 4 ; n -= 4, cp += 4) {
                    unsigned int word;
                    unsigned char _idx;

                    word = ((unsigned int *)cp)[0];
                    _idx = (_crc ^ word) & 0xFF;
                    _crc = _crcTable[_idx] ^ (_crc >> 8);
                    _idx = (_crc ^ (word>>8)) & 0xFF;
                    _crc = _crcTable[_idx] ^ (_crc >> 8);
                    _idx = (_crc ^ (word>>16)) & 0xFF;
                    _crc = _crcTable[_idx] ^ (_crc >> 8);
                    _idx = (_crc ^ (word>>24)) & 0xFF;
                    _crc = _crcTable[_idx] ^ (_crc >> 8);
                }
            }
#endif
            for ( ; n >= 4 ; n -= 4, cp += 4) {
                unsigned char _idx;

                _idx = (_crc ^ cp[0]) & 0xFF;
                _crc = _crcTable[_idx] ^ (_crc >> 8);
                _idx = (_crc ^ cp[1]) & 0xFF;
                _crc = _crcTable[_idx] ^ (_crc >> 8);
                _idx = (_crc ^ cp[2]) & 0xFF;
                _crc = _crcTable[_idx] ^ (_crc >> 8);
                _idx = (_crc ^ cp[3]) & 0xFF;
                _crc = _crcTable[_idx] ^ (_crc >> 8);
            }
            while (n-- > 0) {
                unsigned char _idx = (_crc ^ *cp++) & 0xFF;
                _crc = _crcTable[_idx] ^ (_crc >> 8);
            }

            if (sizeof(INT) == 8 || _crc <= _MAX_INT)
                __INST(crc) = __MKSMALLINT(_crc);
            else {
                // this code fails with gcc 4.7.2:
                // __INST(crc) = __MKUINT(_crc); __STORESELF(crc);
                OBJ temp = __MKUINT(_crc); 
                __INST(crc) = temp; __STORESELF(crc);
            }

            // if (__unsignedLongIntVal(__INST(crc)) == 4294967295) printf("inst: %d crc: %d new: %d\n", __unsignedLongIntVal(__INST(crc)), _crc, __unsignedLongIntVal(temp));
            RETURN (count);
        }
    }
bad: ;
%}.
    self error:'invalid argument'

    "Created: / 09-01-2012 / 16:48:35 / cg"
! !

!CRC32Stream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


CRC32Stream initialize!
