"
 COPYRIGHT (c) 1997 by eXept Software AG 
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

TwoByteString variableWordSubclass:#Unicode16String
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!Unicode16String class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG 
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
    Represents 16-bit (2-byte) Unicode strings.
"
! !

!Unicode16String class methodsFor:'initialization'!

initialize
    "initialize the class - private"

    self flags:(Behavior flagWords).

    Smalltalk at:#UnicodeString put:Unicode16String.

    "
     Unicode16String initialize
    "

    "Created: 30.6.1997 / 15:35:52 / cg"
    "Modified: 30.6.1997 / 15:39:21 / cg"
! !

!Unicode16String class methodsFor:'reading'!

readFrom:aStreamOrString onError:exceptionBlock
    "read & return the next String from the (character-)stream aStream;
     skipping all whitespace first; return the value of exceptionBlock,
     if no string can be read. The sequence of characters as read from the
     stream must be one as stored via storeOn: or storeString."

    "
     this method is not to be inherited
     (i.e. not ok for subclasses; Symbol, for example)
    "
    self ~~ Unicode16String ifTrue:[
        ^ super readFrom:aStreamOrString onError:exceptionBlock
    ].
    ^ self readSmalltalkStringFrom:aStreamOrString onError:exceptionBlock

    "
        self readFrom:'abcäöü' storeString
    "
! !


!Unicode16String methodsFor:'conversion'!

asUnicode16String
    "as the receiver already is a unicode-16 string, return it"

    ^ self
!

asUnicodeString
    "as the receiver already is a unicode string, return it"

    ^ self
! !

!Unicode16String methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "display myself as on aStream.
     You must use an ISO10646 unicode font to display this string"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifTrue:[
        aGCOrStream
            nextPut:$';
            nextPutAllUnicode:self;
            nextPut:$'.
        ^ self
    ].
    ^ super displayOn:aGCOrStream
!

printOn:aStream
    "print the receiver on aStream. 
     Let aStream decide how to represent this, whether utf8, ucs16, ..."

    aStream nextPutAllUnicode:self

    "Modified (comment): / 25-01-2012 / 10:28:34 / cg"
!

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
            'hello' asUnicodeString storeOn:s
        ].

        String streamContents:[:s|
            'hello -öäüß' asUnicodeString storeOn:s
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

    "Modified: / 28-09-2011 / 16:17:38 / cg"
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
        'hello' asUnicodeString storeString
        'hello -öäüß' storeString
        'hello -öäüß' asUnicodeString storeString
    "

    "Modified: / 25-01-2012 / 11:59:34 / cg"
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

!Unicode16String methodsFor:'testing'!

isUnicode16String
    ^ true
!

isUnicodeString
    "true if this is a 2- or 4-byte unicode string
     (i.e. not a single byte string).
     Notice, that the name is misleading: 
     all strings are use unicode encoding"

    ^ true
! !

!Unicode16String class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Unicode16String initialize!
