"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

HTMLMarkup variableSubclass:#HTMLStyle
	instanceVariableNames:'associations'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLStyle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    Attention: Please read the warning in HTMLElement.
"
! !

!HTMLStyle methodsFor:'accessing'!

at:propertyName
    associations isNil ifTrue:[^ nil].
    ^ associations at:propertyName

    "Created: 24.2.1997 / 11:45:54 / cg"
!

at:propertyName put:something
    associations isNil ifTrue:[
        associations := Dictionary new.
    ].
    associations at:propertyName put:something

    "Created: 24.2.1997 / 11:45:43 / cg"
! !

!HTMLStyle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLStyle.st,v 1.3 2016-04-28 20:45:56 cg Exp $'
! !

