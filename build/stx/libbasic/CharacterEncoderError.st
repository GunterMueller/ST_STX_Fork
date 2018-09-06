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

"{ NameSpace: Smalltalk }"

ConversionError subclass:#CharacterEncoderError
	instanceVariableNames:'defaultValue'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!CharacterEncoderError class methodsFor:'documentation'!

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
    raised if no encoding/decoding exists for some codePoint
    while converting 
    (for example, when converting unicode to ISO-8859-x and vice versa).
"
! !

!CharacterEncoderError methodsFor:'accessing'!

defaultValue
    ^ defaultValue ? 16rFFFF    "/ unicode invalid character
!

defaultValue:something
    defaultValue := something.
! !

!CharacterEncoderError methodsFor:'queries'!

defaultResumeValue
    "the default answer, if no one handles the query and the exception is resumed"

    ^ self defaultValue
!

isInvalidEncodingError
    ^ false
! !

!CharacterEncoderError class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

