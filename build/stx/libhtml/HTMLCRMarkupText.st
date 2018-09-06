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

HTMLText variableSubclass:#HTMLCRMarkupText
	instanceVariableNames:''
	classVariableNames:'CRString'
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLCRMarkupText class methodsFor:'documentation'!

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

! !

!HTMLCRMarkupText class methodsFor:'initialization'!

initialize
    CRString := Character cr asString
! !

!HTMLCRMarkupText methodsFor:'accessing'!

text
    ^ CRString
!

text:foo
    self halt:'should not have text'
! !

!HTMLCRMarkupText class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLCRMarkupText.st,v 1.3 2008-10-20 14:57:21 cg Exp $'
! !

HTMLCRMarkupText initialize!
