"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

TabulatorSpecification subclass:#ParagraphSpecification
	instanceVariableNames:'leftMargin rightMargin textAlignment'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!ParagraphSpecification class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    Instances of this class can be used to represent the tabs
    and margins of a paragraph of text. Its a goody, not really
    used currently.
"
! !

!ParagraphSpecification methodsFor:'accessing'!

leftMargin
    "return leftMargin"

    ^ leftMargin
!

leftMargin:something
    "set leftMargin"

    leftMargin := something.
!

rightMargin
    "return rightMargin"

    ^ rightMargin
!

rightMargin:something
    "set rightMargin"

    rightMargin := something.
! !

!ParagraphSpecification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/ParagraphSpecification.st,v 1.6 2006-11-13 16:11:31 cg Exp $'
! !

