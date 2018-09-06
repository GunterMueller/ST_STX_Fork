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

AbstractRevisionItem subclass:#ExpandableRevisionItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!ExpandableRevisionItem class methodsFor:'documentation'!

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
    an item in a hierarchcal revision list

    [author:]
        Pierre Schwarz (ps@exept.de)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!ExpandableRevisionItem methodsFor:'accessing'!

icon

    ^nil
!

revisionString
    "return the value of the instance variable 'revision' (automatically generated)"

    ^ 'more revisions ...'





! !

!ExpandableRevisionItem methodsFor:'actions'!

recursiveToggleExpand

    self parent addAllRevisionsBefore:self


!

toggleExpand

    self parent addNewRevisionsBefore:self


! !

!ExpandableRevisionItem methodsFor:'testing'!

isExpandableRevisionItem
"
the receiver is a expandable revision item. Used for testing tree items.

<return: Boolean>
"
    ^true



! !

!ExpandableRevisionItem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

