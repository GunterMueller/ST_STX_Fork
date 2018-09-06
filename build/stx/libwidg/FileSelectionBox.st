"
 COPYRIGHT (c) 1990 by Claus Gittinger
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

ListSelectionBox subclass:#FileSelectionBox
	instanceVariableNames:'patternField selectingDirectory allowMakeDirectory'
	classVariableNames:'LastFileSelectionDirectory'
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!FileSelectionBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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
    this class implements file selection boxes. Instances show a list of
    files, and perform an action block with the selected pathname as
    argument when ok is clicked. It is also possible, to open the box
    without action and ask it afterward if it has been left with ok
    (i.e. the ST-80 way, asking 'aBox accepted ifTrue:[...]')

    There is an optional PatternField, which shows itself when a pattern
    is defined (i.e. if there is no pattern, it is hidden). 
    If there is a pattern, only files matching the pattern are shown in 
    the list. Directories are not affected by the patternField.

    In addition, there is an optional matchBlock (actually this is defined 
    in the FileSelectionList). Only names for which this matchblock
    returns true will be presented. The matchBlock affects both regular files
    and names of directories. The argument passed to the matchBlock is the full
    pathname.

    All of the actual work is done in the fileList; see the documentation
    of FileSelectionList for more options 
    (you can access a boxes fileList via 'aBox>>listView' and get access to all
     of those fancy settings)
    For example, by accessing the list, it is possible to hide all directories 
    ('aBox listView ignoreDirectories:true'), to hide the parentDirectory alone 
    ('aBox listView ignoreParentDirectory') and to turn off the marking 
    of subdirectories ('aBox listView markSubdirectories:false').

    [author:]
        Claus Gittinger

    [see also:]
        DialogBox
        EnterBox2 FilenameEnterBox YesNoBox
        ListSelectionBox FileSaveBox
        FileSelectionList SelectionInListView
"
!

examples 
"
  simple standard queries
  (notice, that the receiver of those messages is Dialog - this should always
   be done for compatibility - although the real fileBox implementation is here).

    very simple:
                                                                        [exBegin]
        |name|

        name := Dialog requestFileName.
        Transcript showCR:name
                                                                        [exEnd]


    simple:
                                                                        [exBegin]
        |name|

        name := FileSelectionBox requestFileName:'which file ?'.
        Transcript showCR:name
                                                                        [exEnd]


    with initial selection:
                                                                        [exBegin]
        |name|

        name := FileSelectionBox requestFileName:'which file ?' default:'Make.proto'.
        Transcript showCR:name
                                                                        [exEnd]



  more detailed setup

    setting title:
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which file ?'.
        box open.
        box accepted ifTrue:[
            Transcript showCR:'you selected: ' , box pathName
        ]
                                                                        [exEnd]

    setting a matchpattern:
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which file ?'.
        box pattern:'*.rc'.
        box open
                                                                        [exEnd]

    setting multiple patterns:
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which file ?'.
        box pattern:'*.rc;*.st'.
        box open
                                                                        [exEnd]

    setting a matchblock:
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which file ?'.
        box directory:'/etc'.
        box pattern:'*'.
        box matchBlock:[:name | name asFilename baseName first between:$a and:$z].
        box open
                                                                        [exEnd]

    both pattern and matchBlock:
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which directory ?'.
        box selectingDirectory:true.
        box pattern:'l*'.
        box matchBlock:[:name | OperatingSystem isDirectory:name].
        box action:[:fn | Transcript showCR:fn].
        box open
                                                                        [exEnd]

    don't show the parent directory:
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which directory ?'.
        box listView ignoreParentDirectory:true.
        box open
                                                                        [exEnd]

    don't show any directory:
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which file ?'.
        box listView ignoreDirectories:true.
        box open
                                                                        [exEnd]

    don't show any directory or hidden file:
    (notice the basename extraction - we are not interested in the full pathName)
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which file ?'.
        box listView ignoreDirectories:true.
        box matchBlock:[:name | (name asFilename baseName startsWith:'.') not].
        box open
                                                                        [exEnd]

    don't allow direct filename entry:
    (i.e. avoid the user choosing files from other directories)
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which one ?'.
        box enterField beInvisible.
        box open.
        box accepted ifTrue:[
            Transcript showCR:'path is ' , box pathName
        ].
                                                                        [exEnd]

    combined with above directory ignoring,
    this limits selection of files from a single directory:
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which file ?'.
        box enterField beInvisible.
        box listView ignoreDirectories:true.
        box open.
        box accepted ifTrue:[
            Transcript showCR:'path is ' , box pathName
        ].
                                                                        [exEnd]

    finally, an action:
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which directory ?'.
        box pattern:'l*'.
        box matchBlock:[:name | OperatingSystem isDirectory:name].
        box action:[:name | Transcript showCR:name].
        box open
                                                                        [exEnd]

  concrete examples:

    only show files beginning with lowercase characters
    and ending in '.c':
                                                                        [exBegin]
        |box|
        box := FileSelectionBox new.
        box title:'Which directory ?'.
        box matchBlock:[:name |
                            box pathName asFilename isDirectory
                            or:[name first isLowercase
                                and:[name endsWith:'.c']]
                       ].
        box open.
        box accepted ifTrue:[
            Transcript showCR:'full path:  ' , box pathName.
            Transcript showCR:'files name: ' , box fileName.
            Transcript showCR:'directory : ' , box directory pathName.
        ]
                                                                        [exEnd]
"
! !

!FileSelectionBox class methodsFor:'accessing'!

lastFileSelectionDirectory
    "return the name of the directory used in the previous
     fileSelection dialog. This will be used as default for the next dialog,
     if no explicit path is specified (see requestFileName:* methods)"

    |f|

    LastFileSelectionDirectory notNil ifTrue:[
        ((f := LastFileSelectionDirectory asFilename) exists 
        and:[f isDirectory]) ifFalse:[
            LastFileSelectionDirectory := nil.
        ]
    ].
    ^ LastFileSelectionDirectory

    "Created: / 9.9.1997 / 10:03:17 / cg"
    "Modified: / 16.6.1998 / 15:11:20 / cg"
!

lastFileSelectionDirectory:aDirectoryString
    "set the name of the directory used in the previous
     fileSelection dialog. This will be used as default for the next dialog,
     if no explicit path is specified (see requestFileName:* methods)"

    LastFileSelectionDirectory := aDirectoryString

    "Created: / 9.9.1997 / 10:03:42 / cg"
    "Modified: / 15.6.1998 / 14:05:21 / cg"
! !

!FileSelectionBox class methodsFor:'defaults'!

listViewType
    "return the type of listView - using a FileSelectionList here"

    ^ FileSelectionList
! !

!FileSelectionBox class methodsFor:'menu specs'!

fileListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileSelectionBox andSelector:#fileListMenu
     (Menu new fromLiteralArrayEncoding:(FileSelectionBox fileListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'New Folder...'
            #translateLabel: true
            #value: #fileListMenuNewFolder
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Remove...'
            #translateLabel: true
            #value: #fileListMenuRemove
          )
         )
        nil
        nil
      )
! !

!FileSelectionBox methodsFor:'accessing'!

allowMakeDirectory:aBoolean
    "allow or deny creation of new directories;
     The default is to allow it."

    allowMakeDirectory := aBoolean.
!

contents
    "return the current entered value (i.e. the enterFields string).
     redefined to return the full pathname."

    |string|

    string := super contents.
    string size == 0 ifTrue:[
        selectingDirectory ifFalse:[^ string].
        ^ selectionList directory pathName
    ].
    (string asFilename isAbsolute) ifTrue:[
        ^ string
    ].
    ^ (selectionList directory pathName asFilename construct:string) asString

    "Modified: / 9.9.1998 / 21:23:16 / cg"
!

directory
    "return the directory which is currently shown"

    ^ selectionList directory
!

directory:directoryName
    "change the directory shown in the list."

    selectionList directory:directoryName.
    selectingDirectory ifTrue:[
        enterField contents:directoryName asFilename pathName
    ]
!

fileName
    "if some filename has been entered, return it (without the directory path)
     otherwise, return nil"

    |string|

    string := super contents.
    string isNil ifTrue:[^ nil].
    ^ self pathName asFilename baseName

    "Modified: / 12.8.1998 / 09:54:01 / cg"
!

matchBlock:aBlock
    "set the matchBlock (in the selectionList). Only files
     for which the block returns true are shown.
     The matching is actually done in the fileSelectionList."

    selectionList matchBlock:aBlock 
!

openOn:aPath
    "open the box showing files in aPath.
     This is only a shortcut message - no new functionality."

    self directory:aPath.
    self showAtPointer
!

pathName
    "same as contents - return the full pathname of the selected file,
     or the pathname of the directory if nothing has been entered"

    ^ self contents
!

pattern:aPattern
    "set the pattern - this also enables the PatternField
     (if the pattern is non-nil) or hides it (if nil)."

    |focusSequence|

    patternField initialText:aPattern.
    selectionList pattern:aPattern.
    aPattern isNil ifTrue:[
        patternField beInvisible.
        self makeUntabable:patternField.
        focusSequence := (Array 
                             with:enterField 
                             with:selectionList 
                             with:okButton 
                             with:abortButton)
    ] ifFalse:[
        patternField beVisible.
        self makeTabable:patternField.
        focusSequence := (Array 
                             with:patternField 
                             with:enterField 
                             with:selectionList 
                             with:okButton 
                             with:abortButton)
    ].

    windowGroup notNil ifTrue:[
        windowGroup focusSequence:focusSequence
    ].

    "Modified: 18.10.1997 / 03:02:05 / cg"
!

selectingDirectory:aBoolean
    "setup the box for directory selection (hides regular files).
     Use this, to ask the user for a directories name"

    selectingDirectory := aBoolean.
    aBoolean ifTrue:[
        selectionList directoryChangeAction:[:entry | self directoryChanged].
        selectionList directorySelectAction:[:entry | self directorySelected].
        selectionList ignoreFiles:true.
    ]

    "Modified: 22.10.1996 / 13:24:50 / cg"
! !

!FileSelectionBox methodsFor:'change & update'!

update:something with:argument from:changedObject
    |commonName index s|

    something == #directory ifTrue:[
        "
         sent by fileNameEnterField, if a filename
         completion was not possible due to multiple
         matches.
        "
        selectionList directory:argument.
        s := enterField contents.
        s notNil ifTrue:[
            commonName := s asFilename baseName.
            commonName size > 0 ifTrue:[
                index := selectionList list findFirst:[:entry | entry startsWith:commonName].
                index ~~ 0 ifTrue:[
                    selectionList makeLineVisible:index
                ]
            ]
        ]
    ].

    super update:something with:argument from:changedObject

    "Modified: / 23-01-2012 / 17:35:54 / cg"
! !

!FileSelectionBox methodsFor:'initialization'!

createEnterField
    "if the (optional) class FilenameEditField is present, use
     it, since it provides filename completion. Otherwise, we have
     to live with the dumb (default) field ...
    "
    FilenameEditField notNil ifTrue:[
        ^ FilenameEditField new.
    ].
    ^ super createEnterField

    "Modified: 18.4.1996 / 20:02:24 / cg"
!

initialize
    |corner|

    super initialize.
    selectingDirectory := false.
    allowMakeDirectory := true.

    label := resources string:'File dialog'.

    labelField extent:(0.7 @ labelField height).
    labelField label:(resources string:'Select a file:').
    labelField adjust:#left.

    patternField := EditField in:self.
    self is3D ifTrue:[
        corner := (1.0 @ (labelField origin y+patternField heightIncludingBorder)).
    ] ifFalse:[
        corner := [(width - ViewSpacing - (patternField borderWidth * 2)) @ (labelField origin y+patternField height"IncludingBorder")].
    ].
    patternField origin:(0.7 @ labelField origin y) corner:corner.
    patternField rightInset:0.
    patternField initialText:'*'.
    patternField leaveAction:[:reason | self patternChanged]. 
    patternField crAction:[self patternChanged].
    patternField hiddenOnRealize:true. "delay showing, until a pattern is defined"
"/ no, since its invisible
"/    self makeTabable:patternField before:enterField.

    enterField 
        origin:[0.0 @ (ViewSpacing + ViewSpacing + (labelField preferredHeight max:patternField preferredHeight) "height")].
    enterField addDependent:self.
    "/ enterField immediateAccept:true.
    enterField acceptAction:[:newFile | self enterFieldChanged ].
    enterField crAction:[:newFile | self enterFieldChanged. self okPressed ].

    selectionList menuHolder:self; menuMessage:#fileListMenu; menuPerformer:self.
    selectionList ignoreCaseInPattern:true.

    "
     FileSelectionBox open
     FileSelectionBox new show
    "

    "Modified: / 23-01-2012 / 18:18:47 / cg"
!

postRealize
    "if some default is present in the enterField,
     scroll to make this one visible"

    |contents|

    super postRealize.
    (contents := enterField contents) notNil ifTrue:[
        contents notEmpty ifTrue:[
            selectionList makeVisible:contents
        ]
    ]

    "Created: 24.7.1997 / 18:19:14 / cg"
! !

!FileSelectionBox methodsFor:'menu'!

fileListMenu
    allowMakeDirectory ifFalse:[^ self].
    ^ self class fileListMenu
!

fileListMenuNewFolder
    |newDirName d|

    newDirName := Dialog request:(resources string:'Name of new Folder:').
    newDirName size == 0 ifTrue:[^ self].

    d := self directory asFilename construct:newDirName.
    d exists ifTrue:[
        d isDirectory ifTrue:[
            ^ self
        ].
        self warn:(resources string:'A file named %1 already exists.' with:newDirName).
        ^ self
    ].

    d makeDirectory.
    self updateList.

    "
     self open
    "
!

fileListMenuRemove
    |selectedFilename baseName|

    selectedFilename := self pathName asFilename.
    baseName := selectedFilename baseName.

    (Dialog confirm:(resources string:'Really remove ''%1'' ?' with:baseName allBold)) ifFalse:[
        ^ self.
    ].

    selectedFilename isDirectory ifTrue:[
        self warn:(resources string:'%1 is a directory..' with:baseName).
        ^ self.
    ].

    selectedFilename delete.
    self updateListWithoutScrolling.
! !

!FileSelectionBox methodsFor:'private'!

updateList
    selectionList updateList
!

updateListWithoutScrolling
    selectionList updateListWithoutScrolling
! !

!FileSelectionBox methodsFor:'queries'!

preferredExtent
    "return my preferred extent 
     - that's the minimum size to make everything visible"

    |wWanted hWanted mm|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].
    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    mm := ViewSpacing.

    wWanted := mm + 
               labelField preferredWidth + 
               (mm * 2) + 
               patternField preferredWidth + 
               mm.
    (wWanted < width) ifTrue:[
        wWanted := width
    ].
    hWanted := mm + labelField height +
               mm + enterField height +
               mm + selectionList height +
               mm + buttonPanel preferredHeight +
               mm.

    (hWanted < height) ifTrue:[
        hWanted := height
    ].
    ^ (wWanted @ hWanted)

    "Modified: 19.7.1996 / 20:44:04 / cg"
! !

!FileSelectionBox methodsFor:'user actions'!

directoryChanged
    selectingDirectory ifTrue:[
        selectionList changeDirectory.
        enterField contents:(selectionList directory pathName).
        selectionList setSelection:nil.
    ].

    "Created: 18.4.1996 / 18:38:21 / cg"
    "Modified: 25.5.1996 / 12:27:05 / cg"
!

directorySelected
    "a directory was selected - show the new path in the inputField,
     if we are in directory mode"

    selectingDirectory ifTrue:[
        |newDir|

        newDir := (selectionList directory)
                      construct:selectionList selectionValue.
        enterField contents:newDir pathName.
    ].

    "Created: / 18.4.1996 / 18:46:15 / cg"
    "Modified: / 7.8.1998 / 17:19:26 / cg"
!

doubleClick
    |entry|

    entry := selectionList selectionValue.
    entry notNil ifTrue:[
        ((selectionList directory asFilename construct:entry) isDirectory) ifFalse:[
            selectingDirectory ifFalse:[
                enterField contents:entry.
                self okPressed
            ]
        ]
    ].

    "Modified: 19.10.1997 / 00:17:37 / cg"
!

enterFieldChanged
    |fn dir|

    fn := enterField contents.
    (dir := fn asFilename) exists ifFalse:[
        dir := dir directory.
    ].
    dir exists ifTrue:[
        dir isDirectory ifFalse:[
            dir := dir directory
        ].
        selectionList changeDirectoryTo:dir pathName
    ].

    "Created: / 23-01-2012 / 18:10:32 / cg"
!

okPressed
    "called for both on ok-press and on return-key"

    |dir string fname|

    string := enterField contents.
    (string notEmptyOrNil) ifTrue:[
        string := string withoutSeparators.
        string asFilename isAbsolute ifTrue:[
            fname := string asFilename
        ] ifFalse:[
            dir := selectionList directory pathName asFilename.
            fname := dir construct:string
        ].
        fname isDirectory ifTrue:[
            selectingDirectory ifFalse:[
                selectionList directory:fname asString.
                self updateList.
                ^ self
            ]    
        ]
    ] ifFalse:[
        selectingDirectory ifTrue:[
            enterField contents:(selectionList directory pathName).
        ].
    ].

    super okPressed

    "Modified: / 10.9.1998 / 22:19:11 / cg"
!

patternChanged
    selectionList pattern:patternField contents. 
    self updateList

    "Created: 4.6.1996 / 20:30:23 / cg"
!

selectionChanged
    |entry|

    entry := selectionList selectionValue.
    (selectionList directory asFilename construct:entry) type == #directory ifFalse:[
        selectingDirectory ifTrue:[
            enterField contents:(selectionList directory pathName).
            selectionList setSelection:nil.
            ^ self
        ]
    ].
    enterField contents:entry

    "Modified: 21.9.1997 / 12:07:55 / cg"
! !

!FileSelectionBox class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

