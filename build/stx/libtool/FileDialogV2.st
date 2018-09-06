"
 COPYRIGHT (c) 2002 by eXept Software AG
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

SimpleDialog subclass:#FileDialogV2
	instanceVariableNames:'aspects directory pattern filterHolder initialText multipleSelect
		doubleClickAction cancelLabelHolder okLabelHolder startFilename
		result filterField filenameField viewFiles filenameLabelHolder
		isLoadDialog newDirectoryVisibilityHolder
		appendButtonVisibleHolder appendWasPressed
		buttonPanelVisibleHolder appendLabelHolder contentsBrowser'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileDialogV2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    documentation to be added.

    [author:]
        Martin Walser (martin@vercingetorix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
                                                                [exBegin]
    FileDialog open
                                                                [exEnd]

                                                                [exBegin]
    FileDialog 
        requestFileName:'enter a fileName:'
        default:''
        version:nil
        ifFail:['none']
        pattern:'*.conf'
        fromDirectory:'/etc'
        whenBoxCreatedEvaluate:nil.
                                                                [exEnd]
                                                                [exBegin]
    |fd|

    fd := FileDialog new.
    fd multipleSelect:true.
    fd open
                                                                [exEnd]
"
!

todo
"
    - make the filedialog windows like f
      filename entry field shows only the filename not the whole directory 
      the tree allways starts in currrent directory
      the parent tree is shown in a compobox where the perents are selectable
    - do not expand the ~ or relative pathnames to absolute pathnames        
"
! !

!FileDialogV2 class methodsFor:'instance creation'!

requestDirectoryName:title default:aFileName ifFail:failBlock
    "same as requestFileName, but only show directories"

    ^ self  
        requestDirectoryName:title 
        default:aFileName 
        ok:nil 
        abort:nil 
        version:nil 
        pattern:nil 
        fromDirectory:nil 
        ifFail:failBlock 
        whenBoxCreatedEvaluate:nil
        asLoadDialog:nil.

    "
     FileDialogV2
        requestDirectoryName:'which directory ?' 
        default:Filename currentDirectory pathName
        ifFail:'none'
    "
!

requestDirectoryName:title default:aFileName ok:okText abort:abortText ifFail:failBlock
    "same as requestFileName, but only show directories"

    ^ self  
        requestDirectoryName:title 
        default:aFileName 
        ok:okText 
        abort:abortText 
        version:nil 
        pattern:nil 
        fromDirectory:nil 
        ifFail:failBlock 
        whenBoxCreatedEvaluate:nil
        asLoadDialog:nil.

    "
     FileDialog
        requestDirectoryName:'which directory ?' 
        default:Filename currentDirectory pathName
        ok:'Yes'
        abort:'No'
        ifFail:'none'
    "
!

requestDirectoryName:title default:aFileName ok:okText abort:abortText ifFail:failBlock acceptReturnAsOK:aBoolean
    "same as requestFileName, but only show directories"

    ^ self  
        requestDirectoryName:title 
        default:aFileName 
        ok:okText 
        abort:abortText 
        version:nil 
        pattern:nil 
        fromDirectory:nil 
        ifFail:failBlock 
        whenBoxCreatedEvaluate:[:box|box doubleClickAction:[:index|box doAccept]]
        asLoadDialog:nil.

    "
     FileDialog
        requestDirectoryName:'which directory ?' 
        default:Filename currentDirectory pathName
        ok:'Yes'
        abort:'No'
        ifFail:'none'
    "
!

requestDirectoryName:titleString default:aFileName ok:okText abort:abortText version:versionSymbol pattern:pattern fromDirectory:aDirectoryPath ifFail:failBlock whenBoxCreatedEvaluate:boxCreatedCallback asLoadDialog:aBoolean
    "same as requestFileName, but only show directories"

    |enteredFileName instance enteredFileNameString|

    instance := self    
        startApplicationFor:titleString 
        default:aFileName 
        ok:okText 
        abort:abortText 
        ifFail:failBlock 
        pattern:pattern 
        fromDirectory:aDirectoryPath 
        whenBoxCreatedEvaluate:boxCreatedCallback
        asLoadDialog:aBoolean
        viewFiles:false
        multipleSelect:false.

    enteredFileNameString := instance result.
    enteredFileNameString isNil ifTrue:[
        ^ failBlock value
    ].
    enteredFileName := enteredFileNameString asFilename.
    enteredFileNameString := enteredFileName asString.
    (enteredFileName notNil 
    and:[enteredFileNameString notEmpty]) ifTrue:[
        versionSymbol isNil ifTrue:[ ^ enteredFileNameString].
        versionSymbol == #mustBeNew ifTrue:[
            "/ file may not exist
            enteredFileName exists ifTrue:[^ ''].
        ].
        versionSymbol == #new ifTrue:[
            "/ file may not exist
            enteredFileName exists ifTrue:[
                (Dialog confirm:(self classResources string:'''%1'' exists.\\Continue anyway ?' with:enteredFileNameString) withCRs)
                    ifFalse:[^ ''].
            ].
        ].
        versionSymbol == #mustBeOld ifTrue:[
            enteredFileName exists ifFalse:[^ ''].
        ].
        versionSymbol == #old ifTrue:[
            "/ file may not exist
            enteredFileName exists ifFalse:[
                (self confirm:(self classResources string:'''%1'' does not exist yet.\\Continue anyway ?' with:enteredFileNameString) withCRs)
                ifFalse:[^ ''].
            ].
        ].
        FileSelectionBox lastFileSelectionDirectory:(enteredFileNameString).
    ].
    ^ enteredFileNameString

    "
     FileDialog
        requestDirectoryName:'which directory ?' 
        default:Filename currentDirectory pathName
        ifFail:nil
    "
    "
     FileDialog
        requestDirectoryName:'which directory ?' 
        default:Filename currentDirectory pathName 
        ok:nil
        abort:nil 
        version:nil 
        pattern:nil 
        fromDirectory:nil 
        ifFail:nil 
        whenBoxCreatedEvaluate:nil
        asLoadDialog:true
    "
!

requestDirectoryName:title default:aFileName ok:okText ifFail:failBlock
    "same as requestFileName, but only show directories"

    ^ self  
        requestDirectoryName:title 
        default:aFileName 
        ok:okText 
        abort:nil 
        version:nil 
        pattern:nil 
        fromDirectory:nil 
        ifFail:failBlock 
        whenBoxCreatedEvaluate:nil
        asLoadDialog:nil.

    "
     FileDialogV2
        requestDirectoryName:'which directory ?' 
        default:Filename currentDirectory pathName
        ok:'Yes'
        ifFail:'none'
    "
!

requestFileName:titleString default:defaultName ok:okText abort:abortText pattern:pattern fromDirectory:aDirectoryPathOrNil whenBoxCreatedEvaluate:boxCreatedCallback

    ^ self  
        requestFileName:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        version:nil 
        ifFail:nil 
        pattern:pattern 
        fromDirectory:aDirectoryPathOrNil 
        whenBoxCreatedEvaluate:boxCreatedCallback
!

requestFileName:titleString default:defaultName ok:okText abort:abortText version:versionSymbol ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath whenBoxCreatedEvaluate:boxCreatedCallback
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "

    ^ self  
        requestFileName:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        version:versionSymbol 
        ifFail:failBlock 
        pattern:pattern 
        fromDirectory:aDirectoryPath 
        whenBoxCreatedEvaluate:boxCreatedCallback 
        asLoadDialog:nil
!

requestFileName:titleString default:defaultName ok:okText abort:abortText version:versionSymbol ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath whenBoxCreatedEvaluate:boxCreatedCallback asLoadDialog:aBoolean
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "


    | instance enteredFileName enteredFileNameString|

    instance := self    
        startApplicationFor:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        ifFail:failBlock 
        pattern:pattern 
        fromDirectory:aDirectoryPath 
        whenBoxCreatedEvaluate:boxCreatedCallback
        asLoadDialog:aBoolean
        viewFiles:true
        multipleSelect:false.

    enteredFileNameString := instance result.
    (enteredFileNameString isNil or:[enteredFileNameString isEmpty]) ifTrue:[
        ^ failBlock value
    ].
    enteredFileName := enteredFileNameString asFilename.
    enteredFileNameString := enteredFileName asString.

    (enteredFileName notNil 
    and:[enteredFileNameString notEmpty]) ifTrue:[
        FileSelectionBox lastFileSelectionDirectory:(enteredFileName directoryName).
        versionSymbol isNil ifTrue:[ ^ enteredFileNameString].
        versionSymbol == #mustBeNew ifTrue:[
            "/ file may not exist
            enteredFileName exists ifTrue:[^ ''].
        ].
        versionSymbol == #new ifTrue:[
            "/ file may not exist
            enteredFileName exists ifTrue:[
                (Dialog confirm:(self classResources string:'''%1'' exists.\\Continue anyway ?' with:enteredFileNameString) withCRs)
                    ifFalse:[^ ''].
            ].
        ].
        versionSymbol == #mustBeOld ifTrue:[
            enteredFileName exists ifFalse:[^ ''].
        ].
        versionSymbol == #old ifTrue:[
            "/ file may not exist
            enteredFileName exists ifFalse:[
                (self confirm:(self classResources string:'''%1'' does not exist yet.\\Continue anyway ?' with:enteredFileNameString) withCRs)
                ifFalse:[^ ''].
            ].
        ].
    ].
    ^ enteredFileNameString
"
     FileDialog 
        requestFileName:'enter a fileName:'
        default:''
        ok:nil 
        abort:nil
        version:nil
        ifFail:['none']
        pattern:'*'
        fromDirectory:Filename currentDirectory pathName
        whenBoxCreatedEvaluate:nil
        asLoadDialog:true
"
!

requestFileName:titleString default:defaultName version:versionSymbol ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPathOrNil whenBoxCreatedEvaluate:boxCreatedCallback

    ^ self  
        requestFileName:titleString 
        default:defaultName 
        ok:nil 
        abort:nil 
        version:versionSymbol 
        ifFail:failBlock 
        pattern:pattern 
        fromDirectory:aDirectoryPathOrNil 
        whenBoxCreatedEvaluate:boxCreatedCallback

    "
     FileDialog 
        requestFileName:'enter a fileName:'
        default:''
        version:nil
        ifFail:['none']
        pattern:'*.conf'
        fromDirectory:Filename currentDirectory pathName
        whenBoxCreatedEvaluate:nil.
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:nil
        ifFail:['none']
        pattern:'*.conf'
        fromDirectory:Filename currentDirectory pathName
        whenBoxCreatedEvaluate:nil
    "
    "
     FileDialog
        requestFileName:'enter a fileName:'
        default:''
        version:#old 
        ifFail:['none']   
        pattern:'*.conf'
        fromDirectory:Filename currentDirectory pathName
        whenBoxCreatedEvaluate:nil
    "
    "
     FileDialog
        requestFileName:'enter a fileName:'
        default:''
        version:#mustBeNew 
        ifFail:['none']   
        pattern:'*.conf'
        fromDirectory:Filename currentDirectory pathName
        whenBoxCreatedEvaluate:nil
    "
!

requestFileNames:titleString default:defaultName ok:okText abort:abortText ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath whenBoxCreatedEvaluate:boxCreatedCallback
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return all selected Filenames as filenames in a collection, or nil if cancel was pressed
    "


    ^ self  
        requestFileNames:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        ifFail:failBlock 
        pattern:pattern 
        fromDirectory:aDirectoryPath 
        whenBoxCreatedEvaluate:boxCreatedCallback 
        asLoadDialog:nil.


"
     FileDialogV2 
        requestFileNames:'enter a fileName:'
        default:''
        ok:nil 
        abort:nil 
        ifFail:['none']
        pattern:'*.conf'
        fromDirectory:Filename currentDirectory pathName
        whenBoxCreatedEvaluate:nil.
"
!

requestFileNames:titleString default:defaultName ok:okText abort:abortText ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath whenBoxCreatedEvaluate:boxCreatedCallback asLoadDialog:asLoadDialog
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return all selected Filenames as filenames in a collection, or nil if cancel was pressed
    "


    | instance enteredFileNames lastDirectory|

    instance := self    
        startApplicationFor:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        ifFail:failBlock 
        pattern:pattern 
        fromDirectory:aDirectoryPath 
        whenBoxCreatedEvaluate:boxCreatedCallback
        asLoadDialog:asLoadDialog 
        viewFiles:true
        multipleSelect:true.

    enteredFileNames := instance currentSelectedFiles.
    (enteredFileNames isEmpty or:[instance result isNil]) ifTrue:[
        ^ failBlock value
    ].
    lastDirectory := enteredFileNames first.
    lastDirectory := lastDirectory isFilename ifTrue:[lastDirectory directory] ifFalse:[lastDirectory].
    FileSelectionBox lastFileSelectionDirectory:(lastDirectory directoryName).
    ^ enteredFileNames

"
     FileDialog 
        requestFileNames:'enter a fileName:'
        default:''
        ok:nil 
        abort:nil 
        ifFail:['none']
        pattern:'*.conf'
        fromDirectory:Filename currentDirectory pathName
        whenBoxCreatedEvaluate:nil
        asLoadDialog:true.
"
!

startApplicationFor:titleString default:initialDefaultFileNameArg ok:okTextArg abort:abortTextArg ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath whenBoxCreatedEvaluate:boxCreatedCallback asLoadDialog:asLoadDialog viewFiles:viewFiles multipleSelect:multipleSelect
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "


    |defaultDir instance defaultFile okText abortText initialDefaultFileName|

    initialDefaultFileName := initialDefaultFileNameArg.
    initialDefaultFileName notNil ifTrue:[ 
        initialDefaultFileName := initialDefaultFileName asFilename 
    ].

    okText := okTextArg.
    okText isNil ifTrue:[ okText := self resources string:'OK' ]. 
    abortText := abortTextArg.
    abortText isNil ifTrue:[ abortText := self resources string:'Cancel' ]. 

    defaultDir := aDirectoryPath.
"/    defaultDir isNil ifTrue:[
"/        (initialDefaultFileName size > 0 and:[initialDefaultFileName exists]) ifTrue:[
"/            defaultDir := initialDefaultFileName asAbsoluteFilename directory.
"/        ] ifFalse:[
"/            defaultDir := FileSelectionBox lastFileSelectionDirectory.
"/            defaultDir isNil ifTrue:[
"/                defaultDir := Filename currentDirectory asAbsoluteFilename.        
"/            ].
"/            defaultDir asFilename exists ifFalse:[
"/                defaultDir := nil
"/            ].
"/        ]
"/    ].
    (initialDefaultFileName notNil 
    and:[initialDefaultFileName isAbsolute 
    and:[true "initialDefaultFileName asFilename exists"]]) ifTrue:[
        defaultDir := initialDefaultFileName asAbsoluteFilename.
        viewFiles ifTrue:[
            defaultDir := defaultDir directory.
        ].
    ] ifFalse:[
        defaultDir isNil ifTrue:[
            defaultDir := FileSelectionBox lastFileSelectionDirectory.
            defaultDir isNil ifTrue:[
                defaultDir := Filename currentDirectory asAbsoluteFilename.        
            ].
            defaultDir asFilename exists ifFalse:[
                defaultDir := nil
            ].
        ]
    ].
    defaultDir := defaultDir asFilename asAbsoluteFilename.
"/    [defaultDir exists] whileFalse:[
"/        defaultDir := defaultDir directory.
"/    ].

    viewFiles ifFalse:[
        defaultFile := defaultDir asAbsoluteFilename.
    ] ifTrue:[
        (initialDefaultFileName notNil and:[initialDefaultFileName withoutSuffix baseName ~= '*']) ifTrue:[
            defaultFile := defaultDir construct:initialDefaultFileName baseName.
        ].
    ].
    defaultFile isNil ifTrue:[
        defaultFile := defaultDir.
    ].

    instance := self new.
    defaultDir notNil ifTrue:[instance directory:defaultDir].
    instance multipleSelect:multipleSelect ? false.
    instance startFilename:defaultFile.
    instance pattern:((pattern isNil or:[pattern isEmpty]) ifTrue:['*'] ifFalse:[pattern]).
    instance initialText:titleString.
    instance okLabelHolder value:okText.
    instance cancelLabelHolder value:abortText.

    instance beLoadDialog:asLoadDialog ? false.
    instance viewFiles:viewFiles ? true.
    self setDoubleClickActionFor:instance.
    instance allButOpenInterface:#windowSpec.
    boxCreatedCallback notNil ifTrue:[boxCreatedCallback value:instance].

    Dialog aboutToOpenBoxNotificationSignal raiseRequestWith:instance.

    instance openWindowModal.
    ^ instance
! !

!FileDialogV2 class methodsFor:'accessing'!

setDoubleClickActionFor:instance

    instance doubleClickAction:[:anIndex|
        | item |
        item := instance contentsBrowser browserItemList at:anIndex ifAbsent:nil.
        item notNil ifTrue:[
            ((instance viewFiles and:[item isDirectory not]) 
            " or:[(instance viewFiles not and:[item isDirectory])] " ) ifTrue:[ 
                instance doAccept.
            ]
        ]
    ].
!

viewDetailsIcon
    ^ FileBrowserV2 viewDetailsIcon
! !

!FileDialogV2 class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    |spec|

    spec := AbstractFileBrowser flyByHelpSpec addPairsFrom:#(

#fileBrowse
'Browse'

).

"/    hist := self directoryHistory.
"/    hist notNil ifTrue:[
"/        hist canForward ifTrue:[
"/            spec at:#directoryForward put:(self classResources string:'Forward to: %1' with:hist nextForwardItem).
"/        ].
"/        hist canBackward ifTrue:[
"/            spec at:#directoryBack put:(self classResources string:'Back to: %1' with:hist nextBackwardItem).
"/        ].
"/    ].
    ^ spec.

    "
     self flyByHelpSpec
    "
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileDialogV2    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#fileHome
''

#fileBrowse
'Browse'

)
! !

!FileDialogV2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileDialogV2 andSelector:#windowSpec
     FileDialogV2 new openInterface:#windowSpec
     FileDialogV2 open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'FileDialogV2'
          name: 'FileDialogV2'
          min: (Point 10 10)
          max: (Point 1024 768)
          bounds: (Rectangle 0 0 400 400)
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: 'FilePart'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -32 1.0)
              component: 
             (SpecCollection
                collection: (
                 (MenuPanelSpec
                    name: 'ToolBar1'
                    layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 32 0)
                    tabable: true
                    menu: toolBarMenu
                    textDefault: true
                  )
                 (SubCanvasSpec
                    name: 'DirectoryContentsBrowser'
                    layout: (LayoutFrame 0 0.0 57 0 0 1.0 -30 1)
                    tabable: true
                    hasHorizontalScrollBar: false
                    hasVerticalScrollBar: false
                    majorKey: DirectoryContentsBrowser
                    createNewApplication: true
                    createNewBuilder: true
                    postBuildCallback: postBuildTreeBrowser:
                  )
                 (VariableHorizontalPanelSpec
                    name: 'VariableHorizontalPanel1'
                    layout: (LayoutFrame 0 0 32 0 0 1 57 0)
                    level: 1
                    showHandle: false
                    barLevel: 0
                    component: 
                   (SpecCollection
                      collection: (
                       (ViewSpec
                          name: 'Box1'
                        )
                       (ViewSpec
                          name: 'Box2'
                          component: 
                         (SpecCollection
                            collection: (
                             (LabelSpec
                                label: 'Filter:'
                                name: 'FilterLabel'
                                layout: (LayoutFrame 8 0 2 0 59 0 -2 1)
                                translateLabel: true
                                adjust: right
                              )
                             (InputFieldSpec
                                name: 'FilterEntryField'
                                layout: (LayoutFrame 60 0 -22 1 -2 1 -2 1)
                                model: filterHolder
                                immediateAccept: true
                                acceptOnReturn: true
                                acceptOnTab: true
                                acceptOnLostFocus: true
                                acceptOnPointerLeave: false
                                postBuildCallback: postBuildFilterField:
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                    handles: (Any 0.5 1.0)
                  )
                 (LabelSpec
                    label: 'Filename:'
                    name: 'FilenameLabel'
                    layout: (LayoutFrame 3 0 -21 1 73 0 -1 1)
                    translateLabel: true
                    labelChannel: filenameLabelHolder
                    adjust: left
                  )
                 (FilenameInputFieldSpec
                    name: 'FilenameEntryField'
                    layout: (LayoutFrame 70 0 -21 1 -4 1 -1 1)
                    tabable: true
                    model: filenameHolder
                    immediateAccept: false
                    acceptOnPointerLeave: false
                    hasKeyboardFocusInitially: true
                    postBuildCallback: postBuildFileNameField:
                  )
                 )
               
              )
            )
           (HorizontalPanelViewSpec
              name: 'ButtonPanel'
              layout: (LayoutFrame 0 0.0 -32 1 0 1 0 1)
              visibilityChannel: buttonPanelVisibleHolder
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'cancelButton'
                    translateLabel: true
                    labelChannel: cancelLabelHolder
                    tabable: true
                    model: doCancel
                    extent: (Point 129 22)
                  )
                 (ActionButtonSpec
                    label: 'Append'
                    name: 'appendButton'
                    visibilityChannel: appendButtonVisibleHolder
                    translateLabel: true
                    labelChannel: appendLabelHolder
                    tabable: true
                    model: appendPressed
                    extent: (Point 129 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'okButton'
                    translateLabel: true
                    labelChannel: okLabelHolder
                    tabable: true
                    model: okPressed
                    isDefault: true
                    extent: (Point 130 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!FileDialogV2 class methodsFor:'menu specs'!

toolBarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileDialogV2 andSelector:#toolBarMenu
     (Menu new fromLiteralArrayEncoding:(FileDialogV2 toolBarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: directoryBack
            enabled: enableBack
            label: 'Back'
            itemValue: doBack
            translateLabel: true
            isButton: true
            submenuChannel: menuDirHistoryBack
            labelImage: (ResourceRetriever ToolbarIconLibrary historyBackIcon)
            keepLinkedMenu: true
          )
         (MenuItem
            activeHelpKey: directoryForward
            enabled: enableForward
            label: 'Forward'
            itemValue: doForward
            translateLabel: true
            isButton: true
            submenuChannel: menuDirHistoryForward
            labelImage: (ResourceRetriever ToolbarIconLibrary historyForwardIcon)
            keepLinkedMenu: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: directoryUp
            enabled: enableDirectoryUp
            label: 'DirectoryUp'
            itemValue: doGoDirectoryUp
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryUpIcon)
          )
         (MenuItem
            label: ''
          )
         (MenuItem
            activeHelpKey: fileHome
            enabled: enableHome
            label: 'Home'
            itemValue: doGotoHomeDirectory
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary homeIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoBookmark
            label: 'Bookmarks'
            translateLabel: true
            isButton: true
            submenuChannel: gotoBookmarksMenuSpec
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryBookmarksIcon)
          )
         (MenuItem
            label: '-'
            isVisible: browseVisibleHolder
          )
         (MenuItem
            activeHelpKey: fileBrowse
            label: 'Browse'
            itemValue: doBrowseDirectory
            translateLabel: true
            isButton: true
            isVisible: browseVisibleHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary fileBrowser24x24Icon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'New Directory...'
            itemValue: newDirectory
            translateLabel: true
            isButton: true
            isVisible: newDirectoryVisibilityHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary newDirectoryIcon)
          )
         (MenuItem
            label: 'viewDetails'
            translateLabel: true
            isButton: true
            startGroup: right
            hideMenuOnActivated: false
            indication: viewDetails
            labelImage: (ResourceRetriever ToolbarIconLibrary viewDetailsIcon)
          )
         (MenuItem
            activeHelpKey: toggleDetails
            label: 'viewDetails'
            translateLabel: true
            isButton: true
            startGroup: right
            isVisible: false
            indication: viewDetails
            submenuChannel: viewDetailsMenuSpec
            labelImage: (ResourceRetriever ToolbarIconLibrary viewDetailsIcon)
          )
         (MenuItem
            activeHelpKey: selectDetails
            label: ''
            isButton: true
            startGroup: right
            submenuChannel: viewDetailsMenuSpec
            labelImage: (ResourceRetriever ToolbarIconLibrary empty1x20Icon)
          )
         )
        nil
        nil
      )

    "Modified: / 06-12-2006 / 12:08:39 / cg"
! !

!FileDialogV2 methodsFor:'accessing'!

currentSelectedFiles

    | selectedFiles|

    selectedFiles := contentsBrowser currentFileNameHolder value.
    ^ selectedFiles select:[:aFile| aFile isDirectory not].
!

directory
    "return the value of the instance variable 'directory' (automatically generated)"

    ^ directory
!

directory:something
    "set the value of the instance variable 'directory' (automatically generated)"

    directory := something.
!

initialText

    initialText isNil ifTrue:[
        ^ resources string:'File Dialog'.
    ].
    ^ resources string:initialText
!

initialText:something
    "set the value of the instance variable 'initialText' (automatically generated)"

    initialText := something.
!

pattern
    "return the value of the instance variable 'pattern' (automatically generated)"

    ^ pattern
!

pattern:something
    "set the value of the instance variable 'pattern' (automatically generated)"

    pattern := something.
!

result
    "return the value of the instance variable 'result' (automatically generated)"

    ^ result
!

result:something
    "set the value of the instance variable 'result' (automatically generated)"

    result := something.
!

selectedDirectories

    | selectedFiles|

    selectedFiles := contentsBrowser currentFileNameHolder value.
    ^ selectedFiles select:[:aFile| aFile isDirectory].
!

startFilename
    "return the value of the instance variable 'startFilename' (automatically generated)"

    startFilename isNil ifTrue:[
        startFilename := Filename currentDirectory asAbsoluteFilename.
    ].
    ^ startFilename
!

startFilename:something
    "set the value of the instance variable 'startFilename' (automatically generated)"

    startFilename := something.
! !

!FileDialogV2 methodsFor:'accessing browser'!

showHiddenFiles
    ^ contentsBrowser showHiddenFiles
!

userContextAvailable
    ^ contentsBrowser userContextAvailable
!

viewDescription
    ^ contentsBrowser viewDescription
!

viewDetails
    ^ contentsBrowser viewDetails
!

viewDetailsMenuSpec
    ^ contentsBrowser viewDetailsMenuSpec
!

viewGroup
    ^ contentsBrowser viewGroup
!

viewIcon
    ^ contentsBrowser viewIcon
!

viewInodeNumber
    ^ contentsBrowser viewInodeNumber
!

viewOwner
    ^ contentsBrowser viewOwner
!

viewPermissions
    ^ contentsBrowser viewPermissions
!

viewPreview
    ^ contentsBrowser viewPreview
!

viewSize
    ^ contentsBrowser viewSize
!

viewSizeInBytes
    ^ contentsBrowser viewSizeInBytes
!

viewSizeInKiloBytes
    ^ contentsBrowser viewSizeInKiloBytes
!

viewTime
    ^ contentsBrowser viewTime
!

viewType
    ^ contentsBrowser viewType
! !

!FileDialogV2 methodsFor:'accessing-behavior'!

asLoadDialog
    ^ self isLoadDialog
!

asLoadDialog:aBoolean
    self beLoadDialog:aBoolean
!

beLoadDialog:aBoolean

    isLoadDialog := aBoolean
!

doubleClickAction
    "return the value of the instance variable 'doubleClickAction' (automatically generated)"

    ^ doubleClickAction
!

doubleClickAction:something
    "set the value of the instance variable 'doubleClickAction' (automatically generated)"

    doubleClickAction := something.
!

isLoadDialog

    ^ isLoadDialog ? true
!

multipleSelect
    ^ multipleSelect ? false
!

multipleSelect:aBoolean
    multipleSelect := aBoolean.
    contentsBrowser notNil ifTrue:[
        contentsBrowser multipleSelect:aBoolean.
    ].
! !

!FileDialogV2 methodsFor:'accessing-components'!

addButton:aButton
    DialogBox defaultOKButtonAtLeft ifTrue:[
        (self componentAt:#ButtonPanel) addSubView:aButton before:(self okButton)
    ] ifFalse:[
        (self componentAt:#ButtonPanel) addSubView:aButton after:(self okButton)
    ].
!

contentsBrowser
    "return the value of the instance variable 'treeBrowser' (automatically generated)"

    ^ contentsBrowser
!

okButton
    ^ (self componentAt:#okButton) 
! !

!FileDialogV2 methodsFor:'accessing-look'!

browseVisibleHolder
    ^ true
!

hideButtonPanel
    self buttonPanelVisibleHolder value:false
!

newDirectoryVisibilityHolder
    newDirectoryVisibilityHolder isNil ifTrue:[
        newDirectoryVisibilityHolder := true asValue.
    ].
    ^ newDirectoryVisibilityHolder
!

showButtonPanel
    self buttonPanelVisibleHolder value:true
!

viewFiles
    "return the value of the instance variable 'viewFiles' (automatically generated)"

    ^ viewFiles
!

viewFiles:something
    "set the value of the instance variable 'viewFiles' (automatically generated)"

    viewFiles := something.
! !

!FileDialogV2 methodsFor:'aspects'!

appendButtonVisibleHolder
    appendButtonVisibleHolder isNil ifTrue:[
        appendButtonVisibleHolder := false asValue.
    ].
    ^ appendButtonVisibleHolder
!

appendLabelHolder
    appendLabelHolder isNil ifTrue:[
        appendLabelHolder := 'Append' asValue.
    ].
    ^ appendLabelHolder
!

aspectOrNil:aKey forSubApplication:aSubApp
    "this hook provides an aspect for a subApp"

    aKey == #currentFileNameHolder ifTrue:[
        directory notNil ifTrue:[
            ^ (OrderedCollection with:directory) asValue
        ]
    ].
    ^ nil
!

buttonPanelVisibleHolder
    buttonPanelVisibleHolder isNil ifTrue:[
        buttonPanelVisibleHolder := true asValue.
        buttonPanelVisibleHolder onChangeSend:#buttonPanelVisibilityChanged to:self.
    ].
    ^ buttonPanelVisibleHolder.
!

cancelLabelHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    cancelLabelHolder isNil ifTrue:[
        cancelLabelHolder := 'Cancel' asValue.
    ].
    ^ cancelLabelHolder.
!

enableBack
    ^ contentsBrowser enableBack.
!

enableDirectoryUp
    ^ contentsBrowser enableDirectoryUp.
!

enableForward
    ^ contentsBrowser enableForward.
!

enableHome
    ^ contentsBrowser enableHome.
!

filenameHolder
    "Return a value holder with the filename.
     Shown in the filename input-field.
     Being the selection in the tree.
    "
    |holder|
    holder := builder bindingAt:#filenameHolder.

    holder ifNil:[
        holder := ValueHolder new.
        holder addDependent:self.
        builder aspectAt:#filenameHolder 
                     put:holder.
    ].

    ^ holder.
!

filenameLabelHolder
    "Return a value holder for the input string.
    "
    filenameLabelHolder isNil ifTrue:[
        filenameLabelHolder := 'Filename:' asValue.
    ].
    ^ filenameLabelHolder
!

filterHolder
    "Return a value holder for filter
    "

    filterHolder isNil ifTrue:[
        filterHolder := contentsBrowser filterModel.
        self pattern notNil ifTrue:[
            filterHolder value:pattern.
        ]
    ].
    ^ filterHolder
!

gotoBookmarksMenuSpec
    <resource: #programMenu>

    ^ contentsBrowser gotoBookmarksMenuSpec

"/    |menu bookmarks|
"/
"/    menu := contentsBrowser class emptyMenuSpec decodeAsLiteralArray.
"/    menu findGuiResourcesIn:self.
"/    menu receiver:self.
"/
"/    "/ add the bookmark items ...
"/    bookmarks := contentsBrowser class directoryBookmarks.
"/    bookmarks notEmptyOrNil ifTrue:[
"/        bookmarks do:[:dirName |
"/            menu addItem:((MenuItem label:dirName asString value:[
"/                (contentsBrowser currentDirectories value includes:dirName) ifFalse:[
"/                    contentsBrowser setCurrentFileName:dirName.
"/                ].
"/            ])).
"/        ].
"/    ].
"/    ^ menu

    "Modified: / 06-12-2006 / 12:06:17 / cg"
!

okLabelHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    okLabelHolder isNil ifTrue:[
        okLabelHolder := 'OK' asValue.
    ].
    ^ okLabelHolder.
! !

!FileDialogV2 methodsFor:'change & update'!

buttonPanelVisibilityChanged
    |filePart|

    filePart := builder componentAt:#FilePart.
    filePart notNil ifTrue:[
        buttonPanelVisibleHolder value ifTrue:[
            filePart layout bottomOffset:-40
        ] ifFalse:[
            filePart layout bottomOffset:0
        ].
        filePart containerChangedSize    "/ force resize
   ]
!

update:something with:aParameter from:changedObject
    |files newFile newLabel fn entryFieldFilename|

    changedObject == contentsBrowser currentFileNameHolder ifTrue:[
        files := changedObject value.

        (files isEmpty) ifTrue:[
            newFile := nil.
        ] ifFalse:[
            files size == 1 ifTrue:[
                newFile := files first.    
            ] ifFalse:[
                newFile := ''.
            ].
        ].
        (self filenameHolder value notNil and:[newFile asFilename isDirectory]) ifTrue:[
            entryFieldFilename := self filenameHolder value asFilename.
            self startFilename asFilename baseName = entryFieldFilename baseName ifTrue:[
                entryFieldFilename isDirectory not ifTrue:[
                    newFile := newFile asFilename construct:entryFieldFilename baseName.
                ].
            ].
        ].
        self filenameHolder value:newFile withoutNotifying:self.
    ].

    changedObject == contentsBrowser viewFilesInDirectoryTree ifTrue:[
        changedObject value ifTrue:[
            newLabel := 'Filename:'.
        ] ifFalse:[
            newLabel := 'Directory:'.
        ].
        self filenameLabelHolder value:(resources string:newLabel)
    ].
    changedObject == self filenameHolder ifTrue:[
        fn := changedObject value asFilename.
        (fn exists) ifFalse:[^ self].
        contentsBrowser currentFileNameHolder value:(OrderedCollection with:fn) withoutNotifying:self.
    ].
    ^ super update:something with:aParameter from:changedObject
! !

!FileDialogV2 methodsFor:'event handling'!

appendWasPressed
    "valid after the dialog has been closed: true if append was pressed"

    ^ appendWasPressed
! !

!FileDialogV2 methodsFor:'initialization & release'!

postBuildFileNameField:aWidget

    filenameField := aWidget.
!

postBuildFilterField:aWidget

    filterField := aWidget.
!

postBuildTreeBrowser:aSubCanvasView

    contentsBrowser := aSubCanvasView client.
!

postBuildWith:aBuilder    
    contentsBrowser multipleSelect:multipleSelect.
    appendWasPressed := false.

    (aBuilder componentAt:'cancelButton') cursor:(Cursor thumbsDown).
    (aBuilder componentAt:'appendButton') cursor:(Cursor thumbsUp).
    (aBuilder componentAt:'okButton') cursor:(Cursor thumbsUp).

    ^ super postBuildWith:aBuilder
!

postOpen
    |directory rootDirectory|

"/     self windowGroup addPreEventHook:self.

    "No ok and cancel buttons, when dialog is part of a larger dialog"
    self window topView isModal ifFalse:[
        self hideButtonPanel
    ].

    contentsBrowser currentFileNameHolder addDependent:self.
    contentsBrowser doubleClickAction:self doubleClickAction.

    directory := (self directory) ? (Filename currentDirectory asAbsoluteFilename).
    rootDirectory := directory asFilename directory.
    contentsBrowser rootHolder value:rootDirectory.

    contentsBrowser viewDirsInContentsBrowser value:true.
    contentsBrowser sortDirectoriesBeforeFiles value:true.
    contentsBrowser viewFilesInContentsBrowser setValue:(self viewFiles ? true).
    contentsBrowser viewFilesInDirectoryTree changed.
    contentsBrowser currentFileNameHolder value:(OrderedCollection with:self startFilename).

    self isLoadDialog ifTrue:[
"/        contentsBrowser newVisibilityHolder value:false.
"/        contentsBrowser allowFileOperations value:false.
        self newDirectoryVisibilityHolder value:false.
    ].
    self filenameHolder value:self startFilename.
    self window label:self initialText.
!

postOpenAsSubcanvasWith:aBuilder    
    self postOpen.
    ^ super postOpenAsSubcanvasWith:aBuilder
!

postOpenWith:aBuilder    

    self postOpen.
    ^ super postOpenWith:aBuilder.
! !

!FileDialogV2 methodsFor:'private'!

returnWasPressedInFilterField
    |ev|

    ev := self windowGroup lastEvent.
    (ev notNil 
    and:[ev isKeyEvent 
    and:[ev key == #Return
    and:[(   ev targetView isSameOrComponentOf:filterField) 
         or:[false "ev targetView isSameOrComponentOf:filenameField"]]]]) ifTrue:[
        ^ true
    ].
    ^ false
!

returnWasPressedInFilterOrFilenameField
    |ev|

    ev := self windowGroup lastEvent.
    (ev notNil 
    and:[ev isKeyEvent 
    and:[ev key == #Return
    and:[(   ev targetView isSameOrComponentOf:filterField) 
         or:[false "ev targetView isSameOrComponentOf:filenameField"]]]]) ifTrue:[
        ^ true
    ].
    ^ false
! !

!FileDialogV2 methodsFor:'user actions'!

appendPressed
    appendWasPressed := true.
    self commonAcceptAction.
!

commonAcceptAction
    filenameField accept.
    self result:(self filenameHolder value asString).

    ^ super doAccept
!

doAccept
    "force accept - ignore in filterField"

    self returnWasPressedInFilterField ifTrue:[
        ^ self
    ].
    appendWasPressed := false.
    self commonAcceptAction.
!

doBack

    contentsBrowser doBack.
!

doCancel

    self result:nil.
    ^ super doCancel.
!

doForward

    contentsBrowser doForward.
!

doGoDirectoryUp

    contentsBrowser doGoDirectoryUp.
!

doGotoHomeDirectory

    contentsBrowser doGotoHomeDirectory.
!

menuDirHistory:backOrForward

    ^ contentsBrowser menuDirHistory:backOrForward.
!

menuDirHistoryBack

    ^ contentsBrowser menuDirHistory:#back.
!

menuDirHistoryForward

    ^ contentsBrowser menuDirHistory:#forward.
!

newDirectory

    ^ contentsBrowser newDirectory
!

okPressed
    self doAccept
! !

!FileDialogV2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/FileDialogV2.st,v 1.6 2006/12/06 11:09:13 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

