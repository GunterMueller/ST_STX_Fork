"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

InputFieldSpec subclass:#EditFieldWithCompletionSpec
	instanceVariableNames:'showOptions'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!EditFieldWithCompletionSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!EditFieldWithCompletionSpec methodsFor:'accessing'!

showOptions
    ^ showOptions
!

showOptions:something
    showOptions := something.
! !

!EditFieldWithCompletionSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder

    super setAttributesIn:aView with:aBuilder.
    aView showOptions: showOptions ? true

    "Created: / 09-08-2009 / 09:11:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!EditFieldWithCompletionSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock

    showOptions := aView showOptions.

    super fromView:aView callBack:aBlock

    "Created: / 09-08-2009 / 09:10:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!EditFieldWithCompletionSpec class methodsFor:'documentation'!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/EditFieldWithCompletionSpec.st,v 1.1 2011/07/01 13:30:32 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: EditFieldWithCompletionSpec.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

