"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

Object subclass:#ExternalAddress
	instanceVariableNames:'address*'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!ExternalAddress class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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
    Instances of this class represent external (non-Smalltalk) memory addresses.
    They are only useful to represent handles as returned by C functions,
    or to pass them to C functions. 
    For example, Window- or WidgetIDs (which are actually 32 bit pointers) can be represented this way,
    but better create a handle-subclass for it, to care for proper finalization.
    (you should not use SmallIntegers for this, since they can only represent 31
     bits; LargeIntegers could be used in theory, but it is not a very good style
     to do so, since it makes things a bit cryptic - having ExternalAddresses
     around makes things pretty clear in inspectors etc.).

    There is not much you can do with ExternalAddresses on the Smalltalk level;
    creation/use should be done in primitive C-code via 
       __MKEXTERNALADDRESS(voidPtr) and __ExternalAddressVal(obj).

    ExternalAddresses are much like ExternalBytes - however, ExternalAddresses do not know
    the size of the memory block and therefore do not allow you to access bytes via indexed at:/at:put: messages
    (which ExternalBytes do).
    ExternalAddresses are meant to remain anonymous, opaque handles.
    Also, memory blocks which are freeable should be represented as ExternalBytes.

    [author:]
        Claus Gittinger

    [see also:]
        ByteArray
        ExternalBytes ExternalFunction
        ( how to write primitive code :html: programming/primitive.html )
"
!

examples
"
    To pass some C-pointer from primitive code to smalltalk:

	...
	RETURN (__MKEXTERNALADDRESS(foo));

    pass it back to C and use it there:

	...
	if (__isExternalAddress(anExternalAddress)) {
	    ptr = __externalAddressVal(anExternalAddress));
	}
	...

    concrete example:

	test1
	%{
	    static char foo[] = {'h', 'e' ,'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd', '\n'};

	    RETURN (__MKEXTERNALADDRESS(foo));
	%}

	test2:anExternalAddress
	%{
	    if (__isExternalAddress(anExternalAddress)) {
		printf(__externalAddressVal(anExternalAddress));
		RETURN (self);
	    }
	%}
"
! !

!ExternalAddress class methodsFor:'instance creation'!

newAddress:addr
    "return a new externalAddress (pointer), pointing to addr."

    ^ self new setAddress:addr

    "Modified (comment): / 15-11-2016 / 11:57:34 / cg"
!

newAddressFromBytes:bytesContainingAddress
    "return a new externalAddress (pointer), pointing to the addr contained in the argument.
     The argument must be a byteArray-like object, whose first pointerSize bytes are extracted"

    ^ (bytesContainingAddress pointerAt:1)

    "
     |bytes ptr|

     bytes := ByteArray new:(ExternalAddress pointerSize).
     bytes pointerAt:1 put:16r12345678.
     ptr := ExternalAddress newAddressFromBytes:bytes.
     self assert:(ptr address = 16r12345678).
    "

    "Created: / 15-11-2016 / 12:53:21 / cg"
! !

!ExternalAddress class methodsFor:'Compatibility-V''Age'!

fromAddress:anInteger
    ^ self newAddress:anInteger

    "Created: / 22-12-2010 / 13:48:42 / cg"
!

sizeInBytes
    ^ self pointerSize

    "Created: / 21-12-2010 / 15:18:06 / cg"
! !

!ExternalAddress class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned (but not for subclasses)."

    ^ self == ExternalAddress

    "Modified: / 11-06-1998 / 17:12:40 / cg"
    "Modified (comment): / 15-11-2016 / 11:56:55 / cg"
!

pointerSize
    "answer the size in bytes of a pointer.
     Notice: this is inlined by the compiler(s) as a constant,
     therefore, queries like 
        'ExternalAddress pointerSize == 8'
     cost nothing; they are compiled in as a constant 
     (and even conditionals are eliminated)."

%{ /* NOCONTEXT */
    RETURN(__mkSmallInteger(sizeof(void *)));
%}.

    "
     self pointerSize
    "

    "Modified (comment): / 15-11-2016 / 11:56:38 / cg"
!

sizeOfPointer
    "answer the size in bytes of a pointer.
     Notice: this is inlined by the compiler(s) as a constant,
     therefore, queries like 
        'ExternalAddress pointerSize == 8'
     cost nothing; they are compiled in as a constant 
     (and even conditionals are eliminated)."

%{ /* NOCONTEXT */
    RETURN(__mkSmallInteger(sizeof(void *)));
%}.

    "
     self sizeOfPointer
    "

    "Created: / 15-11-2016 / 11:40:52 / cg"
! !


!ExternalAddress methodsFor:'Compatibility-Squeak'!

beNull
    self setAddress:0
!

isNull
    ^ self address = 0

    "Created: / 26-10-2010 / 23:17:57 / cg"
! !

!ExternalAddress methodsFor:'accessing'!

address
    "return the start address as an integer"

%{  /* NOCONTEXT */

    unsigned INT addr;

    addr = (unsigned INT)__INST(address_);
    RETURN ( __MKUINT(addr));
%}
!

instVarAt:index
    "redefined to suppress direct access to my address, which is a non-object"

    index == 1 ifTrue:[^ self address].
    ^ super instVarAt:index

    "Created: / 3.9.1999 / 13:47:03 / ps"
!

instVarAt:index put:newAddress
    "redefined to suppress direct access to my address, which is a non-object"

    index == 1 ifTrue:[
        self setAddress:newAddress.
        ^ newAddress
    ].
    ^ super instVarAt:index put:newAddress

    "Created: / 3.9.1999 / 14:31:57 / ps"
! !

!ExternalAddress methodsFor:'comparing'!

= anExternalAddress
    "return true, if two externalAddress instance represent the same
     C pointer"

%{  /* NOCONTEXT */
    if ((__Class(anExternalAddress) == __Class(self))
     && (__externalAddressVal(self) == __externalAddressVal(anExternalAddress))) {
	RETURN (true);
    }
%}.
    ^ false
!

hash
    "return a number useful for hashing"

%{  /* NOCONTEXT */
    unsigned INT addr = (unsigned INT) __externalAddressVal(self);

    if (addr > _MAX_INT) {
	if ((addr & 1) == 0) {
	    addr >>= 1;
	}
	if (addr > _MAX_INT) {
	    if ((addr & 1) == 0) {
		addr >>= 1;
	    }
	}
	if (addr > _MAX_INT) {
	    addr &= _MAX_INT;
	}
    } else {
	addr <<= 1;
	if (addr <= _MAX_INT) {
	    addr <<= 1;
	    if (addr <= _MAX_INT) {
		addr <<= 1;
	    }
	}
	addr >>= 1;
    }
    RETURN (__mkSmallInteger(addr));
%}
! !

!ExternalAddress methodsFor:'converting'!

asExternalAddress
    "convert to an ExternalAddress.
     Useful to convert subclasses"

%{ /* NOCONTEXT */

    if (__qClass(self) == @global(ExternalAddress)) {
        RETURN(self)
    }
    RETURN(__MKEXTERNALADDRESS(__INST(address_)));
%}.

    "
      (ExternalAddress newAddress:16r12345678) asExternalAddress
    "
!

asExternalBytes
    "return an ExternalBytes object pointing to where the receiver points to.
     Use of this is not recommended; primitives which return externalAddresses
     don't think that access to the memory is required/useful, while primitives
     which do think so should return an externalBytes instance right away."

%{ /* NOCONTEXT */

    RETURN(__MKEXTERNALBYTES(__INST(address_)));
%}

    "
      (ExternalAddress newAddress:16r12345678) asExternalBytes
    "
!

copyCStringFromHeap
    ^ self asExternalBytes copyCStringFromHeap
! !

!ExternalAddress methodsFor:'printing & storing'!

printOn:aStream
    "return a printed representation of the receiver"

    self class name printOn:aStream.
    aStream nextPutAll:'@'.
    self address printOn:aStream base:16.

    "
        self new printString
    "
! !

!ExternalAddress methodsFor:'private-accessing'!

setAddress:anInteger
    "set the address"

%{  /* NOCONTEXT */

    unsigned INT addr;

    if (anInteger == nil) {
    	addr = (unsigned INT)NULL;
    } else if (__isSmallInteger(anInteger)) {
        addr = __intVal(anInteger);
    } else {
        addr = __unsignedLongIntVal(anInteger);    
    }
    __INST(address_) = (OBJ)addr;
%}

    "Modified: / 15-11-2016 / 11:59:24 / cg"
!

setAddressFromBytes:aByteArray
    "set the address from a pointer to which we have a pointer to"

%{  /* NOCONTEXT */

    if (__isByteArrayLike(aByteArray)) {
        if (__byteArraySize(aByteArray) == sizeof(void *)) {
            __INST(address_) = (OBJ)(((void **)__byteArrayVal(aByteArray))[0]);
            RETURN (self);
        }
    }
%}.
    self primitiveFailed.

    "Created: / 27-07-2006 / 14:37:57 / fm"
    "Modified: / 07-08-2006 / 15:16:32 / fm"
! !

!ExternalAddress methodsFor:'testing'!

isExternalAddress
    ^ true

    "Created: / 22-12-2010 / 17:14:57 / cg"
! !

!ExternalAddress class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

