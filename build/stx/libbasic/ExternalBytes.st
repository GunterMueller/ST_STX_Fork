"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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

UninterpretedBytes subclass:#ExternalBytes
	instanceVariableNames:'address* size'
	classVariableNames:'AllocatedInstances Lobby DebugMalloc TraceMalloc'
	poolDictionaries:''
	category:'System-Support'
!

!ExternalBytes primitiveDefinitions!
%{
    #include <stdlib.h>
    #include <stdio.h>
// cg: not needed
#if 0
# ifdef __osx__
#  include <sys/malloc.h>
# else
#  include <malloc.h>
# endif
#endif

    extern char *__stx_malloc(size_t);
    extern char *__stx_calloc(size_t, size_t);
    extern char *__stx_realloc(char *, size_t);
    extern void __stx_free(char *);
    extern void __stx_mallocStatistics(void);
%}
! !

!ExternalBytes primitiveFunctions!
%{

struct mallocList {
	char *chunk;
	size_t size;
	struct mallocList *next;
};
static struct mallocList *mallocList = (struct mallocList *)0;
static INT mallocCount = 0;

static void
removeFromMallocList(char *ptr)
{
    struct mallocList *this, *prev, *next;
    int found = 0;

    if (@global(DebugMalloc) != true) return;

    if (ptr) {
	found = 0;
	for (this=mallocList, prev=0; this; this=next) {
	    next = this->next;
	    if (this->chunk == ptr) {
		if (prev) {
		    prev->next = next;
		} else {
		    mallocList = next;
		}
		free(this);
		found++;
		mallocCount--;
	    } else {
		prev = this;
	    }
	}
	if (! found) {
	    console_printf("ExternalBytes [warning]: **** free: alien %"_lx_" (allocated somewhere else ?))\n", (INT)ptr);
	}
    }
}

static void
addToMallocList(char *ptr, size_t nBytes)
{
    struct mallocList *e, *this;
    void *malloc();
    int found;

    if (@global(DebugMalloc) != true) return;

    if (ptr) {
	found = 0;
	for (this=mallocList; this; this=this->next) {
	    if (this->chunk == ptr) {
		console_printf("ExternalBytes [warning]: **** %016"_lx_" already allocated (freed somewhere else ?)\n", (INT)ptr);
		found++;
	    }
	}
	if (! found) {
	    e = (struct mallocList *) malloc(sizeof(struct mallocList));
	    e->next = mallocList;
	    e->chunk = ptr;
	    e->size = nBytes;
	    mallocList = e;
	    mallocCount++;
	}
    }
}

char *
__stx_malloc(size_t nBytes) {
	char *ptr = malloc(nBytes);

	if (@global(TraceMalloc) == true) {
	    console_printf("ExternalBytes [info]: allocated %d bytes at: %016"_lx_"\n", nBytes, (INT)ptr);
	}
	addToMallocList(ptr, nBytes);

	return ptr;
}

char *
__stx_calloc(size_t n, size_t size) {
	char *ptr = __stx_malloc(n * size);
	if (ptr != 0) {
	    bzero(ptr, (n * size));
	}
	return ptr;
}

char *
__stx_realloc(char *ptr, size_t nBytes)
{
	char *newPtr;

	removeFromMallocList(ptr);
	newPtr = realloc(ptr, nBytes);
	addToMallocList(newPtr, nBytes);

	if (@global(TraceMalloc) == true) {
	    console_printf("ExternalBytes [info]: realloc %d bytes for %"_lx_" at: %"_lx_"\n", nBytes, (INT)ptr, (INT)newPtr);
	}
	return newPtr;
}

void
__stx_free(char *ptr)
{
	if (@global(TraceMalloc) == true) {
	    console_printf("ExternalBytes: free bytes at: %"_lx_"\n", (INT)ptr);
	}
	removeFromMallocList(ptr);

	free(ptr);
}

void
__stx_mallocStatistics() {
	struct mallocList *this;
	int amount = 0;
	int n = 0;

	for (this=mallocList; this; this=this->next) {
	    n++;
	    amount += this->size;
	}
	console_printf("ExternalBytes [info]: allocated %d blocks with %d bytes overall\n", n, amount);
}

%}
! !

!ExternalBytes class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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
    This class provides access to any memory in the system. Its main purpose
    is to provide a baseclass for objects referencing structured external data.
    Normally, instances are created by primitive code which wants to pass C-data
    to Smalltalk AND grants smalltalk access to individual bytes afterwards.
    Primitives which do not want to grant this access should return instances of
    ExternalAddress. See more info there. Also, have a look at ExternalFunction
    which is another similar class, but specialized to represent callable C-functions.

    Since the memory address of an instance stays fixed (once allocated),
    it can also be used to share data with external C-parts
    (which are not prepared for objects to change their address).

    Use with great care - access is not always checked for out-of-bounds
    or valid addresses.

    Since the data is allocated outside the garbage collected smalltalk space,
    its address stays fix. Thus, it can be passed to external C-functions without
    any danger. However, you have to take care for freeing the memory yourself.

    To help in avoiding memory bugs, instances created with #new: are
    registered in a local classvar and deregistered when the underlying memory
    is explicitely freed. Since a life reference (from that classvar) exists,
    the garbage collector will never find these to be reclaimable, and the
    underlying memory stays allocated (at a fix address) forever.
    To release the memory, either #free it or #unprotect it.
    The first will immediately release the memory, while the second will delay
    freeing until the next garbage collect occurs.

    If you need memory which is automatically freed, create
    the instance via #unprotectedNew: right away; the underlying malloced-memory
    will be released as soon as no smalltalk reference to the ExtBytes object
    exists any more (however, you have to know for sure, that no C-references
    exist to this memory).

    To release all memory call #releaseAllMemory which simply sets the
    AllocatedInstances class variable to nil (thus releasing those refs).

    Example (automatic freeing as soon as ref to buffer is gone):
	|buffer|

	buffer := ExternalBytes unprotectedNew:100.
	...


    Example (manual freeing - never freed, if ref to buffer is gone):
	|buffer|

	buffer := ExternalBytes new:100.
	...
	buffer free


    Example (delayed automatic freeing as soon as ref to buffer is gone):
	|buffer|

	buffer := ExternalBytes new:100.
	...
	buffer unregister

    This class only supports unstructured external data
    - see the companion class ExternalStructure for more.

    Notice: support for external data is still being developed -
	    a parser for C structure syntax and typedefs is on the way,
	    making shared data with C programs much easier in the future.

    Also notice, that this class may not be available or behave different
    in other smalltalk systems, making code using it very unportable.
    It is provided for C interfacing only.

    Finally note, that ST/X's memory system is much faster than malloc/free
    in the normal case - especially for short term temporary objects,
    automatically reclaimed object memory is about 5-10 times faster than
    malloc/free.
    Things may be different for huge byte-valued objects, which are to be
    reclaimed by the oldspace colletor.
    Anyway, for portability, we strongly warn from using this as a substitute
    for byteArrays; it is meant for shared data with external C-functions ONLY.

    Debugging:
	since all manual memory systems are subject of obscure errors,
	you may want to turn malloc-tracing on; this traces all allocations/frees
	done here. To do this, evaluate: 'ExternalBytes mallocTrace:true'.

	In addition, you may turn on full debugging (with 'ExternalBytes mallocDebug:true');
	if turned on, all malloc/realloc requests are remembered and later free / realloc
	requests validated against this list (i.e. to detect freeing unallocated chunks).

	To benefit from this in C-code, we recommend you use __stx_malloc() / __stx_free()
	instead of malloc() / free(). To do so, redefine them in a header file (or cc comand line)
	and recompile your external c-libraries with this.

	I used this here to find memory leaks in the Xt libraries (there are still some in
	the HTML widget ...). If mallocDebug is on, #dumpMallocChunks will print out what is
	leftOver. This may help to find trouble spots in your C-code.

    [author:]
	Claus Gittinger

    [see also:]
	ExternalAddress ExternalFunction
	ByteArray
	( how to write primitive code :html: programming/primitive.html )
"
!

examples
"
    These examples below are not directly executable;
    some require primitive code to be compiled, or are simply given as sceletton.
    Notice, that in C, indexing is 0-based, while in Smalltalk, indices start
    at 1.

    allocating memory in ST, passing it to C:

      in smalltalk:
	...
	bytes := ExternalBytes new:100.
	...

      in C (assuming that the bytes-object has been passed):

	...
	char *bytePtr;

	bytePtr = (char *)(__externalBytesAddress(bytes));
	if (bytePtr) {
	    ... do something with bytes at bytePtr ...
	}

      freeing (in ST):

	...
	bytes free.
	...

    allocating memory in C, passing it to ST:

      in C:
	...
	char *bytePtr;

	bytePtr = (char *)(malloc(100));
	...
	RETURN (__MKEXTERNALBYTES(bytePtr));

      in Smalltalk (extracting bytes, integers or strings):

	byteVal := bytes byteAt:1.
	...
	intVal := bytes doubleWordAt:1 MSB:true.
	...
	string := bytes stringAt:20.
	...


    |data bytes2|

    data := #[0 1 2 3 4 5 6 7 8 9 9 8 7 6 5 4 3 2 1 0] copy.
    bytes2 := ExternalBytes new:30.
    bytes2 replaceBytesFrom:1 to:20 with:data startingAt:1.
    data replaceBytesFrom:2 to:20 with:bytes2 startingAt:1.
    bytes2

    |data bytes1 bytes2|

    data := #[0 1 2 3 4 5 6 7 8 9 9 8 7 6 5 4 3 2 1 0].
    bytes1 := ExternalBytes new:30.
    bytes2 := ExternalBytes new:30.
    bytes1 replaceBytesFrom:1 to:20 with:data startingAt:1.
    bytes2 atAllPut:99.
    bytes2 replaceBytesFrom:2 to:21 with:bytes1 startingAt:1.
    bytes2 asByteArray

    |data1 bytes1 data2|

    data1 := #[0 1 2 3 4 5 6 7 8 9 9 8 7 6 5 4 3 2 1 0].
    bytes1 := ExternalBytes new:30.
    bytes1 replaceBytesFrom:1 to:20 with:data1 startingAt:1.

    data2 := ByteArray new:30 withAll:99.
    data2 replaceBytesFrom:2 to:21 with:bytes1 startingAt:1.
    data2

"
! !

!ExternalBytes class methodsFor:'initialization'!

initialize
    Lobby isNil ifTrue:[
	Lobby := Registry new.
    ]
! !

!ExternalBytes class methodsFor:'instance creation'!

address:anAddressInteger
    "return a new ExternalBytes object to access bytes starting at anAddressInteger.
     The memory at anAddressInteger has been allocated elsewhere.
     The size is not known, therefore byte accesses will NOT be checked for valid index.
     Use this, if you get a pointer from some external source (such as a
     C-callBack function) and you have to extract bytes from that.

     DANGER ALERT: this method allows very bad things to be done to the
		   system - use with GREAT care (better: do not use it)"

    ^ self basicNew setAddress:anAddressInteger size:nil

    "Modified (comment): / 31-03-2016 / 11:05:07 / cg"
!

address:anAddressInteger size:size
    "return a new ExternalBytes object to access bytes starting at anAddressInteger.
     The memory at anAddressInteger has been allocated elsewhere.
     The size is known, which allows byte accesses to be checked for valid index.
     Use this, if you get a pointer to a structure from some external source
     (such as a C-callBack function) and you have to extract things from that.

     DANGER ALERT: this method allows very bad things to be done to the
		   system - use with GREAT care (better: do not use it)"

    ^ self basicNew setAddress:anAddressInteger size:size

    "Modified (comment): / 31-03-2016 / 11:04:27 / cg"
!

new:numberOfBytes
    "allocate some memory usable for data;
     the memory safe from being finalized by the garbage collector.
     Return a corresponding ExternalBytes object or raise MallocFailure (if malloc fails).

     Use this, if you have to pass a block of bytes to some
     external destination (such as a C function) which does not copy the
     data, but instead keeps a reference to it. For example, many functions
     which expect strings simply keep a ref to the passed string - for those,
     an ST/X string-pointer is not the right thing to pass, since ST/X objects
     may change their address.

     DANGER ALERT: the memory is NOT automatically freed until it is either
		   MANUALLY freed (see #free) or the returned externalBytes object
		   is unprotected or the classes releaseAllMemory method is called."

    |newInst|

    newInst := self unprotectedNew:numberOfBytes.
    newInst protectFromGC.
    ^ newInst

    "
     |bytes|

     bytes := ExternalBytes new:100.
     bytes wordAt:1 put:1.
     bytes doubleWordAt:3 put:16r12345678.
     bytes inspect
    "
!

newNullTerminatedFromString:aString
    "allocate a null terminated string containing the chars of aString"

    |nChars extBytes|

    nChars := aString size.
    self assert:(aString bitsPerCharacter == 8).

    extBytes := self new:nChars+1.
    extBytes replaceBytesFrom:1 to:nChars with:aString startingAt:1.
    extBytes at:nChars+1 put:0.
    ^ extBytes
!

newNullTerminatedFromWideString:aString
    "allocate a null terminated wide string containing the U16-chars of aString"

    |nChars extBytes|

    nChars := aString size.
    self assert:(aString bitsPerCharacter <= 16).

    extBytes := self new:((nChars+1)*2).
    1 to:nChars do:[:i |
	extBytes unsignedInt16At:(i*2) put:(aString at:i) codePoint.
    ].
    extBytes unsignedInt16At:((nChars+1)*2) put:0.
    ^ extBytes

    "Modified (comment): / 31-03-2016 / 11:05:37 / cg"
!

unprotectedNew:numberOfBytes
    "allocate some memory usable for data;
     the memory is under the control of the garbage collector (i.e. the instance will
     be finalized and the malloc'd memory will be freed, if the instance goes away).
     Return a corresponding ExternalBytes object or raise MallocFailure (if malloc fails).

     DANGER ALERT: the memory block as allocated will be automatically freed
		   as soon as the reference to the returned externalBytes object
		   is gone (by the next garbage collect).
		   If the memory has been passed to a C-function which
		   remembers this pointer, bad things may happen ...."

    |newInst|

    newInst := self basicNew allocateBytes:numberOfBytes.
    newInst registerForFinalization.
    ^ newInst

    "
     |bytes|

     bytes := ExternalBytes unprotectedNew:100.
     bytes wordAt:1 put:1.
     bytes doubleWordAt:3 put:16r12345678.
     bytes inspect
    "
! !

!ExternalBytes class methodsFor:'instance release'!

releaseAllMemory
    AllocatedInstances := nil
    "
     ... the next GC will get 'em
    "
! !

!ExternalBytes class methodsFor:'malloc debug'!

dumpMallocChunks
%{  /* NOCONTEXT */
    struct mallocList *entry;

    for (entry = mallocList; entry; entry=entry->next) {
	console_printf("  %"_lx_" (%d)\n", (INT)(entry->chunk), entry->size);
    }
%}
    "
     self dumpMallocChunks
    "
!

freeAllMallocChunks
    "free all stx_malloc'd memory. Be careful, this does no validation at all;
     It simply walks through all chunks and frees them unconditionally.
     This may be helpful during debugging memory-leaks, to release memory which
     was not correctly freed by C-code. Howeve, only memory which was allocated
     by __stx_malloc() is freed here - so you better compile your primitive code with
     malloc redefined to stx_malloc.
     Also, mallocDebug has to be on to do this."

    "first free my own memory ..."

    self releaseAllMemory.
    ObjectMemory garbageCollect.
%{
    struct mallocList *entry;

    while ((entry = mallocList) != (struct mallocList *)0) {
	if (@global(TraceMalloc) == true ) {
	    console_printf("ExternalBytes [info]: **** forced free of %"_lx_" (%d)\n", (INT)entry->chunk, entry->size);
	}
	__stx_free(entry->chunk);
    }
%}
!

mallocDebug:aBoolean
    DebugMalloc := aBoolean

    "
     ExternalBytes mallocDebug:true
     ExternalBytes mallocDebug:false
    "
!

mallocStatistics
%{
    __stx_mallocStatistics();
%}
    "
     self mallocStatistics
    "
!

mallocTrace:aBoolean
    TraceMalloc := aBoolean

    "
     ExternalBytes mallocTrace:true
     ExternalBytes mallocTrace:false
    "
!

numberOfAllocatedChunks
%{  /* NOCONTEXT */
    RETURN ( __mkSmallInteger(mallocCount) );
%}
    "
     self numberOfAllocatedChunks
    "
! !

!ExternalBytes class methodsFor:'queries'!

charTypeIsSigned
    "return true, if the machine's native chars are signed"

%{  /* NOCONTEXT */
    char c;

    c = (char)128;
    RETURN ( (int)c < 0 ? true : false );
%}
    "
     ExternalBytes charTypeIsSigned
    "
!

doubleAlignment
    "return the alignement of longs in structs and unions"

%{  /* NOCONTEXT */
    struct {
	char c;
	double d;
    } dummy;
    RETURN (__mkSmallInteger( (char *)&dummy.d - (char *)&dummy.c ));
%}
    "
     ExternalBytes doubleAlignment
    "
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned."

    ^ self == ExternalBytes

    "Modified: / 11.6.1998 / 17:12:51 / cg"
!

longAlignment
    "return the alignement of longs in structs and unions"

%{  /* NOCONTEXT */
    struct {
	char c;
	long l;
    } dummy;
    RETURN (__mkSmallInteger( (char *)&dummy.l - (char *)&dummy.c ));
%}
    "
     ExternalBytes longAlignment
    "
!

sizeofDouble
    "return the number of bytes used by the machines native doubles"

%{  /* NOCONTEXT */
    RETURN (__mkSmallInteger( sizeof(double)));
%}
    "
     ExternalBytes sizeofDouble
    "
!

sizeofEnums
    "return the number of bytes used by the machine's native enums.
     Be aware, that this can be adjusted in some compilers via the __packed__ attribute;
     So better double check..."

%{  /* NOCONTEXT */
    enum foo { bla1, bla2 } foo;
    RETURN (__mkSmallInteger( sizeof(foo)));
%}
    "
     ExternalBytes sizeofEnums
    "
!

sizeofFloat
    "return the number of bytes used by the machine's native floats"

%{  /* NOCONTEXT */
    RETURN (__mkSmallInteger( sizeof(float)));
%}
    "
     ExternalBytes sizeofFloat
    "
!

sizeofInt
    "return the number of bytes used by the machine's native integer"

%{  /* NOCONTEXT */
    RETURN (__mkSmallInteger( sizeof(int)));
%}
    "
     ExternalBytes sizeofInt
    "
!

sizeofLong
    "return the number of bytes used by the machine's native longs"

%{  /* NOCONTEXT */
    RETURN (__mkSmallInteger( sizeof(long)));
%}
    "
     ExternalBytes sizeofLong
    "
!

sizeofLongDouble
    "return the number of bytes used by the machine's native longdouble.
     If the machine does not support them, return nil."

%{  /* NOCONTEXT */
#if defined(__GNUC__) || defined(__CLANG__) || defined(__win32__)
    RETURN (__mkSmallInteger( sizeof(long double)));
#endif
%}.
    ^ nil

    "
     ExternalBytes sizeofLongDouble
    "
!

sizeofLongLong
    "return the number of bytes used by the machine's native longlongs.
     If the machine does not support them, return nil."

%{  /* NOCONTEXT */
#ifdef HAS_LONGLONG
    RETURN (__mkSmallInteger( sizeof(long long)));
#endif
%}.
    ^ nil

    "
     ExternalBytes sizeofLongLong
    "
!

sizeofNativeInt
    "return the number of bytes used by the machine's SmallInteger native values"

%{  /* NOCONTEXT */
    RETURN (__mkSmallInteger( sizeof(INT)));
%}
    "
     ExternalBytes sizeofNativeInt
    "
!

sizeofPointer
    "return the number of bytes used by the machine's native pointer"

%{  /* NOCONTEXT */
    RETURN (__mkSmallInteger( sizeof(char *)));
%}
    "
     ExternalBytes sizeofPointer
    "
!

sizeofShort
    "return the number of bytes used by the machine's native short"

%{  /* NOCONTEXT */
    RETURN (__mkSmallInteger( sizeof(short)));
%}
    "
     ExternalBytes sizeofShort
    "
! !

!ExternalBytes methodsFor:'accessing'!

address
    "return the start address as an integer"

%{  /* NOCONTEXT */

    if (__INST(address_) != nil) {
	unsigned INT addr;

	addr = (unsigned INT)__INST(address_);
	RETURN ( __MKUINT(addr));
    }
%}.
    ^ nil
!

basicAt:index
    "return the byte at index, anInteger;
     Indices are 1-based, therefore
     this is the byte at (address + index - 1)"

%{  /* NOCONTEXT */

    unsigned char *cp = (unsigned char *)(__INST(address_));
    INT indx;
    OBJ sz;

    if (cp && __isSmallInteger(index)) {
	indx = __intVal(index);
	if (indx > 0) {
	    if (((sz = __INST(size)) == nil)
	     || (__intVal(sz) >= indx)) {
		cp = cp + indx - 1;
		RETURN ( __mkSmallInteger((*cp)) );
	    }
	}
    }
%}.
    (size notNil and:[self address notNil]) ifTrue:[
	^ self subscriptBoundsError:index
    ].
    "
     invalid index or unallocated
    "
    self primitiveFailed
!

basicAt:index put:value
    "set the byte at index, anInteger to value which must be 0..255.
     Returns value (sigh).
     Indices are 1-based, therefore
     this is the byte at (address + index - 1)"

%{  /* NOCONTEXT */

    unsigned char *cp = (unsigned char *)(__INST(address_));
    int val;
    INT indx;
    OBJ sz;

    if (__isSmallInteger(value)) {
	val = __smallIntegerVal(value);
    } else if (__isCharacter(value)) {
	val = __smallIntegerVal(__characterVal(value));
    } else
	goto badArg;

    if (cp && __isSmallInteger(index)) {
	indx = __intVal(index);
	if (indx > 0) {
	    if (((sz = __INST(size)) == nil)
	     || (__intVal(sz) >= indx)) {
		if ((val & ~0xFF) == 0) /* i.e. (val >= 0) && (val <= 255) */  {
		    cp[indx-1] = val;
		    RETURN ( value );
		}
	    }
	}
    }

badArg: ;
%}.

    (size notNil and:[self address notNil]) ifTrue:[
	(index between:1 and:size) ifTrue:[
	    ^ ElementOutOfBoundsSignal raise
	].
	^ self subscriptBoundsError:index
    ].
    "
     invalid index, invalid value or unallocated
    "
    self primitiveFailed

    "Modified: 19.4.1996 / 11:15:05 / cg"
!

byteAt:index
    "return the unsigned byte at index, anInteger.
     Indices are 1-based, therefore
     this is the byte at (address + index - 1)"

    ^ self basicAt:index
!

byteAt:index put:aByteValuedInteger
    "set the byte at index.
     Indices are 1-based, therefore
     this is the byte at (address + index - 1)"

    ^ self basicAt:index put:aByteValuedInteger
!

copyCStringFromHeap
    "fetch a 0-terminated string from my pointed-to address"

    |idx byte s|

    idx := 1.
    s := WriteStream on:''.
    [(byte := self at:idx) ~~ 0] whileTrue:[
        s nextPut:(Character value:byte).
        idx := idx + 1.
    ].
    ^ s contents
!

copyUnicodeStringFromHeap
    "fetch a 0-terminated wide-string from my pointed-to address"

    |idx word s|

    idx := 1.
    s := WriteStream on:Unicode16String new.
    [(word := self unsignedInt16At:idx) ~~ 0] whileTrue:[
	s nextPut:(Character value:word).
	idx := idx + 2.
    ].
    ^ s contents
!

instVarAt:index
    "redefined to suppress direct access to my address, which is a non-object"

    index == 1 ifTrue:[^ self address].
    ^ super instVarAt:index
! !

!ExternalBytes methodsFor:'converting'!

asExternalAddress
    "return the start address as an external address"

%{  /* NOCONTEXT */

    RETURN(__MKEXTERNALADDRESS(__INST(address_)));
%}.
    self primitiveFailed
!

asExternalBytes

    ^ self
!

asString
    "speed up string conversions"

    |size|

    self class == ExternalBytes ifTrue:[
        size := self size.
        ^ (String uninitializedNew:size) replaceBytesFrom:1 to:size with:self startingAt:1.
    ].
    ^ super asString.

    "
      #[16r41 16r42 16r43] asExternalBytes asString
    "
! !

!ExternalBytes methodsFor:'filling & replacing'!

replaceBytesFrom:start to:stop with:aCollection startingAt:repStart
    "replace elements from another collection, which must be a ByteArray-
     like collection.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

%{  /* NOCONTEXT */

    unsigned INT nIndex, repNIndex;
    int startIndex, stopIndex;
    REGISTER unsigned char *src;
    REGISTER int repStartIndex;
    int repStopIndex, count;
    REGISTER unsigned char *dst;
    OBJ cls;

    if ((__isBytes(aCollection) || __isWords(aCollection) || __isExternalBytesLike(aCollection))
     && __bothSmallInteger(start, stop)
     && __isSmallInteger(repStart)) {
	startIndex = __intVal(start) - 1;
	if (startIndex >= 0) {
	    dst = (unsigned char *)__INST(address_) + startIndex;
	    nIndex = __smallIntegerVal(__INST(size));

	    stopIndex = __intVal(stop) - 1;
	    count = stopIndex - startIndex + 1;
	    if (count == 0) {
		RETURN ( self );
	    }

	    if ((count > 0) && (stopIndex < nIndex)) {
		repStartIndex = __intVal(repStart) - 1;
		if (repStartIndex >= 0) {
		    if (__isExternalBytesLike(aCollection)) {
			OBJ sz;

			src = __externalBytesVal(aCollection);
			if (src == 0) goto fallBack;

			sz = __externalBytesSize(aCollection);
			if (__isSmallInteger(sz)) {
			    repNIndex = __smallIntegerVal(sz);
			} else {
			    repNIndex = -1; /* unknown */
			}
			src = src + repStartIndex;
		    } else {
			repNIndex = __qSize(aCollection) - OHDR_SIZE;
			src = __byteArrayVal(aCollection) + repStartIndex;
			if ((cls = __qClass(aCollection)) != @global(ByteArray)) {
			    int nInst;

			    nInst = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
			    src += nInst;
			    repNIndex -= nInst;
			}
		    }

		    repStopIndex = repStartIndex + (stopIndex - startIndex);
		    if (repStopIndex < repNIndex) {
			if (aCollection == self) {
			    /* take care of overlapping copy */
			    if (src < dst) {
				/* must do a reverse copy */
				src += count;
				dst += count;
				while (count-- > 0) {
				    *--dst = *--src;
				}
				RETURN ( self );
			    }
			}

#ifdef memcpy4
			if (((unsigned INT)src & 3) == ((unsigned INT)dst & 3)) {
			    int nW;

			    /* copy unaligned part */
			    while (count && ((unsigned INT)src & 3)) {
				*dst++ = *src++;
				count--;
			    }

			    if (count > 0) {
				/* copy aligned part */
				nW = count >> 2;
				memcpy4(dst, src, nW);
				if ((count = count & 3) != 0) {
				    /* copy any remaining part */
				    src += (nW<<2);
				    dst += (nW<<2);
				    while (count--) {
					*dst++ = *src++;
				    }
				}
			    }
			    RETURN ( self );
			}
#else
# if __POINTER_SIZE__ == 8
			if (((unsigned INT)src & 7) == ((unsigned INT)dst & 7)) {
			    /* copy unaligned part */
			    while (count && ((unsigned INT)src & 7)) {
				*dst++ = *src++;
				count--;
			    }

			    /* copy aligned part */
			    while (count >= 8) {
				((unsigned INT *)dst)[0] = ((unsigned INT *)src)[0];
				dst += 8;
				src += 8;
				count -= 8;
			    }
			    while (count--) {
				*dst++ = *src++;
			    }
			    RETURN ( self );
			}
# endif /* 64bit */
#endif /* memcpy4 */

#ifdef FAST_MEMCPY
			memcpy(dst, src, count);
#else
# ifdef __UNROLL_LOOPS__
			while (count >= 8) {
			    dst[0] = src[0]; dst[1] = src[1];
			    dst[2] = src[2]; dst[3] = src[3];
			    dst[4] = src[4]; dst[5] = src[5];
			    dst[6] = src[6]; dst[7] = src[7];
			    dst += 8; src += 8;
			    count -= 8;
			}
# endif /* __UNROLL_LOOPS__ */
			while (count-- > 0) {
			    *dst++ = *src++;
			}
#endif
			RETURN ( self );
		    }
		}
	    }
	}
    }
fallBack: ;
%}.
    "
     fall back for the error report if any index is invalid
    "
    ^ super replaceBytesFrom:start to:stop with:aCollection startingAt:repStart

    "
     ((ExternalBytes unprotectedNew:16)
	    replaceBytesFrom:1 to:8
	    with:#[10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160]
	    startingAt:1) copy

     (ExternalBytes unprotectedNew:16)
	    replaceBytesFrom:3 to:10
	    with:#[10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160]
	    startingAt:4

     (ExternalBytes unprotectedNew:16)
	    replaceBytesFrom:3 to:4
	    with:#[10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160]
	    startingAt:1

     (ExternalBytes unprotectedNew:16)
	    replaceBytesFrom:0 to:9
	    with:#[10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160]
	    startingAt:1

     (ExternalBytes unprotectedNew:16)
	    replaceBytesFrom:1 to:10
	    with:#[10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160]
	    startingAt:0
    "
!

replaceNullTerminatedFromString:aString
    "replace elements from aString, and add a 0-byte at the end"

    |nChars|

    nChars := aString size.
    self replaceBytesFrom:1 to:nChars with:aString startingAt:1.
    self at:nChars+1 put:0.
! !

!ExternalBytes methodsFor:'finalization'!

executor
    "redefined to return a lightweight copy
     - all we need is the memory handle and the size."

%{ /* NOCONTEXT */

    OBJ theCopy, cls;

    __PROTECT__(self);
    theCopy = __MKEXTERNALBYTES_N(__INST(address_), __smallIntegerVal(__INST(size)));
    __UNPROTECT__(self);
    __InstPtr(theCopy)->o_class = cls = __InstPtr(self)->o_class;
    __STORE(theCopy, cls);
    RETURN (theCopy);
%}

    "
      (ExternalBytes unprotectedNew:10) executor
    "
!

finalizationLobby
    "answer the registry used for finalization.
     ExternalBytes have their own Registry"

    ^ Lobby
!

finalize
    "some ExternalBytes object was finalized;
     free the associated heap memory with it"

%{  /* NOCONTEXT */
    char *mem = (char *)__INST(address_);
    if (mem && (OBJ)mem != nil) {
	__stx_free(mem);
    }
    __INST(address_) = __INST(size) = nil;
%}
! !

!ExternalBytes methodsFor:'freeing'!

free
    "free a previously allocated piece of memory - be very careful, there
     are no checks done here. All dangers you usually have with malloc/free
     are present here ..."

    "at least, we check for double freeing the same chunk"
    self address isNil ifTrue:[
	self error:'freeing memory twice'.
	^ self
    ].
    Lobby unregister:self.
    self finalize.  "/ does what we need here ..
    self unprotectFromGC
!

register
    "register the receiver to be automatically finalized by the GC"

    Lobby register:self.
! !

!ExternalBytes methodsFor:'pointer arithmetic'!

referenceToBytesFrom:start to:stop
   "answer a new ExternalBytes referencing a range within the receiver.
    BE CAREFUL: after the receiver has been freed, the new ExternalBytes
    contents is undefined"

%{ /* NOCONTEXT */

    char *addr;
    int size;
    int __start, __stop;

    if (__bothSmallInteger(start, stop) && __INST(address_) != nil) {
	__start = __smallIntegerVal(start);
	__stop = __smallIntegerVal(stop);
	if (__start > 0 && __start <= __stop && __stop <= __smallIntegerVal(__INST(size))) {
	    addr = (char *)(__INST(address_)) + (__start - 1);
	    size = __stop - __start + 1;
	    RETURN( __MKEXTERNALBYTES_N(addr, size) );
	}
    }
%}.
   ^ self primitiveFailed
! !

!ExternalBytes methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "return a printed representation of the receiver for displaying"

    |addr|

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
	^ super displayOn:aGCOrStream
    ].

    aGCOrStream nextPutAll:self className.
    addr := self address.
    addr isNil ifTrue:[
	aGCOrStream nextPutAll:'[free]'.
    ] ifFalse:[
	size notNil ifTrue:[
	    aGCOrStream nextPutAll:'[sz:'.
	    size printOn:aGCOrStream.
	    aGCOrStream space.
	] ifFalse:[
	    aGCOrStream nextPut:$[.
	].
	aGCOrStream nextPutAll:'@'.
	addr printOn:aGCOrStream base:16.
	aGCOrStream nextPut:$].
    ].

    "
	self new printString
	(self new:5) displayString
    "


    "Modified: / 24.2.2000 / 19:02:19 / cg"
! !

!ExternalBytes methodsFor:'private-accessing'!

invalidateReference
    "clear the start address and size"

%{  /* NOCONTEXT */
    __INST(address_) = nil;
    __INST(size) = nil;
%}
!

setAddress:aNumber size:sz
    "set the start address and size"

%{  /* NOCONTEXT */
    if (__INST(address_) == nil) {
	if (aNumber == nil) {
	    __INST(address_) = nil;
	} else {
	    if (__isSmallInteger(aNumber)) {
		__INST(address_) = (OBJ) __intVal(aNumber);
	    } else if(__isInteger(aNumber)) {
		__INST(address_) = (OBJ) __unsignedLongIntVal(aNumber);
	    } else if(__isExternalAddress(aNumber)) {
		__INST(address_) = __externalAddressVal(aNumber);
	    }
	}
	__INST(size) = sz;
	RETURN (self);
    }
%}.
    ^ self error:'cannot change address'
!

setSize:sz
    "set the size - warning: dangerous if wrong"

    size := sz
! !

!ExternalBytes methodsFor:'private-allocation'!

allocateBytes:numberOfBytes
    "allocate (malloc) numberOfBytes; if doClear is true, the allocated memory is cleared.
     Fail if already allocated.
     Raise MallocFailure if malloc fails to allocate enough memory"

    ^ self allocateBytes:numberOfBytes clear:true
!

allocateBytes:numberOfBytes clear:doClear
    "allocate (malloc) numberOfBytes; if doClear is true, the allocated memory is cleared.
     Fail if already allocated.
     Raise MallocFailure if malloc fails to allocate enough memory"

    |mallocFailure|

%{
    /*
     * Fail if already allocated
     */
    if (__INST(address_) == nil && __isSmallInteger(numberOfBytes)) {
	INT nBytes = __smallIntegerVal(numberOfBytes);
	if (nBytes > 0) {
	    char *space = __stx_malloc(nBytes);
	    if (space) {
		if (doClear == true) {
		    bzero(space, nBytes);
		}
		__INST(address_) = (OBJ)space;
		__INST(size) = numberOfBytes;
		RETURN(self);
	    } else {
		mallocFailure = true;
	    }
	}
    }
%}.
    mallocFailure == true ifTrue:[
	^ MallocFailure raiseRequestWith:numberOfBytes.
    ] ifFalse:[
	self primitiveFailed.
    ].
! !

!ExternalBytes methodsFor:'queries'!

basicSize
    "we do not know how many bytes are valid"

    size isNil ifTrue:[^ 0].
    ^ size
!

containsNon7BitAscii
    "return true, if any byte in the receiver has the 7th bit on.
     This my look as a too specific operation to be put here,
     put it is very helpful for UTF8 string reading (Java class reader),
     to quickly determine, if UTF8 decoding is needed or not.
     As most strings in a class file are in fact only containing 7bit ascii,
     this should speedup class file reading considerably"

%{  /* NOCONTEXT */
    unsigned char *cp = (unsigned char *)(__INST(address_));
    unsigned int size = __intVal(__INST(size));
    unsigned char *endP;

    if (cp == NULL || size == 0) {
	RETURN(false);
    }

    endP = cp + size;
#if __POINTER_SIZE__ == 8
    while (cp+8 < endP) {
	if ( ((unsigned INT *)cp)[0] & 0x8080808080808080) RETURN( true );
	cp += 8;
    }
#endif
    while (cp+4 < endP) {
	if ( ((unsigned int *)cp)[0] & 0x80808080) RETURN( true );
	cp += 4;
    }
    while (cp < endP) {
	if (*cp++ & 0x80) RETURN( true );
    }
    RETURN ( false );
%}
.
    ^ self contains:[:b | b bitTest:16r80].

    "
     #[1 2 3 1 2 3 1 2 127 ] asExternalBytes containsNon7BitAscii
     #[1 2 3 1 2 3 1 2 250 251 250 251 255] asExternalBytes containsNon7BitAscii
    "
!

isValid
    "true if I have an address"

%{  /* NOCONTEXT */
    RETURN ((__INST(address_) == 0) ? false : true );
%}
!

species
    "when copying, or concatenating, return instances of this class"

    ^ ByteArray
! !

!ExternalBytes methodsFor:'registration'!

protectFromGC
    "enter a reference to the receiver into the AllocatedInstances
     class variable - this prevents it from ever being finalized by
     the garbage collector, thus protecting the underlying memory."

    |wasBlocked|


    "using a Semaphore can cause a deadlock, since unprotectFromGC may be called by
     a finalization method"

    wasBlocked := OperatingSystem blockInterrupts.
"/    AccessLock critical:[
	AllocatedInstances isNil ifTrue:[
	    AllocatedInstances := IdentitySet new
	].
	AllocatedInstances add:self.
"/    ]
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
!

unprotectFromGC
    "remove the receiver from the AllocatedInstances
     class variable - if there is no other reference to the receiver,
     and this was ever allocated by me (i.e. not by the outside world),
     the next garbage collect will finalize the receiver and the underlying
     memory be freed."

    |wasBlocked|

    "using a Semaphore can cause a deadlock, since protectFromGC may be interrupted by me
     being called by a finalization method"

    wasBlocked := OperatingSystem blockInterrupts.
"/    AccessLock critical:[
    AllocatedInstances notNil ifTrue:[
	AllocatedInstances remove:self ifAbsent:nil.
    ].
"/    ]
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
! !

!ExternalBytes methodsFor:'resizing'!

grow:numberOfBytes
    "reallocate (realloc) numberOfBytes.
     Raise MallocFailure if realloc fails to allocate enough memory"

    |mallocStatus|

    size == numberOfBytes ifTrue:[^ self].

%{
    if (__isSmallInteger(numberOfBytes)) {
	INT nBytes = __smallIntegerVal(numberOfBytes);
	if (nBytes > 0) {
	    char *space;
	    char *prevSpace = (char *)__INST(address_);

	    if (prevSpace == (char *)nil)
		prevSpace = 0;  /* allocate from scratch */
	    space = __stx_realloc(prevSpace, nBytes);
	    if (space) {
		__INST(address_) = (OBJ)space;
		__INST(size) = numberOfBytes;
		if (space == prevSpace) {
		    /* same address, no re-registration */
		    RETURN(self);
		}
		mallocStatus = true;
	    } else {
		mallocStatus = false;
	    }
	}
    }
%}.
    mallocStatus == true ifTrue:[
	Lobby registerChange:self.
    ] ifFalse:[mallocStatus == false ifTrue:[
	^ MallocFailure raiseRequestWith:numberOfBytes.
    ] ifFalse:[
	self primitiveFailed.
    ]].
! !

!ExternalBytes methodsFor:'testing'!

isExternalBytes
    ^ true
! !

!ExternalBytes class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ExternalBytes initialize!
