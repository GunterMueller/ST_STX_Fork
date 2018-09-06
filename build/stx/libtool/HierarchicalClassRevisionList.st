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

HierarchicalList subclass:#HierarchicalClassRevisionList
	instanceVariableNames:'itemComputationList semaphoreCritical itemTask currentItemInTask
		dataColl'
	classVariableNames:'Lobby'
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!HierarchicalClassRevisionList class methodsFor:'documentation'!

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

!HierarchicalClassRevisionList class methodsFor:'instance creation'!

new

    ^ super new initialize
! !

!HierarchicalClassRevisionList methodsFor:'accessing'!

dataColl
    "return the value of the instance variable 'classRevisionColl' (automatically generated)"

    ^ dataColl
!

dataColl:something
    "set the value of the instance variable 'classRevisionColl' (automatically generated)"

    dataColl := something.
!

icons
"

<return: Dictionary of: Symbol->Image>
"
    |icons|

    icons := Dictionary new.
    icons at:#loadedRevision put:(Smalltalk imageFromFileNamed:'red_ball.xpm' forClass:self class).
    icons at:#unloadedRevision put:(Smalltalk imageFromFileNamed:'green_ball.xpm' forClass:self class).
    icons at:#unloadedClassItem put:(Smalltalk imageFromFileNamed:'small_folder_yellow_grey1.xpm' forClass:self class).
    icons at:#loadingClassItem put:(Smalltalk imageFromFileNamed:'small_folder_yellow_search.xpm' forClass:self class).
    icons at:#loadedClassItem put:(Smalltalk imageFromFileNamed:'small_folder_yellow.xpm' forClass:self class).
    ^icons


!

itemComputationList

    ^ itemComputationList ifNil:[itemComputationList := IdentitySet new]

!

semaphoreCritical
    "return the value of the instance variable 'semaphoreCritical' (automatically generated)"

    ^ semaphoreCritical ifNil:[semaphoreCritical := RecursionLock new]

! !

!HierarchicalClassRevisionList methodsFor:'finalization'!

disposed

    self stopItemTask.    
    Lobby unregister:self.


! !

!HierarchicalClassRevisionList methodsFor:'initialization'!

initialize

    self showRoot:false.
    dataColl := OrderedCollection new.
    self root:ClassItemRootForRevision new.
    Lobby ifNil:[
        Lobby := Registry new.
    ].
    Lobby register:self.

! !

!HierarchicalClassRevisionList methodsFor:'protocol'!

getDataForItem: anItem

    self semaphoreCritical critical:[
        |theList|
        currentItemInTask == anItem ifTrue:[^self].
        (theList := self itemComputationList) removeIdentical:anItem ifAbsent:[nil].
        theList add:anItem.
        self startItemTask]

!

itemTaskCycle

    |theItem|

    [
        theItem := nil.
        self semaphoreCritical critical:[
            self itemComputationList notEmpty
                ifTrue:[theItem := self itemComputationList remove:(self itemComputationList last) ifAbsent:[nil]]
        ].
        (theItem notNil and:[theItem needsChildren])ifTrue:[
            currentItemInTask:=theItem.
            theItem computeRevisions.
            currentItemInTask:=nil
        ].
        theItem notNil
    ] whileTrue.

!

newData: aClassRevisionColl

    dataColl := aClassRevisionColl.
    self root:ClassItemRootForRevision new.


!

startItemTask

    self semaphoreCritical critical:[
        itemTask ifNil:[
            itemTask := Process for:[
                                            self itemTaskCycle
                                        ]
                               priority:(Processor userBackgroundPriority).
            itemTask addExitAction:[itemTask := nil].
            itemTask resume.
        ].
    ].

!

stopItemTask
    |task|

    self semaphoreCritical critical:[
        (task := itemTask) notNil ifTrue:[
            itemTask := nil.
            Exception handle:[:ex|] do:[
                task terminateWithAllSubprocesses.
                task waitUntilTerminated.
            ]
        ]
    ].


! !

!HierarchicalClassRevisionList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/HierarchicalClassRevisionList.st,v 1.3 2000/02/18 14:08:26 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

