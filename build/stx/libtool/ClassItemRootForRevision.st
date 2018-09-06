"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

ClassItemRoot subclass:#ClassItemRootForRevision
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!ClassItemRootForRevision class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    This is not yet finished (work in progress) - do not use.

    [author:]
        Pierre Schwarz (ps@exept.de)

    [see also:]

    [instance variables:]

    [class variables:]
"

! !

!ClassItemRootForRevision class methodsFor:'accessing'!

classItemClass

    ^ClassNameItem



! !

!ClassItemRootForRevision methodsFor:'protocol'!

computeChildrensFor:aClassRevisionColl
"

<return: OrderedCollection|nil>
"
    |theClassItemColl|

    aClassRevisionColl ifNil:[^#()].
    theClassItemColl := aClassRevisionColl collect:[:eachClassRevision |
        |theClassItem theClass|
        theClassItem := self classItemClass new.
        theClassItem revisionInfo:eachClassRevision.
        theClassItem].
    ^theClassItemColl

    "Modified: / 18.2.2000 / 15:04:31 / cg"
!

doubleClickOn:anItem



! !

!ClassItemRootForRevision class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/ClassItemRootForRevision.st,v 1.3 2000/02/18 14:09:10 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

