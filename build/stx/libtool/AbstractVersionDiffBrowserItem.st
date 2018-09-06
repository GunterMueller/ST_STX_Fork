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

HierarchicalItem subclass:#AbstractVersionDiffBrowserItem
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!AbstractVersionDiffBrowserItem class methodsFor:'documentation'!

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

!AbstractVersionDiffBrowserItem methodsFor:'protocol'!

children
"
default childrens of the receiver are none. 

<return: Array>
"

    children isNil ifTrue:[
        children := #()
    ].
    ^ children






!

icon
"
use the default icon for the receiver. 

<return: nil>
"

   ^ nil


!

label
"
no label for the receiver. 

<return: nil>
"

    ^ nil

!

middleButtonMenu
"returns the middleButtonMenu or nil if no menu is defined

<return: nil>
"
    ^ nil

! !

!AbstractVersionDiffBrowserItem methodsFor:'testing'!

isClassItem
"
Used for testing tree items. Define correct behaviour in subclasses

<return: Boolean>
"

    ^false
!

isExpandableRevisionItem
"
the receiver is a expandable revision item. Used for testing tree items.

<return: Boolean>
"
    ^false




!

isRevisionItem
"
Used for testing tree items. Define correct behaviour in subclasses

<return: Boolean>
"

    ^false
!

isSourceRevisionItem
"
Used for testing tree items. Define correct behaviour in subclasses

<return: Boolean>
"

    ^false
! !

!AbstractVersionDiffBrowserItem class methodsFor:'documentation'!

version
    ^ '$Id: AbstractVersionDiffBrowserItem.st 7854 2012-01-30 17:49:41Z vranyj1 $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: AbstractVersionDiffBrowserItem.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

