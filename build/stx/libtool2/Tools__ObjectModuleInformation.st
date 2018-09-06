"{ Package: 'stx:libtool2' }"

"{ NameSpace: Tools }"

ToolApplicationModel subclass:#ObjectModuleInformation
	instanceVariableNames:'readOnly listOfModuleNames selectedModuleIndexHolder allModules
		objectHandles showOthers showCObjects showBuiltIn showMethods
		showClassLibs table1VisibleHolder table2VisibleHolder
		selectedInfoIndexHolder canBrowseSelectedModule
		canUnloadSelectedModule classNamesShown classInfoShown
		vmInfoShown canUnloadSelectedModulesPackage
		canBrowseSelectedModulesExtensions canUnloadSelectedDLL'
	classVariableNames:''
	poolDictionaries:''
	category:'Monitors-ST/X'
!

Object subclass:#InfoRow
	instanceVariableNames:'name version date value'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ObjectModuleInformation
!

!ObjectModuleInformation class methodsFor:'documentation'!

documentation
"
    Shows the modules (dll's) of ST/X.
    Both builtIn modules, and dynamically loaded modules are listed.

    [author:]
        Claus Gittinger
"
!

examples
"
  Starting the application:
                                                                [exBegin]
    ObjectModuleInformation open

                                                                [exEnd]
"
! !

!ObjectModuleInformation class methodsFor:'info'!

defaultLabel
    ^ 'Object Module Info'

    "Created: / 05-10-2007 / 11:56:59 / cg"
! !

!ObjectModuleInformation class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ObjectModuleInformation andSelector:#windowSpec
     Tools::ObjectModuleInformation new openInterface:#windowSpec
     Tools::ObjectModuleInformation open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'ST/X Module & Version Information'
         name: 'ST/X Module & Version Information'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 505 567)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'ToolBar1'
             layout: (LayoutFrame 0 0 0 0 0 1 40 0)
             menu: toolbarMenu
             textDefault: true
           )
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0 40 0 0 1 0 1)
             component: 
            (SpecCollection
               collection: (
                (SequenceViewSpec
                   name: 'List1'
                   model: selectedModuleIndexHolder
                   menu: moduleMenu
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   useIndex: true
                   sequenceList: listOfModuleNames
                 )
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         name: 'Label2'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         translateLabel: true
                         labelChannel: descriptionLabelHolder
                         adjust: left
                       )
                      (LabelSpec
                         name: 'Label1'
                         layout: (LayoutFrame 0 0 30 0 0 1 60 0)
                         translateLabel: true
                         labelChannel: middleLabelHolder
                         adjust: left
                       )
                      (DataSetSpec
                         name: 'Table1'
                         layout: (LayoutFrame 0 0 60 0 0 1 0 1)
                         visibilityChannel: table1VisibleHolder
                         model: selectedInfoIndexHolder
                         menu: moduleItemMenu
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         dataList: infoTable1ListHolder
                         columnHolder: tableColumns
                         separatorOneDColor: (Color 66.9993133440147 66.9993133440147 66.9993133440147)
                         keepSpaceForOSXResizeHandleV: true
                       )
                      (DataSetSpec
                         name: 'Table2'
                         layout: (LayoutFrame 0 0 60 0 0 1 0 1)
                         initiallyInvisible: true
                         visibilityChannel: table2VisibleHolder
                         model: selectedInfoIndexHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         dataList: infoTable2ListHolder
                         columnHolder: tableColumnsForSingleInfo
                         separatorOneDColor: (Color 66.9993133440147 66.9993133440147 66.9993133440147)
                         keepSpaceForOSXResizeHandleV: true
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.35195530726257 1.0)
           )
          )
        
       )
     )
! !

!ObjectModuleInformation class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::ObjectModuleInformation andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ObjectModuleInformation mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                  translateLabel: true
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
                  label: 'Dynamically Loaded ClassLibraries Only'
                  itemValue: showOnlyDynamicallyLoadedClassLibraries
                  translateLabel: true
                  hideMenuOnActivated: false
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Builtin'
                  translateLabel: true
                  hideMenuOnActivated: false
                  indication: showBuiltIn
                )
               (MenuItem
                  label: 'Class Libraries'
                  translateLabel: true
                  hideMenuOnActivated: false
                  indication: showClassLibs
                )
               (MenuItem
                  label: 'Methods'
                  translateLabel: true
                  hideMenuOnActivated: false
                  indication: showMethods
                )
               (MenuItem
                  label: 'C-Objects'
                  translateLabel: true
                  hideMenuOnActivated: false
                  indication: showCObjects
                )
               (MenuItem
                  label: 'Others'
                  translateLabel: true
                  hideMenuOnActivated: false
                  indication: showOthers
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Update'
                  itemValue: menuUpdateModuleList
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Module'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: canBrowseSelectedModule
                  label: 'Browse'
                  itemValue: browseModule
                  translateLabel: true
                )
               (MenuItem
                  enabled: canBrowseSelectedModulesExtensions
                  label: 'Browse Extensions'
                  itemValue: browseModuleExtensions
                  translateLabel: true
                )
               (MenuItem
                  enabled: canBrowseSelectedModulesProjectDefinition
                  label: 'Browse ProjectDefinition'
                  itemValue: browseModulesProjectDefinition
                  translateLabel: true
                )
               (MenuItem
                  label: 'Find a Class...'
                  itemValue: findClass
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: canCopyClassNameList
                  label: 'Copy Version Info to Clipboard'
                  itemValue: copyClassOrVMNameList
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Load Package...'
                  itemValue: loadPackage
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: canUnloadSelectedModulesPackage
                  label: 'Unload Package...'
                  itemValue: unloadSelectedModulesPackage
                  translateLabel: true
                )
               (MenuItem
                  enabled: canUnloadSelectedModule
                  label: 'Remove Classes && Unload DLL...'
                  itemValue: unloadSelectedModuleAndRemoveClasses
                  translateLabel: true
                )
               (MenuItem
                  enabled: canUnloadSelectedDLL
                  label: 'Unload DLL...'
                  itemValue: unloadSelectedModule
                  translateLabel: true
                )
               (MenuItem
                  label: 'Inspect'
                  itemValue: inspectSelectedObject
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Update'
                  itemValue: menuUpdateModuleList
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application...'
                  itemValue: openAboutThisApplication
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

moduleItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::ObjectModuleInformation andSelector:#moduleItemMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ObjectModuleInformation moduleItemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: canBrowseSelectedClass
            label: 'Browse'
            itemValue: browseClass
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canCopyClassNameList
            label: 'Copy Version Info to Clipboard'
            itemValue: copyClassOrVMNameList
            translateLabel: true
          )
         )
        nil
        nil
      )
!

moduleMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::ObjectModuleInformation andSelector:#moduleMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ObjectModuleInformation moduleMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: canBrowseSelectedModule
            label: 'Browse'
            itemValue: browseModule
            translateLabel: true
          )
         (MenuItem
            enabled: canBrowseSelectedModulesExtensions
            label: 'Browse Extensions'
            itemValue: browseModuleExtensions
            translateLabel: true
          )
         (MenuItem
            enabled: canBrowseSelectedModulesProjectDefinition
            label: 'Browse ProjectDefinition'
            itemValue: browseModulesProjectDefinition
            translateLabel: true
          )
         (MenuItem
            label: 'Find a Class...'
            itemValue: findClass
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canCopyClassNameList
            label: 'Copy Version Info to Clipboard'
            itemValue: copyClassOrVMNameList
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canUnloadSelectedModulesPackage
            label: 'Unload Package...'
            itemValue: unloadSelectedModulesPackage
            translateLabel: true
          )
         (MenuItem
            enabled: canUnloadSelectedModule
            label: 'Remove Classes && Unload DLL...'
            itemValue: unloadSelectedModuleAndRemoveClasses
            translateLabel: true
          )
         (MenuItem
            enabled: canUnloadSelectedDLL
            label: 'Unload DLL...'
            itemValue: unloadSelectedModule
            translateLabel: true
          )
         (MenuItem
            label: 'Inspect'
            itemValue: inspectSelectedObject
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Update'
            itemValue: menuUpdateModuleList
            translateLabel: true
          )
         )
        nil
        nil
      )
!

toolbarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::ObjectModuleInformation andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ObjectModuleInformation toolbarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Update'
            itemValue: menuUpdateModuleList
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary reloadIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canBrowseSelectedModule
            label: 'Browse the Selected Module''s Classes'
            itemValue: browseModule
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary startSystemBrowserIcon)
          )
         (MenuItem
            enabled: canBrowseSelectedModulesExtensions
            label: 'Browse the Selected Module''s Extensions'
            itemValue: browseModuleExtensions
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary browseClassExtensionsIcon)
          )
         )
        nil
        nil
      )
! !

!ObjectModuleInformation class methodsFor:'tableColumns specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::ObjectModuleInformation andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Name'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         isSortable: true
         sortSelector: name
         width: 0.5
         height: heightOfFirstRow
         model: name
         menuFromApplication: false
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Version'
         activeHelpKey: ''
         labelButtonType: Button
         height: heightOfFirstRow
         model: version
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Date'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         isSortable: true
         sortSelector: dateOrEmpty
         height: heightOfFirstRow
         model: date
         menuFromApplication: false
         canSelect: false
       )
      )
    
!

tableColumnsForSingleInfo
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::ObjectModuleInformation andSelector:#tableColumnsForSingleInfo
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: ''
         activeHelpKey: ''
         labelButtonType: None
         width: 0.3
         model: name
         canSelect: false
       )
      (DataSetColumnSpec
         label: ''
         activeHelpKey: ''
         labelButtonType: None
         model: value
         canSelect: false
       )
      )
    
! !

!ObjectModuleInformation methodsFor:'aspects'!

canBrowseSelectedClass
    ^ [classNamesShown notEmptyOrNil
       and:[ self selectedInfoIndex notNil
       and:[ self selectedInfoIndex ~~ 0 ]]]

    "Modified: / 05-10-2007 / 10:51:39 / cg"
!

canBrowseSelectedModule
    canBrowseSelectedModule isNil ifTrue:[
        canBrowseSelectedModule := false asValue
    ].
    ^ canBrowseSelectedModule.

    "Modified: / 05-10-2007 / 10:51:39 / cg"
!

canBrowseSelectedModulesExtensions
    canBrowseSelectedModulesExtensions isNil ifTrue:[
        canBrowseSelectedModulesExtensions := false asValue
    ].
    ^ canBrowseSelectedModulesExtensions.

    "Modified: / 05-10-2007 / 10:51:39 / cg"
!

canBrowseSelectedModulesProjectDefinition
    ^ [ self projectDefinitionClassOfSelectedModule notNil ]
!

canCopyClassNameList
    ^ [table1VisibleHolder value 
    and:[classInfoShown notEmptyOrNil or:[vmInfoShown notEmptyOrNil] ]]

    "Modified: / 05-10-2007 / 10:51:39 / cg"
!

canUnloadSelectedDLL
    canUnloadSelectedDLL isNil ifTrue:[
        canUnloadSelectedDLL := false asValue
    ].
    ^ canUnloadSelectedDLL.

    "Modified: / 05-10-2007 / 10:51:39 / cg"
!

canUnloadSelectedModule
    canUnloadSelectedModule isNil ifTrue:[
        canUnloadSelectedModule := false asValue
    ].
    ^ canUnloadSelectedModule.

    "Modified: / 05-10-2007 / 10:51:39 / cg"
!

canUnloadSelectedModulesPackage
    canUnloadSelectedModulesPackage isNil ifTrue:[
        canUnloadSelectedModulesPackage := false asValue
    ].
    ^ canUnloadSelectedModulesPackage.
!

descriptionLabelHolder
    ^ builder valueAspectFor:#'descriptionLabelHolder' initialValue:''
!

infoTable1ListHolder
    ^ builder valueAspectFor:#'infoTable1ListHolder' initialValue:#()

    "Created: / 05-10-2007 / 12:48:06 / cg"
!

infoTable2ListHolder
    ^ builder valueAspectFor:#'infoTable2ListHolder' initialValue:#()

    "Created: / 05-10-2007 / 12:48:10 / cg"
!

listOfModuleNames
    listOfModuleNames isNil ifTrue:[
        listOfModuleNames := List new.
    ].
    ^ listOfModuleNames.

    "Modified: / 05-10-2007 / 10:49:19 / cg"
!

middleLabelHolder
    ^ builder valueAspectFor:#'middleLabelHolder' initialValue:''

    "Created: / 05-10-2007 / 11:05:08 / cg"
!

notReadOnly
    ^ self readOnly not

    "Created: / 05-10-2007 / 13:06:00 / cg"
!

readOnly
    ^ readOnly ? false

    "Created: / 05-10-2007 / 13:05:51 / cg"
!

readOnly:aBoolean
    readOnly := aBoolean

    "Created: / 05-10-2007 / 13:05:51 / cg"
!

selectedInfoIndex
    |sel|

    sel := self selectedInfoIndexHolder value.
    ^ sel
!

selectedInfoIndexHolder
    selectedInfoIndexHolder isNil ifTrue:[
        selectedInfoIndexHolder := ValueHolder new.
        selectedInfoIndexHolder onChangeSend:#selectedInfoIndexChanged to:self.
    ].
    ^ selectedInfoIndexHolder.

    "Modified: / 05-10-2007 / 10:51:39 / cg"
!

selectedModuleIndex
    |sel|

    sel := self selectedModuleIndexHolder value.
    ^ sel
!

selectedModuleIndexHolder
    selectedModuleIndexHolder isNil ifTrue:[
        selectedModuleIndexHolder := ValueHolder new.
        selectedModuleIndexHolder onChangeSend:#selectedModuleIndexChanged to:self.
    ].
    ^ selectedModuleIndexHolder.

    "Modified: / 05-10-2007 / 10:51:39 / cg"
!

showBuiltIn
    showBuiltIn isNil ifTrue:[
        showBuiltIn := true asValue.
        showBuiltIn onChangeSend:#filterChanged to:self.
    ].
    ^ showBuiltIn

    "Modified: / 05-10-2007 / 12:43:23 / cg"
!

showCObjects
    showCObjects isNil ifTrue:[
        showCObjects := true asValue.
        showCObjects onChangeSend:#filterChanged to:self.
    ].
    ^ showCObjects

    "Modified: / 05-10-2007 / 12:43:16 / cg"
!

showClassLibs
    showClassLibs isNil ifTrue:[
        showClassLibs := true asValue.
        showClassLibs onChangeSend:#filterChanged to:self.
    ].
    ^ showClassLibs

    "Modified: / 05-10-2007 / 12:43:10 / cg"
!

showMethods
    showMethods isNil ifTrue:[
        showMethods := true asValue.
        showMethods onChangeSend:#filterChanged to:self.
    ].
    ^ showMethods

    "Modified: / 05-10-2007 / 12:43:02 / cg"
!

showOnlyDynamicallyLoadedClassLibraries
    self showBuiltIn value:false withoutNotifying:self.
    self showCObjects value:false withoutNotifying:self.
    self showMethods value:false withoutNotifying:self.
    self showOthers value:false withoutNotifying:self.
    self showClassLibs value:true withoutNotifying:self.
    self filterChanged.
!

showOthers
    showOthers isNil ifTrue:[
        showOthers := true asValue.
        showOthers onChangeSend:#filterChanged to:self.
    ].
    ^ showOthers

    "Modified: / 05-10-2007 / 12:42:54 / cg"
!

table1VisibleHolder
    table1VisibleHolder isNil ifTrue:[
        table1VisibleHolder := true asValue.
    ].
    ^ table1VisibleHolder.

    "Modified: / 05-10-2007 / 12:53:05 / cg"
!

table2VisibleHolder
    table2VisibleHolder isNil ifTrue:[
        table2VisibleHolder := false asValue.
    ].
    ^ table2VisibleHolder.

    "Modified: / 05-10-2007 / 12:53:14 / cg"
! !

!ObjectModuleInformation methodsFor:'change & update'!

isExtensionName:nm
    ^ (nm endsWith:'_extensions')
!

selectedInfoIndexChanged
!

selectedModule
    |sel|

    sel := self selectedModuleIndex.
    sel isNil ifTrue:[^ nil].
    ^ objectHandles at:sel.
!

selectedModuleIndexChanged
    | info |

    info := self selectedModuleInfo.

    self canBrowseSelectedModule value:false.
    self canBrowseSelectedModulesExtensions value:false.
    self canUnloadSelectedDLL value:false.
    self canUnloadSelectedModule value:false.
    self canUnloadSelectedModulesPackage value:false.

    classNamesShown := nil.
    classInfoShown := nil.
    vmInfoShown := nil.

    info isNil ifTrue:[
        "/ selected a cObject or unknown
        self showInfoForNonClassLib:(self selectedModuleIndex).
        ^ self.
    ].
    info == #VM ifTrue:[
        "/ selected the pseudo entry for the VM itself
        self showInfoForVM.
        ^ self.
    ].

    "/ selected a class-library package
    self showInfoForClassLib:info.

    "Modified: / 05-10-2007 / 12:56:13 / cg"
!

selectedModuleInfo
    |sel|

    sel := self selectedModuleIndex.
    sel notNil ifTrue:[
        (self showClassLibs value or:[self showBuiltIn value]) ifTrue:[
            ^ allModules at:sel ifAbsent:nil.
        ].
    ].
    ^ nil
!

selectedObjectHandle
    |sel|

    sel := self selectedModuleIndex.
    sel isNil ifTrue:[^ nil].
    ^ objectHandles at:sel.
!

showInfoForClassLib:info
    "selected a lib-package; fill bottom list with class-info"

    |rows projectDefinitionClass mgr canUnload canUnloadPackage|

    self middleLabelHolder value:'Components:'.

    projectDefinitionClass := self selectedModulesProjectDefinitionClass.
    projectDefinitionClass isNil ifTrue:[
        self descriptionLabelHolder value:''.
    ] ifFalse:[
        self descriptionLabelHolder value:("'Description: ',"projectDefinitionClass description).
    ].

    self canBrowseSelectedModule value:true.

    self canBrowseSelectedModulesExtensions 
        value:(info classNames contains:[:nm | self isExtensionName:nm]).

    canUnload := info dynamic and:[self readOnly not].
    self canUnloadSelectedModule value:canUnload.
    canUnloadPackage := canUnload 
                and:[projectDefinitionClass notNil
                and:[projectDefinitionClass projectIsLoaded]].
    self canUnloadSelectedModulesPackage value:canUnloadPackage.


    classNamesShown := self shownClassNamesFor:info.
    rows := classNamesShown collect:[:eachClassName |
                    |cls entry rev binRev listEntry revisionInfo versionString dateString|

                    listEntry := InfoRow new.
                    listEntry name:eachClassName.

                    cls := Smalltalk classNamed:eachClassName.
                    cls isNil ifTrue:[
                        (self isExtensionName:eachClassName) ifTrue:[
                            projectDefinitionClass notNil ifTrue:[
                                mgr := projectDefinitionClass sourceCodeManager.
                                mgr notNil ifTrue:[
                                    versionString := projectDefinitionClass perform:(mgr nameOfVersionMethodForExtensions) ifNotUnderstood:nil.
                                    versionString notNil ifTrue:[
                                        versionString := '(bin: ',(mgr revisionInfoFromString:versionString) revision,')'.
                                    ]
                                ] ifFalse:[
                                    versionString := '(SCM disabled)'.
                                ].
                            ].
                        ] ifFalse:[
                            versionString := '(class removed)'.
                        ].
                    ] ifFalse:[
                        binRev := cls binaryRevision.
                        binRev notNil ifTrue:[
                            cls isLoaded ifTrue:[
                                entry :='(bin: ' , binRev.
                            ] ifFalse:[
                                entry := '(stub for: ' , binRev.
                            ].    
                            (rev := cls revision) ~= binRev ifTrue:[
                                entry := entry , ' / src: ' , (rev printString)
                            ].
                            entry := entry , ')'.
                            versionString := entry
                        ] ifFalse:[
                            cls revision notNil ifTrue:[
                                versionString := '(overloaded by: ' , cls revision , ')' 
                            ]
                        ].
                        revisionInfo := cls revisionInfo.
                        revisionInfo notNil ifTrue:[
                            dateString := revisionInfo at:#date.
                        ].
                    ].
                    listEntry version:versionString.
                    listEntry date:dateString.
                  ].

    classInfoShown := rows.

    self infoTable1ListHolder value:rows.
    self table1VisibleHolder value:true.
    self table2VisibleHolder value:false.

    "Modified: / 29-09-2011 / 15:40:42 / cg"
!

showInfoForNonClassLib:sel
    "selected a method, cObject or unknown"

    |module fileName list newEntry|

    self descriptionLabelHolder value:''.

    sel isNil ifTrue:[
        self table1VisibleHolder value:false.
        self table2VisibleHolder value:false.
        ^ self.
    ].

    module := objectHandles at:sel.
    fileName := module pathName.

    self canUnloadSelectedDLL value:true.

    module isMethodHandle ifTrue:[
        |method nm entries|

        self canUnloadSelectedModule value:self readOnly not.

        self middleLabelHolder value:'Compiled Method:'.

        (method := module method) isNil ifTrue:[
            nm := '** removed **'.
        ] ifFalse:[
            self canBrowseSelectedModule value:true.
"/            menu := PopUpMenu
"/                        labels:#('Inspect' 'Browse')
"/                        selectors:#(inspect browse).
"/            menu actionAt:#inspect put:[ method inspect ].
"/            menu actionAt:#browse put:[ |who|
"/                                        who := method who.
"/                                        UserPreferences systemBrowserClass
"/                                            openInClass:(who methodClass) 
"/                                            selector:(who methodSelector) 
"/                                      ].
"/            listView1 middleButtonMenu:menu.

            nm := (method whoString) withColor:Color blue.
        ].
        entries := OrderedCollection new.
        newEntry := InfoRow new.
        newEntry name:'Compiled method'; value:nm.
        entries add:newEntry.

        newEntry := InfoRow new.
        newEntry name:'Path'; value:fileName.
        entries add:newEntry.

        (method notNil and:[method code notNil]) ifTrue:[
            newEntry := InfoRow new.
            newEntry name:'Address'; value:('(16r) ' , (method code address hexPrintString leftPaddedTo:8 with:$0)).
            entries add:newEntry.
        ].

        self infoTable2ListHolder value:entries.
        self table1VisibleHolder value:false.
        self table2VisibleHolder value:true.
        ^ self.
    ].

    (module isFunctionObjectHandle 
    and:[module functions notEmpty]) ifTrue:[
        self middleLabelHolder value:'Functions:'.

"/        menu := PopUpMenu
"/                    labels:#('Inspect')
"/                    selectors:#(inspect).
"/        menu actionAt:#inspect put:[ module functions inspect  ].
"/        listView1 middleButtonMenu:menu.
"/
        list := module functions 
                        select:[:f | f notNil]
                        thenCollect:[:f | |entry code|
                                        entry := InfoRow new.
                                        entry name:(f name withColor:Color blue).
                                        code := f code.
                                        code isNil ifTrue:[
                                            entry value:('address: NULL').
                                        ] ifFalse:[
                                            entry value:('address: (16r) ' , (code address hexPrintString leftPaddedTo:8 with:$0)).
                                        ].
                                        entry
                                ].
        self infoTable2ListHolder value:list.
        self table1VisibleHolder value:false.
        self table2VisibleHolder value:true.
        ^ self.
    ].

    newEntry := InfoRow new.
    newEntry name:'Unknown'.
    self infoTable2ListHolder value:(Array with:newEntry).
    self table1VisibleHolder value:false.
    self table2VisibleHolder value:true.

    "Modified: / 05-10-2007 / 13:01:33 / cg"
!

showInfoForVM
    "show file versions of vm info in lower view."

    |l|

    self canBrowseSelectedModule value:false.
    self middleLabelHolder value:'VM Components:'.
    self descriptionLabelHolder value:("'Description: '," 'Runtime System (VM)').

    l := ObjectMemory getVMIdentificationStrings
            select:[:entry | (entry includesString:'$Header') 
                                    and:[entry includesString:',v']]
            thenCollect:[:entry |
                |i1 i2 file revision date listEntry|

                listEntry := InfoRow new.

                i1 := entry indexOfSubCollection:'librun'.
                i1 ~~ 0 ifTrue:[
                    i2 := entry indexOfSubCollection:',v' startingAt:i1.
                    i2 ~~ 0 ifTrue:[
                        file := entry copyFrom:i1+7 to:(i2-1).
                        listEntry name:file.

                        i1 := i2+3.
                        i2 := entry indexOfSeparatorStartingAt:i1.
                        revision := entry copyFrom:i1 to:(i2-1).
                        listEntry version:revision.

                        i1 := i2+1.
                        i2 := entry indexOfSeparatorStartingAt:i1.
                        date := entry copyFrom:i1 to:(i2-1).
                        listEntry date:date.
                    ].
                ].
                listEntry.
            ].

    vmInfoShown := l.
    self infoTable1ListHolder value:l.
    self table1VisibleHolder value:true.
    self table2VisibleHolder value:false.

"/    readOnly ifFalse:[
"/        unloadButton disable.
"/        unloadAndRemoveButton disable.
"/    ]

    "Modified: / 05-10-2007 / 12:53:44 / cg"
!

shownClassNamesFor:info
    "/ selected a package; fill bottom list with class-info

    |classNames|

    classNames := info classNames asSortedCollection.
    ^ classNames 
        select:[:cName |
            |cls|

            cls := Smalltalk classNamed:cName.
            cls isNil ifTrue:[
                true "a removed class"
            ] ifFalse:[
                cls isPrivate not
            ].
        ].
! !

!ObjectModuleInformation methodsFor:'initialization'!

postBuildWith:aBuilder
    |canDoIt|

    super postBuildWith:aBuilder.

    canDoIt := ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles].
    self showBuiltIn value:canDoIt.
    self showCObjects value:canDoIt.
    self showClassLibs value:canDoIt.
    self showMethods value:canDoIt.
    self showOthers value:canDoIt.

    self updateModuleList

    "Created: / 05-10-2007 / 10:50:27 / cg"
! !

!ObjectModuleInformation methodsFor:'menu actions'!

browseClass
    |info classNames selectedClassName selectedClass|

    info := self selectedModuleInfo.
    classNames := (self shownClassNamesFor:info) asSortedCollection.
    selectedClassName := classNames at:(self selectedInfoIndex).
    selectedClass := Smalltalk classNamed:selectedClassName.

    selectedClass notNil ifTrue:[
        Smalltalk browseInClass:selectedClass.
        ^ self.
    ].

    "/ clicked on an extensions-module ?
    (self isExtensionName:selectedClassName) ifTrue:[
        self browseModuleExtensions.
        ^ self.
    ].

    self breakPoint:#cg.
!

browseModule
    |moduleInfoOrHandle classes method|

    moduleInfoOrHandle := self selectedObjectHandle.
    "/ what a hack
    (moduleInfoOrHandle isKindOf: ObjectMemory::BinaryModuleDescriptor) ifTrue:[
        classes := moduleInfoOrHandle classNames collect:[:nm | Smalltalk classNamed:nm].

        UserPreferences systemBrowserClass
            perform:#openOnPackage: with:(moduleInfoOrHandle package)
            ifNotUnderstood:[
                "/ Q: what about extensions ?
                UserPreferences systemBrowserClass
                    browseClasses:classes
                    label:(resources string:'Classes in %1' with:moduleInfoOrHandle libraryName).
            ]
    ] ifFalse:[
        moduleInfoOrHandle isMethodHandle ifTrue:[
            method := moduleInfoOrHandle method.
            (method notNil and:[method mclass notNil]) ifFalse:[
                Dialog information:'The method has been redefined/removed'.
                ^ self.
            ].
            UserPreferences systemBrowserClass 
                openInMethod:method
        ]
    ].
!

browseModuleExtensions
    |info name packageID methods|

    info := self selectedModuleInfo.

    name := info classNames detect:[:nm | self isExtensionName:nm].
    packageID := (name copyButLast:('_extensions' size)) asSymbol.
    methods := Smalltalk allExtensionsForPackage:packageID.
    (UserPreferences browserClass) browseMethods:methods title:('Extensions for ',packageID).
!

browseModulesProjectDefinition
    |projectDefinitionClass|

    projectDefinitionClass := self projectDefinitionClassOfSelectedModule.
    projectDefinitionClass notNil ifTrue:[
        (UserPreferences browserClass) openInClass:projectDefinitionClass class
    ].
!

copyClassOrVMNameList
    |text|

    text := ((classInfoShown ? vmInfoShown)collect:[:eachRow | eachRow infoString]) asStringCollection asString.
    self window setClipboardText:text.
!

findClass
    |class moduleIndex classNamesShown classIndex|

    class := Dialog requestClass:'Classname (Tab for completion):'.
    class isEmptyOrNil ifTrue:[^ self].

    moduleIndex := allModules findFirst:[:module | module isSymbol not and:[module classNames includes:class name]].
    moduleIndex == 0 ifTrue:[
        Dialog information:'Class is not contained in a loaded or builtIn package.'.
        ^ self
    ].
    self selectedModuleIndexHolder value:moduleIndex.

    classNamesShown := self shownClassNamesFor:(self selectedModuleInfo).
    classIndex := classNamesShown indexOf:class name.
    self selectedInfoIndexHolder value:classIndex.

"/    module := allModules at:moduleIndex.
"/    info := self selectedModuleInfo.
"/    classNames := (self shownClassNamesFor:info) asSortedCollection.
"/    selectedClassName := classNames at:(self selectedInfoIndex).
"/    selectedClass := Smalltalk classNamed:selectedClassName.
"/
"/    selectedClass notNil ifTrue:[
"/        Smalltalk browseInClass:selectedClass.
"/        ^ self.
"/    ].
"/
"/    "/ clicked on an extensions-module ?
"/    (self isExtensionName:selectedClassName) ifTrue:[
"/        self browseModuleExtensions.
"/        ^ self.
"/    ].
"/
"/    self breakPoint:#cg.
!

inspectSelectedObject
    self selectedObjectHandle inspect.
!

loadPackage
    AbstractLauncherApplication::PackageLoadDialog openModal.
"/    |package|
"/
"/    package := Dialog request:'Name of Package (module:directory)'.
"/    package isEmptyOrNil ifTrue:[^ self].
"/    [
"/        self withWaitCursorDo:[
"/            Smalltalk loadPackage:package.
"/        ].
"/    ] on:PackageLoadError do:[:ex|
"/        Dialog information:'Package not loaded: ', ex description.
"/    ].
    self updateModuleList
!

menuUpdateModuleList
    self updateModuleList

    "Modified: / 05-10-2007 / 13:11:45 / cg"
!

openDocumentation
    self openHTMLDocument: 'tools/misc/TOP.html#MODULEINFO'

    "Modified: / 05-10-2007 / 13:11:45 / cg"
!

selectedModulesProjectDefinitionClass
    "try to figure out, what the definitionClass is inside that module.
     in the future, we should always find one there, however, old libs or
     special libraries (hand built) might be without a projectDefinition."

    |info classNames definitionClasses libraryName|

    info := self selectedModuleInfo.
    classNames := (self shownClassNamesFor:info) asSortedCollection.
    definitionClasses := classNames ? #()
                                collect:[:nm | Smalltalk classNamed:nm]
                                thenSelect:[:cls | cls isProjectDefinition].

    definitionClasses size == 1 ifTrue:[
        ^ definitionClasses first
    ] ifFalse:[
        "/ 0 or more definition classes - fall back - some heuristics...
        libraryName := info libraryName.  "maybe something like 'libstx_libbasic'"
        (libraryName notNil and:[ libraryName startsWith:'lib' ]) ifTrue:[
            ^ Smalltalk classNamed:(libraryName copyFrom:4).
        ].
    ].

    ^ nil
!

unloadSelectedModule
    self unloadSelectedModuleRemoveConnectedObjects:false
!

unloadSelectedModuleAndRemoveClasses
    self unloadSelectedModuleRemoveConnectedObjects:true
!

unloadSelectedModuleRemoveConnectedObjects:doRemoveClasses 
    |module handle|

    module := allModules at:self selectedModuleIndex ifAbsent:nil.
    module notNil ifTrue:[
        (Dialog 
            confirm:'This is a possibly dangerous operation, as the DLL is unloaded without caring for 
proper package-deinstallation procedures. Please use this only in repair situations and when the 
regular unloadPackage operation fails.

Continue ?') 
                ifFalse:[ ^ self ].
        handle := module handle.
    ] ifFalse:[
        handle := objectHandles at:self selectedModuleIndex ifAbsent:nil.
    ].
    handle notNil ifTrue:[
        self 
            withWaitCursorDo:[
                self selectedModuleIndexHolder value:nil.
                doRemoveClasses ifTrue:[
                    handle removeConnectedObjects.
                ].
                handle unload.
                self updateModuleList.
            ].
    ]
!

unloadSelectedModulesPackage
    |definitionClass|

    definitionClass := self selectedModulesProjectDefinitionClass.
    definitionClass isNil ifTrue:[^ self].

    (Dialog 
        confirm:(resources stringWithCRs:'About to unload the package\\    %1\\Continue' with:definitionClass package allBold))
    ifFalse:[
        ^ self
    ].
    Smalltalk unloadPackage:definitionClass package.
! !

!ObjectModuleInformation methodsFor:'private'!

filterChanged
    self updateModuleList

    "Created: / 05-10-2007 / 12:43:36 / cg"
!

projectDefinitionClassOfSelectedModule
    |info packageID projectDefinitionClass|

    info := self selectedModuleInfo.
    info isNil ifTrue:[^ nil].

    info classNames 
        detect:[:nm | 
            |cls|

            cls := Smalltalk at:nm. 
            cls notNil ifTrue:[
                packageID := cls package.
                true
            ] ifFalse:[
                false
            ]
        ]
        ifNone:[^ nil].

    projectDefinitionClass := packageID asPackageId projectDefinitionClass.
    ^ projectDefinitionClass
!

updateModuleList
    |showClassLibs showBuiltIn showMethods showCObjects showOthers
     listOfModuleNames allObjects handles methodObjects |

    showClassLibs := self showClassLibs value.
    showBuiltIn := self showBuiltIn value.
    showMethods := self showMethods value.
    showCObjects := self showCObjects value.
    showOthers := self showOthers value.

    listOfModuleNames := OrderedCollection new.
    handles := OrderedCollection new.

    allObjects := ObjectFileLoader loadedObjectHandles.
    methodObjects := (allObjects select:[:h | h isMethodHandle]) asArray.

    (showClassLibs or:[showBuiltIn]) ifTrue:[
        |moduleNames|

        allModules := ObjectMemory binaryModuleInfo asOrderedCollection.
        allModules := allModules select:
                                    [:i |
                                        |wantToSee|

                                        wantToSee := false.
                                        i dynamic ifTrue:[
                                            showClassLibs ifTrue:[
                                                i isSingleMethod ifFalse:[
                                                    wantToSee := true
                                                ].
                                            ].
                                        ] ifFalse:[
                                            showBuiltIn ifTrue:[
                                                wantToSee := true
                                            ].
                                        ].
                                        wantToSee
                                    ].

        "/ sorting by reverse id brings newest ones to the top (a side effect)
        allModules sort:[:a :b | (a name) < (b name)].
        moduleNames := allModules collect:[:entry | entry name].
        listOfModuleNames addAll:moduleNames.
        handles addAll:allModules.
    ].

    showMethods ifTrue:[
        |methodNames|

        methodNames := methodObjects collect:[:mH | mH method isNil ifTrue:[
                                                        'compiled method - removed' " , ' (in ' , mH pathName , ')' "
                                                    ] ifFalse:[
                                                        'compiled method ' , mH method whoString  " , ' (in ' , mH pathName , ')' "
                                                    ].
                                             ].
        listOfModuleNames addAll:methodNames.
        handles addAll:methodObjects.
    ].

    showCObjects ifTrue:[
        |cObjects cObjectNames|

        cObjects := (allObjects select:[:h | h isFunctionObjectHandle]) asArray.
        cObjectNames := cObjects collect:[:entry | entry pathName].
        listOfModuleNames addAll:cObjectNames.
        handles addAll:cObjects.
    ].

    showOthers ifTrue:[
        |otherObjects otherObjectNames|

        otherObjects := (allObjects reject:[:h | (h isFunctionObjectHandle
                                                 or:[h isMethodHandle
                                                 or:[h isClassLibHandle]])]) asArray.
        otherObjectNames := otherObjects collect:[:entry | entry pathName].
        listOfModuleNames addAll:otherObjectNames.
        handles addAll:otherObjects.
    ].

    showBuiltIn ifTrue:[
        listOfModuleNames addFirst:'VM'.
        handles addFirst:#VM.
        allModules addFirst:#VM.
    ].

    self listOfModuleNames contents:listOfModuleNames.
    objectHandles := handles.
    self selectedModuleIndexChanged.

    "Modified: / 05-10-2007 / 12:45:37 / cg"
! !

!ObjectModuleInformation::InfoRow methodsFor:'accessing'!

date
    ^ date
!

date:something
    date := something.
!

dateOrEmpty
    ^ date ? ''
!

name
    ^ name
!

name:something
    name := something.
!

name:nameArg version:versionArg date:dateArg 
    name := nameArg.
    version := versionArg.
    date := dateArg.
!

value
    ^ value
!

value:something
    value := something.
!

version
    ^ version
!

version:something
    version := something.
! !

!ObjectModuleInformation::InfoRow methodsFor:'info'!

infoString
    ^ name , ' ', (version ? '-') , ' ', (date ? '-') printString
! !

!ObjectModuleInformation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

