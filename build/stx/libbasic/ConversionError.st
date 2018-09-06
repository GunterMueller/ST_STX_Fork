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

ProceedableError subclass:#ConversionError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!ConversionError class methodsFor:'documentation'!

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
    raised when an error occurs while converting from/to character representation.
    (especially numbers, date, time etc)
"
! !

!ConversionError class methodsFor:'initialization'!

initialize
    NotifierString := 'conversion error'.
! !

!ConversionError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/ConversionError.st,v 1.6 2004/08/22 17:47:16 stefan Exp $'
!

version_SVN
    ^ '$Id: ConversionError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

ConversionError initialize!



