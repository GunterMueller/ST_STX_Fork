"
 COPYRIGHT (c) 2002 by eXept Software AG
 COPYRIGHT (c) 2018 Jan Vrany
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

SimpleDialog subclass:#FileDialog
	instanceVariableNames:'aspects treeBrowser directory pattern filterHolder initialText
		multipleSelect doubleClickAction cancelLabelHolder okLabelHolder
		startFilename result filterField filenameField viewFiles
		filenameLabelHolder isLoadDialog newDirectoryVisibilityHolder
		appendButtonVisibleHolder appendWasPressed
		buttonPanelVisibleHolder appendLabelHolder browseVisibleHolder
		selectedDeviceDrive listOfDeviceDrives rootDirectoryHolder
		initialRoot verticalPanelView okLabelEnabled'
	classVariableNames:'LastExtent'
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
 COPYRIGHT (c) 2018 Jan Vrany
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
    A slightly better file dialog

    [author:]
        Martin Walser (martin@vercingetorix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  usually direct access to FileDialog is not recommended;
  please use the Dialog interface, which is able to dispatch to
  alternative file choosers if the settings say so 
  (native dialogs, for example):
                                                                [exBegin]
    |fileOrNil|

    fileOrNil := Dialog requestFileName:'Choose a File'.
    Transcript showCR:fileOrNil
                                                                [exEnd]

  simple examples:
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

                                                                [exBegin]
    |fd|

    fd := FileDialog new.
    fd multipleSelect:true.
    fd browseMenuItemVisible:false.
    fd open
                                                                [exEnd]

    Adding custom components:
                                                                [exBegin]
    Dialog modifyingBoxWith:[:dialog |
        | fmtBox |

        fmtBox := ComboListView new.
        fmtBox list: #('Comma Separated Values (.csv)'
                        'Microsoft Excel (.xls)'
                        'Microsoft Excel XML (.xlsx)') .
        fmtBox model:'Select...' asValue.
        dialog application addComponent: fmtBox.
    ] do:[
        Dialog requestFileName: 'Save file as...'
    ]
                                                                [exEnd]

"
!

todo
"
    - make the filedialog windows like 
      filename entry field shows only the filename not the whole directory 
      the tree allways starts in currrent directory
      the parent tree is shown in a compobox where the perents are selectable

    - do not expand the ~ or relative pathnames to absolute pathnames        
"
! !

!FileDialog class methodsFor:'instance creation'!

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
     FileDialog
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
    enteredFileName isRelative ifTrue:[
        enteredFileName := instance directory construct:enteredFileNameString
    ].

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
                (Dialog confirm:(self classResources stringWithCRs:'''%1'' exists.\\Continue anyway ?' with:enteredFileNameString))
                    ifFalse:[^ ''].
            ].
        ].
        versionSymbol == #mustBeOld ifTrue:[
            enteredFileName exists ifFalse:[^ ''].
        ].
        versionSymbol == #old ifTrue:[
            "/ file may not exist
            enteredFileName exists ifFalse:[
                (self confirm:(self classResources stringWithCRs:'''%1'' does not exist yet.\\Continue anyway ?' with:enteredFileNameString))
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
     FileDialog
        requestDirectoryName:'which directory ?' 
        default:Filename currentDirectory pathName
        ok:'Yes'
        ifFail:'none'
    "
!

requestFileName:titleString default:defaultName ok:okText abort:abortText pattern:pattern fromDirectory:aDirectoryPathOrNil
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed."

    ^ self
        requestFileName:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        pattern:pattern 
        fromDirectory:aDirectoryPathOrNil 
        whenBoxCreatedEvaluate:nil

    "Created: / 14-02-2011 / 17:59:21 / cg"
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
    enteredFileNameString isEmptyOrNil ifTrue:[
        ^ failBlock value
    ].

    enteredFileName := enteredFileNameString asFilename.
    enteredFileName isRelative ifTrue:[
        (versionSymbol isNil and:[#(http https ftp) includes:(enteredFileNameString upToAll:'://')]) ifTrue:[
            ^ enteredFileNameString.
        ] ifFalse:[
            enteredFileName := instance directory construct:enteredFileNameString.
            enteredFileNameString := enteredFileName asString.
        ].
    ].

    FileSelectionBox lastFileSelectionDirectory:(enteredFileName directoryName).

    versionSymbol isNil ifTrue:[ ^ enteredFileNameString].
    versionSymbol == #mustBeNew ifTrue:[
        "/ file must not exist
        enteredFileName exists ifTrue:[^ failBlock value].
    ].
    versionSymbol == #new ifTrue:[
        "/ file should not exist
        enteredFileName exists ifTrue:[
            (Dialog confirm:(self classResources stringWithCRs:'''%1'' exists.\\Continue anyway ?' with:enteredFileNameString))
                ifFalse:[^ failBlock value].
        ].
    ].
    versionSymbol == #mustBeOld ifTrue:[
        "/ file must exist
        enteredFileName exists ifFalse:[^ failBlock value].
    ].
    versionSymbol == #old ifTrue:[
        "/ file should exist
        enteredFileName exists ifFalse:[
            (self confirm:(self classResources stringWithCRs:'''%1'' does not exist yet.\\Continue anyway ?' with:enteredFileNameString))
            ifFalse:[^ failBlock value].
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

requestFileName:titleString default:defaultName pattern:pattern fromDirectory:aDirectory
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those from the current directory.
     The box will show ok/cancel in its buttons.
     The matchPattern is set to pattern initially.
     Return the string or nil if cancel was pressed."

    |resources|

    resources := self classResources.
    ^ self 
        requestFileName:titleString 
        default:defaultName
        ok:(resources string:'OK') 
        abort:(resources string:'Cancel') 
        pattern:pattern
        fromDirectory:aDirectory

    "Created: / 14-02-2011 / 17:59:14 / cg"
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
     FileDialog 
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
        initialDefaultFileName := initialDefaultFileName asFilename.
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
        true "viewFiles" ifTrue:[
            defaultFile := defaultDir asAbsoluteFilename.
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

    defaultFile isNil ifTrue:[
        viewFiles ifFalse:[
            defaultFile := defaultDir asAbsoluteFilename.
        ] ifTrue:[
            (initialDefaultFileName notNil and:[initialDefaultFileName withoutSuffix baseName ~= '*']) ifTrue:[
                defaultFile := defaultDir construct:initialDefaultFileName baseName.
            ] ifFalse:[
                defaultFile := defaultDir.
            ].
        ].
    ].

    instance := self new.
    defaultDir notNil ifTrue:[instance directory:defaultDir].
    instance 
        multipleSelect:multipleSelect ? false;
       startFilename:defaultFile;
       pattern:(pattern isEmptyOrNil ifTrue:['*'] ifFalse:[pattern]);
       initialText:titleString;
       beLoadDialog:asLoadDialog ? false;
       viewFiles:viewFiles ? true.

     instance okLabelHolder value:okText.
     instance cancelLabelHolder value:abortText.

    self setDoubleClickActionFor:instance.
    instance allButOpenInterface:#windowSpec.
    boxCreatedCallback notNil ifTrue:[boxCreatedCallback value:instance].

    "/ Dialog aboutToOpenBoxNotificationSignal raiseRequestWith:instance.
    instance treeBrowser sortCaselessInTreeBrowser value: (Filename isCaseSensitive not).
    instance openWindowModal.
    ^ instance

    "Modified: / 23-08-2006 / 12:24:54 / cg"
    "Modified: / 13-12-2006 / 16:25:42 / User"
! !

!FileDialog class methodsFor:'accessing'!

classResources
    ^ (FileBrowserV2 ? AbstractFileBrowser) classResources
!

lastExtent
    ^ LastExtent
!

lastExtent:anExtent
    LastExtent := anExtent
!

setDoubleClickActionFor:instance

    instance doubleClickAction:[:anIndex|
        | item |
        item := instance treeBrowser fileList at:anIndex ifAbsent:nil.
        item notNil ifTrue:[
            (instance viewFiles and:[item isDirectory not]) ifTrue:[ 
                instance doAccept.
            ]
        ]
    ].
! !

!FileDialog class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:FileDialog    
    "

    <resource: #help>

    ^ FileBrowserV2 flyByHelpSpec addPairsFrom:#(

#openFileBrowser
'Open a FileBrowser on the selected directory'

)
! !

!FileDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileDialog andSelector:#windowSpec
     FileDialog new openInterface:#windowSpec
     FileDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'FileDialog'
         name: 'FileDialog'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 460 482)
         menu: mainMenu
         performer: treeBrowser
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'FilePanel'
             layout: (LayoutFrame 0 0 0 0 0 1 -40 1)
             horizontalLayout: fit
             verticalLayout: bottomFit
             horizontalSpace: 0
             verticalSpace: 3
             elementsChangeSize: true
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'FilePart'
                   component: 
                  (SpecCollection
                     collection: (
                      (MenuPanelSpec
                         name: 'ToolBar1'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 40 0)
                         tabable: true
                         menu: toolBarMenu
                         textDefault: true
                       )
                      (VariableHorizontalPanelSpec
                         name: 'DeviceAndFilterPanel'
                         layout: (LayoutFrame 0 0 40 0 0 1 70 0)
                         level: 1
                         showHandle: true
                         component: 
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'Box1'
                               component: 
                              (SpecCollection
                                 collection: (
                                  (ComboListSpec
                                     name: 'ComboList1'
                                     layout: (LayoutFrame 1 0 1 0.0 -1 1 -1 1)
                                     visibilityChannel: driveSelectorVisible
                                     model: selectedDeviceDrive
                                     comboList: listOfDeviceDrives
                                     useIndex: false
                                     hidePullDownMenuButton: false
                                   )
                                  )
                                
                               )
                             )
                            (ViewSpec
                               name: 'Box2'
                               component: 
                              (SpecCollection
                                 collection: (
                                  (LabelSpec
                                     label: 'Filter:'
                                     name: 'FilterLabel'
                                     layout: (LayoutFrame 1 0 2 0 59 0 -2 1)
                                     translateLabel: true
                                     adjust: right
                                   )
                                  (InputFieldSpec
                                     name: 'FilterEntryField'
                                     layout: (LayoutFrame 60 0 -27 1 -2 1 -2 1)
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
                         handles: (Any 0.29999999999999999 1.0)
                       )
                      (SubCanvasSpec
                         name: 'DirectoryTreeBrowser'
                         layout: (LayoutFrame 0 0.0 70 0 0 1.0 -34 1)
                         tabable: true
                         hasHorizontalScrollBar: false
                         hasVerticalScrollBar: false
                         majorKey: DirectoryTreeBrowser
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: filterModel
                             aspect: filterHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: rootHolder
                             aspect: rootDirectoryHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: showHiddenFiles
                             aspect: showHiddenFiles
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                         postBuildCallback: postBuildTreeBrowser:
                       )
                      (LabelSpec
                         label: 'Filename:'
                         name: 'FilenameLabel'
                         layout: (LayoutFrame 3 0 -28 1 110 0 -1 1)
                         translateLabel: true
                         labelChannel: filenameLabelHolder
                         adjust: left
                       )
                      (FilenameInputFieldSpec
                         name: 'FilenameEntryField'
                         layout: (LayoutFrame 110 0 -28 1 -2 1 -1 1)
                         tabable: true
                         model: filenameHolder
                         immediateAccept: false
                         acceptOnPointerLeave: true
                         hasKeyboardFocusInitially: true
                         postBuildCallback: postBuildFileNameField:
                       )
                      )
                    
                   )
                   extent: (Point 460 442)
                 )
                )
              
             )
             postBuildCallback: postBuildVerticalPanelView:
           )
          (HorizontalPanelViewSpec
             name: 'ButtonPanel'
             layout: (LayoutFrame 0 0.0 -34 1 -16 1 0 1)
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
                   extent: (Point 142 32)
                   usePreferredHeight: true
                 )
                (ActionButtonSpec
                   label: 'Append'
                   name: 'appendButton'
                   visibilityChannel: appendButtonVisibleHolder
                   translateLabel: true
                   labelChannel: appendLabelHolder
                   tabable: true
                   model: appendPressed
                   extent: (Point 143 32)
                   usePreferredHeight: true
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'okButton'
                   translateLabel: true
                   labelChannel: okLabelHolder
                   tabable: true
                   model: okPressed
                   enableChannel: okLabelEnabled
                   isDefault: true
                   extent: (Point 143 32)
                   usePreferredHeight: true
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
! !

!FileDialog class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileDialog andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(FileDialog mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Directory'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Up'
                  itemValue: doGoDirectoryUp
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: directoryBack
                  enabled: enableBack
                  label: 'Back'
                  itemValue: doBack
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: directoryBack
                  enabled: enableForward
                  label: 'Forward'
                  itemValue: doForward
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: enableHome
                  label: 'Home Directory'
                  itemValue: doGotoHomeDirectory
                  translateLabel: true
                )
               (MenuItem
                  label: 'Bookmarks'
                  translateLabel: true
                  submenuChannel: bookmarksMenu
                )
               (MenuItem
                  label: 'Visited Directories'
                  translateLabel: true
                  submenuChannel: visitedDirectoriesMenu
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'View'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Sort'
                  translateLabel: true
                  submenuChannel: sortMenu
                )
               (MenuItem
                  label: 'Show'
                  translateLabel: true
                  submenuChannel: showMenuSpecForDialog
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Update'
                  itemValue: updateCurrentDirectory
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
!

toolBarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FileDialog andSelector:#toolBarMenu
     (Menu new fromLiteralArrayEncoding:(FileDialog toolBarMenu)) startUp
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
            labelImage: (ResourceRetriever AbstractFileBrowser historyBackIcon)
            keepLinkedMenu: true
          )
         (MenuItem
            label: ''
          )
         (MenuItem
            activeHelpKey: directoryForward
            enabled: enableForward
            label: 'Forward'
            itemValue: doForward
            translateLabel: true
            isButton: true
            submenuChannel: menuDirHistoryForward
            labelImage: (ResourceRetriever AbstractFileBrowser historyForwardIcon)
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
            labelImage: (ResourceRetriever AbstractFileBrowser directoryUpIcon)
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
            activeHelpKey: fileDesktop
            enabled: enableGotoDesktop
            label: 'Desktop'
            itemValue: doGotoDesktopDirectory
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary desktopIcon)
          )
         (MenuItem
            activeHelpKey: fileGotoBookmark
            label: 'Bookmarks'
            translateLabel: true
            isButton: true
            submenuChannel: gotoBookmarksMenu
            labelImage: (ResourceRetriever ToolbarIconLibrary directoryBookmarksIcon)
          )
         (MenuItem
            label: '-'
            isVisible: newDirectoryVisibilityHolder
          )
         (MenuItem
            label: 'New Directory...'
            itemValue: newDirectory
            translateLabel: true
            isButton: true
            isVisible: newDirectoryVisibilityHolder
            labelImage: (ResourceRetriever AbstractFileBrowser newDirectoryIcon)
          )
         (MenuItem
            label: '-'
            isVisible: browseVisibleHolder
          )
         (MenuItem
            activeHelpKey: openFileBrowser
            label: 'Browse'
            itemValue: doBrowseDirectory
            translateLabel: true
            isButton: true
            isVisible: browseMenuItemVisibleHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary startFileBrowserIcon)
          )
         )
        nil
        nil
      )
!

viewInContentsBrowserMenu
    ^ DirectoryContentsBrowser showMenuSpec
! !

!FileDialog class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #filenameHolder
        #filterHolder
        #rootDirectoryHolder
      ).

! !

!FileDialog methodsFor:'accessing'!

currentSelectedFiles

    | selectedFiles|

    selectedFiles := treeBrowser currentFileNameHolder value.
    ^ selectedFiles reject:[:aFile| aFile isDirectory ].
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
    ^ resources string:(initialText ? 'File Dialog')
!

initialText:something
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

    selectedFiles := treeBrowser currentFileNameHolder value.
    ^ selectedFiles select:[:aFile| aFile isDirectory].
!

startFilename
    startFilename isNil ifTrue:[
        startFilename := Filename currentDirectory asAbsoluteFilename.
    ].
    ^ startFilename
!

startFilename:something
    startFilename := something.
! !

!FileDialog methodsFor:'accessing-behavior'!

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
    treeBrowser notNil ifTrue:[
        treeBrowser multipleSelect:aBoolean.
    ].
! !

!FileDialog methodsFor:'accessing-components'!

addButton:aButton
    |buttonPanel okButton|

    buttonPanel := self componentAt:#ButtonPanel.
    okButton := self okButton.

    DialogBox defaultOKButtonAtLeft ifTrue:[
        buttonPanel addSubView:aButton before:okButton
    ] ifFalse:[
        buttonPanel addSubView:aButton after:okButton
    ].
!

okButton
    ^ (self componentAt:#okButton) 
!

treeBrowser
    "return the value of the instance variable 'treeBrowser' (automatically generated)"

    ^ treeBrowser
! !

!FileDialog methodsFor:'accessing-look'!

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

!FileDialog methodsFor:'aspects'!

appendButtonVisibleHolder
    "if set, an additional 'append' button is shown
     (to let user append to a file, instead of overwriting the file)"

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

browseMenuItemVisible:aBoolean
    "controls if an 'open filebrowser' menu item is to be shown in the toolbar"

    self browseMenuItemVisibleHolder value:aBoolean
!

browseMenuItemVisibleHolder
    "controls if an 'open filebrowser' menu item is to be shown in the toolbar"

    browseVisibleHolder isNil ifTrue:[
        browseVisibleHolder := true "false" asValue.
    ].
    ^ browseVisibleHolder.
!

browseVisibleHolder
    "controls if an 'open filebrowser' menu item is to be shown in the toolbar"

    <resource: #obsolete>
    ^ self browseMenuItemVisibleHolder.
!

buttonPanelVisibleHolder
    buttonPanelVisibleHolder isNil ifTrue:[
        buttonPanelVisibleHolder := true asValue.
        buttonPanelVisibleHolder onChangeSend:#buttonPanelVisibilityChanged to:self.
    ].
    ^ buttonPanelVisibleHolder.
!

cancelLabelHolder

    cancelLabelHolder isNil ifTrue:[
        cancelLabelHolder := 'Cancel' asValue.
    ].
    ^ cancelLabelHolder.
!

enableBack
    ^ treeBrowser enableBack.
!

enableDirectoryUp
    ^ treeBrowser enableDirectoryUp.
!

enableForward
    ^ treeBrowser enableForward.
!

enableGotoDesktop
    ^ treeBrowser enableGotoDesktop.
!

enableHome
    ^ treeBrowser enableHome.
!

fileEntryFieldHolder
    "for directoryTreeBrowser"

    ^ self filenameHolder
!

filenameHolder
    "Return a value holder with the filename.
     Shown in the filename input-field.
     Being the selection in the tree."

    |holder|

    holder := builder bindingAt:#filenameHolder.

    holder isNil ifTrue:[
        holder := startFilename asValue.
        holder addDependent:self.
        builder aspectAt:#filenameHolder put:holder.
    ].

    ^ holder.

    "Modified: / 09-07-2010 / 19:25:15 / cg"
!

filenameHolder:aHolder 
    "needed when used as subcanvas"
    
    |holder|

    holder := builder aspectAt:#filenameHolder.
    holder notNil ifTrue:[
        holder removeDependent:self
    ].
    builder aspectAt:#filenameHolder put:aHolder.
    aHolder addDependent:self
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
    "Return a value holder for filter"

    filterHolder isNil ifTrue:[
        filterHolder := (self pattern ? '*') asValue.
    ].
    ^ filterHolder
!

filterHolder:aHolder
    "needed when used as subcanvas"

    filterHolder := aHolder.
!

gotoBookmarksMenu
    <resource: #programMenu>

    ^ treeBrowser gotoBookmarksMenu
"/    |menu bookmarks|
"/
"/    menu := treeBrowser class emptyMenuSpec decodeAsLiteralArray.
"/    menu findGuiResourcesIn:self.
"/    menu receiver:self.
"/
"/    "/ add the bookmark items ...
"/    bookmarks := treeBrowser class directoryBookmarks.
"/    bookmarks notEmptyOrNil ifTrue:[
"/        bookmarks do:[:dirName |
"/            menu addItem:((MenuItem label:dirName asString value:[
"/                (treeBrowser currentSelectedDirectories includes:dirName) ifFalse:[
"/                    treeBrowser setCurrentFileName:dirName.
"/                ].
"/            ])).
"/        ].
"/    ].
"/    ^ menu

    "Modified: / 06-12-2006 / 12:05:06 / cg"
!

listOfDeviceDrives

    listOfDeviceDrives isNil ifTrue:[
        listOfDeviceDrives := Filename volumes.
    ].
    ^ listOfDeviceDrives
!

okLabelEnabled
    <resource: #uiAspect>

    okLabelEnabled isNil ifTrue:[
        isLoadDialog ifTrue:[
            okLabelEnabled := BlockValue
                                with:[:filename| filename notNil 
                                                       and:[
                                                             |physicalFilename|
                                                             physicalFilename := filename asFilename physicalFilename.
                                                             physicalFilename notNil and:[
                                                                 viewFiles 
                                                                    ifTrue:[physicalFilename isRegularFile]
                                                                    ifFalse:[physicalFilename isDirectory]
                                                             ].
                                                        ]
                                                  ]
                                argument:self filenameHolder.
        ] ifFalse:[
            okLabelEnabled := true.
        ].
    ].
    ^ okLabelEnabled.
!

okLabelHolder
    <resource: #uiAspect>

    okLabelHolder isNil ifTrue:[
        okLabelHolder := 'OK' asValue.
    ].
    ^ okLabelHolder.
!

rootDirectoryHolder
    "Return a value holder for filter"

    rootDirectoryHolder isNil ifTrue:[
        rootDirectoryHolder := self initialRootDirectory asValue.
    ].
    ^ rootDirectoryHolder
!

rootDirectoryHolder:aHolder
    "Return a value holder for filter"

    rootDirectoryHolder := aHolder.
!

selectedDeviceDrive

    selectedDeviceDrive isNil ifTrue:[
        selectedDeviceDrive := self listOfDeviceDrives first asValue.
        selectedDeviceDrive addDependent:self.
    ].
    ^ selectedDeviceDrive
!

showDirectoryTree
    ^ false
!

showDiskUsageHolder
    ^ treeBrowser showDiskUsageHolder
!

showHiddenFiles
    ^ treeBrowser showHiddenFiles
!

shownFiles
    ^ treeBrowser shownFiles
!

sortCaselessInTreeBrowser
    ^ treeBrowser sortCaselessInTreeBrowser
!

sortInTreeVisibilityHolder
    ^ true
!

sortPropertyInTree
    ^ treeBrowser sortBlockProperty
!

viewDirsInContentsBrowser
    ^ false
!

viewFilesInDirectoryTree
    ^ false
!

viewNoteBookApplicationHolder
    ^ false
! !

!FileDialog methodsFor:'change & update'!

buttonPanelVisibilityChanged
    |panel filePart partAbove|

    panel := builder componentAt:#FilePanel.
    panel isNil ifTrue:[
        filePart := builder componentAt:#FilePart.
    ].
    partAbove := panel ? filePart.
    partAbove notNil ifTrue:[
        buttonPanelVisibleHolder value ifTrue:[
            partAbove layout bottomOffset:-40
        ] ifFalse:[
            partAbove layout bottomOffset:0
        ].
        partAbove containerChangedSize    "/ force resize
   ]
!

fileSelectionChanged
    |files newFile entryFieldFilename filenameHolder|

    filenameHolder := self filenameHolder.

    files := treeBrowser currentFileNameHolder value.

    (files isEmpty) ifTrue:[
        newFile := nil.
    ] ifFalse:[
        files size == 1 ifTrue:[
            newFile := files first.    
        ] ifFalse:[
            newFile := ''.
        ].
    ].
    (filenameHolder value notNil 
    and:[newFile notNil 
    and:[newFile asFilename isDirectory]]) ifTrue:[
        entryFieldFilename := filenameHolder value asFilename.
        self startFilename asFilename baseName = entryFieldFilename baseName ifTrue:[
            entryFieldFilename isDirectory ifFalse:[
                newFile := newFile asFilename construct:entryFieldFilename baseName.
            ].
        ].
    ].
    filenameHolder value:newFile withoutNotifying:self.
    OperatingSystem supportsVolumes ifTrue:[
        | volume |
        volume := (files size >= 1) 
                ifTrue:[files first volume] 
                ifFalse:nil.    
        self selectedDeviceDrive value:volume.
    ].

    "Created: / 14-02-2011 / 17:54:08 / cg"
!

selectedDeviceDriveChanged
    |newDrive curSel newFile|

    newDrive := self selectedDeviceDrive value.
    curSel := treeBrowser currentFileNameHolder value.
    curSel notEmpty ifTrue:[
        curSel first volume = newDrive ifTrue:[ ^self].
    ].

    newDrive notNil ifTrue:[
        newFile := newDrive asFilename.
        newFile isReadable ifTrue:[
            treeBrowser gotoFile:newFile.
            ^self.
        ].
        self warn:'Cannot open drive %1' with:newFile asFilename volume.
    ].

    newDrive := curSel notEmpty 
                    ifTrue:[ curSel first volume ] 
                    ifFalse:[ 
                        OperatingSystem isMSWINDOWSlike ifTrue:['C:'] ifFalse:['/']
                        "/ Filename defaultVolumeName.
                    ].
    self selectedDeviceDrive value:newDrive.
!

update:something with:aParameter from:changedObject
    |newLabel fn|

    changedObject == treeBrowser currentFileNameHolder ifTrue:[
        self fileSelectionChanged.
        ^ self.
    ].

    changedObject == self selectedDeviceDrive ifTrue:[
        self selectedDeviceDriveChanged.
        ^ self.
    ].
    changedObject == treeBrowser viewFilesInDirectoryTree ifTrue:[
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
        treeBrowser currentFileNameHolder 
                        value:(OrderedCollection with:fn) withoutNotifying:self.
        fn isDirectory ifTrue:[
            treeBrowser expandEnforceSelectedItems.
        ].
    ].
    ^ super update:something with:aParameter from:changedObject

    "Modified: / 14-02-2011 / 17:54:35 / cg"
! !

!FileDialog methodsFor:'construction-adding'!

addComponent: aView
    verticalPanelView addComponent: aView

    "Created: / 03-06-2013 / 17:47:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addComponent: aView labeled: aString
    | label labelAndComponent |

    label := Label new label: aString.
    label preferredExtent: ((self builder componentAt: #FilenameLabel) width @ label preferredExtent y).
    label adjust:#left.  

    labelAndComponent := HorizontalPanelView new.
    labelAndComponent horizontalLayout: #leftFit.
    labelAndComponent add: label; add: aView.
    ^ self addComponent: labelAndComponent

    "Created: / 05-03-2018 / 12:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileDialog methodsFor:'event handling'!

appendWasPressed
    "valid after the dialog has been closed: true if append was pressed"

    ^ appendWasPressed
! !

!FileDialog methodsFor:'initialization & release'!

closeDownViews
    self rememberExtent.
    super closeDownViews.

    "Modified: / 14-02-2011 / 17:55:14 / cg"
!

closeWindow
    self rememberExtent.
    super closeWindow.

    "Modified: / 14-02-2011 / 17:55:55 / cg"
!

commonPostOpen
    |selection|

"/     self windowGroup addPreEventHook:self.

    treeBrowser currentFileNameHolder addDependent:self.
    treeBrowser doubleClickAction:self doubleClickAction.
    treeBrowser viewFilesInDirectoryTree addDependent:self.

    treeBrowser rootHolder value:(self initialRootDirectory).
    treeBrowser viewFilesInDirectoryTree setValue:(self viewFiles ? true).
    treeBrowser viewFilesInDirectoryTree changed.

    self isLoadDialog ifTrue:[
        treeBrowser newVisibilityHolder value:false.
        treeBrowser allowFileOperations value:false.
        self newDirectoryVisibilityHolder value:false.
    ].
    treeBrowser expandEnforceSelectedItems.

    selection := treeBrowser treeSelectionHolder value.
    selection notEmptyOrNil ifTrue:[
        selection := selection asCollection first.
        selection enforcedExpand.
        treeBrowser browser makeItemVisible:selection withMinimumLines:5.
    ].
!

initialRootDirectory
    "returns the directory the browser is open on
    "
    |root|

    initialRoot isNil ifTrue:[

        (root := self directory) notNil ifTrue:[
            root := root asFilename.

            root isDirectory ifFalse:[
                root := root directory.
                root isDirectory ifFalse:[
                    root := nil.
                ]
            ]
        ].
        root isNil ifTrue:[
            root := Filename currentDirectory.
        ].
        initialRoot := root asAbsoluteFilename.
    ].
    ^ initialRoot

    "Modified: / 27-12-2010 / 09:56:30 / cg"
!

initialize
    super initialize.
    isLoadDialog := false.
!

postBuildFileNameField:aWidget

    filenameField := aWidget.
!

postBuildFilterField:aWidget

    filterField := aWidget.
!

postBuildTreeBrowser:aSubCanvasView
    treeBrowser := aSubCanvasView client.
    treeBrowser rootHolder value:(self initialRootDirectory value).
    treeBrowser sortPropertyInTree:(treeBrowser sortBlockProperty).
    treeBrowser showHiddenFiles value:true.

    "Modified: / 24-08-2010 / 16:07:16 / sr"
!

postBuildVerticalPanelView:aView
    verticalPanelView := aView.

    "Created: / 03-06-2013 / 17:41:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildWith:aBuilder 
    |win hMin|

    treeBrowser multipleSelect:multipleSelect.
    appendWasPressed := false.

    (aBuilder componentAt:'cancelButton') cursor:(Cursor thumbsDown).
    (aBuilder componentAt:'appendButton') cursor:(Cursor thumbsUp).
    (aBuilder componentAt:'okButton') cursor:(Cursor thumbsUp).

    win := aBuilder window .
    win minExtent notNil ifTrue:[
        "minExtent is nil if window is not a TopView"
        hMin := (win margin * 2)
                + (aBuilder menuBar isNil ifTrue:[0] ifFalse:[aBuilder menuBar preferredHeight])
                + (aBuilder componentAt:#FilenameEntryField) height
                + (aBuilder componentAt:#ToolBar1) preferredHeight
                + (aBuilder componentAt:#ButtonPanel) preferredHeight.

        win minExtent:(win minExtent x @ hMin).
    ].
    win topView label:self initialText.

    super postBuildWith:aBuilder
!

postOpenAsSubcanvasWith:aBuilder
    super postOpenAsSubcanvasWith:aBuilder.

    "No ok and cancel buttons, when dialog is part of a larger dialog"
    self hideButtonPanel.

    "filenameHolder contains the initial file name, or nil"
    self startFilename:self filenameHolder value.
    treeBrowser currentFileNameHolder value:(Array with:self startFilename).
!

preOpenWith:aBuilder
    "called right before being opened"

    |delta|

    "Increase height of the window so height of the file part
     remain the same. This cares for any components added by a hook"

    verticalPanelView notNil ifTrue:[
        delta := verticalPanelView preferredHeight - verticalPanelView height.
        delta > 0 ifTrue:[
            "/ components where added (possibly in the aboutToOpenBoxNotifiction
            aBuilder window height: (aBuilder window height + delta).
        ].

"/        sumH := 0.
"/        verticalPanelView subViews from:2 do:[:view|
"/            sumH := sumH + view preferredHeight.
"/        ].
"/        sumH ~~ 0 ifTrue:[
"/            newVPanelHeight := verticalPanelView preferredHeight374
"/            aBuilder window height: aBuilder window height + sumH.
"/        ].
    ].

    treeBrowser currentFileNameHolder value:(Array with:self startFilename).

    "Created: / 03-06-2013 / 18:19:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberExtent
    self class lastExtent:self window topView extent.

    "Created: / 14-02-2011 / 17:55:11 / cg"
! !

!FileDialog methodsFor:'menus'!

bookmarksMenu
    ^ treeBrowser bookmarksMenu
!

directoryMenu
    ^ treeBrowser directoryMenu
!

showMenuSpecForDialog
    ^ treeBrowser class showMenuSpecForDialog
!

sortMenu
    ^ treeBrowser class sortInTreeMenu
!

visitedDirectoriesMenu
    ^ treeBrowser visitedDirectoriesMenu
! !

!FileDialog methodsFor:'private'!

returnWasPressedInFilterField
    |wg ev|

    ((wg := self windowGroup) notNil
    and:[ (ev := wg lastEvent) notNil 
    and:[ ev isKeyEvent 
    and:[ ev key == #Return
    and:[ (ev targetView isSameOrComponentOf:filterField) 
          or:[false "ev targetView isSameOrComponentOf:filenameField"]]]]]) ifTrue:[
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

!FileDialog methodsFor:'queries'!

driveSelectorVisible
    ^ OperatingSystem isMSDOSlike
! !

!FileDialog methodsFor:'user actions'!

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
    treeBrowser hasOpenEditor ifTrue:[
        "/ have to send the event to the TreeView
        treeBrowser browser closeEditor.
        ^ self
    ].
    appendWasPressed := false.
    self commonAcceptAction.
!

doBack

    treeBrowser doBack.
!

doBrowseDirectory
    UserPreferences fileBrowserClass openOn:(treeBrowser currentDirectory ? treeBrowser rootHolder value).


!

doCancel

    self result:nil.
    ^ super doCancel.
!

doForward

    treeBrowser doForward.
!

doGoDirectoryUp

    treeBrowser doGoDirectoryUp.
!

doGotoDesktopDirectory

    treeBrowser doGotoDesktopDirectory.
!

doGotoHomeDirectory

    treeBrowser doGotoHomeDirectory.
!

menuDirHistory:backOrForward

    ^ treeBrowser menuDirHistory:backOrForward.
!

menuDirHistoryBack

    ^ treeBrowser menuDirHistory:#back.
!

menuDirHistoryForward

    ^ treeBrowser menuDirHistory:#forward.
!

newDirectory

    ^ treeBrowser newDirectory
!

okPressed
    self doAccept
!

updateCurrentDirectory
    treeBrowser updateCurrentDirectory
! !

!FileDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

