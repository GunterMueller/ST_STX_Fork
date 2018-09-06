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

CharacterEncoder subclass:#ISO10646_1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!ISO10646_1 class methodsFor:'documentation'!

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
    I am a dummy encoder for Unicode.
    Dummy, because that is the standard encding inside ST/X anyway
"
! !

!ISO10646_1 class methodsFor:'queries'!

userFriendlyNameOfEncoding
    ^ 'Unicode'
! !

!ISO10646_1 methodsFor:'encoding & decoding'!

decode:aCode
    ^ aCode
!

decodeString:aString
    ^ aString
!

encode:aCode
    ^ aCode
!

encodeString:aString
    ^ aString
! !

!ISO10646_1 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: CharacterEncoderImplementations__ISO10646_1.st 10807 2012-05-05 21:58:24Z vranyj1 $'
! !



