"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: CharacterEncoderImplementations }"

TwoByteEncoder subclass:#ISO10646_to_UTF8
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

ISO10646_to_UTF8 class instanceVariableNames:'theOneAndOnlyInstance'

"
 No other class instance variables are inherited by this class.
"
!

!ISO10646_to_UTF8 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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
    I can encode characters into/from UTF8
    
    Notice the naming (many are confused):
        Unicode is the set of number-to-glyph assignments
    whereas:
        UTF8 is a concrete way of xmitting Unicode codePoints (numbers).
    UTF16 is another concrete encoding, for example.    
        
    ST/X NEVER uses UTF8 internally - all characters are full 24bit characters.
    Only when exchanging data, are these converted into UTF8 (or other) byte sequences.
"
!

examples
"
  Encoding (unicode to utf8)
     ISO10646_to_UTF8 encodeString:'hello'.


  Decoding (utf8 to unicode):
     |t|

     t := ISO10646_to_UTF8 encodeString:'Hello'.
     ISO10646_to_UTF8 decodeString:t.
"
! !

!ISO10646_to_UTF8 class methodsFor:'instance creation'!

flushSingleton
    "flushes the cached singleton"

    theOneAndOnlyInstance := nil

    "
     self flushSingleton
    "
!

new
    "returns a singleton"

    theOneAndOnlyInstance isNil ifTrue:[
        theOneAndOnlyInstance := self basicNew initialize.
    ].
    ^ theOneAndOnlyInstance.
!

theOneAndOnlyInstance
    "returns a singleton"

    theOneAndOnlyInstance isNil ifTrue:[
        theOneAndOnlyInstance := self basicNew initialize.
    ].
    ^ theOneAndOnlyInstance.
! !

!ISO10646_to_UTF8 methodsFor:'encoding & decoding'!

decode:aCode
    self shouldNotImplement "/ no single byte conversion possible
!

decodeString:aStringOrByteCollection
    "given a string in UTF8 encoding,
     return a new string containing the same characters, in Unicode encoding.
     Returns either a normal String, a Unicode16String or a Unicode32String instance.
     This is only useful, when reading from external sources or communicating with
     other systems 
     (ST/X never uses utf8 internally, but always uses strings of fully decoded unicode characters).
     This only handles up-to 30bit characters."

    ^ CharacterArray decodeFromUTF8:aStringOrByteCollection.
!

encode:aCode
    self shouldNotImplement "/ no single byte conversion possible
!

encodeString:aUnicodeString
    "return the UTF-8 representation of a Unicode string.
     The resulting string is only useful to be stored on some external file,
     not for being used inside ST/X."

    ^ aUnicodeString utf8Encoded.
! !

!ISO10646_to_UTF8 methodsFor:'queries'!

bytesToReadFor:firstByte 
    |bytesToRead|

    bytesToRead := 1.
    (firstByte isBitSet:8) ifFalse:[^1].
    7 downTo:3
        do:[:idx | 
            (firstByte isBitSet:idx) ifTrue:[
                bytesToRead := bytesToRead + 1
            ] ifFalse:[
                ^bytesToRead                
            ]
        ].
    ^bytesToRead

    "Created: / 14-06-2005 / 17:17:24 / janfrog"
!

characterSize:charOrcodePoint
    "return the number of bytes required to encode codePoint"

    "Taken from RFC 3629"

    (charOrcodePoint asInteger between:16r00000000 and:16r0000007F) ifTrue:[^1].
    (charOrcodePoint asInteger between:16r00000080 and:16r000007FF) ifTrue:[^2].
    (charOrcodePoint asInteger between:16r00000800 and:16r0000FFFF) ifTrue:[^3].
    (charOrcodePoint asInteger between:16r00010000 and:16r0010FFFF) ifTrue:[^4].

    ^self error:'Invalid codePoint'

    "Created: / 15-06-2005 / 15:16:22 / janfrog"
!

nameOfEncoding
    ^ #utf8
! !

!ISO10646_to_UTF8 methodsFor:'stream support'!

readNext:charactersToRead charactersFrom:stream

    | s |

    s := (String new:charactersToRead) writeStream.
    charactersToRead timesRepeat:[
        | c |
        c := stream peek.
        s nextPutAll:(stream next:(self bytesToReadFor:c))
    ].
    ^ self decodeString:s contents

    "Created: / 16-06-2005 / 11:45:14 / masca"
!

readNextCharacterFrom:stream

    | c bytesYetToRead s |
    c := stream peek.
    bytesYetToRead := self bytesToReadFor:c codePoint.
    bytesYetToRead == 1 ifTrue:[ 
        stream next.
        ^ c.
    ].
    s := (String new:1 + bytesYetToRead) writeStream.
    s nextPutAll:(stream next: bytesYetToRead).
    ^ self decodeString:s contents

    "Created: / 14-06-2005 / 17:03:59 / janfrog"
    "Modified: / 03-10-2015 / 08:49:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ISO10646_to_UTF8 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

