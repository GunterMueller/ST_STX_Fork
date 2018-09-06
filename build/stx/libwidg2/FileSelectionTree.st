"
 COPYRIGHT (c) 1997 by eXept Software AG 
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

SelectionInTreeView subclass:#FileSelectionTree
	instanceVariableNames:'triggerMonitorBlock monitoringDelayTime'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Trees'
!

!FileSelectionTree class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG 
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
    somewhat like a FileSelectionInList; but specialized for hierarchical (i.e. tree-like)
    lists and adds the functions to show/hide subtrees. 
    Requires SelectionInTree as model and FileSelectionItem (or compatible) list entries.

    You can define your own TreeItem instead of useing the default class FileSelectionItem
    by seting the class through to #itemClass:

    [see also:]
        FileSelectionItem
        SelectionInTree
        SelectionInTreeView
        SelectionInListView

    [author:]
        Claus Atzkern
"



!

examples
"
    open a FileSelectionTree on current directory
                                                                        [exBegin]
    |top scr|

    top := StandardSystemView new label:'select'; extent:300@500.
    scr := HVScrollableView for:FileSelectionTree origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.
    scr := scr scrolledView.

    scr directory:'/'.
    scr showDirectoryIndicator:true.
    scr showRoot:false.
    scr showLines:false.
    scr allowDrag:true.
    scr multipleSelectOk:true.

    top open
                                                                        [exEnd]


    open a FileSelectionTree useing a model
                                                                        [exBegin]
    |top scr model|

    top := StandardSystemView new label:'select'; extent:300@500.
    scr := HVScrollableView for:FileSelectionTree origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.
    scr := scr scrolledView.
    model := (Filename currentDirectory asString) asValue.
    scr rootHolder:model.
    model inspect.

    scr action:[:anIndex| Transcript showCR:anIndex.
                          Transcript showCR:scr selectedPathname.
               ].
    top open
                                                                        [exEnd]


                                                                        [exBegin]
    |top scr|

    top := StandardSystemView new label:'select'; extent:300@500.
    scr := HVScrollableView for:FileSelectionTree origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.
    scr := scr scrolledView.

    scr directory:Filename currentDirectory.
    scr selectionHolder:nil asValue.
    scr selectionHolder inspect.
    scr multipleSelectOk:true.

    scr action:[:anIndex| Transcript showCR:anIndex.
                          Transcript showCR:scr selectedPathname.
               ].
    top open
                                                                        [exEnd]



    open a FileSelectionTree on root path; show directory
    indication (open/closed), no lines and not the root
                                                                        [exBegin]
    |top scr|

    top := StandardSystemView new label:'select'; extent:300@500.
    scr := HVScrollableView for:FileSelectionTree origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.
    scr := scr scrolledView.
    scr showDirectoryIndicator:true.
    scr showLines:false.
    scr showRoot:false.

    scr directory:'/'.

    scr action:[:anIndex| Transcript showCR:anIndex.
                          Transcript showCR:scr selectedPathname.
               ].
    top open
                                                                        [exEnd]



    open a FileSelectionTree on root path; showing only files
                                                                        [exBegin]
    |top scr|

    top := StandardSystemView new label:'select'; extent:300@500.
    scr := HVScrollableView for:FileSelectionTree origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.
    scr := scr scrolledView.
    scr itemClass:(FileSelectionItem filterClassForDirectoriesOnly).
    scr directory:'/'.

    scr action:[:anIndex| Transcript showCR:anIndex.
                          Transcript showCR:scr selectedPathname.
               ].
    top open
                                                                        [exEnd]



    open a FileSelectionTree on a specified path
                                                                        [exBegin]
    |top scr|

    top := StandardSystemView new label:'select'; extent:300@500.
    scr := HVScrollableView for:FileSelectionTree origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.
    scr := scr scrolledView.
    scr directory:'/'.
    scr showLines:false.
    scr action:[:anIndex| Transcript showCR:scr selectedPathname ].
    scr doubleClickAction:[:anIndex| Transcript showCR:scr selectedPathname ].
    top open
                                                                        [exEnd]



    open a FileSelectionTree on a specified path; show or hide
    lines on doubleClick on a file (not a directory)
                                                                        [exBegin]
    |top scr|

    top := StandardSystemView new label:'select'; extent:300@500.
    scr := HVScrollableView for:FileSelectionTree origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:top.
    scr := scr scrolledView.
    scr directory:'/'.

    scr action:[:anIndex| Transcript showCR:anIndex.
                          Transcript showCR:scr selectedPathname.
               ].
    scr doubleClickAction:[:anIndex|
        |fn|
        fn := scr selectedPathname asFilename.
        fn isDirectory ifFalse:[
            scr showLines:(scr showLines not)
        ]
    ].
    top open
                                                                        [exEnd]



    example associated with a FileSelectionList
                                                                        [exBegin]
    |top tree list field label|

    top   := StandardSystemView new label:'select'; extent:600@600.
    tree  := HVScrollableView for:FileSelectionTree origin:(0.0 @ 0.0) corner:(0.5 @ 1.0) in:top.
    list  := HVScrollableView for:FileSelectionList origin:(0.5 @  25) corner:(1.0 @ 1.0) in:top.
    label := Label origin:(0.5 @ 2) in:top.
    label label:'pattern:'.
    field := EditField origin:0.5@2 in:top.
    field leftInset:(label preferredExtent x) + 5.
    field width:1.0.
    field editValue:'*'.
    field crAction:[list pattern:field editValue].

    tree  := tree scrolledView.
    list  := list scrolledView.
    list ignoreDirectories:true.
    list pattern:(field editValue).

    tree itemClass:(FileSelectionItem filterClassForDirectoriesOnly).
    tree directory:(Filename homeDirectory).
    tree showDirectoryIndicator:true.
    list directory:(tree directory).

    list action:[:index| Transcript showCR:'you selected: ' , list selectedPathname].
    tree action:[:anIndex|
        list directory:(tree selectedPathname).
    ].
    top open
                                                                        [exEnd]



    a more complex example
                                                                        [exBegin]
    |top listD listF field lbl inset|

    top   := StandardSystemView new label:'select'; extent:600@600.
    inset := 26.
    listD := HVScrollableView for:FileSelectionTree origin:(0.0 @ inset) corner:(0.5 @ 1.0) in:top.
    listF := HVScrollableView for:FileSelectionTree origin:(0.5 @ 0.0) corner:(1.0 @ 1.0) in:top.
    listD := listD scrolledView.
    listF := listF scrolledView.

    listD itemClass:(FileSelectionItem filterClassForDirectoriesOnly).
    listF itemClass:(FileSelectionItem filterClassForFilesOnly).
    listD showDirectoryIndicator:true.
    listD showLines:false.
    listF showLines:false.
    listF showRoot:false.

    lbl := Label label:'directory:' in:top.
    lbl origin:5 @ ((inset - lbl preferredExtent y) // 2).

    field := FilenameEditField in:top.
    field origin:(4 + lbl corner x) @ ((inset - field preferredExtent y) // 2).
    field width:0.5.
    field rightInset:(field origin x + 4).
    field directoriesOnly.

    field crAction:[|dir|
        dir := field editValue asFilename.

        (dir isDirectory and:[listD directory ~= dir pathName]) ifTrue:[
            listD changeDirectory:dir
        ]
    ].

    listF action:[:anIndex||file|
        (file := listF selectedPathname) notNil ifTrue:[
            Transcript showCR:'selection: ', file
        ]
    ].

    listD directory:(Filename homeDirectory).
    field editValue:listD directory.

    listD doubleClickAction:[:anIndex||path|
        path := listD selectedPathname.
        listF directory:path.
        path notNil ifTrue:[field editValue:path]
    ].
    top open
                                                                        [exEnd]
"


! !

!FileSelectionTree class methodsFor:'constants'!

monitoringDelayTime
    "default delay time of monitoring task in seconds
    "
    ^ 2
! !

!FileSelectionTree methodsFor:'accessing'!

changeDirectory:aPathname
    "change the root directory; try to reuse old hierarchy list and
     the selection in case of a single selection. The pathname must
     be a directory otherwise the root directory is set to nil
    "
    |oldSel child loc oldPath oldFile newFile newPath node idx|

    newFile := self makeLegalFilename:aPathname.
    oldPath := self directory.

    (newFile notNil 
    and:[newFile isDirectory 
    and:[oldPath notNil]]) ifFalse:[
        ^ self directory:newFile
    ].

    (newPath := newFile pathName) = oldPath ifTrue:[
        ^ self
    ].

    oldFile := oldPath asFilename.
    oldSel  := self selectedNode.

    (newPath startsWith:oldPath) ifTrue:[
        node := self detectNode:[:aNode|aNode pathName = newPath].

        node isNil ifTrue:[
            ^ self directory:newFile
        ].
    ] ifFalse:[
        (oldPath startsWith:newPath) ifFalse:[
            ^ self directory:newFile
        ].
        child := model root.

        [newPath = oldPath] whileFalse:[
            oldFile := oldFile directory.
            node    := self itemClass pathName:oldFile.
            node expand.
            loc := node children.
            idx := loc findFirst:[:el| el pathName = oldPath ].

            idx == 0 ifTrue:[
                ^ self directory:newFile
            ].

            loc at:idx put:child.
            child parent:node.
            child   := node.
            oldPath := oldFile pathName.
        ]
    ].

    node children size == 0 ifTrue:[
        oldSel := node.

        (node := node parent) isNil ifTrue:[
            ^ self directory:newFile
        ]
    ] ifFalse:[
        node isExpandable ifTrue:[
            ^ self directory:newFile
        ]
    ].

    selection := nil.        
    node parent:nil.
    model root:node.
    self  setSelection:(self indexOfNode:oldSel).
    model removeDependent:self.
    model selection:selection.
    model addDependent:self.

    "Modified: / 24.9.1998 / 13:00:09 / cg"
!

directory
    "get the full pathname of the root directory
    "
    |root|

    (root := model root) notNil ifTrue:[
        ^ root pathName
    ].
  ^ nil
!

directory:aPath
    "change the root directory of the selection tree to the full pathName,
     aPath. The pathname must be a directory otherwise the root directory
     is set to nil.
    "
    |root path isOK|

    model selection:(selection := nil).
    path := self makeLegalFilename:aPath.

    (path notNil 
    and:[path isDirectory 
    and:[path isExecutable]]) ifTrue:[
        isOK := true.
    ] ifFalse:[
        "/ special for WIN32 / VMS
        isOK := path isVolumeAbsolute
    ].
    isOK ifTrue:[
        root := self itemClass pathName:path.
        model root:root.
        model expand:root.
    ] ifFalse:[
        model root:nil
    ].

    "Modified: / 24.9.1998 / 17:43:11 / cg"
!

itemClass:anItemClass
    "set itemClass to be used
    "
    |directory old new|

    old := self itemClass.
    super itemClass:anItemClass.
    new := self itemClass.

    (old ~~ new and:[new notNil and:[(directory := self directory) notNil]]) ifTrue:[
        self directory:directory "/ recompute list
    ].

!

pathnameAtIndex:anIndex
    "returns pathname at an index or nil
    "
    |node|

    (node := self nodeAtIndex:anIndex) notNil ifTrue:[
        ^ node pathName
    ].
  ^ nil
! !

!FileSelectionTree methodsFor:'accessing-monitoring'!

monitoring
    "returns true if monitor process is running
    "
    ^ triggerMonitorBlock notNil 
!

monitoring:aState
    "enable or disable monitoring
    "
    aState ifTrue:[
        triggerMonitorBlock notNil ifTrue:[^ self].
        "/ triggerMonitorBlock := [self sensor pushUserEvent:#monitorCycle for:self].
        triggerMonitorBlock := [self pushEvent:#monitorCycle].
        Processor addTimedBlock:triggerMonitorBlock afterSeconds:(self monitoringDelayTime).
    ] ifFalse:[
        triggerMonitorBlock isNil ifTrue:[^ self].
        Processor removeTimedBlock:triggerMonitorBlock.
        triggerMonitorBlock := nil.
    ].
!

monitoringDelayTime
    "delay time of monitoring task in seconds
    "
    ^ monitoringDelayTime
!

monitoringDelayTime:seconds
    "delay time of monitoring task in seconds
    "
    seconds > 0 ifTrue:[
        monitoringDelayTime := seconds
    ]
! !

!FileSelectionTree methodsFor:'drag & drop'!

dragObjectForNode:aNode
    "returns the dragable object for a node; could be redefined in subclass
    "
    ^ DropObject new:(aNode contents)



! !

!FileSelectionTree methodsFor:'initialization'!

destroy

    triggerMonitorBlock notNil ifTrue:[
        Processor removeTimedBlock:triggerMonitorBlock.
        triggerMonitorBlock := nil
    ].
    super destroy.

!

initialize
    "setup my model and set the default path to the current directory; on default
     multiple selection is disabled.
    "
    itemClass           := FileSelectionItem.

    super initialize.

    itemClass           := FileSelectionItem.
    monitoringDelayTime := self class monitoringDelayTime.
    supportsExpandAll   := false.
! !

!FileSelectionTree methodsFor:'model'!

rootFromModel
    "update hierarchical list from root model
    "
    |newPath|

    (newPath := rootHolder value) notNil ifTrue:[
        newPath := newPath asString.
        self directory = newPath ifFalse:[
            self changeDirectory:newPath
        ]
    ].

!

selectionFromModel
    "set the selection derived from the selectionHolder
    "
    |selection value size|

    selectionHolder isNil ifTrue:[
        ^ self
    ].

    (value := selectionHolder value) isNil ifTrue:[
        ^ self deselect
    ].

    multipleSelectOk ifFalse:[
        (value isKindOf:TreeItem) ifTrue:[
            super selectionFromModel
        ] ifFalse:[
            value asFilename exists ifFalse:[
                selectionHolder value:nil
            ] ifTrue:[
                self selectPathname:value
            ]
        ].
        ^ self
    ].

    value isEmpty ifTrue:[
        ^ self deselect
    ].

    (value first isKindOf:TreeItem) ifTrue:[
        ^ super selectionFromModel
    ].
    selection := value select:[:aPath| aPath asFilename exists ].

    (size := selection size) ~~ value size ifTrue:[
        size ~~ 0 ifTrue:[selectionHolder value:selection]
                 ifFalse:[selectionHolder value:nil].
      ^ self
    ].
    selection := selection collect:[:aPath| self fileName2node:aPath ].
    model doMakeVisible:selection.
    selection := selection collect:[:el| listOfNodes identityIndexOf:el ].
    super selection:selection.
!

selectionToModel
    "write selection to selection holder
    "
    |old new|

    old := selectionHolder value.

    multipleSelectOk ifFalse:[
        (new := self pathnameAtIndex:selection) = old ifFalse:[
"/            selectionHolder value:new.
            selectionHolder value:new withoutNotifying:self.
        ]
    ] ifTrue:[
        self numberOfSelections == 0 ifTrue:[
            old size ~~ 0 ifTrue:[
                selectionHolder value:nil
            ]
        ] ifFalse:[
            new := selection collect:[:i|(listOfNodes at:i) pathName].

            new size ~~ old size ifTrue:[
                selectionHolder value:new
            ] ifFalse:[
                new do:[:pN|
                    (old includes:pN) ifFalse:[
                          ^ selectionHolder value:new
                      ]
                ]
            ]
        ]
    ]

    "Modified: / 24.9.1998 / 19:25:55 / cg"
! !

!FileSelectionTree methodsFor:'private'!

fileName2node:aFile
    |root file p1 p2|

    root := model root.
    root isNil ifTrue:[ ^ nil ].

"/    file := self makeLegalFilename:aFile.
"/    file isNil ifTrue:[ ^ nil ].

    file := aFile asFilename.

    p1 := root pathName.
    p2 := file pathName.

    (p2 startsWith:p1) ifFalse:[
        ^ nil
    ].
    p1 :=  Filename components:p1.
    p2 := (Filename components:p2) copyFrom:(p1 size).

    "/ that's a kludge for network drives
    (p2 first endsWith:$\) ifTrue:[
        (p2 first endsWith:':\') ifFalse:[
            p2 := p2 copy.
            p2 at:1 put:(p2 first copyButLast:1).
        ]
    ].

    Filename isCaseSensitive ifFalse:[
        ^ model 
            detectItem:[:aNode :name |          
                            aNode name asLowercase = name asLowercase
                            or:[ aNode fileName name = name asLowercase ]
                       ] 
            arguments:p2.
    ].

    ^ model 
        detectItem:[:aNode :name | aNode name = name ] 
        arguments:p2.

    "Modified: / 18.5.1999 / 19:30:19 / cg"
!

makeLegalFilename:aFile
    |filename|

    aFile isNil ifTrue:[ ^ nil ].

    (filename := aFile asFilename) exists ifTrue:[
        filename isDirectory ifFalse:[
            ^ filename
        ]
    ].

    ^ filename makeLegalFilename.

    "Modified: / 24.9.1998 / 12:41:29 / cg"
!

monitorCycle
    "run monitor cycle
    "
    |sz root sel new old|

    (root := model root) notNil ifTrue:[
        root hasObsoleteNodes ifTrue:[
            (root repairObsoleteNodes) ifTrue:[
                sz := self numberOfSelections.

                sz ~~ 0 ifTrue:[
                    old := self selection.

                    sz == 1 ifTrue:[
                        sel := self selectedNode
                    ] ifFalse:[
                        sel := OrderedCollection new.
                        self selectionDo:[:i| sel add:(listOfNodes at:i) ].
                    ].
                    selection := nil.
                ].
                selection := old.
                model root:root.

                sz ~~ 0 ifTrue:[
                    sz == 1 ifTrue:[
                        self selectNode:sel.
                    ] ifFalse:[
                        new := OrderedCollection new.

                        sel do:[:n||i|
                            (i := self indexOfNode:n) ~~ 0 ifTrue:[new add:i]
                        ].
                        self selection:new
                    ]
                ].
            ]
        ]
    ].

    Processor addTimedBlock:triggerMonitorBlock afterSeconds:(self monitoringDelayTime).
! !

!FileSelectionTree methodsFor:'selection'!

selectPathname:aPath
    "set selection to a path
    "
    self selectNode:(self fileName2node:aPath)
!

selectedNodeExpand:doExpand
    "collapse or expand selected node.
     Redefined to show a busy cursor while reading dirs"

    doExpand ifTrue:[
        self withWaitCursorDo:[
            super selectedNodeExpand:doExpand
        ]
    ] ifFalse:[
        super selectedNodeExpand:doExpand
    ]
!

selectedPathname
    "if there is a single selection, the full pathname of the selected
     entry will be returned otherwise nil
    "
    |node|

    (node := self selectedNode) notNil ifTrue:[
        ^ node pathName
    ].
    ^ nil
! !

!FileSelectionTree class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

