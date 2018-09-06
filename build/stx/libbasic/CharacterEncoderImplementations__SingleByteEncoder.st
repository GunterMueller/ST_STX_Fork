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

CharacterEncoder subclass:#SingleByteEncoder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!SingleByteEncoder class methodsFor:'documentation'!

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
    Common abstract superclass for all single-byte encodings.

    [author:]
        Claus Gittinger
"
! !

!SingleByteEncoder class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == CharacterEncoderImplementations::SingleByteEncoder
!

maxCode
    ^ 255 
!

minCode
    ^ 0 
! !

!SingleByteEncoder methodsFor:'queries'!

characterSize:codePoint
    "return the number of bytes required to encode codePoint"

    ^1

    "Created: / 15-06-2005 / 15:11:24 / janfrog"
! !

!SingleByteEncoder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

