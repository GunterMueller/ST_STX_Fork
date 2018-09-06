"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

NumberFormatError subclass:#RomanNumberFormatError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!RomanNumberFormatError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    raised directly, if a roman number cannot be converted to a number.
    (invalid character or empty string).
    Also the superclass of more specific errors:
        BadRomanNumberFormatError 
            - raised if characters are ok, but out of range (such as MMMMMM)
        NaiveRomanNumberFormatNotification
            - raised if a 4 or 9 is encoded as naive roman number (such as IIII)
"
! !

!RomanNumberFormatError class methodsFor:'documentation'!

version
    ^ '$Id: RomanNumberFormatError.st 10808 2012-05-09 15:04:12Z vranyj1 $'
!

version_SVN
    ^ '$Id: RomanNumberFormatError.st 10808 2012-05-09 15:04:12Z vranyj1 $'
! !
