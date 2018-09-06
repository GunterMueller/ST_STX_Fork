"
 COPYRIGHT (c) 2003 by eXept Software AG
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

AbstractFileBrowser subclass:#AbstractDirectoryBrowser
	instanceVariableNames:'inDropMode canDropItem browser updateToExternFileHolderLock'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!AbstractDirectoryBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Abstract class containing the common code from DirectoryTreeBrowser and
    DirectoryContentsBrowser applications.

    [Author:]
        Christian Penk
"
! !

!AbstractDirectoryBrowser class methodsFor:'queries'!

isAbstract
    ^ self == AbstractDirectoryBrowser
! !

!AbstractDirectoryBrowser methodsFor:'accessing'!

updateToExternFileHolderLock
    updateToExternFileHolderLock isNil ifTrue:[
        updateToExternFileHolderLock := self class newLock.
    ].
    ^ updateToExternFileHolderLock
! !

!AbstractDirectoryBrowser methodsFor:'drag & drop'!

canDrop:aDropContext
    ^ inDropMode and:[canDropItem]

    "Modified: / 13-10-2006 / 11:35:09 / cg"
!

doDrop:aContext 
    |col destinationPath receiver didDrop|

    destinationPath := self dropDestinationPath.

    self dropLeave:aContext.

    destinationPath isNil ifTrue:[^ self].

    aContext dropSource argument == #archivApplication ifTrue:[
        receiver := aContext dropSource receiver.
        receiver extractSelectedFilesTo:destinationPath askForExtractOptions:true.
        ^ self
    ].

    self withWaitCursorDo:[
        col := aContext dropObjects collect:[:obj | obj theObject].
        didDrop := self copyOrMoveFiles:col to:destinationPath.
        didDrop ifFalse:[
            aContext clearHasDroppedFlagToSuppressFeedBack
        ].           
    ]
!

dropDestinationPath
    self subclassResponsibility
!

dropEnter:aContext
    |dropObjects|

    self dropTargetItemChangedTo:nil in:aContext.
    inDropMode := false.

"/    self directory isNil ifTrue:[^ self].
    dropObjects := aContext dropObjects.

    dropObjects do:[:anObject| 
        |checkObject|

        anObject isFileObject ifFalse:[^ self].

        checkObject := anObject theObject.
        checkObject isFilename ifFalse:[^ self].
        (aContext dropSource argument == #archivApplication) ifFalse:[
            checkObject isSpecialFile ifTrue:[^ self].
            checkObject isReadable ifFalse:[^ self].
        ].
    ].
    inDropMode := true.
!

dropLeave:aDropContext 
    "called, when leaving the widget"

    inDropMode ifFalse:[ ^ self ].

    self dropTargetItemChangedTo:nil in:aDropContext.
    self removeExpandItemTimedBlock.
    inDropMode := false.
!

dropTargetItemChangedTo:anItem in:aContext

    self subclassResponsibility
!

getDropObjects:anArgument

    ^ self selectedFiles collect:[:file| DropObject newFile:file].
!

getLineNumberFor:aDropContext
    | yVisible|

    yVisible := (aDropContext targetPoint y).
    ^ browser yVisibleToRowNr:yVisible.
!

pushUserEvent:selector withArgument:argument
    self window sensor 
        pushUserEvent:selector 
        for:self 
        withArgument:argument
!

removeExpandItemTimedBlock
    "left blank"
! !

!AbstractDirectoryBrowser methodsFor:'file actions'!

doCopy
    "copy the selected files/directories to the clipBoard"

    self copyFilesToClipBoard:(self selectedFiles).
!

doCut
    "cut the selected files/directories to the clipBoard"

    self cutFilesToClipBoard:(self selectedFiles).
!

doDelete
    "delete the selected files/directories"

    self deleteFiles:(self selectedFiles copy).
!

doErase
    "erase the selected files"

    self eraseFiles:(self selectedFiles copy).
! !

!AbstractDirectoryBrowser methodsFor:'selection'!

selectedFiles

    ^ self selectedItems collect:[:item| item fileName].
!

selectedItems
    self subclassResponsibility
! !

!AbstractDirectoryBrowser methodsFor:'startup & release'!

initialize

    inDropMode := false.
    ^ super initialize.
!

postOpenAsSubcanvasWith:aBuilder
    "this is sent after the applications window is opened inside another application.
     Can be redefined in subclasses for actions after showing the canvas view."

    "/ cg: used to be unconditionally true hew;
    "/ but then, when a FileDialog (which is not an AbstractFileBrowser) is opened,
    "/ the commonPostBuild will not properly update its enable channels;
    "/ especially the enableDirectoryUp is false.
    "/ This whole FileBrowser is so complicated that it became almost unusable.
    "/ (too much inheritance and knowledge - DirTree and DirContents should each only do
    "/ what it should and not depend on shared functionality from their superclass)
    self postOpenFromMaster:(self masterApplication class includesBehavior:AbstractFileBrowser).
!

postOpenFromMaster:fromMaster 
    self subclassResponsibility
!

postOpenWith:aBuilder
    "this is sent after the applications main window is opened.
     Can be redefined in subclasses for actions after opening the view."

    self postOpenFromMaster:false.
!

preBuildWith:aBuilder

    self masterApplication isNil ifTrue:[
        self masterApplication:nil.
    ].
    ^ super preBuildWith:aBuilder.
! !

!AbstractDirectoryBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

