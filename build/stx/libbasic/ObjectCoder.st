"
 COPYRIGHT (c) 2000 by eXept Software AG
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

AspectVisitor subclass:#ObjectCoder
	instanceVariableNames:'stream'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Storage'
!

!ObjectCoder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    This is an abstract class. Subclasses implement encoding and decoding
    of Objects onto resp. from a stream. Possible coders are ASN.1/BER,
    CORBA/CDR, BOSS, RMI ...

    Classes which implement basic types (Boolean, Integer, Float, ...)
    implement the visitor methods #acceptVisitor:with:, which dispatches onto an ObjectCoder.

    [author:]
         Stefan Vogel

    [see also:]
        OSI::ASN1_Coder

    [instance variables:]
        stream  <Stream>        the stream we read/write the encodings from/to

    [class variables:]
"
! !

!ObjectCoder class methodsFor:'instance creation'!

on:aStream
    "return an encoder/decoder for a stream"

    ^ self new stream:aStream


! !

!ObjectCoder class methodsFor:'encoding'!

decode:anObject
    "decode anObject"

    ^ (self on:anObject readStream) upToEnd

    "
     Base64Coder encode:#[1 2 16rFe 16rFF]
     Base64Coder decode:'AQL+/w=='    
     (Base64Coder decode:(Base64Coder encode:#[1 2 16rFe 16rFF])) = #[1 2 16rFe 16rFF]
    "
!

decodingOf:anObject
    "use encode"

    <resource: #obsolete>

    ^ self decode:anObject
!

encode:anObject
    "encode of anObject"

    ^ self new encodingOf:anObject with:nil

    "
     Base64Coder encode:#[1 2 16rFe 16rFF]
     Base64Coder encode:'hello'
     OSI::BERCoder encode:'hello'  
    "

    "Modified (comment): / 12-01-2012 / 13:51:23 / cg"
!

encode:anObject on:aStream
    self encode:anObject on:aStream with:nil
!

encode:anObject on:aStream with:info
    self new encode:anObject on:aStream with:info
!

encode:anObject with:aParameter
    "return the encoding of anObject"

    ^ self new encodingOf:anObject with:aParameter
!

encodingOf:anObject
    "use #encode:"

    <resource: #obsolete>

    ^ self encode:anObject

    "
     Base64Coder encodingOf:#[1 2 16rFe 16rFF]
    "
!

encodingOf:anObject with:aParameter
    "use #encode:with:"

    <resource: #obsolete>

    ^ self encode:anObject with:aParameter
! !

!ObjectCoder methodsFor:'accessing'!

contents

    self flush.
    ^ stream contents
! !

!ObjectCoder methodsFor:'decoding'!

next
    "read, decode and return the next object"

    ^ self subclassResponsibility


! !

!ObjectCoder methodsFor:'encoding'!

encode:anObject on:aStream 
    self encode:anObject on:aStream with:nil
!

encode:anObject on:aStream with:info
    self stream:aStream.
    self startEncoding.
    anObject acceptVisitor:self with:info.
    self endEncoding.
!

encodingOf:anObject
    "answer the encoded argument anObject"

    ^ self encodingOf:anObject with:nil


!

encodingOf:anObject with:aParameter
    "answer the encoded argument anObject"

    stream isNil ifTrue:[
        stream := self emptyWriteStream.
    ] ifFalse:[
        stream reset.
    ].
    self startEncoding.
    anObject acceptVisitor:self with:aParameter.
    self endEncoding.

    ^ stream contents.
!

endEncoding
    "redefinable - allows subclass to create a file trailer or similar stuff"

    "/ intentionally left blank here
!

nextPut:anObject
    "encode anObject onto my stream"

    self nextPut:anObject with:nil
!

nextPut:anObject with:aParameter
    "encode anObject onto my stream"

    anObject acceptVisitor:self with:aParameter.
!

nextPutAll:aCollectionOfObjects
    "encode all objects from the argument"

    aCollectionOfObjects do:[:o |
        self nextPut:o
    ]

!

startEncoding
    "redefinable - allows subclass to create a file header or similar stuff"

    "/ intentionally left blank here
! !

!ObjectCoder methodsFor:'encoding-smalltalk types'!

visitBlock:aBlock with:aParameter
    "encoding of blocks is rather difficult and an error by default.
     If your encoder supports this, redefine it there"

    self error:'encoding of blocks is not supported'
! !

!ObjectCoder methodsFor:'initialization'!

close
    "close the underlying stream"

    stream notNil ifTrue:[
        stream close.
    ].


!

emptyWriteStream
    "answer an empty stream for writing the encoded object"

    ^ self subclassResponsibility
!

flush
    "flush possibly internally buffered data.
     Nothing is done by default. Subclasses may redefine this"

    ^ self
!

reset
    "reset the coder"

    stream notNil ifTrue:[
        stream reset.
    ].


! !

!ObjectCoder methodsFor:'private-accessing'!

stream
    "return my input or output stream"
    
    ^ stream
!

stream:aStream
    "set my input or output stream"

    stream := aStream.
! !

!ObjectCoder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

