"
 COPYRIGHT (c) 2005 by eXept Software AG
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

ISO10646_to_UTF16BE subclass:#ISO10646_to_UTF16LE
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO10646_to_UTF16LE class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
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
    encodes/decodes UTF16 LittleEndian (little-end-first)

    Notice the naming (many are confused):
        Unicode is the set of number-to-glyph assignments
    whereas:
        UTF8, UTF16 etc. are a concrete way of xmitting Unicode codePoints (numbers).

    ST/X NEVER uses UTF8 or UTF16 internally - all characters are full 24bit characters.
    Only when exchanging data, are these converted into UTF8 (or other) byte sequences.
"
!

examples
"
  Encoding (unicode to utf16LE)
     ISO10646_to_UTF16LE encodeString:'hello'.


  Decoding (utf16LE to unicode):
     |t|

     t := ISO10646_to_UTF16LE encodeString:''.
     ISO10646_to_UTF16LE decodeString:t.

  Decoding (utf16LE-Bytes to unicode):
     |bytes|

     bytes := #[ 16r40 0 16r41 0 16r42 0 16r43 0 16r44 0 ].
     ISO10646_to_UTF16LE decodeString:bytes.
"
! !

!ISO10646_to_UTF16LE methodsFor:'encoding & decoding'!

decode:codePoint
    ^ codePoint swapBytes
!

encode:codePoint
    ^ codePoint swapBytes
! !

!ISO10646_to_UTF16LE methodsFor:'private'!

nextPutTwoByteValue:anInteger to:aStream
    aStream nextPutInt16LSB:anInteger
!

nextTwoByteValueFrom:aStream
    ^ aStream nextUnsignedInt16MSB:false
! !

!ISO10646_to_UTF16LE methodsFor:'queries'!

nameOfEncoding
    ^ #utf16le
! !

!ISO10646_to_UTF16LE class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

