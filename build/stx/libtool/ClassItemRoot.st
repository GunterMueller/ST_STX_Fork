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

AbstractVersionDiffBrowserItem subclass:#ClassItemRoot
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!ClassItemRoot class methodsFor:'documentation'!

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

!ClassItemRoot class methodsFor:'accessing'!

classItemClass

    ^ClassItem

! !

!ClassItemRoot methodsFor:'accessing'!

classItemClass
    "return the value of the instance variable 'classItemClass' (automatically generated)"

    ^ self class classItemClass


! !

!ClassItemRoot methodsFor:'initialization'!

initialize
    super initialize.
    isExpanded := true.
! !

!ClassItemRoot methodsFor:'protocol'!

children
"
default childrens of the receiver are none. 

<return: Array>
"

    children ifNil:[
        children := self computeChildrensFor:parent dataColl.
        children do:[:eachChild | eachChild parent:self]
    ].
    ^ children

    "Modified: / 18.2.2000 / 15:02:12 / cg"
!

computeChildrensFor:aClassColl
"

<return: OrderedCollection|nil>
"

    |theClassItemColl|

    aClassColl ifNil:[^#()].
    theClassItemColl := aClassColl collect:[:eachClass |
        |theClassItem theClass|
        theClassItem := self classItemClass new.
        theClass := Smalltalk resolveName:eachClass inClass:Smalltalk.
        theClassItem myClass:theClass.
        theClassItem].
    ^theClassItemColl

!

doubleClickOn:anItem

    |listView|

    (anItem isExpandableRevisionItem and:[parent application listView sensor shiftDown])
        ifTrue: [anItem recursiveToggleExpand]
        ifFalse:[anItem toggleExpand]  
! !

!ClassItemRoot methodsFor:'queries'!

canCollapse
    ^ false

! !

!ClassItemRoot class methodsFor:'documentation'!

version
    ^ '$Id: ClassItemRoot.st 7854 2012-01-30 17:49:41Z vranyj1 $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: ClassItemRoot.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

