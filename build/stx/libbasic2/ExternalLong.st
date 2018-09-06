"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1998 by eXept Software AG
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

ExternalBytes subclass:#ExternalLong
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!ExternalLong class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    mostly added for odbc, which uses instances of me as container in which values
    (pointers) are returned. 
    The name is very misleading: it should be ExternalPointer,
    because on machines where sizeof(long) !!= sizeof(void *), that makes a difference.
    However, over time, others started to use this class, 
    and renaming it would break some code.
"
! !

!ExternalLong class methodsFor:'instance creation'!

new
    "allocate some memory usable for data;
     the memory is not controlled by the garbage collector.
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

    ^ super new:(ExternalAddress pointerSize)

    "
     ExternalLong new
    "

    "Modified: / 20-12-2010 / 16:22:51 / cg"
!

unprotectedNew
    "allocate some memory usable for data;
     the memory is under the control of the garbage collector.
     Return a corresponding ExternalBytes object or raise MallocFailure (if malloc fails).

     DANGER ALERT: the memory block as allocated will be automatically freed
		   as soon as the reference to the returned externalBytes object
		   is gone (by the next garbage collect).
		   If the memory has been passed to a C-function which
		   remembers this pointer, bad things may happen ...."

    ^ super unprotectedNew:(ExternalAddress pointerSize)

    "
     ExternalLong new
    "

    "Modified: / 20-12-2010 / 16:22:39 / cg"
! !

!ExternalLong methodsFor:'accessing'!

asBoolean
    |result|

    result := self byteAt:1.
    result = 0 ifTrue:[
	^ false.
    ].
    ^ true.
!

asExternalBytes
    ^ ExternalBytes address:(self value)

    "
     (ExternalLong new value:10) asExternalBytes
     (ExternalLong new value:0) asExternalBytes
    "
!

asInteger
    "warning: retrieves a signed integer with the size of the native machine's
     pointer (i.e. either 32 or 64bit)"

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self signedInt64At:1 MSB:IsBigEndian
    ] ifFalse:[
        ^ self signedInt32At:1 MSB:IsBigEndian
    ]

    "
     ExternalLong new value:10
     (ExternalLong new value:16rFFFFFF) asInteger
    "

    "Modified: / 22-12-2010 / 18:34:02 / cg"
!

asNullStatus
    "cg: whoever added this here should move it to the sql package"

    |result|

    result := self unsignedInt16At:1 MSB:false.
    result = 0 ifTrue:[ ^ #SQL_NO_NULLS ].
    result = 1 ifTrue:[ ^ #SQL_NULLABLE ].
    ^ #SQL_NULLABLE_UNKNOWN
!

asPointer
    "fetch my cell's pointer value
     (use this if you passed me to a C function as out parameter, to fetch the returned value)"

    "/ ^ ExternalAddress new setAddress:(self value address)
    ^ self pointerAt:1.

    "
     (ExternalLong new value:10) asPointer
    "
!

asUnsignedInteger
    "warning: retrieves an integer with the size of the native machine's
     pointer (i.e. either 32 or 64bit)"

    ExternalAddress pointerSize == 8 ifTrue:[
        ^ self unsignedInt64At:1 MSB:IsBigEndian
    ] ifFalse:[
        ^ self unsignedInt32At:1 MSB:IsBigEndian
    ]

    "
     (ExternalLong new value:10) asUnsignedInteger
    "

    "Created: / 22-12-2010 / 18:31:03 / cg"
!

boolean:bool
    bool ifTrue:[self byteAt:1 put:1].
    self byteAt:1 put:0.
!

value
    ^ (self pointerAt:1) address

    "
     (ExternalLong new value:10) value
    "

    "Modified: / 30.3.1998 / 17:07:57 / cg"
!

value:anInteger
    "/ self doubleWordAt:1 put:anInteger
    self pointerAt:1 put:anInteger
! !

!ExternalLong methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:self className; nextPut:$(.
    self asInteger printOn:aStream.
    aStream nextPut:$)
! !

!ExternalLong class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

