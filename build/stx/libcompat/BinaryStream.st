"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Stream subclass:#BinaryStream
	instanceVariableNames:'msb rawStream'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!BinaryStream class methodsFor:'documentation'!

documentation
"
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    This is a mimicry class to allow some squeak code to be filed in without changing.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.

    This stream is used (in squeak) for storage of binary data in either MSB or LSB 
    byte order. In contrast to ST/X streams (where the MSB/LSB parameter is passed around
    as argument), this one keeps it as a state, and provides the usual nextShort/nextInt
    protocol without that parameter.
    It is needed to port the Matlab reader (goodies/math).

    By default, this stream is in MSB mode (network byte order) 
"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    |bytes rawStream binaryStream val|

    bytes := #[1 2 3 4 5 6 7 8 9].
    rawStream := bytes readStream.
    binaryStream := BinaryStream on:rawStream.
    binaryStream beBigEndian.
    self assert:((val := binaryStream nextShort) = 16r0102).
    self assert:((val := binaryStream nextUnsignedShort) = 16r0304).
    binaryStream reset.
    binaryStream beLittleEndian.
    self assert:((val := binaryStream nextShort) = 16r0201).
    self assert:((val := binaryStream nextUnsignedShort) = 16r0403).
                                                                [exEnd]
"
! !

!BinaryStream class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

on:aStream
    "return an initialized instance"

    ^ self new rawStream:aStream
! !

!BinaryStream methodsFor:'accessing'!

beBigEndian
    msb := true.
!

beLittleEndian
    msb := false.
!

rawStream:anotherStream
    rawStream := anotherStream.
! !

!BinaryStream methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    msb := true.
! !

!BinaryStream methodsFor:'misc'!

position
    ^ rawStream position
!

position:newPosition
    rawStream position:newPosition
!

reset
    rawStream reset
! !

!BinaryStream methodsFor:'reading'!

next:nBytes
    ^ rawStream nextBytes:4
!

nextShort
    ^ rawStream nextInt16MSB:msb
!

nextUnsignedShort
    ^ rawStream nextUnsignedInt16MSB:msb
!

peek
    ^ rawStream peek asInteger
! !

!BinaryStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/BinaryStream.st,v 1.1 2018-05-08 18:14:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/BinaryStream.st,v 1.1 2018-05-08 18:14:47 cg Exp $'
! !

