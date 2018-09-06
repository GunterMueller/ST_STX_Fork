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

AbstractVersionDiffBrowserItem subclass:#AbstractRevisionItem
	instanceVariableNames:'revision'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!AbstractRevisionItem class methodsFor:'documentation'!

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

!AbstractRevisionItem class methodsFor:'instance creation'!

newForRevision:aRevision

    |theRevision|

    theRevision := self new.
    theRevision revision:aRevision.
    ^theRevision
! !

!AbstractRevisionItem methodsFor:'accessing'!

myClass

    ^self parent myClass
!

revision
    "return the value of the instance variable 'revision' (automatically generated)"

    ^ revision
!

revision:something
    "set the value of the instance variable 'revision' (automatically generated)"

    revision := something.
!

revisionString
    "return the value of the instance variable 'revision' (automatically generated)"

    self subclassResponsibility

! !

!AbstractRevisionItem methodsFor:'protocol'!

icon
"
define concrete icons for revision items in subclasses

<return: self>
"
    self subclassResponsibility
!

label
"
label is the revision string

<return: String>
"

    ^self revisionString


! !

!AbstractRevisionItem methodsFor:'testing'!

hasSourceStream
"
has the receiver a source stream? Used for testing tree items.

<return: Boolean>
"
    ^false

!

isLoadedRevision
"
do the receiver represents the actual revision of a class.

<return: Boolean>
"
    ^false



!

isRevisionItem
"
the receiver is a revision item. Used for testing tree items.

<return: Boolean>
"
    ^true

! !

!AbstractRevisionItem class methodsFor:'documentation'!

version
    ^ '$Id: AbstractRevisionItem.st 7854 2012-01-30 17:49:41Z vranyj1 $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: AbstractRevisionItem.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

