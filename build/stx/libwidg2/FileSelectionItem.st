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

TreeItem subclass:#FileSelectionItem
	instanceVariableNames:'modificationTime matchAction isDirectory imageType showIndicator'
	classVariableNames:'ReadDirectoriesForIndicator'
	poolDictionaries:''
	category:'Interface-Support'
!

FileSelectionItem subclass:#Directory
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileSelectionItem
!

FileSelectionItem subclass:#File
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileSelectionItem
!

!FileSelectionItem class methodsFor:'documentation'!

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
    class to build up file tree like structures. You can define your own
    icons and filter. To change the icons, look for these methods:

        class method:           #keysAndIcons      : returns a list of icons and access keys used

        instance method:        #imageType         : get type of icon assigned to file

                                #icon              : get the type of image to be drawn

    Especially suited for use with FileSelectionTree.

    [class variables:]
        ReadDirectoriesForIndicator     <Boolean>       if true, the directories are searched
                                                        for subdirectories to update the
                                                        indicator; on auto mounted file systems
                                                        this would take a very long time!!!!
                                                        therefore the default is set to false.

    [Author:]
        Claus Atzkern

    [See also:]
        TreeItem
        FileSelectionTree
"
! !

!FileSelectionItem class methodsFor:'initialization'!

initialize
    ReadDirectoriesForIndicator := false.
! !

!FileSelectionItem class methodsFor:'instance creation'!

pathName:aPath
    "create a new node entry associated with the full pathname, aPath
    "
    |node|

    node := self new.
    node pathName:aPath.
  ^ node


! !

!FileSelectionItem class methodsFor:'accessing class'!

filterClassForDirectoriesOnly
    ^ Directory
!

filterClassForFilesOnly
    ^ File
! !

!FileSelectionItem class methodsFor:'converting'!

asFilename:aPathname
    "convert pathname to an absolute path
    "
    |path|

    path := aPathname asString.

    (path size > 1 and:[path endsWith:(Filename separator)]) ifTrue:[
        ^ (path copyButLast:1) asFilename.
    ].
  ^ aPathname asFilename

    "Modified: / 24.9.1998 / 15:33:50 / cg"
! !

!FileSelectionItem class methodsFor:'default icons'!

keysAndIcons
    "returns an IdentityDictionary containing a list of images and keys used
     by any file entry.
    "
    |icons image|

    icons := IdentityDictionary new.
    
    #(
        (#directory       fileTypeDirectoryIcon         'tiny_yellow_dir.xpm')
        (#directoryOpened fileTypeDirectoryOpenIcon     'tiny_yellow_dir_open.xpm')
        (#directoryLocked fileTypeDirectoryLockedIcon   'tiny_yellow_dir_locked.xpm')
        (#directoryLink   fileTypeDirectoryLinkIcon     'tiny_yellow_dir_link.xpm'  )

        (#file            fileTypeFileIcon              'tiny_file_plain.xpm'       )
        (#fileLink        fileTypeFileLinkIcon          'tiny_file_link.xpm'        )
        (#fileLocked      fileTypeFileLockedIcon        'tiny_file_lock.xpm'        )
        (#imageFile       fileTypeImageFileIcon         'tiny_file_pix.xpm'         )

     ) do:[:el |
        |key sel fileName|

        key := el at:1.
        sel := el at:2.
        fileName := el at:3.
        image := ToolbarIconLibrary perform:sel.
        image isNil ifTrue:[
            image := Image fromFile:('xpmBitmaps/document_images/', fileName ).
        ].
        image notNil ifTrue:[
            icons at:(el first) put:image.
        ]
    ].
    ^ icons
! !

!FileSelectionItem methodsFor:'accessing'!

children
    "get's list of children
    "
    readChildren ifTrue:[
        children := self readInChildren
    ].
  ^ children
!

fileName
    "returns the fileName of node
    "
    ^ contents



!

icon
    "returns type of image to be drawn
    "
    (children size ~~ 0 and:[hide == false]) ifTrue:[
        ^ #directoryOpened
    ].
    ^ self imageType
!

match:aOneArgBlock

    aOneArgBlock isNil ifTrue:[
        self discardFiles ifTrue:[
            matchAction := [:aFile :isDirectory| isDirectory ]
        ] ifFalse:[
            self discardDirectories ifTrue:[
                matchAction := [:aFile :isDirectory| isDirectory not ]
            ] ifFalse:[
                matchAction := [:aFile :isDir| true ]
            ]
        ]
    ] ifFalse:[
        self discardFiles ifTrue:[
            matchAction := [:aFile :isDirectory| (isDirectory and:[aOneArgBlock value:aFile]) ]
        ] ifFalse:[
            self discardDirectories ifTrue:[
                matchAction := [:aFile :isDirectory| (isDirectory not and:[aOneArgBlock value:aFile]) ]
            ] ifFalse:[
                matchAction := [:aFile :isDir| aOneArgBlock value:aFile ]
            ]
        ]
    ]    
!

pathName
    "returns full pathname of node
    "
    ^ contents asString


!

pathName:aPathname
    "initialze attributes associated with the full pathname, aPathname
    "
    |file|

"/    file := self class asFilename:aPathname.
    file := aPathname asFilename pathName asFilename.
    self 
        fileName:file 
        baseName:(file baseName) 
        parent:nil 
        isDirectory:(file isDirectory)

    "Modified: / 24.9.1998 / 16:02:53 / cg"
! !

!FileSelectionItem methodsFor:'accessing-hierarchy'!

collapse
    "check to release children
    "
    self stopIndicatorValidation.
    hide := true.

    children notEmpty ifTrue:[
        children do:[:aChild|
            aChild releaseCollapsedChildren ifFalse:[ ^ self ]
        ].
        self canReleaseChildren ifTrue:[
            self releaseChildren
        ]
    ]

!

collapseAll
    "release my childrens
    "
    self stopIndicatorValidation.
    hide := true.

    children notEmpty ifTrue:[
        self canReleaseChildren ifTrue:[
            self releaseChildren
        ] ifFalse:[
            children do:[:c| c releaseChildren ]
        ]
    ].

!

expandAll
    "not allowed for a file directory
    "
    self expand
! !

!FileSelectionItem methodsFor:'change & update'!

changedSelected
    "called if the node is selected
    "
    |model|

    (showIndicator isNil and:[ReadDirectoriesForIndicator not]) ifTrue:[
        model := self model.

        model notNil ifTrue:[
            model startIndicatorValidationFor:self
        ]
    ].
! !

!FileSelectionItem methodsFor:'private'!

childFileName:aFilename baseName:aBaseName parent:aParent isDirectory:aBool matchAction:mA
    "initialze attributes associated with the full pathname, aPathname.
     Same as #fileName:baseName:parent:isDirectory:,
     but used only for children (i.e. no need to check for
     being a rootDirectory).
    "

    contents    := aFilename.
    name        := aBaseName.
    parent      := aParent.
    isDirectory := readChildren := aBool.

    isDirectory ifFalse:[
        showIndicator := false
    ] ifTrue:[
        showIndicator := nil
    ].

    matchAction := mA

    "Modified: / 24.9.1998 / 14:10:38 / cg"
    "Created: / 24.9.1998 / 15:51:58 / cg"
!

directoryIsLocked
    ^ self imageType == #directoryLocked

    "Created: / 24.9.1998 / 14:22:08 / cg"
!

fileName:aFilename baseName:aBaseName parent:aParent isDirectory:aBool
    "initialze attributes associated with the full pathname, aPathname
    "
    |f|

    contents    := aFilename.
    (f := aFilename asFilename) isRootDirectory ifTrue:[
        name := f name.
"/        (name endsWith:Filename separator) ifTrue:[
"/            name ~= Filename separator asString ifTrue:[
"/                name := name copyWithoutLast:1.
"/            ]
"/        ]
    ] ifFalse:[
        name        := aBaseName.
    ].
    parent      := aParent.
    isDirectory := readChildren := aBool.

    isDirectory ifFalse:[
        showIndicator := false
    ] ifTrue:[
        showIndicator := nil
    ].

    parent notNil ifTrue:[
        matchAction := parent matchAction       "/ same as from parent
    ] ifFalse:[
        self match:nil                          "/ setup matchAction new
    ]

    "Modified: / 24.9.1998 / 19:19:57 / cg"
!

matchAction
    "returns my match action
    "
    ^ matchAction
!

releaseChildren
    "release my childrens without tests and deregistration from
     update task
    "
    hide := true.
    readChildren := true.
    modificationTime := nil.
    children := OrderedCollection new.


!

stopIndicatorValidation
    "called to stop indicator validation on each child
    "
    |model|

    (hide or:[children isEmpty]) ifFalse:[
        (model := self model) notNil ifTrue:[
            children do:[:c| c stopIndicatorValidation:model ].
            model stopIndicatorValidationFor:children
        ]
    ]


!

stopIndicatorValidation:aModel
    "called to stop indicator validation on each child
    "
    (hide or:[children isEmpty]) ifFalse:[
        children do:[:c| c stopIndicatorValidation:aModel ].
        aModel stopIndicatorValidationFor:children
    ]


! !

!FileSelectionItem methodsFor:'protected'!

isVisibleFile:aFilename isDirectory:isDirectory baseName:aBasename
    ^ matchAction value:aFilename value:isDirectory
! !

!FileSelectionItem methodsFor:'queries'!

canReleaseChildren
    "returns true if children could be released
    "
    ^ (parent notNil and:[parent parent notNil])


!

defaultShowSeparator
    "returns true if the separator is shown if the contents
     from the directory is not yet read
    "
    ^ ReadDirectoriesForIndicator not
!

discardDirectories
    "returns true if children are not type of directory; could be
     reimplemented for speed in any subclass
    "
    ^ false
!

discardFiles
    "returns true if children are not type of file; could be
     reimplemented for speed in any subclass
    "
    ^ false
!

hasChildren
    "returns true if the pathname assigned to this node is a directory
     otherwise false
    "
    ^ isDirectory

!

hasValidIndicator
    "returns true if indication flag is uptodate
    "
    |model|

    showIndicator notNil ifTrue:[
        ^ true
    ].
    ReadDirectoriesForIndicator ifTrue:[
        ^ false
    ].

    model := self model.

    model isNil ifTrue:[
        ^ true                  "/ oops, no model exist
    ].

    model selectedNode == self ifTrue:[
        ^ false                 "/ i'am selected, update indicator
    ].
    ^ true
!

isDirectory
    ^ isDirectory
!

releaseCollapsedChildren
    "release collapsed children
    "
    |canCollapse|

    children isEmpty ifTrue:[
        ^ true
    ].
    canCollapse := true.

    children do:[:aChild|
        aChild releaseCollapsedChildren ifFalse:[
            canCollapse := false
        ]
    ].

    (canCollapse and:[self isExpandable]) ifTrue:[
        self canReleaseChildren ifTrue:[
            self releaseChildren.
          ^ true.
        ]
    ].
    ^ false

!

setShowIndicator:aBool
    "set indication; raise no change notification
    "
    showIndicator := aBool.
!

showIndicator
    "returns true if the node is a non-empty directory.
     This information is gathered lazily: first, false is
     returned and indicatorValidation is started for mySelf;
     this will read directories in the background to avoid
     long startup delays (of my treeView)"

    |model|

    showIndicator isNil ifTrue:[
        self directoryIsLocked ifTrue:[
            showIndicator := readChildren := false.
        ] ifFalse:[
            (model := self model) notNil ifTrue:[
                ReadDirectoriesForIndicator ifFalse:[
                    ^ true
                ].
                model startIndicatorValidationFor:self.
            ].
            ^ false
        ]
    ].
    ^ showIndicator
!

showIndicator:aBool
    "indication might change; raise a change notification
    "
    |oldState|

    (oldState := showIndicator) isNil ifTrue:[
        oldState := self defaultShowSeparator
    ].
    showIndicator := aBool.

    oldState ~~ aBool ifTrue:[
        self changed
    ].

    "Modified: / 28.9.1998 / 11:14:30 / cg"
! !

!FileSelectionItem methodsFor:'repair mechanism'!

hasObsoleteNodes
    "check whether node or any child node is obsolete
    "
    modificationTime notNil ifTrue:[
        modificationTime < contents modificationTime ifTrue:[
            ^ true
        ].
        self discardDirectories ifFalse:[
            (children contains:[:aChild | aChild hasObsoleteNodes]) ifTrue:[^ true].
        ]
    ].
    ^ false
!

repairObsoleteNodes
    "repair nodes
    "
    |list hasChanged|

    modificationTime isNil ifTrue:[
        ^ false
    ].

    modificationTime < contents modificationTime ifTrue:[
        list := self readInChildren.                    
        hasChanged := list size ~~ children size.

        children do:[:aChild||i|
            i := list findFirst:[:f| f name = aChild name ].

            i ~~ 0 ifTrue:[
                list at:i put:aChild
            ] ifFalse:[
                hasChanged := true
            ].
        ].
        hasChanged ifTrue:[
            self stopIndicatorValidation.
            children := list
        ]
    ] ifFalse:[
        hasChanged := false
    ].
    children size ~~ 0 ifTrue:[
        children do:[:aChild|
            (aChild repairObsoleteNodes) ifTrue:[hasChanged := true]
        ]
    ].
    ^ self shown ifTrue:[hasChanged]
                ifFalse:[false]


! !

!FileSelectionItem methodsFor:'update'!

imageType
    "return my icon-image type - a symbol"

    |readable|

    imageType isNil ifTrue:[
        readable := contents isReadable.

        isDirectory ifTrue:[
            (readable and:[contents isExecutable]) ifTrue:[
                contents isSymbolicLink 
                    ifFalse:[imageType := #directory]
                    ifTrue:[imageType := #directoryLink]
            ] ifFalse:[
                imageType := #directoryLocked
            ]
        ] ifFalse:[
            readable ifFalse:[
                imageType := #fileLocked
            ] ifTrue:[
                contents isSymbolicLink ifFalse:[
                    (Image isImageFileSuffix:(contents suffix)) ifFalse:[
                        imageType := #file
                    ] ifTrue:[
                        imageType := #imageFile
                    ]
                ] ifTrue:[
                    imageType := #fileLink
                ]
            ]
        ]
    ].
    ^ imageType

    "Modified: / 24.9.1998 / 15:47:38 / cg"
!

readInChildren
    "read children from directory
    "
    |list directory|

    list := OrderedCollection new.
    readChildren  := false.
    showIndicator := self defaultShowSeparator.

    self directoryIsLocked ifFalse:[
        Cursor read showWhile:[
            directory := DirectoryContents directoryNamed:contents.

            directory isNil ifTrue:[
                self stopIndicatorValidation.
                self releaseChildren.
                imageType := #directoryLocked.
            ] ifFalse:[
                modificationTime := directory modificationTime.

                directory contentsAndBaseNamesDo:[:file :bname :isDir|
                    (self isVisibleFile:file isDirectory:isDir baseName:bname) ifTrue:[
                        list add:(self class new 
                                    childFileName:file 
                                    baseName:bname 
                                    parent:self 
                                    isDirectory:isDir
                                     matchAction:matchAction)
                    ]
                ].
                showIndicator := list size ~~ 0.
            ]
        ]
    ].
    list sort:[:a :b | a fileName name < b fileName name].
    ^ list

    "Modified: / 24.9.1998 / 17:51:48 / cg"
! !

!FileSelectionItem::Directory class methodsFor:'documentation'!

documentation
"
    subtype of FileSelectionItem only showing directories; more an example to show
    how to implement filters

    [Author:]
        Claus Atzkern

    [See also:]
        FileSelectionItem
"

! !

!FileSelectionItem::Directory methodsFor:'queries'!

discardFiles
    ^ true
! !

!FileSelectionItem::File class methodsFor:'documentation'!

documentation
"
    subtype of FileSelectionItem only showing files; more an example to show
    how to implement filters

    [Author:]
        Claus Atzkern

    [See also:]
        FileSelectionItem
"


! !

!FileSelectionItem::File methodsFor:'queries'!

discardDirectories
    ^ true


! !

!FileSelectionItem class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


FileSelectionItem initialize!
