"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

StandardSystemView subclass:#BrowserView
	instanceVariableNames:'classCategoryListView classListView methodCategoryListView
		methodListView classMethodListView codeView classToggle
		instanceToggle currentNamespace currentClassCategory
		currentClassHierarchy currentClass currentMethodCategory
		currentMethod currentSelector showInstance actualClass fullClass
		lastMethodCategory aspect variableListView fullProtocol
		lockUpdates autoSearch myLabel acceptClass lastSourceLogMessage
		lastCategory lastModule lastPackage lastMethodMoveClass
		namespaceList allNamespaces gotClassList classList selectorList
		showAllNamespaces classInstVarsInVarList coloringProcess
		codeModified autoSearchIgnoreCase icons environment'
	classVariableNames:'CheckForInstancesWhenRemovingClasses RememberAspect DefaultIcon
		ShowResourceIcons LastSearchPatterns
		ShowMethodCategoryInClassMethodList LastRenames Icons'
	poolDictionaries:''
	category:'Interface-Browsers'
!

!BrowserView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    this class implements all kinds of class browsers.
    Typically, it is started with 'SystemBrowser open', but there are many other 
    startup messages, to launch special browsers.
    See the categories 'startup' and 'special search startup' in the classes
    protocol.

    Alse, see the extra document 'doc/misc/sbrowser.doc' or the HTML online doc
    for how to use the browser.

    written winter 89 by claus

    Notice: 
        SystemBrowser is currently being rewritten to be an instance
        of ApplicationModel - this transition is not yet complete and you see
        here intermediate versions of BrowserView/SystemBrowser. 

        All action is (currently) still done here in BrowserView, although the
        SystemBrowsers class methods are used to startup a browser.
        (which is done to make the upcoming switch transparent)
        This will certainly change ...

    PS:
        why did we add more and more here, instead of rewriting ?
        - because nobody pays us for it ;-),
        and the browser is not too bad to use, as long as you do not look into code.

    [author:]
        Claus Gittinger
"
! !

!BrowserView class methodsFor:'initialization'!

initialize
    "Browser configuration;
     (values can be changed from your private startup file)"


    "
     setting 'ShowMethodCategoryInClassMethodList' to false will suppress the display
     of a methods category in the search-result browsers..
    "
    ShowMethodCategoryInClassMethodList := true.

    "
     setting 'ShowResourceIcons' to false will suppress the display
     of image-, menu-, canvas- etc. icons beside the method name in
     the method list.
    "
    ShowResourceIcons := true.

    "
     setting 'CheckForInstancesWhenRemovingClasses' to false, the removeClass function will remove
     classes WITHOUT checking for instances. Otherwise,
     it will check and let you confirm in case there are instances.
     Checking for instances may be a bit time consuming, though.
     The default is true - therefore, it will check
    "
    CheckForInstancesWhenRemovingClasses := true.

    "
     setting 'RememberAspect' to true makes the browser remember the aspect shown
     in the classList and show this aspect when a new class is selected.
     If false, it always switches to the classes definition
    "
    RememberAspect := true.

    "
     CheckForInstancesWhenRemovingClasses := true
     CheckForInstancesWhenRemovingClasses := false
     RememberAspect := true
     RememberAspect := false
     ShowResourceIcons := true
     ShowResourceIcons := false
    "

    "Created: / 23.11.1995 / 11:35:58 / cg"
    "Modified: / 27.10.1997 / 17:34:25 / cg"
! !

!BrowserView class methodsFor:'class history'!

addToClassHistory:aClass selector:aSelector
    SystemBrowser addToHistory:aClass selector:aSelector
!

checkClassHistory
    "checks the class history for non-existing classes"

    SystemBrowser checkClassHistory
! !

!BrowserView class methodsFor:'cleanup'!

lowSpaceCleanup
    Icons := DefaultIcon := nil.

    "
     self lowSpaceCleanup
    "

    "Modified: / 26.7.1998 / 14:12:23 / cg"
! !

!BrowserView class methodsFor:'defaults'!

changeHistoryMaxSize
    "returns maximum size of the change history"

    Screen current height < 768 ifTrue:[
        ^ 15
    ].
    ^ 20 "/ 15

    "Created: / 10.2.2000 / 14:03:27 / cg"
    "Modified: / 10.2.2000 / 14:07:01 / cg"
!

classHistory
    "returns the class history"

    ^ SystemBrowser classHistory
!

classHistory:newCollection
    "returns the class history"

    SystemBrowser classHistory:newCollection
!

classHistoryMaxSize
    "returns maximum size of the visited class history"

    ^ SystemBrowser classHistoryMaxSize
!

defaultIcon
    "return the browsers default window icon"

    <resource: #programImage>
    <resource: #style (#SYSTEMBROWSER_ICON #SYSTEMBROWSER_ICON_FILE)>

    |nm i resources|

    (i := DefaultIcon) isNil ifTrue:[
        resources := self classResources.
        i := resources at:'SYSTEMBROWSER_ICON' default:nil.
        i isNil ifTrue:[
            nm := resources at:'SYSTEMBROWSER_ICON_FILE' default:'SBrowser.xbm'.
            i := Smalltalk imageFromFileNamed:nm inPackage:#'stx:libtool'.
            i isNil ifTrue:[
                i := StandardSystemView defaultIcon
            ]
        ].
        i notNil ifTrue:[
            DefaultIcon := i := i onDevice:Screen current
        ]
    ].
    ^ i

    "Modified: / 19-03-1997 / 20:48:34 / ca"
    "Modified: / 17-09-2007 / 11:35:24 / cg"
!

fileImageIcon
    "answer an icon to mark file-loading image  methods"

    ^ self imageIcon

    "Created: / 29.10.1997 / 03:32:43 / cg"
! !

!BrowserView class methodsFor:'interface specs'!

methodFilterSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BrowserView andSelector:#methodFilterSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: methodFilterSpec
        window: 
       (WindowSpec
          label: 'Method Filter:'
          name: 'Method Filter:'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 530 225)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Browse methods from list, which:'
              name: 'Label1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 38 0)
              translateLabel: true
              adjust: left
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel2'
              layout: (LayoutFrame 0 0 44 0 -2 1 84 0)
              horizontalLayout: leftFit
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ToggleSpec
                    label: 'Do not'
                    name: 'Toggle1'
                    translateLabel: true
                    model: notContainingMessage
                    isTriggerOnDown: true
                    showLamp: false
                    lampColor: (Color 100.0 100.0 0.0)
                    extent: (Point 70 27)
                  )
                 (CheckBoxSpec
                    label: 'Send the message:'
                    name: 'CheckBox1'
                    model: doFilterMessage
                    translateLabel: true
                    extent: (Point 200 22)
                  )
                 (InputFieldSpec
                    name: 'EntryField1'
                    enableChannel: doFilterMessage
                    model: filteredMessageSelector
                    acceptOnPointerLeave: false
                    extent: (Point 238 22)
                  )
                 )
               
              )
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel3'
              layout: (LayoutFrame 0 0 84 0 -2 1 124 0)
              horizontalLayout: leftFit
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ToggleSpec
                    label: 'Do not'
                    name: 'Toggle2'
                    translateLabel: true
                    model: notContainingString
                    isTriggerOnDown: true
                    showLamp: false
                    lampColor: (Color 100.0 100.0 0.0)
                    extent: (Point 70 27)
                  )
                 (CheckBoxSpec
                    label: 'Contain the String:'
                    name: 'CheckBox2'
                    model: doFilterString
                    translateLabel: true
                    extent: (Point 200 22)
                  )
                 (InputFieldSpec
                    name: 'EntryField2'
                    enableChannel: doFilterString
                    model: filteredString
                    acceptOnPointerLeave: false
                    extent: (Point 238 22)
                  )
                 )
               
              )
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 -48 1.0 0 1.0 0 1.0)
              horizontalLayout: fitSpace
              verticalLayout: centerMax
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button1'
                    translateLabel: true
                    model: cancel
                    extent: (Point 253 27)
                  )
                 (ActionButtonSpec
                    label: 'Browse'
                    name: 'Button2'
                    translateLabel: true
                    model: accept
                    isDefault: true
                    actionValue: ''
                    extent: (Point 254 27)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

methodMoveDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BrowserView andSelector:#methodMoveDialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: methodMoveDialogSpec
        window: 
       (WindowSpec
          label: 'Move method to:'
          name: 'Move method to:'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 353 174)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Move method to which class:'
              name: 'Label1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 38 0)
              translateLabel: true
              adjust: left
            )
           (ComboBoxSpec
              name: 'ComboBox1'
              layout: (LayoutFrame 0 0.0 41 0 0 1.0 66 0)
              model: className
              acceptOnPointerLeave: false
              comboList: classList
              useIndex: true
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 -48 1.0 0 1.0 0 1.0)
              horizontalLayout: fitSpace
              verticalLayout: centerMax
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button1'
                    translateLabel: true
                    model: cancel
                    extent: (Point 165 27)
                  )
                 (ActionButtonSpec
                    label: 'Move'
                    name: 'Button2'
                    translateLabel: true
                    model: accept
                    isDefault: true
                    extent: (Point 165 27)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

repositoryLoadSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BrowserView andSelector:#repositoryLoadSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: repositoryLoadSpec
        window: 
       (WindowSpec
          label: 'Load from repository'
          name: 'Load from repository'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 417 611)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Load class(es) from the repository ...'
              name: 'Label1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 20 0)
              translateLabel: true
              adjust: left
            )
           (VariableVerticalPanelSpec
              name: 'VariableVerticalPanel1'
              layout: (LayoutFrame 0 0.0 20 0.0 0 1.0 -30 1.0)
              component: 
             (SpecCollection
                collection: (
                 (ViewSpec
                    name: 'Box1'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Modules'
                          name: 'Label6'
                          layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                          translateLabel: true
                          adjust: right
                        )
                       (SequenceViewSpec
                          name: 'moduleSelectionList'
                          layout: (LayoutFrame 0 0.0 20 0 0 1.0 0 1.0)
                          model: moduleSelection
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          miniScrollerHorizontal: true
                          useIndex: false
                          sequenceList: moduleList
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
                          label: 'Packages'
                          name: 'Label5'
                          layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                          translateLabel: true
                          adjust: right
                        )
                       (SequenceViewSpec
                          name: 'packageSelectionList'
                          layout: (LayoutFrame 0 0.0 20 0 0 1.0 0 1)
                          model: packageSelection
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          miniScrollerHorizontal: true
                          useIndex: false
                          sequenceList: packageList
                        )
                       )
                     
                    )
                  )
                 (ViewSpec
                    name: 'Box3'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Containers'
                          name: 'Label4'
                          layout: (LayoutFrame 0 0.0 0 0 0 1.0 20 0)
                          translateLabel: true
                          adjust: right
                        )
                       (SequenceViewSpec
                          name: 'containerList'
                          layout: (LayoutFrame 0 0.0 20 0 0 1.0 0 1)
                          model: containerSelection
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          miniScrollerHorizontal: true
                          isMultiSelect: true
                          useIndex: false
                          sequenceList: containerList
                          doubleClickChannel: containerDoubleClicked
                        )
                       )
                     
                    )
                  )
                 )
               
              )
              handles: (Any 0.21165 0.539806 1.0)
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 -35 1 0 1.0 0 1.0)
              horizontalLayout: spreadSpaceMax
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Load'
                    name: 'loadButton'
                    translateLabel: true
                    model: load
                    enableChannel: loadEnabled
                    extent: (Point 100 25)
                  )
                 (ActionButtonSpec
                    label: 'Dismiss'
                    name: 'dismissButton'
                    translateLabel: true
                    model: close
                    extent: (Point 100 25)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!BrowserView class methodsFor:'menu specs'!

menuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:BrowserView andSelector:#menuSpec
     (Menu new fromLiteralArrayEncoding:(BrowserView menuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Browse'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Clone'
                  itemValue: browserClone
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Class...'
                  itemValue: browserOpenInClass
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: isNotSimulatedEnvironment
                  label: 'Full Class Source'
                  itemValue: browserSpawnFullClass
                  translateLabel: true
                )
               (MenuItem
                  label: 'Class Extensions'
                  itemValue: browserSpawnExtensions
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
            label: 'Find'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Class...'
                  itemValue: classCategoryFindClass
                  translateLabel: true
                )
               (MenuItem
                  label: 'Visited Classes'
                  translateLabel: true
                  submenuChannel: classHistoryMenu
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Method...'
                  itemValue: classCategoryFindMethod
                  translateLabel: true
                )
               (MenuItem
                  label: 'Changed Methods'
                  translateLabel: true
                  submenuChannel: changeHistoryMenu
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Category'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'FileOut'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasClassCategorySelected
                        label: 'FileOut As...'
                        itemValue: classCategoryFileOutAs
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasClassCategorySelected
                        label: 'FileOut Each In...'
                        itemValue: classCategoryFileOutEachIn
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasClassCategorySelected
                        label: 'FileOut Each Binary In...'
                        itemValue: classCategoryFileOutBinaryEach
                        translateLabel: true
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: 'Repository'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        label: 'Repository history...'
                        itemValue: classCategoryRepositoryHistory
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasClassCategorySelected
                        label: 'Validate Class Revisions'
                        itemValue: classCategoryValidateClassRevisions
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasClassCategorySelected
                        label: 'CheckIn Each...'
                        itemValue: classCategoryCheckinEach
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: isNotSimulatedEnvironment
                        label: 'Load from Repository...'
                        itemValue: classCategoryLoadFromRepository
                        translateLabel: true
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  enabled: hasClassCategorySelected
                  label: 'PrintOut'
                  itemValue: classCategoryPrintOut
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasClassCategorySelected
                  label: 'PrintOut Protocol'
                  itemValue: classCategoryPrintOutProtocol
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasClassCategorySelectedAndIsNotSimulatedEnvironment
                  label: 'Spawn Category'
                  itemValue: classCategorySpawn
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                  isVisible: false
                )
               (MenuItem
                  label: 'Find Class...'
                  itemValue: classCategoryFindClass
                  translateLabel: true
                  isVisible: false
                )
               (MenuItem
                  label: 'Find Method...'
                  itemValue: classCategoryFindMethod
                  translateLabel: true
                  isVisible: false
                )
               (MenuItem
                  label: 'Visited Classes'
                  translateLabel: true
                  isVisible: false
                  submenuChannel: classHistoryMenu
                )
               (MenuItem
                  label: 'Changed Classes'
                  translateLabel: true
                  isVisible: false
                  submenuChannel: changeHistoryMenu
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: isNotSimulatedEnvironment
                  label: 'New Class Category...'
                  itemValue: classCategoryNewCategory
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasClassCategorySelectedAndIsNotSimulatedEnvironment
                  label: 'Rename...'
                  itemValue: classCategoryRename
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasClassCategorySelectedAndIsNotSimulatedEnvironment
                  label: 'Remove...'
                  itemValue: classCategoryRemove
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: isNotSimulatedEnvironment
                  label: 'Update'
                  itemValue: classCategoryUpdate
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Class'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'FileOut'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'FileOut As...'
                        itemValue: classFileOutAs
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'FileOut Binary As...'
                        itemValue: classFileOutBinaryAs
                        translateLabel: true
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: 'Repository'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasClassSelectedAndIsNotSimulatedEnvironment
                        label: 'Package...'
                        itemValue: classModifyPackage
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelectedAndIsNotSimulatedEnvironment
                        label: 'Source Container...'
                        itemValue: classModifyContainer
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasClassSelectedAndIsNotSimulatedEnvironment
                        label: 'Remove Source Container...'
                        itemValue: classRemoveContainer
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasClassSelected
                        label: 'Revision Log...'
                        itemValue: classRevisionInfo
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Compare with Repository...'
                        itemValue: classCompareWithRepository
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Check into Source Repository...'
                        itemValue: classCheckin
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: isNotSimulatedEnvironment
                        label: 'Load from Repository...'
                        itemValue: classLoadRevision
                        translateLabel: true
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Documentation'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'PrintOut'
                        itemValue: classPrintOut
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'PrintOut Protocol'
                        itemValue: classPrintOutProtocol
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'HTML Documentation'
                        itemValue: classDocumentation
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Save HTML Documentation As...'
                        itemValue: classDocumentationAs
                        translateLabel: true
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  enabled: hasClassSelected
                  label: 'Show'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasClassSelected
                        label: 'Hierarchy'
                        itemValue: classHierarchy
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasClassSelected
                        label: 'Definition'
                        itemValue: classDefinition
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Comment'
                        itemValue: classComment
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Class Instvars'
                        itemValue: classClassInstVars
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Primitive Definitions'
                        itemValue: classPrimitiveDefinitions
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Primitive Variables'
                        itemValue: classPrimitiveVariables
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Primitive Functions'
                        itemValue: classPrimitiveFunctions
                        translateLabel: true
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasClassSelected
                  label: 'Spawn'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Class'
                        itemValue: classSpawn
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Full Protocol'
                        itemValue: classSpawnFullProtocol
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasClassSelected
                        label: 'Hierarchy'
                        itemValue: classSpawnHierarchy
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Subclasses'
                        itemValue: classSpawnSubclasses
                        translateLabel: true
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  enabled: hasClassSelected
                  label: 'References to Class'
                  itemValue: classRefs
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasClassSelected
                  label: 'Find Response to...'
                  itemValue: methodFindAnyMethod
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: isNotSimulatedEnvironment
                  label: 'New'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        label: 'Class...'
                        itemValue: classNewClass
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Subclass...'
                        itemValue: classNewSubclass
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Private Class...'
                        itemValue: classNewPrivateClass
                        translateLabel: true
                      )
                     (MenuItem
                        label: 'Application...'
                        itemValue: classNewApplication
                        translateLabel: true
                      )
                     (MenuItem
                        label: 'Dialog...'
                        itemValue: classNewDialog
                        translateLabel: true
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasLoadedClassSelectedAndIsNotSimulatedEnvironment
                  label: 'Rename...'
                  itemValue: classRename
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasClassSelectedAndIsNotSimulatedEnvironment
                  label: 'Remove...'
                  itemValue: classRemove
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasLoadedClassSelected
                  label: 'More'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasClassSelected
                        label: 'Inspect Class'
                        itemValue: classInspect
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasClassSelected
                        label: 'Inspect Instances'
                        itemValue: classInstancesInspect
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasClassSelected
                        label: 'Inspect Derived Instances'
                        itemValue: classDerivedInstancesInspect
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasClassSelectedAndIsNotSimulatedEnvironment
                        label: 'Make Private Class In...'
                        itemValue: classMakePrivate
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasClassSelectedAndIsNotSimulatedEnvironment
                        label: 'Make Public Class'
                        itemValue: classMakePublic
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
          )
         (MenuItem
            label: 'Protocol'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasMethodCategorySelected
                  label: 'FileOut'
                  itemValue: methodCategoryFileOut
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMethodCategorySelected
                  label: 'FileOut All'
                  itemValue: methodCategoryFileOutAll
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMethodCategorySelected
                  label: 'PrintOut'
                  itemValue: methodCategoryPrintOut
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasMethodCategorySelected
                  label: 'Spawn'
                  itemValue: methodCategorySpawn
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMethodCategorySelected
                  label: 'Spawn Category...'
                  itemValue: methodCategorySpawnCategory
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasLoadedClassSelectedAndIsNotSimulatedEnvironment
                  label: 'New Category...'
                  itemValue: methodCategoryNewCategory
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasLoadedClassSelectedAndIsNotSimulatedEnvironment
                  label: 'Copy Category...'
                  itemValue: methodCategoryCopyCategory
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasMethodCategorySelectedAndIsNotSimulatedEnvironment
                  label: 'Rename...'
                  itemValue: methodCategoryRename
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMethodCategorySelectedAndIsNotSimulatedEnvironment
                  label: 'Remove...'
                  itemValue: methodCategoryRemove
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasLoadedClassSelectedAndIsNotSimulatedEnvironment
                  label: 'Generate'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Documentation Stubs'
                        translateLabel: true
                        isVisible: showingClass
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Initial Application Code'
                        itemValue: methodCategoryCreateApplicationMethods
                        translateLabel: true
                        isVisible: showingClassAndIsApplicationSubclass
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Initial Dialog Code'
                        itemValue: methodCategoryCreateApplicationMethods
                        translateLabel: true
                        isVisible: showingClassAndIsDialogSubclass
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Access Methods (for Selected Variable)'
                        itemValue: methodCategoryCreateAccessMethods
                        translateLabel: true
                        isVisible: showingInstanceAndHasVariableSelected
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Access Methods with Change Notification (for Selected Variable)'
                        itemValue: methodCategoryCreateAccessMethodsWithChange
                        translateLabel: true
                        isVisible: showingInstanceAndHasVariableSelected
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Access Methods (for All)'
                        itemValue: methodCategoryCreateAccessMethods
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Access Methods with Change Notification (for All)'
                        itemValue: methodCategoryCreateAccessMethodsWithChange
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasLoadedClassSelected
                        label: 'Standard update Method Template'
                        itemValue: methodCategoryCreateUpdateMethod
                        translateLabel: true
                        isVisible: showingInstance
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
          )
         (MenuItem
            label: 'Selector'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasMethodSelected
                  label: 'FileOut'
                  itemValue: methodFileOut
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMethodSelected
                  label: 'PrintOut'
                  itemValue: methodPrintOut
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasMethodSelected
                  label: 'Spawn'
                  itemValue: methodSpawn
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMethodSelected
                  label: 'Inheritance'
                  itemValue: methodInheritance
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Senders...'
                  itemValue: methodSenders
                  translateLabel: true
                )
               (MenuItem
                  label: 'Implementors...'
                  itemValue: methodImplementors
                  translateLabel: true
                )
               (MenuItem
                  label: 'Globals...'
                  itemValue: methodGlobalReferends
                  translateLabel: true
                )
               (MenuItem
                  label: 'String Search...'
                  itemValue: methodStringSearch
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: isNotSimulatedEnvironment
                  label: 'New'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasMethodCategorySelected
                        label: 'Method'
                        itemValue: methodNewMethod
                        translateLabel: true
                      )
                     (MenuItem
                        label: 'Window Spec'
                        itemValue: methodNewWindowSpec
                        translateLabel: true
                        isVisible: showingClassAndHasMethodCategorySelectedAndIsApplicationSubclass
                      )
                     (MenuItem
                        label: 'Menu Spec'
                        itemValue: methodNewMenuSpec
                        translateLabel: true
                        isVisible: showingClassAndHasMethodCategorySelectedAndIsApplicationSubclass
                      )
                     (MenuItem
                        label: 'Image Spec'
                        itemValue: methodNewImageSpec
                        translateLabel: true
                        isVisible: showingClassAndHasMethodCategorySelectedAndIsApplicationSubclass
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  enabled: hasMethodSelectedAndIsNotReadOnlyEnvironment
                  label: 'Change Category...'
                  itemValue: methodChangeCategory
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMethodSelectedAndIsNotReadOnlyEnvironment
                  label: 'Copy To...'
                  itemValue: methodCopy
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMethodSelectedAndIsNotReadOnlyEnvironment
                  label: 'Move To...'
                  itemValue: methodMove
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMethodSelectedAndIsNotReadOnlyEnvironment
                  label: 'Remove...'
                  itemValue: methodRemove
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasMethodSelected
                  label: 'More'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasMethodSelected
                        label: 'Compare with Previous'
                        itemValue: methodCompareWithPreviousVersion
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasMethodSelected
                        label: 'Compare Against...'
                        itemValue: methodCompareSource
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasMethodSelected
                        label: 'Inspect Method'
                        itemValue: methodInspect
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasMethodSelectedAndIsNotSimulatedEnvironment
                        label: 'stc-Compile'
                        itemValue: methodSTCCompile
                        translateLabel: true
                      )
                     (MenuItem
                        label: 'Decompile'
                        itemValue: methodDecompile
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasMethodSelectedAndIsNotReadOnlyEnvironment
                        label: 'Package...'
                        itemValue: methodModifyPackage
                        translateLabel: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasMethodSelectedAndIsNotSimulatedEnvironment
                        label: 'Make Public'
                        itemValue: methodMakePublic
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasMethodSelectedAndIsNotSimulatedEnvironment
                        label: 'Make Protected'
                        itemValue: methodMakeProtected
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasMethodSelectedAndIsNotSimulatedEnvironment
                        label: 'Make Private'
                        itemValue: methodMakePrivate
                        translateLabel: true
                      )
                     (MenuItem
                        enabled: hasMethodSelectedAndIsNotSimulatedEnvironment
                        label: 'Make Ignored'
                        itemValue: methodMakeIgnored
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
          )
         (MenuItem
            label: 'Debug'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasWrappedMethodSelected
                  label: 'Remove Break/Trace'
                  itemValue: methodRemoveBreakOrTrace
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasUnwrappedMethodSelected
                  label: 'BreakPoint'
                  itemValue: methodBreakPoint
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasUnwrappedMethodSelected
                  label: 'BreakPoint in...'
                  itemValue: methodBreakPointInprocess
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasUnwrappedMethodSelected
                  label: 'Trace'
                  itemValue: methodTrace
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasUnwrappedMethodSelected
                  label: 'Start Timing'
                  itemValue: methodStartTiming
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasUnwrappedMethodSelected
                  label: 'Start Counting'
                  itemValue: methodStartCounting
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasUnwrappedMethodSelected
                  label: 'Start Mem Usage'
                  itemValue: methodStartMemoryUsage
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: '&Help'
            translateLabel: true
            startGroup: right
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openBrowserDocumentation
                  translateLabel: true
                )
               (MenuItem
                  label: 'Keyword Index'
                  itemValue: openKeywordIndexDocumentation
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About SystemBrowser...'
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
! !

!BrowserView class methodsFor:'resources'!

classResources
    ^ SystemBrowser classResources
! !

!BrowserView class methodsFor:'startup & release'!

preSnapshot
    "flush cached resources before saving a snapshot
     (do not save them in the image)"

    Icons := DefaultIcon := nil.
! !

!BrowserView methodsFor:'change & update'!

delayedUpdate:something with:someArgument from:changedObject
    |list selector oldMethod|

    (changedObject == environment) ifTrue:[
        something == #methodInClassRemoved ifTrue:[
            "/ ignored; I am dependent of individual class update messages
            ^ self
        ].
        something == #methodInClass ifTrue:[
            "/ ignored; I am dependent of individual class update messages
            ^ self
        ].

        self updateNamespaceList.

        something == #newClass ifTrue:[
            (currentClass notNil
            and:[someArgument name = currentClass name
                 or:[someArgument == currentClass]]) ifTrue:[
                "
                 the current class has changed
                "
                (aspect == #definition
                and:[codeView modified not]) ifTrue:[
                    self refetchClass.
                    self classSelectionChanged.
                ] ifFalse:[
                    self updateClassListWithScroll:false.
                ].
                currentClass wasAutoloaded ifFalse:[
                    self warnLabel:'the selected class has changed'.
                ]
            ].

            ((someArgument category = currentClassCategory)
            or:[currentClassCategory notNil
                and:[currentClassCategory startsWith:$*]]) ifTrue:[
                self updateClassListWithScroll:false.
            ].

            someArgument category ~= currentClassCategory ifTrue:[
                "
                 category new ?
                "
                (classCategoryListView notNil 
                and:[(list := classCategoryListView list) notNil
                and:[(list includes:someArgument category) not]])
                ifTrue:[
                    self updateClassCategoryListWithScroll:false.
                ]
            ].

            "/ restart a highlight process, in case some variable
            "/ is now defined which was not before.
            self startSyntaxHighlightProcess.

            ^ self
        ].

        something == #classRemove ifTrue:[
            someArgument == currentClass ifTrue:[
                self warnLabel:'the selected class was removed'.
                ^ self
            ].
            " fall into general update "
        ].

        "
         any other (unknown) change 
         with the Smalltalk dictionary ...
        "
        self updateClassCategoryListWithScroll:false.
        self updateClassListWithScroll:false.
        ^ self
    ].

    changedObject isBehavior ifTrue:[
        "/
        "/ its a class, that has changed
        "/
        fullClass ifTrue:[
            "/
            "/ full-class browser ...
            "/ (must check for both class and metaclass changes)
            "/
            (currentClass theNonMetaclass == changedObject
            or:[currentClass theMetaclass == changedObject]) ifTrue:[
                self warnLabel:'class was changed - the code shown may be obsolete'.
            ].
            ^ self
        ].

        (currentClass notNil 
        and:[changedObject name = currentClass name
             or:[changedObject == currentClass]]) ifTrue:[
            "/
            "/ its the current class that has changed
            "/
            ((something == #methodDictionary)
            or:[something == #methodPackage         "/ will vanish
            or:[something == #methodTrap
            or:[something == #methodPrivacy]]]) ifTrue:[

                "/ new feature: changeArg may be an array consisting of
                "/ the selector and the oldMethod

                someArgument isArray ifTrue:[
                    oldMethod := someArgument at:2.
                    selector := someArgument at:1.
                ] ifFalse:[
                    selector := someArgument
                ].

                (selector isSymbol) ifTrue:[
                    |changedMethod s1 s2 oldMethodSelection oldMethodCategorySelection|

                    "
                     the method with selector was changed or removed
                    "
                    methodListView notNil ifTrue:[
                        oldMethodSelection := methodListView selection.
                    ].
                    (something ~~ #methodTrap
                    and:[something ~~ #methodPrivacy]) ifTrue:[
                        methodCategoryListView notNil ifTrue:[
                            oldMethodCategorySelection := methodCategoryListView selection.
                            self updateMethodCategoryListWithScroll:false.
                            oldMethodCategorySelection size > 0 ifTrue:[
                                codeView modified ifFalse:[
                                    methodCategoryListView selection:oldMethodCategorySelection.
                                ]
                            ]
                        ].
                    ].

                    self updateMethodListWithScroll:false keepSelection:true.
"/                    methodListView notNil ifTrue:[
"/                        methodListView setSelection:oldMethodSelection.
"/                    ].

                    (something == #methodTrap
                    or:[something == #methodPackage
                    or:[something == #methodPrivacy]]) ifTrue:[
                        selector == currentSelector ifTrue:[
                            self refetchMethod.
                        ].
                        ^ self.
                    ].

                    classMethodListView notNil ifTrue:[
                        oldMethodSelection := classMethodListView selection.
                        self updateMethodCategoryListWithScroll:false.
                        classMethodListView selection:oldMethodSelection.
                    ].

                    selector == currentSelector ifTrue:[
                        "
                         special care here: the currently shown method has been
                         changed somehow in another browser (or via fileIn)
                        "
                        changedMethod := currentClass compiledMethodAt:currentSelector.
                        changedMethod isNil ifTrue:[
                            self warnObsoleteCode:'the method shown was removed'.
                            ^ self
                        ].
                        "compare the source codes"
                        currentMethod notNil ifTrue:[
                            s1 := self compressedCodeLinesFor:changedMethod source.
                            s2 := self compressedCodeLinesFor:codeView contentsAsString.
                            s1 = s2 ifFalse:[
                                codeModified ifTrue:[
                                    self warnObsoleteCode:'method has changed - your modified code may be obsolete'.
                                ] ifFalse:[
                                    self warnObsoleteCode:'method has changed - the code shown may be obsolete'.
                                ]
                            ]
                        ].
                        ^ self    
                    ].
                    "/ some other method has changed;
                    "/ restart a highlight process, in case some variable
                    "/ is now defined which was not before.
                    self startSyntaxHighlightProcess.
                ].
                ^ self
            ].

            something == #comment ifTrue:[
                "
                 the class has changed its comment; we don't care, except if
                 currently showing the comment
                "
                aspect == #comment ifTrue:[
                    codeView modified ifFalse:[
                        self refetchClass.
                        self updateCodeView
                    ] ifTrue:[
                        self warnObsoleteCode:'the comment has changed - reselect to update'.
                    ]
                ].
                self refetchClass.
                ^ self
            ].

            something == #definition ifTrue:[
                "
                 the class has changed its definition.
                 Warn, except if showing a method.
                "
                aspect notNil ifTrue:[
                    codeView modified ifFalse:[
                        self refetchClass.
                        self updateCodeView
                    ] ifTrue:[
                        self warnObsoleteCode:'the classes definition has changed - reselect to update'.
                    ].

                    "/ restart a highlight process, in case some variable
                    "/ is now defined which was not before.
                    self startSyntaxHighlightProcess.

                    ^ self
                ].
            ].

            "/
            "/ if I am not showing code update if unmodified,
            "/ warn if modified
            "/
            aspect notNil ifTrue:[
                codeView modified ifFalse:[
                    self refetchClass.
                    self updateCodeView
                ] ifTrue:[
                    self warnObsoleteCode:'the classes has changed - reselect to update'.
                ].
                ^ self
            ].
        
            "
             get the class again - in case of a changed class definition,
             we are otherwise refering to the obsolete old class
            "
            self refetchClass.

            self updateMethodCategoryListWithScroll:false.

            "don't update codeView ...."
            "self update"

            self warnLabel:'the class has changed'.
            ^ self
        ].

        (currentClass notNil
        and:[changedObject == currentClass superclass]) ifTrue:[
            something == #definition ifTrue:[
                "
                 the superclass has changed its definition.
                 We are only interested, if showing the definition,
                 and the superclasses name has changed.
                "
                aspect notNil ifTrue:[
                    codeView modified ifFalse:[
                        self refetchClass.
                        self updateCodeView
                    ] ifTrue:[
                        self warnObsoleteCode:'the classes definition has changed - reselect to update'.
                    ].

                    "/ restart a highlight process, in case some variable
                    "/ is now defined which was not before.
                    self startSyntaxHighlightProcess.

                    ^ self
                ].
            ].
        ].
        
        "
         any other class has changed (but not its organization, since
         that is caught in the above case).
         We are not interested in it - except, if showing fullProtocol
         or hierarchy ...
        "
        currentClassHierarchy notNil ifTrue:[
            fullProtocol ifTrue:[
                (currentClass isSubclassOf:changedObject) ifTrue:[
                    self warnLabel:'some superclass has changed - reselect to update'.
                ]
            ] ifFalse:[
                ((currentClass isSubclassOf:changedObject)
                or:[changedObject isSubclassOf:currentClass]) ifTrue:[
                    self warnLabel:'some superclass has changed - reselect to update'.
                ]                
            ]
        ].

        (currentClassCategory = '* hierarchy *' 
        or:[ currentClassCategory = '* all *' ]) ifTrue:[
            self updateClassCategoryListWithScroll:false.
            self updateClassListWithScroll:false.
        ].

        (something == #methodDictionary) ifTrue:[
            "/ restart a highlight process, in case some method
            "/ is now implemented which was not before.
            self startSyntaxHighlightProcess.
        ].

        ^ self
    ].

    something == #statistics ifTrue:[
        currentMethod notNil ifTrue:[
            changedObject isMethod ifTrue:[
                (changedObject == currentMethod 
                    or:[changedObject == currentMethod originalMethodIfWrapped]) 
                ifTrue:[
                    self refetchMethod.
                    "/ just in case, this is a method which is used during
                    "/ the update ...
                    changedObject removeDependent:self.
                    self updateMethodListWithScroll:false keepSelection:true.
                    changedObject addDependent:self.
                ].
            ].
        ].
    ]

    "Created: / 04-01-1997 / 13:54:00 / cg"
    "Modified: / 27-10-1998 / 12:02:05 / ps"
    "Modified: / 22-10-2010 / 11:46:49 / cg"
!

refetchClass
    "after a class definition change in another browser,
     this is sent to update (otherwise, we'd still refer to the obsolete class)"

"/    currentClass := Smalltalk at:(currentClass name asSymbol).
    self changeCurrentClass:(environment at:(currentClass name asSymbol)).

"/    showInstance ifTrue:[
"/        actualClass := currentClass
"/    ] ifFalse:[
"/        actualClass := currentClass class
"/    ].

    "Created: / 8.2.1996 / 13:22:27 / cg"
    "Modified: / 17.6.1998 / 16:51:14 / cg"
!

update:something with:someArgument from:changedObject
    "enqueue a delayed update"

    |argList sensor|

    (changedObject == ObjectMemory) ifTrue:[
        (something == #earlyRestart 
         or:[something == #restarted
         or:[something == #returnFromSnapshot]]) ifTrue:[
            "/ those are to be ignored.
            ^ self
        ]
    ].

    "/
    "/ avoid update/warn after my own changes
    "/
    lockUpdates == true ifTrue:[
        ^ self
    ].

    "/
    "/ quick hack: delayed update fails, if I autoload
    "/ LabelAndIcon in the update, and another browser
    "/ gets a chance to do an update as well, trying to
    "/ access the (temporarily nil) LabelAndIcon.
    "/ To get that beast out, do it synchronous for now.
    "/ also do it immediately, if not yet realized

    (LabelAndIcon isLoaded not
     or:[realized not]) ifTrue:[
        ^ self delayedUpdate:something with:someArgument from:changedObject
    ].

    "/
    "/ if such an update is already in the queue, ignore it.
    "/ Otherwise push it as an event, to be handled when I am back
    "/
    argList := Array with:something 
                     with:someArgument 
                     with:changedObject.

    sensor := self sensor.

    (sensor hasEvent:#delayedUpdate:with:from:
            for:self
            withArguments:argList) ifTrue:[
        ^ self
    ].
    sensor
        pushUserEvent:#delayedUpdate:with:from:
        for:self
        withArguments:argList

    "Modified: 26.3.1997 / 18:29:51 / cg"
! !

!BrowserView methodsFor:'class category list menu'!

browserClone
    "open a new SystemBrowser showing the same method as I do"

    |brwsr|

    self sensor ctrlDown ifTrue:[
        brwsr := (Tools::NewSystemBrowser ? NewSystemBrowser) openInClass:actualClass selector:currentSelector.
        ^ self.
    ].

    brwsr := SystemBrowser openInClass:actualClass selector:currentSelector.
    brwsr notNil ifTrue:[
        brwsr extent:(self topView extent).
        environment ~~ Smalltalk ifTrue:[
            brwsr environment:environment.
            actualClass notNil ifTrue:[
                brwsr switchToClassNamed:actualClass name. 
                brwsr classSelectionChanged.
            ].
            currentSelector notNil ifTrue:[
                brwsr switchToMethodNamed:currentSelector.
            ].
        ].
    ]

    "Created: 14.9.1995 / 10:55:20 / claus"
    "Modified: 14.9.1995 / 10:59:31 / claus"
!

browserOpenInClass
    "find a class - and open a browser (by default)"

    self classCategoryFindClassOpen:true

    "Modified: 15.1.1997 / 22:55:32 / cg"
!

browserSpawnExtensions
    "create a new SystemBrowser browsing all extensions"

    self withWaitCursorDo:[
        |brwsr methods|

        methods := Smalltalk allExtensions.
        brwsr := SystemBrowser browseMethods:methods title:'All Class Extensions'.
        brwsr notNil ifTrue:[brwsr environment:environment].
    ]

    "Modified: 18.8.1997 / 15:42:58 / cg"
!

browserSpawnFullClass
    "create a new SystemBrowser browsing full class"

    |brwsr|

    self withWaitCursorDo:[
        brwsr := SystemBrowser browseFullClasses.
        brwsr environment:environment.
" "
        currentClass notNil ifTrue:[
            brwsr switchToClassNamed:(currentClass name)
        ]
" "
    ]

    "Modified: 18.8.1997 / 15:43:01 / cg"
!

classCategoryFileOut
    "create a file 'categoryName.st' consisting of all classes in current category
     into the current projects defaultDirectory."

    self classCategoryFileOutAsk:false

    "Modified: 11.10.1997 / 16:47:46 / cg"
!

classCategoryFileOutAs
    "create a file consisting of all classes in the current category
     into a file as user-specified."

    self classCategoryFileOutAsk:true

    "Modified: 11.10.1997 / 16:38:56 / cg"
    "Created: 11.10.1997 / 16:44:35 / cg"
!

classCategoryFileOutAsk:doAsk
    "create a file 'categoryName' consisting of all classes in current category"

    |aStream fileName classesToInitialize|

    self checkClassCategorySelected ifFalse:[^ self].
    (currentClassCategory startsWith:$*) ifTrue:[
        self warn:(resources string:'Try a real category').
        ^ self
    ].

    fileName := currentClassCategory asString asFilename withSuffix:'.st'.
    fileName makeLegalFilename.

    self withWaitCursorDo:[
        |saveName fileBox dir|

        doAsk ifTrue:[
            fileBox := FileSelectionBox
                            title:(resources string:'fileOut %1 as:' with:currentClassCategory)
                            okText:(resources string:'FileOut')
                            abortText:(resources string:'Cancel')
                            action:[:fileName |saveName := fileName.].

            fileBox initialText:fileName name.
            dir := FileSelectionBox lastFileSelectionDirectory.
            dir isNil ifTrue:[
                "
                 this test allows a smalltalk to be built without Projects/ChangeSets
                "
                Project notNil ifTrue:[
                    dir := Project currentProjectDirectory
                ]
            ].
            dir notNil ifTrue:[
                fileBox directory:dir.
            ].
            fileBox open.

            fileBox destroy.
            fileBox := nil.

            saveName isNil ifTrue:[
                ^ self
            ].
            saveName isEmpty ifTrue:[
                self warn:'bad name given'.
                ^ self
            ].
            FileSelectionBox lastFileSelectionDirectory:(saveName asFilename directoryName).
            fileName := saveName asFilename.
        ] ifFalse:[
            "
             this test allows a smalltalk to be built without Projects/ChangeSets
            "
            Project notNil ifTrue:[
                fileName := Project currentProjectDirectory asFilename construct:fileName.
            ].
        ].

        "
         if file exists, save original in a .sav file
        "
        fileName exists ifTrue:[
            self busyLabel:'saving existing %1' with:fileName.
            fileName copyTo:(fileName withSuffix:'.sav').
        ].

        [
            aStream := fileName newReadWriteStream.
            self busyLabel:'writing: %1' with:fileName name.

            classesToInitialize := OrderedCollection new.
            environment allClassesInCategory:currentClassCategory inOrderDo:[:aClass |
                aClass isPrivate ifFalse:[
                    (self listOfNamespaces includesIdentical:aClass nameSpace)
                    ifTrue:[
                        self busyLabel:'writing: %1' with:fileName name.
                        aClass isLoaded ifFalse:[
                            self warn:'cannot fileOut unloaded class: %1\\skipped.' with:aClass name allBold.
                        ] ifTrue:[
                            aClass fileOutOn:aStream withTimeStamp:true withInitialize:false.
                            (aClass theMetaclass includesSelector:#initialize) ifTrue:[
                                classesToInitialize add:aClass
                            ].
                            aStream cr.
                        ]
                    ]
                ]
            ].

            "/ all class-inits at the end
            "/ (this makes certain, that all classes have been loaded
            "/  before possibly used/needed in an initializer

            classesToInitialize do:[:aClass |
                aClass printClassNameOn:aStream. aStream nextPutAll:' initialize'.
                aStream nextPutChunkSeparator.
                aStream cr
            ].

            aStream close.
        ] on:FileStream openErrorSignal do:[:ex|
            self warn:'Cannot create: %1' with:fileName name
        ]
    ].
    self normalLabel.

    "Created: / 11.10.1997 / 16:38:29 / cg"
    "Modified: / 12.8.1998 / 11:04:11 / cg"
!

classCategoryFileOutBinaryEach
    "fileOut each class in the current category as binary bytecode."

    |mode|

    (currentClassCategory startsWith:$*) ifTrue:[
        self warn:(resources string:'Try a real category').
        ^ self
    ].

    mode := Dialog choose:(resources string:'Save including sources ?')
                   labels:(resources array:#('Cancel' 'Discard' 'By file reference' 'Include source'))
                   values:#(nil #discard #reference #keep)
                   default:#keep.

    mode isNil ifTrue:[^ self].

    self withWaitCursorDo:[
        self allClassesInCategory:currentClassCategory do:[:aClass |
            aClass isPrivate ifFalse:[
                (self listOfNamespaces includesIdentical:aClass nameSpace)
                ifTrue:[
                    self busyLabel:'Saving binary of: %1' with:aClass name.
                    Class fileOutErrorSignal handle:[:ex |
                        self warn:'Cannot create: %1' with:ex parameter.
                        self normalLabel.
                        ex return.
                    ] do:[
                        aClass binaryFileOutWithSourceMode:mode.
                    ]
                ]
            ]
        ].
        self normalLabel.
    ]

    "Created: / 25-01-1996 / 17:27:45 / cg"
    "Modified: / 29-08-2013 / 01:36:38 / cg"
!

classCategoryFileOutEach
    self classCategoryFileOutEachAsk:false.

    "Modified: / 7.8.1998 / 17:11:25 / cg"
!

classCategoryFileOutEachAsk:doAsk
    |fileBox dir dirName|

    (currentClassCategory startsWith:$*) ifTrue:[
        self warn:(resources string:'Try a real category').
        ^ self
    ].

    doAsk ifTrue:[
        fileBox := FileSelectionBox
                        title:(resources string:'fileOut %1 in:' with:currentClassCategory)
                        okText:(resources string:'FileOut')
                        abortText:(resources string:'Cancel')
                        action:[:fileName |dirName := fileName.].

        dir := FileSelectionBox lastFileSelectionDirectory.
        dir isNil ifTrue:[
            "
             this test allows a smalltalk to be built without Projects/ChangeSets
            "
            Project notNil ifTrue:[
                dir := Project currentProjectDirectory
            ]
        ].
        dir notNil ifTrue:[
            fileBox directory:dir.
        ].
        fileBox selectingDirectory:true.
        fileBox open.

        fileBox destroy.
        fileBox := nil.

        dirName isNil ifTrue:[
            ^ self
        ].
        FileSelectionBox lastFileSelectionDirectory:dirName.
    ] ifFalse:[
        "
         this test allows a smalltalk to be built without Projects/ChangeSets
        "
        Project notNil ifTrue:[
            dirName := Project currentProjectDirectory asFilename.
        ] ifFalse:[
            dirName := Filename currentDirectory
        ]
    ].
    self withWaitCursorDo:[
        self allClassesInCategory:currentClassCategory do:[:aClass |
            |fn|

            aClass isPrivate ifFalse:[
                (self listOfNamespaces includesIdentical:aClass nameSpace)
                ifTrue:[
                    self busyLabel:'saving: %1' with:aClass name.
                    Class fileOutErrorSignal handle:[:ex |
                        self warn:'cannot fileOut: %1\(%2)\\skipped.' with:(aClass name allBold) with:ex description.
                        self normalLabel.
                        ex return.
                    ] do:[
                        fn := (Smalltalk fileNameForClass:aClass) , '.st'.
                        aClass fileOutAs:(dirName asFilename constructString:fn).
                    ]
                ]
            ]
        ].
        self normalLabel.
    ]

    "Created: / 07-08-1998 / 17:10:59 / cg"
    "Modified: / 06-10-2006 / 16:17:09 / cg"
!

classCategoryFileOutEachIn
    self classCategoryFileOutEachAsk:true.

    "Created: / 7.8.1998 / 17:20:01 / cg"
!

classCategoryFindClass
    "find a class - and switch by default"

    self classCategoryFindClassOpen:false

    "Modified: 15.1.1997 / 22:55:20 / cg"
!

classCategoryFindClassOpen:doOpen
    "common code for both opening a new browser on a class and
     to search for a class in this browser"

    |box openButton title open okText okText2 className brwsr|

    open := doOpen.
    open ifTrue:[
        title := 'Class to browse:\(TAB to complete or use matchPattern)'.
        okText := 'Open'.
        okText2 := 'Find here'.
    ] ifFalse:[
        title := 'Class to find:\(TAB to complete or use matchPattern)'.
        okText := 'Find'.
        okText2 := 'Open new'.
    ].
    box := self 
                enterBoxForCodeSelectionTitle:(resources stringWithCRs:title)
                withList:(self class classHistory collect: [:histEntry| histEntry className ])
                okText:okText.
    box label:(resources string:'Browse or search class').
    openButton := Button label:(resources string:okText2).
    box addButton:openButton before:(box okButton).

    openButton action:[
       open := open not.
       box doAccept.
       box okPressed.
    ].

    box entryCompletionBlock:[:contents |
        |s what m|

        s := contents withoutSpaces.
        what := Smalltalk classnameCompletion:s inEnvironment:(environment ? Smalltalk).
        box contents:what first.
        (what at:2) size ~~ 1 ifTrue:[
            self beep
        ]
    ].
    box action:[:aString | className := aString].
    box open.

    className notNil ifTrue:[
        open ifTrue:[
            brwsr := SystemBrowser open.
            "/ brwsr topView waitUntilVisible.
        ] ifFalse:[
            brwsr := self
        ].
        brwsr switchToClassNameMatching:className.
    ]

    "Created: / 01-06-1996 / 16:03:15 / cg"
    "Modified: / 29-08-2013 / 12:18:58 / cg"
!

classCategoryFindMethod
    |box matchBlock|

    box := self 
                listBoxForCodeSelectionTitle:'Selector to find:\\(Tab for completion or use matchPattern)' withCRs 
                okText:'Find'.
    box label:(resources string:'Find method').

    matchBlock := [ 
                    |s l|

                    s := box contents.
                    s includesMatchCharacters ifTrue:[
                        l := Set new.

                        environment allMethodsWithSelectorDo:[:eachMethod :eachSelector |
                            (s match:eachSelector) ifTrue:[
                                l add:eachSelector.
                            ].
                        ].
                        box list:(l asOrderedCollection sort).
                        false.
                    ] ifFalse:[
                        true
                    ]
                  ].

    box entryCompletionBlock:[:contents |
        |s what m longest matching|

        box topView withWaitCursorDo:[
            s := contents withoutSpaces.
            s includesMatchCharacters ifTrue:[
                matchBlock value
            ] ifFalse:[
                what := Smalltalk selectorCompletion:s inEnvironment:(environment ? Smalltalk).
                longest := what first.
                matching := what last.
                box list:matching.
                box contents:longest.
                matching size ~~ 1 ifTrue:[
                    self beep
                ]
            ]
        ]
    ].
    box acceptCheck:matchBlock.

    [:restart |
        box action:[:aString | 
                        aString includesMatchCharacters ifFalse:[
                            self switchToAnyMethod:aString string.
                        ] ifTrue:[
                            restart value
                        ]
                    ].

        box open.
    ] valueWithRestart

    "Modified: / 25.1.2000 / 21:51:59 / cg"
!

classCategoryMenu
    <resource: #keyboard ( #Find #Cmdn) >
    <resource: #programMenu >

    |specialMenu m items subMenu|

    currentClassCategory notNil ifTrue:[
        items :=  #(
                    ('FileOut Each Binary...'    classCategoryFileOutBinaryEach      )
                    ('-'                         nil                                 )
                    ('Repository History...'     classCategoryRepositoryHistory      )
                    ('Validate Class Revisions'  classCategoryValidateClassRevisions )
                    ('-'                         nil                                 )
                    ('CheckIn Each...'           classCategoryCheckinEach            )
                    ('-'                         nil                                 )
                    ('Load from Repository...'   classCategoryLoadFromRepository     )
                   ).
    ] ifFalse:[
        items :=  #(
                    ('Repository History...'    classCategoryRepositoryHistory )
                    ('-'                         nil                            )
                    ('Load from Repository...'  classCategoryLoadFromRepository)
                   ).
    ].

    specialMenu := PopUpMenu 
                        itemList:items
                        resources:resources.

    (self hasSourceCodeManager) ifFalse:[
        specialMenu disableAll:#(classCategoryRepositoryHistory  
                                 classCategoryCheckinEach
                                 classCategoryValidateClassRevisions
                                 classCategoryLoadFromRepository
                                ).
    ].
    (currentClassCategory = '* hierarchy *'
    or:[currentClassCategory = '* obsolete *']) ifTrue:[
        specialMenu disableAll:#(classCategoryFileOutBinaryEach
                                 classCategoryCheckinEach
                                 classCategoryValidateClassRevisions
                                ).
    ].

    self isSimulatedEnvironment ifTrue:[
        specialMenu disableAll:#(classCategoryValidateClassRevisions classCategoryCheckinEach
                                 classCategoryLoadFromRepository classCategoryFileOutBinaryEach
                      )
    ].

    self sensor ctrlDown ifTrue:[
        ^ specialMenu
    ].

    currentClassCategory isNil ifTrue:[
        items := #(
"/                    ('namespace...'           namespaceDialog               )
"/                    ('-'                       nil                           )

                    ('Clone'                    browserClone                  )
                    ('Browse Class...'          browserOpenInClass            )
                    ('Browse Full Class Source' browserSpawnFullClass   )
                    ('Browse Class Extensions'  browserSpawnExtensions  )
                    ('-'                       nil                           )
                    ('Update'                  classCategoryUpdate           )
                    ('Find Class...'           classCategoryFindClass      #Find )
                    ('Find Method...'          classCategoryFindMethod       )
                    ('Visited History'         classHistoryMenu              )
                    ('Changed History'         changeHistoryMenu             )
                    ('-'                       nil                           )
                    ('New Class Category...'  classCategoryNewCategory    #Cmdn )
                    ('='                       nil                           )
                    ('More'                    otherMenu                   #Ctrl )
                   ).
    ] ifFalse:[
        items := #(
                    ('FileOut'                 classCategoryFileOut            )
                    ('FileOut As...'           classCategoryFileOutAs          )
                    ('FileOut Each'            classCategoryFileOutEach        )
                    ('FileOut Each In...'      classCategoryFileOutEachIn      )
                    ('PrintOut'                classCategoryPrintOut           )
                    ('PrintOut Protocol'       classCategoryPrintOutProtocol   )
                    ('-'                       nil                             )
"/                    ('namespace...'           namespaceDialog                 )
"/                    ('-'                       nil                             )
                    ('Clone'                   browserClone                  Cmdc )
                    ('Browse Class...'          browserOpenInClass            Cmdo )
                    ('SPAWN_CATEGORY'           classCategorySpawn              )
                    ('Browse Full Class Source' browserSpawnFullClass     )
                    ('Browse Class Extensions'  browserSpawnExtensions  )
                    ('-'                       nil                             )
                    ('Update'                  classCategoryUpdate             )
                    ('Find Class...'           classCategoryFindClass        Find )
                    ('Find Method...'          classCategoryFindMethod         )
                    ('Visited History'         classHistoryMenu                )
                    ('Changed History'         changeHistoryMenu               )
                    ('-'                       nil                             )
                    ('New Class Category...'   classCategoryNewCategory      Cmdn )
                    ('Rename...'               classCategoryRename             )
                    ('Remove...'               classCategoryRemove             )
                    ('='                       nil                             )
                    ('More'                    otherMenu                     Ctrl )
                   ).
    ].

    m := PopUpMenu 
                itemList:items
                resources:resources.

    m subMenuAt:#otherMenu put:specialMenu.
    m subMenuAt:#classHistoryMenu put:self classHistoryPopUpMenu.
    ((ChangeSet current size == 0) or:[(subMenu := self changeHistoryPopUpMenu) isNil]) ifTrue:[
        m disable:#changeHistoryMenu
    ] ifFalse:[
        m subMenuAt:#changeHistoryMenu put:subMenu.
    ].

    ((currentClassCategory = '* hierarchy *') 
    or:[currentClassCategory = '* obsolete *']) ifTrue:[
        m disableAll:#(classCategoryFileOut classCategoryFileOutAs classCategoryFileOutEach
                       classCategoryFileOutEachIn
                       classCategoryPrintOut classCategoryPrintOutProtocol      
                       classCategoryRename classCategoryRemove)
    ].
    (currentClassCategory = '* obsolete *') ifTrue:[
        m disableAll:#(classCategorySpawn browserSpawnFullClass)
    ].

    self isReadOnlyEnvironment ifTrue:[
        m disableAll:#(classCategoryRename classCategoryRemove classCategoryNewCategory changeHistoryMenu
                      )
    ].
    self isSimulatedEnvironment ifTrue:[
        m disableAll:#(
                       classCategoryUpdate browserSpawnFullClass
                       classCategorySpawn browserOpenInClass browserClone
                      )
    ].
    ^ m

    "Created: / 14.9.1995 / 10:50:17 / claus"
    "Modified: / 16.1.1998 / 17:16:28 / stefan"
    "Modified: / 7.8.1998 / 18:39:46 / cg"
!

classCategoryNewCategory
    |box|

    box := self 
                enterBoxTitle:'Name of new class category:' 
                okText:'Create'
                label:'Create category'.

    box action:[:aString |
        |categories|
        categories := classCategoryListView list.
        (categories includes:aString) ifFalse:[
            categories add:aString.
            categories sort.
            classCategoryListView setContents:categories.
        ].
        currentClassCategory := aString.
        classCategoryListView setSelectElement:aString.
        self changeCurrentClass:nil.
        actualClass := acceptClass := nil.
        self classCategorySelectionChanged
    ].
    box open

    "Modified: / 19.8.1996 / 18:25:41 / stefan"
    "Modified: / 10.4.1998 / 12:25:29 / cg"
!

classCategoryPrintOut
    |printStream|

    printStream := Printer new.

    environment allClassesInCategory:currentClassCategory inOrderDo:[:aClass |
        (self listOfNamespaces includesIdentical:aClass nameSpace)
        ifTrue:[
            aClass printOutOn:printStream.
        ]
    ].
    printStream close

    "Modified: 16.1.1997 / 20:22:23 / cg"
!

classCategoryPrintOutProtocol
    |printStream|

    printStream := Printer new.

    environment allClassesInCategory:currentClassCategory inOrderDo:[:aClass |
        (self listOfNamespaces includesIdentical:aClass nameSpace)
        ifTrue:[
            aClass printOutProtocolOn:printStream.
        ]
    ].
    printStream close

    "Modified: 16.1.1997 / 20:22:12 / cg"
!

classCategoryRemove
    "remove all classes in current category"

    |count overallCount t classesToRemove subclassesRemoved box t2|

    self checkClassCategorySelected ifFalse:[^ self].

    classesToRemove := IdentitySet new.

    self allClassesInSelectedNamespacesDo:[:aClass |
        aClass category = currentClassCategory ifTrue:[
            classesToRemove add:aClass
        ]
    ].
    subclassesRemoved := IdentitySet new.
    classesToRemove do:[:aClass |
        aClass allSubclassesDo:[:aSubclass |
            (classesToRemove includes:aSubclass) ifFalse:[
                (subclassesRemoved includes:aSubclass) ifFalse:[
                    subclassesRemoved add:aSubclass
                ]
            ]
        ]
    ].

    count := overallCount := classesToRemove size.
    t := resources 
            string:'Remove all classes in ''%1'' ?' 
            with:currentClassCategory allBold.

    count ~~ 0 ifTrue:[
       count == 1 ifTrue:[
           t2 := '(with %1 class)'
       ] ifFalse:[
           t2 := '(with %1 classes)'
       ].
       t := t , '\' , (resources string:t2 with:count printString)
    ].

    count := subclassesRemoved size.
    overallCount := overallCount + count.
    count ~~ 0 ifTrue:[
       count == 1 ifTrue:[
           t2 := '(and %1 subclass)'
       ] ifFalse:[
           t2 := '(and %1 subclasses)'
       ].
       t := t , '\' , (resources string:t2 with:count printString)
    ].

    t := t withCRs.

    box := YesNoBox 
               title:t
               yesText:(resources string:'Remove')
               noText:(resources string:'Cancel').
    box label:(resources string:'Remove category').

    overallCount ~~ 0 ifTrue:[
        "/ should we disable the returnDefault here ?
    ].

    box confirm ifTrue:[
        "after querying user - do really remove classes in list1 and list2"
        |keep idx oldPosition doRemoveThis yesToAll|

        yesToAll := false.
        keep := false.
        (subclassesRemoved asOrderedCollection , classesToRemove asOrderedCollection) 
        do:[:aClassToRemove |

            doRemoveThis := CheckForInstancesWhenRemovingClasses not
                            or:[yesToAll
                            or:[aClassToRemove hasInstances not]].

            doRemoveThis ifFalse:[
                doRemoveThis := Dialog
                            confirmWithCancel:(resources string:'%1 has instances - remove anyway ?' with:aClassToRemove name allBold) withCRs
                            labels:#('Cancel' 'No' 'Remove All' 'Remove')
                            values:#(nil false #removeAll true) 
                            default:4.
                doRemoveThis isNil ifTrue:[
                    ^ self
                ].
                doRemoveThis == #removeAll ifTrue:[
                    doRemoveThis := yesToAll := true.
                ]
            ].
            doRemoveThis ifTrue:[
                aClassToRemove removeFromSystem
            ] ifFalse:[
                keep := true.
            ]
        ].

        "/ self updateClassCategoryList.
        self updateClassCategoryListWithScroll:false.

        (classCategoryListView list includes:currentClassCategory) ifFalse:[
            currentClassCategory := nil.
        ].
        self classCategorySelectionChanged.
        
        self changeCurrentClass:nil.
"/        keep ifFalse:[
"/            idx := classCategoryListView list indexOf:currentClassCategory.
"/            currentClassCategory := nil.
"/            idx ~= 0 ifTrue:[
"/                classCategoryListView removeIndex:idx.
"/            ].
"/        ].
    ].
    box destroy

    "Modified: / 19.8.1996 / 23:22:35 / stefan"
    "Modified: / 12.10.2001 / 19:45:51 / cg"
!

classCategoryRename
    "launch an enterBox to rename current class category"

    |box|

    self checkClassCategorySelected ifFalse:[^ self].

    box := self 
                enterBoxTitle:(resources 
                                string:'Rename category ''%1'' to:' 
                                  with:currentClassCategory allBold) 
                okText:'Rename'
                label:'Rename category'.

    box initialText:currentClassCategory.
    box action:[:aString | self renameCurrentClassCategoryTo:aString].
    box open

    "Modified: / 12.10.2001 / 19:45:20 / cg"
!

classCategorySpawn
    "create a new SystemBrowser browsing current classCategory"

    currentClassCategory notNil ifTrue:[
        self withWaitCursorDo:[
            |brwsr|

            brwsr := SystemBrowser browseClassCategory:currentClassCategory.
            brwsr environment:environment
        ]
    ]

    "Modified: 18.8.1997 / 15:42:58 / cg"
!

classCategoryUpdate
    "update class category list and dependants"

    |oldClass oldClassName oldMethodCategory newClass|

    classCategoryListView notNil ifTrue:[
        self setListOfNamespaces.

        (oldClass := currentClass) notNil ifTrue:[
            oldClassName := currentClass name.
            (oldClassName endsWith:'-old') ifTrue:[
                oldClassName := oldClassName copyButLast:4 "copyTo:(oldClassName size - 4)"
            ]
        ].
        oldMethodCategory := currentMethodCategory.

        classCategoryListView setContents:(self listOfAllClassCategories).
        currentClassCategory notNil ifTrue:[
            classCategoryListView setSelectElement:currentClassCategory.
            self classCategorySelectionChanged.
            oldClassName notNil ifTrue:[
                classListView setSelectElement:oldClassName.
                oldClass isJavaClass ifTrue:[
                    newClass := (Java at:oldClassName).
                ] ifFalse:[
                    newClass := (environment at:oldClassName asSymbol).
                ].
                newClass isNil ifTrue:[
                    self warn:'oops - ' , oldClassName , ' is gone.'.
                ] ifFalse:[
                    self changeCurrentClass:newClass.
                    self classSelectionChanged.
                    oldMethodCategory notNil ifTrue:[
                        methodCategoryListView setSelectElement:oldMethodCategory.
                        currentMethodCategory := oldMethodCategory.
                        self methodCategorySelectionChanged
                    ]
                ]
            ]
        ].

        self updateNamespaceList
    ]

    "Modified: / 10.4.1998 / 12:25:38 / cg"
! !

!BrowserView methodsFor:'class category source administration'!

classCategoryCheckinEach
    (self checkSelectionChangeAllowedWithCompare:false) ifFalse:[^ self].

    self withWaitCursorDo:[
        |logInfo classes allSelected|

        allSelected := (currentClassCategory = '* all *'
                        or:[currentClassCategory = '* hierarchy *']).

        logInfo := SourceCodeManagerUtilities default
                        getCheckinInfoFor:(resources
                                             string:(allSelected ifTrue:['all classes'] ifFalse:[' any in classCategory ''%1'''])
                                             with:currentClassCategory)
                        initialAnswer:nil
                        withQuickOption:true.

        logInfo notNil ifTrue:[
            allSelected ifTrue:[
                classes := self allClasses
            ] ifFalse:[
                classes := self allClassesInCategory:currentClassCategory.
            ].
            classes := classes reject:[:eachClass | eachClass isPrivate].
            logInfo quickCheckIn ifTrue:[
                classes := classes select:[:aClass | ChangeSet current includesChangeForClassOrMetaclass:aClass].
                classes isEmpty ifTrue:[^ self ].
            ].
            SourceCodeManagerUtilities checkinClasses:classes withInfo:logInfo.
        ].
        self normalLabel.
    ]

    "Created: / 23-11-1995 / 11:41:38 / cg"
    "Modified: / 15-06-1996 / 00:25:58 / stefan"
    "Modified: / 12-03-2012 / 12:56:25 / cg"
!

classCategoryLoadFromRepository
    "mini-browser into the repository, showing modules & packages.
     Allows load of a containers contents"

    |bindings
     moduleList packageList containerList fileNameList
     moduleSelection packageSelection containerSelection
     loadEnabled loadAction dialog|

    loadAction := [:dummy |
            |aStream module directory container list packageID|

            module := moduleSelection value.
            directory := packageSelection value.
            list := containerSelection value.

            packageID := module , ':' , directory.

            dialog window withWaitCursorDo:[
                list do:[:container |
                    "/
                    "/ special: if its a 'loadAll' file,
                    "/ or a project-file, extract all from the repository
                    "/ and perform some special load action.
                    "/
                    ((container = 'loadAll') 
                    or:[container asLowercase asFilename hasSuffix:'prj']) ifTrue:[
                        SourceCodeManager
                            checkoutModule:module 
                            directory:directory 
                            andDo:[:tempDir |
                                |oldPath wasLazy|

                                self activityNotification:'loading ' , container , '...'.
                                (container = 'loadAll') ifTrue:[
                                    [
                                        Class withoutUpdatingChangesDo:[
                                            oldPath := Smalltalk systemPath.
                                            Smalltalk systemPath:(oldPath copy addFirst:tempDir pathName; yourself).
                                            wasLazy := Compiler compileLazy:false.
                                            Class packageQuerySignal answer:packageID do:[
                                                (tempDir construct:container) fileIn.
                                            ]
                                        ].
                                    ] ensure:[
                                        Compiler compileLazy:wasLazy.
                                        Smalltalk systemPath:oldPath.
                                    ]
                                ] ifFalse:[
                                    self error:'unimplemented: project-loading' mayProceed:true.
                                ]
                            ]
                    ] ifFalse:[
                        aStream := SourceCodeManager 
                                streamForClass:nil 
                                fileName:container 
                                revision:#newest
                                directory:directory
                                module:module
                                cache:false.

                        self activityNotification:'loading ' , container , '...'.

                        aStream isNil ifTrue:[
                            self warn:'could not load ' , container , ' from repository'.
                        ] ifFalse:[
                            self busyLabel:'loading from %1' with:(module , '/' , directory , '/' , container).

                            Class withoutUpdatingChangesDo:[
                                [
                                    Class packageQuerySignal answer:packageID do:[
                                        aStream fileIn.
                                    ]
                                ] ensure:[
                                    aStream close.
                                    self normalLabel.
                                    Smalltalk changed.
                                ].
                            ].
                        ]
                    ]
                ].
                self activityNotification:nil
            ]
    ].

    bindings := IdentityDictionary new.
    bindings at:#moduleSelection put:(moduleSelection := nil asValue).
    bindings at:#packageSelection put:(packageSelection := nil asValue).
    bindings at:#containerSelection put:(containerSelection := #() asValue).

    bindings at:#moduleList put:(moduleList := nil asValue).
    bindings at:#packageList put:(packageList := nil asValue).
    bindings at:#containerList put:(containerList := nil asValue).

    bindings at:#loadEnabled put:(loadEnabled := false asValue).

    bindings at:#load                   put:[loadAction value:nil].
    bindings at:#containerDoubleClicked put:loadAction.

    packageSelection 
        onChangeEvaluate:[
             |list|

             dialog window withWaitCursorDo:[
                 list := SourceCodeManager 
                            getExistingContainersInModule:(moduleSelection value)
                            directory:(packageSelection value).

                 list := list select:[:nm | |lcName f|
                                            lcName := nm asLowercase.
                                            ((f := lcName asFilename) hasSuffix:'st')
                                            or:[false "/ (f hasSuffix:'prj')
                                            or:[lcName = 'loadall']]
                                     ].
                 fileNameList := list.
                 list := list collect:[:nm | |lcName f|

                                             lcName := nm asLowercase.
                                             ((f := lcName asFilename) hasSuffix:'st') ifTrue:[
                                                nm asFilename nameWithoutSuffix
                                             ] ifFalse:[
                                                nm
                                             ]
                                      ].
                 containerList value:list.
"/
"/ do not auto-select the first item
"/                 list notEmpty ifTrue:[
"/                    containerSelection value:(Array with:list first)
"/                 ]
             ].
             self activityNotification:nil
           ].

    moduleSelection 
        onChangeEvaluate:[
             |list|

             dialog window withWaitCursorDo:[
                 list := SourceCodeManager getExistingDirectoriesInModule:(moduleSelection value).
                 packageList value:list.
"/
"/ do not auto-select the first item
"/                 list notEmpty ifTrue:[
"/                     packageSelection value:list first
"/                 ]
             ].
             self activityNotification:nil
           ].

    containerSelection
        onChangeEvaluate:[
             loadEnabled value:(containerSelection value notEmpty).
           ].

    self withWaitCursorDo:[
        |list|

        moduleList value:(list := SourceCodeManager getExistingModules).
"/        list notEmpty ifTrue:[
"/            "/ if there is a module named after the user, use that one.
"/            (list includes:(m := OperatingSystem getLoginName)) ifFalse:[
"/                "/ if there is a module named 'stx', use that one.
"/                (list includes:'stx') ifTrue:[
"/                    m := 'stx'
"/                ] ifFalse:[
"/                    m := list first
"/                ]
"/             ].
"/             moduleSelection setValue:m.
"/             list := SourceCodeManager getExistingPackagesInModule:m.
"/             packageList value:list.
"/        ].
    ].

    self activityNotification:nil.

    dialog := SimpleDialog new.

    ActivityNotification handle:[:ex |
        |msg|

        msg := 'Load from repository'.
        ex description size > 0 ifTrue:[
            msg := msg , ' - ' , ex description
        ].
        dialog window topView label:msg.
        ex proceed.
    ] do:[
        dialog
            openFor:self
            spec:self class repositoryLoadSpec 
            withBindings:bindings
    ]

    "Modified: / 07-11-2006 / 13:58:29 / cg"
!

classCategoryRepositoryHistory
    (self checkSelectionChangeAllowedWithCompare:false) ifFalse:[^ self].

    self withWaitCursorDo:[
        |timeGoal repositoryFilter aStream box y component 
         timeGoalListPop repositoryFilterPop|

        box := Dialog new.
        box addTextLabel:(resources string:'Repository change report') adjust:#left.
        box addVerticalSpace:20.

        timeGoal := 'yesterday' asValue. 

        y := box yPosition.
        component := box addTextLabel:(resources string:'List changes since (mm/dd):') adjust:#right.
        component width:0.5; borderWidth:0.
        box yPosition:y.
        timeGoalListPop := box addComboBoxOn:timeGoal tabable:true.
        timeGoalListPop width:0.5; left:0.5; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.

        timeGoalListPop list:#('yesterday'
                               'a week ago'
                               'a month ago'
                               'a year ago'
                               'all'
                              ).

        y := box yPosition.
        component := box addTextLabel:(resources string:'For repository (empty for all):') adjust:#right.
        component width:0.5; borderWidth:0.
        box yPosition:y.
        repositoryFilterPop := box addComboBoxOn:repositoryFilter tabable:true.
        repositoryFilterPop width:0.5; left:0.5; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.
        repositoryFilterPop list:#(
                                "/ to do - get list of available repositories ...
                                'stx'
                                'exept'
                                ''
                               ).

        box addAbortAndOkButtons.
        box open.

        box accepted ifTrue:[
            repositoryFilter := repositoryFilter value.
            repositoryFilter size == 0 
                ifTrue:[repositoryFilter := nil]
                ifFalse:[repositoryFilter := Array with:repositoryFilter].

            timeGoal := timeGoal value.

"/        timeGoal := Dialog 
"/                         request:'list changed repository containers since (mm/dd):
"/
"/You can also specify the date as 
"/''yesterday'', ''a week ago'' or ''a month ago''
"/
"/'
"/                         initialAnswer:'yesterday'  
"/                         onCancel:nil.
"/
"/        timeGoal notNil ifTrue:[


            self busyLabel:'extracting history ...' with:nil.

            aStream := WriteStream on:(String new:200).
            Processor activeProcess 
                withPriority:Processor activePriority-1 to:Processor activePriority
            do:[
                SourceCodeManager notNil ifTrue:[
                    SourceCodeManager
                        writeHistoryLogSince:timeGoal 
                        filterSTSources:true 
                        filterUser:nil 
                        filterRepository:repositoryFilter
                        to:aStream.
                ] ifFalse:[
                    aStream nextPutLine:'no history available (no SourceCodeManagement installed)'
                ].
            ].
            codeView contents:(aStream contents).
            codeView modified:false.
            self clearAcceptAction.
            self clearExplainAction.
            methodListView notNil ifTrue:[
                methodListView setSelection:nil
            ].
            aspect := nil.      
            self normalLabel
        ].
    ]

    "Created: / 23.11.1995 / 11:41:38 / cg"
    "Modified: / 10.2.2000 / 14:13:46 / cg"
!

classCategoryValidateClassRevisions
    "for all classes, ask the sourceCodeManager for the most recent version
     and compare this to the actual version. Send mismatch info to the Transcript.
     Use this, to find classes, which need to be reloaded from the repository."

    self withWaitCursorDo:[
        |logMessage classes repVersion clsVersion binVersion
         count unloadedCount badCount cat needCheckIn|

        cat := currentClassCategory.
        (cat = '* hierarchy *') ifTrue:[
            cat := '* all *'
        ].

        classes := self listOfAllClassesInCategory:cat names:false.
        classes isNil ifTrue:[
            Transcript showCR:'no classes to validate'.
            ^ self
        ].

        count := unloadedCount := badCount := needCheckIn := 0.

        Transcript cr.
        Transcript showCR:'-------------------------------------------------'.
        Transcript showCR:'checking class revisions vs. repository ...'.
        Transcript cr.

        classes do:[:aClass |
            |clsName msg sourceCodeManager repSource currentSource aStream|

            count := count + 1.

            "/ ignore autoloaded and private classes here
                
            clsName := aClass name.

            aClass isLoaded ifFalse:[
                unloadedCount := unloadedCount + 1.
                (currentClassCategory ~= '* all *'
                and:[currentClassCategory ~= '* hierarchy *']) ifTrue:[
                    msg := '?? ''' , clsName , ''' is not loaded - skipped check'.
                ]
            ] ifTrue:[
                ((aClass isRealNameSpace not)
                and:[aClass topOwningClass isNil]) ifTrue:[
                
"/                    self busyLabel:'validating %1 ...' with:aClass name.
                
                    sourceCodeManager := SourceCodeManagerUtilities sourceCodeManagerFor:aClass.
                    sourceCodeManager isNil ifTrue:[
                        msg := '?? ''' , clsName , ''' has no sourceCodeManager - skipped check'.
                    ] ifFalse:[
                        repVersion := sourceCodeManager newestRevisionOf:aClass.
                        repVersion isNil ifTrue:[
                            msg := '-- ' , clsName 
                                    , ' not in repository'
                        ] ifFalse:[
                            clsVersion := aClass revision.
                            binVersion := aClass binaryRevision.

                            clsName := aClass name.
                            msg := nil.

                            clsVersion ~= repVersion ifTrue:[
                                badCount := badCount + 1.
                                msg := '** ' , clsName 
                                        , ' is not up-to-date (this: '
                                        , clsVersion printString
                                        , ' repository: '
                                        , repVersion printString
                                        , ').'.
                                msg := msg allBold.
                            ] ifFalse:[
                                clsVersion ~= binVersion ifTrue:[
                                    binVersion notNil ifTrue:[
                                        msg := clsName , ' up-to-date (but should be stc-recompiled)'
                                    ]
                                ] ifFalse:[
    "/                              msg := clsName , ' is up-to-date.'
                                ].

                                "/ compare the sources;
                                "/ to find classes which need a checkin.

                                aStream := sourceCodeManager getMostRecentSourceStreamForClassNamed:aClass name.
                                repSource := aStream contents asString.
                                aStream close.

                                aStream := String writeStream.
                                Method flushSourceStreamCache.
                                aClass fileOutOn:aStream withTimeStamp:false.
                                currentSource := aStream contents asString.

                                repSource ~= currentSource ifTrue:[
                                    msg := '-- ' , clsName , ' should be checked into the repository'.
                                    needCheckIn := needCheckIn + 1.
                                ].
                            ].
                        ].
                    ].
                ].
            ].
            msg notNil ifTrue:[
                Transcript showCR:msg
            ].
        ].
        Transcript cr.
        Transcript showCR:'----------------------------------------------------------'.
        Transcript showCR:('%1 classes / %2 unloaded / %3 need checkout / %4 need checkin.'
                           bindWith:count with:unloadedCount with:badCount with:needCheckIn).
        Transcript showCR:'----------------------------------------------------------'.

        self normalLabel.
    ]

    "Modified: / 15-06-1996 / 00:25:58 / stefan"
    "Created: / 29-10-1996 / 13:21:08 / cg"
    "Modified: / 10-11-2006 / 17:08:13 / cg"
    "Modified (format): / 29-09-2011 / 16:09:52 / cg"
! !

!BrowserView methodsFor:'class category stuff'!

checkClassCategorySelected
    currentClassCategory isNil ifTrue:[
	self warn:'select a class category first'.
	^ false
    ].
    ^ true
!

classCategorySelection:lineNr
    "user clicked on a class category line - show classes.
     If switching to hierarchy or all, keep current selections"

    |newCategory oldClass oldName classIndex list|

    newCategory := classCategoryListView selectionValue.
    (newCategory = '* all *'
     or:[newCategory = '* hierarchy *'
     or:[currentClass notNil and:[newCategory = currentClass category]]]
    ) ifTrue:[
        "switch to all or hierarchy:
         remember current class and reselect it        
         after showing the updated class list
        "
        oldClass := currentClass
    ].
    currentClassCategory := newCategory.
    oldClass isNil ifTrue:[
        self classCategorySelectionChanged
    ] ifFalse:[
        oldName := oldClass name.
        self withWaitCursorDo:[
            self updateClassList
        ].
        "stupid - search for class name in (indented) list"
        list := classListView list.
        list notNil ifTrue:[
            classIndex := list findFirst:[:elem | elem withoutSpaces = oldName asString].
        ] ifFalse:[
            classIndex := 0
        ].
        classIndex ~~ 0 ifTrue:[
            classListView setSelection:classIndex.
            self changeCurrentClass:(environment at:(oldName asSymbol))
        ] ifFalse:[
            self normalLabel.
        ]
    ]

    "Modified: / 16.1.1998 / 17:12:24 / stefan"
    "Modified: / 10.4.1998 / 12:25:34 / cg"
!

classCategorySelectionChanged
    "class category has changed - update dependent views"

    self withWaitCursorDo:[
        self changeCurrentClass:nil.
        aspect := nil.

        actualClass := acceptClass := nil.
        currentMethodCategory := nil.
        self releaseMethod.

        self updateClassList.
        self updateMethodCategoryList.
        self updateMethodList.
        self updateCodeView.

        self clearExplainAction.
        self clearAcceptAction.

        (currentClassCategory = '* removed *') ifTrue:[
            codeView contents:'these classes have been removed (i.e. they are no longer accessible as globals),
but there are still referenced instances of them around.

They will vanish later (be garbage collected) when the instances are no longer referenced.
'
        ]

    ]

    "Modified: / 10.2.2000 / 14:13:52 / cg"
!

listOfAllClassCategories
    "return a list of all class categories"

    |nameSpaceList newList cat allNameSpaces|

    newList := Set new.

    currentNamespace = '* all *' ifTrue:[
        nameSpaceList := Array with:environment.
        allNameSpaces := true.
    ] ifFalse:[
        nameSpaceList := self listOfNamespaces.
        allNameSpaces := false.
    ].

    nameSpaceList do:[:aNamespace |
        aNamespace allClassesDo:[:aClass |
            aClass isMeta ifFalse:[        
                aClass isRealNameSpace ifFalse:[
                    (allNameSpaces or:[aClass nameSpace == aNamespace]) ifTrue:[
                        cat := aClass category.
                        cat isNil ifTrue:[
                            cat := '* no category *'
                        ].
                        cat ~= 'obsolete' ifTrue:[
                            newList add:cat
                        ]
                    ]
                ]
            ]
        ]
    ].

    newList notEmpty ifTrue:[
        newList add:'* all *'; add:'* hierarchy *'.
    ].

    ^ newList asOrderedCollection sort.

    "Modified: / 10-11-2006 / 17:09:16 / cg"
!

renameCurrentClassCategoryTo:aString
    "helper - do the rename"

    |any categories|

    currentClassCategory notNil ifTrue:[
        any := false.

        self allClassesInSelectedNamespacesDo:[:aClass |
            aClass category = currentClassCategory ifTrue:[
                aClass setCategory:aString.
                any := true
            ]
        ].
        any ifFalse:[
            categories := classCategoryListView list.
            categories remove:currentClassCategory.
            categories add:aString.
            categories sort.
            classCategoryListView setContents:categories.
            currentClassCategory := aString.
            classCategoryListView setSelectElement:aString.
        ] ifTrue:[
            currentClassCategory := aString.
            self updateClassCategoryList.
            self updateClassListWithScroll:false
        ]
    ]

    "Modified: 16.1.1997 / 20:20:38 / cg"
!

switchToAnyMethod:aSelectorString
    "find all implementors of aSelectorString, and present a list
     to choose from. When an entry is selected, switch to that class/selector.
     This allows for quickly moving around in the system."

    |classes sel box theClassName|

    classes := OrderedCollection new.
    (sel := aSelectorString asSymbolIfInterned) notNil ifTrue:[
        environment allClassesDo:[:aClass |
            (aClass includesSelector:sel) ifTrue:[
                classes add:aClass.
            ].
            (aClass theMetaclass includesSelector:sel) ifTrue:[
                classes add:aClass theMetaclass.
            ].
        ]
    ].
    classes size == 0 ifTrue:[
        SystemBrowser showNoneFound.
        ^ self
    ].

    classes size > 1 ifTrue:[
        box := ListSelectionBox 
                    title:(resources string:'searching for #%1 method.\\in which class ?\\(Tab for completion or select)' with:aSelectorString) withCRs.
        box label:'find method'.
        box okText:(resources string:'show').
        box list:(classes collect:[:aClass | aClass name]) asSortedCollection.
        box action:[:aString | theClassName := aString].
        box entryCompletionBlock:[:contents |
            |s l what m names|

            s := contents withoutSpaces.
            s size == 0 ifTrue:[
                l := classes
            ] ifFalse:[
                l := classes select:[:cls | cls name startsWith:s].
            ].
            l size == 0 ifTrue:[
                l := classes select:[:cls | cls name asLowercase startsWith:s asLowercase].
            ].
            l size > 0 ifTrue:[    
                box list:(names := l collect:[:aClass | aClass name]) asSortedCollection.
                box contents:(names longestCommonPrefix). "/ l first name.
                l size ~~ 1 ifTrue:[
                    self beep
                ]
            ]
        ].
        box open.
    ] ifFalse:[
        theClassName := classes first name
    ].

    theClassName notNil ifTrue:[
        self switchToClassNamed:theClassName. 
        self updateMethodCategoryList.
        self switchToMethodNamed:aSelectorString.
    ].

    "Modified: / 1.9.1995 / 01:39:58 / claus"
    "Modified: / 25.1.2000 / 20:43:35 / cg"
!

updateClassCategoryList
    self updateClassCategoryListWithScroll:true.

    "Modified: 8.1.1997 / 10:58:06 / cg"
!

updateClassCategoryListWithScroll:scroll
    |oldClassCategory oldClass oldMethodCategory oldMethod
     oldSelector newCategoryList|

    classMethodListView notNil ifTrue:[ ^ self ].

    oldClassCategory := currentClassCategory.
    oldClass := currentClass.
    oldMethodCategory := currentMethodCategory.
    oldMethod := currentMethod.
    oldMethod notNil ifTrue:[
        oldSelector := currentSelector
    ].

    classCategoryListView notNil ifTrue:[
        newCategoryList := self listOfAllClassCategories.
        newCategoryList = classCategoryListView list ifFalse:[
            scroll ifTrue:[
                classCategoryListView contents:newCategoryList
            ] ifFalse:[
                classCategoryListView setContents:newCategoryList
            ]
        ]
    ].

    oldClassCategory notNil ifTrue:[
        classCategoryListView notNil ifTrue:[
            classCategoryListView setSelectElement:oldClassCategory
        ]
    ].
    classListView notNil ifTrue:[
        oldClass notNil ifTrue:[
            classListView multipleSelectOk ifTrue:[
                classListView setSelectElement:(Array with:oldClass name)
            ] ifFalse:[
                classListView setSelectElement:(oldClass name)
            ]
        ]
    ].
    oldMethodCategory notNil ifTrue:[
        methodCategoryListView notNil ifTrue:[
            methodCategoryListView setSelectElement:oldMethodCategory
        ].
    ].
    oldSelector notNil ifTrue:[
        methodListView notNil ifTrue:[
            methodListView setSelectElement:oldSelector
        ].
    ]

    "Modified: / 27.7.1998 / 10:56:50 / cg"
! !

!BrowserView methodsFor:'class history'!

changeHistoryMenu
    "returns a popup menu to navigate
     to the last few changes"

    <resource: #programMenu >

    |labels changes hist menu n nMax|

    changes := ChangeSet current.
    hist := OrderedCollection new.
    labels := Set new.

    menu := Menu new receiver:self.
    n := 0.
    nMax := self class classHistoryMaxSize.
    changes reverseDo:[:aChange |
        |item|

        n < nMax ifTrue:[
            aChange isMethodChange ifTrue:[
                item := aChange printString.
                (labels includes:item) ifFalse:[
                    labels add:item.
                    n := n + 1.

                    menu addItem:
                            (MenuItem new 
                                label: item; 
                                itemValue: #switchBackToMessageNamed: argument: item; 
                                activeHelpKey: #historyMenuItem).
                ]
            ].
        ].
    ].
    n = 0 ifTrue:[
        ^ nil
    ].
    ^ menu

    "Modified: / 09-09-2012 / 13:08:03 / cg"
!

changeHistoryPopUpMenu
    "returns a popup menu to navigate
     to the last few changes"

    <resource: #programMenu >

    |labels changes hist n nMax|

    changes := ChangeSet current.
    hist := OrderedCollection new.
    labels := OrderedCollection new.

    n := 0.
    nMax := self class classHistoryMaxSize.
    changes reverseDo:[:aChange |
        |item|

        n < nMax ifTrue:[
            aChange isMethodChange ifTrue:[
                item := aChange printString.
                (labels includes:item) ifFalse:[
                    labels add:item.
                    n := n + 1.
                ]
            ].
        ].
    ].
    n = 0 ifTrue:[
        ^ nil
    ].
    ^ PopUpMenu 
        labels:labels
        selector:#switchBackToMessageNamed:
        args:labels
        receiver:self

    "Modified: / 10.2.2000 / 14:05:34 / cg"
!

classHistoryMenu
    "returns a menu to navigate to
     the last visited classes"

    <resource: #programMenu >

    |menu classHistory|

    self class checkClassHistory.

    classHistory := self class classHistory.
    classHistory isEmpty ifTrue: [ ^ nil ].

    menu := Menu new receiver:self.
    classHistory do:[:histEntry |
        menu addItem:(MenuItem new 
            label: histEntry className; 
            itemValue: #switchBackToMessageNamed: argument: histEntry className).
    ].    

"/    menu addSeparator.
"/    menu addItem:(MenuItem new 
"/        label: (resources string:'empty history'); 
"/        value: #emptyClassHistory:).
"/
    ^ menu

    "Modified: / 09-09-2012 / 13:08:13 / cg"
!

classHistoryPopUpMenu
    "returns a popup menu to navigate to
     the last visited classes"

    <resource: #programMenu >

    |labels selectors args classHistory|

    self class checkClassHistory.

    classHistory := self class classHistory.
    classHistory isEmpty ifTrue: [
        ^ nil
    ].

    labels := classHistory collect: [:histEntry| histEntry className ].
    selectors := Array new: classHistory size.
    selectors atAllPut:#switchBackToMessageNamed:.
    selectors := selectors asOrderedCollection.
    args := labels. "/ classHistory collect: [:histEntry| histEntry selector ].

    ^ PopUpMenu 
        labels:labels
        selectors:selectors
        args:args
        receiver:self.

    "Modified: / 21.5.1998 / 15:42:10 / cg"
!

emptyClassHistory
    "removes all class history entries"

    SystemBrowser emptyClassHistory
!

loadFromMessage:aMessageString
    "switch to the class and selector specified by aMessage,
     which has the form: '<className> {class} <selector>'
     Backward compatibility - should no longer be used."

    self switchBackToMessageNamed:aMessageString

!

switchBackToMessageNamed: aMessage
    "switch to the class and selector specified by aMessage,
     which has the form: '<className> {class} <selector>'"

    |selector nameSpace words meta savedHistory ns|

    words := aMessage asCollectionOfWords.

    savedHistory := self class classHistory copy.

    self switchToClassNamed:(words first).
    self classSelectionChanged.

    (ns := actualClass nameSpace ? Smalltalk) ~~ Smalltalk 
        ifTrue:  [nameSpace := ns name]
        ifFalse: [nameSpace := '* all *'].

    namespaceList model value ~= nameSpace ifTrue:[
        namespaceList model value:nameSpace.    
    ].

    meta := (aMessage includesString: ' class ').
    meta not ~~ showInstance ifTrue:[
        self instanceProtocol:meta not.
        self classSelectionChanged.
    ].

    (words size > 1
    and:[(words last) ~= 'class']) ifTrue:[
        selector := words last asSymbolIfInterned.
        (selector notNil and:[actualClass includesSelector:selector])
        ifTrue:[
            self switchToMethodNamed: selector.
        ]
    ].

    self class classHistory:savedHistory.
! !

!BrowserView methodsFor:'class list menu'!

classClassInstVars
    "show class instance variables in codeView and setup accept-action
     for a class-instvar-definition change"

    self doClassMenu:[:currentClass |
        |s|

        s := WriteStream on:''.
        currentClass class fileOutClassInstVarDefinitionOn:s withNameSpace:true.
        codeView contents:(s contents); modified:false.
        codeModified := false.

        self setAcceptActionForClassInstVars.
        self clearExplainAction.

        methodListView notNil ifTrue:[
            methodListView setSelection:nil
        ].
        aspect := #classInstVars.
        self normalLabel
    ]

    "Modified: / 10.2.2000 / 14:12:32 / cg"
!

classComment
    "show the classes comment in the codeView.
     Also, set accept action to change the comment."

    self classShowFrom:#comment set:#comment: aspect:#comment 
!

classDefinition
    "show class definition in View and setup accept-action for
     a class-definition change.
     Extract documentation either from a documentation method or
     from the comment - not a biggy, but beginners will like
     it when exploring the system."

    currentClass isNil ifTrue:[
        ^ self
    ].

    self doClassMenu:[:currentClass |
        |m commentOrNil cls aStream isComment src highlighter|

        aStream := TextStream on:(String new:200).

        cls := acceptClass ? currentClass.
        cls := cls theNonMetaclass.

        (cls isRealNameSpace) ifTrue:[
            cls fileOutDefinitionOn:aStream
        ] ifFalse:[

            "/
            "/ here, show it with a nameSpace pragma
            "/ and prefer short names.
            "/
            cls
                basicFileOutDefinitionOn:aStream 
                withNameSpace:true
                withPackage:false.

            cls isLoaded ifTrue:[
                "/ show the definition now...
                src := aStream contents.
                codeView contents:src.

                "/ ...but continue fetching with the documentation,
                "/ which may take longer, if the source must be fetched
                "/ from the repository.

                "
                 add documentation as a comment, if there is any
                "
                commentOrNil := cls commentOrDocumentationString.
                isComment := (commentOrNil = cls comment).

                commentOrNil notNil ifTrue:[
                    commentOrNil := commentOrNil asStringCollection withoutLeadingAndTrailingBlankLines asString
                ].
            ].
            cls isJavaClass ifFalse:[
                aStream cr; cr; cr; cr; cr.
                aStream emphasis:(UserPreferences current commentEmphasisAndColor).
                commentOrNil isNil ifTrue:[
                    aStream nextPut:$" ; cr; nextPutLine:' no comment or documentation method found'.
                ] ifFalse:[
                    aStream nextPut:$" ; cr; nextPutLine:' Documentation:'.
                    aStream cr; nextPutLine:commentOrNil; cr.
                    aStream nextPutLine:' Notice: '.
                    aStream nextPutAll:'   the above text has been extracted from the classes '.
                    aStream nextPutLine:(isComment ifTrue:['comment.'] ifFalse:['documentation method.']).
                    aStream nextPutLine:'   Any change in it will be lost if you ''accept'' here.'.
                    aStream nextPutAll:'   To change the '.
                    aStream nextPutAll:(isComment ifTrue:['comment'] ifFalse:['documentation']).
                    aStream nextPutAll:', switch to the '.
                    aStream nextPutAll:(isComment ifTrue:['comment'] ifFalse:['documentation method']).
                    aStream nextPutLine:' and ''accept'' any changes there.'.
                ].
                aStream nextPut:$".
                aStream emphasis:nil.
            ]
        ].

        src := aStream contents.
        UserPreferences current syntaxColoring ifTrue:[
            highlighter := cls syntaxHighlighterClass.
            highlighter notNil ifTrue:[
                src := highlighter formatExpression:src in:nil.
            ]
        ].

        codeView contents:src.
        codeView modified:false.
        codeModified := false.

        self setAcceptActionForClass.

"/        currentClass isNamespace ifTrue:[
"/            codeView acceptAction:nil.
"/        ] ifFalse:[
"/            codeView acceptAction:[:theCode |
"/                |ns|
"/
"/                currentClass notNil ifTrue:[
"/                    ns := currentClass nameSpace
"/                ] ifFalse:[
"/                    ns := nil
"/                ].
"/            
"/                codeView cursor:Cursor execute.
"/
"/                Class nameSpaceQuerySignal handle:[:ex |
"/                    ns isNil ifTrue:[
"/                        ex reject
"/                    ].
"/                    ex proceedWith:ns
"/                ] do:[
"/                    Object abortSignal catch:[
"/
"/                        Class nameSpaceQuerySignal answer:Smalltalk
"/                        do:[
"/                            (Compiler evaluate:theCode asString notifying:codeView compile:false)
"/                            isBehavior ifTrue:[
"/                                codeView modified:false.
"/                                codeModified := false.
"/                                self classCategoryUpdate.
"/                                self updateClassListWithScroll:false.
"/                            ]
"/                        ]
"/                    ].
"/                ].
"/                codeView cursor:Cursor normal.
"/            ].
"/        ].
        self clearExplainAction.

        methodListView notNil ifTrue:[
            methodListView setSelection:nil
        ].
        aspect := #definition.
        self normalLabel
    ]

    "Modified: / 10-11-2006 / 17:08:33 / cg"
!

classDerivedInstancesInspect
    "inspect the current classes derived instances"

    self
        classInspectObjectsReturnedBy:[currentClass allSubInstances] 
        ifNone:[self warn:'no direct or derived instances'. ^ self]

    "Created: / 24-02-1996 / 16:12:14 / cg"
    "Modified: / 20-04-2005 / 11:20:26 / cg"
!

classDocumentation
    "show classes documentation (i.e. open doc-View on it)"

    self generateClassDocumentationThenDo:[:text |
        |v|

        v := HTMLDocumentView
                openFullOnText:text 
                inDirectory:(Smalltalk getSystemFileName:'doc/online/english/classDoc').
        v nameSpaceForExecution:(currentClass nameSpace).
    ]

    "Created: 18.5.1996 / 12:12:20 / cg"
    "Modified: 17.6.1997 / 13:32:40 / cg"
!

classDocumentationAs
    "as for a fileName & save a classes documentation html doc into it"

    |fileBox dir saveName|

    fileBox := FileSelectionBox
                    title:(resources string:'Save HTML doc of ''%1'' as:' with:currentClass name)
                    okText:(resources string:'Save')
                    abortText:(resources string:'Cancel')
                    action:[:fileName | saveName := fileName].
    fileBox initialText:((Smalltalk fileNameForClass:currentClass),'.html').
    dir := FileSelectionBox lastFileSelectionDirectory.
    dir notNil ifTrue:[
        fileBox directory:dir.
    ].
    fileBox open.
    fileBox destroy.
    saveName isNil ifTrue:[
        ^ self
    ].
    saveName isEmpty ifTrue:[
        self warn:'bad name given'.
        ^ self
    ].
    FileSelectionBox lastFileSelectionDirectory:(saveName asFilename directoryName).

    self classDocumentationToFile:saveName

    "Modified: / 06-10-2006 / 16:17:00 / cg"
!

classDocumentationToFile:aFilename
    "save a classes documentation html doc into a file"

    self generateClassDocumentationThenDo:[:text |
        |f|

        f := aFilename asFilename writeStream.
        f nextPutAll:text asString.
        f close.
    ]
!

classFileOut
    "fileOut the current class.
     Catch errors (sure, you like to know if it failed) and
     warn if any)"

    self classFileOutAsk:false

    "Modified: 16.4.1997 / 20:55:13 / cg"
!

classFileOutAs
    "fileOut the current class, asking for a filename."

    self classFileOutAsk:true

    "Modified: 16.4.1997 / 20:55:31 / cg"
!

classFileOutAsk:ask
    "fileOut the current class, possibly asking for a filename.
     Catch errors (sure, you like to know if it failed) and
     warn if any)"

    self doClassMenu:[:currentClass |
        |msg fileBox saveName dir|

        currentClass isPrivate ifTrue:[
            self warn:'You must fileOut the owning class: ' , currentClass owningClass name
        ] ifFalse:[
            ask ifTrue:[
                fileBox := FileSelectionBox
                                title:(resources string:'fileOut %1 as:' with:currentClass name)
                                okText:(resources string:'FileOut')
                                abortText:(resources string:'Cancel')
                                action:[:fileName | saveName := fileName].
                fileBox initialText:((Smalltalk fileNameForClass:currentClass), '.st').
                dir := FileSelectionBox lastFileSelectionDirectory.
                dir notNil ifTrue:[
                    fileBox directory:dir.
                ].
                fileBox open.
                fileBox destroy.
                saveName isNil ifTrue:[
                    ^ self
                ].
                saveName isEmpty ifTrue:[
                    self warn:'bad name given'.
                    ^ self
                ].
                FileSelectionBox lastFileSelectionDirectory:(saveName asFilename directoryName).
            ].

            self busyLabel:'saving %1' with:currentClass name.
            Class fileOutErrorSignal handle:[:ex |
                self warn:'cannot fileOut: %1\(%2)' with:currentClass name with:ex description.
                self normalLabel.
                ex return.
            ] do:[
                saveName notNil ifTrue:[
                    currentClass fileOutAs:saveName.
                ] ifFalse:[
                    currentClass fileOut.
                ]
            ].
        ].
        self normalLabel.
    ]

    "Created: / 16-04-1997 / 20:55:01 / cg"
    "Modified: / 06-10-2006 / 16:16:52 / cg"
!

classFileOutBinary
    "fileOut the current class as binary bytecode."

    self classFileOutBinaryAsk:false

    "Modified: / 29.12.1998 / 21:42:15 / cg"
!

classFileOutBinaryAs
    "fileOut the current class as binary bytecode; ask for a fileName."

    self classFileOutBinaryAsk:true

    "Created: / 29.12.1998 / 21:42:27 / cg"
!

classFileOutBinaryAsk:ask
    "fileOut the current class as binary bytecode."

    |mode fileBox saveName dir|

    mode := Dialog choose:(resources string:'Save including sources ?')
                   labels:(resources array:#('Cancel' 'Discard' 'By file Reference' 'Include Source'))
                   values:#(nil #discard #reference #keep)
                   default:#keep.

    mode isNil ifTrue:[^ self].   "/ cancelled

    self doClassMenu:[:currentClass |
        |msg|

        currentClass isPrivate ifTrue:[
            self warn:'You must fileOut the owning class: ' , currentClass owningClass name
        ] ifFalse:[
            ask ifTrue:[
                fileBox := FileSelectionBox
                                title:(resources string:'binary fileOut %1 as:' with:currentClass name)
                                okText:(resources string:'fileOut')
                                abortText:(resources string:'cancel')
                                action:[:fileName | saveName := fileName].
                fileBox initialText:((Smalltalk fileNameForClass:currentClass), '.cls').
                dir := FileSelectionBox lastFileSelectionDirectory.
                dir notNil ifTrue:[
                    fileBox directory:dir.
                ].
                fileBox open.
                fileBox destroy.
                saveName isNil ifTrue:[
                    ^ self
                ].
                saveName isEmpty ifTrue:[
                    self warn:'bad name given'.
                    ^ self
                ].
                FileSelectionBox lastFileSelectionDirectory:(saveName asFilename directoryName).
            ].

            self busyLabel:'saving binary of %1' with:currentClass name.
            Class fileOutErrorSignal handle:[:ex |
                self warn:'cannot create: %1\(%2)' with:ex parameter with:ex description.
                self normalLabel.
                ex return.
            ] do:[
                saveName notNil ifTrue:[
                    currentClass binaryFileOutWithSourceMode:mode as:saveName.
                ] ifFalse:[
                    currentClass binaryFileOutWithSourceMode:mode
                ]
            ].
        ].
        self normalLabel.
    ]

    "Created: / 29-12-1998 / 21:35:13 / cg"
    "Modified: / 06-10-2006 / 16:16:47 / cg"
!

classHierarchy
    "show current classes hierarchy in codeView"

    self doClassMenu:[:currentClass |
        |aStream|

        aStream := WriteStream on:(String new:200).
        actualClass printHierarchyOn:aStream.
        codeView contents:(aStream contents); modified:false.
        codeModified := false.
        self clearAcceptAction.
        self clearExplainAction.
        methodListView notNil ifTrue:[
            methodListView setSelection:nil
        ].
        aspect := #hierarchy. 
        self normalLabel
    ]

    "Modified: / 10.2.2000 / 14:14:04 / cg"
!

classInspect
    "inspect the current class"

    self checkClassSelected ifFalse:[^ self].

    currentClass inspect.
!

classInspectObjectsReturnedBy:aBlock ifNone:warnBlock
    "inspect the current classes derived instances"

    |insts numInsts inspectedObject|

    self checkClassSelected ifFalse:[^ self].

    insts := aBlock value.

    numInsts := insts size.
    numInsts == 0 ifTrue:[
        warnBlock value.
        ^ self
    ].
    numInsts == 1 ifTrue:[
        inspectedObject := insts first.
    ] ifFalse:[
        inspectedObject := insts
    ].
    inspectedObject inspect

    "Created: / 24-02-1996 / 16:12:14 / cg"
    "Modified: / 20-04-2005 / 11:21:18 / cg"
!

classInstancesInspect
    "inspect the current classes instances"

    self
        classInspectObjectsReturnedBy:[currentClass allInstances] 
        ifNone:[self warn:'no instances'. ^ self]

    "Created: / 24-02-1996 / 16:12:14 / cg"
    "Modified: / 20-04-2005 / 11:21:08 / cg"
!

classLoad
    "load an autoloaded class"

    |nm nameShown|

    self checkClassSelected ifFalse:[^ self].
    nm := currentClass name.
    nameShown := self displayedClassNameOf:currentClass.

    Autoload autoloadFailedSignal handle:[:ex |
        self warn:(resources string:'Autoload of %1 failed.

Check your source directory for a file named ''%2.st'' 
and/or the abbreviation file for its (correct) shortened name.') 
                with:nm with:(Smalltalk fileNameForClass:currentClass).
        ex return.
    ] do:[
        self withWaitCursorDo:[
            self busyLabel:'loading %1 ...' with:currentClass name.

            lockUpdates := true.
            [
                currentClass autoload.

                currentClass := actualClass := nil.
                "/ reselect the current class
                showInstance ifFalse:[
                    nameShown := nameShown , ' class'
                ].
                self switchToClassNamed:nameShown.
                self classSelectionChanged.
"/                self classDefinition
            ] ensure:[
                lockUpdates := false.
                self normalLabel.
            ].
        ]
    ]

    "Modified: / 06-10-2006 / 16:16:34 / cg"
!

classMakePrivate
    "change a class from public to private;
     ask for the owners class, check if a private class with the same name exists,
     before doing this."

    |ownerName owner|

    ownerName := Dialog request:(resources string:'Name of owner class:').
    ownerName size == 0 ifTrue:[
        "/ cancelled
        ^ self
    ].
    owner := Smalltalk classNamed:ownerName.
    owner isNil ifTrue:[
        self warn:(resources string:'No class named ''%1'' found - try again.' with:ownerName).
        ^ self
    ].

    (owner privateClassesAt:currentClass nameWithoutPrefix) notNil ifTrue:[
        self warn:(resources 
                        string:'A private class named ''%1'' already exists in ''%2''.\\Please remove/rename that one first,\or rename the public class ''%1'' here\and try again.'
                        with:currentClass nameWithoutPrefix
                        with:ownerName)
                    withCRs.
        ^ self
    ].

    currentClass makePrivateIn:owner

    "Modified: / 29.5.1998 / 19:03:19 / cg"
!

classMakePublic
    "change a class from private to public;
     check if a public class with the same name exists,
     before doing this."

    |ns baseName|

    baseName := currentClass nameWithoutPrefix.
    (ns := currentClass topOwningClass nameSpace) ~~ Smalltalk ifTrue:[
        ns := Dialog confirmWithCancel:(resources string:'Make public in ''Smalltalk'' or in its nameSpace ''%1'' ?' with:ns name)
                labels:(Array with:'Cancel' with:'In Smalltalk' with:'In ' , ns name)
                values:(Array with:nil with:Smalltalk with:ns)
                default:3.
        ns isNil ifTrue:[^ self].
    ].

    (ns classNamed:baseName) notNil ifTrue:[
        self warn:(resources
                        string:'A public class named ''%1'' already exists in %2.\\Please remove/rename that one first,\or rename the private class ''%1'' here\and try again.'
                        with:baseName with:ns name) withCRs.
        ^ self
    ].

    currentClass makePublicIn:ns

    "Modified: 3.7.1997 / 13:26:21 / cg"
!

classMenu
    "sent by classListView to ask for the menu"

    <resource: #keyboard ( #Cmdl #Cmdn #Cmdd) >
    <resource: #programMenu >

    |specialMenu items m newClassMenu spawnMenu spawnItems|

    currentClass isNil ifTrue:[
        items :=  #(
                       ('Load from Repository...' classLoadRevision)
                    ).
    ] ifFalse:[
        items :=  #(
                       ('FileOut Binary'               classFileOutBinary           )
                       ('FileOut Binary As...'         classFileOutBinaryAs         )
                       ('-'                            nil                          )
                       ('Inspect Class'                classInspect                 )
                       ('Inspect Instances'            classInstancesInspect        )
                       ('Inspect Derived Instances'    classDerivedInstancesInspect        )
                       ('-'                            nil                          )
                       ('Make Private Class In...'     classMakePrivate             )
                       ('Make Public Class'            classMakePublic              )
                       ('-'                            nil                          )
                       ('Primitive Definitions'        classPrimitiveDefinitions    )
                       ('Primitive Variables'          classPrimitiveVariables      )
                       ('Primitive Functions'          classPrimitiveFunctions      )
                       ('-'                            nil                          )
                       ('Package...'                   classModifyPackage         )
                       ('Source Container...'          classModifyContainer         )
                       ('Remove Source Container...'   classRemoveContainer         )
                       ('-'                            nil                          )
                       ('Revision Log'                 classRevisionInfo            )
                       ('Compare with Repository...'   classCompareWithRepository   )
                       ('-'                            nil                          )
                       ('Check into Source Repository...' classCheckin                 )
                       ('Load from Repository...'         classLoadRevision            )
                    ).
    ].

    specialMenu := PopUpMenu itemList:items resources:resources.

    currentClass notNil ifTrue:[
        currentClass sourceCodeManager isNil ifTrue:[
            specialMenu disableAll:#(classModifyContainer classRemoveContainer
                                     classRevisionInfo 
                                     classLoadRevision classCheckin 
                                     classCompareWithRepository).
        ].
        currentClass isPrivate ifTrue:[
            specialMenu disableAll:#(
                                     classFileOutBinary
                                     classMakePrivate
                                     classModifyPackage
                                     classModifyContainer 
                                     classRemoveContainer
                                     classRevisionInfo 
                                     classLoadRevision classCheckin
                                     classCompareWithRepository
                                     classPrimitiveDefinitions
                                     classPrimitiveVariables
                                     classPrimitiveFunctions).
        ] ifFalse:[
            specialMenu disableAll:#(
                                     classMakePublic
                                    )
        ]
    ] ifFalse:[
        SourceCodeManager isNil ifTrue:[
            specialMenu disableAll:#(classLoadNewRevision)
        ]
    ].

    (currentClass notNil
    and:[currentClass isLoaded not]) ifTrue:[
        specialMenu disableAll:#(
                                     classInstancesInspect
                                     classDerivedInstancesInspect
                                     classFileOutBinary
                                     classFileOutBinaryAs
                                     classMakePrivate
                                     classMakePublic
                                     "/ classModifyPackage
                                     classModifyContainer 
                                     classRemoveContainer
                                     classRevisionInfo 
                                     classLoadRevision 
                                     classCheckin
                                     classCompareWithRepository
                                     classPrimitiveDefinitions
                                     classPrimitiveVariables
                                     classPrimitiveFunctions).
    ].

    self environment ~~ Smalltalk ifTrue:[
        specialMenu disableAll:#(classMakePrivate classMakePublic classModifyContainer classRemoveContainer
                                 classRevisionInfo classLoadRevision classCheckin classModifyPackage
                                 classLoadNewRevision classFileOutBinary classFileOutBinaryAs
                      )
    ].

    self sensor ctrlDown ifTrue:[
        ^ specialMenu
    ].

    currentClass isNil ifTrue:[
        items :=    #(
                       ('New Class'             classNewClass       Cmdn)
                       ('New Application'       classNewApplication)
                       ('New Dialog'            classNewDialog)
                     ).
    ] ifFalse:[
        currentClass isLoaded ifFalse:[
            items :=    #(
                           ('HTML Documentation'            classDocumentation     )
                           ('Save HTML Documentation As...' classDocumentationAs   )
                           ('-'                          nil                    )
                           ('References to Class'        classRefs              )
                           ('-'                          nil                    )
                           ('New Class'                  classNewClass          Cmdn )
                           ('New Application'            classNewApplication    )
                           ('New Dialog'                 classNewDialog         )
                           ('Remove...'                  classRemove            )
                           ('-'                          nil                    )
                           ('Load'                       classLoad              Cmdl )
                         ).
        ] ifTrue:[
            fullProtocol ifTrue:[
                items :=    #(
                               ('Hierarchy'                 classHierarchy             )
                               ('Definition'                classDefinition            )
                               ('HTML Documentation'             classDocumentation    Cmdd )
                               ('Save HTML Documentation As...'  classDocumentationAs       )
                               ('Comment'                   classComment               )
                               ('Class Instvars'            classClassInstVars         )
                             ).
            ] ifFalse:[
                items :=    #(
                               ('FileOut'                   classFileOut          )
                               ('FileOut As...'             classFileOutAs        )
                               ('PrintOut'                  classPrintOut         )
                               ('PrintOut Protocol'         classPrintOutProtocol )
                               ('-'                         nil                   )
                              ).

                classCategoryListView isNil ifTrue:[
                    "/ a hierarchy or subclass-browser.
                    items := items , #(
                               ('Browse'                    browserClone   )
                              ).
                ].
                items := items , #(
                               ('Spawn...'                 spawnMenu             )
                               ('-'                         nil                  )
                              ).

                spawnItems := #(               
                                    ('Class'           classSpawn             )
                                    ('Full Protocol'   classSpawnFullProtocol )
                                    ('Hierarchy'       classSpawnHierarchy    )
                                    ('Subclasses'      classSpawnSubclasses   )
                               ).
                spawnMenu := PopUpMenu 
                                itemList:spawnItems
                                resources:resources.

                fullClass ifFalse:[
                    items := items , #(
                               ('Hierarchy'                 classHierarchy            )
                               ('Definition'                classDefinition           )
                               ('HTML Documentation'             classDocumentation   Cmdd )
                               ('Save HTML Documentation As...'  classDocumentationAs      )
                               ('Comment'                   classComment              )
                               ('Class Instvars'            classClassInstVars        )
                               ('-'                         nil                       )
                              ).
                ].

                items := items , #(
                               ('References to Class'   classRefs   )
                               ('-'                     nil         )
                               ('New'                   newClassMenu)
                              ).

                newClassMenu := PopUpMenu 
                            itemList:#(
                                        ('Class'         classNewClass          Cmdn )
                                        ('Subclass'      classNewSubclass            )
                                        ('Private Class' classNewPrivateClass        )
                                        ('Application'   classNewApplication         )
                                        ('Dialog'        classNewDialog              )
                                      )
                            resources:resources.

                items := items , #(
                               ('Rename...'  classRename )
                               ('Remove...'  classRemove )
                              ).

                currentClass wasAutoloaded ifTrue:[
                    items := items , #(
                               ('Unload'  classUnload)
                              ).
                ]
            ]
        ].
    ].

    items := items , #(
                          ('='          nil             )
                          ('More'       otherMenu   Ctrl)
                        ).

    m := PopUpMenu itemList:items resources:resources.

    newClassMenu notNil ifTrue:[
        m subMenuAt:#newClassMenu put:newClassMenu.
    ].
    spawnMenu notNil ifTrue:[
        m subMenuAt:#spawnMenu put:spawnMenu.
    ].

    (currentClass notNil and:[currentClass isPrivate]) ifTrue:[
        m disableAll:#(
                       classFileOut
                       classFileOutAs
                      )
    ].

    m subMenuAt:#otherMenu put:specialMenu.

    self isReadOnlyEnvironment ifTrue:[
        m disableAll:#(classUnload classRename classRemove classNewDialog classNewApplication
                       classNewPrivateClass classNewSubclass classNewClass newClassMenu
                      )
    ].
    self isSimulatedEnvironment ifTrue:[
        m disableAll:#(classUnload 
                       classRefs classDocumentation classDocumentationAs classSpawn
                      )
    ].
    ^ m

    "Modified: / 22-01-2011 / 15:25:05 / cg"
!

classNewApplication
    "create a class-definition prototype for an application in codeview"

    self 
        classClassDefinitionTemplateFor:ApplicationModel 
        in:currentClassCategory 
        nameSpace:false 
        private:false.

    aspect := nil.

    "Modified: / 26-07-2012 / 23:09:17 / cg"
!

classNewClass
    "create a class-definition prototype in codeview"

    |theClass cls|

    currentNamespace == JAVA ifTrue:[
        theClass := Java at:'java.lang.Object'
    ] ifFalse:[
        theClass := Object.
    ].
    currentClass notNil ifTrue:[
        (cls := currentClass superclass) notNil ifTrue:[
            theClass := cls 
        ]
    ].
    self 
        classClassDefinitionTemplateFor:theClass 
        in:currentClassCategory 
        nameSpace:false 
        private:false.

    aspect := nil.

    "Modified: / 26-07-2012 / 23:09:12 / cg"
!

classNewDialog
    "create a class-definition prototype for a dialog in codeview"

    self 
        classClassDefinitionTemplateFor:SimpleDialog 
        in:currentClassCategory 
        nameSpace:false 
        private:false.

    aspect := nil.

    "Modified: / 26-07-2012 / 23:09:08 / cg"
!

classNewPrivateClass
    "create a class-definition prototype in codeview"

    self 
        classClassDefinitionTemplateFor:Object 
        in:nil 
        nameSpace:false 
        private:true.
    aspect := nil.

    "Created: / 11-10-1996 / 16:01:20 / cg"
    "Modified: / 26-07-2012 / 23:09:04 / cg"
!

classNewSubclass
    "create a subclass-definition prototype in codeview"

    self doClassMenu:[:currentClass |
        self classClassDefinitionTemplateFor:currentClass 
                                          in:(currentClass category)
                                          nameSpace:false
                                          private:false.
        aspect := nil
    ]

    "Modified: / 26-07-2012 / 23:08:58 / cg"
!

classPrimitiveDefinitions
    "show the classes primitiveDefinition in the codeView.
     Also, set accept action to change it."

    self classShowFrom:#primitiveDefinitionsStringOrDefault 
                   set:#primitiveDefinitions: 
                aspect:#primitiveDefinitions 
!

classPrimitiveFunctions
    "show the classes primitiveFunctions in the codeView.
     Also, set accept action to change it."

    self classShowFrom:#primitiveFunctionsStringOrDefault 
                   set:#primitiveFunctions: 
                aspect:#primitiveFunctions 
!

classPrimitiveVariables
    "show the classes primitiveVariables in the codeView.
     Also, set accept action to change it."

    self classShowFrom:#primitiveVariablesStringOrDefault 
                   set:#primitiveVariables: 
                aspect:#primitiveVariables 
!

classPrintOut
    self classPrintOutWith:#printOutOn:
!

classPrintOutFullProtocol
    self classPrintOutWith:#printOutFullProtocolOn:
!

classPrintOutProtocol
    self classPrintOutWith:#printOutProtocolOn:
!

classPrintOutWith:aSelector
    self doClassMenu:[:currentClass |
        |printStream|

        printStream := Printer new.
        currentClass perform:aSelector with:printStream.
        printStream close
    ]
!

classProtocols
     ^ self
!

classRefs
    self doClassMenu:[:currentClass |
        self withWaitCursorDo:[
            |any1 any2 nm msg|

            any1 :=true.
            any2 :=false.
            nm := currentClass name asSymbol.
            msg := SystemBrowser classResources string:'users of: %1' with:nm.
            SystemBrowser 
                browseReferendsOf:nm 
                title:msg
                ifNone:[any1 := false].

            "/ for namespace-classes, also search for accesses without prefix
            (nm := currentClass nameWithoutPrefix) ~= currentClass name ifTrue:[
                any2 :=true.
                SystemBrowser 
                    browseReferendsOf:nm asSymbol
                    title:(SystemBrowser classResources string:'users of: %1' with:nm)
                    ifNone:[any2 := false].
            ].
            (any1 or:[any2]) ifFalse:[
                SystemBrowser showNoneFound:msg.
            ]
        ]
    ]

    "Created: 23.11.1995 / 14:11:43 / cg"
    "Modified: 18.8.1997 / 15:43:47 / cg"
!

classRemove
    "user requested remove of current class and all subclasses -
     count subclasses and let user confirm removal."

    |count t box|

    currentClass notNil ifTrue:[
        count := currentClass allSubclasses size.
        t := 'Remove class %1'.
        count ~~ 0 ifTrue:[
           t := t , '\(with %2 subclass'.
           count ~~ 1 ifTrue:[
                t := t , 'es'
           ].
           t := (t , ')') 
        ].
        t := t , ' ?'.
        t := (resources string:t with:currentClass name allBold with:count) withCRs.

        box := YesNoBox 
                   title:t
                   yesText:(resources string:'Remove')
                   noText:(resources string:'Abort').
        box label:(resources string:'Remove class').

        box confirm ifTrue:[
            "after querying user - do really remove current class
             and all subclasses
            "
            self doClassMenu:[:currentClass |
                |didRemove|

                didRemove := false.

                "
                 query ?
                "
                currentClass allSubclassesDo:[:aSubClass |
                    (CheckForInstancesWhenRemovingClasses not
                    or:[aSubClass hasInstances not
                    or:[self confirm:(resources string:'''%1'' has instances - remove anyway ?' with:aSubClass name)]])
                        ifTrue:[
                            aSubClass removeFromSystem
                    ]
                ].
                (CheckForInstancesWhenRemovingClasses not
                or:[currentClass hasInstances not
                or:[self confirm:(resources string:'''%1'' has instances - remove anyway ?' with:currentClass name)]])
                    ifTrue:[
                        didRemove := true.
                        currentClass removeFromSystem.
                ].

                didRemove ifTrue:[
                    self changeCurrentClass:nil.
                    Smalltalk changed.
                    self updateClassList.

                    "if it was the last in its category, update class category list"

"/                    classListView numberOfLines == 0 ifTrue:[
"/                        self updateClassCategoryListWithScroll:false
"/                    ].

                    methodCategoryListView notNil ifTrue:[methodCategoryListView contents:nil].
                    methodListView notNil ifTrue:[methodListView contents:nil].
                    codeView contents:nil.
                    codeView modified:false.
                    codeModified := false.
                ]
            ]
        ].
        box destroy.
    ]

    "Modified: / 12.10.2001 / 19:46:34 / cg"
!

classRename
    "launch an enterBox for new name and query user"

    |box|

    self checkClassSelected ifFalse:[^ self].
    box := self 
                enterBoxTitle:(resources 
                                string:'Rename %1 to:' 
                                with:currentClass name allBold) 
                okText:'Rename'
                label:'Rename class'.

    box initialText:(currentClass name).
    box action:[:aString | self renameCurrentClassTo:aString].
    box open

    "Modified: / 12.10.2001 / 19:46:54 / cg"
!

classShowFrom:getSelector set:setSelector aspect:aspectSymbol
    "common helper for comment, primitive-stuff etc.
     show the string returned from the classes getSelector-method,
     Set acceptaction to change it via setSelector."

    self doClassMenu:[:currentClass |
        |text|

        text := currentClass perform:getSelector.
        codeView contents:text; modified:false.
        codeModified := false.

        codeView acceptAction:[:theCode |
            AbortOperationRequest catch:[
                lockUpdates := true.
                currentClass perform:setSelector with:theCode asString.
                codeView modified:false.
                codeModified := false.
            ].
            lockUpdates := false.
        ].
        self clearExplainAction.

        methodListView notNil ifTrue:[
            methodListView setSelection:nil
        ].
        aspect := aspectSymbol.
        self normalLabel
    ]

    "Modified: / 16.11.2001 / 17:37:35 / cg"
!

classSpawn
    "create a new SystemBrowser browsing current class,
     or if there is a selection, spawn a browser on the selected class
     even a class/selector pair can be specified."

    self doClassMenuWithSelection:[:cls :sel |
        |browser|

        cls isMeta ifTrue:[
            self listOfNamespaces do:[:aNamespace |
                aNamespace allClassesDo:[:aClass |
                    aClass theMetaclass == cls ifTrue:[
                        browser := SystemBrowser browseClass:aClass.
                        browser instanceProtocol:false.
                        sel notNil ifTrue:[
                            browser switchToMethodNamed:sel
                        ].
                        ^ self
                    ].
                ].
            ].
            self warn:'oops, no class for this metaclass'.
            ^ self
        ].
        browser := SystemBrowser browseClass:cls. 
        browser environment:environment.
        cls hasMethods ifFalse:[
            browser instanceProtocol:false.
        ].
        sel notNil ifTrue:[
            browser switchToMethodNamed:sel
        ].
    ]

    "
     select 'Smalltalk allClassesDo:' and use spawn from the class menu
     select 'Smalltalk'               and use spawn from the class menu
    "

    "Modified: 20.12.1996 / 15:41:16 / cg"
!

classSpawnFullProtocol
    "create a new browser, browsing current classes full protocol"

    self doClassMenuWithSelection:[:cls :sel |  |brwsr|
        brwsr := SystemBrowser browseFullClassProtocol:cls.
        brwsr environment:environment
    ]
!

classSpawnHierarchy
    "create a new HierarchyBrowser browsing current class"

    self doClassMenuWithSelection:[:cls :sel | |brwsr|
        brwsr := SystemBrowser browseClassHierarchy:cls.
        brwsr environment:environment
    ]
!

classSpawnSubclasses
    "create a new browser browsing current class's subclasses"

    self doClassMenuWithSelection:[:cls :sel |
        |subs brwsr|

        subs := OrderedCollection new.
        self classHierarchyOf:cls withAutoloaded:false do:[:aClass :lvl |
            subs add:(String new:lvl*2) , aClass name
        ].
"/        subs := cls allSubclasses.
        (subs notNil and:[subs size ~~ 0]) ifTrue:[
            brwsr := SystemBrowser browseClasses:subs 
                                   label:('subclasses of ' , cls name)
                                   sort:false.
            brwsr environment:environment
        ]
    ]

    "Modified: 4.1.1997 / 13:35:55 / cg"
!

classUnload
    "unload an autoloaded class"

    |nm|

    self checkClassSelected ifFalse:[^ self].
    nm := currentClass name.
    currentClass unload.
    self switchToClassNamed:nm.
    self classSelectionChanged.

    "Modified: / 9.4.1998 / 13:59:07 / cg"
!

classUses
    "a powerful tool, when trying to learn more about where
     a class is used. This one searches all uses of a class,
     and shows a list of uses - try it and like it"

    self doClassMenu:[:currentClass |
	self withSearchCursorDo:[
	    SystemBrowser browseUsesOf:currentClass
	]
    ]

    "Created: 23.11.1995 / 14:11:47 / cg"
!

doClassMenuWithSelection:aBlock
    "a helper - if there is a selection, which represents a classes name,
     evaluate aBlock, passing that class and optional selector as arguments.
     Otherwise, check if a class is selected and evaluate aBlock with the
     current class."

    |string words clsName cls sel isMeta|

    string := codeView selection.
    string notNil ifTrue:[
        self extractClassAndSelectorFromSelectionInto:[:c :s :m |
            clsName := c.
            sel := s.
            isMeta := m.
        ].
        clsName isNil ifTrue:[
            string := string asString withoutSeparators.
            words := string asCollectionOfWords.
            words notEmpty ifTrue:[
                clsName := words first.
                (clsName endsWith:' class') ifTrue:[
                    isMeta := true.
                    clsName := clsName copyButLast:6
                ] ifFalse:[
                    isMeta := false
                ].
                sel := Parser selectorInExpression:string.
            ]
        ].
        clsName notNil ifTrue:[
            (cls := environment classNamed:clsName) notNil ifTrue:[
                isMeta ifTrue:[
                    cls := cls theMetaclass
                ].
                self withWaitCursorDo:[
                    aBlock value:cls value:sel.
                ].
                ^ self
            ] ifFalse:[
                self warn:'no class named: %1 - spawning current' with:clsName
            ]
        ].
    ].

    classMethodListView notNil ifTrue:[
        sel := classMethodListView selectionValue.
        sel notNil ifTrue:[
            sel := self selectorFromClassMethodString:sel string
        ]
    ].
    self doClassMenu:[:currentClass | aBlock value:currentClass value:sel]

    "Modified: 17.6.1996 / 16:51:49 / stefan"
    "Modified: 18.8.1997 / 15:44:01 / cg"
!

generateClassDocumentationThenDo:aBlock
    "helper"

    self doClassMenu:[:currentClass |
        Autoload autoloadFailedSignal handle:[:ex |
            self warn:'autoload failed.

Check your source directory and/or 
the abbreviation file for the classes (correct) shortened name.'.
            ex return.
        ] do:[
            |text|

            text := HTMLDocGenerator htmlDocOf:currentClass.
            text notNil ifTrue:[
                aBlock value:text.
            ]
        ]
    ]

    "Created: 18.5.1996 / 12:12:20 / cg"
    "Modified: 17.6.1997 / 13:32:40 / cg"
! !

!BrowserView methodsFor:'class list source administration'!

classCheckin
    "check a class into the source repository"

    self doClassMenu:[:currentClass |
        currentClass isLoaded ifFalse:[
            self warn:'cannot checkin unloaded classes.'.
            ^ self.
        ].
        SourceCodeManagerUtilities checkinClass:currentClass withInfo:nil
    ].

    "Created: 23.11.1995 / 11:41:38 / cg"
    "Modified: 15.4.1996 / 17:07:07 / cg"
!

classCompareWithRepository
    "open a diff-textView comparing the current (in-image) version
     with the some version found in the repository."

    |info mod|

    currentClass isLoaded ifFalse:[
        self warn:'cannot compare unloaded classes.'.
        ^ self.
    ].

    self doClassMenu:[:currentClass |
        |aStream comparedSource currentSource v rev revString thisRevString mgr
         nm msg rev2 newestRev 
         containerModule containerPackage containerFile rslt|

        nm := currentClass name.
        mgr := SourceCodeManagerUtilities sourceCodeManagerFor:currentClass.

        rev := currentClass binaryRevision.
        rev2 := currentClass revision.
        rev isNil ifTrue:[
            rev := rev2
        ].
        rev isNil ifTrue:[
            "/
            "/ class not in repository - allow compare against any other containers newest contents
            "/
            self normalLabel.

            containerModule := lastModule ? Project current repositoryModule.
            containerPackage := lastPackage ? Project current package.
            rslt := SourceCodeManagerUtilities default
                askForContainer:(resources string:'The class seems to have no repository information.\\Do you want to compare it against an existing containers contents ?')
                title:'Container to compare' note:nil 
                initialModule:containerModule 
                initialPackage:containerPackage 
                initialFileName:(currentClass name , '.st')
                forNewContainer:false.
            rslt isNil ifTrue:[
                "/ canel
                ^ self
            ].
            containerModule := lastModule := rslt at:#module.
            containerPackage := lastPackage := rslt at:#package.
            containerFile := rslt at:#fileName.
        ] ifFalse:[
            "/
            "/ class in repository - ask for revision
            "/
            newestRev := mgr newestRevisionOf:currentClass.

            msg := resources string:'compare to revision: (empty for newest)'.
            rev notNil ifTrue:[
                msg := msg , '\\' , (resources string:'Current %1 is based upon rev %2.'
                                               with:nm allBold with:rev).
                (rev2 notNil and:[rev2 ~= rev]) ifTrue:[
                    msg := msg , '\' , (resources string:'And has been checked into the repository as %1.' with:rev2)
                ]
            ].
            newestRev notNil ifTrue:[
                msg := msg , '\' , (resources string:'Newest in reporitory is %1.' with:newestRev)
            ].

            self normalLabel.
            rev := SourceCodeManagerUtilities default
                        askForExistingRevision:msg 
                        title:'Compare with repository' 
                        class:currentClass

            "/ rev := Dialog request:msg withCRs onCancel:nil.
        ].

        (rev notNil or:[containerFile notNil]) ifTrue:[
            rev notNil ifTrue:[
                rev withoutSpaces isEmpty ifTrue:[
                    msg := 'extracting newest %1 (' , (newestRev ? '???') , ')'.
                    "/ aStream := mgr getMostRecentSourceStreamForClassNamed:nm.
                    aStream := mgr getSourceStreamFor:currentClass revision:newestRev.
                    revString := '(newest: ' , (newestRev ? '???') , ')'.
                ] ifFalse:[
                    msg := 'extracting previous %1'.
                    aStream := mgr getSourceStreamFor:currentClass revision:rev.
                    revString := rev
                ].
            ] ifFalse:[
                msg := 'extracting newest version from ' , containerModule , '/' , containerPackage, '/' , containerFile.
                aStream := mgr streamForClass:nil fileName:containerFile revision:#newest directory:containerPackage module:containerModule cache:false.
                revString := '???'
            ].
            self busyLabel:msg with:nm.

            aStream isNil ifTrue:[
                info := mgr sourceInfoOfClass:currentClass.
                info notNil ifTrue:[
                    mod := info at:#module ifAbsent:'??'.
                ].
                self warn:(resources string:'Could not extract source from repository (source module: ''%1'')' with:(mod ? '??')).
                ^ self
            ].
            aStream class readErrorSignal handle:[:ex |
                self warn:(resources stringWithCRs:'Read error while reading extracted source\\') , ex description.
                aStream close.
                ^ self
            ] do:[
                comparedSource := aStream contents asString.
            ].
            aStream close.

            self busyLabel:'generating current source ...' with:nil.

            aStream := String writeStream.
            Method flushSourceStreamCache.
            currentClass fileOutOn:aStream withTimeStamp:false.
            currentSource := aStream contents asString.
            aStream close.

            self busyLabel:'comparing  ...' with:nil.

            comparedSource = currentSource ifTrue:[
                self information:'Versions are identical.'.
            ] ifFalse:[
                thisRevString := currentClass revision.
                thisRevString isNil ifTrue:[
                    thisRevString := 'no revision'
                ].

                revString = '(newest)' ifTrue:[
                    (rev := mgr newestRevisionOf:currentClass) notNil ifTrue:[
                        revString := '(newest is' , rev , ')'
                    ]
                ].

                self busyLabel:'comparing  ...' with:nil.

                UserPreferences versionDiffViewerClass
                  openOnClass:currentClass
                  labelA:('current: (based on: ' , thisRevString , ')')
                  sourceA:currentSource
                  labelB:('repository: ' , revString)
                  sourceB:comparedSource
                  title:('comparing ' , currentClass name).
            ].
            self normalLabel.
        ]
    ]

    "Created: / 04-01-1997 / 15:48:20 / cg"
    "Modified: / 12-09-2006 / 14:25:56 / cg"
    "Modified (format): / 29-09-2011 / 16:09:33 / cg"
!

classCreateSourceContainerFor:aClass
    "let user specify the source-repository values for aClass"

    ^ self 
	classDefineSourceContainerFor:aClass 
	title:(resources string:'Repository information for %1' with:aClass name)
	text:(resources string:'CREATE_REPOSITORY' with:aClass name)
	createDirectories:true
	createContainer:true.

    "Modified: 15.4.1996 / 17:07:57 / cg"
!

classDefineSourceContainerFor:aClass title:title text:boxText createDirectories:createDirs createContainer:createContainer
    "let user specify the source-repository values for aClass"

    |rslt|

    rslt := SourceCodeManagerUtilities
                defineSourceContainerForClass:aClass 
                title:title 
                text:boxText 
                createDirectories:createDirs 
                createContainer:createContainer.
    self normalLabel.
    ^ rslt.
!

classLoadNewRevision
    "let user specify a container and fileIn from there"

    |box
     moduleHolder directoryHolder fileNameHolder
     module directory fileName aStream
     y component mgr|

    mgr := SourceCodeManager.
    mgr isNil ifTrue:[^ false].

    fileNameHolder := ValueHolder newString.
    moduleHolder := (UserPreferences current usersModuleName "OperatingSystem getLoginName") asValue.
    directoryHolder := 'private' asValue.

    "/
    "/ open a dialog for the module/directory/container
    "/
    box := DialogBox new.
    box label:'container fileIn'.

    component := box addTextLabel:(resources stringWithCRs:'container to fileIn') adjust:#left.
    component borderWidth:0.
    box addVerticalSpace.
    box addVerticalSpace.

    y := box yPosition.
    component := box addTextLabel:(resources string:'Module:') adjust:#right.
    component width:0.4.
    box yPosition:y.
    component := box addInputFieldOn:moduleHolder tabable:true.
    component width:0.6; left:0.4; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.

    box addVerticalSpace.
    y := box yPosition.
    component := box addTextLabel:'Package:' adjust:#right.
    component width:0.4.
    box yPosition:y.
    component := box addInputFieldOn:directoryHolder tabable:true.
    component width:0.6; left:0.4; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.

    box addVerticalSpace.
    y := box yPosition.
    component := box addTextLabel:'Filename:' adjust:#right.
    component width:0.4.
    box yPosition:y.
    component := box addInputFieldOn:fileNameHolder tabable:true.
    component width:0.6; left:0.4; immediateAccept:true; acceptOnLeave:false; cursorMovementWhenUpdating:#beginOfLine.

    box addVerticalSpace.
    box addAbortAndOkButtons.

    box open.

    box destroy.
    box accepted ifFalse:[
        ^ false
    ].

    module := moduleHolder value withoutSpaces.
    directory := directoryHolder value withoutSpaces.
    fileName := fileNameHolder value withoutSpaces.

    (fileName endsWith:',v') ifTrue:[
        fileName := fileName copyButLast:2
    ].
    (fileName endsWith:'.st') ifFalse:[
        fileName := fileName , '.st'
    ].

    (mgr checkForExistingContainer:fileName
         inModule:module 
         directory:directory) 
    ifFalse:[
        self warn:'no such container'.
        ^ false
    ].

    aStream := mgr 
            streamForClass:nil 
            fileName:fileName 
            revision:#newest
            directory:directory
            module:module
            cache:false.

    aStream isNil ifTrue:[
        self warn:'could not fileIn from repository'.
        ^ false.
    ].

    self busyLabel:'loading from %1' with:(module , '/' , directory , '/' , fileName).

    Class withoutUpdatingChangesDo:[
        [
            aStream fileIn.
        ] ensure:[
            aStream close.
            self normalLabel.
            Smalltalk changed.
        ].
    ].

    ^ false

    "Created: / 13-09-1996 / 09:27:09 / cg"
    "Modified: / 13-09-2006 / 18:24:11 / cg"
!

classLoadRevision
    " load a specific revision into the system - especially useful to
     upgrade a class to the newest revision"

    currentClass isNil ifTrue:[
        ^ self classLoadNewRevision.
    ].

    currentClass isLoaded ifFalse:[
        self warn:'cannot load specific releases of autoloaded classes.'.
        ^ self.
    ].

    self doClassMenu:[:currentClass |
        |aStream comparedSource currentSource v rev revString what mgr keep className
         newClass prevCategory ok|

        rev := SourceCodeManagerUtilities default
                    askForExistingRevision:'load which revision:'
                    title:'Load from repository' 
                    class:currentClass.
        "/ rev := Dialog request:'load which revision: (empty for newest)' onCancel:nil.
        rev notNil ifTrue:[
            className := currentClass name.
            (className includesString:'_rev_') ifTrue:[
                self warn:'select the original class and try again.'.
                ^ self
            ].

            mgr := SourceCodeManagerUtilities sourceCodeManagerFor:currentClass.
            ok := false.

            rev withoutSpaces isEmpty ifTrue:[
                what := className , '(newest)'.
                self busyLabel:'extracting %1' with:what.
                aStream := mgr getMostRecentSourceStreamForClassNamed:className.
                revString := 'newest'.
                keep := false.
            ] ifFalse:[
                what := className , '(' , rev , ')'.
                self busyLabel:'extracting %1' with:what.
                aStream := mgr getSourceStreamFor:currentClass revision:rev.
                revString := rev.
                keep := true.
            ].

            aStream isNil ifTrue:[
                self warn:'cannot find classes source.'.
                ^ self.
            ].

            self busyLabel:'loading %1' with:what .

            [
                Class withoutUpdatingChangesDo:[
                    |saveIt prevSkip|

                    saveIt := Dialog confirmWithCancel:'Keep a save-copy of the existing class ?

Enter ''yes'', to have the existing class be
renamed before the fileIn is performed.
You have to care for subclasses if doing so,
because those are moved out of the way together
with the class.

Enter ''no'' to load the repository version
without saving the existing class.
In this case, methods from the repository version
will be merged with methods of the class in your 
running image.)' default:false.
                    saveIt isNil ifTrue:[^ self].
                    saveIt ifTrue:[
                        "/ rename the current class - for backup
                        prevCategory := currentClass category.    
                        currentClass setCategory:'* obsolete *'.
                        Smalltalk renameClass:currentClass to:className , '_saved'.
                    ].

                    prevSkip := ClassCategoryReader skipUnchangedMethods.
                    ClassCategoryReader skipUnchangedMethods:false.

                    Class nameSpaceQuerySignal answer:currentClass nameSpace
                    do:[
                        Class packageQuerySignal answer:currentClass package
                        do:[
                            lockUpdates := true.
                            [
                                aStream fileIn.
                            ] ensure:[
                                ClassCategoryReader skipUnchangedMethods:prevSkip.
                                lockUpdates := false.
                            ].
                        ].
                    ].

                    "/ did that work ?
                    newClass := Smalltalk at:className ifAbsent:nil.
                    newClass isNil ifTrue:[
                        saveIt ifTrue:[
                            self warn:'fileIn failed - undoing changes ...'.
                            Smalltalk renameClass:currentClass to:className.                        
                            currentClass setCategory:prevCategory.
                        ] ifFalse:[
                            self warn:'fileIn failed - cannot recover class'.
                        ]
                    ] ifFalse:[
                        "/
                        "/ if we loaded an old version, rename that one and fix the name of the
                        "/ current class
                        "/
                        keep ifTrue:[
                            saveIt ifTrue:[
                                Smalltalk renameClass:newClass to:(className , '_rev_' , rev).
                                newClass setCategory:'* old versions *'.
                                Smalltalk renameClass:currentClass to:className.
                                currentClass setCategory:prevCategory.
                            ]
                        ].
                        ok := true.
                    ]
                ].
            ] ensure:[
                aStream close.
                self normalLabel.
                Smalltalk changed.
            ].
            ok ifTrue:[
                self switchToClassNamed:newClass name.
            ]    
        ]
    ]

    "Created: / 14-11-1995 / 16:43:15 / cg"
    "Modified: / 06-10-2006 / 13:42:04 / cg"
!

classModifyContainer
    "change the classes container in the source repository"

    currentClass isLoaded ifFalse:[
        self warn:'don''t know anything about unloaded classes.'.
        ^ self.
    ].

    self doClassMenu:[:currentClass |
        self 
            classDefineSourceContainerFor:currentClass 
            title:(resources string:'Repository information for %1' with:currentClass name)
            text:'defining/changing the source code container'
            createDirectories:true createContainer:true. 
    ]

    "Created: / 23-11-1995 / 11:41:38 / cg"
    "Modified: / 06-10-2006 / 13:40:38 / cg"
!

classModifyPackage
    "change the classes package assignment (dangerous)"

    |newPackage|

    currentClass owningClass notNil ifTrue:[
        self warn:'Private classes always belong to the owners package.\\Cannot change the packageID.' withCRs.
        ^ self
    ].

    currentClass isLoaded ifFalse:[
        self warn:('The package-ID is ''' , currentClass package allBold , '''.'
                   , '\\I will not change the package-ID of unloaded classes.') withCRs.
        ^ self.
    ].

    newPackage := Dialog 
                    request:(resources string:'Change the package-ID of ''%1'' to:\\(Warning - this may affect autoloading & source code access)' with:currentClass name allBold) withCRs
                    initialAnswer:currentClass package.
    newPackage size == 0 ifTrue:[
        ^ self
    ].

    self doClassMenu:[:currentClass |
        currentClass package:newPackage.
    ]

    "Created: / 23-11-1995 / 11:41:38 / cg"
    "Modified: / 06-10-2006 / 13:21:01 / cg"
!

classRemoveContainer
    "remove a container from the source repository"

    currentClass isLoaded ifFalse:[
	self warn:'please load the class first'.
	^ self.
    ].

    self doClassMenu:[:currentClass |
	self 
	    classRemoveSourceContainerFor:currentClass
    ]

    "Created: 23.11.1995 / 11:41:38 / cg"
    "Modified: 11.9.1996 / 12:55:42 / cg"
!

classRemoveSourceContainerFor:aClass
    "show container & let user confirm twice."

    ^ SourceCodeManagerUtilities removeSourceContainerForClass:aClass.
!

classRevisionInfo
    "show current classes revision info in codeView"

    self doClassMenu:[:currentClass |
        |aStream info info2 s rv mgr fn msg|

        aStream := WriteStream on:(String new:200).
        currentClass notNil ifTrue:[
            Processor activeProcess 
                withPriority:Processor activePriority-1 to:Processor activePriority
            do:[
                self busyLabel:'extracting revision info' with:nil.

                SourceCodeManagerUtilities repositoryLogOf:currentClass onto:aStream
            ]
        ].
        codeView contents:(aStream contents); modified:false.
        codeModified := false.
        self clearAcceptAction.
        self clearExplainAction.
        methodListView notNil ifTrue:[
            methodListView setSelection:nil
        ].
        aspect := #revisionInfo. 
        self normalLabel
    ]

    "Created: / 14.11.1995 / 16:43:15 / cg"
    "Modified: / 10.2.2000 / 14:14:09 / cg"
! !

!BrowserView methodsFor:'class stuff'!

allClasses
    |classes|

    currentNamespace = '* all *' ifTrue:[
        ^ environment allClasses
    ].

    classes := Set new.

    (self listOfNamespaces) do:[:aNamespace |
        aNamespace allClassesDo:[:aClass |
            |actualNamespace nm|

            aClass isMeta ifFalse:[
                (aClass isRealNameSpace) ifFalse:[
                    actualNamespace := aClass nameSpace.
                    (actualNamespace isRealNameSpace) ifFalse:[
                        classes add:aClass
                    ]
                ]
            ]
        ]
    ].
    ^ classes

    "Modified: / 10-11-2006 / 17:06:55 / cg"
!

allClassesInCategory:aCategory
    |classes|

    currentNamespace = '* all *' ifTrue:[
        ^ environment allClassesInCategory:currentClassCategory
    ].

    classes := Set new.

    (self listOfNamespaces) do:[:aNamespace |
        aNamespace allClassesDo:[:aClass |
            |actualNamespace nm|

            aClass isMeta ifFalse:[
                (aCategory = '* all *'
                or:[aClass category = aCategory]) ifTrue:[
                    (aClass isRealNameSpace) ifFalse:[
                        actualNamespace := aClass nameSpace.
                        (actualNamespace isRealNameSpace) ifFalse:[ "/ a private class
                            classes add:aClass
                        ]
                    ]
                ]
            ]
        ]
    ].
    ^ classes

    "Created: / 23-12-1996 / 10:26:28 / cg"
    "Modified: / 10-11-2006 / 17:07:35 / cg"
!

allClassesInCategory:aCategory do:aBlock
    |classes|

    classes := self allClassesInCategory:aCategory.
    classes do:aBlock

    "Modified: 23.12.1996 / 10:30:00 / cg"
!

allClassesInSelectedNamespacesDo:aBlock
    |nameSpacesConsidered|

    currentNamespace = '* all *' ifTrue:[
        environment allClassesDo:aBlock.
        ^ self
    ].

    nameSpacesConsidered := self listOfNamespaces asIdentitySet.

    environment allClassesDo:[:aClass |
        (nameSpacesConsidered includes:aClass nameSpace)
        ifTrue:[
            aBlock value:aClass
        ]
    ]

    "Created: / 16.1.1997 / 20:18:47 / cg"
    "Modified: / 18.6.1998 / 15:06:23 / cg"
!

changeCurrentClass:newClass
    "change the current class to some other class;
     keep instance protocol as it was.
     This does not update any views."

    |cls meta|

"/    fullProtocol ifTrue:[^ self].

    self releaseClass.

    newClass notNil ifTrue:[
        cls := newClass.
        cls isMeta ifTrue:[
            meta := cls.
            cls := meta theNonMetaclass
        ] ifFalse:[
            meta := cls theMetaclass
        ].
    ].

    currentClass := cls.
    showInstance ifTrue:[
       actualClass := acceptClass := cls.
    ] ifFalse:[
       actualClass := acceptClass := meta.
    ].

    currentClass notNil ifTrue:[
        cls addDependent:self.
        meta addDependent:self.
    ].
    self normalLabel.

    "Modified: / 1.9.1995 / 01:04:05 / claus"
    "Modified: / 13.12.1995 / 15:32:49 / cg"
    "Created: / 10.4.1998 / 12:25:16 / cg"
!

checkClassSelected
    "warn and return false, if no class is selected"

    currentClass isNil ifTrue:[
	self warn:'select a class first'.
	^ false
    ].
    ^ true
!

classClassDefinitionTemplateFor:aClass in:cat nameSpace:isNameSpace private:isPrivate
    "common helper for newClass and newSubclass
     - show a template to define a subclass of aClass in category cat.
     Also, set acceptaction to install the class."

    |theSuperClass|

    currentMethodCategory := nil.
    self releaseMethod.

    classListView setSelection:nil.

    fullClass ifFalse:[
        methodCategoryListView contents:nil.
        methodListView contents:nil
    ].

    (aClass == Autoload
    or:[aClass isNil or:[aClass isLoaded not]]) ifTrue:[
        currentNamespace == JAVA ifTrue:[
            theSuperClass := Java at:'java.lang.Object'
        ] ifFalse:[
            theSuperClass := Object
        ]
    ] ifFalse:[
        theSuperClass := aClass
    ].
    codeView contents:(self classTemplateFor:theSuperClass in:cat nameSpace:isNameSpace private:isPrivate).
    codeView modified:false.
    codeModified := false.

    self changeCurrentClass:nil

    "Created: / 26-07-2012 / 23:07:08 / cg"
!

classClassDefinitionTemplateFor:aClass in:cat namespace:isNameSpace private:isPrivate
    "common helper for newClass and newSubclass
     - show a template to define a subclass of aClass in category cat.
     Also, set acceptaction to install the class."

    <resource: #obsolete>

   ^ self
        classClassDefinitionTemplateFor:aClass in:cat nameSpace:isNameSpace private:isPrivate

    "Created: / 23-12-1996 / 12:45:43 / cg"
    "Modified (format): / 26-07-2012 / 23:07:34 / cg"
!

classDoubleClick:lineNr
    "double click on a class;
     if its unloaded, load it.
     if its an application-class, start the app"

    |testRunner|

    currentClass notNil ifTrue:[
        currentClass isVisualStartable ifTrue:[
            self withWaitCursorDo:[
                self busyLabel:'starting application %1' with:currentClass name.
                currentClass open.
                self normalLabel.
            ].
            ^ self
        ].
        currentClass isLoaded ifFalse:[
            self classLoad.
"/            self withWaitCursorDo:[
"/                currentClass autoload.
"/            ].
            self normalLabel.
            ^ self
        ].
        (currentClass isTestCaseLike and:[currentClass isAbstract not]) ifTrue:[
            testRunner := UserPreferences current testRunnerClass.
            testRunner notNil ifTrue:[ 
                testRunner openOnTestCase:currentClass.
                ^ self
            ].
        ].
    ]

    "Created: / 29-10-1997 / 15:50:26 / cg"
    "Modified: / 16-02-1998 / 11:55:25 / stefan"
    "Modified: / 06-07-2011 / 14:04:39 / cg"
!

classListUpdate
    RememberAspect ifTrue:[
	aspect == #hierarchy ifTrue:[
	    ^ self classHierarchy
	].
	aspect == #classInstVars ifTrue:[
	    ^ self classClassInstVars
	].
	aspect == #comment ifTrue:[
	    ^ self classComment
	].
	aspect == #primitiveDefinitions ifTrue:[
	    ^ self classPrimitiveDefinitions
	].
	aspect == #primitiveFunctions ifTrue:[
	    ^ self classPrimitiveFunctions
	].
	aspect == #primitiveVariables ifTrue:[
	    ^ self classPrimitiveVariables
	].
	aspect == #revisionInfo ifTrue:[
	    ^ self classRevisionInfo
	].
    ].
    self classDefinition

    "Created: 23.11.1995 / 11:28:58 / cg"
    "Modified: 23.11.1995 / 11:36:08 / cg"
!

classSelection:lineNr
    "user clicked on a class line - show method categories"

    |cls nm oldSelector sel classes msg globlName|

    (currentClassHierarchy notNil
     and:[fullProtocol]) ifTrue:[
        oldSelector := currentSelector.

        self updateMethodCategoryListWithScroll:false.
        self updateMethodListWithScroll:false.
        fullProtocol ifFalse:[
            self updateVariableList.
        ].
        oldSelector notNil ifTrue:[
            self switchToMethod:oldSelector.
            currentMethod isNil ifTrue:[
                currentSelector := oldSelector.
                codeView contents:'*** no other implementor of ' , currentSelector allBold , ' in that hierarchy ***'.
                self clearAcceptAction.
            ] ifFalse:[
                self switchToMethodCategory:(currentMethod category).
                self methodSelectionChanged.
            ]
        ].
        ^ self
    ].

    (sel := classListView selectionValue) isNil ifTrue:[
        self classCategorySelectionChanged. 
        aspect := nil.
        currentClass := actualClass := nil.
        self updateCodeView.
        ^ self
    ].
    nm := sel withoutSpaces.
    cls := self findClassNamed:nm.
    cls notNil ifTrue:[
        self changeCurrentClass:cls.
        self classSelectionChanged
    ] ifFalse:[
        (self confirm:('oops - no class named: ' , nm , ' found in selected namespace(s)\\Try to reconnect ?') withCRs)
        ifTrue:[
            "/ search for all classes by that name ...
            classes := IdentitySet new.
            Class allSubInstancesDo:[:aClass |
                aClass name = nm ifTrue:[
                    classes add:aClass
                ]
            ].
            classes notEmpty ifTrue:[
                classes size == 1 ifTrue:[
                    cls := classes first.
                    environment
                        keysAndValuesDo:[:key :aClass |
                                (environment at:key) == cls ifTrue:[
                                    globlName := key
                                ]
                        ].

                    msg := 'found ' , cls name , ' in category ''' , cls category , '''.\'.
                    globlName notNil ifTrue:[
                        msg := msg , '(known as ' , globlName , ')\'.
                    ].
                    (self confirm:(msg , '\rebind in Smalltalk as ''' , cls name , '''?') withCRs)
                    ifTrue:[
                        environment at:cls name asSymbol put:cls
                    ]
                ] ifFalse:[
                    self warn:('found multiple classes with a name of ' , nm , '.\\Select and rename as required') withCRs.
                    SystemBrowser browseClasses:classes asOrderedCollection
                                          label:'choose and rename as required'
                ]
            ] ifFalse:[
                Class allSubInstancesDo:[:aClass |
                    aClass isMeta ifFalse:[
                        (environment at:aClass name) ~~ aClass ifTrue:[
                            classes add:aClass
                        ]
                    ]
                ].
                classes size > 0 ifTrue:[
                    self warn:'oops - could not a class with that name.\\Please see all classes which are not found in Smalltalk and fix things manually.' withCRs.
                    classes inspect
                ] ifFalse:[
                    self warn:'oops - could not a class with that name.'.
                ]
            ]
        ]
    ].

    actualClass notNil ifTrue:[
        "/ self addToClassHistory: actualClass name asString
        self class addToClassHistory:actualClass selector:nil
    ]

    "Modified: / 10.2.2000 / 14:14:18 / cg"
!

classSelectionChanged
    |oldMethodCategory oldMethod oldSelector|

    self withWaitCursorDo:[
        "/ alien classes have no methodCategories; hide that list ...

        currentClass notNil ifTrue:[
            currentClass supportsMethodCategories ifFalse:[
                self hideMethodCategoryList
            ] ifTrue:[
                self showMethodCategoryList
            ].
        ].

        "/ temporarily nil the aspect, to avoid
        "/ double redraw.
        aspect := nil. "/ #definition.

        oldMethodCategory := currentMethodCategory.
        oldMethod := currentMethod.
        oldSelector := currentSelector.

        showInstance ifTrue:[
            actualClass := acceptClass := currentClass
        ] ifFalse:[
            actualClass := acceptClass := currentClass theMetaclass
        ].
        currentMethodCategory := nil.
        self releaseMethod.

        self updateMethodCategoryList.

        oldMethodCategory notNil ifTrue:[
            methodCategoryListView setSelectElement:oldMethodCategory.
            methodCategoryListView hasSelection ifTrue:[
                currentMethodCategory := oldMethodCategory.
                self methodCategorySelectionChanged
            ]
        ].
        aspect := #definition.

        self updateMethodList.
        "/ self updateCodeView.
        self updateVariableList.

        fullClass ifTrue:[
            self updateCodeView.
            self setAcceptActionForFullClass.
        ] ifFalse:[
"/            self classDefinition.
            self classListUpdate.
            self setAcceptActionForClass.
        ].
        self clearExplainAction.

        (classCategoryListView notNil and:[currentClass notNil]) ifTrue:[
            (currentClassCategory = currentClass category) ifFalse:[
                currentClassCategory := currentClass category.
                (classCategoryListView list includes:currentClassCategory) ifTrue:[
                    classCategoryListView setSelectElement:currentClassCategory
                ] ifFalse:[
                    classCategoryListView setSelection:nil
                ]
            ]
        ].

        self setDoitActionForClass
    ]

    "Created: / 23.11.1995 / 11:32:03 / cg"
    "Modified: / 24.2.2000 / 15:50:17 / cg"
!

classTemplateFor:aSuperClass in:categoryString nameSpace:isNameSpace private:isPrivate
    "return a class definition template - be smart in what is offered initially"

    |cat name nameProto namePrefix i existingNames withNameSpaceDirective
     className ownerName s|

    (aSuperClass notNil and:[aSuperClass isJavaClass not]) ifFalse:[
        (currentNamespace == JAVA 
        or:[aSuperClass notNil and:[aSuperClass isJavaClass]])
        ifTrue:[
            ^ self javaClassTemplateFor:aSuperClass in:categoryString private:isPrivate
        ].
    ].

    self setAcceptActionForNewClass.

    s := TextStream on:''.

    isNameSpace ifTrue:[
        s nextPutLine:'NameSpace name:''NewNameSpace'''.
        s cr.
        s emphasis:(UserPreferences current commentEmphasisAndColor).
        s nextPutAll:'"
 Replace ''NewNameSpace'' by the desired name.

 Create the namespace by ''accepting'',
 either via the menu or the keyboard (usually CMD-A).
"
'.
        ^ s contents.
    ].

    withNameSpaceDirective :=
        currentNamespace notNil 
        and:[currentNamespace ~= '* all *'
        and:[currentNamespace ~= Smalltalk]].

    withNameSpaceDirective ifTrue:[
        className := aSuperClass nameWithoutNameSpacePrefix.
        s nextPutLine:('"{ NameSpace: ''' , currentNamespace name , ''' }"').
        s cr.
    ] ifFalse:[    
        className := aSuperClass name.
    ].

    cat := categoryString.
    (cat isNil or:[cat startsWith:$*]) ifTrue:[
        cat := '* no category *'
    ].

    nameProto := 'NewClass'.
    i := 1.
    isPrivate ifTrue:[
        namePrefix := currentClass name , '::'.
        existingNames := currentClass privateClasses.
        existingNames size > 0 ifTrue:[
            existingNames := existingNames collect:[:cls | cls name].
        ]
    ] ifFalse:[
        namePrefix := ''.
        existingNames := Smalltalk keys
    ].

    name := 'NewClass' , i printString.
    existingNames notNil ifTrue:[
        nameProto := namePrefix , name.
        [nameProto knownAsSymbol and:[existingNames includes:nameProto asSymbol]] whileTrue:[
            i := i + 1.
            name := 'NewClass' , i printString.
            nameProto := namePrefix , name
        ].
    ].

    s nextPutAll:className.

    isPrivate ifTrue:[
        withNameSpaceDirective ifTrue:[
            ownerName := currentClass nameWithoutNameSpacePrefix
        ] ifFalse:[
            ownerName := currentClass name
        ].
        s nextPutAll:(' subclass:#' , name  , '
' , '    instanceVariableNames: ''''
' , '    classVariableNames: ''''
' , '    poolDictionaries: ''''
' , '    privateIn:' , ownerName)
    ] ifFalse:[
        s nextPutAll:(' subclass:#' , name , '
' , '    instanceVariableNames: ''''
' , '    classVariableNames: ''''
' , '    poolDictionaries: ''''
' , '    category: ''').
        cat notNil ifTrue:[
            cat printWithQuotesDoubledOn:s
        ].
        s nextPutAll: ''''
    ].

    s cr; cr.
    s emphasis:(UserPreferences current commentEmphasisAndColor).
    s nextPutAll:'
"
 Replace ''' , className , ''', ''', name , ''' and
 the empty string arguments by true values.

 Install (or change) the class by ''accepting'',
 either via the menu or the keyboard (usually CMD-A).

 To be nice to others (and yourself later), do not forget to
 add some documentation; preferably under the classes documentation
 protocol.
 (see the `create documentation stubs'' item in the methodList menu.)
"
'.

    ^ s contents

    "Modified: / 15-06-1998 / 17:23:05 / cg"
    "Created: / 26-07-2012 / 23:07:42 / cg"
!

classTemplateFor:aSuperClass in:categoryString namespace:isNameSpace private:isPrivate
    "return a class definition template - be smart in what is offered initially"

    <resource: #obsolete>

    ^ self
        classTemplateFor:aSuperClass in:categoryString nameSpace:isNameSpace private:isPrivate

    "Created: / 23-12-1996 / 12:46:31 / cg"
    "Modified (format): / 26-07-2012 / 23:08:13 / cg"
!

doClassMenu:aBlock
    "a helper - check if class is selected and evaluate aBlock
     while showing waitCursor"

    self checkClassSelected ifTrue:[
        self withWaitCursorDo:[aBlock value:currentClass]
    ]

    "Modified: 18.8.1997 / 15:43:58 / cg"
!

javaClassTemplateFor:aSuperClass in:categoryString private:isPrivate
    "return a java class definition template - be smart in what is offered initially"

    |name i className s superPackage|

    self setAcceptActionForNewJavaClass.

    s := TextStream on:''.
    s nextPutLine:('package ' , categoryString , ';').
    s cr.

    s nextPutLine:('public ').
    s nextPutAll:('class ').

    i := 1.
    name := 'NewClass' , i printString.
    [ (Java classNamed:(categoryString , '.' , name)) notNil ] whileTrue:[
        i := i + 1.
        name := 'NewClass' , i printString.
    ].
    s nextPutAll:name; space.

    className := aSuperClass lastName.
    superPackage := aSuperClass package copyReplaceAll:$/ with:$..
    superPackage = categoryString ifFalse:[
        superPackage = 'java.lang' ifFalse:[
            className := aSuperClass name copyReplaceAll:$/ with:$..
        ].
    ].

    s nextPutAll:'extends '; nextPutAll:className.
    s nextPutLine:' {'.
    s nextPutLine:'    // { private } { static } { final } type varName;'.
    s nextPutLine:'    // int var1;'.
    s nextPutLine:'    // int var2;'.
    s nextPutLine:'}'.

    s cr; cr.
    s emphasis:(UserPreferences current commentEmphasisAndColor).
    s nextPutAll:'

// Replace ''' , className , ''', ''', name , ''' and
// change the local variable declarations as required.
//
// Install (or change) the class by ''accepting'',
// either via the menu or the keyboard (usually CMD-A).
'.

    ^ s contents

    "Created: / 23-12-1996 / 12:46:31 / cg"
    "Modified: / 16-07-2013 / 19:50:01 / cg"
!

listOfAllClassNamesInCategory:aCategory
    "return a list of the names of all classes in a given category"

    ^ self listOfAllClassesInCategory:aCategory names:true

    "Modified: 10.1.1997 / 14:00:33 / cg"
!

listOfAllClassesInCategory:aCategory names:namesFlag
    "return a list of (the names) of all classes in a given category
     from the currently selected set of nameSpaces."

    |nameSpaces listOfClassNames listOfClasses classesPresent namesPresent searchCategory 
     match anyCategory nm allNameSpaces|

    allNameSpaces := (currentNamespace = '* all *').

    "/ keep track of added names (care for obsolete classes)

    namesPresent := Set new.

    (aCategory = '* hierarchy *') ifTrue:[
        listOfClassNames := OrderedCollection new.
        listOfClasses := OrderedCollection new.

        self classHierarchyOf:(environment at:#Object) withAutoloaded:true do:[:aClass :lvl|
            |indent|

            aClass isRealNameSpace ifFalse:[
                aClass isObsolete ifFalse:[
                    nm := self displayedClassNameOf:aClass.

                    (namesPresent includes:nm) ifFalse:[
                        indent := String new:lvl*2.

                        "/ show classes from other nameSpaces in italic

                        (allNameSpaces not
                         and:[(self findClassNamedInNameSpace:nm) isNil]) ifTrue:[
                            nm := nm allItalic.
                        ].
                        nm := indent , nm.
                        namesPresent add:nm.
                        listOfClassNames add:nm.
                        listOfClasses add:nm.
                    ]
                ]
            ]
        ].
        namesFlag ifFalse:[
            ^ listOfClasses
        ].
        ^ listOfClassNames
    ].

    (aCategory = '* all *') ifTrue:[
        anyCategory := true
    ] ifFalse:[
        anyCategory := false.
        (aCategory = '* no category *') ifTrue:[
            searchCategory := nil
        ] ifFalse:[
            searchCategory := aCategory
        ].
    ].

    allNameSpaces ifTrue:[
        nameSpaces := Array with:environment.
    ] ifFalse:[
        nameSpaces := self listOfNamespaces.
    ].

    listOfClasses := OrderedCollection new.
    listOfClassNames := OrderedCollection new.
    classesPresent := IdentitySet new.

    nameSpaces do:[:aNamespace |
        aNamespace allClassesDo:[:aClass |
            |thisCategory actualNamespace nm owner|

            aClass isMeta ifFalse:[
                aClass isRealNameSpace ifFalse:[
                    (classesPresent includes:aClass) ifFalse:[

                        match := anyCategory.
                        match ifFalse:[
                            thisCategory := aClass category.
                            match := ((thisCategory = searchCategory) 
                                     or:[thisCategory = aCategory]).
                        ].

                        match ifTrue:[
                            fullClass ifTrue:[
                                aClass owningClass notNil ifTrue:[
                                    match := false
                                ]
                            ].
                        ].

                        match ifTrue:[
                            nm := self displayedClassNameOf:aClass.
                            (namesPresent includes:nm) ifFalse:[

                                allNameSpaces ifFalse:[
                                    (owner := aClass topOwningClass) notNil ifTrue:[
                                        actualNamespace := owner nameSpace
                                    ] ifFalse:[
                                        actualNamespace := aClass nameSpace.
                                    ].
                                    match := actualNamespace isRealNameSpace not. "/ a private class
                                ].
                                match ifTrue:[
                                    namesPresent add:nm.
                                    classesPresent add:aClass.
                                    listOfClasses add:aClass.
                                    listOfClassNames add:nm.
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].

    fullClass ifFalse:[
        "/
        "/ mhm - must search through private classes of those
        "/ in smalltalk (they are not visible in the nameSpace,
        "/ but should also be displayed)
        "/
        environment allClassesDo:[:aClass |
            |actualNamespace owner|

            aClass isMeta ifFalse:[
                (classesPresent includes:aClass) ifFalse:[
                    (owner := aClass topOwningClass) notNil ifTrue:[
                        (classesPresent includes:owner) ifTrue:[
                            nm := self displayedClassNameOf:aClass.
                            (namesPresent includes:nm) ifFalse:[
                                namesPresent add:nm.
                                listOfClasses add:aClass.
                                listOfClassNames add:nm.
                            ]
                        ]
                    ]
                ]
            ]
        ].
    ].

    (listOfClasses size == 0) ifTrue:[^ nil].

    "/ sort by name
    listOfClassNames sortWith:listOfClasses.

    namesFlag ifFalse:[
        ^ listOfClasses
    ].

    "/ indent after sorting
    1 to:listOfClassNames size do:[:index |
        |nm cls owner s|

        cls := listOfClasses at:index.
        owner := cls.
        (owner := owner owningClass) notNil ifTrue:[
            nm := listOfClassNames at:index.
            s := nm.
            [owner notNil] whileTrue:[    
                s := '  ' , s.
                owner := owner owningClass
            ].
            listOfClassNames at:index put:s.
        ].
    ].

    ^ listOfClassNames

    "Created: / 10-01-1997 / 13:57:34 / cg"
    "Modified: / 10-11-2006 / 17:09:48 / cg"
!

listOfClassNameHierarchyOf:aClass
    "return a hierarchy class-list"

    |startClass classes thisOne|

    showInstance ifTrue:[
        startClass := aClass
    ] ifFalse:[
        startClass := aClass theMetaclass.
    ].
    classes := startClass allSuperclasses.
    thisOne := Array with:startClass.
    classes := classes reversed , thisOne.

    fullProtocol ifFalse:[
        classes := classes , startClass allSubclassesInOrder
    ].
    ^ classes collect:[:c | self displayedClassNameOf:c "c name"]

    "Created: 10.1.1997 / 14:01:06 / cg"
    "Modified: 30.7.1997 / 17:47:24 / cg"
!

renameCurrentClassTo:newNameString
    "helper - do the class-rename"

    self doClassMenu:[:currentClass |
        |oldSym oldBaseSym cls newOwnerOrNameSpacePath nsOrOwner s nextWord t hardRename|

        newNameString = currentClass name ifTrue:[^ self].

        newOwnerOrNameSpacePath := OrderedCollection new.

        nsOrOwner := Smalltalk.
        s := newNameString readStream.
        [s atEnd] whileFalse:[
            nextWord := s nextAlphaNumericWord.
            s skipSeparators.
            s atEnd ifFalse:[
                nsOrOwner isNameSpace ifTrue:[
                    t := nsOrOwner at:nextWord asSymbol
                ] ifFalse:[
                    t := nsOrOwner privateClassesAt:nextWord asSymbol
                ].
                t isNil ifTrue:[
                    self warn:('Name: ''' , newNameString , ''' specifies a non-existing NameSpace or Ownerclass.\\(no ''' , nextWord , ''' in ''' , nsOrOwner name , ')') withCRs.
                    ^ self
                ].
                nsOrOwner := t.
                s peek == $. ifTrue:[
                    s next.
                ] ifFalse:[
                    s peek == $: ifTrue:[
                        s next.
                        s next ~= $: ifTrue:[
                            self warn:'Bad name: ''' , newNameString , ''' (either use ''.'' or ''::'' as nameSpace separator)'.
                            ^ self
                        ]
                    ]
                ]
            ]
        ].
        nsOrOwner isNil ifTrue:[
            self warn:'Name ''' , newNameString , ''' specifies a non-existing NameSpace or Ownerclass'.
            ^ self
        ].

        hardRename := false.
        currentClass isPrivate ifTrue:[
            "/ check if the new name implies an owner-change
            hardRename := (nsOrOwner ~~ currentClass owningClass)
        ] ifFalse:[
            hardRename := (nsOrOwner ~~ Smalltalk)
        ].
        hardRename ifTrue:[
            (self confirm:'New name implies a NameSpace or OwningClass change - is this what you want ?') ifFalse:[
                ^ self
            ]
        ].

        "/ check if the target already exists - confirm if so.

        (cls := Smalltalk classNamed:newNameString) notNil ifTrue:[
            (self confirm:(resources string:'WARN_RENAME' 
                                     with:newNameString 
                                     with:cls category) withCRs)
                ifFalse:[^ self]
        ].

        oldSym := currentClass name asSymbol.
        oldBaseSym := currentClass nameWithoutPrefix asSymbol.

        "/
        "/ renaming is actually more complicated as one might
        "/ think (care for classVariables, privateClasses etc.)
        "/ Smalltalk knows all about that ...

        Smalltalk renameClass:currentClass to:newNameString.

        self updateClassList.
        self updateMethodCategoryListWithScroll:false.
        self updateMethodListWithScroll:false.
        self withWaitCursorDo:[
            Transcript showCR:('searching for users of ' , oldSym); endEntry.
            SystemBrowser browseReferendsOf:oldSym warnIfNone:false.
            oldBaseSym ~= oldSym ifTrue:[
                Transcript showCR:('searching for users of ' , oldBaseSym); endEntry.
                SystemBrowser browseReferendsOf:oldBaseSym warnIfNone:false
            ]
        ]
    ]

    "Created: / 25.11.1995 / 13:02:53 / cg"
    "Modified: / 31.7.1998 / 15:47:21 / cg"
!

switchToClassNameMatching:aMatchString
    |classNames caselessMatchingNames 
     substringMatchingNames caselessSubstringMatchingNames
     lcMatchString subMatch lcSubMatch thisName box className
     needSearch cls|

    classNames := Set new.
    caselessMatchingNames := Set new.
    substringMatchingNames := Set new.
    caselessSubstringMatchingNames := Set new.
    lcMatchString := aMatchString asLowercase.
    needSearch := true.
    aMatchString includesMatchCharacters ifFalse:[
        subMatch := '*' , aMatchString , '*'.
        lcSubMatch := subMatch asLowercase.

        "/ if the name is already a good one, avoid the expensive search
        className := aMatchString asSymbolIfInterned.
        className notNil ifTrue:[
            cls := environment at:className ifAbsent:nil.
            (cls notNil and:[cls isBehavior]) ifTrue:[
                needSearch := false.
            ]
        ]
    ].

    needSearch ifTrue:[
        environment allClassesDo:[:aClass |
            "/ to make it look better,
            "/ show dotted names for java
            "/ thisName := aClass name.

            aClass isJavaClass ifTrue:[
                thisName := aClass displayString. "/ fullName copyReplaceAll:$/ with:$.
            ] ifFalse:[
                thisName := aClass name
            ].

            (aMatchString match:thisName) ifTrue:[
                classNames add:thisName
            ] ifFalse:[
                (lcMatchString match:thisName asLowercase) ifTrue:[
                    caselessMatchingNames add:thisName
                ] ifFalse:[
                    subMatch notNil ifTrue:[
                        (subMatch match:thisName) ifTrue:[
                            substringMatchingNames add:thisName
                        ] ifFalse:[
                            (lcSubMatch match:thisName asLowercase) ifTrue:[
                                caselessSubstringMatchingNames add:thisName
                            ]
                        ]
                    ]
                ]
            ]
        ].

        "/ if nothing matched - try caseless matches
        classNames size == 0 ifTrue:[
            classNames := caselessMatchingNames.

            "/ if nothing matched - try substring matches
            classNames size == 0 ifTrue:[
                classNames := substringMatchingNames.

                "/ if nothing matched - try caseless substring matches
                classNames size == 0 ifTrue:[
                    classNames := caselessSubstringMatchingNames.
                ]
            ]
        ].

        (classNames size == 0) ifTrue:[^ nil].
        (classNames size == 1) ifTrue:[
            className := classNames first
        ] ifFalse:[
            classNames := classNames asArray sort.

            box := self listBoxTitle:'Select class to switch to:'
                              okText:'OK'
                                list:classNames.
            box action:[:aString | className := aString].
            box open.
        ].
    ].

    className size == 0 ifTrue:[^ self].

    "/ use slashed javaName for search.
    className := className copyReplaceAll:$. with:$/ ifNone:className.
    self switchToClassNamed:className.
    self classSelectionChanged.

    "Modified: / 22.2.1999 / 18:55:25 / cg"
!

switchToClassNamed:aString
    |meta str theClass newCat element idx l|

    meta := false.

    str := aString.
    (aString endsWith:' class') ifTrue:[
        str := aString copyButLast:6.
        meta := true
    ].

    theClass := self findClassNamed:str.

    classCategoryListView notNil ifTrue:[
        classCategoryListView list size == 0 ifTrue:[
            classCategoryListView list:(self listOfAllClassCategories).
        ]
    ].
    (theClass isRealNameSpace) ifTrue:[               
        namespaceList select:(namespaceList list indexOf:theClass name).
        self changeNameSpaceTo:(theClass name).
        classListView deselect.
        ^ self
    ].

    theClass nameSpace ~~ currentNamespace ifTrue:[
        namespaceList notNil ifTrue:[
            namespaceList select:(namespaceList list indexOf:'* all *').
            self changeNameSpaceTo:('* all *').
        ]
    ].

    theClass == currentClass ifTrue:[^ self].

    theClass isBehavior ifTrue:[
        classCategoryListView notNil ifTrue:[
            currentClassHierarchy isNil ifTrue:[
                ((newCat := theClass category) ~= currentClassCategory) ifTrue:[
                    currentClassCategory := newCat.
                    newCat isNil ifTrue:[
                        element := '* no category *'
                    ] ifFalse:[
                        element := newCat.
                    ].
                    classCategoryListView setSelectElement:element.
                    "/ classCategoryListView makeSelectionVisible.
                ]
            ]
        ].
        currentClass := actualClass := nil.
        self updateClassList.
        self changeCurrentClass:theClass.

"/        (currentNamespace = '* all *'
"/        or:[currentNamespace ~= theClass nameSpace]) ifTrue:[
"/            str := theClass name
"/        ] ifFalse:[
"/            str := theClass nameWithoutPrefix
"/        ].

        l := classListView list.
        l notNil ifTrue:[
            idx := l findFirst:[:line | line withoutSpaces = str].
"/            classListView selection:idx.
              classListView setSelection:idx.

"/            classListView setSelectElement:str.
        ].

        self instanceProtocol:meta not.
        idx ~~ 0 ifTrue:[
"/            self classSelectionChanged.
            classCategoryListView notNil ifTrue:[
                classCategoryListView setSelectElement:theClass category
            ]
        ].

        actualClass notNil ifTrue:[
            "/ self addToClassHistory: actualClass name asString
            self class addToClassHistory:actualClass selector:nil
        ]
    ]

    "Modified: / 01-09-1995 / 01:41:35 / claus"
    "Modified: / 17-06-1996 / 16:54:55 / stefan"
    "Modified: / 10-11-2006 / 17:10:15 / cg"
!

updateClassList
    self updateClassListWithScroll:true
!

updateClassListWithScroll:scroll
    |classes oldClassName|

    gotClassList == true ifTrue:[^ self].

    classListView isNil ifTrue:[^ self].

    self sensor
        flushEventsFor:nil 
        where:[:event |  
                    |aspect|

                    event type == #delayedUpdate:with:from:
                    and:[ (aspect := event arguments at:1) == #newClass
                          or:[aspect == #classDefinition]
                        ]
              ].

    "
     refetch in case we are not up to date
    "
    (currentClass notNil and:[fullProtocol not]) ifTrue:[
        oldClassName := currentClass name.
        currentClass := self findClassNamed:oldClassName.
    ].

    currentClassCategory notNil ifTrue:[
        classes := self listOfAllClassNamesInCategory:currentClassCategory
    ] ifFalse:[
        currentClassHierarchy notNil ifTrue:[
            classes := self listOfClassNameHierarchyOf:currentClassHierarchy
        ]
    ].

    classListView list = classes ifFalse:[
        scroll ifTrue:[
            classListView contents:classes
        ] ifFalse:[
            classListView setContents:classes
        ].
        oldClassName notNil ifTrue:[
            classListView setContents:classes.
            classListView setSelectElement:oldClassName
        ] ifFalse:[
            variableListView notNil ifTrue:[variableListView contents:nil]
        ].

        scroll ifTrue:[
            fullProtocol ifTrue:[
                classListView scrollToBottom
            ]
        ]
    ].

    "Modified: 10.1.1997 / 14:01:20 / cg"
! !

!BrowserView methodsFor:'class-method list menu'!

classMethodBrowse
    |brwsr|

    (environment notNil and:[environment ~~ Smalltalk]) ifTrue:[
        "/ only the old browser supports this (for now)
        brwsr := SystemBrowser openInClass:actualClass selector:currentSelector.
        brwsr environment:environment
    ] ifFalse:[
        brwsr := UserPreferences systemBrowserClass 
                    openInClass:actualClass selector:currentSelector.
    ].

    "Created: / 13-12-1995 / 15:05:12 / cg"
    "Modified: / 23-10-2006 / 10:48:55 / cg"
!

classMethodFileOutAll
    "fileout all methods into one source file"

    |list classString selectorString cls mth outStream fileName append
     fileBox f|

    append := false.
    fileBox := FileSaveBox
                        title:(resources string:'Save methods in:')
                        okText:(resources string:'Save')
                        abortText:(resources string:'Cancel')
                        action:[:fName | fileName := fName].
    fileBox appendAction:[:fName | fileName := fName. append := true].
    fileBox initialText:'some_methods.st'.
    Project notNil ifTrue:[
        fileBox directory:Project currentProjectDirectory
    ].
    fileBox open.

    fileName isNil ifTrue:[^ self].

    "
     if file exists, save original in a .sav file
    "
    f := fileName asFilename.
    f exists ifTrue:[
        f copyTo:(f withSuffix: 'sav')
    ].

    [
        append ifTrue:[
            outStream := f appendingWriteStream.
        ] ifFalse:[
            outStream := f newReadWriteStream.
        ].
    ] on:FileStream openErrorSignal do:[:ex|
        ^ self warn:'Cannot create: %1' with:fileName
    ].

    [
        self withWaitCursorDo:[
            list := classMethodListView list.
            list do:[:l |
                |line|

                line := l asString.

                self busyLabel:'writing: ' with:line.

                classString := self classNameFromClassMethodString:line.
                selectorString := self selectorFromClassMethodString:line.

                cls := self findClassNamed:classString.
                cls isNil ifTrue:[
                    self warn:'oops class %1 is gone' with:classString
                ] ifFalse:[
                    mth := cls compiledMethodAt:(selectorString asSymbol).
                    Class fileOutErrorSignal handle:[:ex |
                        |box answer|
                        box := YesNoBox 
                                    title:('FileOut error: ' 
                                           , ex description 
                                           , '\\continue anyway ?') withCRs
                                    yesText:'continue' 
                                    noText:'abort'.
                        answer := box confirm.
                        box destroy.
                        answer ifTrue:[
                            ex proceed
                        ].
                        ^ self
                    ] do:[
                        cls fileOutMethod:mth on:outStream.
                    ]    
                ]
            ].
        ]
    ] ensure:[
        self normalLabel.
        outStream close
    ].

    "Modified: / 17-06-1996 / 16:51:11 / stefan"
    "Modified: / 27-07-2012 / 09:39:07 / cg"
!

classMethodMenu
    <resource: #keyboard ( #Cmds #Cmdi #Cmdg ) >
    <resource: #programMenu >

    |items m specialMenu|

    (currentMethod notNil
    and:[currentMethod isWrapped]) ifTrue:[
        items := #(
                            ('Inspect Method'      methodInspect            )
                            ('Decompile'           methodDecompile          )
                            ('-'              nil               )
                  ).

        currentMethod isCounting ifTrue:[
            items := items , #(
                            ('Stop counting'  methodStopCounting)
                            ('Reset count'    methodResetCounting)
                          ).
        ] ifFalse:[
            currentMethod isCountingMemoryUsage ifTrue:[
                items := items , #(
                            ('Stop mem usage'  methodStopMemoryUsage)
                            ('Reset mem count' methodResetMemoryUsage)
                          ).
            ] ifFalse:[
                currentMethod isTimed ifTrue:[
                    items := items , #(
                            ('Stop timing' methodStopTiming)
                            ('Reset times' methodResetTiming)
                          ).
                ] ifFalse:[
                    items := items , #(
                            ('Remove break/trace'  methodRemoveBreakOrTrace )
                          ).
                ]
            ]
        ]
    ] ifFalse:[
        items := #(
                            ('Inspect method'      methodInspect            )
                            ('Decompile'           methodDecompile          )
                            ('-'                   nil                      )
                            ('Breakpoint'          methodBreakPoint         )
                            ('Breakpoint in...'   methodBreakPointInProcess)
                            ('-'                   nil                      )
                            ('Trace'               methodTrace              )
                            ('Trace sender'        methodTraceSender        )
                            ('Trace full walkback' methodTraceFull          )
                            ('-'                   nil                      )
                            ('Start timing'        methodStartTiming        )
                            ('Start counting'      methodStartCounting      )
                            ('Start mem usage'     methodStartMemoryUsage   )
                      ).
    ].
    specialMenu := PopUpMenu
                        itemList:items
                        resources:resources.

    self environment ~~ Smalltalk ifTrue:[
        specialMenu disableAll:#(methodStartMemoryUsage methodStartCounting methodStartTiming
                       methodTraceFull methodTraceSender methodTrace  methodBreakPointInProcess methodBreakPoint
                      )
    ].

    self sensor ctrlDown ifTrue:[
        currentMethod isNil ifTrue:[
            classMethodListView flash.
            ^ nil
        ].

        ^ specialMenu
    ].

    items := #(
                                ('FileOut'             methodFileOut                   )
                                ('FileOut all'         classMethodFileOutAll           )
                                ('PrintOut'            methodPrintOut                  )
                                ('-'                   nil                             )
                                ('Browse full'         classMethodBrowse               )
                                ('Spawn'               methodSpawn                     )
                                ('Spawn class'         classSpawn                      )
                                ('Spawn full protocol' classSpawnFullProtocol          )
                                ('Spawn hierarchy'     classSpawnHierarchy             )
                                ('-'                   nil                             )
                                ('Filter...'           classMethodFilter               )
                                ('Senders...'          methodSenders             Cmds  )
                                ('Implementors...'     methodImplementors        Cmdi  )
                                ('Globals...'          methodGlobalReferends     Cmdg  )
                                ('-'                   nil                             )
                                ('Change category...'  methodChangeCategory            )
                                ('Move...'             methodMove                      )
                                ('Remove'              methodRemove                    )
                                ('-'                   nil                             )
                                ('More'                othersMenu                Ctrl  )
               ).

    m := PopUpMenu itemList:items resources:resources.
    m subMenuAt:#othersMenu put:specialMenu.

    self environment ~~ Smalltalk ifTrue:[
        m disableAll:#(methodSenders classMethodFilter methodImplementors methodGlobalReferends
                       methodChangeCategory methodMove methodRemove 
                      )
    ].
    ^ m

    "Modified: / 7.8.1998 / 17:13:47 / cg"
! !

!BrowserView methodsFor:'class-method stuff'!

classFromClassMethodString:aString
    "helper for classMethod-list - extract class name from the string"

    |classString|

    classString := self classNameFromClassMethodString:aString.
    ^ self findClassNamed:classString.

    "Created: 3.3.1997 / 15:12:59 / cg"
!

classMethodFilter
    "filter - that is: open another method-list browser on all those methods
     which pass some filter."

    |aspects list allMethods filteredMethods sel str|

    aspects := IdentityDictionary new.
    aspects at:#doFilterMessage         put:false asValue.
    aspects at:#notContainingMessage    put:false asValue.
    aspects at:#doFilterString          put:false asValue.
    aspects at:#notContainingString     put:false asValue.
    aspects at:#filteredMessageSelector put:nil asValue.
    aspects at:#filteredString          put:nil asValue.

    (SystemBrowser  
      openDialogInterfaceSpec:(self class methodFilterSpec)
      withBindings:aspects) ifFalse:[
        ^ self
    ].

    self withWaitCursorDo:[
        list := classMethodListView list.
        allMethods := list collect:[:line |
            |cls sel|

            cls := self classFromClassMethodString:line.
            sel := self selectorFromClassMethodString:line.
            sel := sel asSymbol.
            cls isNil ifTrue:[
                nil
            ] ifFalse:[
                cls compiledMethodAt:sel
            ]
        ].
        allMethods := allMethods select:[:m | m notNil].

        filteredMethods := allMethods.
        (aspects at:#doFilterMessage) value ifTrue:[
            sel := (aspects at:#filteredMessageSelector) value.
            sel size > 0 ifTrue:[
                sel := sel string asSymbol.
                (aspects at:#notContainingMessage) value ifTrue:[
                    filteredMethods := filteredMethods reject:[:m | m sends:sel].
                ] ifFalse:[
                    filteredMethods := filteredMethods select:[:m | m sends:sel].
                ]
            ]
        ].
        (aspects at:#doFilterString) value ifTrue:[
            str := (aspects at:#filteredString) value.
            str size > 0 ifTrue:[
                str := str string.
                (aspects at:#notContainingString) value ifTrue:[
                    filteredMethods := filteredMethods reject:[:m | m source includesString:str].
                ] ifFalse:[
                    filteredMethods := filteredMethods select:[:m | m source includesString:str].
                ]
            ]
        ].

        filteredMethods = allMethods ifTrue:[
            self information:'Filtered list is the same as shown.'.
            ^ self
        ].
        filteredMethods isEmpty ifTrue:[
            self information:'Filtered list is empty.'.
            ^ self
        ].

        SystemBrowser
            browseMethods:filteredMethods 
            title:('filtered ' , self topView label)
    ]

    "Modified: / 11-07-2010 / 16:36:14 / cg"
!

classMethodSelection:lineNr
    "user clicked on a class/method line - show code"

    |cls string classString selectorString meta|

    string := classMethodListView selectionValue string.
    classString := self classNameFromClassMethodString:string.
    selectorString := self selectorFromClassMethodString:string.

    "/ reselected with control ?
    self sensor ctrlDown ifTrue:[
        selectorString = currentSelector ifTrue:[
            "/ if there is a trace/break, remove it.
            (currentMethod notNil and:[currentMethod isWrapped]) ifTrue:[
                self methodRemoveBreakOrTrace.
                ^ self
            ]
        ].
    ].

    (classString endsWith:' class') ifTrue:[
        classString := classString copyButLast:6.
        meta := true.
    ] ifFalse:[
        meta := false.
    ].
    self changeCurrentClass:(self findClassNamed:classString).
    currentClass notNil ifTrue:[
        meta ifTrue:[cls := currentClass theMetaclass] ifFalse:[cls := currentClass].
    ].
    actualClass := acceptClass := cls.

    currentClass isNil ifTrue:[
        self warn:'oops method is gone'
    ] ifFalse:[
        currentClassCategory := currentClass category.
        currentSelector := selectorString asSymbol.
        currentClass isJavaClass ifTrue:[
            currentMethod := currentClass compiledMethodAt:currentSelector.
            currentMethod isNil ifTrue:[
                currentClass methodDictionary keysAndValuesDo:[:sel :mthd |
                    mthd name = currentSelector ifTrue:[
                        currentMethod := mthd
                    ]       
                ].
            ]
        ] ifFalse:[
            currentMethod := actualClass compiledMethodAt:currentSelector.
        ].
        currentMethod isNil ifTrue:[
            self warn:'oops method is gone'
        ] ifFalse:[
            currentMethodCategory := currentMethod category.
        ].

        self methodSelectionChanged
    ].

    self setDoitActionForClass

    "Modified: / 31.8.1995 / 11:56:02 / claus"
    "Modified: / 17.6.1996 / 16:51:28 / stefan"
    "Modified: / 24.12.1999 / 02:10:45 / cg"
!

classNameFromClassMethodString:aString
    "helper for classMethod-list - extract the class name from the string"

    |s words clsName|

    s := aString string withoutSpaces.
    (s includes:${ ) ifTrue:[
        s := s copyTo:(s indexOf:${ ) - 1.
        s := s withoutSpaces.
    ].
    (s includes:$[ ) ifTrue:[
        s := s copyTo:(s indexOf:$[ ) - 1.
        s := s withoutSpaces.
    ].

"/ new code:
    words := s asCollectionOfWords.
    clsName := words at:1.
    words size > 2 ifTrue:[
        (words at:2) = 'class' ifTrue:[
            ^ clsName , ' class'
        ]
    ].
    ^ clsName.
"/ OLD code
"/
"/    (s endsWith:' !!') ifTrue:[
"/        s := s copyButLast:2
"/    ].
"/    (s endsWith:')') ifTrue:[
"/        s := aString copyTo:(aString lastIndexOf:$()-1.
"/        s := s withoutSpaces.
"/    ].
"/    (s endsWith:' !!') ifTrue:[
"/        s := s copyButLast:2
"/    ].
"/    pos := s lastIndexOf:(Character space).
"/    ^ s copyTo:(pos - 1)

    "Modified: / 17.6.1996 / 17:06:59 / stefan"
    "Created: / 3.3.1997 / 15:11:30 / cg"
    "Modified: / 16.10.1998 / 13:32:30 / cg"
!

selectorFromClassMethodString:aString
    "helper for classMethod-list - extract selector from the string"

    |pos s|

    s := aString string withoutSpaces.
    (s endsWith:'???') ifTrue:[
        s := s copyButLast:3.    "/ kludge
        s := s withoutSpaces.
    ].
    (s includes:${ ) ifTrue:[
        s := s copyTo:(s indexOf:${ ) - 1.
        s := s withoutSpaces.
    ].
    (s includes:$[ ) ifTrue:[
        s := s copyTo:(s indexOf:$[ ) - 1.
        s := s withoutSpaces.
    ].

    (s endsWith:' !!') ifTrue:[
        s := s copyButLast:2
    ].
    (s endsWith:')') ifTrue:[
        s := aString copyTo:(aString lastIndexOf:$()-1.
        s := s withoutSpaces.
    ].
    (s endsWith:' !!') ifTrue:[
        s := s copyButLast:2
    ].
    pos := s lastIndexOf:(Character space).
    s := s copyFrom:(pos + 1).
    s := s string.
    ^ s

    "Modified: 17.6.1996 / 17:04:38 / stefan"
    "Modified: 4.11.1996 / 23:57:00 / cg"
!

updateClassMethodListWithScroll:scroll keepSelection:keep
    |newList selection|

    newList := OrderedCollection new.
    selection := classMethodListView selection.

    "/ update the list, caring for traps.
    classMethodListView list do:[:entry |
        |cls sel mthd s icn|

        cls := self classFromClassMethodString:entry string.
        sel := self selectorFromClassMethodString:entry string.
        (cls isNil or:[sel isNil]) ifTrue:[
            "/ method is gone ?
            s := entry string.
            (s endsWith:'???') ifFalse:[
                s := s , ' ???'.
            ].
        ] ifFalse:[
            cls isJavaClass ifTrue:[
                s := entry.
"/                cls methodDictionary keysAndValuesDo:[:sel :mthd |
"/                    mthd name = sel ifTrue:[
"/                        newList add:(self listEntryForMethod:mthd selector:(cls name , ' ' , sel))
"/                    ]
"/                ]
            ] ifFalse:[
                mthd := cls compiledMethodAt:(sel asSymbol).
                s := cls name , ' ' , sel allBold.
                mthd isNil ifTrue:[
                    s := s , ' ???'
                ] ifFalse:[
                    ShowMethodCategoryInClassMethodList == true ifTrue:[
                        s := s , '  {' , mthd category allItalic, '}'
                    ].
                    s := (self 
                            listEntryForMethod:mthd 
                            selector:s)
                ]
            ].
        ].
        newList add:s.
    ].
    classMethodListView setList:newList.
    classMethodListView setSelection:selection.

    "Modified: / 18.12.1995 / 22:54:04 / stefan"
    "Created: / 3.3.1997 / 15:10:15 / cg"
    "Modified: / 17.10.1998 / 11:30:35 / cg"
! !

!BrowserView methodsFor:'event handling'!

handlesKeyPress:key inView:view
    "this method is reached via delegation: are we prepared to handle
     a keyPress in some other view ?"

    <resource: #keyboard (#Find #Cmdn #Cmdl #Cmdi #Cmds #Cmdg #Cmdt #Cmda #Cmdc #Cmdo)>

    |untranslatedKey|

    untranslatedKey := device keyboardMap keyAtValue:key ifAbsent:key.

    view == classCategoryListView ifTrue:[
        (key == #Find) ifTrue:[^ true].
        (untranslatedKey == #Cmdn) ifTrue:[^ true].
        (untranslatedKey == #Cmdc) ifTrue:[^ true].
        (untranslatedKey == #Cmdo) ifTrue:[^ true].
    ].

    view == classListView ifTrue:[
        (key == #Find) ifTrue:[^ true].
        (untranslatedKey == #Cmdn) ifTrue:[^ true].
        (untranslatedKey == #Cmdl) ifTrue:[^ true].
        (untranslatedKey == #Cmdd) ifTrue:[^ true].
    ].

    view == methodCategoryListView ifTrue:[
        (key == #Find) ifTrue:[^ true].
        (untranslatedKey == #Cmdn) ifTrue:[^ true].
    ].

    ((view == methodListView)
    or:[view == classMethodListView]) ifTrue:[
        (key == #Delete) ifTrue:[^ true].
        (untranslatedKey == #Cmdi) ifTrue:[^ true].
        (untranslatedKey == #Cmds) ifTrue:[^ true].
        (untranslatedKey == #Cmdg) ifTrue:[^ true].
        (untranslatedKey == #Cmdt) ifTrue:[^ true].
        (untranslatedKey == #Cmda) ifTrue:[^ true].
    ].

    ^ false

    "Created: / 2.3.1996 / 14:33:30 / cg"
    "Modified: / 16.1.1998 / 17:20:36 / stefan"
    "Modified: / 18.4.1998 / 15:54:15 / cg"
!

keyPress:key x:x y:y view:view
    "this method is reached via delegation from the classCategoryListView"

    <resource: #keyboard (#Find #Cmdn #Cmdl #Cmdi #Cmds #Cmdg #Cmdt #Cmda #Cmdc #Cmdo)>

    |untranslatedKey|

    "/
    "/ have to untranslate (since we get #Inspect / #Search
    "/
    untranslatedKey := device keyboardMap keyAtValue:key ifAbsent:key.

    view == classCategoryListView ifTrue:[
        (key == #Find) ifTrue:[^ self classCategoryFindClass].
        (untranslatedKey == #Cmdn) ifTrue:[^ self classCategoryNewCategory].
        (untranslatedKey == #Cmdc) ifTrue:[^ self browserClone].
        (untranslatedKey == #Cmdo) ifTrue:[^ self browserOpenInClass].
    ].

    view == classListView ifTrue:[
        (key == #Find) ifTrue:[^ self classCategoryFindClass].
        (untranslatedKey == #Cmdn) ifTrue:[^ self classNewClass].
        (untranslatedKey == #Cmdl) ifTrue:[^ self classLoad].
        (untranslatedKey == #Cmdd) ifTrue:[^ self classDocumentation].
    ].

    view == methodCategoryListView ifTrue:[
        (key == #Find) ifTrue:[
            currentClass isNil ifTrue:[ ^ self classCategoryFindMethod ].
            ^ self methodFindAnyMethod
        ].
        (untranslatedKey == #Cmdn) ifTrue:[^ self methodCategoryNewCategory].
    ].

    ((view == methodListView)
    or:[view == classMethodListView]) ifTrue:[
        (key == #Find) ifTrue:[
            currentClass isNil ifTrue:[ ^ self classCategoryFindMethod ].
            ^ self methodFindAnyMethod
        ].
        (key == #Delete) ifTrue:[^ self methodRemoveConfirmed].
        (untranslatedKey == #Cmdi) ifTrue:[^ self methodImplementors].
        (untranslatedKey == #Cmds) ifTrue:[^ self methodSenders].
        (untranslatedKey == #Cmdg) ifTrue:[^ self methodGlobalReferends].
        (untranslatedKey == #Cmdt) ifTrue:[^ self methodStringSearch].
        (untranslatedKey == #Cmda) ifTrue:[^ self methodAproposSearch].
    ].
    view keyPress:key x:x y:y

    "Created: / 2.3.1996 / 14:37:52 / cg"
    "Modified: / 16.1.1998 / 17:20:24 / stefan"
    "Modified: / 18.4.1998 / 15:56:36 / cg"
! !

!BrowserView methodsFor:'help'!

helpTextFor:aComponent
    |s|

    (aComponent == instanceToggle 
    or:[aComponent == classToggle]) ifTrue:[
        s := 'HELP_INST_CLASS_TOGGLE'
    ].
    aComponent == classMethodListView ifTrue:[
        s := 'HELP_CLSMTHOD_LIST'
    ].
    s notNil ifTrue:[
        ^ resources string:s
    ].
    ^ nil

    "Modified: 31.8.1995 / 19:11:39 / claus"
    "Modified: 28.6.1997 / 15:00:18 / cg"
! !

!BrowserView methodsFor:'initialization & release'!

autoSearch:aString
    "used with class-method list browsing. If true,
     selecting an entry from the list will automatically
     search for the searchstring in the codeView"

    self setSearchPattern:aString.
    autoSearchIgnoreCase := false.
    autoSearch := aString

    "Modified: / 18.6.1998 / 16:49:50 / cg"
!

autoSearch:aString ignoreCase:ign
    "used with class-method list browsing. If true,
     selecting an entry from the list will automatically
     search for the searchstring in the codeView"

    self setSearchPattern:aString.
    autoSearchIgnoreCase := ign.
    autoSearch := aString

    "Created: / 18.6.1998 / 16:49:59 / cg"
!

autoSearchVariable:aVariable 
    self autoSearchVariables:(Array with:aVariable)
!

autoSearchVariables:aCollectionOfVariables 
    self autoSearchVariables:aCollectionOfVariables readers:true writers:true
!

autoSearchVariables:aCollectionOfVariables readers:doReaders writers:doWriters
    self autoSearch:aCollectionOfVariables first
!

closeRequest
    "let user confirm, if codeView was modified and not saved"

    (self checkSelectionChangeAllowed) ifTrue:[
	super closeRequest
    ]

    "Created: / 3.8.1998 / 19:52:39 / cg"
    "Modified: / 3.8.1998 / 20:02:29 / cg"
!

closeRequestFor:aDialog
    "let user confirm, if codeView was modified and not saved"

    aDialog closeRequest
!

destroy
    "release dependant - destroy popups"

    self stopSyntaxHighlightProcess.

    self releaseMethod.
    Smalltalk removeDependent:self.
    currentClass notNil ifTrue:[
	self releaseClass.
	"/
	"/ just in case someone keeps a ref to myself around ...
	"/ ... release refs to my class (not really needed)
	"/
	currentClass := actualClass := acceptClass := nil
    ].
    super destroy

    "Modified: / 27.7.1998 / 11:02:52 / cg"
!

initialize
    super initialize.

    showInstance := true.
    showAllNamespaces := false.
    fullClass := false.
    fullProtocol := false.
    gotClassList := false.
    aspect := nil.
    currentNamespace := '* all *'.

    "inform me, when Smalltalk changes"
    Smalltalk addDependent:self.

    environment := Smalltalk.
!

postRealize
    |v checkBlock|

    super postRealize.

    checkBlock := [:lineNr | self checkSelectionChangeAllowed].

    v := classCategoryListView.
    v notNil ifTrue:[
	v action:[:lineNr | self classCategorySelection:lineNr].
	v selectConditionBlock:checkBlock.
	v ignoreReselect:false.
	v list size == 0 ifTrue:[
	    v list:(self listOfAllClassCategories).
	].
	"
	 tell classCategoryListView to ask for the menu
	"
	v menuHolder:self; menuPerformer:self; menuMessage:#classCategoryMenu.
    ].

    v := classListView.
    v notNil ifTrue:[
	v action:[:lineNr | self classSelection:lineNr].
	v doubleClickAction:[:lineNr | self classDoubleClick:lineNr].
	v selectConditionBlock:checkBlock.
	v ignoreReselect:false.
	"
	 tell classListView to ask for the menu
	"
	v menuHolder:self; menuPerformer:self; menuMessage:#classMenu.
    ].

    v := methodCategoryListView.
    v notNil ifTrue:[
	v action:[:lineNr | self methodCategorySelection:lineNr].
	v selectConditionBlock:checkBlock.
	v ignoreReselect:false.
	"
	 tell methodCategoryListView to ask for the menu
	"
	v menuHolder:self; menuPerformer:self; menuMessage:#methodCategoryMenu.
    ].

    v := methodListView.
    v notNil ifTrue:[
	v action:[:lineNr | self methodSelection:lineNr].
	v doubleClickAction:[:lineNr | self methodDoubleClick:lineNr].
	v selectConditionBlock:checkBlock.
	v ignoreReselect:false.
	"
	 tell methodListView to ask for the menu
	"
	v menuHolder:self; menuPerformer:self; menuMessage:#methodMenu.
    ].

    v := classMethodListView.
    v notNil ifTrue:[
	v action:[:lineNr | self classMethodSelection:lineNr].
	v selectConditionBlock:checkBlock.
	v ignoreReselect:false.
	"
	 tell classMethodListView to ask for the menu
	"
	v menuHolder:self; menuPerformer:self; menuMessage:#classMethodMenu.
    ].

    v := variableListView.
    v notNil ifTrue:[
	v action:[:lineNr | self variableSelection:lineNr].
	v ignoreReselect:false.
	v toggleSelect:true.
	v menuHolder:self; menuPerformer:self; menuMessage:#variableListMenu.
    ].

    "
     normal browsers show the top/selection at first;
     fullProtocol browsers better show the end initially
    "
    fullProtocol ifTrue:[
	classListView scrollToBottom.
    ]

    "Created: / 24.7.1997 / 18:14:59 / cg"
    "Modified: / 29.10.1997 / 15:50:26 / cg"
!

title:someString
    myLabel := someString.
    self topView label:someString.

    "Modified: 18.8.1997 / 15:19:50 / cg"
! !

!BrowserView methodsFor:'initialize subviews'!

createClassListViewIn:frame
    "setup the classlist subview, a variableList view and the class/inst toggles"

    |v panel spc wScr wScrHalf|

    self createTogglesIn:frame.

    panel := VariableVerticalPanel
                    origin:(0.0 @ 0.0) corner:(1.0 @ 1.0)
                    in:frame.
    styleSheet is3D ifTrue:[
        spc := ViewSpacing.
    ] ifFalse:[
        spc := 0
    ].
    panel bottomInset:(instanceToggle height + spc + instanceToggle borderWidth).

    v := HVScrollableView 
                for:SelectionInListView 
                miniScrollerH:true miniScrollerV:false
                in:panel.
    v autoHideHorizontalScrollBar:true.
    v origin:(0.0 @ 0.0) corner:(1.0 @ 0.7).
    classListView := v scrolledView.
    classListView delegate:self.

    v := HVScrollableView 
                for:SelectionInListView 
                miniScrollerH:true miniScrollerV:false
                in:panel.
    v autoHideHorizontalScrollBar:true.
    v origin:(0.0 @ 0.7) corner:(1.0 @ 1.0).

    variableListView := v scrolledView.
    variableListView delegate:self.
    variableListView toggleSelect:true.

    wScr := v scrollBar preferredWidth.
    wScrHalf := wScr // 2.

"/    (styleSheet at:'scrollBarPosition' default:#right) == #right ifTrue:[
"/        classToggle rightInset:(classToggle rightInset + wScr).
"/        classToggle leftInset:(classToggle leftInset - wScrHalf).
"/        instanceToggle rightInset:(instanceToggle rightInset + wScrHalf)
"/    ].

    "Modified: 19.3.1997 / 17:38:07 / cg"
!

createCodeViewIn:aView
    "setup the code view"

    ^ self createCodeViewIn:aView atY:0.25

    "Modified: 2.3.1996 / 16:08:46 / cg"
!

createCodeViewIn:aView atY:relY
    "setup the code view"
    |v|

    v := HVScrollableView for:CodeView miniScrollerH:true miniScrollerV:false in:aView.
    v origin:(0.0 @ relY) corner:(1.0 @ 1.0).
    codeView := v scrolledView

    "Created: 2.3.1996 / 16:09:03 / cg"
!

createMethodListViewIn:aView atX:relX
    "setup the method list view"
    |v|

    v := HVScrollableView for:SelectionInListView miniScrollerH:true miniScrollerV:false in:aView.
    v origin:(relX @ 0.0) corner:(1.0 @ 1.0).
    methodListView := v scrolledView.
    methodListView delegate:self.
    ^ v

    "Created: 2.3.1996 / 16:07:10 / cg"
    "Modified: 2.3.1996 / 16:11:42 / cg"
!

createTogglesIn:aFrame
    "create and setup the class/instance toggles"

    |h halfSpace classAction instanceAction|

    classAction := [self instanceProtocol:false].
    instanceAction := [self instanceProtocol:true].

    halfSpace := ViewSpacing // 2.

    instanceToggle := "Toggle" RadioButton label:(resources string:'Instance') in:aFrame.
    h := instanceToggle heightIncludingBorder.
    instanceToggle origin:(0.0 @ 1.0) corner:(0.5 @ 1.0).
    instanceToggle topInset:h negated.

    instanceToggle turnOn.
    instanceToggle controller beToggle.
    instanceToggle pressAction:instanceAction.
    instanceToggle releaseAction:classAction.

    classToggle := "Toggle" RadioButton label:(resources string:'Class') in:aFrame.
    h := classToggle heightIncludingBorder.
    classToggle origin:(0.5 @ 1.0) corner:(1.0 @ 1.0).
    classToggle topInset:h negated.

    classToggle turnOff.
    classToggle controller beToggle.
    classToggle pressAction:classAction.
    classToggle releaseAction:instanceAction.

    styleSheet is3D ifTrue:[
"/        instanceToggle bottomInset:halfSpace.
"/        classToggle bottomInset:halfSpace.

        instanceToggle leftInset:halfSpace.
        classToggle leftInset:halfSpace.
        instanceToggle rightInset:ViewSpacing - halfSpace.
        classToggle rightInset:ViewSpacing - halfSpace.

"/ no longer needed; changed to use RadioButtons instead of Toggle
"/        styleSheet name == #motif ifTrue:[
"/            instanceToggle showLamp:true.
"/            classToggle showLamp:true.
"/        ]
    ].

    "Modified: / 30.8.1998 / 22:53:55 / cg"
!

pullDownMenu
    "return the top (pullDown) menu"

    <resource: #programMenu>

    ^ self menuFromSpec:self class menuSpec.
"/
"/    |m|
"/
"/    m := self class menuSpec.
"/    m := m decodeAsLiteralArray.
"/    m receiver:self.
"/    m findGuiResourcesIn:self.
"/    ^ m.
!

setupForAll
    "create subviews for a full browser"

    |vpanel hpanel frame v spc nsHolder hMax menuPanel mH
     topFraction|

    topFraction := 0.3.

    styleSheet is3D ifTrue:[
        spc := ViewSpacing.
    ] ifFalse:[
        spc := 0
    ].

    menuPanel := MenuPanel in:self.
    "/ menuPanel level:1.
    menuPanel verticalLayout:false.
    menuPanel receiver:self.
    menuPanel menu:(self pullDownMenu).
    mH := menuPanel preferredHeight.
    menuPanel origin:(0.0 @ 0.0) corner:(1.0 @ (mH)).

    vpanel := VariableVerticalPanel 
                origin:(0.0 @ (mH + 1)) corner:(1.0 @ 1.0) in:self.
    vpanel snapMode:#both.

    hpanel := View origin:(0.0 @ 0.0) corner:(1.0 @ topFraction) in:vpanel.

    v := HVScrollableView for:SelectionInListView
                          miniScrollerH:true miniScrollerV:false
                          in:hpanel.
    v origin:(0.0 @ 0.0) corner:(0.25 @ 1.0).
    styleSheet isWindowsStyle ifTrue:[v rightInset:1].
    classCategoryListView := v scrolledView.
    classCategoryListView delegate:self.

    frame := View origin:(0.25 @ 0.0) corner:(0.5 @ 1.0) in:hpanel.
    styleSheet isWindowsStyle ifTrue:[frame rightInset:1].
    self createClassListViewIn:frame.

    (environment isNil or:[environment hasNameSpaces]) ifTrue:[
        namespaceList := ComboListView origin:(0.0@1.0) corner:(0.25@1.0) in:hpanel.

        hMax := (instanceToggle height + instanceToggle borderWidth)
                max:(namespaceList preferredHeight).
        "/ hMax := hMax "+ (spc // 2)".

        v bottomInset:hMax + (spc - (spc // 2)).
        nsHolder := currentNamespace asValue.

        namespaceList topInset:(hMax negated) "- (spc//2)" "+ (spc // 2)".
        styleSheet name ~= 'win95' ifTrue:[
            namespaceList leftInset:(ViewSpacing // 2).
        ].
"/    namespaceList bottomInset:(spc // 2).

"/    styleSheet is3D ifTrue:[
"/        namespaceList leftInset:(classCategoryListView originRelativeTo:v) x.
"/    ].

"/    (v scrollBar originRelativeTo:v) > (classCategoryListView originRelativeTo:v)
"/    ifTrue:[
"/        namespaceList rightInset:((v scrollBar originRelativeTo:v)
"/                                  -
"/                                  (classCategoryListView originRelativeTo:v))
"/    ] ifFalse:[
"/        styleSheet is3D ifTrue:[
"/            namespaceList rightInset:(ViewSpacing // 2).
"/        ]
"/    ].

"/        styleSheet is3D ifTrue:[
"/            namespaceList rightInset:(ViewSpacing // 2).
"/        ].

        self setListOfNamespaces.
        namespaceList model:nsHolder.
        namespaceList label menuHolder:self; menuMessage:#nameSpaceMenu.
        nsHolder onChangeEvaluate:[
                                    self changeNameSpaceTo:nsHolder value
                                  ].
    ].

    v := HVScrollableView for:SelectionInListView miniScrollerH:true miniScrollerV:false in:hpanel.
    v origin:(0.5 @ 0.0) corner:(0.75 @ 1.0).
    styleSheet isWindowsStyle ifTrue:[v rightInset:1].
    methodCategoryListView := v scrolledView.
    methodCategoryListView delegate:self.

    self createMethodListViewIn:hpanel atX:0.75.

    self createCodeViewIn:vpanel atY:topFraction

    "Modified: / 11.10.2001 / 21:20:21 / cg"
!

setupForClass:aClass
    "create subviews for browsing a single class"

    |vpanel hpanel frame v topFraction|

    topFraction := 0.3.

    vpanel := VariableVerticalPanel origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:self.
    vpanel snapMode:#both.

    hpanel := View origin:(0.0 @ 0.0) corner:(1.0 @ topFraction) in:vpanel.
    frame := View origin:(0.0 @ 0.0) corner:(0.5 @ 1.0)in:hpanel.
    styleSheet isWindowsStyle ifTrue:[frame rightInset:1].

    self createTogglesIn:frame.

    v := ScrollableView for:SelectionInListView in:frame.
    v origin:(0.0 @ 0.0)
      extent:[frame width
              @
              (frame height 
               - ViewSpacing
               - instanceToggle height
               - instanceToggle borderWidth
               + v borderWidth)].
    methodCategoryListView := v scrolledView.
    methodCategoryListView delegate:self.

    self createMethodListViewIn:hpanel atX:0.5.
    self createCodeViewIn:vpanel atY:topFraction.

    self changeCurrentClass:aClass.
    actualClass := acceptClass := aClass.
    self updateMethodCategoryList.
    self updateMethodList.
    self updateCodeView.
    self classDefinition.

    "Modified: / 15.9.1998 / 22:20:33 / cg"
!

setupForClass:aClass methodCategory:aMethodCategory
    "setup subviews to browse a method category"

    |vpanel v topFraction|

    topFraction := 0.3.

    vpanel := VariableVerticalPanel origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:self.
    vpanel snapMode:#both.

    v := self createMethodListViewIn:vpanel atX:0.0.
    v corner:(1.0 @ topFraction).

    self createCodeViewIn:vpanel atY:topFraction.

    currentClassCategory := aClass category.
    self changeCurrentClass:aClass.
    actualClass := acceptClass := aClass.
    currentMethodCategory := aMethodCategory.
    self updateMethodList.
    self updateCodeView.

    "Modified: / 10.4.1998 / 12:25:52 / cg"
!

setupForClass:aClass selector:selector
    "setup subviews to browse a single method"

    |v|

    v := ScrollableView for:CodeView in:self.
    v origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    codeView := v scrolledView.

    currentClassCategory := aClass category.
    self changeCurrentClass:aClass.
    actualClass := acceptClass := aClass.
    currentSelector := selector.
    currentMethod := actualClass compiledMethodAt:selector.
    currentMethod notNil ifTrue:[
        currentMethodCategory := currentMethod category.
    ].
    self updateCodeView

    "Modified: / 10.4.1998 / 12:25:55 / cg"
!

setupForClassCategory:aClassCategory
    "setup subviews to browse a class category"

    |vpanel hpanel frame v topFraction|

    topFraction := 0.4.

    vpanel := VariableVerticalPanel origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:self.
    vpanel snapMode:#both.

    hpanel := View origin:(0.0 @ 0.0) corner:(1.0 @ topFraction) in:vpanel.
    frame  := View origin:(0.0 @ 0.0) corner:(0.33 @ 1.0) in:hpanel.
    styleSheet isWindowsStyle ifTrue:[frame rightInset:1].

    self createClassListViewIn:frame.

    v := ScrollableView for:SelectionInListView in:hpanel.
    v origin:(0.33 @ 0.0) corner:(0.66 @ 1.0).
    styleSheet isWindowsStyle ifTrue:[v rightInset:1].
    methodCategoryListView := v scrolledView.
    methodCategoryListView delegate:self.

    self createMethodListViewIn:hpanel atX:0.66.
    self createCodeViewIn:vpanel atY:topFraction.

    currentClassCategory := aClassCategory.
    self updateClassList.
    self updateMethodCategoryList.
    self updateMethodList.
    self updateCodeView

    "Modified: / 15.9.1998 / 22:16:45 / cg"
!

setupForClassHierarchy:aClass
    "setup subviews to browse a class hierarchy"

    |vpanel hpanel frame v cls topFraction|

    topFraction := 0.4.

    vpanel := VariableVerticalPanel origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:self.
    vpanel snapMode:#both.

    "
     notice: we use a different ratio here
    "
    hpanel := View origin:(0.0 @ 0.0) corner:(1.0 @ topFraction) in:vpanel.
    frame := View origin:(0.0 @ 0.0) corner:(0.33 @ 1.0) in:hpanel.
    styleSheet isWindowsStyle ifTrue:[frame rightInset:1].

    self createClassListViewIn:frame.

    v := ScrollableView for:SelectionInListView in:hpanel.
    v origin:(0.33 @ 0.0) corner:(0.66 @ 1.0).
    styleSheet isWindowsStyle ifTrue:[v rightInset:1].
    methodCategoryListView := v scrolledView.
    methodCategoryListView delegate:self.

    self createMethodListViewIn:hpanel atX:0.66.
    self createCodeViewIn:vpanel atY:topFraction.

    cls := aClass theNonMetaclass.
    currentClassHierarchy := currentClass := actualClass := cls.
    self updateClassList.
    classListView setSelectElement:aClass name; makeSelectionVisible.
    self updateMethodCategoryList.
    self updateMethodList.
    self updateCodeView.

    aClass isMeta ifTrue:[
        self instanceProtocol:false
    ].

    "Modified: / 5.11.2001 / 16:33:43 / cg"
!

setupForClassList:aList
    "setup subviews to browse classes from a list"

    self setupForClassList:aList sort:true

    "Modified: 28.5.1996 / 13:53:03 / cg"
!

setupForClassList:aList sort:doSort
    "setup subviews to browse classes from a list"

    |vpanel hpanel frame l v topFraction|

    topFraction := 0.3.

    vpanel := VariableVerticalPanel origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:self.
    vpanel snapMode:#both.

    hpanel := View origin:(0.0 @ 0.0) corner:(1.0 @ topFraction) in:vpanel.
    frame := View origin:(0.0 @ 0.0) corner:(0.33 @ 1.0) in:hpanel.
    styleSheet isWindowsStyle ifTrue:[frame rightInset:1].

    self createClassListViewIn:frame.

    v := ScrollableView for:SelectionInListView in:hpanel.
    v origin:(0.33 @ 0.0) corner:(0.66 @ 1.0).
    styleSheet isWindowsStyle ifTrue:[v rightInset:1].
    methodCategoryListView := v scrolledView.
    methodCategoryListView delegate:self.

    self createMethodListViewIn:hpanel atX:0.66.
    self createCodeViewIn:vpanel atY:topFraction.

    l := (aList collect:[:entry | 
                entry isBehavior ifTrue:[
                    entry name
                ] ifFalse:[
                    entry
                ]]) asOrderedCollection.
    doSort ifTrue:[
        l sort.
    ].
    classListView list:l.
    gotClassList := true.

    self updateMethodCategoryList.
    self updateMethodList.
    self updateCodeView

    "Created: / 28.5.1996 / 13:52:47 / cg"
    "Modified: / 15.9.1998 / 22:21:25 / cg"
!

setupForFullClass
    "setup subviews to browse a class as full text"

    |vpanel hpanel v topFraction|

    topFraction := 0.3.

    vpanel := VariableVerticalPanel origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:self.
    vpanel snapMode:#both.

    hpanel := View origin:(0.0 @ 0.0) corner:(1.0 @ topFraction) in:vpanel.

    v := ScrollableView for:SelectionInListView in:hpanel.
    v origin:(0.0 @ 0.0) corner:(0.5 @ 1.0).
    styleSheet isWindowsStyle ifTrue:[v rightInset:1].
    classCategoryListView := v scrolledView.
    classCategoryListView contents:(self listOfAllClassCategories).

    v := ScrollableView for:SelectionInListView in:hpanel.
    v origin:(0.5 @ 0.0) corner:(1.0 @ 1.0).
    classListView := v scrolledView.

    self createCodeViewIn:vpanel atY:topFraction.

    fullClass := true.
    self updateCodeView

    "Modified: / 15.9.1998 / 22:17:48 / cg"
!

setupForFullClassProtocol:aClass
    "setup subviews to browse a classes full protocol"

    |vpanel hpanel frame v cls topFraction|

    topFraction := 0.4.

    vpanel := VariableVerticalPanel origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:self.
    vpanel snapMode:#both.

    "
     notice: we use a different ratio here
    "
    hpanel := View origin:(0.0 @ 0.0) corner:(1.0 @ topFraction) in:vpanel.
    frame := View origin:(0.0 @ 0.0) corner:(0.33 @ 1.0) in:hpanel.
    styleSheet isWindowsStyle ifTrue:[frame rightInset:1].

    self createClassListViewIn:frame.
    classListView multipleSelectOk:true.
    classListView toggleSelect:true.
    classListView strikeout:true.

    v := ScrollableView for:SelectionInListView in:hpanel.
    v origin:(0.33 @ 0.0) corner:(0.66 @ 1.0).
    styleSheet isWindowsStyle ifTrue:[v rightInset:1].
    methodCategoryListView := v scrolledView.
    methodCategoryListView delegate:self.

    self createMethodListViewIn:hpanel atX:0.66.
    self createCodeViewIn:vpanel atY:topFraction.

    cls := aClass theNonMetaclass.
    currentClassHierarchy := actualClass := acceptClass := currentClass := cls.
    fullProtocol := true.

    self updateClassList.
    self updateMethodCategoryList.
    self updateMethodList.
    self updateCodeView.
    self updateVariableList.
    aClass isMeta ifTrue:[
        self instanceProtocol:false
    ].

    "Modified: / 5.11.2001 / 16:33:55 / cg"
!

setupForList:aList
    "setup subviews to browse methods from a list"

    |vpanel v topFraction|

    topFraction := 0.3.

    vpanel := VariableVerticalPanel origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:self.
    vpanel snapMode:#both.

    v := ScrollableView for:SelectionInListView in:vpanel.
    v origin:(0.0 @ 0.0) corner:(1.0 @ topFraction).
    classMethodListView := v scrolledView.
    classMethodListView contents:aList.
    classMethodListView delegate:self.

    classMethodListView doubleClickAction:[:lineNr | self classMethodBrowse].

    self createCodeViewIn:vpanel atY:topFraction.
    aList size == 1 ifTrue:[
        classMethodListView setSelection:1.
        self classMethodSelection:1. 
    ].
    self updateCodeView.
    "/ kludge - get trap icons
    self updateClassMethodListWithScroll:false keepSelection:true

    "Modified: / 25.10.1997 / 19:27:40 / cg"
! !

!BrowserView methodsFor:'method category list menu'!

createAccessMethodsFor:aCollectionOfInstVarNames withChange:withChange
    "workhorse for creating access methods for instvars."

    SmalltalkCodeGeneratorTool
        createAccessMethodsFor:aCollectionOfInstVarNames 
        in:currentClass theNonMetaclass 
        withChange:withChange 
        asValueHolder:false
        readersOnly:false 
        writersOnly:false.

    "Modified: / 31-01-2011 / 18:28:27 / cg"
!

methodCategoryCopyCategory
    "show the enter box to copy from an existing method category"

    |title box|

    showInstance ifTrue:[
        title := 'Class to copy instance method category from:'
    ] ifFalse:[
        title := 'Class to copy class method category from:'
    ].

    box := self listBoxTitle:title 
                      okText:'OK' 
                        list:(environment allClasses collect:[:cls | cls name]) asArray sort.

    box label:(resources string:'Copy methods').
    box action:[:aString | self copyMethodsFromClass:aString].
    box open

    "Modified: / 12.10.2001 / 19:48:49 / cg"
!

methodCategoryCreateAccessMethods
    "create access methods for instvars.
     If no variable is selected, for all instvars;
     otherwise for that selected instvar."

    self methodCategoryCreateAccessMethodsWithChange:false

    "Modified: / 7.8.1998 / 18:17:34 / cg"
!

methodCategoryCreateAccessMethodsWithChange
    "create access methods for instvars.
     If no variable is selected, for all instvars;
     otherwise for that selected instvar."

    self methodCategoryCreateAccessMethodsWithChange:true

    "Modified: / 7.8.1998 / 18:17:39 / cg"
!

methodCategoryCreateAccessMethodsWithChange:aBoolean
    "create access methods for instvars.
     If no variable is selected, for all instvars;
     otherwise for that selected instvar."

    self checkClassSelected ifFalse:[^ self].

    showInstance ifFalse:[
        self warn:'select instance - and try again'.
        ^ self.
    ].

    self withWaitCursorDo:[
        |nm names|

        (variableListView notNil
        and:[(nm := variableListView selectionValue) notNil]) ifTrue:[
            names := Array with:nm
        ] ifFalse:[
            names := currentClass instVarNames 
        ].

        lockUpdates := true.
        [
            self createAccessMethodsFor:names withChange:aBoolean.
        ] ifCurtailed:[
            lockUpdates := false
        ].
        self updateMethodCategoryListWithScroll:false.
        self updateMethodListWithScroll:false
    ]

    "Modified: / 18.8.1997 / 15:44:10 / cg"
    "Created: / 7.8.1998 / 18:17:18 / cg"
!

methodCategoryCreateApplicationMethods
    "create an empty application framework"

    self checkClassSelected ifFalse:[^ self].
    SmalltalkCodeGeneratorTool createApplicationCodeFor:currentClass.

    "Modified: / 31-01-2011 / 18:28:29 / cg"
!

methodCategoryCreateDocumentationMethods
    "create empty documentation methods"

    |metaClass|

    self checkClassSelected ifFalse:[^ self].

    metaClass := currentClass theMetaclass.
    self withWaitCursorDo:[
        SmalltalkCodeGeneratorTool createDocumentationMethodsFor:metaClass.
        SmalltalkCodeGeneratorTool createExamplesMethodFor:metaClass.

        self instanceProtocol:false.
        self switchToMethodNamed:#documentation 
    ]

    "Modified: / 31-01-2011 / 18:28:32 / cg"
!

methodCategoryCreateUpdateMethod
    "create an update:with:from: method
     (I'm tired of typing)"

    self checkClassSelected ifFalse:[^ self].
    (actualClass includesSelector:#'update:with:from:') ifTrue:[
        self warn:'class already implements #update:with:from:\\No code generated.' withCRs.    
        ^ self
    ].

    self withWaitCursorDo:[
        SmalltalkCodeGeneratorTool createUpdateMethodIn:actualClass.
        self instanceProtocol:true.
        self switchToMethodNamed:#'update:with:from:' 
    ]

    "Modified: / 31-01-2011 / 18:28:35 / cg"
!

methodCategoryFileOut
    "fileOut all methods in the selected methodcategory of
     the current class"

    self checkClassSelected ifFalse:[^ self].
    self whenMethodCategorySelected:[
        self busyLabel:'saving: %1' with:currentClass name , '-' , currentMethodCategory.
        Class fileOutErrorSignal handle:[:ex |
            self warn:'cannot create: %1' with:ex parameter.
            self normalLabel.
            ex return.
        ] do:[
            actualClass fileOutCategory:currentMethodCategory.
        ].
        self normalLabel.
    ]
!

methodCategoryFileOutAll
    "fileOut all methods in the selected methodcategory of
     the current class"


    self whenMethodCategorySelected:[
        |fileName outStream|

        fileName := (currentMethodCategory , '.st') asFilename.
        fileName makeLegalFilename.
        "
         this test allows a smalltalk to be built without Projects/ChangeSets
        "
        Project notNil ifTrue:[
            fileName := Project currentProjectDirectory asFilename construct: fileName name.
        ].
        "
         if file exists, save original in a .sav file
        "
        fileName exists ifTrue:[
            fileName copyTo:(fileName withSuffix: 'sav')
        ].

        [
            outStream := fileName newReadWriteStream.
        ] on:FileStream openErrorSignal do:[:ex|
            ^ self warn:'cannot create: %1' with:fileName pathName
        ].

        self busyLabel:'saving: ' with:currentMethodCategory.
        Class fileOutErrorSignal handle:[:ex |
            self warn:'cannot create: %1' with:ex parameter.
            ex return
        ] do:[
            environment allClassesDo:[:class |
                |hasMethodsInThisCategory|

                hasMethodsInThisCategory := false.
                class methodDictionary do:[:method |
                    method category = currentMethodCategory ifTrue:[
                        hasMethodsInThisCategory := true
                    ]
                ].
                hasMethodsInThisCategory ifTrue:[
                    class fileOutCategory:currentMethodCategory on:outStream.
                    outStream cr
                ].
                hasMethodsInThisCategory := false.
                class theMetaclass methodDictionary do:[:method |
                    method category = currentMethodCategory ifTrue:[
                        hasMethodsInThisCategory := true
                    ]
                ].
                hasMethodsInThisCategory ifTrue:[
                    class theMetaclass fileOutCategory:currentMethodCategory on:outStream.
                    outStream cr
                ]
            ].
        ].
        outStream close.
        self normalLabel.
    ].

    "Modified: / 7.6.1996 / 09:03:56 / stefan"
    "Modified: / 28.10.1997 / 14:37:32 / cg"
!

methodCategoryMenu
    <resource: #keyboard (#Cmdn)>
    <resource: #programMenu >

    |items m varSel s1 s2 codeMenu disableFlag|

    currentClass isNil ifTrue:[
        methodCategoryListView flash.
        ^ nil
    ].


    currentClass isLoaded ifTrue:[
        disableFlag := false.
        showInstance ifFalse:[
            items := #( 
                        ( 'Documentation Stubs' methodCategoryCreateDocumentationMethods)
                     ).

            (currentClass isSubclassOf:ApplicationModel) ifTrue:[
                (currentClass isSubclassOf:SimpleDialog) ifTrue:[
                        items := items , #( 
                                ( 'Initial Dialog Code' methodCategoryCreateApplicationMethods)
                             ).
                ] ifFalse:[
"/                ((currentClass class implements:#windowSpec)
"/                and:[currentClass class implements:#mainMenu]) ifFalse:[
                        items := items , #( 
                                ( 'Initial Application Code' methodCategoryCreateApplicationMethods)
                             ).
"/                    ]
                ]
            ] 
        ] ifTrue:[
            (variableListView notNil
            and:[(varSel := variableListView selectionValue) notNil]) ifTrue:[
                s1 := 'Access Methods (for ''%1'')'. 
                s2 := 'Access Methods with Change Notification (for ''%1'')'. 
            ] ifFalse:[
                s1 := 'Access Methods (for All)'. 
                s2 := 'Access Methods with Change Notification (for All)'. 
                disableFlag := currentClass instVarNames size == 0
            ].
            s1 := resources string:s1 with:varSel.
            s2 := resources string:s2 with:varSel.
            items := Array with:(Array 
                                    with:s1 
                                    with:#methodCategoryCreateAccessMethods)
                           with:(Array 
                                    with:s2 
                                    with:#methodCategoryCreateAccessMethodsWithChange).

            items := items , #( 
                        ( 'Standard Update Method Template' methodCategoryCreateUpdateMethod)
                     ).
        ].
        codeMenu := PopUpMenu itemList:items resources:resources.

        disableFlag ifTrue:[
            codeMenu disableAll:#(methodCategoryCreateAccessMethods methodCategoryCreateAccessMethodsWithChange).
        ].
        (actualClass includesSelector:#'update:with:from:') ifTrue:[
            codeMenu disable:#methodCategoryCreateUpdateMethod
        ]
    ].

    currentMethodCategory notNil ifTrue:[
        items := #(
                    ('FileOut'               methodCategoryFileOut        )
                    ('FileOut all'           methodCategoryFileOutAll     )
                    ('PrintOut'              methodCategoryPrintOut       )
                    ('-'                                                  )
                    ('SPAWN_METHODCATEGORY'  methodCategorySpawn          )
                    ('Spawn Category...'     methodCategorySpawnCategory  )
                 ).
    ] ifFalse:[
        items := #().
    ].

    items size > 0 ifTrue:[
    items := items , #(
                    ('-'                               )
               ).                                                       
    ].
    items := items , #(
                ('New Category...'        methodCategoryNewCategory     Cmdn )
                ('Copy Category...'       methodCategoryCopyCategory    )
               ).                                                       

    currentMethodCategory notNil ifTrue:[
        items := items , #(
                    ('-'                               )
                    ('Rename...'  methodCategoryRename )
                    ('Remove...'  methodCategoryRemove )
                   ).
    ].

    codeMenu notNil ifTrue:[
        items := items , #(
                        ('-'                      )
                        ('Generate' codeMenu)
                  ).
    ].

    m := PopUpMenu 
        itemList:items
        resources:resources.

    currentClass isLoaded ifFalse:[
        m disableAll:#(
                        methodCategoryNewCategory
                        methodCategoryCopyCategory
                        methodCategoryCreateAccessMethods
                        methodCategoryFindMethod
                      )
    ].

    codeMenu notNil ifTrue:[
        m subMenuAt:#codeMenu put:codeMenu.
    ].

    self isReadOnlyEnvironment ifTrue:[
        m disableAll:#(methodCategoryNewCategory methodCategoryCreateAccessMethods methodCategoryRemove
                       methodCategoryRename codeMenu methodCategoryCopyCategory
                      )
    ].

    ^ m

    "Modified: / 10.2.2000 / 13:38:58 / cg"
!

methodCategoryNewCategory
    "show the enter box to add a new method category.
     Offer existing superclass categories in box to help avoiding
     useless typing."

    |someCategories existingCategories box superclass|

    actualClass notNil ifTrue:[
        someCategories := actualClass allCategories asNewSet.
        (superclass := actualClass superclass) notNil ifTrue:[
            superclass allSubclasses do:[:cls |
                someCategories addAll:cls categories
            ]
        ].
        someCategories := someCategories asOrderedCollection
    ] ifFalse:[
        "
         mhmh - offer some typical categories ...
        "
        showInstance ifTrue:[
            someCategories := #('accessing' 
                                'initialization'
                                'private' 
                                'printing & storing'
                                'queries'
                                'testing'
                               )
        ] ifFalse:[
            someCategories := #(
                                'documentation'
                                'initialization'
                                'instance creation'
                               ).
        ].
    ].
    someCategories sort.

    "
     remove existing categories
    "
    existingCategories := methodCategoryListView list.
    existingCategories notNil ifTrue:[
        someCategories := someCategories reject:[:cat | existingCategories includes:cat].
    ].
    someCategories := someCategories asSet asOrderedCollection sort.

    box := self listBoxTitle:'Name of new method category:'
                      okText:'Create'
                        list:someCategories.
    box label:(resources string:'Create category').
    box initialText:lastCategory.
    box action:[:aString | self newMethodCategory:aString. lastCategory := aString].
    box open

    "Modified: / 11-07-2010 / 16:36:23 / cg"
!

methodCategoryPrintOut
    |printStream|

    self checkClassSelected ifFalse:[^ self].
    self whenMethodCategorySelected:[
        printStream := Printer new.
        actualClass printOutCategory:currentMethodCategory on:printStream.
        printStream close
    ]
!

methodCategoryRemove
    "show number of methods to remove and query user"

    |t box sels count answer|

    currentMethodCategory notNil ifTrue:[
        sels := OrderedCollection new.
        actualClass methodDictionary keysAndValuesDo:[:selector :aMethod |
            (aMethod category = currentMethodCategory) ifTrue:[
                sels add:selector
            ]
        ].
        count := sels size.
        (count ~~ 0) ifTrue:[
            (count == 1) ifTrue:[
                t := 'Remove the method in category ''%1'' ?'
            ] ifFalse:[
                t := 'Remove all %2 methods in category ''%1'' ?'
            ].
            t := resources string:t 
                        with:currentMethodCategory allBold
                        with:count printString.
            t := t withCRs.

            box := YesNoBox 
                       title:t
                       yesText:(resources string:'Remove')
                       noText:(resources string:'Abort').
            answer := box confirm.
            box destroy.
            answer ifFalse:[
                ^ self.
            ].
            sels do:[:selector|
                actualClass removeSelector:selector.
            ].
        ].
        currentMethodCategory := nil.
        self releaseMethod.
        self updateMethodCategoryListWithScroll:false.
        self updateMethodList
    ]

    "Modified: / 7.6.1996 / 09:13:15 / stefan"
    "Modified: / 17.11.2001 / 23:12:40 / cg"
!

methodCategoryRename
    "launch an enterBox to rename current method category"

    |box suggestion last|

    self checkMethodCategorySelected ifFalse:[^ self].

    LastRenames isNil ifTrue:[
        LastRenames := OrderedCollection new.
    ].
    last := LastRenames detect:[:ren | ren key = currentMethodCategory] ifNone:nil.
    last notNil ifTrue:[
        suggestion := last value
    ] ifFalse:[
        suggestion := currentMethodCategory
    ].

    box := self 
                enterBoxTitle:(resources string:'Rename method category ''%1'' to:' 
                                           with:currentMethodCategory allBold)
                okText:'Rename'
                label:'Rename category'.

    box initialText:suggestion.
    box action:[:aString | 
        aString ~= currentMethodCategory ifTrue:[
            LastRenames := LastRenames select:[:ren | ren key ~= currentMethodCategory].
            LastRenames addLast:(currentMethodCategory -> aString).
            LastRenames size > 20 ifTrue:[LastRenames removeFirst].

            actualClass renameCategory:currentMethodCategory to:aString.
            currentMethodCategory := aString.
            self releaseMethod.
            self updateMethodCategoryList.
            self updateMethodListWithScroll:false
        ]
    ].
    box open

    "Modified: / 12.10.2001 / 19:47:59 / cg"
!

methodCategorySpawn
    "create a new SystemBrowser browsing current method category"

    currentMethodCategory notNil ifTrue:[
        self withWaitCursorDo:[
            |brwsr|

            brwsr := SystemBrowser browseClass:actualClass
                                   methodCategory:currentMethodCategory.
            brwsr environment:environment
        ]
    ]

    "Modified: 18.8.1997 / 15:44:18 / cg"
!

methodCategorySpawnCategory
    "create a new SystemBrowser browsing all methods from all
     classes with same category as current method category"

    self askAndBrowseMethodCategory:'category to browse methods (matchPattern allowed):'
                             action:[:aString | |brwsr|
                                        brwsr := SystemBrowser browseMethodCategory:aString.
                                    ]
! !

!BrowserView methodsFor:'method category stuff'!

asBrowserList:aList
    "add *all* entry"

    (aList size == 0) ifTrue:[^ nil].
    aList add:'* all *'.
    ^ aList asOrderedCollection sort
!

checkMethodCategorySelected
    currentMethodCategory isNil ifTrue:[
	self warn:'select a method category first'.
	^ false
    ].
    ^ true
!

copyMethodsFromClass:aClassName
    |class box list|

    currentClass notNil ifTrue:[
        class := environment classNamed:aClassName.
        class isBehavior ifFalse:[
            self warn:'no class named %1' with:aClassName.
            ^ self
        ].
        class isLoaded ifFalse:[
            (self confirm:(class name , ' is an autoloaded class.\I can only copy categories if it is loaded first.\\Load the class now?') withCRs)
            ifTrue:[
                class autoload
            ]
        ].        

        showInstance ifFalse:[
            class := class theMetaclass             
        ].

        "show enterbox for category to copy from"

        list := class categories asOrderedCollection sort.
        list addFirst:'*'.

        box := self 
                enterBoxTitle:'name of category to copy from (matchpattern allowed, * for all):'
                okText:'copy'
                label:(resources string:'copy methods from %1' with:aClassName)
                list:list.

        box open.
        box accepted ifTrue:[
            self 
                copyMethodsFromClass:class 
                category:(box aspectValueFor:#fieldValue)
        ]
    ]

    "Modified: / 16.1.1997 / 20:15:51 / cg"
    "Modified: / 19.12.1997 / 12:27:42 / stefan"
!

copyMethodsFromClass:class category:category
    currentClass notNil ifTrue:[
        AbortOperationRequest catch:[
            class methodDictionary do:[:aMethod |
                |source|

                (category match:aMethod category) ifTrue:[
                    source := aMethod source.
                    codeView contents:source; modified:false.
                    codeModified := false.
                    actualClass compilerClass
                         compile:source 
                         forClass:actualClass 
                         inCategory:aMethod category
                         notifying:codeView.
                    self updateMethodCategoryListWithScroll:false.
                    self updateMethodListWithScroll:false.
                ]
            ]
        ]
    ]

    "Modified: / 7.6.1996 / 09:02:35 / stefan"
    "Modified: / 16.11.2001 / 17:37:40 / cg"
!

listOfAllMethodCategoriesInClass:aClass
    "answer a list of all method categories of the argument, aClass"

    ^ self asBrowserList:(aClass categories)    
!

listOfAllMethodCategoriesInFullProtocolHierarchy:aClass
    "answer a list of all method categories of the argument, aClass,
     and all of its superclasses.
     Used with fullProtocol browsing."

    |newList|

    newList := Set new.
    self classesInFullProtocolHierarchy:aClass do:[:c |
        newList addAll:(c categories).
    ].
    ^ self asBrowserList:newList  
!

methodCategorySelection:lineNr
    "user clicked on a method category line - show selectors"

    |cat|

    (cat := methodCategoryListView selectionValue) isNil ifTrue:[
	cat := currentMethodCategory
    ].
    cat notNil ifTrue:[
	self switchToMethodCategory:cat string.
    ].

    "Modified: 22.10.1996 / 17:27:13 / cg"
!

methodCategorySelectionChanged
    "method category selection has changed - update dependent views"

    self withWaitCursorDo:[
        self releaseMethod.

        self updateMethodList.
        aspect ~~ #definition ifTrue:[self updateCodeView].

        currentMethodCategory notNil ifTrue:[
            methodCategoryListView setSelectElement:currentMethodCategory
        ].

        aspect isNil ifTrue:[
            self setAcceptAndExplainActionsForMethod.
        ].

"/ this is now done in
"/ #updateMethodList
"/
"/        (variableListView notNil
"/        and:[variableListView hasSelection]) ifTrue:[
"/            self hilightMethodsInMethodCategoryList:false inMethodList:true.
"/        ]
    ]

    "Created: / 23.11.1995 / 14:17:38 / cg"
    "Modified: / 27.7.1998 / 10:58:26 / cg"
!

newMethodCategory:aString
    |categories|

    currentClass isNil ifTrue:[
	^ self warn:'select/create a class first'.
    ].
    categories := methodCategoryListView list.
    categories isNil ifTrue:[categories := OrderedCollection new].
    (categories includes:aString) ifFalse:[
	categories add:aString.
	categories sort.
	methodCategoryListView contents:categories
    ].
    currentMethodCategory := aString.
    aspect := nil.
    self methodCategorySelectionChanged

    "Modified: 10.2.1996 / 13:07:32 / cg"
!

switchToMethodCategory:aCategory
    |oldSelector|

    oldSelector := currentSelector.

    aspect := nil.
    (fullProtocol not and:[currentClass isNil]) ifTrue:[^ self].

    currentMethodCategory := aCategory.
    self methodCategorySelectionChanged.

    "if there is only one method, show it right away"
    methodListView list size == 1 ifTrue:[
        methodListView setSelection:1.
        self methodSelection:1
    ] ifFalse:[
        oldSelector notNil ifTrue:[
            methodListView setSelectElement:oldSelector.
            methodListView hasSelection ifTrue:[
                self methodSelection:methodListView selection.
            ]
        ]
    ].
"/    actualClass notNil ifTrue:[
"/        self addToClassHistory: actualClass name asString
"/    ]


    "Modified: 26.5.1996 / 15:07:07 / cg"
    "Created: 4.6.1996 / 23:03:50 / cg"
!

updateMethodCategoryList
    self updateMethodCategoryListWithScroll:true
!

updateMethodCategoryListWithScroll:scroll
    |categories|

    methodCategoryListView notNil ifTrue:[
	fullProtocol ifTrue:[
	    currentClassHierarchy notNil ifTrue:[
		categories := self listOfAllMethodCategoriesInFullProtocolHierarchy:actualClass 
	    ]
	] ifFalse:[
	    currentClass notNil ifTrue:[
		categories := self listOfAllMethodCategoriesInClass:actualClass
	    ]
	].

	methodCategoryListView list = categories ifFalse:[
	    scroll ifTrue:[
		methodCategoryListView contents:categories
	    ] ifFalse:[
		methodCategoryListView setContents:categories
	    ].
	    currentMethodCategory notNil ifTrue:[
		methodCategoryListView setSelectElement:currentMethodCategory
	    ]
	]
    ]

    "Modified: 30.7.1997 / 15:53:22 / cg"
!

whenMethodCategorySelected:aBlock
    self checkMethodCategorySelected ifTrue:[
        self withWaitCursorDo:aBlock
    ]

    "Modified: 18.8.1997 / 15:44:38 / cg"
! !

!BrowserView methodsFor:'method list menu'!

commonTraceHelperWith:aSelector
    "install a break/trace or countPoint for the current method"

    "/ not for unbound methods (i.e. obsolete)

    currentMethod isNil ifTrue:[^ self].
    currentMethod who isNil ifTrue:[
        self warn:'method is no longer valid'.
        ^ self
    ].

    currentMethod perform:aSelector.
    self refetchMethod.

    Class withoutUpdatingChangesDo:[
        currentClass changed:#methodTrap with:currentSelector.
        Smalltalk changed:#methodTrap with:(Array with:currentClass with:currentSelector).
    ].

    "Modified: / 27.7.1998 / 11:10:40 / cg"
!

commonTraceHelperWith:aSelector with:argument
    "install a break/trace or countPoint for the current method"

    "/ not for unbound methods (i.e. obsolete)

    currentMethod isNil ifTrue:[^ self].
    currentMethod who isNil ifTrue:[
        self warn:'method is no longer valid'.
        ^ self
    ].

    currentMethod perform:aSelector with:argument.
    self refetchMethod.

    Class withoutUpdatingChangesDo:[
        currentClass changed:#methodTrap with:currentSelector.
        Smalltalk changed:#methodTrap with:(Array with:currentClass with:currentSelector).
    ]

    "Modified: / 27.7.1998 / 11:10:57 / cg"
!

methodAproposSearch
    "launch an enterBox for a keyword search"

    self askForSearchTitle:'Keyword to search for (in selector):' 
                  openWith:#aproposSearch:in:
                isSelector:true
                searchArea:#class

    "Modified: / 12.10.2001 / 19:43:18 / cg"
!

methodBreakPoint
    "set a breakpoint on the current method"

    self commonTraceHelperWith:#setBreakPoint.

    "Modified: / 12.1.1998 / 19:14:30 / cg"
!

methodBreakPointInProcess
    "set a breakpoint on the current method, which only triggers if
     executed by some particular process."

    |processes processNames box windowGroups|

    windowGroups := WindowGroup allSubInstances.

    processes := ProcessorScheduler knownProcesses asOrderedCollection.
    processes := processes select:[:aProcess |
                        aProcess notNil and:[aProcess isDead not]
                 ].
    processes := processes sort:[:a :b | a id < b id].
    processNames := processes collect:[:aProcess |
                        |pName theGroup top topLabel winLabel|

                        pName := aProcess nameOrId.

                        "/ if its a windowGroup process,
                        "/ fetch its first topViews name and add.
                        "/ (allows selecting among multiple browsers ...)
                        winLabel := ''.

                        theGroup := windowGroups select:[:g | g process == aProcess].
                        theGroup size == 1 ifTrue:[
                            theGroup := theGroup first.
                            top := theGroup topViews.
                            top size > 0 ifTrue:[
                                top := top first.
                                topLabel := top label.
                                (topLabel notNil and:[topLabel ~= pName]) ifTrue:[
                                     winLabel := '  "' , topLabel , '")'.
                                ]
                            ].                        
                        ].
                        aProcess id printString , ' [' , pName , ']' , winLabel
                    ].

    "/ let user specify which one ...

    box := ListSelectionBox new.
    box noEnterField.
    box list:processNames.
    box label:(resources string:'Process selection').
    box title:(resources 
                string:'Stop if method is executed by process:\\(current process is %1)'
                with:(Processor activeProcess id)
                with:(Processor activeProcess nameOrId)) withCRs.
    box action:[:selection |
        self commonTraceHelperWith:#breakPointInProcess: 
                              with:(processes at:box selectionIndex)
    ].
    box open.
    box destroy

    "Created: / 14.10.1996 / 15:40:53 / cg"
    "Modified: / 2.2.1998 / 12:39:38 / stefan"
    "Modified: / 16.11.2001 / 11:49:23 / cg"
!

methodChangeCategory
    "move the current method into another category -
     nothing done here, but a query for the new category.
     Remember the last category, to allow faster category change of a group of methods."

    |box txt newCategory method|

    self checkMethodSelected ifFalse:[^ self].

    actualClass isNil ifTrue:[
        box := self 
                enterBoxTitle:'' 
                okText:'Change'
                label:'Change category'.
    ] ifFalse:[
        |someCategories|

        someCategories := actualClass categories asOrderedCollection sort.
        box := self 
                listBoxTitle:'' 
                okText:'Change' 
                list:someCategories.
    ].

    box title:(resources string:'Change category from ''%1'' to:' with:currentMethod category).
    lastMethodCategory isNil ifTrue:[
        txt := currentMethod category.
    ] ifFalse:[
        txt := lastMethodCategory
    ].
    box initialText:txt.
    box action:[:aString | newCategory := aString].
    box label:(resources string:'Change category').
    box open.
    box destroy.

    newCategory notNil ifTrue:[
        lastMethodCategory := newCategory.
        method := currentMethod.
        newCategory ~= method category ifTrue:[
            method category:newCategory asSymbol.
            self updateMethodCategoryListWithScroll:false.
            self updateMethodListWithScroll:false
        ]
    ].

    "Created: / 29-10-1995 / 19:59:22 / cg"
    "Modified: / 23-11-2006 / 16:58:15 / cg"
!

methodCompareSource
    "compare with some other methods source"

    |v classAndMethod words className methodName 
     meta class method|

    self checkMethodSelected ifFalse:[^ self].

    classAndMethod := Dialog 
                request:'Compare current code with source of (Class selector)'
                initialAnswer:(actualClass name , ' ' , currentSelector).
    classAndMethod size == 0 ifTrue:[^ self].

    words := classAndMethod asCollectionOfWords.

    className := words at:1 ifAbsent:nil.
    className isNil ifTrue:[
        ^ self warn:'No class entered.'.
    ].

    meta := false.
    words size > 2 ifTrue:[
        (words at:2) ~= 'class' ifTrue:[
            ^ self warn:'Bad input.'.
        ].
        methodName := words at:3.
        meta := true.
    ] ifFalse:[
        methodName := words at:2 ifAbsent:nil.
    ].

    methodName isNil ifTrue:[
        ^ self warn:'No method entered.'.
    ].

    className := className asSymbolIfInterned.
    (className isNil or:[(class := environment at:className) isBehavior not]) ifTrue:[
        ^ self warn:('No such class: ' , className , '.').
    ].
    meta ifTrue:[class := class theMetaclass ].

    methodName := methodName asSymbolIfInterned.
    (methodName isNil or:[(method := class compiledMethodAt:methodName) isNil]) ifTrue:[
        ^ self warn:'No such method.'.
    ].

    v := DiffCodeView 
        openOn:codeView contentsAsString string
        label:(resources string:'code here')
        and:method source asString string
        label:'method compare'.      
    v label:'comparing with ' , className , ' ' , methodName.

    "Modified: 7.11.1996 / 18:53:55 / cg"
!

methodCompareSourceAgainstCurrent
    "compare with some other methods source"

    |v class codeHere codeRemote selector|

    self checkMethodSelected ifFalse:[^ self].
    class := currentMethod mclass.
    selector := currentMethod selector.

    codeHere := ((environment at:(class name asSymbol)) compiledMethodAt:selector) source.
    codeRemote := currentMethod source.

    v := DiffCodeView 
        openOn:codeHere asString string
        label:(resources string:'method here')
        and:codeRemote asString string
        label:'method remote'.      
    v label:'comparing with local version'.

    "Modified: 7.11.1996 / 18:53:55 / cg"
!

methodCompareWithPreviousVersion
    "compare with previous version"

    |prev this v|

    self checkMethodSelected ifFalse:[^ self].

    prev := currentMethod previousVersion source.
    prev isNil ifTrue:[
        self warn:'oops - previous version is gone'.
        ^ self
    ].
    prev := prev string.
    this := codeView contentsAsString string.

    v := DiffCodeView 
        openOn:this
        label:(resources string:'code here')
        and:prev
        label:(resources string:'previous version').

    v topView label:(resources string:'Comparing %1 >> %2' with:currentMethod mclass className with:currentMethod selector).

    "Modified: 7.11.1996 / 18:53:55 / cg"
!

methodCopy
    "copy the current method into another class; typically a brother-sister class"

    |newClass newClassName sup initial copiedMethod 
     supers subs list|

    self checkMethodSelected ifFalse:[^ self].

    lastMethodMoveClass ~= currentClass name ifTrue:[
        initial := lastMethodMoveClass.
    ].

    initial isNil ifTrue:[
        (sup := currentClass superclass) notNil ifTrue:[
            initial := sup name
        ] ifFalse:[
            initial := nil.
        ].
    ].

    supers := (currentClass allSuperclasses reversed collect:[:cls | cls name]).
    subs := (currentClass allSubclasses collect:[:cls | cls name]).
    list := supers.
    (supers notEmpty and:[subs notEmpty]) ifTrue:[
        list := list , (Array with:'---- ' , currentClass name , ' ----')
    ].
    list := list , subs.


"/ preps to use windowSpecs ...
"/
"/    holders := IdentityDictionary new.
"/    holders at:#className put:initial asValue.
"/    holders at:#classList put:list.
"/
"/    (SystemBrowser 
"/      openDialogInterface:#methodMoveDialogSpec
"/      withBindings:holders) ifFalse:[
"/        ^ self
"/    ].
"/    newClassName := (holders at:#className) value.

    newClassName := Dialog 
                    request:(resources string:'Copy this method to which class:')
                    initialAnswer:initial
                    okLabel:(resources string:'Copy')
                    title:(resources string:'Copy method')
                    onCancel:nil
                    list:list.
    newClassName isNil ifTrue:[^ self].
    (newClassName startsWith:'---- ') ifTrue:[^ self].

    newClass := environment classNamed:newClassName.
    newClass isNil ifTrue:[
        self warn:'no such class'.
        ^ self
    ].

    showInstance ifFalse:[
        newClass isMeta ifFalse:[
            newClass := newClass theMetaclass
        ]
    ].

    (newClass includesSelector:currentSelector) ifTrue:[
        (self confirm:(newClass name allBold , ' already implements ' , currentSelector
                      , '\\Redefine anyway ?' withCRs)) ifFalse:[
            ^ self
        ]
    ].

    lastMethodMoveClass := newClassName.

    copiedMethod := newClass 
                        compile:(currentMethod source) 
                        classified:currentMethodCategory.

    (copiedMethod isNil or:[copiedMethod == #Error]) ifTrue:[
        self warn:'not copied - compilation failed due to an error'.
        ^ self
    ].

    "Modified: / 16.11.2001 / 10:10:27 / cg"
!

methodDecompile
    "decompile the current methods bytecodes.
     The Decompiler is delivered as an extra, and not normally
     avaliable with the system."

    |s|

    self checkMethodSelected ifFalse:[^ self].
    self checkSelectionChangeAllowed ifFalse:[^ self].

    s := String writeStream.
    (currentMethod decompileTo:s) ifFalse:[
        self warn:'No decompiler available'.
    ].
    codeView contents:s contents; modified:false.
    codeModified := false.
    self clearAcceptAction.
    self clearExplainAction.

    "Modified: / 10.2.2000 / 14:14:40 / cg"
!

methodFileOut
    "file out the current method"

    self checkMethodSelected ifFalse:[^ self].

    self busyLabel:'saving:' with:currentSelector.
    Class fileOutErrorSignal handle:[:ex |
        self warn:'cannot create: %1' with:ex parameter.
        self normalLabel.
        ex return
    ] do:[
        actualClass fileOutMethod:currentMethod.
    ].
    self normalLabel.
!

methodFindAnyMethod
    |box|

    box := self enterBoxForSearchSelectorTitle:'Method selector to search for:'.
    box label:(resources string:'Find method').
    box action:[:aString | self switchToAnyMethodNamed:aString].
    box open

    "Created: / 2.2.1999 / 14:40:04 / cg"
    "Modified: / 12.10.2001 / 19:44:35 / cg"
!

methodFindMethod
    |box|

    box := self enterBoxForSearchSelectorTitle:'Method selector to search for:'.
    box label:(resources string:'Find method').
    box action:[:aString | self switchToMethodNamed:aString].
    box open

    "Created: / 2.2.1999 / 14:40:00 / cg"
    "Modified: / 12.10.2001 / 19:43:38 / cg"
!

methodFlushCode

    self checkMethodSelected ifFalse:[^ self].
    self checkSelectionChangeAllowed ifFalse:[^ self].

    currentMethod clearJittedCodeAndForceJittingAgain.
    "/ currentMethod checked:false; code:nil.

    "Created: / 10.11.1998 / 18:30:14 / cg"
!

methodFormatMethod:oldText
    "prettyPrint the method (but do not accept it);
     uses the RefactoryBrowsers formatter"

    |newText|

    newText := RBFormatter format:oldText.
    newText = oldText ifTrue:[^ self].
    codeView contents:newText; modified:true.

    "Modified: / 22.11.1999 / 11:53:55 / cg"
!

methodGlobalReferends
    "launch an enterBox for global symbol to search for"

    self askForSearchTitle:'Global variable to search users of:' 
                  openWith:#browseReferendsOf:in:
                isSelector:false

"/    self enterBoxForBrowseTitle:'global variable to browse users of:'
"/                         action:[:aString | 
"/                                    SystemBrowser browseReferendsOf:aString asSymbol
"/                                ]

    "Modified: / 12.10.2001 / 19:42:49 / cg"
!

methodImplementors
    "launch an enterBox for selector to search for"

    self 
        askForSearchTitle:'Selector to browse implementors of:' 
        openWith:#browseImplementorsOf:in:ignoreCase:
        isSelector:true
        searchArea:#everywhere
        withCaseIgnore:true

    "Modified: / 12.10.2001 / 19:41:41 / cg"
!

methodInheritance
    "launch a browser showing inherited (and overwritten) methods"

    |methodList nRedef msg whereRedef|

    currentClass isNil ifTrue:[^ self].
    currentSelector isNil ifTrue:[^ self].

    methodList := OrderedCollection new.
    actualClass allSuperclasses do:[:aSuperClass |
        |m|

        m := aSuperClass compiledMethodAt:currentSelector.
        m notNil ifTrue:[
            methodList addFirst:m
        ]
    ].
    methodList size == 0 ifTrue:[
        nRedef := 0.
        actualClass allSubclassesDo:[:aSubClass |
            (aSubClass compiledMethodAt:currentSelector) notNil ifTrue:[
                nRedef := nRedef + 1.
                whereRedef := aSubClass name.
            ]
        ].
        msg := '''%1'' does not redefine any inherited method.'.
        nRedef ~~ 0 ifTrue:[
            nRedef == 1 ifTrue:[
                msg := msg , '\But is redefined in %3.'
            ] ifFalse:[
                msg := msg , '\But is redefined in %2 subclasses.'
            ]
        ].
        ^ self information:(resources
                                string:msg
                                with:currentSelector allBold
                                with:nRedef
                                with:whereRedef) withCRs.
    ].
    methodList addLast:(actualClass compiledMethodAt:currentSelector).
    SystemBrowser 
        browseMethods:methodList 
        title:(resources string:'''%1'' inheritance & redefinition' with:currentSelector)
        sort:false
!

methodInspect
    "inspect  the current method"

    self checkMethodSelected ifFalse:[^ self].
    currentMethod inspect.
"/    (actualClass compiledMethodAt:currentSelector) inspect.

    "Modified: 4.6.1996 / 22:47:27 / cg"
!

methodInvoke
    "invoke the current method"

    |w cls sel rec|

    self checkMethodSelected ifFalse:[^ self].

    w := currentMethod who.
    w notNil ifTrue:[
        cls := w methodClass.
        cls notNil ifTrue:[
            cls ~~ actualClass ifTrue:[
                ^ self warn:'oops - obsolete class; please reselect the class.'
            ].
            cls isMeta ifFalse:[
                (self confirm:'Instance method - Invoke on a new instance ?')
                ifFalse:[
                    ^ self
                ].
                rec := cls basicNew.
            ] ifTrue:[
                rec := cls
            ].
            sel := w methodSelector.
            sel notNil ifTrue:[
                rec perform:sel.
                ^ self
            ]
        ].
    ]. 
    self warn:'Cannot invoke method (no class)'

    "Modified: / 29.4.1997 / 11:24:30 / dq"
    "Modified: / 5.11.2001 / 16:33:11 / cg"
!

methodLocalSuperSends
    "launch a browser showing super sends in current class & subclasses"

    self checkClassSelected ifFalse:[^ self].
    self withSearchCursorDo:[
	SystemBrowser browseSuperCallsUnder:currentClass
    ]

    "Created: 23.11.1995 / 12:03:57 / cg"
    "Modified: 23.11.1995 / 14:12:15 / cg"
!

methodMakeIgnored
    "make the current method be invisible.
     EXPERIMENTAL"

    self methodPrivacy:#ignored

    "Created: 13.12.1995 / 13:59:59 / cg"
!

methodMakePrivate
    "make the current method private.
     EXPERIMENTAL"

    self methodPrivacy:#private 
!

methodMakeProtected
    "make the current method protected.
     EXPERIMENTAL"

    self methodPrivacy:#protected 
!

methodMakePublic
    "make the current method public.
     EXPERIMENTAL"

    self methodPrivacy:#public 
!

methodMenu
    "return a popupmenu as appropriate for the methodList"

    <resource: #programMenu >
    <resource: #keyboard ( #Cmds #Cmdi #Cmdg #Cmdt #Cmda #Ctrl) >

    |specialMenu m items
     newItems brkItems fileItems mthdItems
     searchItems sepLocalItems sepMthdItems|

    currentMethod notNil ifTrue:[
        currentMethod isCountingMemoryUsage ifTrue:[
            brkItems := #(
                                ('-'               nil)
                                ('Stop Mem Usage'  methodStopMemoryUsage)
                                ('Reset Mem Count' methodResetMemoryUsage)
                          ).
        ] ifFalse:[
            currentMethod isCounting ifTrue:[
                brkItems := #(
                                    ('-'              nil               )
                                    ('Stop Counting'  methodStopCounting)
                                    ('Reset Count'    methodResetCounting)
                              ).
            ] ifFalse:[
                currentMethod isTimed ifTrue:[
                    brkItems := #(
                                        ('-'           nil             )
                                        ('Stop Timing' methodStopTiming)
                                        ('Reset Times' methodResetTiming)
                                  ).
                ] ifFalse:[
                    currentMethod isTraced ifTrue:[
                        brkItems := #(
                                            ('-'            nil                     )
                                            ('Remove Trace' methodRemoveBreakOrTrace)
                                      ).
                    ] ifFalse:[
                        currentMethod isBreakpointed ifTrue:[
                            brkItems := #(
                                                ('-'                 nil                     )
                                                ('Remove Breakpoint' methodRemoveBreakOrTrace)
                                          ).
                        ] ifFalse:[
                            brkItems := #(
                                                ('-'                   nil                       )
                                                ('Breakpoint'          methodBreakPoint          )
                                                ('Breakpoint In...'    methodBreakPointInProcess )
                                                ('-'                   nil                       )
                                                ('Trace'               methodTrace               )
                                                ('Trace Sender'        methodTraceSender         )
                                                ('Trace Full Walkback' methodTraceFull           )
                                                ('-'                   nil                       )
                                                ('Start Timing'        methodStartTiming         )
                                                ('Start Counting'      methodStartCounting       )
                                                ('Start Mem Usage'     methodStartMemoryUsage    )
                                          ).
                        ]
                    ]
                ]
            ]
        ].

        self isSimulatedEnvironment ifTrue:[
            brkItems := #().
            items := #(
                            ('Compare against...'        methodCompareSource  )
                            ('Compare against Current'   methodCompareSourceAgainstCurrent  )
                            ('Inspect Method'            methodInspect        )
                      ).
        ] ifFalse:[
            items := #(
                            ('Compare against...'        methodCompareSource  )
                            ('Inspect Method'            methodInspect        )
                      ).
        ].

        currentMethod isJavaMethod ifTrue:[
            items := items , #(
                            ('Decompile'                 methodDecompile      )
                            ('-'                         nil                  )
                            ('Flush Code'                methodFlushCode      )
                       ).
        ] ifFalse:[

            items := items , #(
                            ('stc-Compile'               methodSTCCompile     )
                            ('Decompile'                 methodDecompile      )
                            ('-'                         nil                  )
                            ('Package...'                methodModifyPackage  )
                       ).

            Method methodPrivacySupported ifTrue:[
                items := items , #(
                                ('-'                         nil                  )
                                ('Make Public'               methodMakePublic     )
                                ('Make Private'              methodMakePrivate    )
                                ('Make Protected'            methodMakeProtected  )
                                ('Make Ignored'              methodMakeIgnored    )
                           ).
            ].

            actualClass isMeta ifTrue:[
                items := #(
                              ('Invoke Method' methodInvoke )
                              ('-'             nil          )
                          )
                          , items.
            ].

        ].
        items := items , brkItems.

        specialMenu := PopUpMenu itemList:items resources:resources.

        currentClass owningClass notNil ifTrue:[
            specialMenu disable:#methodModifyPackage
        ].

        currentMethod isPublic ifTrue:[
            specialMenu disable:#methodMakePublic
        ].
        currentMethod isPrivate ifTrue:[
            specialMenu disable:#methodMakePrivate
        ].
        currentMethod isProtected ifTrue:[
            specialMenu disable:#methodMakeProtected
        ].
        currentMethod isIgnored ifTrue:[
            specialMenu disable:#methodMakeIgnored
        ].
        ((currentMethod hasCode and:[currentMethod isDynamic not])
        or:[currentMethod isJavaMethod
        or:[Compiler canCreateMachineCode not]]) ifTrue:[
            specialMenu disable:#methodSTCCompile
        ].
        currentMethod byteCode isNil ifTrue:[
            currentMethod isLazyMethod ifFalse:[
                specialMenu disable:#methodDecompile
            ]
        ].
        currentMethod numArgs ~~ 0 ifTrue:[
            specialMenu disable:#methodInvoke
        ].
        self environment ~~ Smalltalk ifTrue:[
            specialMenu disableAll:#(methodSTCCompile methodModifyPackage 
                                     methodMakePublic methodMakePrivate methodMakeProtected methodMakeIgnored 
                                     methodBreakPoint methodBreakPointInProcess methodTrace methodTraceSender   
                                     methodTraceFull methodStartTiming methodStartCounting methodStartMemoryUsage
                                    )
        ].
    ].

    self sensor ctrlDown ifTrue:[
        currentMethod isNil ifTrue:[
            methodListView flash.
            ^ nil
        ].

        ^ specialMenu
    ].


    sepLocalItems  := #().
    sepMthdItems  := #().

    searchItems := #(
                ('Senders...'           methodSenders                 Cmds)
                ('Implementors...'      methodImplementors            Cmdi)
                ('Globals...'           methodGlobalReferends         Cmdg)
                ('String Search...'     methodStringSearch            Cmdt)
                ('Apropos...'           methodAproposSearch           )
                ('-'                                                  )
                ('Find Method here...'  methodFindMethod              )
                ('Find Method...'       methodFindAnyMethod           )
               ).

    currentMethodCategory notNil ifTrue:[
        sepLocalItems := #(('-')).

        (currentClass notNil 
        and:[showInstance not
        and:[currentClass isSubclassOf:ApplicationModel]]) ifTrue:[
            newItems :=           #(
                                    ('New Method'       methodNewMethod     )
                                    ('New Window Spec'  methodNewWindowSpec )
                                    ('New Menu Spec'    methodNewMenuSpec   )
                                    ('New Image Spec'   methodNewImageSpec   )
                                    ).
        ] ifFalse:[
            newItems :=           #(
                                    ('New Method'       methodNewMethod)
                                    ).
        ].
        sepMthdItems := #(('-')).
    ] ifFalse:[
        newItems := #()
    ].

    currentMethod notNil ifTrue:[
        fileItems :=           #(
                                ('FileOut'       methodFileOut  )
                                ('PrintOut'      methodPrintOut )
                                ('-'             nil            )
                                ('SPAWN_METHOD'  methodSpawn    )
                                ('Inheritance'   methodInheritance )
                                ('-'             nil            )
                                ).

        sepLocalItems := #(('-')). 

        mthdItems :=           #(
                                ('Change Category...'      methodChangeCategory )
                                ('Copy To...'              methodCopy           )
                                ('Move To...'              methodMove           )
                                ('Remove'                  methodRemove         )
                                ('-'                       nil                              )
                                ('Compare with Previous'   methodCompareWithPreviousVersion )
                                ('Back to Previous'        methodPreviousVersion            )
                                ).

    ] ifFalse:[
        fileItems := #().
        mthdItems := #().
        sepMthdItems := #().
    ].



    items :=
                fileItems ,
                searchItems ,
"/                localSearchItems ,
                sepLocalItems ,
                newItems ,
                sepMthdItems ,
                mthdItems.

    specialMenu notNil ifTrue:[
        items := items , #(
                        ('='                      )
                        ('More'  otherMenu  Ctrl)
                  ).
    ].

    m := PopUpMenu itemList:items resources:resources.

    specialMenu notNil ifTrue:[
        m subMenuAt:#otherMenu put:specialMenu.
    ].

    currentMethod notNil ifTrue:[
        self currentMethodsPreviousVersionCode isNil ifTrue:[
            m disable:#methodPreviousVersion.
            m disable:#methodCompareWithPreviousVersion
        ]
    ].
    self isReadOnlyEnvironment ifTrue:[
        m disableAll:#(
                       methodNewMethod methodChangeCategory 
                       methodMove methodCopy methodRemove 
                      )
    ].
    self isSimulatedEnvironment ifTrue:[
        m disableAll:#(methodSenders methodImplementors methodGlobalReferends methodStringSearch
                       methodAproposSearch
                      )
    ].
    ^ m

    "Created: / 23.11.1995 / 12:02:29 / cg"
    "Modified: / 18.12.1995 / 16:20:07 / stefan"
    "Modified: / 29.4.1997 / 11:20:59 / dq"
    "Modified: / 30.4.1999 / 09:15:32 / cg"
!

methodModifyPackage
    "change the methods package assignment"

    |newPackage|

    currentClass owningClass notNil ifTrue:[
        self warn:'Private classes always belong to the owners package.\\Cannot change the packageID.' withCRs.
        ^ self
    ].

    newPackage := Dialog 
                    request:(resources 
                                string:'Change the package-ID of ''%1'' to:' 
                                with:currentSelector allBold) withCRs
                    initialAnswer:currentClass package.
    newPackage size == 0 ifTrue:[
        ^ self
    ].

    currentMethod package:newPackage.
!

methodMove
    "move the current method into another class; typically a superclass"

    |newClass newClassName sup initial movedMethod 
     supers subs list|

    self checkMethodSelected ifFalse:[^ self].

    lastMethodMoveClass ~= currentClass name ifTrue:[
        initial := lastMethodMoveClass.
    ].

    initial isNil ifTrue:[
        (sup := currentClass superclass) notNil ifTrue:[
            initial := sup name
        ] ifFalse:[
            initial := nil.
        ].
    ].

    supers := (currentClass allSuperclasses reversed collect:[:cls | cls name]).
    subs := (currentClass allSubclasses collect:[:cls | cls name]).
    list := supers.
    (supers notEmpty and:[subs notEmpty]) ifTrue:[
        list := list , (Array with:'---- ' , currentClass name , ' ----')
    ].
    list := list , subs.


"/ preps to use windowSpecs ...
"/
"/    holders := IdentityDictionary new.
"/    holders at:#className put:initial asValue.
"/    holders at:#classList put:list.
"/
"/    (SystemBrowser 
"/      openDialogInterface:#methodMoveDialogSpec
"/      withBindings:holders) ifFalse:[
"/        ^ self
"/    ].
"/    newClassName := (holders at:#className) value.

    newClassName := Dialog 
                    request:(resources string:'Move this method to which class:')
                    initialAnswer:initial
                    okLabel:(resources string:'Move')
                    title:(resources string:'Move method')
                    onCancel:nil
                    list:list.
    newClassName isNil ifTrue:[^ self].
    (newClassName startsWith:'---- ') ifTrue:[^ self].

    newClass := environment classNamed:newClassName.
    newClass isNil ifTrue:[
        self warn:'no such class'.
        ^ self
    ].

    showInstance ifFalse:[
        newClass isMeta ifFalse:[
            newClass := newClass theMetaclass
        ]
    ].

    (newClass includesSelector:currentSelector) ifTrue:[
        (self confirm:(newClass name allBold , ' already implements ' , currentSelector
                      , '\\Move anyway ?' withCRs)) ifFalse:[
            ^ self
        ]
    ].

    lastMethodMoveClass := newClassName.

    movedMethod := newClass 
                        compile:(currentMethod source) 
                        classified:currentMethodCategory.

    (movedMethod isNil or:[movedMethod == #Error]) ifTrue:[
        self warn:'not moved - compilation failed due to an error'.
        ^ self
    ].

    self methodRemove

    "Created: / 13.12.1995 / 10:56:42 / cg"
    "Modified: / 16.11.2001 / 12:10:00 / cg"
!

methodNewImageSpec
    "open a BitmapEditor"

    |specSel|

    currentClass isNil ifTrue:[
        ^ self warn:'select/create a class first'.
    ].
    currentMethodCategory isNil ifTrue:[
        ^ self warn:'select/create a method category first'.
    ].

    (actualClass includesSelector:#someImageSpec) ifFalse:[
        specSel := #someImageSpec
    ].
    ImageEditor openOnClass:currentClass andSelector:specSel

    "Created: / 28.10.1997 / 12:42:00 / cg"
!

methodNewMenuSpec
    "open a MenuEditor"

    |specSel|

    currentClass isNil ifTrue:[
        ^ self warn:'select/create a class first'.
    ].
    currentMethodCategory isNil ifTrue:[
        ^ self warn:'select/create a method category first'.
    ].

    (actualClass includesSelector:#menuSpec) ifFalse:[
        specSel := #menuSpec
    ].
    MenuEditor openOnClass:currentClass andSelector:specSel

    "Created: / 28.10.1997 / 12:42:00 / cg"
!

methodNewMethod
    "prepare for definition of a new method - put a template into
     code view and define accept-action to compile it"

    currentClass isNil ifTrue:[
        ^ self warn:'select/create a class first'.
    ].
    currentMethodCategory isNil ifTrue:[
        ^ self warn:'select/create a method category first'.
    ].

    self releaseMethod.

    methodListView setSelection:nil.
    codeView contents:(self methodTemplate); modified:false.
    codeModified := false.

    self setAcceptAndExplainActionsForMethod.

    "Modified: / 27.7.1998 / 11:00:16 / cg"
!

methodNewWindowSpec
    "open GUI Painter"

    |specSel|

    currentClass isNil ifTrue:[
        ^ self warn:'select/create a class first'.
    ].
    currentMethodCategory isNil ifTrue:[
        ^ self warn:'select/create a method category first'.
    ].

    (actualClass includesSelector:#windowSpec) ifFalse:[
        specSel := #windowSpec
    ].
    UIPainter openOnClass:currentClass andSelector:specSel

    "Modified: / 28.10.1997 / 12:40:35 / cg"
!

methodPreviousVersion
    "switch back to the previous version
     (undo last change)"

    |cls sel prev|

    self checkMethodSelected ifFalse:[^ self].

    prev := currentMethod previousVersion.
    prev isNil ifTrue:[
        self warn:'oops - previous version is gone'.
        ^ self
    ].

    cls := currentMethod containingClass.
    cls notNil ifTrue:[
        sel := actualClass selectorAtMethod:currentMethod.
        sel isNil ifTrue:[
            self warn:'oops - cannot find methods selector (gone)'
        ] ifFalse:[        
            cls basicAddSelector:sel withMethod:prev.
            currentMethod := prev.
            self updateCodeView
        ].
    ] ifFalse:[
        self warn:'oops - cannot find containing class'
    ]

    "Modified: 7.11.1996 / 18:51:09 / cg"
!

methodPrintOut
    "print out the current method"

    |printStream|

    self checkMethodSelected ifFalse:[^ self].

    printStream := Printer new.
    actualClass printOutSource:(currentMethod source) on:printStream.
    printStream close

    "Modified: / 28.1.1998 / 00:28:03 / cg"
!

methodPrivacy:how
    "change the current methods privacy"

    self checkMethodSelected ifFalse:[^ self].

    (how == currentMethod privacy) ifFalse:[
        currentMethod privacy:how.
    ]

    "Created: / 29-10-1995 / 20:00:00 / cg"
    "Modified: / 23-01-1998 / 17:56:02 / stefan"
    "Modified: / 23-11-2006 / 17:04:13 / cg"
!

methodRemove
    "remove the current method"

    |cls sel|

    self checkMethodSelected ifFalse:[^ self].

    sel := currentMethod selector.
    sel notNil ifTrue:[
        cls := currentMethod mclass.
        cls notNil ifTrue:[
            cls ~~ actualClass ifTrue:[
                ^ self warn:'oops - obsolete class; please reselect class ...'
            ].
            sel notNil ifTrue:[
                actualClass removeSelector:sel.
                self releaseMethod.
                self updateMethodListWithScroll:false.
                ^ self
            ]
        ].
    ]. 
    self warn:'cannot remove unbound method (no class)'

    "Modified: / 27.7.1998 / 11:00:35 / cg"
!

methodRemoveBreakOrTrace
    "turn off tracing of the current method"

    self commonTraceHelperWith:#clearBreakPoint.

    "Modified: / 12.1.1998 / 19:15:32 / cg"
!

methodRemoveConfirmed
    "confirm and remove the current method"

    |sel|

    self checkMethodSelected ifFalse:[^ self].
    sel := currentMethod selector.
    sel notNil ifTrue:[
        (self confirm:'Remove ' , sel allBold , ' ?') ifTrue:[
            self methodRemove
        ]
    ]. 

    "Modified: / 27.7.1998 / 11:00:35 / cg"
!

methodResetCounting
    "reset the counting statstics for the current method"

    self commonTraceHelperWith:#resetCountingStatistics

    "Modified: / 30.7.1998 / 17:16:26 / cg"
    "Created: / 30.7.1998 / 17:39:08 / cg"
!

methodResetMemoryUsage
    "reset the memory statstics for the current method"

    self commonTraceHelperWith:#resetMemoryUsageStatistics

    "Modified: / 30.7.1998 / 17:16:26 / cg"
    "Created: / 30.7.1998 / 17:39:20 / cg"
!

methodResetTiming
    "reset the timing statstics for the current method"

    self commonTraceHelperWith:#resetTimingStatistics

    "Created: / 30.7.1998 / 17:14:41 / cg"
    "Modified: / 30.7.1998 / 17:16:26 / cg"
!

methodSTCCompile
    "compile the current method to machine code via the stc compiler.
     This is not supported on all machines."

    self checkMethodSelected ifFalse:[^ self].

    ParserFlags 
        withSTCCompilation:#always 
        do:[
            codeView accept.
        ].

    "Modified: 18.8.1997 / 15:44:22 / cg"
!

methodSenders
    "launch an enterBox for selector to search for"

    self 
        askForSearchTitle:'Selector to browse senders of:' 
        openWith:#browseAllCallsOn:in:ignoreCase:
        isSelector:true
        searchArea:#everywhere
        withCaseIgnore:true

    "Modified: / 12.10.2001 / 19:41:26 / cg"
!

methodSpawn
    "create a new SystemBrowser browsing current method,
     or if the current selection is of the form 'class>>selector', 
     spawn a browser on that method."

    |s sel selSymbol clsName clsSymbol cls isMeta brwsr msg|

    classMethodListView notNil ifTrue:[
        s := classMethodListView selectionValue string.
        clsName := self classNameFromClassMethodString:s.
        sel := self selectorFromClassMethodString:s.
        isMeta := false
    ].

    self extractClassAndSelectorFromSelectionInto:[:c :s :m |
        clsName := c.
        sel := s.
        isMeta := m
    ].

    (sel notNil and:[clsName notNil]) ifTrue:[
        ((clsSymbol := clsName asSymbolIfInterned) notNil
         and:[(selSymbol := sel asSymbolIfInterned) notNil]) ifTrue:[
            (environment includesKey:clsSymbol) ifTrue:[
                cls := environment at:clsSymbol.
                isMeta ifTrue:[
                    cls := cls theMetaclass
                ].
                cls isBehavior ifFalse:[
                    cls := cls theMetaclass
                ].
                cls isBehavior ifTrue:[
                    self withWaitCursorDo:[
                        (cls includesSelector:selSymbol) ifFalse:[
                            cls := cls theMetaclass.
                        ].
                        (cls includesSelector:selSymbol) ifTrue:[
                            SystemBrowser browseClass:cls selector:selSymbol.
                            ^ self
                        ].
                        msg := ' does not implement #' , sel
                    ]
                ] ifFalse:[
                    msg := ' is not a class'
                ]
            ] ifFalse:[
                msg := ' is unknown'
            ]
        ] ifFalse:[
            msg := ' and/or ' , sel , ' are unknown'
        ].
        self warn:(clsName , msg).
        ^ self
    ].

    self checkMethodSelected ifFalse:[
        self warn:'select a method first'.
        ^ self
    ].

    self withWaitCursorDo:[
        brwsr := SystemBrowser browseClass:(currentMethod mclass) selector:(currentMethod selector).
        brwsr environment:environment
    ]

    "Modified: 18.8.1997 / 15:46:10 / cg"
!

methodStartCounting
    "set a countpoint on the current method"

    self commonTraceHelperWith:#startCounting

    "Created: / 15.12.1995 / 11:00:44 / cg"
    "Modified: / 12.1.1998 / 19:15:40 / cg"
!

methodStartMemoryUsage
    "set a countpoint for memory usage on the current method"

    self commonTraceHelperWith:#startCountingMemoryUsage

    "Created: / 18.12.1995 / 16:00:22 / stefan"
    "Modified: / 12.1.1998 / 19:15:46 / cg"
!

methodStartTiming
    "set a timing on the current method"

    self commonTraceHelperWith:#startTiming

    "Created: / 17.6.1996 / 17:12:06 / cg"
    "Modified: / 12.1.1998 / 19:15:50 / cg"
!

methodStopCounting
    "show the number of invocations & remove a countpoint on the current method"

    self commonTraceHelperWith:#stopCounting

    "Created: / 15.12.1995 / 11:03:22 / cg"
    "Modified: / 12.1.1998 / 19:15:55 / cg"
!

methodStopMemoryUsage
    "stop counting of memory usage for this method"

    self commonTraceHelperWith:#stopCountingMemoryUsage.

    "Created: / 18.12.1995 / 16:02:02 / stefan"
    "Modified: / 12.1.1998 / 19:16:06 / cg"
!

methodStopTiming
    "stop timing the current method"

    self commonTraceHelperWith:#stopTiming

    "Created: / 17.6.1996 / 17:12:27 / cg"
    "Modified: / 30.7.1998 / 17:15:10 / cg"
!

methodStringSearch
    "launch an enterBox for string to search for"

    |whereDefault|


    currentClass notNil ifTrue:[
        whereDefault := #class.
    ] ifFalse:[
        currentClassCategory notNil ifTrue:[
            whereDefault := #classCategory.
        ] ifFalse:[
            currentNamespace notNil ifTrue:[
                whereDefault := #currentNameSpace.                
            ] ifFalse:[
                whereDefault := nil
            ]
        ]
    ].
    self 
        askForSearchTitle:'String to search for in sources:' 
        openWith:#browseForString:in:ignoreCase:
        isSelector:true
        searchArea:whereDefault
        withCaseIgnore:true

    "Modified: / 12.10.2001 / 19:43:02 / cg"
!

methodTrace
    "turn on tracing of the current method"

    self commonTraceHelperWith:#setTracePoint.

    "Modified: / 12.1.1998 / 19:16:16 / cg"
!

methodTraceFull
    "turn on tracing of the current method"

    self commonTraceHelperWith:#setTraceFullPoint.

    "Created: / 15.12.1995 / 18:20:33 / cg"
    "Modified: / 12.1.1998 / 19:16:19 / cg"
!

methodTraceSender
    "turn on tracing of the current method"

    self commonTraceHelperWith:#setTraceSenderPoint.

    "Modified: / 12.1.1998 / 19:16:22 / cg"
! !

!BrowserView methodsFor:'method stuff'!

checkMethodSelected
    currentMethod isNil ifTrue:[
	self warn:'select a method first'.
	^ false
    ].
    ^ true
!

listEntryForMethod:aMethod selector:selector
    "answer a method list entry 
     (gimmic: adding a little image to breakPointed methods)"

    |s icn|

    s := aMethod printStringForBrowserWithSelector:selector inClass:aMethod class.

    "/
    "/ wrap icons (i.e. break- or trace points)
    "/ have higher prio ...
    "/
    aMethod isWrapped ifTrue:[
        (s endsWith:' !!') ifTrue:[
            s := s copyButLast:2
        ].
        aMethod isBreakpointed ifTrue:[
            icn := self stopIcon
        ] ifFalse:[
            aMethod isTimed ifTrue:[
                icn := self timeIcon
            ] ifFalse:[
                icn := self traceIcon
            ]
        ].
    ].

    icn isNil ifTrue:[
        ShowResourceIcons ~~ false ifTrue:[
            icn := self resourceIconForMethod:aMethod.
        ].
    ].

    icn notNil ifTrue:[
        ^ LabelAndIcon icon:icn string:s
    ].
    ^ s

    "Created: / 22-10-1996 / 19:51:00 / cg"
    "Modified: / 05-03-2007 / 16:25:00 / cg"
!

listOfAllMethodsInCategory:aCategory inFullProtocolHierarchyOfClass:aClass
    "answer a list of all methods in a given method category 
     of the argument, aClass and its superclasses.
     Used with fullProtocol browsing."

    |newList selectors otherSelectors allCategories|

    newList := OrderedCollection new.
    selectors := IdentitySet new.
    otherSelectors := IdentitySet new.

    allCategories := (aCategory = '* all *').

    self classesInFullProtocolHierarchy:aClass do:[:c |
	|searchCategory|

	(aCategory = '* no category *') ifTrue:[
	    searchCategory := nil
	] ifFalse:[
	    searchCategory := aCategory
	].

	c methodDictionary keysAndValuesDo:[:selector :aMethod |
	    (allCategories
	     or:[aMethod category = searchCategory]) ifTrue:[
		(otherSelectors includes:selector) ifFalse:[
		    (selectors includes:selector) ifFalse:[
			selectors add:selector.
			newList add:(selector -> aMethod)
		    ]
		].
	    ] ifFalse:[
		otherSelectors add:selector
	    ]
	].
    ].
    (newList size == 0) ifTrue:[^ nil].
    ^ newList

    "Modified: 14.10.1997 / 00:19:20 / cg"
!

listOfAllMethodsInCategory:aCategory ofClass:aClass
    "answer a list of all methods in a given method category 
     of the argument, aClass"

    |newList searchCategory all|

    all := (aCategory = '* all *').

    (aCategory = '* no category *') ifTrue:[
	searchCategory := nil
    ] ifFalse:[
	searchCategory := aCategory
    ].
    newList := OrderedCollection new.

    aClass methodDictionary keysAndValuesDo:[:selector :aMethod |
	(all or:[aMethod category = searchCategory]) ifTrue:[
	    newList add:(selector -> aMethod)
	]
    ].
    (newList size == 0) ifTrue:[^ nil].
    ^ newList

    "Created: 30.7.1997 / 15:10:16 / cg"
    "Modified: 30.7.1997 / 15:12:38 / cg"
!

listOfAllSelectorsInCategory:aCategory inFullProtocolHierarchyOfClass:aClass
    "answer a list of all selectors in a given method category 
     of the argument, aClass and its superclasses.
     Used with fullProtocol browsing."

    |methodList newList|

    methodList := self listOfAllMethodsInCategory:aCategory inFullProtocolHierarchyOfClass:aClass.
    (methodList size == 0) ifTrue:[^ nil].

    aClass isJavaClass ifTrue:[
	methodList := methodList asOrderedCollection.
	methodList sort:[:a :b |
			    |mA mB|

			    mA := a value.
			    mB := b value.
			    mA name < mB name
			].

	selectorList := methodList collect:[:assoc | assoc key].
	^ methodList collect:[:assoc |
				self 
				    listEntryForMethod:(assoc value)
				    selector:(assoc key)
			     ].
    ].

    methodList := methodList asOrderedCollection.
    selectorList := methodList collect:[:assoc | assoc key].
    newList := methodList 
		    collect:[:assoc |
			self 
			    listEntryForMethod:(assoc value)
			    selector:assoc key
		    ].
    ^ newList asOrderedCollection sort:[:a :b | a string < b string] with:selectorList

    "Modified: 30.7.1997 / 15:28:59 / cg"
!

listOfAllSelectorsInCategory:aCategory ofClass:aClass
    "answer a list of all selectors in a given method category 
     of the argument, aClass"

    |methodList newList|

    methodList := self listOfAllMethodsInCategory:aCategory ofClass:aClass.
    (methodList size == 0) ifTrue:[^ nil].

    aClass isJavaClass ifTrue:[
	methodList := methodList asOrderedCollection.
	methodList sort:[:a :b |
			    |mA mB|

			    mA := a value.
			    mB := b value.
			    mA name < mB name
			].

	selectorList := methodList collect:[:assoc | assoc key].
	^ methodList collect:[:assoc |
				self 
				    listEntryForMethod:(assoc value)
				    selector:(assoc key)
			     ].
    ].

    selectorList := methodList collect:[:assoc | assoc key].
    newList := methodList 
		    collect:[:assoc | 
				self 
				    listEntryForMethod:(assoc value)
				    selector:(assoc key)
			    ].
    ^ newList sort:[:a :b | a string < b string] with:selectorList

    "Modified: 30.7.1997 / 15:29:16 / cg"
!

methodDoubleClick:lineNr
    |resources editorClass|

    (currentMethod notNil) ifTrue:[
        resources := currentMethod resources.
        resources notNil ifTrue:[
            editorClass := SystemBrowser resourceEditorClassForResources:resources.
            editorClass notNil ifTrue: [
                self withWaitCursorDo:[
                    editorClass 
                        openOnClass:currentClass 
                        andSelector:currentSelector
                ]
            ]
        ]
    ]
!

methodSelection:lineNr
    "user clicked on a method line - show code"

    |selection|

"/    selection := methodListView selectionValue string.
selection := selectorList at:lineNr.

    "/ reselected with control ?
    self sensor ctrlDown ifTrue:[
        selection = currentSelector ifTrue:[
            "/ if there is a trace/break, remove it.
            (currentMethod notNil and:[currentMethod isWrapped]) ifTrue:[
                self methodRemoveBreakOrTrace.
                ^ self
            ]
        ].
    ].
    self switchToMethod:selection.

    "Modified: 30.7.1997 / 15:31:21 / cg"
!

methodSelectionChanged
    "method selection has changed - update dependent views"

    self withWaitCursorDo:[
        |index cls|

        aspect := nil.
        self updateCodeView.

        self refetchMethod.

        (currentMethod notNil 
        and:[currentMethod isCounting]) ifTrue:[
            self updateMethodListWithScroll:false keepSelection:true.
        ].

        self setAcceptAndExplainActionsForMethod.

        "
         if there is any autoSearch string, do the search
        "
        autoSearch notNil ifTrue:[
            codeView 
                searchFwd:autoSearch
                ignoreCase:autoSearchIgnoreCase 
                startingAtLine:1 col:0 
                ifAbsent:[]
        ].

        fullProtocol ifTrue:[
            "
             remove any bold attribute from classList
            "
            1 to:classListView list size do:[:i |
                classListView attributeAt:i remove:#bold.
            ].
            "
             boldify the class where this method is implemented
            "
            currentMethod notNil ifTrue:[
                cls := currentMethod containingClass.
                index := classListView list indexOf:(cls name).
                (index == 0 
                 and:[cls isMeta
                 and:[cls name endsWith:' class']]) ifTrue:[
                    index := classListView list indexOf:(cls name copyButLast:6).
                ].
                index ~~ 0 ifTrue:[
                    classListView attributeAt:index add:#bold.
                    classListView makeLineVisible:index.
                ].
                currentClass := acceptClass := cls.
            ]
        ].
    ]

    "Created: / 23.11.1995 / 14:17:44 / cg"
    "Modified: / 17.6.1996 / 16:47:50 / stefan"
    "Modified: / 4.8.1998 / 20:04:58 / cg"
!

methodTemplate
    "return a method definition template string"

    ^ SmalltalkLanguage instance methodTemplate
!

resourceIconForMethod:aMethod
    ^ SystemBrowser resourceIconForMethod:aMethod

    "Modified: / 17-08-2006 / 09:08:51 / cg"
!

switchToAnyMethodNamed:matchString
    "switch (in the current classes hierarchy) to a method named matchString.
     If there are more than one matches, switch to the first."

    |aSelector classToStartSearch classToSearch aClass nm|

    actualClass isNil ifTrue:[
        currentClassHierarchy notNil ifTrue:[
            classToStartSearch := currentClassHierarchy
        ]
    ] ifFalse:[
        classToStartSearch := actualClass 
    ].

    classToStartSearch notNil ifTrue:[
"/        showInstance ifFalse:[
"/            classToStartSearch := classToStartSearch class
"/        ].
        ((matchString ~= '*') and:[matchString includesMatchCharacters]) ifTrue:[
            classToSearch := classToStartSearch.
            aClass := nil.
            [classToSearch notNil and:[aClass isNil]] whileTrue:[
                aSelector := classToSearch methodDictionary findFirstKey:[:element | matchString match:element].
                aSelector notNil ifTrue:[
                    aClass := classToSearch
                ] ifFalse:[
                    classToSearch := classToSearch superclass
                ]
            ]
        ] ifFalse:[
            aSelector := matchString asSymbolIfInterned.
            aSelector notNil ifTrue:[
                aClass := classToStartSearch whichClassIncludesSelector:aSelector.
            ]
        ].

        aClass notNil ifTrue:[
            nm := aClass name.
"/            showInstance ifFalse:[
"/                ((nm ~= 'Metaclass') and:[nm endsWith:' class']) ifTrue:[
"/                    nm := nm copyButLast:6 "copyTo:(nm size - 5)"
"/                ]
"/            ].
            aClass ~~ actualClass ifTrue:[
                self switchToClassNamed:nm.
            ].    
            self switchToMethodNamed:aSelector "matchString".
            ^ self.
        ]
    ].
    self beep

    "Modified: 17.6.1996 / 16:52:36 / stefan"
    "Modified: 8.10.1996 / 22:06:01 / cg"
!

switchToMethod:aString
    "user clicked on a method line - show code"

    |selectorString selectorSymbol cat|

    (fullProtocol not and:[currentClass isNil]) ifTrue:[^ self].

    "
     kludge: extract real selector
    "
    selectorString := aString withoutSpaces upTo:(Character space).
    selectorSymbol := selectorString asSymbolIfInterned.
    selectorSymbol isNil ifTrue:[
        self beep.
        ^ self
    ].

    fullProtocol ifTrue:[
        self releaseMethod.
        "
         search which class implements the selector
        "
        self classesInFullProtocolHierarchy:actualClass do:[:c |
            (currentMethod isNil 
             and:[c includesSelector:selectorSymbol]) ifTrue:[
                currentSelector := selectorSymbol.
                currentMethod := c compiledMethodAt:selectorSymbol.
                acceptClass := c
            ]
        ]
    ] ifFalse:[
        currentSelector := selectorSymbol.
        currentMethod := actualClass compiledMethodAt:selectorSymbol.
    ].

    methodCategoryListView notNil ifTrue:[
        currentMethod notNil ifTrue:[
            cat := currentMethod category.
            (currentMethodCategory ~= cat) ifTrue:[
                currentMethodCategory := cat.
                methodCategoryListView setSelectElement:currentMethodCategory
            ]
        ]
    ].

    self methodSelectionChanged.
    currentSelector notNil ifTrue:[
        "/ self addToClassHistory: actualClass name asString, ' ', currentSelector
        self class addToClassHistory:actualClass selector:currentSelector
    ]

    "Modified: / 27.7.1998 / 11:01:38 / cg"
!

switchToMethodNamed:matchString
    "switch (in the current class) to a method named matchString.
     If there are more than one matches, switch to the first."

    |aSelector method cat classToSearch dict m idx|

    currentClass notNil ifTrue:[
        classToSearch := actualClass.
        dict := classToSearch methodDictionary.

        ((matchString ~= '*') and:[matchString includesMatchCharacters]) ifTrue:[
            aSelector := dict findFirstKey:[:element | matchString match:element].       
            aSelector notNil ifTrue:[
                method := dict at:aSelector.
            ]
        ] ifFalse:[
            (aSelector := matchString asSymbolIfInterned) notNil ifTrue:[
                method := dict at:aSelector ifAbsent:nil
            ].
        ].

        method notNil ifTrue:[
            cat := method category.
            cat isNil ifTrue:[cat := '* all *'].
            methodCategoryListView setSelectElement:cat.
            currentMethodCategory := cat.
            self updateMethodCategoryListWithScroll:false.
            self methodCategorySelectionChanged.

            self releaseMethod.
            currentMethod := method.
            currentSelector := aSelector.

            m := aSelector , '*(*)'.
            selectorList notNil ifTrue:[
                idx := selectorList findFirst:[:line |
                                                    line = aSelector
                                                    or:[m match:line]].
"/            idx := methodListView list findFirst:[:line |
"/                                                line = aSelector
"/                                                or:[m match:line]].

                methodListView setSelection:idx. "/ setSelectElement:aSelector.
            ].
            self methodSelectionChanged.
            ^ self
        ]
    ].
    self beep.

    "Modified: / 28.6.1996 / 20:28:56 / stefan"
    "Modified: / 27.7.1998 / 11:01:55 / cg"
!

updateMethodList
    self updateMethodListWithScroll:true keepSelection:false
!

updateMethodListWithScroll:scroll
    self updateMethodListWithScroll:scroll keepSelection:false
!

updateMethodListWithScroll:scroll keepSelection:keep
    |selectors scr first last selection searchCategory|

    methodListView notNil ifTrue:[
        selection := methodListView selection.

        searchCategory := currentMethodCategory.
        (currentClass notNil
        and:[currentClass supportsMethodCategories not]) ifTrue:[
            searchCategory := '* all *'
        ].

        (searchCategory notNil 
        and:[actualClass notNil]) ifTrue:[
            fullProtocol ifTrue:[
                selectors := self listOfAllSelectorsInCategory:searchCategory 
                                inFullProtocolHierarchyOfClass:actualClass
            ] ifFalse:[
                selectors := self listOfAllSelectorsInCategory:searchCategory
                                                       ofClass:actualClass
            ]
        ].
        scr := scroll.
        first := methodListView firstLineShown.
        first ~~ 1 ifTrue:[
            last := methodListView lastLineShown.
            selectors size <= (last - first + 1) ifTrue:[
                scr := true
            ]
        ].

        scr ifTrue:[
            methodListView list:selectors
        ] ifFalse:[
            methodListView setList:selectors
        ].

        (variableListView notNil 
        and:[variableListView hasSelection]) ifTrue:[
            self hilightMethodsInMethodList.
        ].

        keep ifTrue:[
            methodListView setSelection:selection.
        ].
        ^ self
    ].

    classMethodListView notNil ifTrue:[
        self updateClassMethodListWithScroll:scroll keepSelection:keep
    ].

    "Modified: 18.12.1995 / 22:54:04 / stefan"
    "Modified: 30.7.1997 / 15:55:06 / cg"
! !

!BrowserView methodsFor:'misc'!

beep
    "output an audible beep or bell on my screen device"

    UserPreferences current beepInEditor ifTrue:[                
        super beep
    ]
!

codeChanged
    codeView modified ifTrue:[
        self stopSyntaxHighlightProcess.
        codeModified := true.
        self startSyntaxHighlightProcess.
    ]

    "Created: / 31.3.1998 / 14:25:29 / cg"
    "Modified: / 18.6.1998 / 09:27:52 / cg"
!

compressedCodeLinesFor:someCode
    |s|

    s := someCode asString string asCollectionOfLines copy.
    [s last isEmpty] whileTrue:[s removeLast].
    s := s collect:[:s | |t|
			   s notNil ifTrue:[
			      t := s withoutTrailingSeparators.
			      t size == 0 ifTrue:[
				  nil
			      ] ifFalse:[
				  t
			      ].
			   ] ifFalse:[
			      s
			   ]
		     ].
    ^ s

    "Created: / 17.6.1998 / 16:48:03 / cg"
!

instanceProtocol:aBoolean
    "switch between instance and class protocol"

    |onToggle offToggle|

    showInstance ~~ aBoolean ifTrue:[
        self checkSelectionChangeAllowed ifTrue:[
            instanceToggle notNil ifTrue:[
                aBoolean ifTrue:[
                    offToggle := classToggle.
                    onToggle := instanceToggle.
                ] ifFalse:[
                    onToggle := classToggle.
                    offToggle := instanceToggle.
                ].
                onToggle turnOn.
                offToggle turnOff.
            ].
            showInstance := aBoolean.

            (variableListView notNil
            and:[variableListView hasSelection]) ifTrue:[
                self unhilightMethodCategories.
                self unhilightMethods.
                variableListView setSelection:nil
            ].

            fullProtocol ifTrue:[
                showInstance ifTrue:[
                    actualClass := currentClassHierarchy.
                ] ifFalse:[
                    actualClass := currentClassHierarchy theMetaclass.
                ].
                acceptClass := actualClass.

                self updateClassList.
                self updateMethodCategoryListWithScroll:false.
                self updateMethodListWithScroll:false.
                self updateVariableList.
                ^ self
            ].
            currentClass notNil ifTrue:[
                self classSelectionChanged
            ].
            codeView modified:false.
            codeModified := false.
        ] ifFalse:[
            aBoolean ifTrue:[
                onToggle := classToggle.
                offToggle := instanceToggle
            ] ifFalse:[
                offToggle := classToggle.
                onToggle := instanceToggle.
            ].
            onToggle turnOn.
            offToggle turnOff.
        ]
    ]

    "Modified: / 31.3.1998 / 23:40:04 / cg"
!

openAboutThisApplication
    "opens an about box for this application."

    Dialog aboutClass:self class.

    "Modified: / 12-09-2006 / 17:20:19 / cg"
!

openBrowserDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'tools/sbrowser/TOP.html'
!

openKeywordIndexDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'index.html'
!

processName
    "the name of my process - for the processMonitor only"

    ^ 'System Browser'.
!

showActivity:someMessage
    "some activityNotification to be forwarded to the user;
     show it in the windows title area here."

    someMessage size == 0 ifTrue:[
	self normalLabel
    ] ifFalse:[
	self busyLabel:someMessage with:nil
    ]

    "Created: 16.12.1995 / 18:41:37 / cg"
    "Modified: 23.4.1996 / 21:39:24 / cg"
!

updateCodeView
    |code sourceLineNumber doStartSyntax highlighter|

    codeView modifiedChannel retractInterestsFor:self.

    aspect == #hierarchy ifTrue:[
        ^ self classHierarchy
    ].
    aspect == #classInstVars ifTrue:[
        ^ self classClassInstVars
    ].
    aspect == #comment ifTrue:[
        ^ self classComment
    ].
    aspect == #primitiveDefinitions ifTrue:[
        ^ self classPrimitiveDefinitions
    ].
    aspect == #primitiveFunctions ifTrue:[
        ^ self classPrimitiveFunctions
    ].
    aspect == #primitiveVariables ifTrue:[
        ^ self classPrimitiveVariables
    ].
    aspect == #revisionInfo ifTrue:[
        ^ self classRevisionInfo
    ].

    fullClass ifTrue:[
        currentClass notNil ifTrue:[
            currentClass isLoaded ifTrue:[
                code := currentClass source.
            ] ifFalse:[
                code := currentClass definition.
            ].
        ]
    ] ifFalse:[
        aspect == #definition ifTrue:[
            ^ self classDefinition
        ].

        currentMethod notNil ifTrue:[
            (codeView acceptAction isNil
            and:[actualClass notNil 
            and:[currentMethodCategory notNil]]) ifTrue:[
                self setAcceptAndExplainActionsForMethod.
            ].

            code := currentMethod source.
            sourceLineNumber := currentMethod sourceLineNumber.

            code isNil ifTrue:[
                (sourceLineNumber isNil
                or:[currentMethod sourcePosition isNil
                or:[currentMethod getSource isNil]]) ifTrue:[
                    code := '"
Sorry, but the methods sourceCode is not available.

Probably, the methods sourceCode-info was stripped from the system.
"'.
                ] ifFalse:[
                    code := '"
Sorry, but the methods sourceCode is not available.

If this ST/X is a ' , 'regular distribution' allBold ,', please check the setting of
your systemPath which contains a collection of pathNames.
The system searches those directories for a subdirectory named ''source'', 
which itself should contain the classes source file.
Also, check if that directory and/or sourceFile grants read access.
The sourcePath can be accessed via 
    Smalltalk systemPath 
and
    Smalltalk systemPath:aCollectionOfPathStrings

To fix this (in the running system), evaluate:
    Smalltalk systemPath addFirst:''<<pathOfDirContainingSourceDir>>.''
    Smalltalk flushPathCaches.

You may also want to add those statements to the end of your ''private.rc''
file - so you will not get this error again and again. 

Also, check if you have the sourceCodeManagement (CVS) enabled,
and (if so) configured correctly.

If all of the above fail, and you know the path of the source file,
you can workaround the problem, by adding a symbolic link to that sourcefile
in the ''source'' directory.


If this is ST/X a ' , 'demo-distribution' allBold ,', the source for some classes is not
published, and this may be normal behavior (unless it happens for all classes).
Notice, that it is possible to browse & add new methods - even with missing sources.
"'.
                ].
                self clearAcceptAction.
            ] ifFalse:[       
                (UserPreferences current autoFormatting
                and:[RBFormatter notNil]) ifTrue:[
                    Error catch:[
                        code := RBFormatter format:code.
                    ].
                ].
                UserPreferences current syntaxColoring ifTrue:[
                    currentMethod notNil ifTrue:[
                        highlighter := currentMethod syntaxHighlighterClass.
                        highlighter == #askClass ifTrue:[
                            highlighter := (actualClass ? Smalltalk) syntaxHighlighterClass.
                        ]
                    ] ifFalse:[
                        highlighter := (actualClass ? Smalltalk) syntaxHighlighterClass.
                    ].
                    highlighter notNil ifTrue:[
                        code size < 5000 ifTrue:[       
                            code := highlighter formatMethodSource:code in:actualClass.
                            codeView modifiedChannel onChangeSend:#codeChanged to:self.
                        ] ifFalse:[
                            doStartSyntax := true.
                        ]
                    ]
                ]
            ]
        ]
    ].

    "/ do async redraw - avoids visible scroll when an autoSearch is
    "/ done soon ...

    code size > 0 ifTrue:[
        codeView setList:(code asStringCollection) expandTabs:true redraw:false.
        codeView cursorHome.
        codeView unselectWithoutRedraw.
        codeView invalidate.
    ] ifFalse:[
        codeView contents:code.
    ].

    codeView modified:false.
    codeModified := false.

    doStartSyntax == true ifTrue:[
        self startSyntaxHighlightProcess.
    ].

    sourceLineNumber notNil ifTrue:[
        sourceLineNumber ~~ 1 ifTrue:[
            codeView gotoLine:sourceLineNumber.
            sourceLineNumber > 10 ifTrue:[
                sourceLineNumber := sourceLineNumber - 10
            ].
            codeView scrollToLine:sourceLineNumber.
        ].
    ].
    self normalLabel.

    "Created: / 23.11.1995 / 14:16:43 / cg"
    "Modified: / 10.2.2000 / 14:15:03 / cg"
! !

!BrowserView methodsFor:'namespace menu'!

nameSpaceCheckInEach
    |classes|

    (self checkSelectionChangeAllowedWithCompare:false) ifFalse:[^ self].

    classes := currentNamespace allClasses.
    classes isEmpty ifTrue:[
        self warn:(resources 
                        string:'No classes in nameSpace ''%''.'
                        with:currentNamespace name).
        ^ self
    ].

    self withWaitCursorDo:[
        |info|


        info := SourceCodeManagerUtilities
                        getCheckinInfoFor:(resources 
                                            string:'(any in nameSpace %1)'
                                            with:currentNamespace name)
                        initialAnswer:nil
                        withQuickOption:true.

        info notNil ifTrue:[
            "/ ignore private classes
            classes := classes select:[:aClass | aClass owningClass isNil].
            info quickCheckIn ifTrue:[
                classes := classes select:[:aClass | ChangeSet current includesChangeForClassOrMetaclass:aClass].
                classes isEmpty ifTrue:[^ self ].
            ].

            classes do:[:aClass |
                self busyLabel:'checking in %1' with:aClass name.
                "/ ca does not want boxes to pop up all over ...
                InformationSignal handle:[:ex |
                    Transcript showCR:ex description
                ] do:[
                    SourceCodeManagerUtilities 
                        checkinClass:aClass withInfo:info.
                ].
                self normalLabel.
            ]
        ].
        self normalLabel.
    ]

    "Created: / 23-11-1995 / 11:41:38 / cg"
    "Modified: / 15-06-1996 / 00:25:58 / stefan"
    "Modified: / 12-10-2006 / 23:55:21 / cg"
!

nameSpaceMenu
    <resource: #programMenu >

    |items m|

    items := #( 
                ('New NameSpace' nameSpaceNewNameSpace)
              ).

"/    showAllNamespaces ifTrue:[
"/        items := items , #( ('-') ('show topLevel namespaces only' showTopLevelNamespaces)).
"/    ] ifFalse:[
"/        items := items , #( ('-') ('show all namespaces' showAllNamespaces)).
"/    ].


    (currentNamespace notNil
    and:[currentNamespace ~~ Smalltalk
    and:[currentNamespace ~= '* all *']]) ifTrue:[
        "/ is it all empty ?
        currentNamespace allClasses isEmpty ifTrue:[
            items := items , #(
                                ('-') 
                                ('Remove' nameSpaceRemove)).
        ] ifFalse:[
            items := items , #(
                                ('-') 
                                ('Remove all Classes...' nameSpaceRemoveAllClasses)
                                ('-') 
                                ('Checkin each...'       nameSpaceCheckInEach)
                              ).
        ]
    ].

    m := PopUpMenu itemList:items resources:resources performer:self.
    self environment ~~ Smalltalk ifTrue:[
        m disableAll:#(nameSpaceRemove nameSpaceRemoveAllClasses nameSpaceCheckInEach nameSpaceNewNameSpace)
    ].
    ^ m.

    "Created: / 4.1.1997 / 23:51:38 / cg"
    "Modified: / 3.2.1999 / 20:13:57 / cg"
!

nameSpaceNewNameSpace
    "create a namespace-definition prototype in codeview"

    self classClassDefinitionTemplateFor:nil in:nil nameSpace:true private:false.
    aspect := nil.

    "Created: / 23-12-1996 / 13:11:48 / cg"
!

nameSpaceRemove
    "remove that nameSpace - but only if its empty"

    (currentNamespace ~~ Smalltalk
    and:[currentNamespace allClasses isEmpty]) ifTrue:[
        self withWaitCursorDo:[
            environment removeClass:currentNamespace.
            allNamespaces := nil.
            self setListOfNamespaces.
            self changeNameSpaceTo:'* all *'.
            namespaceList contents:'* all *'
        ]
    ].

    "Modified: 18.8.1997 / 15:44:31 / cg"
!

nameSpaceRemoveAllClasses
    "remove all classes in that nameSpace - but only after confirmation"

    |classes|

    classes := currentNamespace allClasses.
    classes isEmpty ifTrue:[
        self warn:(resources 
                        string:'No classes in nameSpace ''%''.'
                        with:currentNamespace name).
        ^ self
    ].
    (self confirm:(resources 
                    string:'Really remove all %1 classes in nameSpace ''%2'' ?' 
                    with:classes size printString
                    with:currentNamespace name)) ifFalse:[
        ^ self
    ].

    self withWaitCursorDo:[
        classes copy do:[:cls |
            environment removeClass:cls.
        ]
    ]

    "Modified: / 3.2.1999 / 20:18:13 / cg"
! !

!BrowserView methodsFor:'namespace stuff'!

changeNameSpaceTo:nsName
    |n selectedClass str selectedCategory l newCat|

    nsName = '* all *' ifTrue:[
        currentNamespace := nsName.
    ] ifFalse:[
        n := environment at:nsName asSymbol.
        n isNameSpace ifTrue:[
            currentNamespace := n.
        ] ifFalse:[
            ^ self
        ]
    ].

    selectedClass := actualClass.
    currentClass := actualClass := nil.
    selectedCategory := currentClassCategory.

    self updateClassCategoryListWithScroll:true.
    selectedCategory notNil ifTrue:[
        self classCategorySelectionChanged.
    ].

    selectedClass notNil ifTrue:[
        str := self displayedClassNameOf:selectedClass.

        self switchToClassNamed:str.

        ((l := classListView list) isNil
        or:[(l includes:str) not]) ifTrue:[
             currentClassCategory := nil.
             currentClass := nil.
             aspect := nil.   
             self updateMethodCategoryList.
             self updateMethodList.
             self updateCodeView.
        ].

        (classCategoryListView notNil and:[currentClass notNil]) ifTrue:[
            newCat := currentClass category.
            (currentClassCategory = newCat) ifFalse:[
                currentClassCategory := newCat.
                classCategoryListView setSelectElement:newCat
            ]
        ].
    ]

    "Created: 3.1.1997 / 11:11:13 / cg"
    "Modified: 29.1.1997 / 18:33:42 / cg"
!

displayedClassNameOf:aClass
    "depending on the current nameSpace, either show a classes
     fullname or its name without the namespace prefix (if its in the current)"

    |owner nm ns|

    aClass isJavaClass ifTrue:[
	^ aClass fullName "/ asString replaceAll:$/ with:$.
    ].

    "/ in which nameSpace is that class (or its owner) ?

    owner := aClass topOwningClass.
    owner notNil ifTrue:[
	ns := owner nameSpace.
    ] ifFalse:[
	ns := aClass nameSpace.
    ].

    "/ this 'cannot' happen (should always be Smalltalk)
    ns isNil ifTrue:[
	^ aClass name
    ].

    currentNamespace = '* all *' ifTrue:[
	(ns == Smalltalk) ifTrue:[
	    nm := aClass nameWithoutNameSpacePrefix.
	    ^ nm
	].
	nm := aClass nameWithoutNameSpacePrefix.
	^ ns name , '::' , nm   "/ full name
"/        ^ aClass name        "/ full name
    ].

    nm := aClass nameWithoutNameSpacePrefix.

    "/ is it in one of the selected namespaces ?

    (self findClassNamedInNameSpace:nm) isNil ifTrue:[
	^ ns name , '::' , nm   "/ full name
    ].
    currentNamespace = ns ifFalse:[
	^ ns name , '::' , nm   "/ full name
    ].
    ^ nm.

    "Created: 20.12.1996 / 17:46:41 / cg"
    "Modified: 31.7.1997 / 22:57:16 / cg"
!

listOfAllNamespaces
    "return a list of all namespaces"

    allNamespaces isNil ifTrue:[
        allNamespaces := NameSpace allNameSpacesIn:environment.
        allNamespaces remove:environment.

        showAllNamespaces ifFalse:[
            "/ only topLevel namespaces are shown
            "/ i.e. ignore subspaces 
            allNamespaces := allNamespaces select:[:ns | ns isTopLevelNameSpace].
        ]
    ].
    ^ allNamespaces

    "Modified: 31.7.1997 / 22:32:30 / cg"
!

listOfNamespaces
    "return a list of considered namespaces"

    currentNamespace isNil ifTrue:[
        ^ Array with:environment
    ].

    currentNamespace = '* all *' ifTrue:[
        ^ self listOfAllNamespaces
    ].

    ^ Array with:currentNamespace

    "Created: 26.10.1996 / 11:25:39 / cg"
    "Modified: 20.12.1996 / 19:18:18 / cg"
!

setListOfNamespaces
    |l hasSmalltalk|

    namespaceList isNil ifTrue:[ ^ self ].

    l := self listOfAllNamespaces collect:[:ns | ns name].
    l := l asOrderedCollection.
    hasSmalltalk := true.
    l remove:'Smalltalk' ifAbsent:[hasSmalltalk := false].
    l sort.
    l addFirst:'-'.
    hasSmalltalk ifTrue:[
	l addFirst:'Smalltalk'
    ].
    l addFirst:'* all *'.
    namespaceList list:l

    "Modified: 20.12.1996 / 19:18:29 / cg"
!

showAllNamespaces
    "toggle to show all namespaces"

    showAllNamespaces := true.
    self updateNamespaceList

    "Modified: 31.7.1997 / 22:33:16 / cg"
!

showTopLevelNamespaces
    "toggle to show topLevel namespaces only"

    showAllNamespaces := false.
    self updateNamespaceList

    "Created: 31.7.1997 / 22:33:29 / cg"
!

updateNamespaceList
    allNamespaces := nil.
    namespaceList notNil ifTrue:[
	self setListOfNamespaces
    ].

    "Created: 8.1.1997 / 10:54:03 / cg"
! !

!BrowserView methodsFor:'private'!

askAndBrowseMethodCategory:title action:aBlock
    "convenient helper method: setup enterBox with initial being current method category"

    |sel box|

    box := self 
                enterBoxTitle:title 
                okText:'Browse'
                label:'browse category'.

    sel := codeView selection.
    sel isNil ifTrue:[
        currentMethodCategory notNil ifTrue:[
            sel := currentMethodCategory
        ]
    ].
    sel notNil ifTrue:[
        box initialText:(sel asString withoutSpaces)
    ].
    box action:[:aString | self withWaitCursorDo:[aBlock value:aString]].
    box open

    "Modified: / 18.6.1998 / 16:40:46 / cg"
!

askForMethodCategory
    "convenient helper method: setup a box asking for a method category"

    |someCategories box txt retVal|

    someCategories := actualClass categories asOrderedCollection sort.
    box := self listBoxTitle:'Accept in which method category ?' okText:'Accept' list:someCategories.

    lastMethodCategory isNil ifTrue:[
        txt := Compiler defaultMethodCategory "/ 'new methods' - '** As yet uncategorized **'
    ] ifFalse:[
        txt := lastMethodCategory
    ].
    box initialText:txt.
    box action:[:aString | aString notEmpty ifTrue:[retVal := aString] ].
    box open.
    ^ retVal

    "Modified: / 18.7.1998 / 22:18:25 / cg"
!

askForSearchSelectorTitle:title openWith:aSelector
    "convenient helper method: setup enterBox with text from codeView or selected
     method for browsing based on a selector. Set action and launch box"

    ^ self 
	askForSearchTitle:title 
	openWith:aSelector 
	isSelector:true

    "Modified: / 18.6.1998 / 16:40:39 / cg"
!

askForSearchTitle:title openWith:aSelector isSelector:isSelector
    "convenient helper method: setup enterBox with text from codeView or selected
     method for browsing based on a selector. Set action and launch box"

    ^ self
	askForSearchTitle:title 
	openWith:aSelector 
	isSelector:isSelector 
	searchArea:#everywhere

    "Modified: / 18.6.1998 / 16:40:35 / cg"
!

askForSearchTitle:title openWith:aSelector isSelector:isSelector searchArea:whereDefault
    "convenient helper method: setup enterBox with text from codeView or selected
     method for browsing based on a selector. Set action and launch box.
     SearchArea may be one of #everywhere, #classCategory, #class, #classWithPrivateClasses,
     #classHierarchy or #classHierarchyWithPrivateClasses"

    ^ self
	askForSearchTitle:title 
	openWith:aSelector 
	isSelector:isSelector 
	searchArea:whereDefault 
	withCaseIgnore:false

    "Modified: / 18.6.1998 / 16:40:26 / cg"
!

askForSearchTitle:title openWith:aSelector isSelector:isSelector searchArea:whereDefault withCaseIgnore:withCaseIgnore
    "OBSOLETE: NewSystemBrowser has a better dialog for that.
     convenient helper method: setup enterBox with text from codeView or selected
     method for browsing based on a selector. Set action and launch box.
     SearchArea may be one of 
        #everywhere, 
        #currentNameSpace
        #currentClassesNameSpace
        #classCategory, 
        #class, 
        #classWithPrivateClasses,
        #classHierarchy or 
        #classHierarchyWithPrivateClasses"

    |box panel selectorHolder where whereChannel caseHolder
     b sel classes areas toSearch cls inputField ns|

    areas := OrderedCollection new.

    sel := isSelector ifTrue:[self selectorToSearchFor] ifFalse:[self stringToSearchFor].
    sel size == 0 ifTrue:[
        "/ use last searchString
        LastSearchPatterns size > 0 ifTrue:[
            sel := LastSearchPatterns first.
        ].
    ].
    selectorHolder := sel asValue.

    box := Dialog new.
    box addTextLabel:(resources string:title) adjust:#left.

    inputField := box addComboBoxOn:selectorHolder tabable:true.
    inputField list:LastSearchPatterns.

    inputField selectAllInitially.
    inputField entryCompletionBlock:[:contents |
        |s what m|

        s := contents string withoutSpaces.
        box topView withWaitCursorDo:[
            what := Smalltalk selectorCompletion:s inEnvironment:(environment ? Smalltalk).
            inputField contents:what first.
            (what at:2) size ~~ 1 ifTrue:[
                self beep
            ]
        ]
    ].

    withCaseIgnore ifTrue:[
        box addCheckBox:(resources string:'Ignore case') on:(caseHolder := false asValue).
    ].

    (currentClassCategory notNil 
    or:[currentClass notNil]) ifTrue:[
        box addHorizontalLine.
        box addVerticalSpace.

        box addTextLabel:(resources string:'Search in:') adjust:#left.

        panel := VerticalPanelView new.
        panel horizontalLayout:#fitSpace.

        whereChannel := RadioButtonGroup new.
        b := CheckBox label:(resources string:'Everywhere').
        panel add:b. whereChannel add:b value:#everywhere.
        areas add:#everywhere.
        box makeTabable:b.

"/        classMethodListView notNil ifTrue:[
"/            b := CheckBox label:(resources string:'shown methods').
"/            panel add:b. whereChannel add:b value:#currentMethodList.
"/            areas add:#currentMethodList.
"/            box makeTabable:b.
"/        ].

        currentNamespace ~= '* all *' ifTrue:[
            b := CheckBox label:(resources string:'Current NameSpace').
            panel add:b. whereChannel add:b value:#currentNameSpace.
            areas add:#currentNameSpace.
            box makeTabable:b.
        ] ifFalse:[
            (currentClass notNil 
            and:[(ns := currentClass nameSpace) notNil 
            and:[ns ~~ Smalltalk]]) ifTrue:[
                b := CheckBox label:(resources string:'Classes NameSpace (''%1'')' with:ns name).
                panel add:b. whereChannel add:b value:#currentClassesNameSpace.
                areas add:#currentClassesNameSpace.
                box makeTabable:b.
            ]
        ].

        currentClassCategory notNil ifTrue:[
            b := CheckBox label:(resources string:'Class Category (''%1'')' with:currentClassCategory).
            panel add:b. whereChannel add:b value:#classCategory.
            areas add:#classCategory.
            box makeTabable:b.
        ].

        currentClass notNil ifTrue:[
            b := CheckBox label:(resources string:'Class (''%1'')' with:currentClass name).
            panel add:b. whereChannel add:b value:#class.
            areas add:#class.
            box makeTabable:b.

            b := CheckBox label:(resources string:'Class & Superclasses').
            panel add:b. whereChannel add:b value:#classAndSuperclasses.
            areas add:#classAndSuperclasses.
            box makeTabable:b.
            currentClass superclass isNil ifTrue:[
                b disable
            ].

            b := CheckBox label:(resources string:'Class & Subclasses').
            panel add:b. whereChannel add:b value:#classHierarchy.
            areas add:#classHierarchy.
            box makeTabable:b.

            currentClass subclasses size == 0 ifTrue:[
                b disable.
            ].

            b := CheckBox label:(resources string:'Class & Private Classes').
            panel add:b. whereChannel add:b value:#classWithPrivateClasses.
            areas add:#classWithPrivateClasses.
            box makeTabable:b.
        
            fullProtocol ifTrue:[
                cls := actualClass theNonMetaclass.
            ] ifFalse:[
                cls := currentClass
            ].
            cls privateClasses size == 0 ifTrue:[
                b disable
            ].

            b := CheckBox label:(resources string:'Class & Subclasses & All Private Classes').
            panel add:b. whereChannel add:b value:#classHierarchyWithPrivateClasses.
            areas add:#classHierarchyWithPrivateClasses.
            box makeTabable:b.

            currentClass subclasses size == 0 ifTrue:[
                b disable.
            ] ifFalse:[
"/ this takes too long ...
"/                toSearch := IdentitySet new.
"/                currentClass withAllSubclasses do:[:cls | toSearch add:cls privateClasses].
"/                toSearch size == 0 ifTrue:[
"/                    b disable
"/                ]
            ]
        ].

        whereDefault notNil ifTrue:[
            (areas includes:whereDefault) ifTrue:[
                where := whereDefault asSymbol
            ] ifFalse:[
                where := areas first.
            ]
        ] ifFalse:[
            where := #everywhere.
        ].
        whereChannel value:where.
        box addComponent:panel indent:0.  "/ panel has its own idea of indenting

        box addVerticalSpace.
        box addHorizontalLine.
    ] ifFalse:[
        whereChannel := #everywhere asValue.
    ].

    box addAbortButton.
    box addOkButtonLabelled:(resources string:'Browse').

    box label:(resources string:'Search').
    box open.

    box accepted ifTrue:[
        sel := selectorHolder value.
        where := whereChannel value.

        sel isEmpty ifTrue:[
            self warn:'Nothing entered for search'.
            ^ self.
        ].
        where isNil ifTrue:[
            self warn:'No class(es) for search'.
            ^ self.
        ].
        sel := sel string.

        LastSearchPatterns isNil ifTrue:[
            LastSearchPatterns := OrderedCollection new.
        ].
        (LastSearchPatterns includes:sel) ifTrue:[
            LastSearchPatterns remove:sel.
        ] ifFalse:[
            LastSearchPatterns size > 15 ifTrue:[
                LastSearchPatterns removeFirst
            ]
        ].
        LastSearchPatterns addFirst:sel.

        where == #everywhere ifTrue:[
            classes :=  environment allClasses.
        ] ifFalse:[ where == #currentNameSpace ifTrue:[
            classes := currentNamespace allClassesWithAllPrivateClasses
        ] ifFalse:[ where == #currentClassesNameSpace ifTrue:[
            currentClass isPrivate ifTrue:[
                classes := currentClass topOwningClass nameSpace allClassesWithAllPrivateClasses
            ] ifFalse:[
                classes := currentClass nameSpace allClassesWithAllPrivateClasses
            ]
        ] ifFalse:[ where == #classCategory ifTrue:[
            classes := environment allClassesInCategory:currentClassCategory
        ] ifFalse:[(where == #class or:[where == #classWithPrivateClasses]) ifTrue:[
            currentClass isNil ifTrue:[
                classes := #()
            ] ifFalse:[
                classes := Array with:currentClass
            ]
        ] ifFalse:[ (where == #classHierarchy or:[where == #classHierarchyWithPrivateClasses]) ifTrue:[
            classes := currentClass withAllSubclasses
        ] ifFalse:[ (where == #classAndSuperclasses) ifTrue:[
            classes := currentClass withAllSuperclasses
        ]]]]]]].

        (where == #classWithPrivateClasses 
        or:[where == #classHierarchyWithPrivateClasses]) ifTrue:[
            toSearch := IdentitySet withAll:classes.
            classes := IdentitySet withAll:toSearch.

            [toSearch notEmpty] whileTrue:[
                cls := toSearch removeFirst.
                classes addAll:cls allPrivateClasses.
            ].
            classes := classes asOrderedCollection.
        ].

        classes isEmpty ifTrue:[
            self warn:'No class(es) given for search'.
        ] ifFalse:[
            self withSearchCursorDo:[
                withCaseIgnore ifTrue:[
                    SystemBrowser perform:aSelector with:sel with:classes with:caseHolder value
                ] ifFalse:[
                    SystemBrowser perform:aSelector with:sel with:classes
                ]
            ]
        ]
    ]

    "Created: / 18.6.1998 / 16:39:44 / cg"
    "Modified: / 5.11.2001 / 16:29:14 / cg"
!

busyLabel:what with:someArgument
    "set the title for some warning"

    self topView
	label:('System Browser - ' , (resources string:what with:someArgument))

    "Modified: 18.8.1997 / 15:19:15 / cg"
!

checkAcceptedMethod:mthdHere inClass:actualClass
    "method was accepted - do some standard checks"

    |sel cls superCls implClass mthdThere treeHere treeThere dictionary|

    (RBParser notNil and:[RBParser isLoaded]) ifTrue:[
        "/ does new method redefine an inherited method,
        "/ which does the same ?

        sel := mthdHere selector.
        cls := mthdHere mclass.

        ( #( 
            documentation
            version
            examples
            copyright
            history
           ) includes:sel) ifTrue:[
            cls isMeta ifTrue:[
                ^ self
            ]
        ].
        superCls := cls superclass.
        superCls notNil ifTrue:[
            implClass := superCls whichClassIncludesSelector:sel.
        ].
        implClass notNil ifTrue:[
            "/ ok, it is redefined
            mthdThere := implClass compiledMethodAt:sel.
            treeHere := RBParser 
                            parseMethod:mthdHere source
                            onError: [:aString :position | ^ self "ignore any error"].
            treeHere isNil ifTrue:[^ self].
            treeThere := RBParser 
                            parseMethod:mthdThere source
                            onError: [:aString :position | ^ self "ignore any error"].
            treeThere isNil ifTrue:[^ self].

            dictionary := Dictionary new.
            (treeHere body equalTo: treeThere body withMapping: dictionary) ifTrue:[
                self information:'This methods functionality is already inherited from ', implClass name.
            ] 
        ]        
    ].

    "Modified: / 18.2.2000 / 11:34:12 / cg"
!

checkSelectionChangeAllowed
    "return true, if selection change is ok;
     its not ok, if code has been changed.
     in this case, return the result of a user query"

    |what m cls src1 src2 list1 list2 v|

    codeView modified ifFalse:[
        codeModified == true ifFalse:[
            ^ true
        ]
    ].

    cls := acceptClass ? actualClass.

    (currentMethod notNil and:[cls notNil]) ifTrue:[
        self withWaitCursorDo:[
            m := cls compiledMethodAt:currentSelector.
            m notNil ifTrue:[
                src1 := m source.
                src1 notNil ifTrue:[src1 := src1 string].
                src2 := codeView contentsAsString.
                src2 notNil ifTrue:[src2 := src2 string].

                (src1 ~= src2) ifTrue:[
                    src1 size == 0 ifTrue:[
                        list1 := #()
                    ] ifFalse:[
                        list1 := src1 asCollectionOfLines 
                                        collect:[:line | 
                                                    line isNil ifTrue:['']
                                                    ifFalse:[
                                                        line 
                                                            withoutTrailingSeparators
                                                                withTabsExpanded
                                                    ]
                                                ].
                    ].
                    list2 := src2 asCollectionOfLines collect:[:line | line isNil ifTrue:['']
                                                               ifFalse:[
                                                                    line 
                                                                        withoutTrailingSeparators
                                                                            withTabsExpanded
                                                               ]
                                                      ].
                    HistoryManager notNil ifTrue:[
                        list1 := HistoryManager withoutHistoryLines:list1 asStringCollection asString.
                        list2 := HistoryManager withoutHistoryLines:list2 asStringCollection asString.
                    ].

                    list1 = list2 ifFalse:[
                        what := self checkSelectionChangeAllowedWithCompare:true.
                        what == #compare ifTrue:[
                            v := DiffCodeView 
                                    openOn:src2 
                                    label:(resources string:'Code here (to be accepted ?)')
                                    and:src1
                                    label:(resources string:'Method''s actual code').
                            v label:(resources string:'Comparing method versions').
                            ^ false
                        ].
                        ^ what
                    ].
                ].
                ^ true
            ]
        ]
    ].

    ^ self checkSelectionChangeAllowedWithCompare:false

    "Created: / 24.11.1995 / 11:03:33 / cg"
    "Modified: / 7.4.1998 / 09:49:52 / cg"
!

checkSelectionChangeAllowedWithCompare:compareOffered
    "return true, if selection change is ok;
     its not ok, if code has been changed.
     in this case, return the result of a user query"

    |action labels values|

    codeView modified ifFalse:[
        codeModified ifFalse:[
            ^ true
        ]
    ].

    compareOffered ifTrue:[
        labels := #('Cancel' 'Compare' 'Accept' 'Continue').
        values := #(false #compare #accept true).
    ] ifFalse:[
        labels := #('Cancel' 'Accept' 'Continue').
        values := #(false #accept true).
    ].

    action := OptionBox 
                  request:(resources stringWithCRs:'Text has not been accepted.\\Your modifications will be lost when continuing.')
                  label:(resources string:'Attention')
                  image:(WarningBox iconBitmap)
                  buttonLabels:(resources array:labels)
                  values:values
                  default:true
                  onCancel:false.
    action ~~ #accept ifTrue:[
        ^ action
    ].
    codeView accept. 
    ^ true

    "Created: / 24.11.1995 / 10:54:46 / cg"
    "Modified: / 16.11.2001 / 15:33:16 / cg"
!

classHierarchyOf:aClass level:level do:aBlock using:subclassDictionary removeFrom:remainSet
    "evaluate the 2-arg block for every subclass of aClass,
     passing class and nesting level to the block."

    |names subclasses|

    remainSet remove:aClass ifAbsent:[].

    aBlock value:aClass value:level.

    subclasses := subclassDictionary at:aClass ifAbsent:[nil].
    (subclasses size > 0) ifTrue:[
        names := subclasses collect:[:class | class name].
        names sortWith:subclasses.
        subclasses do:[:aSubClass |
            self classHierarchyOf:aSubClass 
                            level:(level + 1) 
                               do:aBlock 
                            using:subclassDictionary
                       removeFrom:remainSet
        ]
    ]

    "Created: 20.12.1996 / 17:05:06 / cg"
    "Modified: 5.1.1997 / 18:45:41 / cg"
!

classHierarchyOf:topClass withAutoloaded:withAutoloaded do:aBlock
    "evaluate the 2-arg block for every class,
     starting at Object; passing class and nesting level to the block."

    |classes s subclassDict l remaining allNameSpaces nameSpaceList|

    classes := IdentitySet new.

    "/ first, collect the list of classes to consider
    "/ that's all classes which are in the selected NameSpaces,
    "/ or private ones, owned by a class which is
    "/ also all of its superclasses are added.

    allNameSpaces := (currentNamespace = '* all *').
    nameSpaceList := self listOfNamespaces.

    environment allClassesDo:[:aClass |
        |actualNamespace match owner|

        aClass isMeta ifFalse:[
            (aClass isRealNameSpace) ifFalse:[
                match := allNameSpaces.
                match ifFalse:[
                    (owner := aClass topOwningClass) notNil ifTrue:[
                        actualNamespace := owner nameSpace
                    ] ifFalse:[
                        actualNamespace := aClass nameSpace.
                    ].
                    match := nameSpaceList includesIdentical:actualNamespace.
                ].
                match ifTrue:[
                    classes addAll:(aClass withAllSuperclasses).
                ]
            ]
        ]
    ].

    "/ now, generate a dictionary, which associates a set of subclasses
    "/ to each ...

    subclassDict := IdentityDictionary new:classes size.
    classes do:[:aClass |
        s := aClass superclass.
        s notNil ifTrue:[
            l := subclassDict at:s ifAbsent:[nil].
            l isNil ifTrue:[
                l := OrderedCollection new:5.
                subclassDict at:s put:l
            ].
            l add:aClass
        ]
    ].

    "/
    "/ walk this ..
    "/
    remaining := classes.
    self classHierarchyOf:topClass level:0 do:aBlock using:subclassDict removeFrom:remaining.

    "/
    "/ if autoloaded classes are wanted ...
    "/
    withAutoloaded ifTrue:[
        (remaining includes:Autoload) ifTrue:[
            self classHierarchyOf:Autoload level:0 do:aBlock using:subclassDict removeFrom:remaining.
        ].
        (remaining asSortedCollection:[:a :b | a name < b name]) do:[:aNilSubclass |
            aBlock value:aNilSubclass value:0
        ]
    ].

    "Created: / 28-05-1996 / 13:46:23 / cg"
    "Modified: / 10-11-2006 / 17:08:47 / cg"
!

classesInFullProtocolHierarchy:aClass do:aBlock
    "evaluate aBlock for all non-striked out classes in
     the hierarchy"

    |index|

    index := (classListView list size).
    aClass withAllSuperclassesDo:[:c |
        (classListView isInSelection:index) ifFalse:[
            aBlock value:c
        ].
        index := index - 1
    ]
!

classesInHierarchy:aClass do:aBlock
    |index|

    index := (classListView list size).
    aClass withAllSuperclassesDo:[:c |
        (classListView isInSelection:index) ifFalse:[
            aBlock value:c
        ].
        index := index - 1
    ]
!

clearAcceptAction
    "tell the codeView that there is nothing to accept"

    codeView acceptAction:nil.

    "Created: / 10.2.2000 / 14:13:25 / cg"
!

clearExplainAction
    "tell the codeView that there is nothing to explain"

    codeView explainAction:nil.
    codeView pointerOverWordAction:nil
!

compileCode:someCode
    (ReadStream on:someCode) fileIn
!

currentMethodsPreviousVersionCode
    currentMethod isNil ifTrue:[^ nil].
    ^ currentMethod previousVersionCode
!

enterBoxForCodeSelectionTitle:title okText:okText
    "convenient method: setup enterBox with text from codeview"

    ^ self enterBoxForCodeSelectionTitle:title withList:nil okText:okText
!

enterBoxForCodeSelectionTitle:title withList:listOrNil okText:okText
    "convenient method: setup enterBox with text from codeview"

    |sel box initialText superclass|

    box := self 
                enterBoxTitle:(resources string:title) 
                withList:listOrNil
                okText:(resources string:okText).

    sel := codeView selection.
    sel notNil ifTrue:[
        initialText := sel asString withoutSeparators
    ] ifFalse:[
        (currentClass notNil 
        and:[(superclass := currentClass superclass) notNil]) ifTrue:[
            initialText := superclass name
        ]
    ].
    initialText notNil ifTrue:[
        box initialText:initialText
    ].
    ^ box

    "Modified: / 22.2.1999 / 18:57:22 / cg"
!

enterBoxForSearchSelectorTitle:title
    "convenient method: setup enterBox with text from codeView or selected
     method for browsing based on a selector"

    |box|

    box := self 
                enterBoxTitle:title 
                okText:'Search'
                label:'Search selector'.

    box initialText:(self selectorToSearchFor).
    ^ box

    "Modified: / 12.10.2001 / 19:44:15 / cg"
!

enterBoxTitle:title okText:okText
    "convenient method: setup enterBox"

    ^ self enterBoxTitle:title withList:nil okText:okText
!

enterBoxTitle:title okText:okText label:label
    "convenient method: setup enterBox"

    |box|

    box := EnterBox new.
    box label:(resources string:label).
    box title:(resources string:title) 
	okText:(resources string:okText).
    ^ box

    "Created: 15.1.1997 / 23:01:04 / cg"
    "Modified: 16.1.1997 / 00:26:31 / cg"
!

enterBoxTitle:title okText:okText label:label list:aList
    "convenient method: setup enterBox"

    |box fieldHolder|

    fieldHolder := ValueHolder new.

    box := DialogBox new.
    box label:(resources string:label).

    box addTextLabel:(resources string:title) adjust:#left.
    box addVerticalSpace.

    aList isNil ifTrue:[
        box addInputFieldOn:fieldHolder.
    ] ifFalse:[
        (box addComboBoxOn:fieldHolder) list:aList
    ].

    box addVerticalSpace:15.
    box addAbortButton;
        addOkButtonLabelled:(resources string:okText).

    box aspectAt:#fieldValue put:fieldHolder.

"/    box showAtPointer.
"/
"/    box := EnterBox new.
"/    box label:(resources string:label).
"/    box title:(resources string:title) 
"/        okText:(resources string:okText).
    ^ box

    "Created: 15.1.1997 / 23:01:04 / cg"
    "Modified: 16.1.1997 / 20:13:28 / cg"
!

enterBoxTitle:title withList:aListOrNil okText:okText
    "convenient method: setup enterBox"

    ^ SystemBrowser enterBoxTitle:title withList:aListOrNil okText:okText
"/    |box|
"/
"/    aListOrNil notNil ifTrue:[
"/        box := EnterBoxWithList new.
"/        box list:aListOrNil.
"/    ] ifFalse:[
"/        box := EnterBox new.
"/    ].
"/    box title:(resources string:title) okText:(resources string:okText).
"/    ^ box
!

environment
    "allows me to browse something different from Smalltalk (a SnapShotImage for example)"

    ^ environment ? Smalltalk
!

environment:anEnvironment
    "allows me to browse something different from Smalltalk (a SnapShotImage for example)"

    environment := anEnvironment
!

extractClassAndSelectorFromSelectionInto:aBlock
    "given a string which can be either 
        'class>>sel', 'class » sel'  or 'class sel', 
    extract className and selector, 
    and call aBlock with the result."

    ^ SystemBrowser extractClassAndSelectorFrom:codeView selection into:aBlock
!

findClassNamed:aClassName
    "search through namespaces for aClassName."

    |nm nameSym cls meta|

    meta := false.
    nm := aClassName.
    (nm endsWith:' class') ifTrue:[
        meta := true.
        nm := nm copyButLast:6.
    ].
    nameSym := nm asSymbol.

    currentNamespace = '* all *' ifTrue:[
        (cls := environment at:nameSym) notNil ifTrue:[
            meta ifTrue:[^ cls theMetaclass].
            ^ cls
        ]
    ].
    self listOfNamespaces do:[:aNamespace |
        (cls := aNamespace at:nameSym) notNil ifTrue:[
            meta ifTrue:[^ cls theMetaclass].
            ^ cls
        ]
    ].
    currentNamespace ~= '* all *' ifTrue:[
        (cls := environment at:nameSym) notNil ifTrue:[
            meta ifTrue:[^ cls theMetaclass].
            ^ cls
        ]
    ].

    (nm startsWith:'Smalltalk::') ifTrue:[
        cls := environment classNamed:(nm withoutPrefix:'Smalltalk::').
        cls notNil ifTrue:[
            meta ifTrue:[^ cls theMetaclass].
            ^ cls
        ]
    ].
    ^ nil

    "Created: 20.12.1996 / 15:39:38 / cg"
    "Modified: 23.1.1997 / 14:21:00 / cg"
!

findClassNamedInNameSpace:aClassName
    "search through current namespaces for aClassName.
     Return the class or nil, if not found."

    |cls owner|

    self listOfNamespaces do:[:aNamespace |
	(cls := aNamespace at:aClassName asSymbol) notNil ifTrue:[
	    (owner := cls topOwningClass) notNil ifTrue:[
		owner nameSpace == aNamespace ifTrue:[
		    ^ cls
		]
	    ] ifFalse:[
		cls nameSpace == aNamespace ifTrue:[
		    ^ cls
		]
	    ]
	]
    ].
    ^ nil

    "Created: 20.12.1996 / 17:41:54 / cg"
    "Modified: 3.1.1997 / 19:30:53 / cg"
!

findClassOfVariable:aVariableName accessWith:aSelector
    "this method returns the class, in which a variable
     is defined; 
     needs either #instVarNames or #classVarNames as aSelector."

    |cls homeClass list|

    "
     first, find the class, where the variable is declared
    "
    cls := currentClass.
    [cls notNil] whileTrue:[
        aSelector == #classInstVarNames ifTrue:[
            list := cls theMetaclass instVarNames
        ] ifFalse:[                             
            list := cls perform:aSelector
        ].
        (list includes:aVariableName) ifTrue:[
            homeClass := cls.
            cls := nil.
        ] ifFalse:[
            cls := cls superclass
        ]
    ].
    homeClass isNil ifTrue:[
        "nope, must be one below ... (could optimize a bit, by searching down
         for the declaring class ...
        "
        homeClass := currentClass
    ] ifFalse:[
"/        Transcript showCR:'starting search in ' , homeClass name.
    ].
    ^ homeClass

    "Modified: / 25.10.1997 / 20:26:25 / cg"
!

hideMethodCategoryList
    classCategoryListView isNil ifTrue:[
	classListView notNil ifTrue:[
	    methodCategoryListView superView extent:0.0 @ 1.0.
	    methodListView superView origin:0.33 @ 0.0 extent:0.67 @ 1.0.
	].
	^ self.
    ].

    methodCategoryListView superView extent:0.0 @ 1.0.
    methodListView superView origin:0.5 @ 0.0 extent:0.5 @ 1.0.

    "Created: 30.7.1997 / 17:50:27 / cg"
    "Modified: 30.7.1997 / 18:00:02 / cg"
!

listBoxForCodeSelectionTitle:title okText:okText
    "convenient method: setup listBox with text from codeview"

    |sel box|

    box := self listBoxTitle:title okText:okText list:nil. 
    sel := codeView selection.
    sel notNil ifTrue:[
	box initialText:(sel asString withoutSeparators)
    ].
    ^ box
!

listBoxTitle:title okText:okText list:aList
    "convenient method: setup a listBox & return it"

    ^ SystemBrowser listBoxTitle:title okText:okText list:aList
!

normalLabel
    "set the normal (inactive) window- and icon labels"

    |l il|

    myLabel notNil ifTrue:[
        "if I have been given an explicit label,
         and its not the default, take that one"

        myLabel ~= 'System Browser' ifTrue:[
            l := il := myLabel
        ]
    ].
    l isNil ifTrue:[    
        l := resources string:'System Browser'.

        currentClass notNil ifTrue:[
"/            l := l, ': ', currentClass name.
            l := self displayedClassNameOf:currentClass.
            classListView isNil ifTrue:[
                currentSelector notNil ifTrue:[
                    l := l , ' ' ,  currentSelector
                ]
            ] ifFalse:[
                currentClass isLoaded ifFalse:[
                    l := l , ' (unloaded)'
                ]
            ].
            il := currentClass nameWithoutPrefix
        ] ifFalse:[
            il := l.
        ]
    ].
    self topView label:l; iconLabel:il.

    "Modified: 18.8.1997 / 15:19:36 / cg"
!

refetchMethod
    |sel|

    sel := currentSelector.
    self releaseMethod.
    currentSelector := sel.
    sel notNil ifTrue:[
        currentMethod := (acceptClass ? actualClass) compiledMethodAt:sel.

        (currentMethod notNil) ifTrue:[
            (currentMethod isWrapped) ifTrue:[
                currentMethod originalMethod addDependent:self.
            ].
            currentMethod addDependent:self.
        ]
    ]

    "Created: / 27-07-1998 / 11:09:35 / cg"
    "Modified: / 22-10-2010 / 12:43:01 / cg"
!

releaseClass
    |cls meta|

    currentClass notNil ifTrue:[
        cls := currentClass.
        cls isMeta ifTrue:[
            meta := cls.
            cls := meta theNonMetaclass
        ] ifFalse:[
            meta := cls theMetaclass
        ].
        cls removeDependent:self.
        meta removeDependent:self.
    ].

    "Created: 13.12.1995 / 15:32:21 / cg"
!

releaseMethod
    currentMethod notNil ifTrue:[
	currentMethod removeDependent:self.
	currentMethod isWrapped ifTrue:[
	    currentMethod originalMethod removeDependent:self.
	]
    ].
    currentMethod := currentSelector := nil.

    "Created: / 27.7.1998 / 10:56:00 / cg"
    "Modified: / 27.7.1998 / 11:26:52 / cg"
!

selectorToSearchFor
    "look in codeView and methodListView for a search-string when searching for selectors"

    |sel t|

    sel := codeView selection.
    sel notNil ifTrue:[
        t := SystemBrowser extractSelectorFrom:sel.
        t notNil ifTrue:[
            sel := t.
        ].
    ] ifFalse:[
        methodListView notNil ifTrue:[
            methodListView selection notNil ifTrue:[
sel := selectorList at:(methodListView selection).
"/                sel := methodListView selectionValue string
            ]
        ] ifFalse:[
            classMethodListView notNil ifTrue:[
                classMethodListView selection notNil ifTrue:[
                    sel := classMethodListView selectionValue string.
                ].
                sel notNil ifTrue:[
                    sel := self selectorFromClassMethodString:sel
                ]
            ]
        ].
        sel notNil ifTrue:[
            sel := sel withoutSpaces upTo:(Character space)
        ] ifFalse:[
            sel := ''
        ]
    ].
    ^ sel string

    "Modified: / 6.2.2000 / 00:59:20 / cg"
!

setAcceptActionForClass
    "tell the codeView what to do on accept and explain"

    ((self isReadOnlyEnvironment) 
    or:[ (currentClass isRealNameSpace)
    or:[ currentClass isNil
    or:[ currentClass isLoaded not ]]])
    ifTrue:[
        self clearAcceptAction.
        ^ self
    ].
    currentClass theNonMetaclass isJavaClass ifTrue:[
        ^ self setAcceptActionForJavaClass.
    ].

    codeView acceptAction:[:theCode |
        |ns compiler|

        currentClass notNil ifTrue:[
            ns := currentClass nameSpace.
            compiler := currentClass subclassDefinerClass.
        ] ifFalse:[
            ns := nil.
            compiler := Compiler.
        ].

        codeView withWaitCursorDo:[

            Class nameSpaceQuerySignal handle:[:ex |
                ns isNil ifTrue:[
                    ex reject
                ].
                ex proceedWith:ns
            ] do:[
                AbortOperationRequest catch:[
                    UndefinedObject createMinimumProtocolInNewSubclassQuery
                    answer:true
                    do:[
                        (Class classRedefinitionNotification) handle:[:ex |
                            |answer|

"/ cg: now always keep the old packageID
                            answer := OptionBox 
                                          request: 
('You are about to change the definition of a class from another (system-) package.
The class is part of the ''%1'' package. 

PS: you can disable this check in the launchers settings-compilation dialog.' 
                                              bindWith:(ex oldPackage allBold))

                                          label:'Class redefinition'
                                          image:(WarningBox iconBitmap)
                                          buttonLabels:#('Cancel' 'Continue')
                                          values:#(#cancel #keep)
                                          default:#keep.

                            (answer == #keep) ifTrue:[
                                ex proceedWith:answer
                            ]
                        ] do:[
                            |rslt|

                            rslt := compiler 
                                        evaluate:theCode asString 
                                        notifying:codeView 
                                        compile:false.

                            rslt isBehavior ifTrue:[
                                self classCategoryUpdate.
                                self updateClassListWithScroll:false.
                                codeView modified:false.
                                codeModified := false.
                            ].
                        ]
                    ]
                ].
            ].
        ].
    ].

    "Modified: / 10-11-2006 / 17:10:04 / cg"
    "Modified: / 02-09-2013 / 09:41:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setAcceptActionForClassInstVars
    "tell the codeView what to do on accept"

    ((self isReadOnlyEnvironment) 
    or:[ currentClass isLoaded not ])
    ifTrue:[
        self clearAcceptAction.
        ^ self
    ].
    codeView acceptAction:[:theCode |
        codeView withWaitCursorDo:[
            AbortOperationRequest catch:[
                Class nameSpaceQuerySignal answer:Smalltalk
                do:[
                    Compiler evaluate:theCode asString notifying:codeView compile:false.
                ].

                codeView modified:false.
                codeModified := false.
                self normalLabel.
                self updateClassList.
            ].
        ].
    ].

    "Created: / 10.2.2000 / 14:11:59 / cg"
    "Modified: / 16.11.2001 / 17:37:48 / cg"
!

setAcceptActionForFullClass
    "tell the codeView what to do on accept"

    (self isReadOnlyEnvironment) ifTrue:[
        self clearAcceptAction.
        ^ self
    ].
    codeView acceptAction:[:theCode |
        codeView withWaitCursorDo:[
            AbortOperationRequest catch:[
                self compileCode:theCode asString.
                codeView modified:false.
                codeModified := false.
            ].
        ].
    ].

    "Created: / 24.2.2000 / 15:50:03 / cg"
    "Modified: / 16.11.2001 / 17:37:51 / cg"
!

setAcceptActionForJavaClass
    "tell the codeView what to do on accept and explain"

    self setAcceptActionForNewJavaClass 
!

setAcceptActionForNewClass
    "tell the codeView what to do on accept and explain"

    (self isReadOnlyEnvironment) ifTrue:[
        self clearAcceptAction.
        ^ self
    ].
    codeView acceptAction:[:theCode |
        codeView withWaitCursorDo:[
            AbortOperationRequest catch:[
                |cls|

                Error handle:[:ex |
                    codeView error:ex description
                             position:1 to:nil from:nil.
                ] do:[
                    Class nameSpaceQuerySignal answer:(environment ? Smalltalk)
                    do:[
                        cls := (environment compilerClass evaluate:theCode asString notifying:codeView compile:false).
                        cls isBehavior ifTrue:[
                            codeView modified:false.
                            self classCategoryUpdate.
                            self updateClassListWithScroll:false.
                            cls isNameSpace ifFalse:[
                                self switchToClassNamed:(cls name).
                            ]
                        ]
                    ]
                ]
            ].
        ].
    ].
    self clearExplainAction.

    "Modified: / 16.11.2001 / 17:37:54 / cg"
!

setAcceptActionForNewJavaClass
    "tell the codeView what to do on accept and explain"

    codeView acceptAction:[:theCode |
        codeView withWaitCursorDo:[
            AbortOperationRequest catch:[
                |cls|

                Error handle:[:ex |
                    ex creator == HaltInterrupt ifTrue:[
                        ex reject
                    ].
                    codeView error:ex description position:1 to:nil from:nil.
                ] do:[
                    | compiler |
                    compiler := (Smalltalk at:#JavaCompiler).
                    cls := compiler 
                                evaluateClassDefinition:theCode asString 
                                notifying:codeView.

                    cls isBehavior ifTrue:[
                        codeView modified:false.
                        self classCategoryUpdate.
                        self updateClassListWithScroll:false.
                        self switchToClassNamed:(cls name).
                        self classDefinition.
                    ]
                ]
            ].
        ].
    ].
    self clearExplainAction.

    "Modified: / 16-11-2001 / 17:37:58 / cg"
    "Modified: / 27-02-2013 / 12:18:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setAcceptAndExplainActionsForMethod
    "tell the codeView what to do on accept and explain"

    (self isReadOnlyEnvironment) ifTrue:[
        self clearAcceptAction.
        ^ self
    ].
    codeView acceptAction:[:theCode |
        |cat cls rslt|

        fullProtocol ifTrue:[
            cls := acceptClass 
        ].
        cls isNil ifTrue:[
            cls := actualClass.
            cls isNil ifTrue:[
                self warn:'oops class is gone; reselect and try again'.
                ^ self
            ].
        ].

        codeView withWaitCursorDo:[

            (cat := currentMethodCategory) = '* all *' ifTrue:[
                "must check from which category this code came from ...
                 ... thanks to Arno for pointing this out"

                cat := self askForMethodCategory.
            ].
            (cat notEmptyOrNil) ifTrue:[
                AbortOperationRequest catch:[
                    lockUpdates := true.

                    (Class methodRedefinitionNotification) handle:[:ex |
                        |answer|

                        answer := SystemBrowser askForPackageChangeFrom:ex oldPackage 
                                                                     to:ex newPackage.
                        (answer ~~ #cancel) ifTrue:[
                            ex proceedWith:answer
                        ]
                    ] do:[

                        rslt := actualClass compilerClass 
                            compile:theCode asString withoutSeparators
                            forClass:cls
                            inCategory:cat 
                            notifying:codeView.

                        codeView modified:false.
                        codeModified := false.
                        currentMethod := actualClass compiledMethodAt:currentSelector.
                        methodCategoryListView notNil ifTrue:[    
                            ((methodCategoryListView list ? #()) includes:cat) ifFalse:[
                                self updateMethodCategoryListWithScroll:false.
                            ]
                        ].
                        self updateMethodListWithScroll:false keepSelection:(rslt == currentMethod).
                        self normalLabel.

                        rslt isMethod ifTrue:[
                            self checkAcceptedMethod:rslt inClass:actualClass.
                        ]
                    ]
                ].
                lockUpdates := false.
            ].
        ].
    ].

    codeView explainAction:[:theCode :theSelection |
        self showExplanation:(Explainer 
                                explain:theSelection 
                                in:theCode
                                forClass:actualClass)
    ].
    RBFormatter notNil ifTrue:[
        "/ use the refactoryBrowser for formatting, if present
        codeView formatAction:[:theCode |
            self methodFormatMethod:theCode.
        ].
    ].

"/ future feature ...
"/    codeView pointerOverWordAction:[:word :line :col |
"/        word isAlphaNumeric ifTrue:[
"/            Transcript showCR:(Explainer 
"/                                explain:word 
"/                                in:codeView contents
"/                                forClass:actualClass)
"/        ]
"/    ].

    "Modified: / 16.11.2001 / 17:38:01 / cg"
!

setDoitActionForClass
    "tell the codeView what to do on doIt"

    "set self for doits. This allows accessing the current class
     as self, and access to the class variables by name.
    "
    codeView doItAction:[:theCode |
	|compiler ns|

	currentClass notNil ifTrue:[
	    ns := currentClass nameSpace
	] ifFalse:[
	    ns := nil
	].

	Class nameSpaceQuerySignal handle:[:ex |
	    ns isNil ifTrue:[
		ex reject
	    ].
	    ex proceedWith:ns
	] do:[
	    currentClass isNil ifTrue:[
		compiler := Compiler
	    ] ifFalse:[
		compiler := currentClass evaluatorClass
	    ].

	    compiler 
		evaluate:theCode 
		in:nil 
		receiver:currentClass 
		notifying:codeView 
		logged:false
		ifFail:nil 
	]
    ].

    "Modified: / 17.6.1998 / 11:35:44 / cg"
!

setSearchPattern:aString
    codeView setSearchPattern:aString
!

showExplanation:someText
    "show explanation from Parser"

    self information:someText
!

showMethodCategoryList
    classCategoryListView isNil ifTrue:[
	classListView notNil ifTrue:[
	    methodCategoryListView superView extent:0.33 @ 1.0.
	    methodListView superView origin:0.66 @ 0.0 extent:0.34 @ 1.0.
	].
	^ self.
    ].
    methodCategoryListView notNil ifTrue:[
	methodCategoryListView superView extent:0.25 @ 1.0.
    ].
    methodListView notNil ifTrue:[
	methodListView superView origin:0.75 @ 0.0 extent:0.25 @ 1.0.
    ].

    "Created: 30.7.1997 / 17:50:20 / cg"
    "Modified: 16.8.1997 / 03:28:23 / cg"
!

stringToSearchFor
    "look in codeView and methodListView for a search-string when searching for classes/names"

    |sel|

    sel := codeView selection.
    sel notNil ifTrue:[
	sel := sel asString withoutSpaces
    ] ifFalse:[
	sel isNil ifTrue:[
	    currentClass notNil ifTrue:[
		sel := currentClass name
	    ]
	].
	sel notNil ifTrue:[
	    sel := sel withoutSpaces
	] ifFalse:[
	    sel := ''
	]
    ].
    ^ sel

    "Created: / 17.6.1998 / 12:42:31 / cg"
!

warnLabel:what
    "set the title for some warning"

    self topView label:('System Browser WARNING: ' , what)

    "Modified: 18.8.1997 / 15:19:56 / cg"
!

warnObsoleteCode:whatHappened
    "invoked, when someone else has changed what I am showing
     currently. Change my window label and show the text in red."

    self warnLabel:whatHappened.
    codeView contents:(codeView contentsAsString asText 
                        emphasizeAllWith:(UserPreferences current emphasisForObsoleteCode))

    "Modified: / 17.6.1998 / 12:40:46 / cg"
    "Created: / 17.6.1998 / 12:42:12 / cg"
!

withSearchCursorDo:aBlock
    ^ self topView withCursor:(Cursor questionMark) do:aBlock

    "Created: 23.11.1995 / 14:11:14 / cg"
    "Modified: 18.8.1997 / 15:40:19 / cg"
!

withWaitCursorDo:aBlock
    |topView|

    topView := self topView.
    topView == self ifTrue:[
        ^ super withWaitCursorDo:aBlock
    ].
    ^ topView withWaitCursorDo:aBlock

    "Created: 18.8.1997 / 15:41:52 / cg"
! !

!BrowserView methodsFor:'private-defaults'!

breakPointedIcon
    "answer an icon to mark breakPointed methods"

    ^ self fetchIcon:#breakPointed selector:#breakPointedIcon
!

canvasIcon
    "answer an icon to mark canvas (windowSpec) methods"

    ^ self fetchIcon:#canvas selector:#canvasIcon
!

fetchIcon:name selector:fetchSelector
    "answer an icon"

    icons isNil ifTrue:[icons := IdentityDictionary new].
    "/ Icons isNil ifTrue:[Icons := IdentityDictionary new].

    ^ icons at:name ifAbsentPut:[
        |fh icn h|

        true "(icn := Icons at:name ifAbsent:nil) isNil" ifTrue: [
            icn := (SystemBrowser perform:fetchSelector) onDevice:Screen current.
            "/ Icons at:name put:icn.
        ].
        h := icn height.
        h > (fh := SelectionInListView defaultFont heightOn:device) ifTrue:[
            icn := icn magnifiedBy:(fh / h)
        ].
        icn onDevice:device
      ]

    "
     Icons := nil
    "
!

fileImageIcon
    "answer an icon to mark fileImage methods"

    ^ self fetchIcon:#fileImage selector:#fileImageIcon

    "Modified: / 7.4.1997 / 17:31:40 / cg"
    "Created: / 29.10.1997 / 03:32:05 / cg"
!

globalClassIdentifierEmphasisAndColor
    |prefs|

    prefs := UserPreferences current.
    ^ Text 
        addEmphasis:(prefs globalClassIdentifierEmphasis) to:(#color->prefs globalClassIdentifierColor).

!

helpIcon
    "answer an icon to mark help spec methods"

    ^ self fetchIcon:#help selector:#helpIcon
!

hierarchicalListIcon
    "answer an icon to mark hierarchicalList spec methods"

    ^ self fetchIcon:#hierarchicalList selector:#hierarchicalListIcon
!

imageIcon
    "answer an icon to mark image spec methods"

    ^ self fetchIcon:#image selector:#imageIcon
!

menuIcon
    "answer an icon to mark menu spec methods"

    ^ self fetchIcon:#menu selector:#menuIcon
!

programImageIcon
    "answer an icon to mark program-image spec methods"

    ^ self fetchIcon:#programImage selector:#programImageIcon
!

programMenuIcon
    "answer an icon to mark menu spec methods"

    ^ self fetchIcon:#programMenu selector:#programMenuIcon
!

stopIcon
    "answer an icon to mark breakPointed methods"

    ^ self fetchIcon:#stop selector:#stopIcon
!

tabListIcon
    "answer an icon to mark tabList spec methods"

    ^ self fetchIcon:#tabList selector:#tabListIcon
!

tableColumnsIcon
    "answer an icon to mark tableColumns spec methods"

    ^ self fetchIcon:#tableColumns selector:#tableColumnsIcon
!

timeIcon
    "answer an icon to mark timed methods"

    ^ self fetchIcon:#time selector:#timeIcon
!

traceIcon
    "answer an icon to mark traced methods"

    ^ self fetchIcon:#trace selector:#traceIcon
! !

!BrowserView methodsFor:'private-queries'!

hasClassCategorySelected
        ^ currentClassCategory notNil
!

hasClassCategorySelectedAndIsNotSimulatedEnvironment
        ^ currentClassCategory notNil and:[self isNotSimulatedEnvironment]
!

hasClassCategorySelectedHolder
        ^ [ self hasClassCategorySelected ]
!

hasClassSelected
        ^ currentClass notNil
!

hasClassSelectedAndIsNotSimulatedEnvironment
        ^ self hasClassSelected and:[self isNotSimulatedEnvironment]
!

hasClassSelectedHolder
        ^ [ self hasClassSelected ]
!

hasLoadedClassSelected
        ^ currentClass notNil and:[currentClass isLoaded]
!

hasLoadedClassSelectedAndIsNotSimulatedEnvironment
        ^ self hasLoadedClassSelected and:[self isNotSimulatedEnvironment]
!

hasMethodCategorySelected
        ^ currentMethodCategory notNil
!

hasMethodCategorySelectedAndIsNotSimulatedEnvironment
        ^ self hasMethodCategorySelected and:[self isNotSimulatedEnvironment]
!

hasMethodSelected
        ^ currentMethod notNil
!

hasMethodSelectedAndIsNotReadOnlyEnvironment
        ^ self hasMethodSelected and:[self isReadOnlyEnvironment]
!

hasMethodSelectedAndIsNotSimulatedEnvironment
        ^ self hasMethodSelected and:[self isNotSimulatedEnvironment]
!

hasSourceCodeManager
        ^ Smalltalk sourceCodeManager notNil
!

hasUnwrappedMethodSelected
        ^ currentMethod notNil and:[currentMethod isWrapped not]
!

hasWrappedMethodSelected
        ^ currentMethod notNil and:[currentMethod isWrapped]
!

isNotSimulatedEnvironment
        ^ self isSimulatedEnvironment not
!

isReadOnlyEnvironment
    (self environment respondsTo:#isReadOnlyEnvironment) ifTrue:[
        ^ self environment isReadOnlyEnvironment
    ].
    ^ self environment ~~ Smalltalk
!

isSimulatedEnvironment
        ^ self environment ~~ Smalltalk
!

selectedMethodIsBreakpointed
    ^ currentMethod notNil and:[currentMethod isBreakpointed]
!

selectedMethodIsNotWrapped
    ^ currentMethod notNil and:[currentMethod isWrapped not]
!

selectedMethodIsTraced
    ^ currentMethod notNil and:[currentMethod isTraced]
!

showingClass
        ^ showInstance not
!

showingClassAndHasMethodCategorySelectedAndIsApplicationSubclass
        ^ self showingClass and:[self hasMethodCategorySelected]
!

showingClassAndIsApplicationSubclass
        ^ showInstance not 
        and:[ currentClass notNil
        and:[ currentClass isSubclassOf:ApplicationModel ]]
!

showingClassAndIsDialogSubclass
        ^ showInstance not 
        and:[ currentClass notNil
        and:[ currentClass isSubclassOf:Dialog ]]
!

showingInstance
        ^ showInstance
!

showingInstanceAndHasVariableSelected
        ^ showInstance  
        and:[ variableListView notNil
        and:[ variableListView selectionValue notNil ]]
! !

!BrowserView methodsFor:'syntax coloring'!

startSyntaxHighlightProcess
    "start a background process, which does the syntax coloring.
     When it finishes, it pushes a user event to install the new
     text. 
     (This is done as a event to synchronize the coloring with modifications
      done to the text - the colored text will discarded, if there were
      any modifications in the meanwhile)"

    |oldCodeList highlighter prio|

    coloringProcess notNil ifTrue:[
        coloringProcess terminate.
        coloringProcess := nil.
    ].

    currentMethod isNil ifTrue:[^ self].
    UserPreferences current syntaxColoring == true ifFalse:[^ self].

    highlighter := currentMethod syntaxHighlighterClass.
    highlighter == #askClass ifTrue:[
        highlighter := actualClass syntaxHighlighterClass.
    ].
    highlighter isNil ifTrue:[^ self].

    prio := Processor userBackgroundPriority - 1.
    self topView shown ifFalse:[
        prio := (prio - 1 max:1).
    ].

    coloringProcess := [
        |oldCode newCode cls|

        [
            codeView modified ifFalse:[
                oldCodeList := codeView list copy.
                codeView modified ifFalse:[
                    oldCodeList isNil ifFalse:[
                        oldCode := oldCodeList asStringWithoutEmphasis.
                        codeView modified ifFalse:[
                            "/ oldCode := oldCodeList asStringWithoutEmphasis.
                            cls := actualClass.

                            codeView modified ifFalse:[
                                Screen currentScreenQuerySignal answer:device
                                do:[
                                    newCode := highlighter formatMethodSource:oldCode in:cls.
                                ].

                                "/ must add this event - and not been interrupted
                                "/ by any arriving key-event.
                                codeView modified ifFalse:[
                                    newCode := newCode asStringCollection.
                                    codeView modified ifFalse:[
                                        coloringProcess := nil.
                                        self sensor
                                            pushUserEvent:#syntaxHighlightedCode: for:self
                                            withArguments:(Array with:newCode).
                                    ]
                                ]
                            ].
                        ].
                    ].
                ].
            ].
        ] ensure:[
            coloringProcess := nil.
        ].
    ] forkAt:prio.

    codeView modified:false.
    codeView modifiedChannel onChangeSend:#codeChanged to:self.

    "Created: / 31.3.1998 / 14:25:29 / cg"
    "Modified: / 9.7.1998 / 00:25:51 / cg"
!

stopSyntaxHighlightProcess
    "stop any background process, which does the syntax coloring."

    |p|

    (p := coloringProcess) notNil ifTrue:[
        coloringProcess := nil.
        p terminate.
    ].

    "Modified: / 17.6.1998 / 16:45:18 / cg"
!

syntaxHighlightedCode:newCode
    "the background highlighter has generated new colored text,
     with highlighted syntax.
     If there have been no modifications in the meantime, install it."

    |firstShown lastShown cursorWasOn anyChange newLines l
     replaceAction|

    codeView modified ifTrue:[
        "/ new input arrived in the meantime
        ^ self
    ].
"/    codeView hasSelection ifTrue:[
"/        "/ something selected - don't overwrite (is this agood idea ?)
"/        ^ self
"/    ].

    coloringProcess notNil ifTrue:[
        "/ another coloring process has already been started.
        "/ ignore this (leftover) code.
        ^ self
    ].
    currentMethod isNil ifTrue:[
        "/ have already switched to some other method,
        "/ or closed.
        ^ self
    ].

    firstShown := codeView firstLineShown.
    lastShown := codeView lastLineShown.
"/    sensor := self sensor.

    replaceAction := [:lNr :line |
        |oldLine|

        oldLine := codeView listAt:lNr.
        oldLine notNil ifTrue:[
            line notNil ifTrue:[
                "/ this check is needed - there is a race 
                "/ when the text is converted. This detects the 
                "/ resulting error.
                "/ Certainly a kludge. 

                oldLine string = line string ifTrue:[
                    oldLine emphasis ~= line emphasis ifTrue:[
                        codeView list at:lNr put:line.

                        codeView withoutRedrawAt:lNr put:line.
                        (lNr between:firstShown and:lastShown) ifTrue:[
                            anyChange ifFalse:[
                                anyChange := true.
                                cursorWasOn := codeView hideCursor
                            ].
                            codeView redrawLine:lNr.
                        ]
                    ]
"/                ] ifFalse:[
"/                    oldLine string printCR.
"/                    line string printCR.
                ]
            ]
        ].

        "/ stop when keyboard input arrives ...
"/ cg: commented - that's done when text is modified ...
"/        (sensor hasUserEvents) ifTrue:[
"/            (sensor hasKeyPressEventFor:nil) ifTrue:[
"/                (anyChange and:[cursorWasOn]) ifTrue:[codeView showCursor].
"/                ^ self.
"/            ]
"/        ]
    ].

    anyChange := false.

    newLines := newCode asStringCollection.

    "/ the cursor line first - thats where your eyes are ...
    (l := codeView cursorLine) notNil ifTrue:[
        l <= newLines size ifTrue:[
            replaceAction value:l value:(newLines at:l)
        ]
    ].

    newLines keysAndValuesDo:replaceAction.

    anyChange ifTrue:[
        "/ codeView textChanged.
        cursorWasOn ifTrue:[
            codeView showCursor
        ]
    ].

    "Modified: / 20.11.2001 / 00:38:09 / cg"
! !

!BrowserView methodsFor:'unused'!

listOfAllMethodCategoriesInHierarchy:aClass
    "answer a list of all method categories of the argument, aClass,
     and all of its superclasses"

    |newList|

    newList := Set new.
    self classesInHierarchy:aClass do:[:c |
        newList addAll:(c categories).
    ].
    ^ self asBrowserList:newList  
!

listOfAllSelectorsInCategory:aCategory inHierarchyOfClass:aClass
    "answer a list of all selectors in a given method category 
     of the argument, aClass and its superclasses"

    |newList|

    newList := Set new.
    self classesInHierarchy:aClass do:[:c |
	|searchCategory|

	(aCategory = '* all *') ifTrue:[
	    newList addAll:(c methodDictionary keys)
	] ifFalse:[
	    (aCategory = '* no category *') ifTrue:[
		searchCategory := nil
	    ] ifFalse:[
		searchCategory := aCategory
	    ].
	    c methodDictionary keysAndValuesDo:[:selector :aMethod |
		(aMethod category = searchCategory) ifTrue:[
		    newList add:selector
		]
	    ]
	].
    ].
    (newList size == 0) ifTrue:[^ nil].
    ^ newList asOrderedCollection sort

    "Modified: 5.6.1996 / 11:42:12 / stefan"
! !

!BrowserView methodsFor:'variable list menu'!

allClassInstVarMods
    "show an enterbox for classVar to search for"

    self allVarRefsTitle:'class instance variable to browse all modifications of:' 
		  access:#classInstVarNames
		    mods:true

    "Modified: / 25.10.1997 / 20:19:49 / cg"
    "Created: / 25.10.1997 / 20:21:48 / cg"
!

allClassInstVarRefs
    "show an enterbox for classVar to search for"

    self allVarRefsTitle:'class instance variable to browse all references to:' 
		  access:#classInstVarNames
		    mods:false

    "Modified: / 25.10.1997 / 20:20:09 / cg"
    "Created: / 25.10.1997 / 20:22:14 / cg"
!

allClassVarMods
    "show an enterbox for classVar to search for"

    self allVarRefsTitle:'class variable to browse all modifications of:' 
		  access:#classVarNames
		    mods:true

    "Modified: / 25.10.1997 / 20:22:24 / cg"
!

allClassVarRefs
    "show an enterbox for classVar to search for"

    self allVarRefsTitle:'class variable to browse all references to:' 
		  access:#classVarNames
		    mods:false

    "Modified: / 25.10.1997 / 20:22:30 / cg"
!

allInstVarMods
    "show an enterbox for instVar to search for"

    self allVarRefsTitle:'instance variable to browse all modifications of:' 
		  access:#instVarNames
		    mods:true

    "Modified: / 25.10.1997 / 20:22:35 / cg"
!

allInstVarRefs
    "show an enterbox for instVar to search for"

    self allVarRefsTitle:'instance variable to browse all references to:' 
		  access:#instVarNames
		    mods:false

    "Modified: / 25.10.1997 / 20:22:40 / cg"
!

allVarRefsTitle:title access:access mods:modifications
    "show an enterbox for instVar to search for"

    self doClassMenu:[:currentClass |
        |box|

        box := self enterBoxForVariableSearch:title.
        box action:[:aVariableName |
            |homeClass|

            aVariableName notEmpty ifTrue:[
                self withSearchCursorDo:[
                    homeClass := self findClassOfVariable:aVariableName accessWith:access.
                    access == #classVarNames ifTrue:[
                        SystemBrowser 
                            browseClassRefsTo:aVariableName 
                            under:homeClass 
                            modificationsOnly:modifications
                    ] ifFalse:[
                        access == #classInstVarNames ifTrue:[
                            SystemBrowser 
                                browseInstRefsTo:aVariableName 
                                under:homeClass class
                                modificationsOnly:modifications
                        ] ifFalse:[
                            SystemBrowser 
                                browseInstRefsTo:aVariableName 
                                under:homeClass 
                                modificationsOnly:modifications
                        ]
                     ]
                ]
            ]
        ].
        box open
    ]

    "Created: / 25.10.1997 / 20:19:26 / cg"
!

classInstVarMods
    "show an enterbox for classVar to search for"

    self varRefsOrModsTitle:'class instance variable to browse modifications of:'
		     access:#classInstVarNames
		       mods:true

    "Modified: / 25.10.1997 / 20:17:41 / cg"
    "Created: / 25.10.1997 / 20:21:04 / cg"
!

classInstVarRefs
    "show an enterbox for classVar to search for"

    self varRefsOrModsTitle:'class instance variable to browse references to:'
		     access:#classInstVarNames
		       mods:false

    "Modified: / 25.10.1997 / 20:17:23 / cg"
    "Created: / 25.10.1997 / 20:21:19 / cg"
!

classVarMods
    "show an enterbox for classVar to search for"

    self varRefsOrModsTitle:'class variable to browse modifications of:'
		     access:#classVarNames
		       mods:true

    "Modified: / 25.10.1997 / 20:17:41 / cg"
!

classVarRefs
    "show an enterbox for classVar to search for"

    self varRefsOrModsTitle:'class variable to browse references to:'
		     access:#classVarNames
		       mods:false

    "Modified: / 25.10.1997 / 20:17:23 / cg"
!

enterBoxForVariableSearch:title
    |box sel|

    box := self enterBoxForCodeSelectionTitle:title okText:'Browse'.
    variableListView notNil ifTrue:[
        codeView hasSelection ifFalse:[
            (sel := variableListView selectionValue) notNil ifTrue:[
                (sel startsWith:'-') ifFalse:[
                    box initialText:sel
                ]
            ]
        ]
    ].
    ^ box
!

instVarMods
    "show an enterbox for instVar to search for"

    self varRefsOrModsTitle:'instance variable to browse modifications of:'
		     access:#instVarNames
		       mods:true

    "Modified: / 25.10.1997 / 20:14:52 / cg"
!

instVarRefs
    "show an enterbox for instVar to search for"

    self varRefsOrModsTitle:'instance variable to browse references to:'
		     access:#instVarNames
		       mods:false

    "Modified: / 25.10.1997 / 20:14:27 / cg"
!

showClassInstVars
    classInstVarsInVarList := true.
    self updateVariableList.

    "Created: / 25.10.1997 / 19:43:04 / cg"
    "Modified: / 25.10.1997 / 19:43:41 / cg"
!

showClassVars
    classInstVarsInVarList := false.
    self updateVariableList.

    "Created: / 25.10.1997 / 19:42:55 / cg"
    "Modified: / 25.10.1997 / 19:43:35 / cg"
!

varInspect
    "open an inspector on the value of a classVar / classInstVar"

    |name searchClass dict|

    name := variableListView selectionValue.
    name isNil ifTrue:[^ self].

    showInstance ifTrue:[
	"/ inspect an instVar
	"/ create a dictionary of all instances with their current value there
	dict := IdentityDictionary new.
	currentClass allInstancesDo:[:i |
	    dict at:i put:(i instVarNamed:name).
	].
	(dict size == 0) ifTrue:[
	    self warn:'there are currently no instances of ' , currentClass name.
	    ^ self
	].
	dict inspect
    ] ifFalse:[
	(classInstVarsInVarList) ifFalse:[
	    "/ inspect a classVar
	    searchClass := currentClass whichClassDefinesClassVar:name.
	    (searchClass classVarAt:(name asSymbol)) inspect
	] ifTrue:[        
	    "/ inspect a classInstVar
	    (currentClass instVarNamed:name) inspect.
	].
    ].

    "Modified: / 16.10.1998 / 00:37:58 / cg"
!

varRefsOrModsTitle:title access:accessor mods:mods
    "show an enterbox for instvar to search for"

    self doClassMenu:[:currentClass |
        |box|

        box := self enterBoxForVariableSearch:title.
        box action:[:aString |
            aString notEmpty ifTrue:[
                self withSearchCursorDo:[
                    |sel classes|

                    sel := #'browseInstRefsTo:in:modificationsOnly:'.
                    accessor == #classInstVarNames ifTrue:[
                        classes := Array with:currentClass theMetaclass.
                    ] ifFalse:[
                        classes := Array with:currentClass.
                        accessor == #classVarNames ifTrue:[
                            sel := #'browseClassRefsTo:in:modificationsOnly:'
                        ]
                    ].
                    SystemBrowser perform:sel with:aString with:classes with:mods 
                ]
            ]
        ].
        box open
    ]

    "Created: / 25.10.1997 / 20:12:52 / cg"
    "Modified: / 25.10.1997 / 21:10:34 / cg"
!

varTypeInfo
    "show typical usage of a variable"

    |name idx classes values value msg cut names instCount subInstCount box
     searchClass s canInspect|

    name := variableListView selectionValue.
    name isNil ifTrue:[^ self].
    name := name allBold.

    canInspect := false.

    (classInstVarsInVarList or:[showInstance]) ifFalse:[
        searchClass := currentClass whichClassDefinesClassVar:name.
        value := searchClass classVarAt:(name asSymbol).
        s := value displayString.
        s size > 60 ifTrue:[
            s := (s copyTo:60) , ' ...'
        ].
        msg := name , ' is (currently):\\' , s.
        s ~= value classNameWithArticle ifTrue:[
            msg := msg , '\\(' , value class name , ')'
        ].
        canInspect := true.
    ] ifTrue:[        
        searchClass := actualClass whichClassDefinesInstVar:name.

        idx := searchClass instVarIndexFor:name.
        idx isNil ifTrue:[^ self].

        classes := IdentitySet new.
        values := IdentitySet new.
        instCount := 0.
        subInstCount := 0.
        searchClass allSubInstancesDo:[:i |
            |val|

            val := i instVarAt:idx.
            val notNil ifTrue:[values add:val].
            classes add:val class.
            (i isMemberOf:searchClass) ifTrue:[
                instCount := instCount + 1.
            ] ifFalse:[
                subInstCount := subInstCount + 1
            ]
        ].
        (instCount == 0 and:[subInstCount == 0]) ifTrue:[
            self warn:'there are currently no instances of ' , currentClass name.
            ^ self
        ].

        instCount ~~ 0 ifTrue:[
            msg := 'in (currently: ' , instCount printString,') instances '.
            subInstCount ~~ 0 ifTrue:[
                msg := msg , 'and '
            ]
        ] ifFalse:[
            msg := 'in '.
        ].
        subInstCount ~~ 0 ifTrue:[
            msg := msg , '(currently: ' , subInstCount printString, ') derived instances '
        ].
        msg := msg, 'of ' , searchClass name , ',\'.
        msg := msg , name , ' '.
        ((values size == 1) 
        or:[classes size == 1 and:[classes first == UndefinedObject]]) ifTrue:[
            values size == 1 ifTrue:[
                value := values first.
            ].
            (value isNumber or:[value isString]) ifTrue:[
                msg := msg , 'is always the same:\\      ' , 
                             value class name , ' (' , value storeString , ')'.
                canInspect := true.
            ] ifFalse:[
                (value isNil or:[value == true or:[value == false]]) ifTrue:[
                    msg := msg , 'is always:\\      ' , 
                                 value printString.
                ] ifFalse:[
                    msg := msg , 'is always the same:\\'.
                    msg := msg , '      ' , value class name.
                    value isLiteral ifTrue:[
                        msg := msg , ' (' , value storeString , ')'
                    ].
                    canInspect := true.
                ]
            ]
        ] ifFalse:[
            classes size == 1 ifTrue:[
                msg := msg , 'is always:\\'.
                msg := msg , '      ' , classes first name , '\'.
            ] ifFalse:[
                msg := msg , 'is one of:\\'.
                classes := classes asOrderedCollection.
                classes size > 20 ifTrue:[
                    classes := classes copyFrom:1 to:20.
                    cut := true
                ] ifFalse:[
                    cut := false.
                ].
                names := classes collect:[:cls |
                    cls == UndefinedObject ifTrue:[
                        'nil'
                    ] ifFalse:[
                        cls == True ifTrue:[
                            'true'
                        ] ifFalse:[
                            cls == False ifTrue:[
                                'false'
                            ] ifFalse:[
                                cls name
                            ]
                        ]
                    ].
                ].
                names := names copy sort.
                names do:[:nm |
                    msg := msg , '      ' , nm , '\'.
                ].
            ]
        ].
    ].

    canInspect ifTrue:[
       (OptionBox 
              request:msg withCRs
              label:'Variable Type Information'
              image:(InfoBox iconBitmap)
              buttonLabels:#('OK' 'Inspect')
              values:#(true #inspect)) == #inspect
        ifTrue:[
            value inspect
        ]
    ] ifFalse:[
        box := InfoBox title:msg withCRs.
        box label:'Variable Type Information'.
        box open
    ].

    "Modified: / 3.1.1998 / 14:50:00 / cg"
!

variableListMenu
    <resource: #programMenu >

    |items m|

    currentClass isNil ifTrue:[
        variableListView flash.
        ^ nil
    ].

    showInstance ifFalse:[
        items := #(
                    ('Class Instvar Refs...'      classInstVarRefs    )
                    ('Class Instvar Mods...'      classInstVarMods    )
                    ('Classvar Refs...'           classVarRefs        )
                    ('Classvar Mods...'           classVarMods        )
                    ('-'                           nil                 )
                    ('All Class Instvar Refs...'  allClassInstVarRefs )
                    ('All Class Instvar Mods...'  allClassInstVarMods )
                    ('All Classvar Refs...'       allClassVarRefs     )
                    ('All Classvar Mods...'       allClassVarMods     )
                   ).
    ] ifTrue:[
        items := #(
                    ('Instvar Refs...'            instVarRefs         )
                    ('Instvar Mods...'            instVarMods         )
                    ('Classvar Refs...'           classVarRefs        )
                    ('Classvar Mods...'           classVarMods        )
                    ('-'                           nil                 )
                    ('All Instvar Refs...'        allInstVarRefs      )
                    ('All Classvar Refs...'       allClassVarRefs     )
                    ('All Instvar Mods...'        allInstVarMods      )
                    ('All Classvar Mods...'       allClassVarMods     )
                   ).
    ].

    showInstance ifFalse:[
        classInstVarsInVarList == true ifTrue:[
            items := items , #(('-') ('Show ClassVars' showClassVars)).
        ] ifFalse:[
            items := items , #(('-') ('Show Class InstVars' showClassInstVars)).
        ].
    ].

    ("showInstance and:[" variableListView hasSelection "]" ) ifTrue:[
        items := items , #(
                                ('-'                           )
                                ('Type Information...' varTypeInfo)
                           ).
    ].

    ("showInstance not and:["variableListView hasSelection"]") ifTrue:[
        items := items , #(
                                ('Inspect' varInspect)
                           ).
    ].

    m := PopUpMenu itemList:items resources:resources.

    currentClass instSize == 0 ifTrue:[
        m disableAll:#(instVarRefs instVarMods).
        currentClass subclasses size == 0 ifTrue:[
            m disableAll:#(allInstVarRefs allInstVarMods).
        ]
    ].

    currentClass isLoaded ifFalse:[
        m disableAll
    ].
    ^ m

    "Modified: / 1.2.2002 / 13:02:36 / cg"
!

variableSelection:lineNr
    "variable selection changed"

    |name idx|

    name := variableListView selectionValue.
    name isNil ifTrue:[
	self unhilightMethodCategories.
	self unhilightMethods.
	self autoSearch:nil.
	^ self
    ].

    "
     first, check if the selected variable is really the one 
     we get - reselect if its hidden (for example, a class variable
     with the same name could be defined in a subclass)
    "
    idx := variableListView list findLast:[:entry | entry = name].
    idx ~~ lineNr ifTrue:[
	"select it - user will see whats going on"
	variableListView setSelection:idx
    ].

    "search for methods in the current category, which access the selected
     variable, and highlight them"

    self hilightMethodsInMethodCategoryList:true inMethodList:true.
    self autoSearch:name.

    "Modified: 25.5.1996 / 12:26:07 / cg"
! !

!BrowserView methodsFor:'variable stuff'!

hilightEntryFor:entry
    "helper; given a list item, highlight it"

    |e|

    methodCategoryListView font bold ifTrue:[
        "/ already bold; use different color then
        methodCategoryListView foregroundColor brightness > 0.5 ifTrue:[
            methodCategoryListView backgroundColor brightness < 0.25 ifTrue:[
                e := #color->Color blue
            ] ifFalse:[
                e := #color->self blackColor
            ]
        ] ifFalse:[
            methodCategoryListView backgroundColor brightness > 0.75 ifTrue:[
                e := #color->Color red darkened
            ] ifFalse:[
                e := #color->self whiteColor.
            ]
        ]
    ] ifFalse:[
        e := #bold.
    ].

    entry isString ifTrue:[
        ^ entry asText emphasizeAllWith:e.
    ].
    ^ entry copy string:(entry string asText emphasizeAllWith:e)

    "Created: 22.10.1996 / 23:36:59 / cg"
    "Modified: 22.10.1996 / 23:50:03 / cg"
!

hilightMethodsInMethodCategoryList
    "search for methods  which access the selected
     variable, and highlight them"

    self hilightMethodsInMethodCategoryList:true inMethodList:false



!

hilightMethodsInMethodCategoryList:inCat inMethodList:inMethods 
    "search for methods  which access the selected
     variable, and highlight them"

    |name redefinedSelectors methodList methodCategoryList entry|

    variableListView isNil ifTrue:[^ self].

    inCat ifTrue:[self unhilightMethodCategories].
    inMethods ifTrue:[self unhilightMethods].

    actualClass isNil ifTrue:[^ self].
    (methodCategoryListView isNil 
    and:[methodListView isNil]) ifTrue:[^ self].

    name := variableListView selectionValue.
    name isNil ifTrue:[^ self].

    self withSearchCursorDo:[
        |classes filter any supers|

        classes := Array with:actualClass.
        (currentClassHierarchy notNil and:[fullProtocol]) ifTrue:[
            supers := actualClass allSuperclasses.
            classes := classes , supers.
            redefinedSelectors := IdentitySet new.
        ].

        filter := SystemBrowser 
                        filterToSearchRefsTo:name 
                        classVars:(showInstance not and:[classInstVarsInVarList ~~ true]) 
                        modificationsOnly:false. 

        methodListView notNil ifTrue:[
            methodList := methodListView list.
            methodList notNil ifTrue:[
                methodList := methodList collect:[:s | self selectorFromClassMethodString:s].
            ]
        ].
        methodCategoryListView notNil ifTrue:[
            methodCategoryList := methodCategoryListView list.
        ].

        any := false.

        "
         highlight the method that ref this variable
        "
        classes do:[:someClass |
            (fullProtocol
            and:[classListView valueIsInSelection:(someClass name)]) ifFalse:[
                someClass methodDictionary keysAndValuesDo:[:selector :method |
                    (inCat
                    or:[methodList notNil
                        and:[methodList includes:selector]])
                    ifTrue:[
                        (redefinedSelectors isNil
                        or:[(redefinedSelectors includes:selector) not])
                       ifTrue:[
                           (filter value:someClass value:method value:selector) ifTrue:[
                               |idx cat|

                               (inCat
                               and:[methodCategoryList notNil]) ifTrue:[
                                   cat := method category.
                                   "
                                    highlight the methodCategory
                                   "
                                   idx := methodCategoryListView list indexOf:cat.
                                   idx ~~ 0 ifTrue:[
                                        entry := methodCategoryListView at:idx.
                                        entry := self hilightEntryFor:entry.
                                        methodCategoryListView at:idx put:entry
"/                                       methodCategoryListView attributeAt:idx put:#bold.
                                   ].
                               ].

                               (inMethods
                               and:[methodList notNil]) ifTrue:[
                                   "
                                    highlight the method
                                   "
                                   idx := methodListView list 
                                                findFirst:[:item | |s|
                                                                (s := item string) = selector
                                                                or:[s startsWith:(selector , ' ')]
                                                          ].
                                   idx ~~ 0 ifTrue:[
                                        entry := methodListView at:idx.
                                        entry := self hilightEntryFor:entry.
                                        methodListView at:idx put:entry
"/                                        methodListView attributeAt:idx put:#bold.
                                   ].
                                   any := true
                               ].
                           ].
                           redefinedSelectors notNil ifTrue:[
                               redefinedSelectors add:selector
                           ]
                        ]
                    ]
                ]
            ]
        ].
        any ifTrue:[
            self setSearchPattern:name
        ]
    ]

    "Created: / 23.11.1995 / 14:12:08 / cg"
    "Modified: / 5.6.1996 / 11:38:19 / stefan"
    "Modified: / 25.10.1997 / 21:02:47 / cg"
!

hilightMethodsInMethodList
    "search for methods  which access the selected
     variable, and highlight them"

    self hilightMethodsInMethodCategoryList:false inMethodList:true 



!

unhilightEntryFor:entry
    "helper; given a list itme, unhighlight it"

    entry isString ifTrue:[
	^ entry string
    ].
    ^ entry copy string:(entry string)

    "Created: 22.10.1996 / 23:38:21 / cg"
!

unhilightMethodCategories
    "unhighlight items in method list"

    |list entry sz "{ Class: SmallInteger }"|

    variableListView isNil ifTrue:[^ self].

    methodCategoryListView notNil ifTrue:[
	list := methodCategoryListView list.
	sz := list size.
	1 to:sz do:[:idx |
	    entry := list at:idx.
	    entry := self unhilightEntryFor:entry.
	    methodCategoryListView at:idx put:entry.
"/            methodCategoryListView attributeAt:idx put:nil.
	]
    ].

    "Modified: 22.10.1996 / 23:40:52 / cg"
!

unhilightMethods
    "unhighlight items in method list"

    |list entry sz "{Class: SmallInteger }" |

    variableListView isNil ifTrue:[^ self].

    methodListView notNil ifTrue:[
	list := methodListView list.
	sz := list size.
	1 to:sz do:[:idx |
	    entry := list at:idx.
	    entry := self unhilightEntryFor:entry.
	    methodListView at:idx put:entry.

"/            methodListView attributeAt:idx put:nil.
	].
    ].

    "Modified: 22.10.1996 / 23:39:18 / cg"
!

updateVariableList
    "update the variable list - either show instVars, classVars or classInstVars"

    |l subList last nameAccessSelector class oldSelection askMeta|

    variableListView isNil ifTrue:[^ self].

    oldSelection := variableListView selectionValue.

    l := OrderedCollection new.
    "
     show classVars/classInstVars, 
     if classProtocol is shown (instead of classInstance vars)
    "
    askMeta := false.
    showInstance ifTrue:[
        nameAccessSelector := #instVarNames
    ] ifFalse:[
        classInstVarsInVarList == true ifTrue:[
            nameAccessSelector := #instVarNames.
            askMeta := true.
        ] ifFalse:[
            nameAccessSelector := #classVarNames
        ]
    ].

    class := currentClassHierarchy notNil ifTrue:[
        currentClassHierarchy
    ] ifFalse:[
        currentClass
    ].
    class := currentClass.
    fullProtocol ifTrue:[
        class := currentClassHierarchy
    ].

    class isNil ifTrue:[
        variableListView list:nil.
        ^ self
    ].

    class withAllSuperclassesDo:[:aClass |
        |ignore clsName|

        ignore := fullProtocol 
                  and:[classListView valueIsInSelection:(aClass name asString)].
        ignore ifFalse:[
            askMeta ifTrue:[
                subList := aClass theMetaclass perform:nameAccessSelector.
            ] ifFalse:[
                subList := aClass perform:nameAccessSelector.
            ].
            subList size ~~ 0 ifTrue:[
                l := l , (subList asOrderedCollection reversed).
                aClass nameSpace == currentNamespace ifTrue:[
                    clsName := aClass nameWithoutNameSpacePrefix
                ] ifFalse:[
                    clsName := aClass name
                ].
                showInstance ifFalse:[
                    clsName := clsName , ' class'
                ].
                l := l , (OrderedCollection with:'--- ' , clsName , ' ---').
            ]
        ]
    ].
    l reverse.
    variableListView setAttributes:nil.
    l ~= variableListView list ifTrue:[
        variableListView list:l.
    ].

    l keysAndValuesDo:[:index :entry |
        (entry startsWith:'-') ifTrue:[
            variableListView attributeAt:index put:#disabled.
            last := index
        ]
    ].
    last notNil ifTrue:[variableListView scrollToLine:last].

    oldSelection notNil ifTrue:[
        variableListView setSelectElement:oldSelection.
        self hilightMethodsInMethodCategoryList:true inMethodList:true.
    ]

    "Modified: / 17.9.1998 / 13:45:02 / cg"
! !

!BrowserView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


BrowserView initialize!
