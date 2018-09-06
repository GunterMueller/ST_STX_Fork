"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

SelectionInListView subclass:#FileSelectionList
	instanceVariableNames:'pattern directory timeStamp directoryId directoryName
		directoryContents directoryFileTypes realAction matchBlock
		stayInDirectory ignoreParentDirectory markDirectories
		ignoreDirectories directoryChangeCheckBlock quickDirectoryChange
		directoryChangeAction directorySelectAction fileSelectAction
		ignoreFiles directoryHolder directoryStack ignoreCaseInPattern'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Lists'
!

!FileSelectionList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    this class implements file selection lists - its basically a
    selection-in-list-view, but adds some right-arrows to directories.
    (and will soon remember the previous position when changing directories).
    You can specify an optional filename-pattern (such as '*.st') and an
    optional matchBlock (such as: [:name | name startsWith:'A']).

    Only files (plus directories) matching the pattern (if present) and
    for which the matchBlock returns true (if present), are shown.

    Except for file-browser like applications, FileSelectionLists are almost 
    exclusively used with FileSelectionBoxes (see examples there).

    [Instance variables:]
            pattern                 the matchpattern

            directory               the current directory

            timeStamp               the time, when directoryContents was last taken

            directoryId             the directories id (inode-nr) when it was taken

            directoryName           the path when it was taken

            directoryContents       (cached) contents of current directory

            directoryFileTypes      (cached) isDirectory-boolean per entry

            fileTypes               file types as shown in list (i.e only matching ones)

            matchBlock              if non-nil: block evaluated per full filename;
                                    only files for which matchBlock returns true are shown.

            realAction              (internal) the action to perform when a file is selected

            quickDirectoryChange    if true, directories can be changed with a single click
                                    if false (the default), they need a double click.
                                    Makes sense if a directory is what we are interested in,
                                    for files its better to leave it as false.

            stayInDirectory         if true, no directoryChanges are allowed.
                                    Makes sense to limit the user to choose among certain files.    
                                    The default is false.

            ignoreParentDirectory   if true, the parent directory is not shown.
                                    Makes sense to limit the user to files below the initial
                                    directory. Default is false.

            ignoreDirectories       if true, no directories are shown at all.
                                    Makes sense to limit the user to choose among regular files.
                                    Default is false.

            ignoreFiles             if true, no regular files are shown at all.
                                    Makes sense to limit the user to choose among directories files.
                                    Default is false.

            directoryChangeCheckBlock 
                                    if nonNil, directoryChanges are only allowed if this block
                                    returns true. It is evaluated with one argument, the pathName.
                                    Defaults to nil (i.e. no checks).

            directorySelectAction 
                                    if nonNil, a directory-select evaluate this block.
                                    Possible hook for others (used with Boxes)
                                    Defaults to nil.

            fileSelectAction 
                                    if nonNil, file-select evaluate this block.
                                    Possible hook for others (used with Boxes)
                                    Defaults to nil.

    [author:]
        Claus Gittinger

    [see also:]
        DialogBox
        EnterBox2 YesNoBox
        ListSelectionBox FileSelectionBox FileSaveBox 
"
!

examples 
"
    FileSelectionLists are typically used in FileSelectionBoxes,
    or file-browser-like applications.
    Thus, the following examples are a bit untypical.

    example (plain file-list):
                                                                        [exBegin]
        |list|

        list := FileSelectionList new.
        list open
                                                                        [exEnd]


    setting a directory holder:
                                                                        [exBegin]
        |holder list|

        holder := '/etc' asValue.
        list := FileSelectionList new.
        list directoryHolder:holder.
        list open.

        (EditField on:holder) open.
                                                                        [exEnd]


    scrolled & some action:
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]

    ignore the parentDirectory:
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list ignoreParentDirectory:true.
        top open
                                                                        [exEnd]

    ignore all directories (i.e. regular files only):
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list ignoreDirectories:true.
        top open
                                                                        [exEnd]

    ignore all regular files (i.e. directories only):
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list ignoreFiles:true.
        top open
                                                                        [exEnd]

    don't show the directory arrow-mark:
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list markDirectories:false.
        top open
                                                                        [exEnd]

    adds a pattern, only showing .st files and directories:
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list pattern:'*.st'.
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]

    a more complicated pattern:
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list pattern:'[A-D]*.st'.
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]

    adds a matchblock to show only writable files:
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list matchBlock:[:name | 
                            |fileName|
                            fileName := name asFilename.
                            fileName isWritable or:[fileName isDirectory]
                        ].
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]

    adds a matchblock to suppress directories:
    (this can be done easier with #ignoreDirectories)
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list matchBlock:[:name | 
                            name asFilename isDirectory not
                        ].
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]

    the above can be done more convenient:
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list ignoreDirectories:true.
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]

    adds a matchblock to block parent dirs (i.e. only allow files here & below):
    (can be done easier with #ignoreParentDirectory)
                                                                        [exBegin]
        |top v list currentDir|

        currentDir := '.' asFilename pathName.

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list matchBlock:[:name | 
                            ((name endsWith:'/..') and:[list directory pathName = currentDir]) not
                        ].
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]

    do not allow changing up AND show all .rc-files only:
    (but allow going down)
                                                                        [exBegin]
        |top v list currentDir|

        currentDir := '.' asFilename pathName.

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list pattern:'*.rc'.
        list matchBlock:[:name |  
                            ((name endsWith:'/..') and:[list directory pathName = currentDir]) not
                        ].
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]

    show only .rc-files in current directory:
                                                                        [exBegin]
        |top v list currentDir|

        currentDir := '.' asFilename pathName.

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list pattern:'*.rc'.
        list matchBlock:[:name | 
                            name asFilename isDirectory not
                        ].
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]

    show only h*-files in /etc; don't allow directory changes:
                                                                        [exBegin]
        |top v list|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list directory:'/etc'.
        list pattern:'h*'.
        list matchBlock:[:name | name printNL.
                            name asFilename isDirectory not
                        ].
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]

    only allow changing into directories below the current one; i.e. not up;
    but show it
                                                                        [exBegin]
        |top v list here|

        top := StandardSystemView new.
        top extent:(300 @ 200).
        v := ScrollableView for:FileSelectionList in:top.
        v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        list := v scrolledView.
        list directoryChangeCheckBlock:[:dirPath |
                        dirPath asFilename pathName
                            startsWith:Filename currentDirectory pathName].
        list action:[:index | Transcript showCR:'you selected: ' , list selectionValue].
        top open
                                                                        [exEnd]


    living in a box:
                                                                        [exBegin]
        |box listView|

        box := Dialog new.
        box addTextLabel:'which file ?'.

        listView := box 
                        addListBoxOn:nil 
                        class:FileSelectionList
                        withNumberOfLines:10 
                        hScrollable:false 
                        vScrollable:true.

        box addAbortButton; addOkButton.
        box stickAtBottomWithVariableHeight:listView.
        box open.
        box accepted ifTrue:[
            Transcript showCR:listView selectedPathname
        ]
                                                                        [exEnd]


    living in a box (local files only, no directory change allowed):
                                                                        [exBegin]
        |box listView|

        box := Dialog new.
        box addTextLabel:'which file ?'.

        listView := box 
                        addListBoxOn:nil 
                        class:FileSelectionList
                        withNumberOfLines:10 
                        hScrollable:false 
                        vScrollable:true.

        listView ignoreDirectories:true.
        listView ignoreParentDirectory:true.

        box addAbortButton; addOkButton.
        box stickAtBottomWithVariableHeight:listView.
        box open.
        box accepted ifTrue:[
            Transcript showCR:listView selectedPathname
        ]
                                                                        [exEnd]


    living in a box (local files only; immediately show owner in another field):
                                                                        [exBegin]
        |box listView lbl|

        box := Dialog new.
        box addTextLabel:'which file ?'.

        listView := box 
                        addListBoxOn:nil 
                        class:FileSelectionList
                        withNumberOfLines:10 
                        hScrollable:false 
                        vScrollable:true.

        lbl := box addTextLabel:''.
        lbl adjust:#left.

        listView fileSelectAction:[:index |
            |ownerId owner|

            ownerId := listView selectedPathname asFilename info at:#uid.
            ownerId == OperatingSystem getUserID ifTrue:[
                lbl label:('one of yours').
            ] ifFalse:[
                owner := OperatingSystem getUserNameFromID:ownerId.
                lbl label:(owner , '''s property').
            ]
        ].

        listView directorySelectAction:[:index |
            |ownerId owner|

            ownerId := listView selectedPathname asFilename info at:#uid.
            ownerId == OperatingSystem getUserID ifTrue:[
                lbl label:('your files there').
            ] ifFalse:[
                owner := OperatingSystem getUserNameFromID:ownerId.
                lbl label:(owner , '''s files there').
            ]    
        ].

        box addAbortButton; addOkButton.
        box stickAtBottomWithFixHeight:lbl.
        box stickAtBottomWithVariableHeight:listView.
        box open.
        box accepted ifTrue:[
            Transcript showCR:listView selectedPathname
        ]
                                                                        [exEnd]
"
! !

!FileSelectionList methodsFor:'accessing-behavior'!

action:aBlock
    "set the action to be performed on a selection"

    realAction := aBlock
!

directoryChangeAction:aBlock
    "set the action to be performed on a directory change"

    directoryChangeAction := aBlock

    "Created: 5.3.1996 / 02:37:08 / cg"
!

directoryChangeCheckBlock:aBlock
    "set the directoryChangeCheckBlock - if non-nil, it controls if
     a directory change is legal."

    directoryChangeCheckBlock := aBlock
!

directorySelectAction:aBlock
    "set the action to be performed when a directory is selected.
     Useful if someone else wants to show additional information
     (readable/owner ...) somewhere."

    directorySelectAction := aBlock

    "Created: 18.4.1996 / 18:45:13 / cg"
!

fileSelectAction:aBlock
    "set the action to be performed when a file is selected.
     Useful if someone else wants to show additional information
     (readable/owner ...) somewhere."

    fileSelectAction := aBlock

    "Created: 18.4.1996 / 18:45:24 / cg"
!

ignoreCaseInPattern:aBoolean
    "set/clear the flag which controls if the pattern match is caseless.
     if it changes, update the list.
     The default is true for systems, where filenames are caseless (i.e. msdos-based)."

    ignoreCaseInPattern ~= aBoolean ifTrue:[
        ignoreCaseInPattern := aBoolean.
        realized ifTrue:[
            self updateList
        ].
    ].
!

ignoreDirectories:aBoolean
    "set/clear the flag which controls if directories are ignored
     (i.e. hidden). The default is false (i.e. dirs are shown)"

    ignoreDirectories := aBoolean
!

ignoreFiles:aBoolean
    "set/clear the flag which controls if plain files are ignored
     (i.e. hidden). The default is false (i.e. they are shown)"

    ignoreFiles := aBoolean

    "Created: 18.4.1996 / 18:48:43 / cg"
    "Modified: 18.4.1996 / 18:49:23 / cg"
!

ignoreParentDirectory:aBoolean
    "set/clear the flag which controls if the parent directory (..)
     is shown in the list. The default is false (i.e. show it)"

    ignoreParentDirectory := aBoolean
!

markDirectories:aBoolean
    "turn on/off marking of directories with an arrow.
     The default is on"

     markDirectories := aBoolean
!

matchBlock:aBlock
    "set the matchBlock - if non-nil, it controls which
     names are shown in the list."

    matchBlock := aBlock
!

pattern:aPattern
    "set the pattern - if it changes, update the list."

    pattern ~= aPattern ifTrue:[
	pattern := aPattern.
	realized ifTrue:[
	    self updateList
	].
    ].
!

quickDirectoryChange:aBoolean
    "set/clear quick change (i.e. chdir with single click).
     The default is false (i.e. double click is required)"

    quickDirectoryChange := aBoolean

    "Created: 4.3.1996 / 17:37:58 / cg"
!

stayInDirectory:aBoolean
    "set/clear the flag which controls if selecting a directory
     should locally change (if false) or be handled just like
     the selection of a file (if true).
     The default is false (i.e. change and do not tell via action)"

    stayInDirectory := aBoolean
! !

!FileSelectionList methodsFor:'accessing-channels'!

directoryHolder:aValueHolder
    directoryHolder := aValueHolder.
    directoryHolder onChangeSend:#directoryHolderChange to:self.
    self directoryHolderChange

    "Modified: 20.9.1997 / 13:16:58 / cg"
! !

!FileSelectionList methodsFor:'accessing-contents'!

directory
    "return the shown directory"

    ^ directory
!

directory:nameOrDirectory
    "set the lists contents to the filenames in the directory.
     This does not validate the change with any directoryChangeBlock."

    |oldPath f|

    nameOrDirectory isNil ifTrue:[
        directory := nil.
        directoryHolder notNil ifTrue:[directoryHolder value:directory].
        ^ self updateList
    ].
    directory notNil ifTrue:[
        oldPath := directory pathName.
    ].
    directory := nameOrDirectory asFilename.
    (directory exists 
    and:[directory isDirectory]) ifFalse:[
        directory := Filename currentDirectory
    ].
    directoryHolder notNil ifTrue:[directoryHolder value:directory].
    realized ifTrue:[
        (directory pathName = oldPath) ifFalse:[
            self updateList
        ]
    ]

    "Modified: 18.9.1997 / 23:42:27 / stefan"
    "Modified: 20.9.1997 / 13:29:02 / cg"
!

selectedPathname
    "if there is a selection, return its full pathname.
     Of there is no selection, return nil."

    |sel|

    sel := self selectionValue.
    sel isNil ifTrue:[^ nil].
    ^ directory constructString:sel.

    "Modified: 7.9.1997 / 23:49:01 / cg"
    "Modified: 18.9.1997 / 23:49:16 / stefan"
! !

!FileSelectionList methodsFor:'drawing'!

redrawFromVisibleLine:startVisLineNr to:endVisLineNr
    "redefined to look for directory in every line"

    |l|

    "first, draw chunk of lines"
    super redrawFromVisibleLine:startVisLineNr to:endVisLineNr.
    markDirectories ifFalse:[^ self].

    "then draw marks"
    startVisLineNr to:endVisLineNr do:[:visLineNr |
        l := self visibleLineToListLine:visLineNr.
        l notNil ifTrue:[
            (directoryFileTypes at:l) ifTrue:[
                self drawRightArrowInVisibleLine:visLineNr
            ]
        ]
    ]

    "Modified: / 22.9.1998 / 12:32:24 / cg"
!

redrawVisibleLine:visLineNr
    "if the line is one for a directory, draw a right arrow"

    |l|

    super redrawVisibleLine:visLineNr.
    markDirectories ifFalse:[^ self].

    l := self visibleLineToListLine:visLineNr.
    l notNil ifTrue:[
        (directoryFileTypes at:l) ifTrue:[
            self drawRightArrowInVisibleLine:visLineNr
        ]
    ]

    "Modified: / 22.9.1998 / 12:32:34 / cg"
! !

!FileSelectionList methodsFor:'events'!

directoryHolderChange
    self directory:directoryHolder value.

    "Created: 20.9.1997 / 13:12:45 / cg"
!

doubleClicked
    self selectionIsDirectory ifTrue:[
        stayInDirectory ifFalse:[
            quickDirectoryChange ifFalse:[
                directoryChangeAction notNil ifTrue:[
                    directoryChangeAction value:self selection
                ] ifFalse:[
                    self changeDirectory
                ]
            ]
        ].
        ^ self
    ].
    super doubleClicked

    "Created: 4.3.1996 / 17:39:58 / cg"
    "Modified: 5.3.1996 / 02:38:06 / cg"
!

keyPress:key x:x y:y
    "handle cursor-left and cursor-right keys"

    <resource: #keyboard (#CursorLeft #CursorRight)>

    key == #CursorLeft ifTrue:[
        self changeToParentDirectory.
        ^ self
    ].
    (key == #CursorRight) ifTrue:[
        self changeToPreviousDirectory.
        ^ self
    ].
    super keyPress:key x:x y:y
!

selectionChanged
    "if the selection changed, check for it being a directory
     and possibly go there. If its not a directory, perform the realAction."

    self selection isCollection ifFalse:[
        self selectionIsDirectory ifTrue:[
            (stayInDirectory not and:[quickDirectoryChange]) ifTrue:[
                directoryChangeAction notNil ifTrue:[
                    directoryChangeAction value:self selection
                ] ifFalse:[
                    self changeDirectory
                ]
            ] ifFalse:[
                directorySelectAction notNil ifTrue:[
                    directorySelectAction value:self selection
                ]
            ]
        ] ifFalse:[
            realAction notNil ifTrue:[
                realAction value:self selection
            ].
            fileSelectAction notNil ifTrue:[
                fileSelectAction value:self selection
            ]
        ]
    ]

    "Modified: 18.4.1996 / 18:44:30 / cg"
!

sizeChanged:how
    "redraw marks if any"

    super sizeChanged:how.
    markDirectories ifTrue:[
        self invalidate
    ]

    "Modified: 29.5.1996 / 16:15:12 / cg"
! !

!FileSelectionList methodsFor:'initialization'!

initialize
    directory := Filename currentDirectory.
    stayInDirectory := ignoreParentDirectory := ignoreDirectories := false.
    ignoreFiles := quickDirectoryChange := false.
    markDirectories := true.
    super initialize.

    pattern := '*'.
    ignoreCaseInPattern := Filename isCaseSensitive not.
    self initializeAction.

    "nontypical use ..."
    "
     FileSelectionList new open
     (FileSelectionList new directory:'/etc') open
     (ScrollableView for:FileSelectionList) open
     (HVScrollableView for:FileSelectionList) open
    "

    "Modified: 18.4.1996 / 18:49:19 / cg"
    "Modified: 18.9.1997 / 18:52:03 / stefan"
!

initializeAction
    "setup action as: selections in list get forwarded to enterfield if not 
     a directory; otherwise directory is changed"

    actionBlock := [:lineNr | self selectionChanged].
"/    doubleClickActionBlock := [:lineNr | self selectionChanged].

    "Modified: 4.3.1996 / 17:39:08 / cg"
!

reinitialize
    directory := Filename currentDirectory.
    super reinitialize

    "Modified: 18.9.1997 / 18:52:16 / stefan"
! !

!FileSelectionList methodsFor:'private'!

changeDirectory
    "change directory to the selected one"

    |entry|

    entry := self selectionValue.
    (entry isEmptyOrNil) ifTrue:[^ self].

    (self changeDirectoryTo:entry) ifFalse:[^ self].

    directoryStack := nil.
!

changeDirectoryTo:newDirectory
    "change directory; check if allowed; return true if change was ok"

    |entry ok newDir warnMessage oldDir|

    entry := newDirectory.
    (entry endsWith:' ...') ifTrue:[
        entry := entry copyButLast:4.
    ].

    ok := false.
    oldDir := directory baseName.
    entry asFilename isAbsolute ifTrue:[
        newDir := entry asFilename.
    ] ifFalse:[
        newDir := directory construct:entry.
    ].
    (directoryChangeCheckBlock isNil
    or:[directoryChangeCheckBlock value:newDir]) ifTrue:[
        newDir isReadable ifFalse:[
            warnMessage := 'No permission to read directory "%1" !!'
        ] ifTrue:[
            newDir isExecutable ifFalse:[
                warnMessage := 'No permission to enter directory "%1" !!'
            ] ifTrue:[
                ok := true.
            ]
        ].
    ].
    ok ifFalse:[
        warnMessage notNil ifTrue:[
            self warn:warnMessage with:entry.
        ].
        self setSelection:nil
    ] ifTrue:[
        self directory:newDir.
        entry = '..' ifTrue:[
            self setSelectElement:oldDir 
        ].
    ].
    ^ ok

    "Modified: / 23-01-2012 / 18:16:19 / cg"
!

changeToParentDirectory
    "change to the parent directory"

    |current parent|

    current := self directory asFilename.
    parent := current directory.
    parent = current ifTrue:[^ false].

    (self changeDirectoryTo:'..') ifFalse:[^ false].

    directoryStack isNil ifTrue:[
        directoryStack := OrderedCollection new.
    ].
    directoryStack addFirst:current pathName
!

changeToPreviousDirectory
    "change to the previous directory"

    |current previous|

    directoryStack size == 0 ifTrue:[^ false].

    previous := directoryStack removeFirst.

    (self changeDirectoryTo:(previous asFilename baseName)) ifFalse:[^ false].
!

selectionIsDirectory
    "return true, if the current selection is a directory"

    |entry|

    entry := self selectionValue.
    (entry isEmptyOrNil) ifTrue:[ ^ false].

    (entry endsWith:' ...') ifTrue:[
        entry := entry copyButLast:4.
    ].
    ^ (directory construct:entry) isDirectory

    "Created: / 4.3.1996 / 17:43:26 / cg"
    "Modified: / 18.9.1997 / 23:37:05 / stefan"
    "Modified: / 22.9.1998 / 12:30:21 / cg"
!

updateList
    "set the lists contents to the filenames in the directory"

    |newList newTypes obsolete 
     matching dir ignoreCase|

    directory isNil ifTrue:[
        self list:nil.
        ^ self
    ].

    self withCursor:(Cursor read) do:[
        "
         if the directory-id changed, MUST update.
         (can happen after a restart, when a file is no longer
          there, has moved or is NFS-mounted differently)
        "
        obsolete := directoryId ~~ directory id
                    or:[directoryName ~= directory pathName
                    or:[timeStamp notNil
                        and:[directory modificationTime > timeStamp]]].

        obsolete ifTrue:[
            timeStamp := directory modificationTime.
            directoryId := directory id.
            directoryName := directory pathName.
            [
                directoryContents := (directory fullDirectoryContents ? #()) sort.
            ] on:FileStream openErrorSignal do:[:ex|
                directoryContents := nil
            ].
        ].

        newList := OrderedCollection new.
        newTypes := OrderedCollection new.

        ignoreCase := ignoreCaseInPattern ? (Filename isCaseSensitive not).

        dir := directory pathName asFilename.
        directoryContents do:[:name |
            |type fn fullName isDirectory ignore|

            fn := dir construct:name.
            fullName := dir constructString:name.
            isDirectory := fn isDirectory.
            ignore := true.

            (matchBlock isNil or:[matchBlock value:fullName]) ifTrue:[
                isDirectory ifTrue:[
                    ignoreDirectories ifFalse:[
                        name = '..' ifTrue:[
                            ignoreParentDirectory ifFalse:[
                                ignore := false.
                            ]
                        ] ifFalse:[
                            name = '.' ifTrue:[
                                "ignore"
                            ] ifFalse:[
                                ignore := false.
                            ]
                        ]
                    ]
                ] ifFalse:[
                    ignoreFiles ifFalse:[
                        matching := true.

                        (pattern size > 0) ifTrue:[ 
                            pattern ~= '*' ifTrue:[
                                matching := pattern compoundMatch:name caseSensitive:ignoreCase not
                            ]
                        ].
                                        
                        matching ifTrue:[
                            ignore := false.
                        ]
                    ]
                ].
            ].
            ignore ifFalse:[
                newList add:name.
                newTypes add:isDirectory.
            ].
        ].
        directoryFileTypes := newTypes.
        self list:newList.
    ].

    "Modified: / 18.9.1997 / 23:43:52 / stefan"
    "Modified: / 16.12.1999 / 01:23:41 / cg"
!

updateListWithoutScrolling
    "set the lists contents to the filenames in the directory"

    |sav|

    sav := scrollWhenUpdating.
    scrollWhenUpdating := nil.
    self updateList.
    scrollWhenUpdating := sav
!

visibleLineNeedsSpecialCare:visLineNr
    |l|

    l := self visibleLineToListLine:visLineNr.
    l notNil ifTrue:[
        (directoryFileTypes at:l) ifTrue:[^ true].
        ^ super visibleLineNeedsSpecialCare:visLineNr
    ].
    ^ false

    "Modified: / 22.9.1998 / 12:32:48 / cg"
!

widthForScrollBetween:firstLine and:lastLine
    "return the width in pixels for a scroll between firstLine and lastLine
     - return full width here since there might be directory marks"

    ^ (width - margin - margin)
! !

!FileSelectionList methodsFor:'realization'!

realize
    "check if directory is still valid (using timestamp and inode numbers)
     - reread if not"

    super realize.

    (timeStamp isNil 
     or:[(directory modificationTime > timeStamp) 
     or:[(directoryId isNil)
     or:[directoryId ~~ directory id]]]) ifTrue:[
        directoryId := nil.
        self updateList
    ].

    "Created: 24.7.1997 / 18:24:36 / cg"
    "Modified: 18.9.1997 / 23:36:10 / stefan"
! !

!FileSelectionList class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

