"
 COPYRIGHT (c) 1999-2013 by eXept Software AG
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

HashStream subclass:#SHA1Stream
	instanceVariableNames:'hashContext'
	classVariableNames:'HashSize ContextSize'
	poolDictionaries:''
	category:'System-Crypt-Hashing'
!

!SHA1Stream primitiveDefinitions!
%{

#if defined(__LSBFIRST)
# ifndef LITTLE_ENDIAN
#  define LITTLE_ENDIAN /* This should be #define'd if true. */
# endif
#endif

#define SHA1HANDSOFF /* Copies data before messing with it. */

#include <stdio.h>
#include <string.h>

typedef struct {
    unsigned int32 state[5];
    unsigned int32 count[2];
    unsigned char buffer[64];
} SHA1_CTX;

#if USE_ANSI_C
 void SHA1Transform(unsigned int32 /* long */ state[5], unsigned char buffer[64]);
 void SHA1Init(SHA1_CTX* context);
 void SHA1Update(SHA1_CTX* context, unsigned char* data, unsigned int len);
 void SHA1Final(unsigned char digest[20], SHA1_CTX* context);
#else /* general: compiles everywhere */
# define SHA1Init   __SHA1Init
# define SHA1Update __SHA1Update
# define SHA1Final  __SHA2Final

 void SHA1Init();
 void SHA1Update();
 void SHA1Final();
#endif /* USE_ANSI_C */
%}
! !

!SHA1Stream primitiveFunctions!
%{

/*
 * SHA-1 in C
 * By Steve Reid <steve@edmweb.com>
 * 100% Public Domain
 */

#define rol(value, bits) (((value) << (bits)) | ((value) >> (32 - (bits))))

/* blk0() and blk() perform the initial expand. */
/* I got the idea of expanding during the round function from SSLeay */
#ifdef LITTLE_ENDIAN
# define blk0(i) (block->l[i] = (rol(block->l[i],24)&0xFF00FF00) \
    |(rol(block->l[i],8)&0x00FF00FF))
#else
# define blk0(i) block->l[i]
#endif

#define blk(i) (block->l[i&15] = rol(block->l[(i+13)&15]^block->l[(i+8)&15] \
    ^block->l[(i+2)&15]^block->l[i&15],1))

/* (R0+R1), R2, R3, R4 are the different operations used in SHA1 */
#define R0(v,w,x,y,z,i) z+=((w&(x^y))^y)+blk0(i)+0x5A827999+rol(v,5);w=rol(w,30);
#define R1(v,w,x,y,z,i) z+=((w&(x^y))^y)+blk(i)+0x5A827999+rol(v,5);w=rol(w,30);
#define R2(v,w,x,y,z,i) z+=(w^x^y)+blk(i)+0x6ED9EBA1+rol(v,5);w=rol(w,30);
#define R3(v,w,x,y,z,i) z+=(((w|x)&y)|(w&x))+blk(i)+0x8F1BBCDC+rol(v,5);w=rol(w,30);
#define R4(v,w,x,y,z,i) z+=(w^x^y)+blk(i)+0xCA62C1D6+rol(v,5);w=rol(w,30);

/*
 * Hash a single 512-bit block. This is the core of the algorithm.
 */
static void
#if USE_ANSI_C
SHA1Transform (unsigned int32 state[5], unsigned char buffer[64])
#else
SHA1Transform (state, buffer)
    unsigned int32 state[5];
    unsigned char buffer[64];
#endif
{
    unsigned int32 a, b, c, d, e;
    typedef union {
	unsigned char c[64];
	unsigned int32 /* long */ l[16];
    } CHAR64LONG16;
    CHAR64LONG16* block;
#ifdef SHA1HANDSOFF
    static unsigned char workspace[64];
    block = (CHAR64LONG16*)workspace;
    memcpy(block, buffer, 64);
#else
    block = (CHAR64LONG16*)buffer;
#endif
    /* Copy context->state[] to working vars */
    a = state[0];
    b = state[1];
    c = state[2];
    d = state[3];
    e = state[4];
    /* 4 rounds of 20 operations each. Loop unrolled. */
    R0(a,b,c,d,e, 0); R0(e,a,b,c,d, 1); R0(d,e,a,b,c, 2); R0(c,d,e,a,b, 3);
    R0(b,c,d,e,a, 4); R0(a,b,c,d,e, 5); R0(e,a,b,c,d, 6); R0(d,e,a,b,c, 7);
    R0(c,d,e,a,b, 8); R0(b,c,d,e,a, 9); R0(a,b,c,d,e,10); R0(e,a,b,c,d,11);
    R0(d,e,a,b,c,12); R0(c,d,e,a,b,13); R0(b,c,d,e,a,14); R0(a,b,c,d,e,15);
    R1(e,a,b,c,d,16); R1(d,e,a,b,c,17); R1(c,d,e,a,b,18); R1(b,c,d,e,a,19);
    R2(a,b,c,d,e,20); R2(e,a,b,c,d,21); R2(d,e,a,b,c,22); R2(c,d,e,a,b,23);
    R2(b,c,d,e,a,24); R2(a,b,c,d,e,25); R2(e,a,b,c,d,26); R2(d,e,a,b,c,27);
    R2(c,d,e,a,b,28); R2(b,c,d,e,a,29); R2(a,b,c,d,e,30); R2(e,a,b,c,d,31);
    R2(d,e,a,b,c,32); R2(c,d,e,a,b,33); R2(b,c,d,e,a,34); R2(a,b,c,d,e,35);
    R2(e,a,b,c,d,36); R2(d,e,a,b,c,37); R2(c,d,e,a,b,38); R2(b,c,d,e,a,39);
    R3(a,b,c,d,e,40); R3(e,a,b,c,d,41); R3(d,e,a,b,c,42); R3(c,d,e,a,b,43);
    R3(b,c,d,e,a,44); R3(a,b,c,d,e,45); R3(e,a,b,c,d,46); R3(d,e,a,b,c,47);
    R3(c,d,e,a,b,48); R3(b,c,d,e,a,49); R3(a,b,c,d,e,50); R3(e,a,b,c,d,51);
    R3(d,e,a,b,c,52); R3(c,d,e,a,b,53); R3(b,c,d,e,a,54); R3(a,b,c,d,e,55);
    R3(e,a,b,c,d,56); R3(d,e,a,b,c,57); R3(c,d,e,a,b,58); R3(b,c,d,e,a,59);
    R4(a,b,c,d,e,60); R4(e,a,b,c,d,61); R4(d,e,a,b,c,62); R4(c,d,e,a,b,63);
    R4(b,c,d,e,a,64); R4(a,b,c,d,e,65); R4(e,a,b,c,d,66); R4(d,e,a,b,c,67);
    R4(c,d,e,a,b,68); R4(b,c,d,e,a,69); R4(a,b,c,d,e,70); R4(e,a,b,c,d,71);
    R4(d,e,a,b,c,72); R4(c,d,e,a,b,73); R4(b,c,d,e,a,74); R4(a,b,c,d,e,75);
    R4(e,a,b,c,d,76); R4(d,e,a,b,c,77); R4(c,d,e,a,b,78); R4(b,c,d,e,a,79);
    /* Add the working vars back into context.state[] */
    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
    state[4] += e;
    /* Wipe variables */
    a = b = c = d = e = 0;
}

/*
 * SHA1Init - Initialize new context
 */
void
#if USE_ANSI_C
SHA1Init(SHA1_CTX* context)
#else
SHA1Init(context)
    SHA1_CTX* context;
#endif
{
    /* SHA1 initialization constants */
    context->state[0] = 0x67452301;
    context->state[1] = 0xEFCDAB89;
    context->state[2] = 0x98BADCFE;
    context->state[3] = 0x10325476;
    context->state[4] = 0xC3D2E1F0;
    context->count[0] = context->count[1] = 0;
}


/*
 * Run your data through this.
 */
void
#if USE_ANSI_C
SHA1Update(SHA1_CTX* context, unsigned char* data, unsigned int len)
#else
SHA1Update(context, data, len)
    SHA1_CTX* context;
    unsigned char* data;
    unsigned int len;
#endif
{
    unsigned int i, j;

    j = (context->count[0] >> 3) & 63;
    if ((context->count[0] += len << 3) < (len << 3)) context->count[1]++;
    context->count[1] += (len >> 29);
    if ((j + len) > 63) {
	memcpy(&context->buffer[j], data, (i = 64-j));
	SHA1Transform(context->state, context->buffer);
	for ( ; i + 63 < len; i += 64) {
	    SHA1Transform(context->state, &data[i]);
	}
	j = 0;
    }
    else i = 0;
    memcpy(&context->buffer[j], &data[i], len - i);
}


/*
 * Add padding and return the message digest.
 */
void
#if USE_ANSI_C
SHA1Final(unsigned char digest[20], SHA1_CTX* context)
#else
SHA1Final(digest, context)
    unsigned char digest[20];
    SHA1_CTX* context;
#endif
{
    unsigned int32 i, j;
    unsigned char finalcount[8];

    for (i = 0; i < 8; i++) {
	finalcount[i] = (unsigned char)((context->count[(i >= 4 ? 0 : 1)]
	 >> ((3-(i & 3)) * 8) ) & 255);  /* Endian independent */
    }
    SHA1Update(context, (unsigned char *)"\200", 1);
    while ((context->count[0] & 504) != 448) {
	SHA1Update(context, (unsigned char *)"\0", 1);
    }
    SHA1Update(context, finalcount, 8);  /* Should cause a SHA1Transform() */
    for (i = 0; i < 20; i++) {
	digest[i] = (unsigned char)
	 ((context->state[i>>2] >> ((3-(i & 3)) * 8) ) & 255);
    }
    /* Wipe variables */
    i = j = 0;
    memset(context->buffer, 0, 64);
    memset(context->state, 0, 20);
    memset(context->count, 0, 8);
    memset(&finalcount, 0, 8);
#ifdef SHA1HANDSOFF  /* make SHA1Transform overwrite it's own static vars */
    SHA1Transform(context->state, context->buffer);
#endif
}

#if 0
/*************************************************************/

/*
 * SHA1 test program
 */

int main(int argc, char** argv)
{
    int i, j;
    SHA1_CTX context;
    unsigned char digest[20], buffer[16384];
    FILE* file;

    if (argc > 2) {
	puts("Public domain SHA-1 implementation - by Steve Reid <steve@edmweb.com>");
	puts("Produces the SHA-1 hash of a file, or stdin if no file is specified.");
	exit(0);
    }
    if (argc < 2) {
	file = stdin;
    }
    else {
	if (!(file = fopen(argv[1], "rb"))) {
	    fputs("Unable to open file.", stderr);
	    exit(-1);
	}
    }
    SHA1Init(&context);
    while (!feof(file)) {  /* note: what if ferror(file) */
	i = fread(buffer, 1, 16384, file);
	SHA1Update(&context, buffer, i);
    }
    SHA1Final(digest, &context);
    fclose(file);
    for (i = 0; i < 5; i++) {
	for (j = 0; j < 4; j++) {
	    printf("%02X", digest[i*4+j]);
	}
	putchar(' ');
    }
    putchar('\n');
    exit(0);
}
#endif

%}
! !

!SHA1Stream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999-2013 by eXept Software AG
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
    Generate a SHA-1 hash value as defined in
    NIST, FIPS PUB 180-1: Secure Hash Standard, April 1995.
    This may be used as checksum or for generating cryptographic signatures.

    Notice (2005):
        Be aware that SHA-1 is considered broken and may not be appropriate in some applications.
        Especially it should no longer be used for security stuff.

    performance: roughly
          150 Mb/s on a 2007 MAC Powerbook (2.6Ghz I7-Duo)
          120400 Kb/s on a 2.5Ghz 64X2 Athlon 4800+ (64bit)
           47400 Kb/s on a 2Ghz Duo (old measure)
            9580 Kb/s on a 400Mhz PIII
            3970 Kb/s on a 300Mhz Sparc

    [author:]
        Stefan Vogel

    [see also:]
        MD5Stream
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
    Test Vectors (from FIPS PUB 180-1); results are:

                                                                [exBegin]
    |hashStream|

    hashStream := SHA1Stream new.
    hashStream nextPut:'abc'.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
    hashStream nextPut:'dbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
                                                                [exEnd]

                                                                [exBegin]
    |hashValue|

    hashValue := SHA1Stream hashValueOf:'hello world'.
    self assert:(hashValue hexPrintString = '2AAE6C35C94FCFB415DBE95F408B9CE91EE846ED')
                                                                [exEnd]
                                                                
                                                                [exBegin]
    |hashValue|

    hashValue := SHA1Stream hashValueOf:'abc'.
    hashValue printOn:Transcript base:16. Transcript cr.
                                                                [exEnd]

                                                                [exBegin]
    |hashStream|

    hashStream := SHA1Stream new.
    hashStream nextPut:'abc' asByteArray.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
    hashStream nextPut:'dbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq' asByteArray.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.

                                                                [exEnd]

                                                                [exBegin]
    |hashStream|

    hashStream := SHA1Stream new.
    1000000 timesRepeat:[ hashStream nextPut:$a ].
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
                                                                [exEnd]

                                                                [exBegin]
    |hashStream|

    hashStream := SHA1Stream new.
    hashStream nextPut:'a'.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
                                                                [exEnd]

                                                                [exBegin]
    |hashStream|

    hashStream := SHA1Stream new.
    hashStream nextPut:$a.
    hashStream hashValue printOn:Transcript base:16. Transcript cr.
                                                                [exEnd]

  timing throughput:
                                                                [exBegin]
    |hashStream n t|

    hashStream := SHA1Stream new.
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
!

performance
"
    CPU                             cc          algo        kb/sec

    MAC (2010 macbook; 2.7Ghz I7)   clang -O2   slow        128495
							    131967



  timing throughput:
								[exBegin]
    |hashStream n t|

    hashStream := SHA1Stream new.
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

!SHA1Stream class methodsFor:'initialization'!

initialize
    |ctxSize|

%{
    ctxSize = __MKSMALLINT(sizeof(SHA1_CTX));
%}.
    ContextSize := ctxSize.
    HashSize := 20.

    "
	self initialize
    "
! !

!SHA1Stream class methodsFor:'queries'!

hashBlockSize
    "return the block size used internally by the compression function"

    ^ 64

    "Created: / 18.3.1999 / 08:37:10 / stefan"
!

hashSize
    "return the size of the hashvalue returned by instances of this class"

    ^ HashSize

    "Modified: / 18.3.1999 / 07:54:22 / stefan"
! !

!SHA1Stream methodsFor:'initialization'!

initialize

    hashContext := ByteArray new:ContextSize.
    self reset

    "Created: / 17.3.1999 / 16:11:37 / stefan"
    "Modified: / 18.3.1999 / 07:56:46 / stefan"
! !

!SHA1Stream methodsFor:'positioning'!

reset
   "reset the stream in order to compute a new hash value"

%{
   if (__isByteArray(__INST(hashContext)) &&
       __byteArraySize(__INST(hashContext)) == sizeof(SHA1_CTX)
   ) {
	SHA1_CTX *ctx = (SHA1_CTX *)__ByteArrayInstPtr(__INST(hashContext))->ba_element;

	SHA1Init(ctx);
	RETURN(self);
   }
%}.
   ^ self primitiveFailed

    "Created: / 18-03-1999 / 07:59:02 / stefan"
    "Modified: / 12-01-2012 / 12:21:23 / cg"
! !

!SHA1Stream methodsFor:'queries'!

hashValue
    "Get the value hashed so far.
     The context is kept, so that more objects may be hashed after
     retrieving a hash value"


    |digest|

    digest := ByteArray new:HashSize.

%{
    OBJ hcon;

    hcon = __INST(hashContext);
    if (__isByteArray(hcon) &&
	__byteArraySize(hcon) == sizeof(SHA1_CTX) &&
	__isByteArray(digest) &&
	__byteArraySize(digest) == 20
    ) {
	SHA1_CTX *ctx = (SHA1_CTX *)(__ByteArrayInstPtr(hcon)->ba_element);
	SHA1_CTX copyContext;

	memcpy(&copyContext, ctx, sizeof(SHA1_CTX));
	SHA1Final(__ByteArrayInstPtr(digest)->ba_element, &copyContext);
	RETURN(digest);
    }
%}.

    ^ self primitiveFailed

    "Created: / 17.3.1999 / 16:13:12 / stefan"
    "Modified: / 18.3.1999 / 08:00:54 / stefan"
! !

!SHA1Stream methodsFor:'writing'!

nextPutByte:anInteger
    "update the hash value with anInteger <= 255."

%{
   if (__isSmallInteger(anInteger) && __intVal(anInteger) <= 255
       && __isByteArray(__INST(hashContext))
       && __byteArraySize(__INST(hashContext)) == sizeof(SHA1_CTX)
   ) {
        SHA1_CTX *ctx = (SHA1_CTX *)__ByteArrayInstPtr(__INST(hashContext))->ba_element;
        unsigned char value = __intVal(anInteger);

        SHA1Update(ctx, &value, 1);
        RETURN(self);
    }
bad: ;
%}.

    ^ self primitiveFailed
!

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
       && __byteArraySize(__INST(hashContext)) == sizeof(SHA1_CTX)
       && __bothSmallInteger(count, start)
   ) {
	SHA1_CTX *ctx = (SHA1_CTX *)__ByteArrayInstPtr(__INST(hashContext))->ba_element;

	len = __intVal(count);
	offs = __intVal(start) - 1;

	if (__isExternalBytesLike(anObject)) {
	    OBJ sz;

	    nInstBytes = 0;
	    extPtr = (char *)__externalBytesAddress(anObject);
	    if (extPtr == NULL) goto bad;
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
	    SHA1Update(ctx, extPtr+offs, (unsigned int)len);
	    RETURN (count);
	}
    }
bad: ;
%}.

    ^ self primitiveFailed
! !

!SHA1Stream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


SHA1Stream initialize!
