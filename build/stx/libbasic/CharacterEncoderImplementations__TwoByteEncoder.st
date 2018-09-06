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
"{ Package: 'stx:libbasic' }"

"{ NameSpace: CharacterEncoderImplementations }"

CharacterEncoder subclass:#TwoByteEncoder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!TwoByteEncoder class methodsFor:'documentation'!

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
    abstract superclass of all two-byte encoders
"
! !

!TwoByteEncoder class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == CharacterEncoderImplementations::TwoByteEncoder
!

maxCode
    ^ 16rFFFF 
!

minCode
    ^ 0 
! !

!TwoByteEncoder methodsFor:'queries'!

characterSize:codePoint
    "return the number of bytes required to encode codePoint"

    ^2

    "Created: / 15-06-2005 / 15:12:01 / janfrog"
! !

!TwoByteEncoder methodsFor:'stream support'!

readNextCharacterFrom:aStream
    | c |

    c := aStream nextUnsignedInt16MSB:false.
    ^ c isNil 
        ifTrue: [nil]
        ifFalse: [(self decode:c) asCharacter]
!

readNextInputCharacterFrom:aStream
    ^ aStream nextUnsignedInt16MSB:false
! !

!TwoByteEncoder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

