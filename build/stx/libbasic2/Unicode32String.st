"
 COPYRIGHT (c) 2004 by eXept Software AG 
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

FourByteString variableLongSubclass:#Unicode32String
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!Unicode32String class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG 
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
    Not yet fully finished - unicode support is still being implemented.
"
! !

!Unicode32String class methodsFor:'initialization'!

initialize
    "initialize the class - private"

    self flags:(Behavior flagLongs)

    "
     Unicode32String initialize
    "

    "Created: 30.6.1997 / 15:35:52 / cg"
    "Modified: 30.6.1997 / 15:39:21 / cg"
! !

!Unicode32String class methodsFor:'reading'!

readFrom:aStreamOrString onError:exceptionBlock
    "read & return the next String from the (character-)stream aStream;
     skipping all whitespace first; return the value of exceptionBlock,
     if no string can be read. The sequence of characters as read from the
     stream must be one as stored via storeOn: or storeString."

    "
     this method is not to be inherited
     (i.e. not ok for subclasses; Symbol, for example)
    "
    self ~~ Unicode32String ifTrue:[
        ^ super readFrom:aStreamOrString onError:exceptionBlock
    ].
    ^ self readSmalltalkStringFrom:aStreamOrString onError:exceptionBlock

    "
        self readFrom:'abcäöü' storeString
        String readFrom:'abcäöü' storeString
    "
! !


!Unicode32String methodsFor:'conversion'!

asUnicode32String
    "as the receiver already is a unicode-32 string, return it"

    ^ self
!

asUnicodeString
    "as the receiver already is a unicode string, return it"

    ^ self
!

printOn:aStream
    "print the receiver on aStream. 
     Let aStream decide how to represent this, whether utf8, ucs16, ..."

    aStream nextPutAllUnicode:self

    "Modified (comment): / 27-07-2013 / 15:37:03 / cg"
! !

!Unicode32String methodsFor:'printing & storing'!

storeOn:aStream
    "put the storeString of myself on aStream"

    self containsNon7BitAscii ifTrue:[
        "non-7bit string has been utf8Encoded"
        self utf8Encoded storeOn:aStream.
        aStream nextPutAll:' utf8Decoded'.
    ] ifFalse:[
        self asSingleByteString storeOn:aStream.
    ].

    "
        String streamContents:[:s|
            'hello' asUnicode32String storeOn:s
        ].

        String streamContents:[:s|
            'hello -öäüß' asUnicode32String storeOn:s
        ].
    "

"/    aStream nextPut:$'.
"/    (self includes:$') ifTrue:[
"/        self do:[:thisChar |
"/            (thisChar == $') ifTrue:[aStream nextPut:thisChar].
"/            aStream nextPutUnicode:thisChar
"/        ]
"/    ] ifFalse:[
"/        aStream nextPutAllUnicode:self
"/    ].
"/    aStream nextPut:$'

    "Modified: / 28-09-2011 / 16:18:43 / cg"
!

storeString
    "return a String for storing myself"

    self containsNon7BitAscii ifTrue:[
        "non-7bit string has been utf8Encoded"
        ^ (self utf8Encoded storeString),' utf8Decoded'.
    ] ifFalse:[
        ^ self asSingleByteString storeString.
    ].

    "
        'hello' asUnicode32String storeString
        'hello -öäüß' storeString
        'hello -öäüß' asUnicode32String storeString
    "
!

unicodeStoreOn:aStream
    "put the storeString of myself on aStream"

    aStream nextPut:$'.
    (self includes:$') ifTrue:[
        self do:[:thisChar |
            (thisChar == $') ifTrue:[aStream nextPut:thisChar].
            aStream nextPutUnicode:thisChar
        ]
    ] ifFalse:[
        aStream nextPutAllUnicode:self
    ].
    aStream nextPut:$'
!

unicodeStoreString
    "return a UnicodeString for storing myself.
     This method is a kind of kludge.
     Use it when you want to write a storeString to an encoded Stream"

    ^ self basicStoreString.
! !

!Unicode32String methodsFor:'testing'!

isUnicode32String
    "true if this is a 4-byte unicode string"

    ^ true
!

isUnicodeString
    "true if this is a 2- or 4-byte unicode string
     (i.e. not a single byte string).
     Notice, that the name is misleading: 
     all strings are use unicode encoding"

    ^ true
! !

!Unicode32String class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Unicode32String initialize!
