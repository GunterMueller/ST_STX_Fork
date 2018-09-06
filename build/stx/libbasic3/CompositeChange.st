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
"{ Package: 'stx:libbasic3' }"

Change subclass:#CompositeChange
	instanceVariableNames:'name changes'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!CompositeChange class methodsFor:'documentation'!

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

!CompositeChange class methodsFor:'instance creation'!

name: aString changes: aChangeSet

    ^self new
        name: aString;
        changes: aChangeSet;
        yourself.

    "Created: / 25-07-2009 / 19:36:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CompositeChange methodsFor:'accessing'!

changes
    ^ changes
!

changes:aChangeSet
    changes := aChangeSet.
!

name
    ^ name
!

name:aString
    name := aString.
! !

!CompositeChange methodsFor:'applying'!

apply

    changes apply

    "Modified: / 25-07-2009 / 19:41:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CompositeChange methodsFor:'enumerating'!

do: aBlock

    ^changes do: aBlock

    "Created: / 29-10-2010 / 14:03:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompositeChange methodsFor:'fileout'!

fileOutOn: aStream


    changes do:[:e|e fileOutOn: aStream]
! !

!CompositeChange methodsFor:'printing & storing'!

printOn: aStream

    ^name printOn: aStream

    "Created: / 25-07-2009 / 19:44:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !


!CompositeChange methodsFor:'testing'!

isCompositeChange

    ^true

    "Created: / 25-07-2009 / 23:17:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isOrContainsClassDefinitionChange
    ^ changes contains:[:chg | chg isOrContainsClassDefinitionChange]
! !


!CompositeChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/CompositeChange.st,v 1.5 2014-02-19 13:05:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/CompositeChange.st,v 1.5 2014-02-19 13:05:25 cg Exp $'
!

version_SVN
    ^ '$ Id: CompositeChange.st 1851 2010-10-29 14:37:22Z vranyj1  $'
! !

