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

Stream subclass:#HashStream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Crypt-Hashing'
!

!HashStream class methodsFor:'documentation'!

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
    Abstract class. 
    Subclasses generate hash values used as checksums
    or for generating cryptographic signatures.

    Notice: due to historic reasons and compatibility with Squeak,
    there are two modes of operation:
        1) hashFunction mode, in which the hash of a single block of bytes is computed
        2) hashStream mode, in which instances behave like a writeStream, computing and
           updating the hash, as data is sent to it.

    hashFunction mode is called using: #hashValueOf:aStringOrByteArray
    Warning: Not all subclasses support the stream mode 
             (especially those which were ported from squeak do not).

    [author:]
        Stefan Vogel

    [see also:]
        SHA1Stream MD5Stream
"
!

examples
"
  hashFunction mode:
                                                                [exBegin]
    MD5Stream hashValueOf:'hello world'
    MD4Stream hashValueOf:'hello world'
                                                                [exEnd]

  hashStream mode:
                                                                [exBegin]
    |md5|

    md5 := MD5Stream new.
    md5 nextPutAll:'hello world'.
    md5 hashValue  
                                                                [exEnd]
"
! !

!HashStream class methodsFor:'instance creation'!

new
    "have to re-allow new - it was disabled in Stream"
    ^ self basicNew initialize


!

random
    "create a random number generator using myself"

    ^ HashRandom with:self

    "
     SHA1Stream random next
    "

    "Modified: / 12.11.1999 / 17:21:17 / stefan"
! !

!HashStream class methodsFor:'compatibility - squeak'!

hashMessage:aStringOrByteArrayOrStream
    "SQUEAK compatibility 
        - but this is a bad choice - squeak uses #digestMessage: at the instance side"

    ^ self hashValueOf:aStringOrByteArrayOrStream
! !

!HashStream class methodsFor:'queries'!

blockSize
    "return the block size when the hash is used by encryption/decryption.
     (see OfbCipherMode and CtrCipherMode)"

    ^ self hashSize
!

canStream
    "simple hash functions (squeak-ported) cannot stream.
     Use hashFunction: there"

    ^ true
!

hashBlockSize
    "return the block size used internally by the compression function"
    
    self subclassResponsibility
!

hashSize
    "return the size of the hashvalue returned by instances of this class (in bytes)"

    self subclassResponsibility

    "Created: / 04-01-2012 / 19:22:32 / cg"
! !

!HashStream class methodsFor:'self tests'!

test
    "test against testVector"

    self testVector do:[:pair |
        |data expectedHash expectedHashBytes computedHash hashStream|

        data := pair first.
        expectedHash := pair second.
        expectedHash isString ifTrue:[
            expectedHashBytes := ByteArray fromHexString:expectedHash
        ] ifFalse:[
            expectedHashBytes := expectedHash
        ].

        "/ non-stream interface must be implemented by all
        computedHash := self hashValueOf:data.
        self assert:computedHash = expectedHashBytes message:'Test failed'.
        self canStream ifTrue:[
            hashStream := self new.
            hashStream nextPut:data.
            computedHash := hashStream hashValue.
            self assert:computedHash = expectedHashBytes message:'Test failed'
        ].
    ].

    "
        MD5Stream test.
        SHA1Stream test.
        RipeMD160Stream test.
    "

    "Modified: / 10-01-2012 / 22:35:17 / cg"
!

testVector
    "/ obsolete - moved to TestHashAlgorithms unit test.

    ^ self subclassResponsibility

    "Modified (comment): / 09-01-2012 / 21:49:59 / cg"
! !

!HashStream class methodsFor:'utilities'!

cryptBlock:aStringOrByteArray from:srcIdx to:srcEndOrNil into:resultOrNil startingAt:dstIdx encrypt:encryptMode
    "one-way encryption of aStringOrByteArray.
     Used when a HashStream is used as the block cipher with OFB or CTR mode.

     encryptMode is ignored here."

    |hashValue|

    (srcIdx == 1 and:[srcEndOrNil isNil]) ifTrue:[
        hashValue := self hashValueOf:aStringOrByteArray.
    ] ifFalse:[
        |bytesToEncrypt|

        bytesToEncrypt := aStringOrByteArray copyFrom:srcIdx to:srcIdx+self hashSize-1.
        hashValue := self hashValueOf:bytesToEncrypt.
    ].
    resultOrNil isNil ifTrue:[
        ^ hashValue.
    ] ifFalse:[
        resultOrNil replaceBytesFrom:dstIdx to:dstIdx+hashValue size-1 with:hashValue startingAt:1.
        ^ resultOrNil.
    ].

    "
        |cipher iv cipherText|

        cipher := OfbCipher for:SHA512Stream.
        iv := cipher randomInitializationVector.
        cipherText := cipher encrypt:'Hello world, here is the alien from Mars and 1234567890' asByteArray.
        self information:cipherText printString.

        cipher initializationVector:iv.
        self information:(cipher decrypt:cipherText) asString.
    "
!

digestMessage:aStringOrByteArrayOrStream
    ^ self hashValueOf:aStringOrByteArrayOrStream
!

hashValueOf:aStringOrByteArrayOrStream
    |hashStream|

    hashStream := self new.
    aStringOrByteArrayOrStream isStream ifTrue:[
        aStringOrByteArrayOrStream copyToEndInto:hashStream.
    ] ifFalse:[
        hashStream nextPutAll:aStringOrByteArrayOrStream.
    ].

    ^ hashStream hashValue

    "
     MD5Stream hashValueOf:'BlaBlaBla'
     MD5Stream hashValueOf:('makefile' asFilename readStream)
     MD5Stream hashValueOf:('BlaBlaBla' readStream)
    "

    "Modified: / 12-01-2012 / 12:14:44 / cg"
!

hashValueOfFile:aFilename
    |hash|

    aFilename asFilename readingFileDo:[:readStream|
        readStream binary.
        hash := self hashValueOf:readStream.
    ].
    ^ hash

    "
     MD5Stream hashValueOfFile:'makefile'
    "
! !

!HashStream methodsFor:'accessing'!

contents
    "return the entire contents of the stream
     - this is our hashValue."

    ^ self hashValue

    "Created: / 17.3.1999 / 15:10:03 / stefan"
! !

!HashStream methodsFor:'compatibility - squeak'!

digestMessage:bytes
    "SQUEAK: answer the digest of bytes"

    ^ self hashValueOf:bytes
! !

!HashStream methodsFor:'not implemented'!

next
    "I can only write"

    ^ self shouldNotImplement

    "Created: / 17-03-1999 / 15:11:03 / stefan"
    "Modified (comment): / 09-01-2012 / 16:55:28 / cg"
! !

!HashStream methodsFor:'operations'!

hashValueOf:bytes
    "answer the digest of bytes"

    ^ self 
        reset;
        nextPutAll:bytes;
        hashValue.

    "
        SHA1Stream new 
                hashValueOf:'123456789abcdefg';
                hashValueOf:'123456789abcdefg'

        (SHA1Stream new hmac key:'123456') 
                hashValueOf:'123456789abcdefg';
                hashValueOf:'123456789abcdefg'

        (SHA1Stream new hmac key:'123456') 
                nextPutAll:'123456789abcdefg';
                contents
    "
!

reset
    "initialize to a clean state"

    ^ self subclassResponsibility
! !

!HashStream methodsFor:'queries'!

blockSize
    "the class knows about the basic block size"

    ^ self class blockSize

    "Created: / 18.3.1999 / 10:17:02 / stefan"
!

hashBlockSize
    "the class knows about the basic block size"
    
    ^ self class hashBlockSize
!

hashSize
    "return the size of the returned hashvalue (in bytes)"

    "the class knows about the basic hash size"
    ^ self class hashSize

    "Created: / 18-03-1999 / 10:17:12 / stefan"
    "Modified: / 15-10-1999 / 11:53:20 / stefan"
    "Modified (comment): / 11-01-2012 / 10:12:09 / cg"
!

hashValue
    "return the value of the computed hash"

    ^ self subclassResponsibility

    "Modified (comment): / 23-01-2012 / 10:01:20 / cg"
!

isReadable
    "return true, if reading is supported by the receiver.
     Always return false here"

    ^ false

    "Modified: / 17.3.1999 / 15:06:09 / stefan"
!

isWritable
    "return true, if writing is supported by the receiver.
     Always return true here"

    ^ true

    "Created: / 17.3.1999 / 15:05:49 / stefan"
! !

!HashStream methodsFor:'testing'!

atEnd
    "return true if the end of the stream has been reached;
    this is never reached"

    ^ false

    "Created: / 17.3.1999 / 15:08:55 / stefan"
! !

!HashStream methodsFor:'writing'!

nextPut:anObject
    "add the hash of anObject to the computed hash so far.
     anObject can be a Character, SmallInteger ByteArray or String"

    anObject isByteCollection ifTrue:[
        self nextPutBytes:(anObject byteSize) from:anObject startingAt:1.
        ^ self.
    ].

    anObject isCharacter ifTrue:[
        "/ only 8bit chars are allowed !!
        self nextPutBytes:1 from:(ByteArray with:anObject codePoint) startingAt:1.
        ^ self.
    ].

    anObject isInteger ifTrue:[
        self nextPutBytes:anObject digitBytes.
        ^ self.
    ].

    self error:'unsupported argument'.

    "Modified (comment): / 09-01-2012 / 16:54:05 / cg"
!

nextPutAll:aCollection
    "Hash streams handle Strings and ByteArrays in #nextPutBytes:"

    aCollection isByteCollection ifTrue:[
        self nextPutBytes:(aCollection byteSize) from:aCollection startingAt:1.
    ] ifFalse:[
        super nextPutAll:aCollection
    ].

    "Created: / 14-10-1999 / 11:22:50 / stefan"
    "Modified: / 09-01-2012 / 13:02:44 / cg"
!

nextPutByte:aByte
    "add the hash of anObject to the computed hash so far.
     aByte can be a SmallInteger <= 255"

    self nextPutBytes:1 from:(ByteArray with:aByte) startingAt:1.
!

nextPutBytes:count from:anObject startingAt:start
    "write count bytes from an object starting at index start.
     Return the number of bytes written.
     The object must have non-pointer indexed instvars 
     (i.e. be a ByteArray, String, Float- or DoubleArray)."

    self subclassResponsibility

    "Modified: / 09-01-2012 / 16:41:31 / cg"
! !

!HashStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

