"
 COPYRIGHT (c) 1999 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

HashStream subclass:#MD5Stream
	instanceVariableNames:'hashContext'
	classVariableNames:'HashSize ContextSize'
	poolDictionaries:''
	category:'System-Crypt-Hashing'
!

!MD5Stream primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#include "md5.h"

%}
! !

!MD5Stream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    Generate a MD5 hash value as defined in RFC 1321.
    This may be used as checksum or for generating cryptographic signatures.

    Note:
        in August 2004, some researchers have found a way to generate full collisions for MD5.
        Therefore, for new applications, it may be wise to choose another hash function for security stuff.
        See a hash-collision example in the examples method.

        So, the MD5 algorithm has severe weaknesses, for example it is easy to compute two messages yielding
        the same hash (collision attack).
        The use of this algorithm is only justified for non-cryptographic application.


    performance: roughly
                          150 Mb/s on a 2007 MAC Powerbook (2.6Ghz I7-Duo)
                       104000 Kb/s on a 2.5Ghz 64X2 Athlon 4800+ (64bit)
                        80000 Kb/s on a 2Ghz Duo
                        27200 Kb/s on a 1.2Ghz Athlon
                        12600 Kb/s on a 400Mhz PIII
                         9150 Kb/s on a 300Mhz Sparc.
        performance is almost completely limited by the speed of the md5-routine, which is the reference
        implementation in C from md5lib.

    [author:]
        Stefan Vogel

    [references:]
        * Ronald L. Rivest, http://www.roxen.com/rfc/rfc1321.html
          ''The MD5 Message-Digest Algorithm'', IETF RFC-1321 (informational).
        * Bruce Schneier, Section 18.5 MD5, ''Applied Cryptography, 2nd edition'', John Wiley &amp; Sons, 1996

    [see also:]
        SHA1Stream
        SHA256Stream SHA512Stream (in libcrypt)

    [class variables:]
        HashSize        size of returned hash value
        ContextSize     (implementation) size of hash context

    [instance variables:]
        hashContext     (implementation)
                        internal buffer for computation of the hash value
"
!

examples
"
								[exBegin]
    Test Vectors (from FIPS PUB 180-1); results are:

    'abc'
    -> #[90 1 50 98 3C D2 4F B0 D6 96 3F 7D 28 E1 7F 72]

    'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'
    -> #[82 15 EF 7 96 A2 B CA AA E1 16 D3 87 6C 66 4A]

    A million repetitions of 'a'
    -> #[77 7 D6 AE 4E 2 7C 70 EE A2 A9 35 C2 29 6F 21]
								[exEnd]

								[exBegin]
     Transcript showCR:(MD5Stream hashValueOf:'abc') hexPrintString
								[exEnd]

								[exBegin]
     (MD5Stream hashValueOf:'abc')
	printOn:Transcript base:16.
     Transcript cr.
								[exEnd]

								[exBegin]
     (MD5Stream hashValueOfStream:('abc' readStream))
	    printOn:Transcript base:16.
     Transcript cr.
								[exEnd]

								[exBegin]
    |hashStream|

    hashStream := MD5Stream new.
    hashStream nextPut:'abc'.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
    hashStream nextPut:'dbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
								[exEnd]

								[exBegin]
    |hashStream|

    hashStream := MD5Stream new.
    hashStream nextPut:'a' asByteArray.
    hashStream nextPut:'bc' asByteArray.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
    hashStream nextPut:'dbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq' asByteArray.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
								[exEnd]

								[exBegin]
    |hashStream|

    hashStream := MD5Stream new.
    1000000 timesRepeat:[ hashStream nextPut:$a ].
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
								[exEnd]

								[exBegin]
    |hashStream|

    hashStream := MD5Stream new.
    hashStream nextPut:'a'.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
								[exEnd]

								[exBegin]
    |hashStream|

    hashStream := MD5Stream new.
    hashStream nextPut:$a.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
								[exEnd]

								[exBegin]
    |hashStream|

    hashStream := MD5Stream new.
    hashStream nextPut:'abc'.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
    hashStream reset.
    hashStream nextPut:'abc'.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
								[exEnd]

  a collision:
								[exBegin]
    |hashStream|

    hashStream := MD5Stream new.
    hashStream nextPut:(ByteArray fromHexStringWithSeparators:'
d131dd02c5e6eec4693d9a0698aff95c 2fcab58712467eab4004583eb8fb7f89
55ad340609f4b30283e488832571415a 085125e8f7cdc99fd91dbdf280373c5b
d8823e3156348f5bae6dacd436c919c6 dd53e2b487da03fd02396306d248cda0
e99f33420f577ee8ce54b67080a80d1e c69821bcb6a8839396f9652b6ff72a70').
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
    hashStream reset.

    hashStream nextPut:(ByteArray fromHexStringWithSeparators:'
d131dd02c5e6eec4693d9a0698aff95c 2fcab50712467eab4004583eb8fb7f89
55ad340609f4b30283e4888325f1415a 085125e8f7cdc99fd91dbd7280373c5b
d8823e3156348f5bae6dacd436c919c6 dd53e23487da03fd02396306d248cda0
e99f33420f577ee8ce54b67080280d1e c69821bcb6a8839396f965ab6ff72a70').
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
								[exEnd]

  timing throughput:
								[exBegin]
    |hashStream n t|

    hashStream := MD5Stream new.
    n := 1000000.
    t := Time millisecondsToRun:[
	    n timesRepeat:[
		hashStream nextPutAll:'12345678901234567890123456789012345678901234567890'.
	    ].
	 ].
    t := (t / 1000) asFloat.
    Transcript show:t; show:' seconds for '; show:(50*n/1024) asFloat; showCR:' Kb'.
    Transcript show:(n*50/1024 / t); showCR:' Kb/s'
								[exEnd]
"
! !

!MD5Stream class methodsFor:'initialization'!

initialize
    |ctxSize|

%{
    ctxSize = __mkSmallInteger(sizeof(MD5_CTX));
%}.
    ContextSize := ctxSize.
    HashSize := 16.

    "
	self initialize
    "



! !

!MD5Stream class methodsFor:'queries'!

hashBlockSize
    "return the block size used internally by the compression function"
    
    ^ 64

    "Created: / 18.3.1999 / 08:36:44 / stefan"
!

hashSize
    "return the size of the hashvalue returned by instances of this class"

    ^ HashSize

    "Created: / 18.3.1999 / 08:02:16 / stefan"
! !

!MD5Stream methodsFor:'initialization'!

initialize

    hashContext := ByteArray new:ContextSize.
    self reset.

    "Modified: / 18.3.1999 / 08:03:42 / stefan"
! !

!MD5Stream methodsFor:'positioning'!

reset
   "reset the stream in order to compute a new hash value"

%{
   if (__isByteArray(__INST(hashContext)) &&
       __byteArraySize(__INST(hashContext)) == sizeof(MD5_CTX)
   ) {
	MD5_CTX *ctx = (MD5_CTX *)__ByteArrayInstPtr(__INST(hashContext))->ba_element;

	MD5Init(ctx);
	RETURN(self);
   }
%}.
   ^ self primitiveFailed



! !

!MD5Stream methodsFor:'queries'!

hashValue
    "Get the value hashed so far.
     The context is kept, so that more objects may be hashed after
     retrieving a hash value"


    |digest|

    digest := ByteArray new:HashSize.

%{
    if (__isByteArray(__INST(hashContext)) &&
	__byteArraySize(__INST(hashContext)) == sizeof(MD5_CTX) &&
	__isByteArray(digest) &&
	__byteArraySize(digest) == 16
    ) {
	MD5_CTX *ctx = (MD5_CTX *)__ByteArrayInstPtr(__INST(hashContext))->ba_element;
	MD5_CTX copyContext;

	memcpy(&copyContext, ctx, sizeof(copyContext));
	MD5Final(__ByteArrayInstPtr(digest)->ba_element, &copyContext);
	RETURN(digest);
    }
%}.

    ^ self primitiveFailed
! !

!MD5Stream methodsFor:'writing'!

nextPutBytes:count from:anObject startingAt:start
    "update the hash value with count bytes from an object starting at index start.
     The object must have non-pointer indexed instvars
     (i.e. be a ByteArray, String, Float- or DoubleArray),
     or an externalBytes object (with known size)"

%{
    INT len, offs;
    INT objSize;
    int nInstBytes;
    char *extPtr;

    if (__isByteArray(__INST(hashContext))
       &&__byteArraySize(__INST(hashContext)) == sizeof(MD5_CTX)
       && __bothSmallInteger(count, start)
    ) {
        MD5_CTX *ctx = (MD5_CTX *)__ByteArrayInstPtr(__INST(hashContext))->ba_element;

        len = __intVal(count);
        offs = __intVal(start) - 1;

        if (__isExternalBytesLike(anObject)) {
            OBJ sz;

            nInstBytes = 0;
            extPtr = (char *)__externalBytesAddress(anObject);
            if (extPtr == (char *)0) goto bad;
            sz = __externalBytesSize(anObject);
            if (__isSmallInteger(sz)) {
                objSize = __intVal(sz);
            } else {
                objSize = 0; /* unknown */
            }
        } else {
            OBJ oClass = __Class(anObject);
            int nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);

            nInstBytes = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
            switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
                case BYTEARRAY:
                case WORDARRAY:
                case LONGARRAY:
                case SWORDARRAY:
                case SLONGARRAY:
                case FLOATARRAY:
                    break;
                case DOUBLEARRAY:
#ifdef __NEED_DOUBLE_ALIGN
                    nInstBytes = (nInstBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
#endif
                    break;
                case LONGLONGARRAY:
                case SLONGLONGARRAY:
#ifdef __NEED_LONGLONG_ALIGN
                    nInstBytes = (nInstBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
#endif
                    break;
                default:
                    goto bad;
            }
            // nInstBytes is the number of bytes occupied by pointer instance variables
            // subtract from size and add to byte-pointer
            objSize = __Size(anObject) - nInstBytes;
            extPtr = (char *)anObject + nInstBytes;
        }
        if ((offs >= 0) && (len >= 0) && (objSize >= (len + offs))) {
            MD5Update(ctx, extPtr+offs, len);
            RETURN (count);
        }
    }
bad: ;
%}.

    ^ self primitiveFailed
! !

!MD5Stream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


MD5Stream initialize!
