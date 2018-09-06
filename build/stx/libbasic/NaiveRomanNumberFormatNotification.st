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

Notification subclass:#NaiveRomanNumberFormatNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!NaiveRomanNumberFormatNotification class methodsFor:'documentation'!

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
    raised if a naive roman number is converted.
    These are the (incorrect) representations for 4, 9, 40, 90 etc.,
    which use 4 ones (tens, etc) instead of a 5-1 encoding.
    (such as 'IIII' instead of 'IV')

    This is a notification only - i.e. if not handled, the conversion proceeds
    and accepts the naive number.
"
! !

!NaiveRomanNumberFormatNotification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/NaiveRomanNumberFormatNotification.st,v 1.3 2008/08/06 09:53:07 cg Exp $'
! !



