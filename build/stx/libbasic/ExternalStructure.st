"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2006 by eXept Software AG
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

ExternalBytes subclass:#ExternalStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

ExternalStructure class instanceVariableNames:'cType'

"
 No other class instance variables are inherited by this class.
"
!

!ExternalStructure class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    Instances of this class represent external (non-Smalltalk) data,
    typically C-structs or C++ instances.
    They are only useful to represent handles as returned by C functions as smalltalk objects.

    ExternallStructures are much like ExternalBytes - however, the latter
    allow you to access bytes via indexed at:/at:put: messages, whilst instances of subclasses of me
    allow access via the corresponding getter/setter methods of my C-type.

    Usage: normally (within exept), these are to be used with the ctype framework, which parses
    c header files and generates structure descriptions (ctypes).
    However, this class can also be used wthout such type descriptions, by subclassing it
    and redefining sizeof (to return the size in bytes of the structure) and getters 
    (as 'self longAt:idx', unsignedLOngAt:idx, etc.).

    [author:]
        Claus Gittinger

    [see also:]
        ExternalBytes ExternalAddress
        ( how to write primitive code :html: programming/primitive.html )
"
! !

!ExternalStructure class methodsFor:'instance creation'!

fromExternalAddress:anExternalAddress
    ^ self new fromExternalAddress:anExternalAddress
!

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

    ^ super new:(self sizeof)

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

    ^ super unprotectedNew:(self sizeof)
! !

!ExternalStructure class methodsFor:'queries'!

cType
    ^ cType
!

fields
    "for Squeak compatibility support: may return a literal array structure definition,
     from which the size and layout of the fields can be constructed.
     Returns nil for ST/X subclasses, which redefine the sizeof method"

    ^ nil
!

sizeof
    "the sizeof my instances in bytes"

    cType isNil ifTrue:[
        "/ second chance for Squeak external structures
        self fields notNil ifTrue:[
            self generateCTypeFromFieldDescription:self fields.
        ].
    ].
    cType notNil ifTrue:[
        ^ cType sizeof
    ].
    self subclassResponsibility
! !

!ExternalStructure class methodsFor:'utilities'!

generateCTypeFromFieldDescription:fieldsSpec
    "to support Squeak external structures, which define a fields method,
     which returns a literal array spec of fields"

    self halt.
! !

!ExternalStructure methodsFor:'private'!

fromExternalAddress:anExternalAddressOrExternalStructure
    self 
        setAddress:(anExternalAddressOrExternalStructure address) 
        size:(anExternalAddressOrExternalStructure size).
! !

!ExternalStructure methodsFor:'testing'!

isExternalStructure
    ^ true
! !

!ExternalStructure class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

