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

AbstractVersionDiffBrowserItem subclass:#ClassItem
	instanceVariableNames:'myClass isRegistered revisonColl revisionInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!ClassItem class methodsFor:'documentation'!

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

!ClassItem class methodsFor:'protocol'!

expandableRevisionItemClass

    ^ExpandableRevisionItem
!

sourceRevisonItemClass

    ^SourceRevisionItem
!

versionRevisionItemClass

    ^VersionRevisionItem
! !

!ClassItem methodsFor:'accessing'!

loadedRevisionItem

    ^children detect:[:eachRevision | eachRevision isLoadedRevision]
!

myClass
    "return the value of the instance variable 'myClass' (automatically generated)"

    ^ myClass
!

myClass:something
    "set the value of the instance variable 'myClass' (automatically generated)"

    myClass := something.
!

needsChildren
    "return the value of the instance variable 'isRegistered' (automatically generated)"

    ^ children size == 0
!

revisonColl
    "return the value of the instance variable 'revisonColl' (automatically generated)"

    ^ revisonColl
!

revisonColl:something
    "set the value of the instance variable 'revisonColl' (automatically generated)"

    revisonColl := something.
! !

!ClassItem methodsFor:'initialization'!

initialize
"
initialize necessary things

<return: self>
"
    super initialize.
    isRegistered := false
! !

!ClassItem methodsFor:'private'!

addAllRevisionsBefore:anExpandableRevisonItem


    |theChildrens theStartIndex theStopIndex theRevisionSize|

    (theStartIndex := children size) <= (theRevisionSize := revisonColl size) ifTrue:[
        theStopIndex := theRevisionSize.
        theChildrens := revisonColl copyFrom:theStartIndex to:theStopIndex.
        "remove expandable item"
        self remove:anExpandableRevisonItem.
        "add items"
        self addAll:theChildrens.
    ]
!

addNewRevisionsBefore:anExpandableRevisonItem


    |theChildrens theStartIndex theStopIndex|

    (theStartIndex := children size) <= revisonColl size ifTrue:[
        theStopIndex := (theStartIndex-1) * 2 + (theStartIndex-1).
        theStopIndex := theStopIndex min:revisonColl size.
        theChildrens := revisonColl copyFrom:theStartIndex to:theStopIndex.
        "add items"
        self addAll:theChildrens before:anExpandableRevisonItem.
        "check if all revisions are shown, if true remove expandable item"
        (theStopIndex = revisonColl size) ifTrue:[self remove:anExpandableRevisonItem].
    ]
!

setRevisionInfo:aRevisionInfo

    aRevisionInfo removeKey:#revisions.
    revisionInfo := aRevisionInfo
! !

!ClassItem methodsFor:'protocol'!

children
"returns list of children. The revision for the class myClass
are computed via the sourcecode manager. Only when the childrens
are needed, they are calculated.

<return: nil|List>
"  

    isRegistered ifFalse:[
        isRegistered := true.
        self application getRevisionInfoForClassItem:self.
        self changed:#icon
    ].
    ^children

!

computeRevisions

    |theClass theSourceCodeManager theRevisionLog|

    theClass := self myClass. 
    (theSourceCodeManager := theClass sourceCodeManager) isNil
        ifFalse:[theRevisionLog := theSourceCodeManager revisionLogOf:theClass].
    self setRevisions:theRevisionLog
!

hasChildren
"a class items has always childs

<return: Boolean>
"

     ^true
!

icon
    isRegistered ifFalse:[^#unloadedClassItem].
    (isRegistered and:[children size ~~ 0]) ifTrue:[
        ^#loadedClassItem 
    ].
    ^#loadingClassItem
!

label

   ^myClass name


!

newestRevision

    revisionInfo ifNil:[^''].
    ^revisionInfo at:#newestRevision


!

setChildrensFromRevisionColl

    |theChildrens|

    revisonColl size > 5
        ifTrue:[
            theChildrens := revisonColl copyFrom:1 to:5.
            theChildrens add:self class expandableRevisionItemClass new.
            ]
        ifFalse:[theChildrens:=revisonColl].
    self addAll:theChildrens
!

setRevisions:aRevisionInfo

    aRevisionInfo isNil
        ifTrue: [revisonColl := Array with:(self class sourceRevisonItemClass newForRevision:nil)]
        ifFalse:[revisonColl := (aRevisionInfo at:#revisions) collect:[:eachRevision|
                    self class versionRevisionItemClass newForRevision:eachRevision].
                self isMyClassChanged
                    ifTrue:[revisonColl addFirst:(self class sourceRevisonItemClass newForRevision:myClass revisionInfo)].
                self setRevisionInfo:aRevisionInfo].
     self setChildrensFromRevisionColl.
! !

!ClassItem methodsFor:'testing'!

isClassItem
"
Used for testing tree items. Define correct behaviour in subclasses

<return: Boolean>
"

    ^true


!

isMyClassChanged

    ^Project isClassChanged: myClass  
! !

!ClassItem class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/ClassItem.st,v 1.8 2000/02/18 14:09:35 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

