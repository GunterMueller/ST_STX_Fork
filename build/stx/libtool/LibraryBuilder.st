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

ApplicationBuilder subclass:#LibraryBuilder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools'
!

!LibraryBuilder class methodsFor:'documentation'!

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

    The Library Builder of ST/X allows you to build ST/X-libraries by following steps:

        0. Clobber the target directory of the application
        1. File out the source code of all library classes
        2. Link the source code of all library classes into the source directory
        3. Generate the file Make.Proto
        4. Generate the file Makefile
        5. Make the library

    [start with:]
        LibraryBuilder open

    [see also:]
        ApplicationBuilder

    [author:]
        Thomas Zwick, eXept Software AG
"
! !

!LibraryBuilder class methodsFor:'accessing'!

label

   ^'Library Builder (experimental)'





! !

!LibraryBuilder class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:LibraryBuilder    
    "

    <resource: #help>

    ^super helpSpec addPairsFrom:#(

#addLibraryClasses
'Adds the selected classes to the list of library classes.'

#fileOutClasses
'Files out the source code of the selected library classes.'

#findClass
'Find the class with the first known letters.'

#inlineNew
'Additionally inline new.'

#libraryClasses
'Classes of the library.'

#libraryName
'Name of the library.'

#linkSources
'Creates links in the source directory to the source files of the library classes.'

#optinline
'Generate optimized inline code.'

#optspace
'Optimize for space.'

#optspace2
'Optimize more for space.'

#optspace3
'Optimize even more for space.'

#removeLibraryClasses
'Removes the selected library classes.'

#stxClasses
'Classes of the ST/X.'

)
! !

!LibraryBuilder class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:LibraryBuilder andSelector:#windowSpec
     LibraryBuilder new openInterface:#windowSpec
     LibraryBuilder open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Library Builder (experimental)'
              #layout: #(#LayoutFrame 15 0 222 0 514 0 681 0)
              #label: 'Library Builder (experimental)'
              #min: #(#Point 420 220)
              #max: #(#Point 1152 900)
              #bounds: #(#Rectangle 15 222 515 682)
              #menu: #menu
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#ViewSpec
                    #name: 'Box1'
                    #layout: #(#LayoutFrame 0 0.0 3 0 0 1.0 316 0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#ViewSpec
                              #name: 'Box2'
                              #layout: #(#LayoutFrame 0 0.0 0 0.0 -148 1.0 0 1.0)
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#LabelSpec
                                        #name: 'libraryNameLabel'
                                        #layout: #(#AlignmentOrigin 147 0 15 0 1 0.5)
                                        #label: 'Library Name:'
                                        #adjust: #right
                                    )
                                     #(#InputFieldSpec
                                        #name: 'libraryNameField'
                                        #layout: #(#LayoutFrame 150 0 4 0 0 1 26 0)
                                        #activeHelpKey: #libraryName
                                        #model: #libraryName
                                    )
                                     #(#DividerSpec
                                        #name: 'Separator2'
                                        #layout: #(#LayoutFrame 0 0 28 0 0 1 31 0)
                                    )
                                     #(#LabelSpec
                                        #name: 'libraryClassesLabel'
                                        #layout: #(#AlignmentOrigin 147 0 42 0 1 0.5)
                                        #label: 'Library Classes:'
                                        #adjust: #right
                                    )
                                     #(#SequenceViewSpec
                                        #name: 'libraryClassesList'
                                        #layout: #(#LayoutFrame 0 0.6 56 0 0 1.0 195 0)
                                        #activeHelpKey: #libraryClasses
                                        #model: #selectionOfLibraryClasses
                                        #hasHorizontalScrollBar: true
                                        #hasVerticalScrollBar: true
                                        #miniScrollerVertical: true
                                        #backgroundColor: #(#Color 100.0 74.9996 49.9992)
                                        #isMultiSelect: true
                                        #useIndex: false
                                        #sequenceList: #libraryClasses
                                    )
                                     #(#DividerSpec
                                        #name: 'Separator3'
                                        #layout: #(#LayoutFrame 0 0 196 0 0 1 199 0)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'targetDirectoryButton'
                                        #layout: #(#LayoutFrame 4 0 204 0 147 0 228 0)
                                        #activeHelpKey: #selectPath
                                        #label: 'Target Directory:'
                                        #model: #doSelectDirectory:
                                        #actionValue: 'Target'
                                    )
                                     #(#InputFieldSpec
                                        #name: 'targetDirectoryField'
                                        #layout: #(#LayoutFrame 150 0 205 0 0 1.0 227 0)
                                        #activeHelpKey: #targetDirectory
                                        #model: #targetDirectory
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'topDirectoryButton'
                                        #layout: #(#LayoutFrame 4 0 228 0 147 0 252 0)
                                        #activeHelpKey: #selectPath
                                        #label: 'Top Directory:'
                                        #model: #doSelectDirectory:
                                        #actionValue: 'Top'
                                    )
                                     #(#InputFieldSpec
                                        #name: 'topDirectoryField'
                                        #layout: #(#LayoutFrame 150 0 229 0 0 1.0 251 0)
                                        #activeHelpKey: #topDirectory
                                        #model: #topDirectory
                                    )
                                     #(#DividerSpec
                                        #name: 'Separator4'
                                        #layout: #(#LayoutFrame 0 0.0 278 0 0 1.0 281 0)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'systemLibrariesButton'
                                        #layout: #(#LayoutFrame 4 0 285 0 147 0 309 0)
                                        #activeHelpKey: #selectPath
                                        #label: 'System Libraries:'
                                        #model: #doSelectLibrary:
                                        #actionValue: 'SystemLibrary'
                                    )
                                     #(#ComboBoxSpec
                                        #name: 'systemLibrariesComboBox'
                                        #layout: #(#LayoutFrame 150 0 286 0 0 1 308 0)
                                        #activeHelpKey: #systemLibaries
                                        #model: #systemLibrary
                                        #immediateAccept: false
                                        #acceptOnTab: false
                                        #comboList: #systemLibraries
                                    )
                                     #(#SequenceViewSpec
                                        #name: 'listOfCategoriesList'
                                        #layout: #(#LayoutFrame 0 0.0 56 0 0 0.3 195 0)
                                        #activeHelpKey: #libraryClasses
                                        #model: #selectionOfCategory
                                        #hasHorizontalScrollBar: true
                                        #hasVerticalScrollBar: true
                                        #miniScrollerVertical: true
                                        #backgroundColor: #(#Color 86.9993 86.9993 86.9993)
                                        #useIndex: false
                                        #sequenceList: #listOfCategories
                                    )
                                     #(#SequenceViewSpec
                                        #name: 'listOfClassesList'
                                        #layout: #(#LayoutFrame 0 0.3 56 0 0 0.6 195 0)
                                        #activeHelpKey: #libraryClasses
                                        #model: #selectionOfClasses
                                        #hasHorizontalScrollBar: true
                                        #hasVerticalScrollBar: true
                                        #miniScrollerVertical: true
                                        #backgroundColor: #(#Color 86.9993 86.9993 86.9993)
                                        #isMultiSelect: true
                                        #useIndex: false
                                        #sequenceList: #listOfClasses
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'sourceDirectoryButton1'
                                        #layout: #(#LayoutFrame 4 0 252 0 147 0 276 0)
                                        #activeHelpKey: #selectPath
                                        #label: 'Source Directory:'
                                        #model: #doSelectDirectory:
                                        #actionValue: 'Source'
                                    )
                                     #(#InputFieldSpec
                                        #name: 'sourceDirectoryField'
                                        #layout: #(#LayoutFrame 150 0 253 0 0 1.0 275 0)
                                        #activeHelpKey: #sourceDirectory
                                        #model: #sourceDirectory
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'removeButton'
                                        #layout: #(#LayoutFrame -32 0.6 34 0 -1 0.6 56 0)
                                        #activeHelpKey: #removeLibraryClasses
                                        #hasCharacterOrientedLabel: false
                                        #label: 'leftIcon'
                                        #model: #removeLibraryClasses
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'addButton'
                                        #layout: #(#LayoutFrame 1 0.6 34 0 32 0.6 56 0)
                                        #activeHelpKey: #addLibraryClasses
                                        #hasCharacterOrientedLabel: false
                                        #label: 'rightIcon'
                                        #model: #addLibraryClasses
                                    )
                                  )
                              )
                          )
                           #(#DividerSpec
                              #name: 'Separator5'
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
                                        #layout: #(#LayoutFrame -4 0.0 4 0.0 0 1.0 -128 1.0)
                                        #component: 
                                         #(#SpecCollection
                                            #collection: 
                                             #(
                                               #(#CheckBoxSpec
                                                  #name: 'spaceCheckBox'
                                                  #layout: #(#LayoutFrame 12 0 24 0 21 1 46 0)
                                                  #activeHelpKey: #optspace
                                                  #model: #optspace
                                                  #label: 'Space'
                                              )
                                               #(#CheckBoxSpec
                                                  #name: 'space2CheckBox'
                                                  #layout: #(#LayoutFrame 12 0 48 0 21 1 70 0)
                                                  #activeHelpKey: #optspace2
                                                  #model: #optspace2
                                                  #label: 'Space2'
                                              )
                                               #(#CheckBoxSpec
                                                  #name: 'space3CheckBox'
                                                  #layout: #(#LayoutFrame 12 0 72 0 21 1 94 0)
                                                  #activeHelpKey: #optspace3
                                                  #model: #optspace3
                                                  #label: 'Space3'
                                              )
                                               #(#CheckBoxSpec
                                                  #name: 'inlineCheckBox'
                                                  #layout: #(#LayoutFrame 12 0 96 0 21 1 118 0)
                                                  #activeHelpKey: #optinline
                                                  #model: #optinline
                                                  #label: 'Inline'
                                              )
                                               #(#CheckBoxSpec
                                                  #name: 'inlineNewCheckBox'
                                                  #layout: #(#LayoutFrame 12 0 120 0 21 1 142 0)
                                                  #activeHelpKey: #inlineNew
                                                  #model: #inlineNew
                                                  #label: 'Inline New'
                                              )
                                               #(#CheckBoxSpec
                                                  #name: 'linkSourcesCheckBox'
                                                  #layout: #(#LayoutFrame 12 0 144 0 21 1 166 0)
                                                  #activeHelpKey: #linkSources
                                                  #model: #linkSources
                                                  #label: 'Link Sources'
                                              )
                                            )
                                        )
                                        #label: 'Options'
                                        #labelPosition: #topLeft
                                    )
                                     #(#VerticalPanelViewSpec
                                        #name: 'VerticalPanel'
                                        #layout: #(#LayoutFrame 0 0.0 -68 1 -6 1.0 -2 1.0)
                                        #component: 
                                         #(#SpecCollection
                                            #collection: 
                                             #(
                                               #(#ActionButtonSpec
                                                  #name: 'buildButton'
                                                  #activeHelpKey: #build
                                                  #label: 'Build'
                                                  #model: #doBuild
                                                  #extent: #(#Point 128 32)
                                              )
                                               #(#ActionButtonSpec
                                                  #name: 'stopButton'
                                                  #activeHelpKey: #stop
                                                  #label: 'Stop'
                                                  #model: #doStop
                                                  #extent: #(#Point 128 31)
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
                    #layout: #(#LayoutFrame 0 0.0 318 0 0 1.0 -26 1)
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

!LibraryBuilder class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:LibraryBuilder andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(LibraryBuilder menu)) startUp
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
                          #label: 'Load...'
                          #value: #doLoad
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Save As...'
                          #value: #doSaveAs
                      )
                       #(#MenuItem
                          #label: '-'
                      )
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
                #label: 'Library'
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Build'
                          #value: #doBuild
                          #activeHelpKey: #build
                      )
                       #(#MenuItem
                          #label: 'Stop'
                          #value: #doStop
                          #activeHelpKey: #stop
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'File Out Class'
                          #value: #doFileOutClass
                          #activeHelpKey: #fileOutClasses
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
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'System Libraries...'
                          #value: #doSelectLibrary:
                          #activeHelpKey: #systemLibaries
                          #argument: 'SystemLibrary'
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

!LibraryBuilder methodsFor:'actions'!

addLibraryClasses
    "adds selecetd classes to the list of the library classes"

    |libraryClasses selectionOfLibraryClasses|

    self selectionOfClasses value size == 0 
        ifTrue: [^self warn: 'No class selected!!'].

    libraryClasses := (aspects at: #libraryClasses) value.

    (aspects at: #libraryClasses) value: 
        ((libraryClasses,
        (selectionOfLibraryClasses := self selectionOfClasses value)) asSet asSortedCollection asArray
            topologicalSort:[:n1 :n2 | ((Smalltalk at: n2) isSubclassOf: (Smalltalk at: n1))]) asOrderedCollection.

    self selectionOfLibraryClasses value: selectionOfLibraryClasses.

    self selectionOfCategory changed
!

classSelected: anIndexCollection
    "updates the field of the class name after a selection in the class tree view"

    self valueOfClassName value: (self selectionOfClasses value first name upTo: $ )


!

doBuild
    "builds the library by doing following tasks:
        0. Clobber the target directory of the application
        1. File out the source code of all library classes
        2. Link the source code of all library classes into the source directory
        3. Generate the file Make.Proto
        4. Generate the file Makefile
        5. Make the library
    "
    |dir compilerPath compilerFlags block0 block1 block2 block3 block4 block5 priority|

    task notNil ifTrue: [self warn: 'There is already a build running!!'].

    self inform: 'Starting building of library...' asBoldText.

    (dir := self getTargetDirectory) isNil 
        ifTrue: [^self warn: 'Could not create library directory!!'].

    shellView directory: dir.

    (compilerPath := ByteCodeCompiler ccPath, ' ') isNil 
        ifTrue: [^self warn:'Define first a system compiler!!'].
    compilerFlags := self getCompilerFlags.

    block0 := self getBlockForClobberingTargetDirectory: dir.
    block1 := self getBlockForFilingOutAllClassesIn: dir.
    block2 := self getBlockForLinkingSourceOfAllClassesIn: dir.
    block3 := self getBlockForGeneratingMakeProtoFileIn: dir.
    block4 := self getBlockForGeneratingMakefileFileIn: dir.
    block5 := self getBlockForMakingTheLibraryIn: dir.

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
                                                task isNil 
                                                    ifTrue: [self inform: 'Library build.' asBoldText]
                                                    ifFalse: [self informTargetBuildingFailed].
                                                task := nil.
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
    ].







!

doFileOutClass
    "files out the source code of the selected classes"

    |dir|
    (dir := self getTargetDirectory) isNil 
        ifTrue: [^self warn: 'Could not create library directory!!'].

    self selectionOfLibraryClasses value do:
    [:clsName |
        (Smalltalk at: clsName) fileOutIn: dir
    ]

!

doLoad
    "opens a dialog for loading a library specification"

    |selectedFile fileStream fileAspects|

    (selectedFile := FileSelectionBrowser
        request: 'Load Library Specification' 
        fileName: ((aspects at: #targetDirectory) value asFilename construct: (aspects at: #libraryName) value,'.def') name
        withFileFilters: #('*.def')) notNil 
    ifTrue:
    [
        (fileStream := selectedFile asFilename readStream) notNil
        ifTrue:
        [   
            fileAspects := Compiler evaluate: fileStream contents asString.
            fileAspects associationsDo: 
            [:aspect|
                (aspects at: aspect key) value: aspect value
            ].
            shellView directory: (aspects at: #targetDirectory) value.
            fileStream close    
        ]
    ]


!

doSaveAs
    "opens a dialog for saving the the library specification"

    |selectedFile fileStream longestStringSize|

    (selectedFile := FileSelectionBrowser
        request: 'Save Library Specification' 
        fileName: ((aspects at: #targetDirectory) value asFilename construct: (aspects at: #libraryName) value,'.def') name
        withFileFilters: #('*.def')) notNil 
    ifTrue:
    [
        (fileStream := selectedFile asFilename writeStream) notNil
        ifTrue:
        [   
            longestStringSize := aspects keys first size.
            aspects keys do: [:key| key size > longestStringSize ifTrue: [longestStringSize := key size]].
            fileStream nextPutAll: 'IdentityDictionary new'; cr.
            aspects associationsDo: 
            [:aspect| 
                fileStream nextPutAll: 'at: #', aspect key.
                (longestStringSize - aspect key size) timesRepeat: [fileStream space].
                fileStream nextPutAll: ' put: '. 
                aspect value value storeOn: fileStream.
                fileStream nextPutAll: ';'. 
                fileStream cr
            ].
            fileStream nextPutAll: 'yourself'.
            fileStream close    
        ]
    ]


!

informTargetBuildingFailed
    "informs that something went wrong"

    self inform: 'Library building failed.' asBoldText.
    task := nil
!

removeLibraryClasses
    "removes selected library classes from the list of the library classes"

    |libraryClasses|

    self selectionOfLibraryClasses value size == 0 ifTrue: [^self warn: 'No library class selected!!'].

    libraryClasses := aspects at: #libraryClasses.

    self selectionOfLibraryClasses value do:
    [:clsName|
        libraryClasses value remove: clsName ifAbsent: nil
    ].
    self selectionOfCategory changed.
    libraryClasses changed

! !

!LibraryBuilder methodsFor:'aspects'!

listOfCategories
    "returns the list of categories as value holder"

    |holder|
    (holder := builder bindingAt:#listOfCategories) isNil ifTrue:[
        builder aspectAt:#listOfCategories put: (holder :=  List withAll:
        ((Object withAllSubclasses reject: [:cls|cls isPrivate]) collect: [:cls| cls category]) asSet asSortedCollection)
    ].
    ^ holder



!

listOfClasses
    "returns the list of classes belonging to the selected category as value holder"

    |holder|
    (holder := builder bindingAt:#listOfClasses) isNil ifTrue:[
        builder aspectAt:#listOfClasses put: (holder := List new)
    ].
    ^ holder



!

selectionOfCategory
    "returns the selected category as value holder"

    |holder|
    (holder := builder bindingAt:#selectionOfCategory) isNil ifTrue:[
        builder aspectAt:#selectionOfCategory put:(holder :=  ValueHolder new).
        holder onChangeSend: #value to: 
        [self listOfClasses contents: 
                ((Object withAllSubclasses select: [:cls| cls category = holder value and: [cls isPrivate not]]) collect: [:cls| cls name]).
        self selectionOfLibraryClasses value: ((aspects at: #libraryClasses) value  select: [:clsName| self listOfClasses includes: clsName ]).
        self selectionOfClasses        value: (self listOfClasses select: [:clsName| self selectionOfLibraryClasses value includes: clsName ])].
    ].
    ^ holder

!

selectionOfClasses
    "returns the selected classes as value holder"

    |holder|
    (holder := builder bindingAt:#selectionOfClasses) isNil ifTrue:[
        builder aspectAt:#selectionOfClasses put:(holder :=  ValueHolder new).
    ].
    ^ holder

!

selectionOfLibraryClasses
    "returns the selected library classes as value holder"

    |holder|
    (holder := builder bindingAt:#selectionOfLibraryClasses) isNil ifTrue:[
        builder aspectAt:#selectionOfLibraryClasses put:(holder := Array new asValue).
    ].
    ^ holder

! !

!LibraryBuilder methodsFor:'building blocks'!

getBlockForFilingOutAllClassesIn: dir
    "returns the block for filing out all Smalltalk-source files into the target directory"

    ^
    [
        |libraryClasses|
        (libraryClasses := self getLibraryClasses) isEmpty
        ifTrue: 
        [
            self warn:'No class libraries defined!!'
        ]
        ifFalse:     
        [
            libraryClasses do:
            [:cls |
                cls isLoaded ifFalse: [cls autoload].     
                cls fileOutIn: dir.
            ].
            task := nil
        ]
    ]

!

getBlockForGeneratingMakeProtoFileIn: dir
    "returns the block for generating the file Make.proto"

    ^
    [
        |makeProtoFile makeProtoFileStream conf libraryClasses|

        (makeProtoFileStream := (makeProtoFile := dir asFilename construct:'Make.proto') writeStream) isNil
        ifTrue:
        [
            self warn: 'Cannot create Make.proto'
        ]
        ifFalse:
        [
            libraryClasses := self getLibraryClasses collect: [:cls|Smalltalk fileNameForClass:cls name].

            makeProtoFileStream
                nextPutAll:'#Make.proto automatically generated by the Library Builder of ST/X.'; cr; cr;
                nextPutAll:'TOP=', (aspects at: #topDirectory) value; cr;
                nextPutAll:'LIBNAME=', (aspects at: #libraryName) value ; cr;
                nextPutAll:'PACKAGE=tz:$(LIBNAME)' ; cr;
                nextPutAll:'STCLOCALOPTIMIZATIONS=', 
                    ((aspects at: #optspace ) value ifTrue: [' +optspace' ] ifFalse: ['']),
                    ((aspects at: #optspace2) value ifTrue: [' +optspace2'] ifFalse: ['']),
                    ((aspects at: #optspace3) value ifTrue: [' +optspace3'] ifFalse: ['']),
                    ((aspects at: #optinline) value ifTrue: [' +optinline'] ifFalse: ['']),
                    ((aspects at: #inlineNew) value ifTrue: [' +inlineNew'] ifFalse: ['']); cr;

                nextPutAll:'STCLOCALOPT=$(STCLOCALOPTIMIZATIONS) -H. -package=$(PACKAGE) -Z$(LIBNAME) $(COMMONSYMFLAG) $(INITCODESEPFLAG)'; cr;
                nextPutAll:'RCSSOURCES=*.st Make.proto' ; cr;
                nextPutAll:'all::           classLibRule' ; cr;
                nextPutAll:'LINK_ADDITIONAL_OBJS=', ((aspects at: #systemLibraries) value asStringCollection asStringWith: $ ); cr.

            makeProtoFileStream nextPutAll:'OBJS= \'; cr.

            libraryClasses do:
            [:clsFileName|
                makeProtoFileStream tab; nextPutAll: clsFileName; nextPutAll:'.$(O)'; tab.
                libraryClasses last ~~ clsFileName ifTrue: [makeProtoFileStream nextPutAll: '\'; cr]
            ].

            makeProtoFileStream cr; cr; nextPutAll:'# BEGINMAKEDEPEND --- do not remove this line; make depend needs it'.
            libraryClasses do:
            [:clsFileName|
                makeProtoFileStream cr; nextPutAll: clsFileName; nextPutAll:'.$(O):  '; nextPutAll: clsFileName; nextPutAll:'.st $(STCHDR)'.
            ].
            makeProtoFileStream cr; nextPutAll:'# ENDMAKEDEPEND --- do not remove this line'.

            makeProtoFileStream close.  

            task := nil
        ]
    ]

!

getBlockForGeneratingMakefileFileIn: dir
    "returns the block for generating the file Makefile"

    ^
    [
        |makeFile makeFileStream makeProtoFile catOn|

        (makeFileStream := (makeFile := dir asFilename construct:'Makefile') writeStream) isNil
        ifTrue:
        [
            self warn:'Cannot create Makefile'.
        ]
        ifFalse:
        [
            catOn :=
            [:aFileName|
                |systemFileStream|
                systemFileStream := Smalltalk systemFileStreamFor: ((aspects at: #topDirectory) value asFilename construct: aFileName) name.
                makeFileStream nextPutAll: systemFileStream contents asString.
                systemFileStream close
            ].

            catOn value: (aspects at: #standardHeaderPath) value.
            catOn value: (aspects at: #commonDefinesPath) value.
            catOn value: (aspects at: #vendorCommonDefinesPath) value.
            catOn value: (aspects at: #vendorCommonConfigurationDefinesPath) value.
            catOn value: (aspects at: #packagePath) value.
            catOn value: (aspects at: #standardHeader2Path) value.

            (makeProtoFile := self getTargetDirectory asFilename construct:'Make.proto') exists
            ifTrue:
            [
                makeFileStream nextPutAll:makeProtoFile readStream contents asString.
            ].

            makeFileStream cr; cr; nextPutAll: 'CONF=', (aspects at: #configuration) value.
            catOn value: (aspects at: #standardRulesPath) value.

            makeFileStream close.

            task := nil
        ]
    ]


!

getBlockForLinkingSourceOfAllClassesIn: dir
    "returns the block for linking source of all Smalltalk-source files into the target directory"

    ^
    [
        self getLibraryClasses do:
        [:cls |
            (aspects at: #linkSources) value 
            ifTrue: 
            [                       
                self executeCommand: 
                'ln -s ', 
                ((aspects at: #targetDirectory) value asFilename construct: cls name, '.st') name, ' ', 
                 (aspects at: #sourceDirectory) value inDirectory: dir.
            ]
        ].
        task := nil
    ]

!

getBlockForMakingTheLibraryIn: dir
    "returns the block for making the library"

    ^
    [
        self inform: 'Making the library...'.
        self executeCommand: 'make' inDirectory: dir.
        task := nil
    ]


! !

!LibraryBuilder methodsFor:'initialization'!

initialize
    "initializes all aspects"

    |topDir myAspects|

    super initialize.

    topDir := (Filename currentDirectory asFilename construct:'..') construct:'..'.

    myAspects := IdentityDictionary new.
    aspects associationsDo: [:aspect| myAspects at: aspect key put: aspect value copy].
    aspects   := myAspects.

    (aspects at: #systemLibrary) addDependent: self.
    self aspectsAt: #libraryName     putFirst: 'libnew'.
    self aspectsAt: #libraryClasses  putFirst: OrderedCollection new.
    self getLibraryClasses. "do check classes"
    self aspectsAt: #libraryDefines  putFirst: '-L/usr/X11/lib -Llib -Lbinary -L. -L/usr/local/lib -L/usr/lib -L/lib -lm -ldl -lXext -lX11'.
    self aspectsAt: #targetDirectory putFirst: (topDir pathName asFilename construct: 'libnew') pathName.
    self aspectsAt: #sourceDirectory putFirst: topDir pathName.

    self aspectsAt: #standardHeaderPath                   putFirst: '/rules/stdHeader'.
    self aspectsAt: #commonDefinesPath                    putFirst: '/configurations/COMMON/defines'.
    self aspectsAt: #vendorCommonDefinesPath              putFirst: '/configurations/vendorConf'.
    self aspectsAt: #vendorCommonConfigurationDefinesPath putFirst: '/configurations/myConf'.
    self aspectsAt: #packagePath                          putFirst: '/configurations/myPack'.
    self aspectsAt: #standardHeader2Path                  putFirst: '/rules/stdHeader2'.
    self aspectsAt: #standardRulesPath                    putFirst: '/rules/stdRules'.

    self aspectsAt: #optspace    putFirst: false.
    self aspectsAt: #optspace2   putFirst: false.
    self aspectsAt: #optspace3   putFirst: false.
    self aspectsAt: #optinline   putFirst: false.
    self aspectsAt: #inlineNew   putFirst: false.

    self aspectsAt: #linkSources putFirst: false.

! !

!LibraryBuilder methodsFor:'queries'!

getLibraryClasses
    "returns the 'real' library classes"

    |libraryClasses cls|
    libraryClasses := OrderedCollection new.
    (aspects at: #libraryClasses) value reverseDo:
    [:clsName| 
        (cls := Smalltalk at: clsName) notNil
            ifTrue: [libraryClasses add: cls]
            ifFalse:[(aspects at: #libraryClasses) value remove: clsName]
    ].
    (aspects at: #libraryClasses) changed.
    ^libraryClasses reverse
! !

!LibraryBuilder methodsFor:'startup & release'!

closeRequest
    "close request; stores the aspects for the next try"

    self class aspects: aspects.

    super closeRequest



! !

!LibraryBuilder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

