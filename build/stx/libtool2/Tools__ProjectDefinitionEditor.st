"{ Package: 'stx:libtool2' }"

"{ NameSpace: Tools }"

ResourceSpecEditor subclass:#ProjectDefinitionEditor
	instanceVariableNames:'definitionClass classList extensionsList selectedClassIndexHolder
		classesTableColumns revisionNrHolder companyNameHolder
		fileMajorVersionNrHolder minorVersionNrHolder iconFileNameHolder
		fileReleaseNrHolder productNameHolder majorVersionNrHolder
		fileRevisionNrHolder fileDescriptionHolder releaseNrHolder
		fileMinorVersionNrHolder descriptionHolder legalCopyrightHolder
		isApplicationDefinitionHolder isNonGUIApplicationHolder
		startSinglethreadedHolder hasConsoleHolder shownHasConsoleHolder
		startupClassNameHolder startupSelectorHolder prerequisitesList
		classListHolder extensionsListHolder prerequisitesListHolder
		documentExtensionsListStringHolder stcOptimizationFlagsHolder
		ccOptimizationFlagsHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools'
!

Object subclass:#ClassListEntry
	instanceVariableNames:'className autoloaded win32 unix'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectDefinitionEditor
!

Object subclass:#ExtensionsListEntry
	instanceVariableNames:'className selector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectDefinitionEditor
!

Object subclass:#PrerequisitesListEntry
	instanceVariableNames:'package'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectDefinitionEditor
!

!ProjectDefinitionEditor class methodsFor:'documentation'!

documentation
"
    unfinished app-definition editor

    [author:]
	cg (cg@FUSI)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
								[exBegin]
    (ProjectDefinitionEditor new
	definitionClass:stx_libbasic) open
								[exEnd]

								[exBegin]
    (ProjectDefinitionEditor new
	definitionClass:bosch_dapasx_application) open
								[exEnd]
"
! !

!ProjectDefinitionEditor class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::ProjectDefinitionEditor    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#documentExtensions
'";"-separated list of file extensions'

)

    "Created: / 15-10-2006 / 14:34:57 / cg"
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::ProjectDefinitionEditor    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#documentExtensions
'";"-separated list of file extensions'

)
! !

!ProjectDefinitionEditor class methodsFor:'interface specs'!

classesSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectDefinitionEditor andSelector:#classesSpec
     Tools::ProjectDefinitionEditor new openInterface:#classesSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: classesSpec
	window:
       (WindowSpec
	  label: 'NewApplication'
	  name: 'NewApplication'
	  min: (Point 0 0)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (DataSetSpec
	      name: 'ClassesTable'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      model: selectedClassIndexHolder
	      menu: classListMenu
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      dataList: classListHolder
	      columnHolder: classesTableColumns
	    )
	   )

	)
      )

    "Modified: / 07-09-2006 / 11:35:14 / cg"
!

compilationSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectDefinitionEditor andSelector:#compilationSpec
     Tools::ProjectDefinitionEditor new openInterface:#compilationSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: compilationSpec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          min: (Point 0 0)
          bounds: (Rectangle 0 0 433 300)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Optimization'
              name: 'FramedBox1'
              layout: (LayoutFrame 0 0 0 0 0 1 93 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'STC Optimization Flags:'
                    name: 'Label1'
                    layout: (LayoutFrame 0 0.0 7 0 160 0 29 0)
                    translateLabel: true
                    adjust: right
                  )
                 (ComboBoxSpec
                    name: 'STCOptimizationFlagsComboBox'
                    layout: (LayoutFrame 162 0.0 5 0 0 1.0 27 0)
                    model: stcOptimizationFlagsHolder
                    acceptOnPointerLeave: false
                    comboList: stcOptimizationFlagList
                    postBuildCallback: flagHolderBuilt:
                  )
                 (LabelSpec
                    label: 'CC Optimization Flags:'
                    name: 'Label2'
                    layout: (LayoutFrame 0 0.0 35 0 160 0 57 0)
                    translateLabel: true
                    adjust: right
                  )
                 (ComboBoxSpec
                    name: 'CCOptimizationFlagsComboBox'
                    layout: (LayoutFrame 162 0.0 33 0 0 1.0 55 0)
                    model: ccOptimizationFlagsHolder
                    acceptOnPointerLeave: false
                    comboList: ccOptimizationFlagList
                    postBuildCallback: flagHolderBuilt:
                  )
                 )
               
              )
            )
           (FramedBoxSpec
              label: 'Includes'
              name: 'FramedBox2'
              layout: (LayoutFrame 0 0 98 0 0 1 160 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Additional Includes:'
                    name: 'Label3'
                    layout: (LayoutFrame 0 0.0 7 0 160 0 29 0)
                    translateLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'IncludeFlagsEntryField'
                    layout: (LayoutFrame 162 0.0 5 0 0 1.0 27 0)
                    model: includeFlagsHolder
                    acceptOnReturn: true
                    acceptOnTab: true
                    acceptOnLostFocus: true
                    acceptOnPointerLeave: false
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

descriptionSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ApplicationDefinitionBuilder andSelector:#descriptionSpec
     ApplicationDefinitionBuilder new openInterface:#descriptionSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: descriptionSpec
        window:
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          min: (Point 0 0)
          bounds: (Rectangle 0 0 433 300)
        )
        component:
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Company:'
              name: 'CompanyLabel'
              layout: (LayoutFrame 2 0.0 13 0 160 0 35 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'CompanyEntryField'
              layout: (LayoutFrame 162 0.0 12 0 -2 1.0 34 0)
              model: companyNameHolder
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Description:'
              name: 'DescriptionLabel'
              layout: (LayoutFrame 2 0.0 39 0 160 0 61 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'DescriptionEntryField'
              layout: (LayoutFrame 162 0.0 38 0 -2 1.0 60 0)
              model: descriptionHolder
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'ProductName:'
              name: 'ProductNameLabel'
              layout: (LayoutFrame 2 0.0 65 0 160 0 87 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'ProductNameEntryField'
              layout: (LayoutFrame 162 0.0 64 0 -2 1.0 86 0)
              model: productNameHolder
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'ProductVersion:'
              name: 'ProductVersionLabel'
              layout: (LayoutFrame 2 0.0 91 0 160 0 113 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'MajorVersionNrEntryField'
              layout: (LayoutFrame 162 0.0 90 0 182 0.0 112 0)
              model: majorVersionNrHolder
              type: number
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (InputFieldSpec
              name: 'MinorVersionNrEntryField'
              layout: (LayoutFrame 184 0.0 90 0 204 0.0 112 0)
              model: minorVersionNrHolder
              type: numberOrNil
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (InputFieldSpec
              name: 'RevisionNrEntryField'
              layout: (LayoutFrame 206 0.0 90 0 226 0.0 112 0)
              model: revisionNrHolder
              type: number
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (InputFieldSpec
              name: 'ReleaseNrEntryField'
              layout: (LayoutFrame 228 0.0 90 0 248 0.0 112 0)
              model: releaseNrHolder
              type: number
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'LegalCopyright:'
              name: 'LegalCopyrightLabel'
              layout: (LayoutFrame 2 0.0 119 0 160 0 141 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'LegalCopyrightEntryField'
              layout: (LayoutFrame 162 0.0 118 0 -2 1.0 140 0)
              model: legalCopyrightHolder
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'FileDescriptionDescription:'
              name: 'FileDescriptionLabel'
              layout: (LayoutFrame 2 0.0 161 0 160 0 183 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'FileDescriptionEntryField'
              layout: (LayoutFrame 162 0.0 160 0 -2 1.0 182 0)
              model: fileDescriptionHolder
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'FileVersion:'
              name: 'FileVersionLabel'
              layout: (LayoutFrame 2 0.0 187 0 160 0 209 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'FileMajorVersionNrEntryField'
              layout: (LayoutFrame 162 0.0 186 0 182 0.0 208 0)
              model: fileMajorVersionNrHolder
              type: number
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (InputFieldSpec
              name: 'FileMinorVersionNrEntryField'
              layout: (LayoutFrame 184 0.0 186 0 204 0.0 208 0)
              model: fileMinorVersionNrHolder
              type: number
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (InputFieldSpec
              name: 'FileRevisionNrEntryField'
              layout: (LayoutFrame 206 0.0 186 0 226 0.0 208 0)
              model: fileRevisionNrHolder
              type: number
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (InputFieldSpec
              name: 'FileReleaseNrEntryField'
              layout: (LayoutFrame 228 0.0 186 0 248 0.0 208 0)
              model: fileReleaseNrHolder
              type: number
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Icon Filename:'
              name: 'IconFileNameLabel'
              layout: (LayoutFrame 2 0.0 236 0 160 0 258 0)
              visibilityChannel: isApplicationDefinitionHolder
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'IconFileNameEntryField'
              layout: (LayoutFrame 162 0.0 234 0 -2 1.0 256 0)
              visibilityChannel: isApplicationDefinitionHolder
              model: iconFileNameHolder
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: false
            )
           )

        )
      )
!

extensionsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ApplicationDefinitionEditor andSelector:#extensionsSpec
     ApplicationDefinitionEditor new openInterface:#extensionsSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: extensionsSpec
	window:
       (WindowSpec
	  label: 'NewApplication'
	  name: 'NewApplication'
	  min: (Point 0 0)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (DataSetSpec
	      name: 'ExtensionsTable'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      model: selectedExtensionIndexHolder
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      dataList: extensionsListHolder
	      columnHolder: extensionsTableColumns
	    )
	   )

	)
      )

    "Modified: / 07-09-2006 / 11:35:17 / cg"
!

prerequisitesSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ApplicationDefinitionEditor andSelector:#extensionsSpec
     ApplicationDefinitionEditor new openInterface:#extensionsSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: extensionsSpec
	window:
       (WindowSpec
	  label: 'NewApplication'
	  name: 'NewApplication'
	  min: (Point 0 0)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (DataSetSpec
	      name: 'ExtensionsTable'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      model: selectedPrerequisitesIndexHolder
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      dataList: prerequisitesListHolder
	      columnHolder: prerequisitesTableColumns
	    )
	   )

	)
      )

    "Created: / 05-09-2006 / 13:21:32 / cg"
    "Modified: / 07-09-2006 / 11:35:20 / cg"
!

startupSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectDefinitionEditor andSelector:#startupSpec
     Tools::ProjectDefinitionEditor new openInterface:#startupSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: startupSpec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          min: (Point 0 0)
          bounds: (Rectangle 0 0 433 300)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              label: 'Startup'
              name: 'StartupFrame'
              layout: (LayoutFrame 0 0 0 0 0 1 93 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Startup Class:'
                    name: 'Label1'
                    layout: (LayoutFrame 0 0.0 7 0 160 0 29 0)
                    translateLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'StartupClassEntryField'
                    layout: (LayoutFrame 162 0.0 5 0 0 1.0 27 0)
                    model: startupClassNameHolder
                    acceptOnReturn: true
                    acceptOnTab: true
                    acceptOnLostFocus: true
                    acceptOnPointerLeave: false
                  )
                 (LabelSpec
                    label: 'Startup Selector:'
                    name: 'Label2'
                    layout: (LayoutFrame 0 0.0 35 0 160 0 57 0)
                    translateLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'StartupSelectorEntryField'
                    layout: (LayoutFrame 162 0.0 33 0 0 1.0 55 0)
                    model: startupSelectorHolder
                    acceptOnReturn: true
                    acceptOnTab: true
                    acceptOnLostFocus: true
                    acceptOnPointerLeave: false
                  )
                 )
               
              )
            )
           (FramedBoxSpec
              label: 'Execution'
              name: 'ExecutionFrame'
              layout: (LayoutFrame 0 0 94 0 0 1 176 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (CheckBoxSpec
                    label: 'Non-GUI Application'
                    name: 'Non-GUI CheckBox'
                    layout: (LayoutFrame 0 0.0 7 0 0 0.5 29 0)
                    model: isNonGUIApplicationHolder
                    translateLabel: true
                  )
                 (CheckBoxSpec
                    label: 'Singlethreaded'
                    name: 'SinglethreadedCheckBox'
                    layout: (LayoutFrame 0 0.5 7 0 0 1 29 0)
                    enableChannel: isNonGUIApplicationHolder
                    model: startSinglethreadedHolder
                    translateLabel: true
                  )
                 (CheckBoxSpec
                    label: 'Has Console'
                    name: 'HasConsoleCheckBox1'
                    layout: (LayoutFrame 0 0.5 34 0 0 1 56 0)
                    enableChannel: isGUIApplicationHolder
                    model: shownHasConsoleHolder
                    translateLabel: true
                  )
                 )
               
              )
            )
           (FramedBoxSpec
              label: 'File Extensions'
              name: 'FileExtensionsFrame'
              layout: (LayoutFrame 0 0 177 0 0 1 237 0)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Document Extensions:'
                    name: 'Label3'
                    layout: (LayoutFrame 0 0.0 7 0 160 0 29 0)
                    activeHelpKey: documentExtensions
                    translateLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    activeHelpKey: documentExtensions
                    name: 'EntryField1'
                    layout: (LayoutFrame 162 0.0 5 0 0 1.0 27 0)
                    model: documentExtensionsListStringHolder
                    type: string
                    acceptOnReturn: true
                    acceptOnTab: true
                    acceptOnLostFocus: true
                    acceptOnPointerLeave: false
                  )
                 )
               
              )
            )
           )
         
        )
      )

    "Modified: / 15-10-2006 / 14:35:12 / cg"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ApplicationDefinitionBuilder andSelector:#windowSpec
     ApplicationDefinitionBuilder new openInterface:#windowSpec
     ApplicationDefinitionBuilder open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'ApplicationDefinitionBuilder'
	  name: 'ApplicationDefinitionBuilder'
	  min: (Point 10 10)
	  max: (Point 1024 768)
	  bounds: (Rectangle 0 0 596 339)
	  menu: mainMenu
	)
	component:
       (SpecCollection
	  collection: (
	   (NoteBookViewSpec
	      name: 'NoteBook1'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      model: selectedTabIndexHolder
	      menu: tabList
	      useIndex: true
	    )
	   )

	)
      )

    "Modified: / 03-09-2006 / 10:57:33 / cg"
! !

!ProjectDefinitionEditor class methodsFor:'list specs'!

tabList
^ self  tabListForApplication.

    "Created: / 06-09-2006 / 13:38:03 / cg"
!

tabListForApplication
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#tabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
	  label: 'Description'
	  minorKey: descriptionSpec
	)
       (TabItem
	  label: 'Classes'
	  createNewBuilder: false
	  translateLabel: true
	  minorKey: classesSpec
	)
       (TabItem
	  label: 'Extensions'
	  minorKey: extensionsSpec
	)
       (TabItem
	  label: 'Prerequisites'
	  minorKey: prerequisitesSpec
	)
       (TabItem
	  label: 'Compilation'
	  minorKey: compilationSpec
	)
       (TabItem
	  label: 'Startup'
	  minorKey: startupSpec
	)
       )

      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]

    "Created: / 05-09-2006 / 16:24:48 / cg"
    "Modified: / 06-09-2006 / 18:44:34 / cg"
!

tabListForLibrary
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#tabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
	  label: 'Description'
	  minorKey: descriptionSpec
	)
       (TabItem
	  label: 'Classes'
	  createNewBuilder: false
	  translateLabel: true
	  minorKey: classesSpec
	)
       (TabItem
	  label: 'Extensions'
	  minorKey: extensionsSpec
	)
       (TabItem
	  label: 'Prerequisites'
	  minorKey: prerequisitesSpec
	)
       (TabItem
	  label: 'Compilation'
	  minorKey: compilationSpec
	)
       )

      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]

    "Created: / 05-09-2006 / 16:24:52 / cg"
    "Modified: / 06-09-2006 / 18:44:38 / cg"
! !

!ProjectDefinitionEditor class methodsFor:'menu specs'!

classListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::ProjectDefinitionEditor andSelector:#classListMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ProjectDefinitionEditor classListMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: hasDefinitionClassHolder
	    label: 'Generate'
	    itemValue: menuGenerateClassList
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    enabled: hasDefinitionClassHolder
	    label: 'Add...'
	    itemValue: menuAddClass
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: hasDefinitionClassHolder
	    label: 'Remove...'
	    itemValue: menuRemoveClass
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
!

extensionsListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::ProjectDefinitionEditor andSelector:#extensionsListMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ProjectDefinitionEditor extensionsListMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: hasDefinitionClassHolder
	    label: 'Generate'
	    itemValue: menuGenerateExtensionsList
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    enabled: hasDefinitionClassHolder
	    label: 'Add...'
	    itemValue: menuAddExtension
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: hasDefinitionClassHolder
	    label: 'Remove...'
	    itemValue: menuRemoveExtension
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::ProjectDefinitionEditor andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ProjectDefinitionEditor mainMenu)) startUp
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
                  label: 'New Library'
                  itemValue: menuNewLibraryDefinition
                  translateLabel: true
                )
               (MenuItem
                  label: 'New Application'
                  itemValue: menuNewApplicationDefinition
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Open...'
                  itemValue: menuOpen
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasDefinitionClassHolder
                  label: 'Save'
                  itemValue: menuSave
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasDefinitionClassHolder
                  label: 'Save As...'
                  itemValue: menuSaveAs
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
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
            label: 'Definition'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasDefinitionClassHolder
                  label: 'Generate Definitions'
                  itemValue: menuGenerateProjectDefinitions
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Classes'
            translateLabel: true
            isVisible: classesMenuVisibleHolder
            submenuChannel: classListMenu
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'Extensions'
            translateLabel: true
            isVisible: extensionsMenuVisibleHolder
            submenuChannel: extensionsListMenu
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'Prerequisites'
            translateLabel: true
            isVisible: prerequisitesMenuVisibleHolder
            submenuChannel: prerequisitesListMenu
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'MENU_Help'
            translateLabel: true
            startGroup: conditionalRight
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

prerequisitesListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::ProjectDefinitionEditor andSelector:#prerequisitesListMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ProjectDefinitionEditor prerequisitesListMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: hasDefinitionClassHolder
	    label: 'Generate'
	    itemValue: menuGeneratePrerequisitesList
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    enabled: hasDefinitionClassHolder
	    label: 'Add...'
	    itemValue: menuAddPrerequisite
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: hasDefinitionClassHolder
	    label: 'Remove...'
	    itemValue: menuRemovePrerequisite
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
! !

!ProjectDefinitionEditor class methodsFor:'tableColumns specs'!

classesTableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::ProjectDefinitionEditor andSelector:#classesTableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Class'
         labelAlignment: left
         labelButtonType: Button
         model: className
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Auto'
         labelButtonType: Button
         editorType: CheckToggle
         rendererType: CheckToggle
         model: autoloaded
       )
      (DataSetColumnSpec
         label: 'Win32'
         labelButtonType: Button
         editorType: CheckToggle
         rendererType: CheckToggle
         model: win32
       )
      (DataSetColumnSpec
         label: 'Unix'
         labelButtonType: Button
         editorType: CheckToggle
         rendererType: CheckToggle
         model: unix
       )
      )
    
!

extensionsTableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::ProjectDefinitionEditor andSelector:#extensionsTableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
	 label: 'Class'
	 labelAlignment: left
	 labelButtonType: Button
	 model: className
	 canSelect: false
       )
      (DataSetColumnSpec
	 label: 'Selector'
	 labelAlignment: left
	 labelButtonType: Button
	 model: selector
	 canSelect: false
       )
      )

!

prerequisitesTableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::ProjectDefinitionEditor andSelector:#prerequisitesTableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
	 label: 'Package'
	 labelAlignment: left
	 labelButtonType: Button
	 model: package
       )
      )

! !

!ProjectDefinitionEditor methodsFor:'accessing'!

definitionClass
    ^ definitionClass

    "Created: / 04-09-2006 / 16:30:09 / cg"
!

definitionClass:aClass
    definitionClass := aClass.
    self refetchDefinitionValues.

    "Created: / 04-09-2006 / 16:30:18 / cg"
    "Modified: / 07-09-2006 / 12:26:57 / cg"
!

specClass:aClass
    super specClass:aClass.
    self definitionClass:aClass theNonMetaclass.

    "Created: / 06-09-2006 / 19:24:10 / cg"
! !

!ProjectDefinitionEditor methodsFor:'aspects'!

ccOptimizationFlagList
    ^ #(
        '-O'
        '-g'
    )

    "Created: / 15-10-2006 / 15:14:39 / cg"
!

ccOptimizationFlagsHolder
    ccOptimizationFlagsHolder isNil ifTrue:[
        ccOptimizationFlagsHolder := ValueHolder new.
    ].
    ^ ccOptimizationFlagsHolder

    "Created: / 15-10-2006 / 15:13:14 / cg"
!

classListHolder
    classListHolder isNil ifTrue:[
	classListHolder := #() asValue.
    ].
    ^ classListHolder.

    "Created: / 07-09-2006 / 11:34:35 / cg"
!

classesTableColumns
    classesTableColumns isNil ifTrue:[
	classesTableColumns := self class classesTableColumns asValue.
    ].
    ^ classesTableColumns.

    "Modified: / 04-09-2006 / 17:58:09 / cg"
!

companyNameHolder
    companyNameHolder isNil ifTrue:[
	companyNameHolder := ValueHolder new.
    ].
    ^ companyNameHolder.

    "Created: / 04-09-2006 / 17:58:02 / cg"
!

descriptionHolder
    descriptionHolder isNil ifTrue:[
	descriptionHolder := ValueHolder new.
    ].
    ^ descriptionHolder.

    "Modified: / 04-09-2006 / 17:58:15 / cg"
!

documentExtensionsListStringHolder
    documentExtensionsListStringHolder isNil ifTrue:[
        documentExtensionsListStringHolder := '' asValue.
    ].
    ^ documentExtensionsListStringHolder.

    "Created: / 15-10-2006 / 14:32:29 / cg"
!

extensionsListHolder
    extensionsListHolder isNil ifTrue:[
	extensionsListHolder := #() asValue.
    ].
    ^ extensionsListHolder.

    "Created: / 07-09-2006 / 11:34:50 / cg"
!

fileDescriptionHolder
    fileDescriptionHolder isNil ifTrue:[
	fileDescriptionHolder := ValueHolder new.
    ].
    ^ fileDescriptionHolder.

    "Modified: / 04-09-2006 / 17:58:19 / cg"
!

fileMajorVersionNrHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    fileMajorVersionNrHolder isNil ifTrue:[
	fileMajorVersionNrHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       fileMajorVersionNrHolder addDependent:self.
"/       fileMajorVersionNrHolder onChangeSend:#fileMajorVersionNrHolderChanged to:self.
    ].
    ^ fileMajorVersionNrHolder.
!

fileMinorVersionNrHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    fileMinorVersionNrHolder isNil ifTrue:[
	fileMinorVersionNrHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       fileMinorVersionNrHolder addDependent:self.
"/       fileMinorVersionNrHolder onChangeSend:#fileMinorVersionNrHolderChanged to:self.
    ].
    ^ fileMinorVersionNrHolder.
!

fileReleaseNrHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    fileReleaseNrHolder isNil ifTrue:[
	fileReleaseNrHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       fileReleaseNrHolder addDependent:self.
"/       fileReleaseNrHolder onChangeSend:#fileReleaseNrHolderChanged to:self.
    ].
    ^ fileReleaseNrHolder.
!

fileRevisionNrHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    fileRevisionNrHolder isNil ifTrue:[
	fileRevisionNrHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       fileRevisionNrHolder addDependent:self.
"/       fileRevisionNrHolder onChangeSend:#fileRevisionNrHolderChanged to:self.
    ].
    ^ fileRevisionNrHolder.
!

hasConsoleHolder
    hasConsoleHolder isNil ifTrue:[
        hasConsoleHolder := false asValue
    ].
    ^ hasConsoleHolder.

    "Created: / 20-09-2006 / 14:39:18 / cg"
!

iconFileNameHolder
    iconFileNameHolder isNil ifTrue:[
	iconFileNameHolder := ValueHolder new.
    ].
    ^ iconFileNameHolder.

    "Created: / 04-09-2006 / 18:01:22 / cg"
!

isApplicationDefinitionHolder
    isApplicationDefinitionHolder isNil ifTrue:[
	isApplicationDefinitionHolder := false asValue
    ].
    ^ isApplicationDefinitionHolder.

    "Created: / 04-09-2006 / 19:22:47 / cg"
!

isGUIApplicationHolder
    ^ BlockValue forLogicalNot:self isNonGUIApplicationHolder

    "Created: / 20-09-2006 / 14:38:32 / cg"
!

isNonGUIApplicationHolder
    isNonGUIApplicationHolder isNil ifTrue:[
        isNonGUIApplicationHolder := false asValue.
        isNonGUIApplicationHolder addDependent:self.
    ].
    ^ isNonGUIApplicationHolder.

    "Created: / 05-09-2006 / 13:34:31 / cg"
    "Modified: / 15-10-2006 / 14:00:03 / cg"
!

legalCopyrightHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    legalCopyrightHolder isNil ifTrue:[
	legalCopyrightHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       legalCopyrightHolder addDependent:self.
"/       legalCopyrightHolder onChangeSend:#legalCopyrightHolderChanged to:self.
    ].
    ^ legalCopyrightHolder.
!

majorVersionNrHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    majorVersionNrHolder isNil ifTrue:[
	majorVersionNrHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       majorVersionNrHolder addDependent:self.
"/       majorVersionNrHolder onChangeSend:#majorVersionNrHolderChanged to:self.
    ].
    ^ majorVersionNrHolder.
!

minorVersionNrHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    minorVersionNrHolder isNil ifTrue:[
	minorVersionNrHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       minorVersionNrHolder addDependent:self.
"/       minorVersionNrHolder onChangeSend:#minorVersionNrHolderChanged to:self.
    ].
    ^ minorVersionNrHolder.
!

prerequisitesListHolder
    prerequisitesListHolder isNil ifTrue:[
	prerequisitesListHolder := #() asValue.
    ].
    ^ prerequisitesListHolder.

    "Created: / 07-09-2006 / 11:35:03 / cg"
!

productNameHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    productNameHolder isNil ifTrue:[
	productNameHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       productNameHolder addDependent:self.
"/       productNameHolder onChangeSend:#productNameHolderChanged to:self.
    ].
    ^ productNameHolder.
!

releaseNrHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    releaseNrHolder isNil ifTrue:[
	releaseNrHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       releaseNrHolder addDependent:self.
"/       releaseNrHolder onChangeSend:#releaseNrHolderChanged to:self.
    ].
    ^ releaseNrHolder.
!

revisionNrHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    revisionNrHolder isNil ifTrue:[
	revisionNrHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       revisionNrHolder addDependent:self.
"/       revisionNrHolder onChangeSend:#revisionNrHolderChanged to:self.
    ].
    ^ revisionNrHolder.
!

selectedClassIndexHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    selectedClassIndexHolder isNil ifTrue:[
	selectedClassIndexHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       selectedClassIndexHolder addDependent:self.
"/       selectedClassIndexHolder onChangeSend:#selectedClassIndexHolderChanged to:self.
    ].
    ^ selectedClassIndexHolder.
!

shownHasConsoleHolder
    shownHasConsoleHolder isNil ifTrue:[
        shownHasConsoleHolder := IndirectValue for:self hasConsoleHolder.
    ].
    ^ shownHasConsoleHolder

    "Created: / 15-10-2006 / 13:59:01 / cg"
!

shownHasConsoleValue
    ^ BlockValue 
        with:[:m1 :m2 | self isGUIApplicationHolder value not
                        or:[ self hasConsoleHolder value] ]
        argument:(self hasConsoleHolder)
        argument:(self isGUIApplicationHolder).

    "Created: / 15-10-2006 / 13:54:16 / cg"
!

startSinglethreadedHolder
    startSinglethreadedHolder isNil ifTrue:[
	startSinglethreadedHolder := false asValue.
    ].
    ^ startSinglethreadedHolder.

    "Created: / 05-09-2006 / 13:34:54 / cg"
!

startupClassNameHolder
    startupClassNameHolder isNil ifTrue:[
	startupClassNameHolder := '' asValue.
    ].
    ^ startupClassNameHolder.

    "Created: / 06-09-2006 / 18:41:52 / cg"
!

startupSelectorHolder
    startupSelectorHolder isNil ifTrue:[
	startupSelectorHolder := '' asValue.
    ].
    ^ startupSelectorHolder.

    "Created: / 05-09-2006 / 13:34:20 / cg"
!

stcOptimizationFlagList
    ^ #(
        '+optSpace'
        '+optSpace2'
        '+optSpace3'
        '+optInline'
        '-optInline'
        '-inlineNew'
        '-inlineNot'
    )

    "Created: / 15-10-2006 / 15:14:29 / cg"
!

stcOptimizationFlagsHolder
    stcOptimizationFlagsHolder isNil ifTrue:[
        stcOptimizationFlagsHolder := ValueHolder new.
    ].
    ^ stcOptimizationFlagsHolder

    "Modified: / 15-10-2006 / 15:13:10 / cg"
!

tabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#tabList) isNil ifTrue:[
	builder aspectAt:#tabList put:(list := self class tabListForApplication asValue).
    ].
    ^ list

    "Modified: / 06-09-2006 / 17:58:08 / cg"
! !

!ProjectDefinitionEditor methodsFor:'aspects-menu'!

classesMenuVisibleHolder
    ^ builder booleanValueAspectFor:#'classesMenuVisibleHolder'

    "Modified: / 03-09-2006 / 10:57:00 / cg"
!

extensionsMenuVisibleHolder
    ^ builder booleanValueAspectFor:#'extensionsMenuVisibleHolder'

    "Created: / 05-09-2006 / 13:03:16 / cg"
!

hasDefinitionClass
    ^ definitionClass notNil

    "Created: / 07-09-2006 / 12:29:10 / cg"
!

hasDefinitionClassHolder
    ^ [ self hasDefinitionClass ]

    "Created: / 07-09-2006 / 12:29:22 / cg"
!

prerequisitesMenuVisibleHolder
    ^ builder booleanValueAspectFor:#'prerequisitesMenuVisibleHolder'

    "Created: / 05-09-2006 / 13:26:45 / cg"
!

selectedTabIndexHolder
    |h|

    h := builder valueAspectFor:#'selectedTabIndexHolder' initialValue:nil.
    h addDependent:self.
    ^ h

    "Created: / 03-09-2006 / 10:58:05 / cg"
! !

!ProjectDefinitionEditor methodsFor:'change & update'!

fetchClassListEntries
    |entries|

    entries := OrderedCollection new.
    definitionClass
        classNamesAndAttributesDo:[:className :attributes |
            |entry|

            entry := ClassListEntry new.
            entry
                className:className
                autoloaded:(attributes includes:#autoload)
                win32:(attributes includes:#win32)
                unix:(attributes includes:#unix).
            entries add:entry.
        ].
    entries sort:[:a :b | a className < b className].
    ^ entries.

    "Created: / 05-09-2006 / 12:31:26 / cg"
    "Modified: / 21-11-2006 / 18:04:35 / cg"
!

fetchExtensionsListEntries
    |entries|

    entries := OrderedCollection new.
    definitionClass
	extensionMethodNames pairWiseDo:[:className :selector |
	    |entry|

	    entry := ExtensionsListEntry new.
	    entry className:className selector:selector.
	    entries add:entry.
	].

    ^ entries.

    "Created: / 06-09-2006 / 18:45:15 / cg"
!

fetchPrerequisitesListEntries
    |entries|

    entries := OrderedCollection new.
    definitionClass
	preRequisites do:[:packageName |
	    |entry|

	    entry := PrerequisitesListEntry new.
	    entry package:packageName.
	    entries add:entry.
	].

    ^ entries.

    "Created: / 06-09-2006 / 18:45:15 / cg"
    "Modified: / 07-09-2006 / 12:36:21 / cg"
!

fetchValues
    |definitionClass isApplicationDefinition startupClassName startupSelector|

    definitionClass := self definitionClass.
    definitionClass isNil ifTrue:[^ self ].

    isApplicationDefinition := definitionClass isApplicationDefinition.

    self isApplicationDefinitionHolder value:isApplicationDefinition.
    self isNonGUIApplicationHolder value:(isApplicationDefinition and:[definitionClass isGUIApplication not]).
    self hasConsoleHolder value:(isApplicationDefinition and:[definitionClass isConsoleApplication]).
    self startSinglethreadedHolder value:(isApplicationDefinition and:[definitionClass isSingleThreadedApplication]).

    isApplicationDefinition ifTrue:[
        startupClassName := definitionClass name.
        startupSelector := #start.

        Error handle:[:ex | ] do:[ startupClassName := definitionClass startupClassName].
        Error handle:[:ex | ] do:[ startupSelector := definitionClass startupSelector].
        self startupClassNameHolder value:startupClassName.
        self startupSelectorHolder value:startupSelector.

        self iconFileNameHolder value:(definitionClass applicationIconFileName).
        self tabList value:(self class tabListForApplication).
        self documentExtensionsListStringHolder value:(definitionClass documentExtensions asStringWith:';').
    ] ifFalse:[
        self tabList value:(self class tabListForLibrary).
    ].

    self companyNameHolder value:(definitionClass companyName).
    self descriptionHolder value:(definitionClass description).
    self legalCopyrightHolder value:(definitionClass legalCopyright).
    self productNameHolder value:(definitionClass productName).
    self majorVersionNrHolder value:(definitionClass majorVersionNr asInteger).
    self minorVersionNrHolder value:(definitionClass minorVersionNr asInteger).
    self revisionNrHolder value:(definitionClass revisionNr asInteger).
    self releaseNrHolder value:(definitionClass releaseNr asInteger).

    self fileDescriptionHolder value:(definitionClass fileDescription).
    self fileMajorVersionNrHolder value:(definitionClass fileMajorVersionNr asInteger).
    self fileMinorVersionNrHolder value:(definitionClass fileMinorVersionNr asInteger).
    self fileRevisionNrHolder value:(definitionClass fileRevisionNr asInteger).
    self fileReleaseNrHolder value:(definitionClass fileReleaseNr asInteger).

    self classListHolder value:(self fetchClassListEntries).
    self extensionsListHolder value:(self fetchExtensionsListEntries).
    self prerequisitesListHolder value:(self fetchPrerequisitesListEntries).

    self window notNil ifTrue:[
        self window
            label:(isApplicationDefinition
                    ifTrue:'Application'
                    ifFalse:'Library' )
                        , ' Definition: ',definitionClass name.
    ].

    "Created: / 04-09-2006 / 16:34:39 / cg"
    "Modified: / 15-10-2006 / 14:32:45 / cg"
!

refetchDefinitionValues
    self isApplicationDefinitionHolder value:( definitionClass isApplicationDefinition ).
    self fetchValues.

    "Created: / 07-09-2006 / 12:26:54 / cg"
!

update:something with:parameter from:changedObject
    changedObject == self selectedTabIndexHolder ifTrue:[
        self updateMenuVisibility.
        ^ self.
    ].
    changedObject == self isNonGUIApplicationHolder ifTrue:[
        changedObject value ifTrue:[
            "/ a NON-GUI application - always has a console
            self shownHasConsoleHolder valueHolder:true
        ] ifFalse:[
            "/ a GUI application - sometimes has a console
            self shownHasConsoleHolder valueHolder:(self hasConsoleHolder)
        ].
        ^ self.
    ].
    ^ super update:something with:parameter from:changedObject

    "Created: / 03-09-2006 / 10:59:42 / cg"
    "Modified: / 15-10-2006 / 14:08:23 / cg"
!

updateMenuVisibility
    self classesMenuVisibleHolder value:(self hasClassesTabSelected).
    self extensionsMenuVisibleHolder value:(self hasExtensionsTabSelected).
    self prerequisitesMenuVisibleHolder value:(self hasPrerequisitesTabSelected).

    "Created: / 03-09-2006 / 11:01:48 / cg"
    "Modified: / 05-09-2006 / 13:27:10 / cg"
! !

!ProjectDefinitionEditor methodsFor:'initialization & release'!

closeRequest
    (self hasUnsavedChanges) ifTrue:[
	(self confirm:(resources string:'Close without saving ?')) ifFalse:[
	    ^ self
	]
    ].

    ^ super closeRequest

    "Modified: / 03-09-2006 / 10:53:14 / cg"
!

flagHolderBuilt:aComboBox
    aComboBox menuSelectAction:[:txt |
        self updateFlagsIn:aComboBox from:txt
    ].

    "Created: / 15-10-2006 / 15:11:50 / cg"
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.
    self selectedTabIndexHolder value:1.
    self updateMenuVisibility.
    self fetchValues.

    "Modified: / 04-09-2006 / 16:28:09 / cg"
!

postOpenWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked right after the applications window has been opened.
     Add any app-specific actions here (starting background processes etc.).
     See also #postBuildWith:, which is invoked before opening."

    "/ add any code here ...

    ^ super postOpenWith:aBuilder
! !

!ProjectDefinitionEditor methodsFor:'menu actions'!

editNew:definitionClass
    |className class newPackage|

    self hasUnsavedChanges ifTrue:[
        self halt.
    ].
    className := Dialog
                    requestClassName:'Name of new Definition class'
                    okLabel:'Create'
                    initialAnswer:'private_myProject'.
    className isEmptyOrNil ifTrue:[^ self].

    class := Smalltalk classNamed:className.
    class notNil ifTrue:[
        (class isLibraryDefinition == (definitionClass == LibraryDefinition)) ifFalse:[
            Dialog warn:(resources
                            string:'A class named "%1" already exists as %2.'
                            with:className allBold
                            with:(class isLibraryDefinition 
                                    ifTrue:'Library'
                                    ifFalse:'Application')).
            ^ self
        ].
        Dialog warn:(resources
                            string:'A class named "%1" already exists. Editing the existing definition.'
                            with:className allBold).
    ] ifFalse:[
        newPackage := className copy replaceAll:$_ with:$/.
        newPackage replaceAll:$/ with:$:. 
        class := definitionClass newNamed:className package:newPackage.
    ].
    self definitionClass:class.

    "Created: / 15-10-2006 / 14:50:15 / cg"
!

menuGenerateProjectDefinitions
    |action|

    action := [:generator :defClass |
		    defClass theNonMetaclass
			forEachMethodsCodeToCompileDo:
			    [:code :category |
				generator
				    compile:code
				    forClass:defClass theMetaclass
				    inCategory:category.
			    ]
			ignoreOldDefinition:true
	       ].

    masterApplication notNil ifTrue:[
	masterApplication
	    generateUndoableChange:'Generate Project Definitions'
	    overClasses:(Array with:self definitionClass)
	    via:action.
    ] ifFalse:[
	action value:Compiler value:self definitionClass
    ].

    self refetchDefinitionValues

    "Created: / 07-09-2006 / 12:26:22 / cg"
!

menuNew
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'new' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''new'' available.'.
!

menuNewApplicationDefinition
    self editNew:ApplicationDefinition

    "Created: / 15-10-2006 / 14:49:53 / cg"
!

menuNewLibraryDefinition
    self editNew:LibraryDefinition

    "Created: / 15-10-2006 / 14:49:46 / cg"
!

menuOpen
    |projectID class answer|

    projectID := Dialog requestProject:'Project' initialAnswer:'' suggestions:nil.
    class := ProjectDefinition definitionClassForPackage:projectID.
    class isNil ifTrue:[
	answer := Dialog
	    confirmWithCancel:(resources string:'No Projectdefinition class exists for "%1".\\Create ?' with:projectID allBold)
	    labels:(resources array:#('Cancel' 'Create Library' 'Create Application' ))
	    values:#(nil LibraryDefinition ApplicationDefinition)
	    default:2
	    boxLabel:(resources string:'Create Projectdefinition').
	answer isNil ifTrue:[^ self].
    ].
    answer == #LibraryDefinition ifTrue:[
	class := LibraryDefinition definitionClassForPackage:projectID createIfAbsent:true
    ] ifFalse:[
	class := ApplicationDefinition definitionClassForPackage:projectID createIfAbsent:true
    ].
    self definitionClass:class.

    "Modified: / 07-09-2006 / 12:19:58 / cg"
!

menuRemoveClass
    |classListHolder|

    classListHolder := self classListHolder.
    classListHolder value removeIndex:(self selectedClassIndexHolder value).
    classListHolder changed.

    "Created: / 06-09-2006 / 21:31:05 / cg"
    "Modified: / 07-09-2006 / 11:35:44 / cg"
!

menuSave
    self menuSaveAs:definitionClass name

    "Modified: / 05-09-2006 / 13:48:27 / cg"
!

menuSaveAs
    |className class newPackage|

    className := Dialog
                    requestClassName:'Name of new Definition class'
                    okLabel:'Create'
                    initialAnswer:'private_myProject'.
    className isEmptyOrNil ifTrue:[^ self].
    class := Smalltalk classNamed:className.
    class notNil ifTrue:[
        Dialog warn:(resources
                            string:'A class named %1 already exists'
                            with:className).
        ^ self.
    ].
    newPackage := className copy replaceAll:$_ with:$/.
    newPackage replaceAll:$/ with:$:. 
    class := ApplicationDefinition newNamed:className package:newPackage.
    self menuSaveAs:class.

    "Modified: / 15-10-2006 / 14:47:53 / cg"
!

menuSaveAs:aClassName
    self halt.

    "Created: / 05-09-2006 / 13:48:03 / cg"
!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    HTMLDocumentView openFullOnDocumentationFile:'TOP.html'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
!

updateFlagsIn:aComboBox from:flag
    |s flags base negation|

    s := aComboBox editor contents.
    flags := s asCollectionOfWords.
    (flags includes:flag) ifFalse:[
        base := (flag copyFrom:2).
        negation := (flag startsWith:'+') 
                        ifTrue:[ ('-',base) ]
                        ifFalse:[ ('+',base) ].
        flags remove:negation ifAbsent:[].
        flags add:flag.
        aComboBox editor contents:(flags asStringWith:' ').
    ].

    "Created: / 15-10-2006 / 15:35:53 / cg"
! !

!ProjectDefinitionEditor methodsFor:'queries'!

hasClassesTabSelected
    ^ self selectedTabIndex == 2

    "Created: / 03-09-2006 / 11:00:39 / cg"
    "Modified: / 06-09-2006 / 21:20:21 / cg"
!

hasExtensionsTabSelected
    ^ self selectedTabIndex == 3

    "Created: / 05-09-2006 / 13:02:26 / cg"
    "Modified: / 06-09-2006 / 21:20:25 / cg"
!

hasPrerequisitesTabSelected
    ^ self selectedTabIndex == 4

    "Created: / 05-09-2006 / 13:27:16 / cg"
    "Modified: / 06-09-2006 / 21:20:33 / cg"
!

hasUnsavedChanges
     ^ false

    "Created: / 03-09-2006 / 10:53:05 / cg"
!

selectedClass
    |item|

    item := self classListHolder value at:(self selectedClassIndexHolder value).
self halt.

    "Created: / 06-09-2006 / 21:32:20 / cg"
    "Modified: / 07-09-2006 / 11:35:48 / cg"
!

selectedTabIndex
    ^ self selectedTabIndexHolder value

    "Created: / 03-09-2006 / 11:00:48 / cg"
! !

!ProjectDefinitionEditor::ClassListEntry methodsFor:'accessing'!

autoloaded
    ^ autoloaded
!

autoloaded:aBoolean
    autoloaded := aBoolean.

    "Modified: / 21-11-2006 / 18:05:26 / cg"
!

className
    ^ className
!

className:something
    className := something.
!

className:classNameArg autoloaded:autoloadedArg win32:win32Arg unix:unixArg
    className := classNameArg.
    autoloaded := autoloadedArg.
    win32 := win32Arg.
    unix := unixArg.
!

unix
    ^ unix
!

unix:aBoolean
    unix := aBoolean.

    "Modified: / 21-11-2006 / 18:05:32 / cg"
!

win32
    ^ win32
!

win32:aBoolean
    win32 := aBoolean.

    "Modified: / 21-11-2006 / 18:05:35 / cg"
! !

!ProjectDefinitionEditor::ExtensionsListEntry methodsFor:'accessing'!

className
    ^ className
!

className:classNameArg selector:selectorArg
    className := classNameArg.
    selector := selectorArg.
!

selector
    ^ selector
! !

!ProjectDefinitionEditor::PrerequisitesListEntry methodsFor:'accessing'!

package
    ^ package

    "Created: / 07-09-2006 / 12:23:17 / cg"
!

package:something
    package := something.

    "Created: / 07-09-2006 / 12:23:19 / cg"
! !

!ProjectDefinitionEditor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
