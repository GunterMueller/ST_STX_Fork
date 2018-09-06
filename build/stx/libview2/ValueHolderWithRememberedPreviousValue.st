"
 COPYRIGHT (c) 2014 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

ValueHolder subclass:#ValueHolderWithRememberedPreviousValue
	instanceVariableNames:'previousValue'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!ValueHolderWithRememberedPreviousValue class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by Claus Gittinger
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
    I implement a valueHolder which remembers the previous value whenever changed.

    [author:]
        Claus Gittinger
"
! !

!ValueHolderWithRememberedPreviousValue methodsFor:'accessing'!

previousValue
    ^ previousValue
!

setValue:anObject
    "set my value without notification."

    previousValue := value.
    value := anObject.
! !

!ValueHolderWithRememberedPreviousValue class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/ValueHolderWithRememberedPreviousValue.st,v 1.2 2014-01-13 13:40:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/ValueHolderWithRememberedPreviousValue.st,v 1.2 2014-01-13 13:40:04 cg Exp $'
! !

