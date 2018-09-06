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

CharacterArray variableLongSubclass:#FourByteString
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!FourByteString class methodsFor:'documentation'!

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
    FourByteStrings are like strings, but storing 32bits per character.
    The integration of them into the system is not completed ....

    [author:]
        Claus Gittinger

    [see also:]
        Text TwoByteString UnicodeEncodedString
        StringCollection
"
! !

!FourByteString class methodsFor:'initialization'!

initialize
    "initialize the class - private"

    self flags:(Behavior flagLongs)

    "
     FourByteString initialize
    "

    "Modified: 22.4.1996 / 16:14:14 / cg"
! !

!FourByteString class methodsFor:'instance creation'!

basicNew:anInteger
    "return a new empty string with anInteger characters"

    ^ (super basicNew:anInteger) atAllPut:(Character space)

    "Modified: 26.2.1996 / 14:38:47 / cg"
!

uninitializedNew:anInteger
    "return a new empty string with anInteger characters"

    ^ super basicNew:anInteger

    "
        self uninitializedNew:10
    "
! !

!FourByteString methodsFor:'accessing'!

basicAt:index
    "return the character at position index, an Integer
     - reimplemented here since we return 32-bit characters"

    |val|

    val := super basicAt:index.
    ^ Character value:val
!

basicAt:index put:aCharacter
    "store the argument, aCharacter at position index, an Integer.
     Returns aCharacter (sigh).
     - reimplemented here since we store 32-bit characters"

    |val|

    val := aCharacter codePoint.
    super basicAt:index put:val.
    ^ aCharacter
! !

!FourByteString methodsFor:'queries'!

bitsPerCharacter
    "return the number of bits each character has.
     Here, 32 is returned (storing quad byte characters)."

    ^ 32
!

bytesPerCharacter
    "return the number of bytes each character has.
     Here, 4 is returned (storing quad byte characters)."

    ^ 4
!

isWideString
    "true if I require more than one byte per character"

    ^ true
! !

!FourByteString class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


FourByteString initialize!
