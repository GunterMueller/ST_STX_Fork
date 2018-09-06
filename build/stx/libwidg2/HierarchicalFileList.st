"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

HierarchicalList subclass:#HierarchicalFileList
	instanceVariableNames:'matchBlock indicatorList indicatorTask sortBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

HierarchicalItem subclass:#HierarchicalFileItem
	instanceVariableNames:'icon contentsItem'
	classVariableNames:'LastUIDToUserNameMapping LastGIDToGroupNameMapping'
	poolDictionaries:''
	privateIn:HierarchicalFileList
!

HierarchicalFileList::HierarchicalFileItem subclass:#File
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HierarchicalFileList
!

HierarchicalFileList::HierarchicalFileItem subclass:#Directory
	instanceVariableNames:'modificationTime makeIconGray quickChildrenInfo isInAccessible'
	classVariableNames:'StateUnknown StateHasChildren StateHasNoChildren StateFetching'
	poolDictionaries:''
	privateIn:HierarchicalFileList
!

HierarchicalFileList::Directory subclass:#RemoteDirectory
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HierarchicalFileList
!

!HierarchicalFileList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

!

examples
"
    open filebrowser without monitoring cycle

                                                                    [exBegin]
    |top sel list directory|

    list := HierarchicalFileList new.
    list showRoot:false.
    list matchBlock:[:fn :isDir| true ].

    directory := Filename currentDirectory.
    directory := Filename homeDirectory.

    list directory:(directory asAbsoluteFilename).

    top := StandardSystemView new; extent:300@300.
    sel := ScrollableView for:HierarchicalListView miniScroller:true
                       origin:0.0@0.0 corner:1.0@1.0 in:top.

    sel doubleClickAction:[:i| (list at:i) toggleExpand ].
    sel   indicatorAction:[:i| (list at:i) toggleExpand ].

    sel hasConstantHeight:true.
    sel list:list.

    top open.
                                                                [exEnd]


    open filebrowser and monitore contents
                                                                    [exBegin]
    |top sel list directory|

    list := HierarchicalFileList new.
    list showRoot:false.
    list matchBlock:[:fn :isDir| true ].

    directory := Filename currentDirectory.
    directory := Filename homeDirectory.

    list directory:(directory asAbsoluteFilename).

    top := StandardSystemView new; extent:300@300.
    sel := ScrollableView for:HierarchicalListView miniScroller:true
                       origin:0.0@0.0 corner:1.0@1.0 in:top.

    sel doubleClickAction:[:i| (list at:i) toggleExpand ].
    sel   indicatorAction:[:i| (list at:i) toggleExpand ].

    sel hasConstantHeight:true.
    sel list:list.
    list monitoringTaskDelay:0.5.
    top open.
                                                                [exEnd]

"
! !

!HierarchicalFileList class methodsFor:'helpers'!

forInfoItem:aItem
    "instance creation helper
    "
    | info fileType retItem|

    info := aItem info.
    fileType := aItem type.
    retItem := self itemFor:aItem fileName fileType:fileType.
    retItem fileInfo:info.
    ^ retItem
!

itemFor:aFileOrDirectoryName fileType:fileType
    "instance creation helper
    "

    fileType == #directory ifTrue:[
        ^ Directory fileName:aFileOrDirectoryName.
    ].
    fileType == #remoteDirectory ifTrue:[
        ^ RemoteDirectory fileName:aFileOrDirectoryName.
    ].

    ^ File fileName:aFileOrDirectoryName.
! !

!HierarchicalFileList methodsFor:'accessing'!

directory
    "returns the root directory or nil"

    ^ root notNil ifTrue:[root fileName] ifFalse:[nil]
!

directory:aDirectory
    "set the root directory or nil"

    self directory:aDirectory expand:true
!

directory:aDirectory expand:doExpand
    "set the root directory or nil;
     reuse old items if existent"

    |oldDir newDir oldRoot newRoot index changeToParent children|

    (     aDirectory isNil
     or:[(newDir := aDirectory asFilename) exists not]
    ) ifTrue:[
        self root:nil.
        ^ self
    ].

    newDir isDirectory ifFalse:[
        newDir := newDir directory
    ].
    newDir := newDir asCanonicalizedFilename.
    oldDir := self directory.

    oldDir = newDir ifTrue:[^ self].
    oldRoot := root.

    changeToParent := false.

    oldDir notNil ifTrue:[
        oldDir directory = newDir ifTrue:[
            changeToParent := true.
        ] ifFalse:[
            "search for existing item
            "
            self do:[:el|
                el fileName = newDir ifTrue:[
                    el parent:nil.
                    self root:el.
                    doExpand ifTrue:[ el expand ].
                    ^ self
                ].
            ].
        ].
    ].
    newRoot := HierarchicalFileItem fileName:newDir.
    newRoot setExpanded:false.  "/ to suppress change notifications
    self root:newRoot.

    children := newRoot children ? #().

    "/ disable <cd ..> handling
    changeToParent := false.

    changeToParent ifTrue:[
        index := children findFirst:[:el| el fileName = oldDir ].
        index ~~ 0 ifTrue:[ newRoot at:index put:oldRoot ].
    ].
    doExpand ifTrue:[ newRoot enforcedExpand ].
!

root:aRoot
    self criticalDo:[
        indicatorList notNil ifTrue:[
            indicatorList do:[:el| el resetFetchIndicator ].
            indicatorList removeAll.
        ]
    ].
    aRoot notNil ifTrue:[
        self showRoot ifFalse:[aRoot setExpanded:true ]
    ].
    ^ super root:aRoot
! !

!HierarchicalFileList methodsFor:'actions'!

matchBlock
    "set the matchBlock - if non-nil, it controls which files are visible."

    ^ matchBlock
!

matchBlock:aBlock
    "set the matchBlock - if non-nil, it controls which files are visible."

    matchBlock := aBlock.

    root notNil ifTrue:[
        self recursionLock critical:[
            self stopMonitoringTask.
            root matchBlockChanged.
        ].
        self startMonitoringTask.
    ].
!

sortBlock
    sortBlock notNil ifTrue:[ ^ sortBlock ].

    sortBlock := [:a :b| |aIsDir entry1 entry2 ignoreCase|
        ignoreCase := Filename isCaseSensitive not.
        aIsDir := a isDirectory.
        aIsDir == b isDirectory  
            ifTrue:[
                entry1 := a fileName name.
                entry2 := b fileName name.
                ignoreCase ifTrue:[
                    entry1 := entry1 asLowercase.
                    entry2 := entry2 asLowercase.
                ].
                entry1 <= entry2.
            ]
            ifFalse:[aIsDir].
    ].
    ^ sortBlock

    "Modified: / 13-12-2006 / 15:38:45 / User"
!

sortBlock:aBlock
    sortBlock := aBlock.

    root notNil ifTrue:[
        self recursionLock critical:[
            self stopMonitoringTask.
            root recursiveSort:aBlock.
        ].
        self startMonitoringTask.
    ].
! !

!HierarchicalFileList methodsFor:'private-monitoring task'!

monitoringCycle

    self monitoringCycle:false
!

monitoringCycle:update
    "the action performed by the monitoring task; 
     tests whether directory is expanded;
     otherwise we do not have to evaluate the directory contents.
     TODO: Think about remote file-systems"

    |index item|

    item := root.
    item isNil ifTrue:[^ self].

    self showRoot ifTrue:[ index := 2 ]         "/ root is  part of list (discard first entry)
                 ifFalse:[ index := 1 ].        "/ root not part of list

    [item notNil] whileTrue:[
        dependents size == 0 ifTrue:[ ^ self ].

        item isDirectory ifTrue:[
            update ifTrue:[
                item modificationTime:nil.
            ]. 
            item monitoringCycle.
            Processor yield.
        ].
        item  := self at:index ifAbsent:nil.
        index := index + 1.
    ].
! !

!HierarchicalFileList methodsFor:'protocol'!

childrenFor:anItem
    "returns all visible children derived from the physical
     directory contents."

    |contents list match|

    anItem isDirectory ifFalse:[^ #()].

    contents := DirectoryContents directoryNamed:anItem fileName.

    (contents isNil or:[contents isReadable not]) ifTrue:[
        anItem beInAccessible.
    ] ifFalse:[
        contents notEmpty ifTrue:[
            match := self matchBlockFor:anItem.
            match isNil ifTrue:[
                list := OrderedCollection withAll:contents.
            ] ifFalse:[
                list := OrderedCollection new.
                contents itemsDo:[:each|
                    (match value:(each fileName) value:(each isDirectory)) ifTrue:[
                        list add:(HierarchicalFileItem forContentsItem:each).
                    ]
                ].
            ].

            list notEmpty ifTrue:[
                list sort:self sortBlock.
                ^ list
            ].
        ].
    ].
    ^ #()
!

hasChildrenFor:anItem
    "returns true if the physical directory contains at least
     one visible item; otherwise false."

    |block|

    anItem isDirectory ifFalse:[
        ^ false
    ].

    (block := self matchBlockFor:anItem) isNil ifTrue:[
        block := [:aFilename :isDirectory| true ]
    ].
    ^ DirectoryContents directoryNamed:(anItem fileName) detect:block
!

matchBlockFor:anItem
    "get the matchBlock - if non-nil, it controls which files are
     visible within the physical directory"

    ^ matchBlock        
!

updateList

    self monitoringCycle:true
! !

!HierarchicalFileList methodsFor:'searching'!

findLastForFile:aPathOrFile
    "find last item which matches the path or file
     returns the item or nil if not contained in self"

    (aPathOrFile isNil or:[root isNil]) ifTrue:[
        ^ nil
    ].

    ^ self findLastForFile:aPathOrFile inRoot:root directory:(root fileName asAbsoluteFilename)

    "Modified: / 08-09-2011 / 03:58:49 / cg"
!

findLastForFile:aPathOrFile inRoot:root directory:rootDir
    "find last item which matches the path or file
     returns the item or nil if not contained in self"

    |file searchItem rootComponents searchComponents|

    (aPathOrFile isNil or:[rootDir isNil]) ifTrue:[
        ^ nil
    ].

    file := aPathOrFile asFilename.
    file exists ifFalse:[ ^ nil ].

"/    file    := file asAbsoluteFilename.

"/    (file pathName startsWith:(rootDir pathName)) ifFalse:[
    (file asString startsWith:(rootDir pathName,Filename separator)) ifFalse:[
        "not included"
        ^ nil
    ].
    rootComponents   := rootDir components.
    searchComponents := file asCanonicalizedFilename components.
    searchItem       := root.

    searchComponents from:(rootComponents size + 1) do:[:aName| |child|
        child := searchItem detect:[:el| el baseName = aName ] ifNone:nil.

        child isNil ifTrue:[ ^ searchItem ].
        searchItem := child.
    ].
    ^ searchItem

    "Created: / 08-09-2011 / 03:55:23 / cg"
! !

!HierarchicalFileList methodsFor:'update'!

startIndicatorValidationFor:anItem
    "an item will be registered for an indication update"

    |prio|

    self criticalDo:[
        indicatorList size == 0 ifTrue:[
            indicatorList := OrderedCollection new.
        ] ifFalse:[
            indicatorList removeIdentical:anItem ifAbsent:nil.
        ].
        anItem isDirectory ifTrue:[
            indicatorList add:anItem.
        ] ifFalse:[
            "/ files are added during drawing....
            indicatorList addFirst:anItem.
        ].

        indicatorTask isNil ifTrue:[
            prio := Processor activePriority.
            indicatorTask := 
                [ 
                    self updateIndicatorCycle. 
                ] newProcess.
            indicatorTask priorityRange:(prio-1 to:prio).
            indicatorTask resume.
        ]
    ].
!

stopIndicatorValidationFor:anItem
    "stop the indicator validation for an item"

    self criticalDo:[
        indicatorList notNil ifTrue:[
            indicatorList removeIdentical:anItem ifAbsent:nil.
            anItem resetFetchIndicator.
        ]
    ].
!

updateIndicatorCycle
    "run fetching indicator (hasChildren info) task cycle.
     This is done in the background to avoid long startup
     delays, in case the indicator information takes long to
     gather (i.e. when reading remote directories)"

    |repeat task item|

    repeat := true.
    task   := indicatorTask.

    [ 
        [ task notNil ] whileTrue:[
            self criticalDo:[
                (     dependents    size ~~ 0       "/ no dependencies (stop task)
                 and:[indicatorList size ~~ 0]      "/ nothing to do
                ) ifTrue:[
                    item := indicatorList removeFirst.

                    (self includesIdentical:item) ifFalse:[
                        "/ item is no longer visible
                        item resetFetchIndicator.
                        item := nil
                    ]
                ] ifFalse:[
                    item := indicatorTask := task := nil
                ]
            ].
            item notNil ifTrue:[
                item fetchIndicator.
            ].
            Processor yield.
        ]
    ] ifCurtailed:[
        task notNil ifTrue:[
            "/ oops, process terminated
            self criticalDo:[
                "/ test whether a new task already started
                indicatorTask == task ifTrue:[
                    indicatorTask := nil
                ]
            ]
        ]
    ].

    "Modified: / 27-02-2007 / 11:49:07 / cg"
! !

!HierarchicalFileList::HierarchicalFileItem class methodsFor:'instance creation'!

fileName:aFileName
    ^ self forContentsItem:(DirectoryContents contentsItemForFileName:aFileName)
!

forContentsItem:aContentsItem
    |item cls|

    cls := HierarchicalFileList::File.

    aContentsItem notNil ifTrue:[
        aContentsItem isRemoteDirectory ifTrue:[
            cls := HierarchicalFileList::RemoteDirectory
        ] ifFalse:[
            aContentsItem isDirectory ifTrue:[
                cls := HierarchicalFileList::Directory
            ]
        ].
    ].
    item := cls basicNew initialize.
    item contentsItem:aContentsItem.
    ^ item
!

new
    "instnces should not be created with new"
    self error.
! !

!HierarchicalFileList::HierarchicalFileItem methodsFor:'accessing'!

baseName
    ^ contentsItem fileName baseName.
!

contentsItem
    ^contentsItem

    "Created: / 08-05-2012 / 15:11:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contentsItem:aContentsItem
    contentsItem := aContentsItem
!

fileName
    ^ contentsItem fileName
!

fileName:aFilename
    self shouldImplement.
    contentsItem :=  DirectoryContents contentsItemForFileName:aFilename

"/    fileName = aFilename ifFalse:[
"/        fileName := aFilename.
"/        self changed:#label
"/    ].
!

fileSize
    |fileInfo|

    fileInfo := contentsItem info.
    fileInfo isNil ifTrue:[^ nil].
    ^ fileInfo fileSize
!

group
    "returns the printable group"

    |fileInfo gid group|

    fileInfo := contentsItem info.
    fileInfo notNil ifTrue:[
        gid := fileInfo gid.

        gid notNil ifTrue:[
            (LastGIDToGroupNameMapping notNil and:[gid == LastGIDToGroupNameMapping key]) ifTrue:[
                ^ LastGIDToGroupNameMapping value
            ].
            group := OperatingSystem getGroupNameFromID:gid.
            LastGIDToGroupNameMapping := gid -> group.
            ^ group
        ]
    ].
    ^ '???'
!

icon
    "returns the icon"

    icon isNil ifTrue:[
        self isRemoteDirectory ifTrue:[
            icon := MIMETypeIconLibrary iconForKeyMatching:#directoryNetwork
        ] ifFalse:[
            icon := MIMETypeIconLibrary iconForFile:(self fileName).
        ]
    ].
    ^ icon.
!

label
    "returns the printable name, the baseName"

    ^ contentsItem fileName baseName
!

modificationTime
    "returns the absolute time of modification"

    |fileInfo|

    fileInfo := contentsItem info.
    fileInfo isNil ifTrue:[^ nil].
    ^ fileInfo modificationTime
!

owner
    "returns the printable owner"

    |fileInfo uid owner|

    fileInfo := contentsItem info.
    fileInfo notNil ifTrue:[
        uid := fileInfo uid.

        uid notNil ifTrue:[
            (LastUIDToUserNameMapping notNil and:[uid == LastUIDToUserNameMapping key]) ifTrue:[
                ^ LastUIDToUserNameMapping value
            ].
            owner := OperatingSystem getUserNameFromID:uid.
            LastUIDToUserNameMapping := uid -> owner.
            ^ owner
        ]
    ].

    ^ '???'
!

pathName
    "returns the pathName"

    ^ contentsItem fileName pathName
!

permissions
    "returns the permissions as printable string"

    |fileInfo mode perms|

    fileInfo := contentsItem info.
    fileInfo notNil ifTrue:[
        mode := fileInfo mode.

        mode notNil ifTrue:[
            perms := String new:9 withAll:$-.

            1 to:9 by:3 do:[:i|
                (mode bitAt:i    ) == 1 ifTrue:[perms at:10 - i put:$x].
                (mode bitAt:i + 1) == 1 ifTrue:[perms at:9  - i put:$w].
                (mode bitAt:i + 2) == 1 ifTrue:[perms at:8  - i put:$r].
            ].
            ^ perms
        ]
    ].
    ^ '???'
!

suffix
    "returns the suffix of the file"

    (OperatingSystem isUNIXlike and:[(self baseName at:1) == $.]) ifTrue:[
        ^ ''
    ].
    ^ contentsItem fileName suffix
! !

!HierarchicalFileList::HierarchicalFileItem methodsFor:'change & update'!

changed:aParameter
    "the item changed; send a change notification"

    aParameter == #icon ifTrue:[ icon := nil ].
    super changed:aParameter.
! !

!HierarchicalFileList::HierarchicalFileItem methodsFor:'fetching'!

fetchIndicator
!

resetFetchIndicator
! !

!HierarchicalFileList::HierarchicalFileItem methodsFor:'instance creation'!

fileName:aFilename fileInfo:aFileInfoOrNil
    self shouldImplement.
"/    fileName := aFilename.
"/    fileInfo := aFileInfoOrNil.
! !

!HierarchicalFileList::HierarchicalFileItem methodsFor:'invalidate'!

invalidate
    self invalidateRepairNow:false
!

invalidateRepairNow
    self invalidateRepairNow:true
!

invalidateRepairNow:doRepair
    "invalidate the contents; dependent on the boolean
     do repair immediately
    "


!

matchBlockChanged
    "called if the matchBlock changed"
! !

!HierarchicalFileList::HierarchicalFileItem methodsFor:'printing'!

printOn:aStream
    super printOn:aStream.
    ' for: ' printOn:aStream.
    self fileName printOn:aStream
! !

!HierarchicalFileList::HierarchicalFileItem methodsFor:'protocol'!

displayIcon:anIcon atX:x y:y on:aGC
    "called to draw the icon - if the item is inaccessible
     a red cross is drawn over thge item"

    |x0 y0 y1 w|

    anIcon displayOn:aGC x:x y:y.

    self isInAccessible ifTrue:[
        aGC paint:(Color red).

        y0 := y + 1.
        y1 := y + anIcon height - 2.

        x0 := x - 1.
        w  := anIcon width.

        2 timesRepeat:[
            aGC displayLineFromX:x0 y:y0 toX:(x0 + w) y:y1.
            aGC displayLineFromX:x0 y:y1 toX:(x0 + w) y:y0.
            x0 := x0 + 1.
        ].
    ].
!

flushChildren
    "flush the children (because node is not visible)
     Can be redefined by subclass"

    children := nil.
! !

!HierarchicalFileList::HierarchicalFileItem methodsFor:'queries'!

isDirectory
    ^ false
!

isDirectoryItem
    ^ self isDirectory

    "Created: / 23-02-2007 / 12:04:37 / User"
!

isInAccessible
    "answer true if the underlaying file is not accessible - for example a directory
     than we will draw a red cross through the item..."

    ^ false
!

isRemoteDirectory
    ^ false
!

isWritable
    ^ self fileName isWritable
!

time
    ^ self valueAt:#modified
! !

!HierarchicalFileList::File methodsFor:'accessing'!

children
    "always returns an empty list
    "
    ^ #()
!

defaultIcon
     <resource: #programImage>

   ^ MIMETypeIconLibrary iconForKeyMatching:#file
!

icon
    icon isNil ifTrue:[ ^ self defaultIcon ].
    ^ icon
! !

!HierarchicalFileList::File methodsFor:'fetching'!

fetchIndicator
    |newIcon|

    icon notNil ifTrue:[^ self ].

    "/ no longer fetching icon
    icon    := self defaultIcon.    
    newIcon := MIMETypeIconLibrary iconForFile:(self fileName).

    icon ~~ newIcon ifTrue:[
        icon := newIcon.
        self iconChanged.
    ].
! !

!HierarchicalFileList::File methodsFor:'protocol'!

displayIcon:anIcon atX:x y:y on:aGC
    icon isNil ifTrue:[
        self model startIndicatorValidationFor:self.
    ].
    super displayIcon:anIcon atX:x y:y on:aGC
! !

!HierarchicalFileList::File methodsFor:'queries'!

hasChildren
    "always returns false
    "
    ^ false
! !

!HierarchicalFileList::Directory class methodsFor:'documentation'!

documentation
"
    [Instance variables:]

        fetchOperation  <Symbol/Boolean>    nil             if children is nil, no information about has children
                                            #fetching       registered in list to be updated for indication
                                            #hasChildren    registered in list to be updated for indication
                                            #hasNoChildren  has children but children list might be nil (remote)
"
! !

!HierarchicalFileList::Directory class methodsFor:'initialization'!

initialize
    StateUnknown := nil.
    StateHasChildren := #hasChildren.
    StateHasNoChildren := #hasNoChildren.
    StateFetching := #fetching

    "
     self initialize
    "
! !

!HierarchicalFileList::Directory methodsFor:'accessing'!

children
    "returns the collection of children or nil"

    |model|

    children notNil ifTrue:[ ^ children ].

    model := self model.
    model isNil ifTrue:[ ^ nil ].

    model criticalDo:[
        children isNil ifTrue:[ self readChildren ].
    ].
    ^ children
!

icon
    "returns the icon"

    |nameKey filename|

    isExpanded ifTrue:[
        makeIconGray == true ifTrue:[ nameKey := #directoryOpenGray ]
                            ifFalse:[ nameKey := #directoryOpen ].
    ] ifFalse:[
        makeIconGray == true ifTrue:[ nameKey := #directoryGray ]
    ].

    nameKey notNil ifTrue:[
        ^ MIMETypeIconLibrary iconForKeyMatching:nameKey
    ].
    icon notNil ifTrue:[^ icon ].

    filename := contentsItem fileName.

    self isRemoteDirectory ifTrue:[
        nameKey := MIMETypeIconLibrary iconKeyForRemoteDirectory:filename.
    ] ifFalse:[
        contentsItem isSymbolicLink ifTrue:[
            icon := MIMETypeIconLibrary iconForLinkedDirectory.
        ] ifFalse:[
            nameKey := filename mimeTypeFromName.
            nameKey isNil ifTrue:[ nameKey := #directory ].
            icon := MIMETypeIconLibrary iconForKeyMatching:nameKey.
        ].
    ].
    ^ icon
!

label
    "returns the printable name, the baseName
    "
    parent isHierarchicalItem ifFalse:[
        "no parent exists, thus we have to test for rootDirectory
        "
        OperatingSystem isMSWINDOWSlike ifTrue:[
            contentsItem fileName isRootDirectory ifTrue:[
                ^ contentsItem fileName pathName
            ]
        ].
    ].
    ^ contentsItem fileName baseName
!

makeIconGray:something
    "set/clear the flag which enforces the icon to be shown in grey"

    makeIconGray := something.
!

modificationTime:something
    modificationTime := something.
!

readChildren
    "reads the list of children
    "
    |model list hadChildren hasChildren|

    self forgetAboutChildren.

    model := self model.
    model isNil ifTrue:[
        "/ must reread later
        modificationTime := children := nil.
        ^ nil
    ].

    hadChildren := children size ~~ 0.

    "/ set to suppress reading of children
    children := #().
    modificationTime := self fileName modificationTime.
    model stopIndicatorValidationFor:self.

    "/ set to false - will be set by my model during reading the contents
    isInAccessible := false.
    list := model childrenFor:self.

    list size ~~ 0 ifTrue:[
        list do:[:aChild| aChild parent:self].
        children := list.
    ].
    hasChildren := children size ~~ 0.

    hasChildren ~~ hadChildren ifTrue:[
        self changed:#redraw
    ].
    ^ children
! !

!HierarchicalFileList::Directory methodsFor:'accessing-hierarchy'!

collapse
    super collapse.

    children notNil ifTrue:[
        children do:[:el| el flushChildren ]
    ].
!

expand
    "expand children; must redefine to raise a notification
     if children are not yet initialized and after initialization empty."

    super expand.
!

recursiveExpand
    "redefined to expand
    "
    self expand


! !

!HierarchicalFileList::Directory methodsFor:'fetching'!

basicFetchIndicator
    |linkName fileName hasChildren info fileItem model|

    fileName := self fileName.
    fileItem := DirectoryContents contentsItemForFileName:fileName.

    fileItem notNil ifTrue:[
        info  := fileItem info.
    ].

    (info notNil and:[info isSymbolicLink]) ifTrue:[
        linkName := info path.
    ] ifFalse:[
        linkName := fileName name.
    ].
        
    (OperatingSystem mountPoints contains:[:mp | mp mountPointPath = linkName and:[mp isRemote]]) ifTrue:[
        "do not follow mounted directories automatically (could be an NFS hardlink)"
        ^ self.
    ].

    (model := self model) notNil ifTrue:[
        isInAccessible := false.

        hasChildren := DirectoryContents
                            directoryNamed:fileName
                            detect:(model matchBlock)
                            onOpenErrorDo:[:fn| isInAccessible := true ].

    ] ifFalse:[
        hasChildren := false.
    ].
    self knownToHaveChildren:hasChildren.
    "/ self assert:children isNil.

    (children isNil and:[info notNil]) ifTrue:[
        "setup modification time to suppress monitorCycle"
        modificationTime := info modificationTime.
    ].

    "Modified: / 08-11-2006 / 17:31:16 / cg"
!

fetchIndicator
    "fetch the indicator value which indicates whether children exist or not.
     Called by the indocator update process."

    |stateBefore stateNow|

    children notNil ifTrue:[
        "/ children already read
        self knownToHaveChildren:(children size > 0).
        ^ self
    ].
    quickChildrenInfo == StateFetching ifFalse:[
        "/ children will be updated in a second....
        ^ self
    ].

    stateBefore := quickChildrenInfo.
    self basicFetchIndicator.
    stateNow := quickChildrenInfo.

    stateBefore ~~ stateNow ifTrue:[
        self changed:#redraw
    ].

"/    children notNil ifTrue:[
"/        self forgetAboutChildren.
"/        children notEmpty ifTrue:[ self changed:#redraw ].
"/    ] ifFalse:[
"/        "/ is a remote or very slow file system
"/        self isKnownToHaveChildren ifTrue:[
"/            self changed:#redraw
"/        ].
"/    ].
!

resetFetchIndicator
    "update indication cycle has deregistered the item
    "

    self forgetAboutChildren.
! !

!HierarchicalFileList::Directory methodsFor:'private'!

flushChildren
    "flush the children because the node is going to be invisible."

    children notNil ifTrue:[
        self knownToHaveChildren:(children size ~~ 0).
        children := nil.
    ] ifFalse:[
        "/ state is unknown
        self forgetAboutChildren.
    ].
! !

!HierarchicalFileList::Directory methodsFor:'private-quick children info'!

forgetAboutChildren
    quickChildrenInfo := StateUnknown
!

isChildrenInfoValid
    ^ quickChildrenInfo ~~ StateUnknown and:[quickChildrenInfo ~~ StateFetching]
!

isFetchingChildrenInfo
    ^ quickChildrenInfo == StateFetching
!

isKnownToHaveChildren
    ^ quickChildrenInfo == StateHasChildren
!

isKnownToHaveNoChildren
    ^ quickChildrenInfo == StateHasNoChildren
!

knownToHaveChildren:aBoolean
    aBoolean ifTrue:[
        quickChildrenInfo := StateHasChildren.
    ] ifFalse:[
        quickChildrenInfo := StateHasNoChildren.
    ].
!

setFetchingChildrenInfo
    quickChildrenInfo := StateFetching
! !

!HierarchicalFileList::Directory methodsFor:'queries'!

beInAccessible
    isInAccessible := true.
!

canExpand
    super canExpand ifTrue:[^ true].

    "/ in case we are currently fetching the subdirectory
"/    self isFetchingChildrenInfo ifTrue:[
"/self halt.  
"/    ].
    
    ^ false
!

hasChildren
    "returns true if children exist"

    |model|

    children notNil ifTrue:[
        self forgetAboutChildren.
        children size ~~ 0 ifTrue:[
            ^ true
        ].
        isExpanded := false.
        children := #().
        ^ false
    ].

    self isFetchingChildrenInfo ifTrue:[
        ^ true.
        "/ ^ false.
    ].
    self isChildrenInfoValid ifTrue:[
        ^ self isKnownToHaveChildren
    ].

    model := self model.

    model notNil ifTrue:[
        self setFetchingChildrenInfo.
        model startIndicatorValidationFor:self.
    ] ifFalse:[
        "/ model canbe nil if an expose event is proccessed after my underlaying model is gone
        "/ self error:'should not happen' mayProceed:true.
        'HierarchicalFileList::Directory -> hasChildren : model is unspecified' printCR.
        self forgetAboutChildren
    ].
    children size ~~ 0 ifTrue:[ ^ true].

    self isFetchingChildrenInfo ifTrue:[
        ^ true.
        "/ ^ false.
    ].
    ^ false
!

isDirectory
    "always true here"

    ^ true
!

isInAccessible
    "answer true if the directory is not accessible"

    ^ isInAccessible ? false
! !

!HierarchicalFileList::Directory methodsFor:'validation'!

invalidateRepairNow:doRepair
    "invalidate contents"

    modificationTime := nil.
    self forgetAboutChildren

    isExpanded ifFalse:[
        children := nil
    ] ifTrue:[
        doRepair ifTrue:[
            self monitoringCycle
        ] ifFalse:[
            children size == 0 ifTrue:[
                "/ expanded but no children added, thus can reset the children
                children := nil
            ]
        ]
    ].
!

matchBlockChanged
    "called if the matchBlock changed
    "
    modificationTime := nil.

    isExpanded ifFalse:[
        children := nil.
        self forgetAboutChildren
    ] ifTrue:[
        self monitoringCycle.

        children size ~~ 0 ifTrue:[
            children do:[:aChild| aChild matchBlockChanged ]
        ]
    ].
!

monitoringCycle
    "run monitoring cycle
        !!!!!!!! called by the HierarchicalList only !!!!!!!!"

    |fileName directory fileInfo unusedDict addedItems mergedList size savedModifyTime
     model timeChanged|

    contentsItem resetInfo.

    fileName  := contentsItem fileName.
    fileInfo  := contentsItem info.
    directory := fileName directory.

    fileInfo isNil ifTrue:[
        fileName exists ifFalse:[
            DirectoryContents flushCachedDirectoryFor:directory.
            self collapse.
            children := nil.
            self forgetAboutChildren.
            self changed:#hierarchy.            
        ].
        ^ self.
    ].
    savedModifyTime  := modificationTime.
    modificationTime := fileInfo modificationTime.
    timeChanged      := (savedModifyTime ~= modificationTime).

    timeChanged ifTrue:[
        |contents|

        "/ test whether the directory realy changed (rootDirectories...)
        "/ this also will flush obsolete directories....
        contents := DirectoryContents cachedDirectoryNamed:directory.

        contents notNil ifTrue:[
            savedModifyTime notNil ifTrue:[
                timeChanged := (contents includesIdentical:contentsItem) not.
            ].
        ].
    ].

    (children notNil and:[timeChanged not]) ifTrue:[
        ^ self.
    ].

    isExpanded ifFalse:[
        timeChanged ifTrue:[
            children := nil.
            self forgetAboutChildren.
            self changed:#hierarchy.
        ].
        ^ self
    ].

    children isNil ifTrue:[ children := #() ].         "/ disable update during merge

    self forgetAboutChildren.
    model := self model.
    mergedList := model childrenFor:self.

    mergedList size == 0 ifTrue:[
        self removeAll.
        ^ self
    ].

    size := children size.
    size == 0 ifTrue:[
        self addAll:mergedList.
        ^ self
    ].

    model criticalDo:[
        addedItems := OrderedCollection new:128.
        unusedDict := Dictionary new:size.

        children do:[:el| unusedDict at:(el fileName) put:el ].

        mergedList keysAndValuesDo:[:anIndex :anItem| |item|
            item := unusedDict removeKey:(anItem fileName) ifAbsent:nil.

            item notNil ifTrue:[
                mergedList at:anIndex put:item
            ] ifFalse:[
                addedItems add:anItem.
                anItem parent:self.
            ].
        ].

        unusedDict do:[:el| self remove:el ].

        addedItems notEmpty ifTrue:[
            self addAll:addedItems
        ].
        "/ children order changed test
        children := mergedList.
        self childrenOrderChanged.
    ].
!

updateList

    modificationTime := nil.
    self monitoringCycle.
! !

!HierarchicalFileList::RemoteDirectory methodsFor:'queries'!

hasChildren
    "returns true if children exist"

    children notNil ifTrue:[
        self forgetAboutChildren.
        ^ children size ~~ 0
    ].

    "/ assume that there are children;
    "/ this might be wrong and clicking on the expand-icon
    "/ will then not perform an expand, but remove the can-expand indicator.
    self knownToHaveChildren:true.
    ^ true
!

isRemoteDirectory
    ^ true
! !

!HierarchicalFileList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


HierarchicalFileList::Directory initialize!
