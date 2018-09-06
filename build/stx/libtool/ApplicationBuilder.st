"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

ToolApplicationModel subclass:#ApplicationBuilder
	instanceVariableNames:'task shellView aspects'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools'
!

ApplicationBuilder class instanceVariableNames:'aspects'

"
 The following class instance variables are inherited by this class:

	ToolApplicationModel - history fileHistory clipboard settings showingHelp instances
	ApplicationModel - ClassResources
	Model - 
	Object - 
"
!

!ApplicationBuilder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    WARNING: unfinished - do not use.

    The Application Builder of ST/X allows you to build ST/X-applications by following steps:

        0. Clobber the target directory of the application
        1. Generate the h-file with symbols
        2. Generate the c-file with modules
        3. Compile the modules init file
        4. Compile the startup C-file
        5. Define the symbolic links to the libraries
        6. Link the libraries to the application
        7. Define the symbolic links to the resources

    [instance variables:]
        task           <Process>               task of the running build
        shellView      <ShellView>             shell view for outputting the build results

    [instance class variables:]
        aspects        <IdentityDictionary>    aspects of the settings

    [start with:]
        ApplicationBuilder open

    [see also:]
        LibraryBuilder

    [author:]
        Thomas Zwick, eXept Software AG
"
! !

!ApplicationBuilder class methodsFor:'accessing'!

aspects

    aspects isNil ifTrue: [aspects := IdentityDictionary new].
    ^aspects


!

aspects: anIdentityDictionary

    aspects := anIdentityDictionary
!

label

   ^'Application Builder (experimental)'
! !

!ApplicationBuilder class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:ApplicationBuilder    
    "

    <resource: #help>

    ^super helpSpec addPairsFrom:#(

#applicationLinkDefines
'Opens a dialog to define the link defines for the application.'

#applicationName
'Name of the application.'

#build
'Starts the process of building the target.'

#buildDate
'Build date of the application.'

#configuration
'Configuration information of the application.'

#libraryDirectory
'Directory of the ST/X libraries.'

#link
'Starts the process of linking the application.'

#selectPath
'Opens a dialog for choosing the name of the file/path.'

#sourceDirectory
'Source directory of ST/X.'

#start
'Start the build application.'

#startupCFile
'Startup C-file of ST/X for the application.'

#startupFile
'Startup C-file of ST/X for the application.'

#startupMessage
'Startup message consisting of the class name and the selector name.'

#startupModule
'Startup module of ST/X for the application.'

#stop
'Stops the process of the building.'

#stxLibraries
'List of the ST/X library names.'

#symlinkBitmaps
'Create symbolic links to the bitmaps of ST/X.'

#symlinkRCFiles
'Create symbolic links to the RC-files of ST/X.'

#symlinkResources
'Create symbolic links to the resources of ST/X.'

#symlinkSources
'Create symbolic links to the sources of ST/X.'

#systemLibaries
'Libraries of the operating system needed by the target.'

#targetDirectory
'Directory where the target will build.'

#topDirectory
'Top directory of ST/X.'

#userLibraries
'Libraries of the user wanted to add to the application.'

)
! !

!ApplicationBuilder class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ApplicationBuilder andSelector:#windowSpec
     ApplicationBuilder new openInterface:#windowSpec
     ApplicationBuilder open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Application Builder'
              #layout: #(#LayoutFrame 79 0 285 0 578 0 744 0)
              #label: 'Application Builder'
              #min: #(#Point 420 220)
              #max: #(#Point 1152 900)
              #bounds: #(#Rectangle 79 285 579 745)
              #menu: #menu
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#ViewSpec
                    #name: 'Box1'
                    #layout: #(#LayoutFrame 0 0.0 3 0 0 1.0 292 0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#ViewSpec
                              #name: 'Box2'
                              #layout: #(#LayoutFrame 0 0.0 0 0.0 -148 1.0 2 1.0)
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#LabelSpec
                                        #name: 'applicationNameLabel'
                                        #layout: #(#AlignmentOrigin 147 0 15 0 1 0.5)
                                        #label: 'Application Name:'
                                        #adjust: #right
                                    )
                                     #(#InputFieldSpec
                                        #name: 'applicationNameField'
                                        #layout: #(#LayoutFrame 150 0 4 0 0 1 26 0)
                                        #activeHelpKey: #applicationName
                                        #model: #applicationName
                                    )
                                     #(#LabelSpec
                                        #name: 'startupMessageLabel'
                                        #layout: #(#AlignmentOrigin 147 0 39 0 1 0.5)
                                        #label: 'Startup Message:'
                                        #adjust: #right
                                    )
                                     #(#InputFieldSpec
                                        #name: 'startupMessageField'
                                        #layout: #(#LayoutFrame 150 0 28 0 0 1.0 50 0)
                                        #activeHelpKey: #startupMessage
                                        #model: #startupMessage
                                    )
                                     #(#LabelSpec
                                        #name: 'buildDateLabel'
                                        #layout: #(#AlignmentOrigin 147 0 63 0 1 0.5)
                                        #label: 'Build Date:'
                                        #adjust: #right
                                    )
                                     #(#InputFieldSpec
                                        #name: 'buildDateField'
                                        #layout: #(#LayoutFrame 150 0 52 0 0 1.0 74 0)
                                        #activeHelpKey: #buildDate
                                        #model: #buildDate
                                    )
                                     #(#LabelSpec
                                        #name: 'configurationLabel'
                                        #layout: #(#AlignmentOrigin 147 0 87 0 1 0.5)
                                        #label: 'Configuration:'
                                        #adjust: #right
                                    )
                                     #(#InputFieldSpec
                                        #name: 'configurationField'
                                        #layout: #(#LayoutFrame 150 0 76 0 0 1.0 98 0)
                                        #activeHelpKey: #configuration
                                        #model: #configuration
                                    )
                                     #(#DividerSpec
                                        #name: 'Separator2'
                                        #layout: #(#LayoutFrame 0 0 102 0 0 1 105 0)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'targetDirectoryButton'
                                        #layout: #(#LayoutFrame 4 0 109 0 147 0 133 0)
                                        #activeHelpKey: #selectPath
                                        #label: 'Target Directory:'
                                        #model: #doSelectDirectory:
                                        #actionValue: 'Target'
                                    )
                                     #(#InputFieldSpec
                                        #name: 'targetDirectoryField'
                                        #layout: #(#LayoutFrame 150 0 109 0 0 1.0 131 0)
                                        #activeHelpKey: #targetDirectory
                                        #model: #targetDirectory
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'topDirectoryButton'
                                        #layout: #(#LayoutFrame 4 0 133 0 147 0 157 0)
                                        #activeHelpKey: #selectPath
                                        #label: 'Top Directory:'
                                        #model: #doSelectDirectory:
                                        #actionValue: 'Top'
                                    )
                                     #(#InputFieldSpec
                                        #name: 'topDirectoryField'
                                        #layout: #(#LayoutFrame 150 0 133 0 0 1.0 155 0)
                                        #activeHelpKey: #topDirectory
                                        #model: #topDirectory
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'libraryDirectoryButton'
                                        #layout: #(#LayoutFrame 4 0 157 0 147 0 181 0)
                                        #activeHelpKey: #selectPath
                                        #label: 'Library Directory:'
                                        #model: #doSelectDirectory:
                                        #actionValue: 'Library'
                                    )
                                     #(#InputFieldSpec
                                        #name: 'libraryDirectoryField'
                                        #layout: #(#LayoutFrame 150 0 157 0 0 1.0 179 0)
                                        #activeHelpKey: #libraryDirectory
                                        #model: #libraryDirectory
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'startupCFileButton'
                                        #layout: #(#LayoutFrame 4 0 181 0 147 0 205 0)
                                        #activeHelpKey: #selectPath
                                        #label: 'Startup C-File:'
                                        #model: #doSelectCFile:
                                        #actionValue: 'StartupCFile'
                                    )
                                     #(#InputFieldSpec
                                        #name: 'startupCFileField'
                                        #layout: #(#LayoutFrame 150 0 181 0 0 1.0 203 0)
                                        #activeHelpKey: #startupModule
                                        #model: #startupCFile
                                    )
                                     #(#DividerSpec
                                        #name: 'Separator3'
                                        #layout: #(#LayoutFrame 0 0.0 208 0 0 1.0 211 0)
                                    )
                                     #(#LabelSpec
                                        #name: 'stxLibraryButton'
                                        #layout: #(#AlignmentOrigin 147 0 227 0 1 0.5)
                                        #label: 'ST/X Libraries:'
                                    )
                                     #(#ComboBoxSpec
                                        #name: 'stxLibrariesComboBox'
                                        #layout: #(#LayoutFrame 150 0 216 0 0 1 238 0)
                                        #activeHelpKey: #stxLibraries
                                        #model: #stxLibrary
                                        #immediateAccept: false
                                        #acceptOnTab: false
                                        #comboList: #stxLibraries
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'systemLibrariesButton'
                                        #layout: #(#LayoutFrame 4 0 239 0 147 0 263 0)
                                        #activeHelpKey: #selectPath
                                        #label: 'System Libraries:'
                                        #model: #doSelectLibrary:
                                        #actionValue: 'SystemLibrary'
                                    )
                                     #(#ComboBoxSpec
                                        #name: 'systemLibrariesComboBox'
                                        #layout: #(#LayoutFrame 150 0 240 0 0 1 262 0)
                                        #activeHelpKey: #systemLibaries
                                        #model: #systemLibrary
                                        #immediateAccept: false
                                        #acceptOnTab: false
                                        #comboList: #systemLibraries
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'userLibrariesButton'
                                        #layout: #(#LayoutFrame 4 0 263 0 147 0 287 0)
                                        #activeHelpKey: #selectPath
                                        #label: 'User Libraries:'
                                        #model: #doSelectLibrary:
                                        #actionValue: 'UserLibrary'
                                    )
                                     #(#ComboBoxSpec
                                        #name: 'userLibrariesComboBox'
                                        #layout: #(#LayoutFrame 150 0 264 0 0 1 286 0)
                                        #activeHelpKey: #userLibraries
                                        #model: #userLibrary
                                        #immediateAccept: false
                                        #acceptOnTab: false
                                        #comboList: #userLibraries
                                    )
                                  )
                              )
                          )
                           #(#DividerSpec
                              #name: 'Separator4'
                              #layout: #(#LayoutFrame -144 1 0 0.0 -138 1 0 1.0)
                              #orientation: #vertical
                          )
                           #(#ViewSpec
                              #name: 'Box3'
                              #layout: #(#LayoutFrame -134 1 0 0.0 0 1.0 0 1.0)
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#FramedBoxSpec
                                        #name: 'FramedBox'
                                        #layout: #(#LayoutFrame -4 0.0 4 0.0 0 1.0 -150 1.0)
                                        #component: 
                                         #(#SpecCollection
                                            #collection: 
                                             #(
                                               #(#CheckBoxSpec
                                                  #name: 'linkRCFilesCheckBox'
                                                  #layout: #(#LayoutFrame 12 0 24 0 12 1 46 0)
                                                  #activeHelpKey: #symlinkRCFiles
                                                  #model: #linkRCFiles
                                                  #label: 'RC-Files'
                                              )
                                               #(#CheckBoxSpec
                                                  #name: 'linkResourcesCheckBox'
                                                  #layout: #(#LayoutFrame 12 0 48 0 12 1 70 0)
                                                  #activeHelpKey: #symlinkResources
                                                  #model: #linkResources
                                                  #label: 'Resources'
                                              )
                                               #(#CheckBoxSpec
                                                  #name: 'linkSourcesCheckBox'
                                                  #layout: #(#LayoutFrame 12 0 72 0 12 1 94 0)
                                                  #activeHelpKey: #symlinkSources
                                                  #model: #linkSources
                                                  #label: 'Sources'
                                              )
                                               #(#CheckBoxSpec
                                                  #name: 'linkBitmapsCheckBox'
                                                  #layout: #(#LayoutFrame 12 0 96 0 12 1 118 0)
                                                  #activeHelpKey: #symlinkBitmaps
                                                  #model: #linkBitmaps
                                                  #label: 'Bitmaps'
                                              )
                                            )
                                        )
                                        #label: 'Symbolic Links'
                                        #labelPosition: #topLeft
                                    )
                                     #(#VerticalPanelViewSpec
                                        #name: 'VerticalPanel'
                                        #layout: #(#LayoutFrame 0 0.0 -144 1 -6 1.0 -2 1.0)
                                        #component: 
                                         #(#SpecCollection
                                            #collection: 
                                             #(
                                               #(#ActionButtonSpec
                                                  #name: 'buildButton'
                                                  #activeHelpKey: #build
                                                  #label: 'Build'
                                                  #model: #doBuild
                                                  #extent: #(#Point 128 33)
                                              )
                                               #(#ActionButtonSpec
                                                  #name: 'linkButton'
                                                  #activeHelpKey: #link
                                                  #label: 'Link'
                                                  #model: #doLink
                                                  #extent: #(#Point 128 34)
                                              )
                                               #(#ActionButtonSpec
                                                  #name: 'stopButton'
                                                  #activeHelpKey: #stop
                                                  #label: 'Stop'
                                                  #model: #doStop
                                                  #extent: #(#Point 128 33)
                                              )
                                               #(#ActionButtonSpec
                                                  #name: 'Button1'
                                                  #activeHelpKey: #start
                                                  #label: 'Start'
                                                  #model: #doStart
                                                  #extent: #(#Point 128 33)
                                              )
                                            )
                                        )
                                        #horizontalLayout: #fit
                                        #verticalLayout: #fit
                                        #horizontalSpace: 3
                                        #verticalSpace: 3
                                    )
                                  )
                              )
                          )
                        )
                    )
                    #borderWidth: 1
                )
                 #(#SubCanvasSpec
                    #name: 'shellViewSubCanvas'
                    #layout: #(#LayoutFrame 0 0.0 294 0 0 1.0 -26 1)
                    #hasHorizontalScrollBar: false
                    #hasVerticalScrollBar: false
                    #clientHolder: #shellView
                )
                 #(#UISubSpecification
                    #name: 'windowSpecForInfoBar'
                    #layout: #(#LayoutFrame 0 0.0 -24 1 0 1.0 0 1.0)
                    #majorKey: #ToolApplicationModel
                    #minorKey: #windowSpecForInfoBar
                )
              )
          )
      )
! !

!ApplicationBuilder class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ApplicationBuilder andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(ApplicationBuilder menu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'About'
                #labelImage: #(#ResourceRetriever nil #menuIcon)
                #submenuChannel: #menuAbout
            )
             #(#MenuItem
                #label: 'File'
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Exit'
                          #value: #closeRequest
                          #activeHelpKey: #fileExit
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: 'Application'
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Build'
                          #value: #doBuild
                          #activeHelpKey: #build
                      )
                       #(#MenuItem
                          #label: 'Link'
                          #value: #doLink
                          #activeHelpKey: #link
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Stop'
                          #value: #doStop
                          #activeHelpKey: #stop
                      )
                       #(#MenuItem
                          #label: 'Start'
                          #value: #doStart
                          #activeHelpKey: #start
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: 'Settings'
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Target Directory...'
                          #value: #doSelectDirectory:
                          #activeHelpKey: #targetDirectory
                          #argument: 'Target'
                      )
                       #(#MenuItem
                          #label: 'Top Directory...'
                          #value: #doSelectDirectory:
                          #activeHelpKey: #topDirectory
                          #argument: 'Top'
                      )
                       #(#MenuItem
                          #label: 'Library Directory...'
                          #value: #doSelectDirectory:
                          #activeHelpKey: #libraryDirectory
                          #argument: 'Library'
                      )
                       #(#MenuItem
                          #label: 'Startup C-File...'
                          #value: #doSelectCFile:
                          #activeHelpKey: #startupCFile
                          #argument: 'StartupCFile'
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'System Libraries...'
                          #value: #doSelectLibrary:
                          #activeHelpKey: #systemLibaries
                          #argument: 'SystemLibrary'
                      )
                       #(#MenuItem
                          #label: 'User Libraries...'
                          #value: #doSelectLibrary:
                          #activeHelpKey: #userLibraries
                          #argument: 'UserLibrary'
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Application Link Defines...'
                          #value: #doDefineApplicationLinkDefines
                          #activeHelpKey: #applicationLinkDefines
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Fonts'
                          #submenuChannel: #menuFont
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: 'Help'
                #startGroup: #right
                #submenuChannel: #menuHelp
            )
          ) nil
          nil
      )
! !

!ApplicationBuilder methodsFor:'actions'!

doBuild
    "builds the application by doing following tasks:
        0. Clobber the target directory of the application
        1. Generate the h-file with symbols
        2. Generate the c-file with modules
        3. Compile the modules init file
        4. Compile the startup C-file
        5. Define the symbolic links to the libraries
        6. Link the libraries to the application
        7. Define the symbolic links to the resources
    "
    |dir compilerPath compilerFlags block0 block1 block2 block3 block4 block5 block6 block7 priority|

    task notNil ifTrue: [self warn: 'There is already a build running!!'].

    self inform: 'Starting building of application...' asBoldText.

    (dir := self getTargetDirectory) isNil 
        ifTrue: [^self warn: 'Could not create application directory!!'].

    shellView directory: dir.

    (compilerPath := ByteCodeCompiler ccPath, ' ') isNil 
        ifTrue: [^self warn:'Define first a system compiler!!'].
    compilerFlags := self getCompilerFlags.

    block0 := self getBlockForClobberingTargetDirectory: dir.
    block1 := self getBlockForGeneratingHFileWithSymbolsIn: dir.
    block2 := self getBlockForGeneratingCFileWithModulesIn: dir.
    block3 := self getBlockForCompilingModulListFileWith: compilerPath, compilerFlags inDirectory: dir.
    block4 := self getBlockForCompilingStartupCFileWith: compilerPath, compilerFlags inDirectory: dir.
    block5 := self getBlockForCreatingSymbolicLinksToTheLibrariesIn: dir.
    block6 := self getBlockForLinkingLibrariesToTheApplicationIn: dir.
    block7 := self getBlockForCreatingSymbolicLinksToTheResourcesIn: dir.

    priority := Processor userBackgroundPriority.
    task := block0 forkAt: priority.
    task addExitAction: 
    [
        task isNil ifTrue: 
        [
            task := block1 forkAt: priority.
            task addExitAction: 
            [
                task isNil ifTrue: 
                [
                    task := block2 forkAt: priority.
                    task addExitAction: 
                    [
                        task isNil ifTrue:
                        [
                            task := block3 forkAt: priority.
                            task addExitAction: 
                            [
                                task isNil ifTrue: 
                                [
                                    task := block4 forkAt: priority.
                                    task addExitAction: 
                                    [
                                        task isNil ifTrue: 
                                        [
                                            task := block5 forkAt: priority.
                                            task addExitAction: 
                                            [
                                                task isNil ifTrue: 
                                                [
                                                    task := block6 forkAt: priority.
                                                    task addExitAction: 
                                                    [
                                                        task isNil ifTrue: 
                                                        [
                                                            task := block7 forkAt: priority.
                                                            task addExitAction: 
                                                            [
                                                                task isNil 
                                                                    ifTrue: [self inform: 'Application build.' asBoldText]
                                                                    ifFalse: [self informTargetBuildingFailed].
                                                                Display beep.
                                                            ]   
                                                        ] ifFalse: [self informTargetBuildingFailed]
                                                    ]
                                                ] ifFalse: [self informTargetBuildingFailed]
                                            ]
                                        ] ifFalse: [self informTargetBuildingFailed]
                                    ]
                                ] ifFalse: [self informTargetBuildingFailed]
                            ]
                        ] ifFalse: [self informTargetBuildingFailed]
                    ]           
                ] ifFalse: [self informTargetBuildingFailed]
            ]
        ] ifFalse: [self informTargetBuildingFailed]
    ]
!

doDefineApplicationLinkDefines
    "opens a dialog for defining the application defines"

    |box|
    box := EnterBox new.
    box label: 'Application Link Defines'.
    box initialText: (aspects at: #applicationLinkDefines) value.
    box showAtPointer.
    box accepted
    ifTrue:
    [
        (aspects at: #applicationLinkDefines) value: box contents
    ].
    box destroy
!

doLink
    "links the application"

    |dir block priority|

    task notNil ifTrue: [self warn: 'There is already a build running!!'].

    self inform: 'Starting building of application...' asBoldText.

    (dir := self getTargetDirectory) isNil 
        ifTrue: [^self warn: 'Could not create application directory!!'].

    shellView directory: dir.

    block := self getBlockForLinkingLibrariesToTheApplicationIn: dir.

    priority := Processor userBackgroundPriority.
    task := block forkAt: priority.
    task addExitAction: 
    [
        task isNil 
            ifTrue: [self inform: 'Application build.' asBoldText]
            ifFalse:[self informTargetBuildingFailed].
        Display beep.
    ]
!

doSelectCFile: whichFile
    "opens a FileSelectionBrowser in order to select C-file"

    |currentFile selectedFile|

    currentFile := aspects at: whichFile asLowercaseFirst asSymbol.

    ((selectedFile := FileSelectionBrowser
        request: 'Select Your ', whichFile, ' File' 
        fileName: currentFile value
        withFileFilters: #('*.c')) notNil and:
    [selectedFile asFilename exists and: [selectedFile asFilename isDirectory not]]) 
        ifTrue: [currentFile value: selectedFile]


!

doSelectDirectory: whichDir
    "opens a FileSelectionBrowser in order to select directory"

    |currentDir selectedDir|

    currentDir := aspects at: (whichDir asLowercaseFirst, 'Directory') asSymbol.

    ((selectedDir := FileSelectionBrowser
        request: 'Select Your ', whichDir, ' Directory' 
        fileName: nil 
        inDirectory: currentDir value
        withFileFilters: #('*.*o')) notNil and:
    [selectedDir asFilename exists and: [selectedDir asFilename isDirectory]]) 
        ifTrue: [currentDir value: selectedDir. shellView executeCommand: 'cd ', selectedDir]


!

doSelectLibrary: whichFile
    "opens a FileSelectionBrowser in order to select library"

    |currentFile selectedFile|

    currentFile := aspects at: whichFile asLowercaseFirst asSymbol.

    ((selectedFile := FileSelectionBrowser
        request: 'Select Your ', whichFile, ' File' 
        fileName: currentFile value
        withFileFilters: #('*.*o' '*.a')) notNil and:
    [selectedFile asFilename exists and: [selectedFile asFilename isDirectory not]]) 
        ifTrue: [currentFile value: selectedFile]


!

doStart
    "starts the build application"

    |dir|
    self doStop.
    (dir := self getTargetDirectory) isNil 
        ifTrue: [^self warn: 'Application directory does not exists!!'].

    shellView directory: dir.
    shellView executeCommand: (aspects at: #applicationName) value.

!

doStop
    "terminates the task of the current build"

    task notNil ifTrue: [task removeAllExitActions. task terminate].
    task := nil.
    shellView executeCommand: 'clear'.
    self inform: ''

!

executeCommand: aCommand inDirectory: dir
    "executes aCommand in directory dir; put aCommand and the result into the shell view"

    |outStream|

    shellView directory: dir.
    shellView append: shellView getDirectoryTextString, ' ', aCommand.

    outStream:= PipeStream readingFrom: aCommand errorDisposition:#inline inDirectory: dir.
    [      
        outStream canReadWithoutBlocking
        ifTrue:
        [
            outStream readWait.
            shellView append: (Text string: (outStream upTo: Character cr) color: Color red).
        ].
    ] doWhile:[outStream atEnd not].

    outStream close

!

inform: aString
    "outputs aString via shell view as information"

    shellView commandInputField contents: aString




!

informTargetBuildingFailed
    "informs that something went wrong"

    self inform: 'Application building failed.' asBoldText.
    task := nil
! !

!ApplicationBuilder methodsFor:'aspects'!

aspectFor:aKey
    "returns an aspect at aKey"

    ^aspects at: aKey ifAbsent: [super aspectFor:aKey]
!

aspectsAt: aKey putFirst: anObject
    "puts firstly anObject as ValueHolder at aKey and returns it"

    ^aspects at: aKey ifAbsent: [aspects at: aKey put: anObject asValue]




























!

shellView
    "returns a shell view"

    shellView isNil ifTrue: [shellView := ShellView new. shellView directory: (aspects at: #topDirectory) value]. 
    ^shellView 



! !

!ApplicationBuilder methodsFor:'building blocks'!

getBlockForClobberingTargetDirectory: dir
    "returns the block for clobbering the target directory of the application"

    ^
    [
        self inform: 'Clobbering the target directory...'.
        self executeCommand: 'rm -r *' inDirectory: dir.
        task := nil
    ]

!

getBlockForCompilingModulListFileWith: compilerPathAndFlags inDirectory: dir
    "returns the block for compiling the C-file with the list of the module names"

    ^
    [
        |command|
        self inform: 'Starting compilation of the modules init file...'.
        command := compilerPathAndFlags , ' -c -fPIC -O6 -fomit-frame-pointer -m486 -DDEBUG -Di386 modulList.c'.
        self executeCommand: command inDirectory: dir.
        (dir asFilename construct: 'modulList.o') exists
            ifTrue:  [task := nil]
            ifFalse: [self warn:'Could not compile the modules file!!']
    ]
!

getBlockForCompilingStartupCFileWith: compilerPathAndFlags inDirectory: dir
    "returns the block for compiling the startup file with passing startup class, startup selector, configuration string, and build date"

    ^
    [
        |startUpClass cls startUpSelector startupFile command|
        ((aspects at: #startupCFile) value asFilename) exists  
        ifFalse: 
        [
            self warn: 'Defined startup C-file not found!!'
        ]
        ifTrue:
        [
            self inform: 'Starting compilation of the startup C-file...'.

            startUpClass    := ((aspects at: #startupMessage) value upTo: $ ) asSymbol.
            (cls := Smalltalk at: startUpClass) isNil 
            ifTrue: 
            [
                self warn: 'Defined class not found in system!!'
            ]
            ifFalse:
            [
                startUpSelector := ((aspects at: #startupMessage) value copy reverse upTo: $ ) reverse asSymbol.
                (cls respondsTo: startUpSelector) 
                ifFalse: 
                [
                    self warn: 'Defined class does not respond to the defined selector!!'
                ]
                ifTrue:
                [
                    startupFile     := (aspects at: #startupCFile) value asFilename.
                    startupFile copyTo: (startupFile := dir asFilename construct: (aspects at: #startupCFile) value asFilename baseName).
                    command := compilerPathAndFlags , ' -o main.o -c -O -O6 -fomit-frame-pointer -m486 -DDEBUG -Di386 ',
                        '-DSTARTUP_CLASS="\"',        startUpClass, '\"" ',
                        '-DSTARTUP_SELECTOR="\"',     startUpSelector, '\"" ',
                        '-DCONFIGURATION_STRING="\"', (aspects at: #configuration)   value, '\"" ',
                        '-DBUILD_DATE="\"',           (aspects at: #buildDate)       value, '\"" ',
                        startupFile name.

                    self executeCommand: command inDirectory: dir
                ]
            ]
        ].
        (dir asFilename construct: 'main.o') exists
            ifTrue:  [task := nil]
            ifFalse: [self warn:'Could not compile the startup C-file!!']
    ]
!

getBlockForCreatingSymbolicLinksToTheLibrariesIn: dir
    "returns the block for creating the symbolic links to the libraries"

    ^
    [
        self inform: 'Starting defining of the symbolic links to the libraries...'.
        self getLibraryFileNames value do:
        [:libPath|       
            self executeCommand: 'ln -s ', libPath , ' ', libPath asFilename head inDirectory: dir
        ].
        task := nil. 
    ]

!

getBlockForCreatingSymbolicLinksToTheResourcesIn: dir
    "returns the block for creating the symbolic links to the resources"

    ^
    [
        self inform: 'Starting linking of the resources...'.
        (aspects at: #linkRCFiles) value
        ifTrue:
        [                
            self executeCommand: 
                'ln -s ', 
                ((aspects at: #libraryDirectory) value asFilename construct: '*.rc') name, ' ', 
                (aspects at: #targetDirectory) value inDirectory: dir.
            self executeCommand: 
                'ln -s ', 
                ((aspects at: #libraryDirectory) value asFilename construct: 'patches') name, ' ', 
                (aspects at: #targetDirectory) value inDirectory: dir.
        ].
        (aspects at: #linkResources) value
        ifTrue:
        [ 
            self executeCommand: 
                'cp -r -d ', 
                ((aspects at: #libraryDirectory) value asFilename construct: 'resources') name, ' ', 
                (aspects at: #targetDirectory) value inDirectory: dir.
        ].
        (aspects at: #linkSources) value
        ifTrue:
        [ 
            self executeCommand: 
                'cp -r -d ', 
                ((aspects at: #libraryDirectory) value asFilename construct: 'source') name, ' ', 
                (aspects at: #targetDirectory) value inDirectory: dir.
        ].
        (aspects at: #linkBitmaps) value
        ifTrue:
        [ 
            self executeCommand: 
                'cp -r -d ', 
                ((aspects at: #libraryDirectory) value asFilename construct: 'bitmaps') name, ' ', 
                (aspects at: #targetDirectory) value inDirectory: dir.
        ].
        task := nil.
    ]

!

getBlockForGeneratingCFileWithModulesIn: dir
    "returns the block for generating a C-file with the modules in directory dir"

    ^
    [
        |selectionOfLibraries|

        self inform: 'Starting generation of the C-file with modules...'.

        selectionOfLibraries := self getModuleNames.
        self executeCommand: 'echo "#include <stcIntern.h>" > modulList.c' inDirectory: dir.
        self executeCommand: 'echo "typedef void (*vf)();" >> modulList.c' inDirectory: dir.
        selectionOfLibraries do:
        [:lib|
            self executeCommand: 'echo "extern void _', lib, '_Init();" >> modulList.c' inDirectory: dir.
        ].
        self executeCommand: 'echo "static vf modules[] = {" >> modulList.c' inDirectory: dir.
        selectionOfLibraries do:
        [:lib|
            self executeCommand: 'echo "_', lib, '_Init," >> modulList.c' inDirectory: dir.
        ].
        self executeCommand: 'echo "(vf)0};" >> modulList.c' inDirectory: dir.
        self executeCommand: 'echo "vf *__modules__ = modules;" >> modulList.c' inDirectory: dir.

        (dir asFilename construct: 'modulList.c') exists
            ifTrue:  [task := nil]
            ifFalse: [self warn:'Could not generate the C-file with libraries!!']
    ]

!

getBlockForGeneratingHFileWithSymbolsIn: dir
    "returns the block for generating a H-file with the symbols in directory dir"

    ^
    [
        |symbolsFile realInc|

        self inform: 'Starting generation of the h-file with symbols...'.

        ByteCodeCompiler stcCompilationIncludes asArrayOfSubstrings do:
        [:inc|
            realInc := inc readStream.
            realInc upTo: $/. 
            realInc := '/', realInc upToEnd.      
            (symbolsFile := realInc asFilename construct: 'symbols.stc') exists
            ifTrue:
            [   
                self executeCommand: 'echo "char *__symbols[] = {" > symbols.h' inDirectory: dir.
                self executeCommand: 'sed ''s/^/"/'' < ', symbolsFile name,' | sed ''s/$/",/'' | sed ''s/\\/\\\\/g'' >> symbols.h' inDirectory: dir.
                self executeCommand: 'echo "0 };" >> symbols.h' inDirectory: dir.
            ]
        ].

        (dir asFilename construct: 'symbols.h') exists
            ifTrue:  [task := nil]
            ifFalse: [self warn:'Could not generate the h-file with symbols!!']
    ]

!

getBlockForLinkingLibrariesToTheApplicationIn: dir
    "returns the block for linking the libraries to the application"

    ^
    [
        |appName command|

        self inform: 'Starting linking of the libraries to the application...'.

        appName := (aspects at: #applicationName) value.

        command := ByteCodeCompiler ccPath,
            ' ', (aspects at: #applicationLinkDefines) value, ' ',
            ' -o ' , appName,
            ' modulList.o main.o ', 
            ((aspects at: #libraryDirectory) value asFilename construct: 'librun', ObjectFileLoader sharedLibraryExtension) name, ' ',
            ((self getLibraryFileNames, (aspects at: #systemLibraries) value) asStringCollection asStringWith: $ ).

        self executeCommand: command inDirectory: dir.

        (dir asFilename construct: (aspects at: #applicationName) value) exists
            ifTrue:  [task := nil]
            ifFalse: [self warn:'Could not build the application!!']
    ]

! !

!ApplicationBuilder methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "updates the combo boxes with the library names and the module names"

    |library libraries|

    changedObject == (aspects at: #stxLibrary ifAbsent: nil) 
    ifTrue: 
    [                
        libraries := (aspects at: #stxLibraries) value.
        (aspects at: #stxLibrary) value size = 0 ifTrue: [libraries remove: (aspects at: #oldSTXLibrary) value ifAbsent: nil].
        (aspects at: #oldSTXLibrary) value: (library := (aspects at: #stxLibrary) value).
    ].
    changedObject == (aspects at: #systemLibrary) 
    ifTrue: 
    [                
        libraries := (aspects at: #systemLibraries) value.
        (aspects at: #systemLibrary) value size = 0 ifTrue: [libraries remove: (aspects at: #oldSystemLibrary) value ifAbsent: nil].
        (aspects at: #oldSystemLibrary) value: (library := (aspects at: #systemLibrary) value).
    ].
    changedObject == (aspects at: #userLibrary ifAbsent: nil) 
    ifTrue: 
    [                
        libraries := (aspects at: #userLibraries) value.
        (aspects at: #userLibrary) value size = 0 ifTrue: [libraries remove: (aspects at: #oldUserLibrary) value ifAbsent: nil].
        (aspects at: #oldUserLibrary) value: (library := (aspects at: #userLibrary) value).
    ].
    (libraries includes: library) not & library notEmpty
    ifTrue:
    [   
        libraries add: library
    ]





! !

!ApplicationBuilder methodsFor:'initialization'!

initialize
    "initialize all aspects"

    |topDir|

    super initialize.

    aspects := self class aspects.

    topDir := (Filename currentDirectory asFilename construct:'..') construct:'..'.

    self aspectsAt: #topDirectory      putFirst: topDir pathName.
    aspects     at: #systemLibraries   put: ObjectFileLoader searchedLibraries asValue.
    (aspects at: #systemLibrary        put: ((aspects at: #systemLibraries) value at: 1 ifAbsent: '') asValue) addDependent: self.
    self aspectsAt: #oldSystemLibrary putFirst: (aspects at: #systemLibrary) value.
    self aspectsAt: #configuration     putFirst: Smalltalk configuration.

    self class ~~ ApplicationBuilder ifTrue: [^self].

    self aspectsAt: #applicationName   putFirst: 'application'.
    self aspectsAt: #startupMessage    putFirst: 'Smalltalk start'.
    self aspectsAt: #startupCFile      putFirst: (topDir construct: 'librun/main.c') pathName.

    self aspectsAt: #targetDirectory   putFirst: ((topDir construct: 'projects') construct:'application') pathName.
    self aspectsAt: #libraryDirectory  putFirst: ((topDir construct: 'projects') construct:'smalltalk') pathName.

    self aspectsAt: #stxLibraries      putFirst: 
        (ObjectMemory binaryModuleInfo collect: [:binMoInfo| (binMoInfo name copy reverse upTo: $ ) reverse]) asSortedCollection.

    self aspectsAt: #userLibraries     putFirst: OrderedCollection new.

    aspects at:     #buildDate         put:      (Date today printString, ' ', Time now printString) asValue.

    self aspectsAt: #linkRCFiles       putFirst: true.
    self aspectsAt: #linkResources     putFirst: true.
    self aspectsAt: #linkSources       putFirst: true.
    self aspectsAt: #linkBitmaps       putFirst: true.

    (aspects at: #stxLibrary           put: ((aspects at: #stxLibraries)    value at: 1 ifAbsent: '') asValue) addDependent: self.
    (aspects at: #userLibrary          put: ((aspects at: #userLibraries)   value at: 1 ifAbsent: '') asValue) addDependent: self.

    self aspectsAt: #oldSTXLibrary    putFirst: (aspects at: #stxLibrary) value.
    self aspectsAt: #oldUserLibrary   putFirst: (aspects at: #userLibrary) value.

    self aspectsAt: #applicationLinkDefines putFirst: '-L/usr/X11/lib -Llib -Lbinary -L. -L/usr/local/lib -L/usr/lib -L/lib -lm -ldl -lXext -lX11'.
! !

!ApplicationBuilder methodsFor:'queries'!

getCompilerFlags
    "returns the defines of the OS and the compiler flags of the ByteCodeCompiler"

    |compilerFlags|

    compilerFlags := OperatingSystem getOSDefine ? ''.

    ByteCodeCompiler stcCompilationDefines notNil 
        ifTrue:[compilerFlags := compilerFlags , ' ' , ByteCodeCompiler stcCompilationDefines].
    ByteCodeCompiler stcCompilationIncludes notNil 
        ifTrue:[compilerFlags := compilerFlags , ' ' , ByteCodeCompiler stcCompilationIncludes].
    ByteCodeCompiler ccCompilationOptions notNil 
        ifTrue:[compilerFlags := compilerFlags , ' ' , ByteCodeCompiler ccCompilationOptions].

    ^compilerFlags

!

getLibraryFileNames
    "returns the complete file names of the system and the user libraries"

    |libraryFileNames|

    libraryFileNames := OrderedCollection new.

    (aspects at: #stxLibraries) value do:
    [:lib|
        |abbrevLib libPath|
        abbrevLib  := lib.
        lib = 'GLXWorkstation'   ifTrue: [abbrevLib := 'GLXWorkstat'].
        lib = 'XWorkstation'     ifTrue: [abbrevLib := 'XWorkstat'  ].
        lib = 'ObjectFileLoader' ifTrue: [abbrevLib := 'ObjFLoader' ].
        (libPath := (aspects at: #libraryDirectory) value asFilename construct: abbrevLib, ObjectFileLoader sharedLibraryExtension) exists
            ifTrue: [libraryFileNames add: libPath name]
    ].

    ^libraryFileNames, (aspects at: #userLibraries) value

!

getModuleNames
    "returns the module names of the system and the user libraries"

    |moduleNames|

    moduleNames := OrderedCollection new.
    (aspects at: #userLibraries) value do:
    [:lib|
        lib asFilename exists ifTrue: [moduleNames add: (lib asFilename baseName upTo: $.)]
    ].

    ^(aspects at: #stxLibraries) value, moduleNames
!

getTargetDirectory
    "returns the directory of the application; if not present, create it"

    |targetDirectory|

    (targetDirectory := (aspects at: #targetDirectory) value asFilename) exists ifFalse:[targetDirectory makeDirectory].   
    (targetDirectory isReadable and:[targetDirectory isWritable]) ifFalse: [^nil].

    ^targetDirectory name


! !

!ApplicationBuilder methodsFor:'startup & release'!

closeRequest
    "close request; before closing stop the running build, then release the dependents of all aspects"

    self doStop.
    aspects do: [:aspect| aspect release].

    super closeRequest

!

postBuildWith:aBuilder
    "sets target directory for the shell view"

    shellView directory: self getTargetDirectory.

    ^super postBuildWith:aBuilder
! !

!ApplicationBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/ApplicationBuilder.st,v 1.10 2013-07-30 05:57:02 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: ApplicationBuilder.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

