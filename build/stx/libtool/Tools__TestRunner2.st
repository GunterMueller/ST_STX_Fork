"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

AbstractTestRunner subclass:#TestRunner2
	instanceVariableNames:'classCategoryOrPackageTabIndexHolder classCategoryList
		packageList classList classListOutGeneratorHolder
		classListInGeneratorHolder modeHolder detailsHolder
		failureListHolder failureSelectionHolder errorListHolder
		errorSelectionHolder lastPass resultHolder lastBrowser
		selectedResultHolder selectedTestCaseHasCoveredClassesHolder'
	classVariableNames:'History'
	poolDictionaries:''
	category:'SUnit-UI'
!

ClassList subclass:#ClassList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TestRunner2
!

ApplicationModel subclass:#ResultList
	instanceVariableNames:'results resultsHolder selectiomHolder listHolder timestampFormat
		selectionHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:TestRunner2
!

HierarchicalItem subclass:#ListEntry
	instanceVariableNames:'label realLabel test result'
	classVariableNames:'PassedText FailedText ErrorText'
	poolDictionaries:''
	privateIn:TestRunner2::ResultList
!

!TestRunner2 class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!TestRunner2 class methodsFor:'initialization'!

initialize
    self initializeHistory.

    "/ mhmh - somehow, this does not work if done immediately
    "/ (probably Launcher is not yet initialized in some situations).
    "/ therefore, do it delayed.
    Smalltalk addStartBlock: [
        self installInLauncher
    ]

    "Created: / 09-06-2008 / 11:11:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-11-2008 / 09:38:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-03-2010 / 08:46:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeHistory

    History := List new.

    "Modified: / 26-11-2008 / 09:38:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 19-03-2010 / 08:46:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

installInLauncher
    |menuItem action|

    NewLauncher isNil ifTrue:[^ self].
    ToolbarIconLibrary isNil ifTrue:[^ self].

    "/ NewLauncher removeUserTool:#TestRunner2.

    "test runner class may be changed, and we want to start the changed class,
     not the one which installed the menu item"
    "/ action := (MessageSend receiver:(Smalltalk at:self name) selector:#open).
    action := [ UserPreferences current testRunnerClass "(Smalltalk at:self name)" open ].


    "Install in Tools menu"
    menuItem := MenuItem label:'SUnit Test Runner (enhanced)' itemValue:action.
    menuItem
        nameKey:#TestRunner2;
        labelImage:self startSUnitIcon;
        isButton:false.
    NewLauncher 
        addMenuItem:menuItem
        from:self
        in:'menu.tools.programming'
        position:#( after startSUnitTestRunner )
        space:false.

    "Install in Toolbar"
    menuItem := MenuItem label: 'SUnit Test Runner (enhanced)' itemValue:action.
    menuItem
        nameKey:#TestRunner2;
        activeHelpKey: #openTestRunner;
        icon:self startSUnitIcon;
        isButton:true.
    NewLauncher 
        addMenuItem:menuItem
        from:self
        in:'toolbar'
        position:#( before garbageCollect )
        space:false.

    "Created: / 09-06-2008 / 11:11:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-11-2008 / 09:38:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-01-2010 / 20:48:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-08-2011 / 11:34:24 / cg"
! !

!TestRunner2 class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::TestRunner2    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#runCoverage
'Run tests with coverage measurements enabled. (requires that the testcase class defines #coveredClasses)'

#runDebugged
'Run tests with debugger enabled'

)

    "Modified: / 09-08-2012 / 09:37:16 / cg"
! !

!TestRunner2 class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ToolbarIconLibrary sUnit24x24Icon

    "Created: / 19-08-2009 / 14:32:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!TestRunner2 class methodsFor:'interface specs'!

buttonPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TestRunner2 andSelector:#buttonPaneSpec
     Tools::TestRunner2 new openInterface:#buttonPaneSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: buttonPaneSpec
        window: 
       (WindowSpec
          label: 'Button Spec'
          name: 'Button Spec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 492 44)
        )
        component: 
       (SpecCollection
          collection: (
           (HorizontalPanelViewSpec
              name: 'ButtonPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: fit
              horizontalSpace: 0
              verticalSpace: 0
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Run Selected'
                    name: 'RunSelected'
                    translateLabel: true
                    tabable: true
                    model: runSelectedAction
                    enableChannel: hasTestCasesAspect
                    disabledLogo: 'Run Selected'
                    extent: (Point 82 44)
                  )
                 (ActionButtonSpec
                    label: 'Profiled'
                    name: 'RunProfiled'
                    visibilityChannel: false
                    translateLabel: true
                    tabable: true
                    model: runProfiledAction
                    initiallyDisabled: true
                    extent: (Point 82 44)
                  )
                 (ActionButtonSpec
                    label: 'Coverage'
                    name: 'RunCoverage'
                    activeHelpKey: runCoverage
                    translateLabel: true
                    tabable: true
                    model: runCoverageAction
                    initiallyDisabled: true
                    extent: (Point 82 44)
                  )
                 (ActionButtonSpec
                    label: 'Debug'
                    name: 'Button1'
                    activeHelpKey: runDebugged
                    translateLabel: true
                    tabable: true
                    model: runDebuggedAction
                    extent: (Point 82 44)
                  )
                 (ActionButtonSpec
                    label: 'Run Failures'
                    name: 'RunFailures'
                    translateLabel: true
                    tabable: true
                    model: runFailuresAction
                    initiallyDisabled: true
                    enableChannel: hasFailuresAspect
                    disabledLogo: 'Run Failures'
                    extent: (Point 82 44)
                  )
                 (ActionButtonSpec
                    label: 'Run Errors'
                    name: 'RunErrors'
                    translateLabel: true
                    tabable: true
                    model: runErrorsAction
                    initiallyDisabled: true
                    enableChannel: hasErrorsAspect
                    disabledLogo: 'Run Errors'
                    extent: (Point 82 44)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

classCategoryListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TestRunner2 andSelector:#classCategoryListSpec
     Tools::TestRunner2 new openInterface:#classCategoryListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: classCategoryListSpec
        window: 
       (WindowSpec
          label: 'Class Category List'
          name: 'Class Category List'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'ClassCategoryList'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              clientKey: classCategoryList
            )
           )
         
        )
      )

    "Modified: / 04-06-2008 / 23:57:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

classListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TestRunner2 andSelector:#classCategoryListSpec
     Tools::TestRunner2 new openInterface:#classCategoryListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: classCategoryListSpec
        window: 
       (WindowSpec
          label: 'Class Category List'
          name: 'Class Category List'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'ClassList'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              clientKey: classList
            )
           )
         
        )
      )

    "Created: / 05-06-2008 / 19:30:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

packageListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TestRunner2 andSelector:#packageListSpec
     Tools::TestRunner2 new openInterface:#packageListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: packageListSpec
        window: 
       (WindowSpec
          label: 'Package List'
          name: 'Package List'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'PackageList'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              clientKey: packageList
            )
           )
         
        )
      )

    "Modified: / 05-06-2008 / 00:14:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resultPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TestRunner2 andSelector:#resultPaneSpec
     TestRunner2 new openInterface:#resultPaneSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: resultPaneSpec
        window: 
       (WindowSpec
          label: 'Result spec'
          name: 'Result spec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'N/A'
              name: 'Mode'
              layout: (LayoutFrame 0 0 0 0 0 1 0 0.6)
              style: (FontDescription arial bold roman 14)
              labelChannel: modeHolder
            )
           (LabelSpec
              label: '...'
              name: 'Details'
              layout: (LayoutFrame 0 0 0 0.6 0 1 0 1)
              labelChannel: detailsHolder
            )
           )
         
        )
      )

    "Modified: / 18-01-2008 / 18:44:00 / janfrog"
!

testHistoryTabSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TestRunner2 andSelector:#testHistoryTabSpec
     Tools::TestRunner2 new openInterface:#testHistoryTabSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: testHistoryTabSpec
        window: 
       (WindowSpec
          label: 'Test History'
          name: 'Test History'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'ResultList'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              majorKey: #'Tools::TestRunner2::ResultList'
              subAspectHolders: 
             (Array
                
               (SubChannelInfoSpec
                  subAspect: resultsHolder
                  aspect: historyHolder
                )
              )
              createNewApplication: true
              createNewBuilder: true
            )
           )
         
        )
      )
!

testResultTabSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TestRunner2 andSelector:#testResultTabSpec
     Tools::TestRunner2 new openInterface:#testResultTabSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: testResultTabSpec
        window: 
       (WindowSpec
          label: 'Test Result'
          name: 'Test Result'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'ResultList'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              majorKey: #'Tools::TestRunner2::ResultList'
              subAspectHolders: 
             (Array
                
               (SubChannelInfoSpec
                  subAspect: resultsHolder
                  aspect: resultHolder
                ) 
               (SubChannelInfoSpec
                  subAspect: selectionHolder
                  aspect: selectedResultHolder
                )
              )
              createNewApplication: true
              createNewBuilder: true
            )
           )
         
        )
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TestRunner2 andSelector:#windowSpec
     Tools::TestRunner2 new openInterface:#windowSpec
     Tools::TestRunner2 open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Test Runner Tool'
         name: 'Test Runner Tool'
         min: (Point 0 0)
         bounds: (Rectangle 0 0 717 412)
         menu: mainMenu
         icon: defaultIcon
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'ResultPane'
             layout: (LayoutFrame 0 0 0 0 0 1 100 0)
             minorKey: resultPaneSpec
           )
          (VariableHorizontalPanelSpec
             name: 'ListPane'
             layout: (LayoutFrame 0 0 100 0 0 1 -30 1)
             showHandle: true
             snapMode: both
             handlePosition: right
             component: 
            (SpecCollection
               collection: (
                (NoteBookViewSpec
                   name: 'ClassOrPackageTab'
                   model: classCategoryOrPackageTabIndexHolder
                   menu: classCategoryOrPackageTabList
                   useIndex: true
                   fitLastRow: false
                   translateLabel: true
                 )
                (TransparentBoxSpec
                   name: 'ClassListBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (SubCanvasSpec
                         name: 'ClassList'
                         layout: (LayoutFrame 0 0 25 0 0 1 0 1)
                         hasHorizontalScrollBar: false
                         hasVerticalScrollBar: false
                         clientKey: classList
                         createNewBuilder: false
                       )
                      )
                    
                   )
                 )
                (NoteBookViewSpec
                   name: 'NoteBook2'
                   menu: resultAndHistoryTabList
                   translateLabel: true
                 )
                )
              
             )
             handles: (Any 0.33333333333332998 0.66666666666666996 1.0)
           )
          (UISubSpecification
             name: 'ButtonPane'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             minorKey: buttonPaneSpec
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
!

windowSpec_old
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TestRunner2 andSelector:#windowSpec
     Tools::TestRunner2 new openInterface:#windowSpec
     Tools::TestRunner2 open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Test Runner Tool'
          name: 'Test Runner Tool'
          min: (Point 0 0)
          bounds: (Rectangle 0 0 717 412)
          icon: defaultIcon
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'ResultPane'
              layout: (LayoutFrame 0 0 0 0 0 1 100 0)
              minorKey: resultPaneSpec
            )
           (VariableHorizontalPanelSpec
              name: 'ListPane'
              layout: (LayoutFrame 0 0 100 0 0 1 -30 1)
              showHandle: true
              snapMode: both
              component: 
             (SpecCollection
                collection: (
                 (NoteBookViewSpec
                    name: 'ClassOrPackageTab'
                    model: classCategoryOrPackageTabIndexHolder
                    menu: classCategoryOrPackageTabList
                    direction: left
                    useIndex: true
                    fitLastRow: false
                  )
                 (SubCanvasSpec
                    name: 'ClassList'
                    hasHorizontalScrollBar: false
                    hasVerticalScrollBar: false
                    clientKey: classList
                    createNewBuilder: false
                  )
                 (VariableVerticalPanelSpec
                    name: 'VariableVerticalPanel1'
                    component: 
                   (SpecCollection
                      collection: (
                       (SequenceViewSpec
                          name: 'FailuresList'
                          model: failureSelectionHolder
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          doubleClickSelector: debugFailure:
                          useIndex: false
                          sequenceList: failureListHolder
                        )
                       (SequenceViewSpec
                          name: 'ErrorsList'
                          model: errorSelectionHolder
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          doubleClickSelector: debugError:
                          useIndex: false
                          sequenceList: errorListHolder
                        )
                       )
                     
                    )
                    handles: (Any 0.5 1.0)
                  )
                 )
               
              )
              handles: (Any 0.33333333333333 0.66666666666667 1.0)
            )
           (UISubSpecification
              name: 'ButtonPane'
              layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
              minorKey: buttonPaneSpec
            )
           )
         
        )
      )

    "Created: / 07-02-2010 / 14:48:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunner2 class methodsFor:'list specs'!

classCategoryOrPackageTabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#classCategoryOrPackageTabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'Categories'
          minorKey: classCategoryListSpec
          createNewBuilder: false
        )
       (TabItem
          label: 'Packages'
          minorKey: packageListSpec
          createNewBuilder: false
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]

    "Modified: / 05-06-2008 / 00:15:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resultAndHistoryTabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#resultAndHistoryTabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'Result'
          minorKey: testResultTabSpec
          createNewBuilder: false
        )
       (TabItem
          label: 'History'
          minorKey: testHistoryTabSpec
          createNewBuilder: false
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]
! !

!TestRunner2 class methodsFor:'menu specs'!

classListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::TestRunner2 andSelector:#classListMenu
     (Menu new fromLiteralArrayEncoding:(Tools::TestRunner2 classListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Browse'
            itemValue: classListMenuBrowse
          )
         (MenuItem
            enabled: selectedTestCaseHasCoveredClassesHolder
            label: 'Browse Covered Classes'
            itemValue: classListMenuBrowseCoveredClasses
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
     MenuEditor new openOnClass:Tools::TestRunner2 andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::TestRunner2 mainMenu)) startUp
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

packageListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::TestRunner2 andSelector:#packageListMenu
     (Menu new fromLiteralArrayEncoding:(Tools::TestRunner2 packageListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Select Prerequisites'
            itemValue: packageListMenuSelectPrerequisites
            translateLabel: true
          )
         (MenuItem
            label: 'Select Prerequisites (recursive)'
            itemValue: packageListMenuSelectPrerequisitesAll
            translateLabel: true
          )
         (MenuItem
            label: 'Select Dependents'
            itemValue: packageListMenuSelectDependents
            translateLabel: true
          )
         (MenuItem
            label: 'Select Dependents (recursively)'
            itemValue: packageListMenuSelectDependentsAll
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Modified: / 06-06-2008 / 20:04:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-09-2011 / 18:51:37 / cg"
!

resultListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::TestRunner2 andSelector:#resultListMenu
     (Menu new fromLiteralArrayEncoding:(Tools::TestRunner2 resultListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Browse'
            itemValue: resultListMenuBrowse
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Copy List'
            itemValue: resultListMenuCopyList
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!TestRunner2 class methodsFor:'resources'!

startSUnitIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary sUnit24x24Icon    
    "/ ^ ToolbarIconLibrary sUnit28x28Icon    
! !

!TestRunner2 class methodsFor:'startup'!

openOnTestCase:aTestCaseClass
    |runner|

    runner := self new.
    runner allButOpen.
    runner packageList selectedProjects value:(Array with:aTestCaseClass package).
    runner classList selectClass:aTestCaseClass.
    runner openWindow.

    "Created: / 06-07-2011 / 14:10:00 / cg"
! !

!TestRunner2 methodsFor:'accessing'!

errorColor
    ^ self class 
        errorColor

    "Modified: / 08-02-2010 / 13:57:26 / Jan Vrany <jan,vrany@fit.cvut.cz>"
!

errorTestSuite

    | testSuite |
    testSuite := TestSuite new.
    errorListHolder value do:
        [:test|
        testSuite addTest: test].
    ^testSuite

    "Created: / 06-06-2008 / 09:08:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

failedColor
    ^ self class failedColor
!

failureTestSuite
    | testSuite |

    testSuite := TestSuite new.
    failureListHolder value do:[:test|
        testSuite addTest: test
    ].
    ^testSuite

    "Created: / 06-06-2008 / 09:03:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 23-09-2011 / 18:56:52 / cg"
!

passedColor
    ^ self class passedColor
!

selectedPackages: packages

    self packageList selectedProjects value: packages.
    "/self packageList updateTreeSelection.

    "Created: / 06-06-2008 / 20:02:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectedTestCases

    | testCases |
    testCases := self classList selectionHolder value.
    testCases isEmptyOrNil ifTrue:
        [testCases := self classList listOfClasses].
    testCases := testCases collect:[:cls|cls theNonMetaclass].
    ^testCases reject:[:cls | cls isAbstract]

    "Created: / 05-06-2008 / 22:02:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-11-2008 / 17:16:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-08-2011 / 19:05:53 / cg"
!

selectedTestSuite
    |testCases testSuite|

    testCases := self selectedTestCases.
    testSuite := TestSuite named:(self suiteNameFromClasses:testCases).
    testCases 
        do:[:testCaseCls | testSuite addTests:((self buildSuiteFromClass:testCaseCls) tests) ].
    ^ testSuite

    "Created: / 05-06-2008 / 22:13:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-06-2008 / 19:28:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-03-2010 / 08:06:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theSingleSelectedProject

    | selection |
    selection := self packageList selectionHolder value.
    ^selection size = 1 
        ifTrue:[selection anyOne]
        ifFalse:[nil]

    "Created: / 06-06-2008 / 20:08:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

theSingleSelectedProjectDefinition

    |package|

    package := self theSingleSelectedProject.
    package ifNil:[^nil].
    ^Smalltalk at:(ProjectDefinition projectDefinitionClassNameForDefinitionOf:package) asSymbol

    "Created: / 06-06-2008 / 20:08:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!TestRunner2 methodsFor:'accessing - menus'!

packageListMenu
    ^ self class packageListMenu

    "Created: / 06-06-2008 / 19:16:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-09-2011 / 18:55:05 / cg"
!

resultListMenu
    ^ self class resultListMenu

    "Created: / 06-06-2008 / 19:16:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 23-09-2011 / 18:53:46 / cg"
! !

!TestRunner2 methodsFor:'accessing-lists'!

allTestCategories

    | categories |
    categories := Set new.
    Smalltalk allClassesDo:
        [:cls|
        (self isTestCaseLike: cls) ifTrue:
            [categories add: cls category]].
    ^categories

    "Modified: / 28-02-2011 / 21:25:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allTestPackages
    | packages |

    packages := Set new.
    Smalltalk allClassesDo: [:cls|
        (self isTestCaseLike: cls) ifTrue:[
            packages add: cls package
        ]
    ].
    ^packages

    "Modified: / 28-02-2011 / 21:25:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classCategoryList
    classCategoryList ifNil:
            [ classCategoryList := Tools::ClassCategoryList new.
            classCategoryList inGeneratorHolder:self allTestCategories asSet asValue.
            classCategoryList outGeneratorHolder:self classListOutGeneratorHolder.
            classCategoryList doubleClickChannel:
                    [:category | 
                    self classList selectionHolder value:#().
                    self runSelectedAction ] ].
    ^ classCategoryList

    "Created: / 04-06-2008 / 23:56:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-06-2008 / 09:51:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 01-02-2010 / 09:48:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classList
    classList isNil ifTrue:[
        classList := Tools::TestRunner2::ClassList new.
        classList immediateUpdate:true.
        classList inGeneratorHolder:self classListInGeneratorHolder.
        classList doubleClickChannel:[:testCase | self runSelectedAction].
        classList menuHolder:[ self class classListMenu ].
        classList selectionHolder onChangeSend:#classSelectionChanged to:self.
    ].
    ^ classList

    "Created: / 05-06-2008 / 19:28:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-11-2008 / 17:22:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-01-2010 / 20:30:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-07-2011 / 22:58:46 / cg"
!

packageList
    packageList ifNil:
            [ packageList := Tools::ProjectList new.
            packageList 
                inGeneratorHolder:(Iterator 
                        on:[:whatToDo | self allTestPackages do:[:p | whatToDo value:p ]]) 
                            asValue.
            packageList outGeneratorHolder:self classListOutGeneratorHolder.
            packageList doubleClickChannel:
                    [:category | 
                    self classList selectionHolder value:#().
                    self runSelectedAction ].
            packageList menuHolder:[ self menuFor:#packageListMenu ] ].
    ^ packageList

    "Created: / 05-06-2008 / 00:12:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 08:46:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-02-2011 / 21:13:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunner2 methodsFor:'actions'!

classSelectionChanged
    |selectedTestCaseHasCoveredClasses|

    selectedTestCaseHasCoveredClasses :=
        self selectedTestCases 
            contains:[:eachClass | eachClass asTestCase coveredClasses notEmpty].

    (builder componentAt:#RunCoverage) enabled:selectedTestCaseHasCoveredClasses.
    self selectedTestCaseHasCoveredClassesHolder value:selectedTestCaseHasCoveredClasses.

    "Created: / 04-07-2011 / 22:59:42 / cg"
    "Modified: / 05-08-2011 / 19:44:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debugError: test
    | caughtEx |

    caughtEx := nil.
    [
        test debug
    ] on: GenericException do:[:ex|
        caughtEx := ex.
        ex pass
    ].
    caughtEx isNil ifTrue:[
        errorListHolder value remove: test.
        errorListHolder changed
    ].
    ((caughtEx isKindOf: TestResult resumableFailure)
      or:[caughtEx isKindOf: TestResult failure]
    ) ifTrue:[
            errorListHolder value remove: test.
            errorListHolder changed.
            failureListHolder value add: test.
            failureListHolder changed
    ].

    "Created: / 06-06-2008 / 09:19:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-11-2016 / 08:12:50 / cg"
!

debugFailure: test
    | caughtEx |

    caughtEx := nil.
    [
        test debug
    ] on: GenericException do:[:ex|
        caughtEx := ex.
        ex pass
    ].
    caughtEx isNil ifTrue:[
        failureListHolder value remove: test.
        failureListHolder changed
    ].

    "Created: / 06-06-2008 / 09:20:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-11-2016 / 08:12:18 / cg"
!

runCoverageAction
    | coveredClasses allCoveredClasses browser result|

    coveredClasses := Set new.
    self selectedTestCases do:[:eachClass | 
        eachClass coveredClasses do:[:cls | cls autoload].
        coveredClasses addAll:eachClass coveredClasses.
    ].

    allCoveredClasses := Set new.
    coveredClasses do:[:eachCoveredClass | 
        allCoveredClasses addAll:(eachCoveredClass withAllPrivateClasses).
    ].

    (lastBrowser notNil 
    and:[ lastBrowser window isOpen]) ifTrue:[
        browser := lastBrowser.
        browser window topView raiseDeiconified.
    ] ifFalse:[
        browser := NewSystemBrowser browseClasses:allCoveredClasses.
        lastBrowser :=  browser.
    ].

    browser showCoverageInformation value:true.
    browser selectClasses:allCoveredClasses.
    browser window topView raise.

    self withWaitCursorDo:[
        allCoveredClasses do:[:eachClass |
            browser recompileClassWithInstrumentation:eachClass
        ].
    ].

    browser showInfo:nil.
    self withWaitCursorDo:[
        InstrumentationContext runForCoverage:[
            result := self runSuite: self selectedTestSuite.
        ].
        History add: result.
    ].

    "Modified: / 18-01-2008 / 18:38:08 / janfrog"
    "Modified: / 06-06-2008 / 08:51:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-03-2010 / 08:44:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 04-07-2011 / 23:04:22 / cg"
!

runDebuggedAction
    self runSuite: self selectedTestSuite keepFailures: false keepErrors: false debug: true

    "Created: / 21-08-2011 / 17:49:49 / cg"
!

runErrorsAction
    self runSuite: self errorTestSuite keepFailures: true keepErrors: false

    "Modified: / 18-01-2008 / 18:38:33 / janfrog"
    "Modified: / 06-06-2008 / 09:13:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (comment): / 25-11-2016 / 08:13:07 / cg"
!

runFailuresAction
    self runSuite: self failureTestSuite keepFailures: false keepErrors: true

    "Modified: / 18-01-2008 / 18:38:40 / janfrog"
    "Modified: / 06-06-2008 / 09:13:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (comment): / 25-11-2016 / 08:13:11 / cg"
!

runProfiledAction
    self shouldImplement.

    "Modified (comment): / 25-11-2016 / 08:11:05 / cg"
!

runSelectedAction
    | result |

    result := self runSuite: self selectedTestSuite.
    History add: result.

    "Modified: / 18-01-2008 / 18:38:08 / janfrog"
    "Modified: / 06-06-2008 / 08:51:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-03-2010 / 08:44:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-07-2011 / 23:04:46 / cg"
    "Modified (format): / 25-11-2016 / 08:13:17 / cg"
!

runSuite: aTestSuite

    ^self runSuite: aTestSuite keepFailures: false keepErrors: false

    "Modified: / 18-01-2008 / 18:38:08 / janfrog"
    "Modified: / 06-06-2008 / 09:12:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-03-2010 / 08:44:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runSuite: aTestSuite keepFailures: keepFailures keepErrors: keepErrors
    ^ self
        runSuite: aTestSuite 
        keepFailures: keepFailures 
        keepErrors: keepErrors 
        debug: false

    "Modified: / 18-01-2008 / 18:38:08 / janfrog"
    "Created: / 06-06-2008 / 09:11:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-06-2008 / 19:40:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-08-2011 / 13:58:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 17:52:28 / cg"
!

runSuite: aTestSuite keepFailures: keepFailures keepErrors: keepErrors debug:doDebug
    | testResult testCases blocker |

    blocker := Semaphore new.

    [
        [
            testResult := TestResult defaultResultClass new.
            testCases := Set new.
            aTestSuite
                run: testResult
                beforeEachDo:[:test :result |
                    self displayRunning: result test: test total: aTestSuite tests size
                ]
                afterEachDo:[:test :result|
                    testCases add: test class name
                ]
                debug:doDebug.

            self displayResult: testResult keepFailures: keepFailures keepErrors: keepErrors.
        ] ensure:[
            blocker signal.
        ].
    ] forkAt: Processor userBackgroundPriority .
    self withWaitCursorDo:[
        blocker wait.
    ].
    ^testResult

    "Modified: / 18-01-2008 / 18:38:08 / janfrog"
    "Created: / 06-06-2008 / 09:11:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-06-2008 / 19:40:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-07-2011 / 23:06:23 / cg"
    "Created: / 21-08-2011 / 17:51:42 / cg"
    "Modified: / 26-07-2013 / 19:13:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunner2 methodsFor:'actions - menu'!

classListMenuBrowse
    UserPreferences systemBrowserClass 
        browseClasses: (self selectedTestSuite tests collect:[:each | each class] as:Set)

    "Created: / 30-06-2011 / 22:02:26 / cg"
!

classListMenuBrowseCoveredClasses
    |setOfCoveredClasses setOfAllCoveredClasses|

    setOfCoveredClasses := Set new.
    (self selectedTestSuite tests collect:[:each | each class]) do:[:eachTestClass |
        setOfCoveredClasses addAll:eachTestClass coveredClasses.
    ].
    setOfAllCoveredClasses := Set new.
    setOfCoveredClasses do:[:eachCoveredClass | setOfAllCoveredClasses addAll:(eachCoveredClass withAllPrivateClasses)].

    UserPreferences systemBrowserClass browseClasses:setOfAllCoveredClasses

    "Created: / 30-06-2011 / 22:02:26 / cg"
!

openDocumentation
    "opens the documentation file"

    HTMLDocumentView openFullOnDocumentationFile: 'tools/misc/TOP.html#SUNIT2'

    "Created: / 04-07-2011 / 22:02:09 / cg"
!

packageListMenuSelectDependents

    |prjDef|

    prjDef := self theSingleSelectedProjectDefinition.
    prjDef ifNil:[^self].
    self selectedPackages:
        (prjDef dependentProjects copy add: prjDef package; yourself)

    "Created: / 06-06-2008 / 20:12:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

packageListMenuSelectDependentsAll

    |prjDef|

    prjDef := self theSingleSelectedProjectDefinition.
    prjDef ifNil:[^self].
    self selectedPackages:
        (prjDef allDependentProjects copy add: prjDef package; yourself)

    "Created: / 06-06-2008 / 20:12:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

packageListMenuSelectPrerequisites

    |prjDef|

    prjDef := self theSingleSelectedProjectDefinition.
    prjDef ifNil:[^self].
    self selectedPackages:
        (prjDef effectivePreRequisites copy add: prjDef package; yourself)

    "Created: / 06-06-2008 / 20:06:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

packageListMenuSelectPrerequisitesAll

    |prjDef|

    prjDef := self theSingleSelectedProjectDefinition.
    prjDef ifNil:[^self].
    self selectedPackages:
        (prjDef allPreRequisites copy add: prjDef package; yourself)

    "Created: / 06-06-2008 / 20:11:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resultListMenuBrowse
    |rslt test cls selector|

    rslt := self selectedResultHolder value.
    test := rslt test.
    test notNil ifTrue:[
        cls := test class. 
        selector := test selector.
    ] ifFalse:[
        cls := Smalltalk classNamed:rslt rawLabel
    ].

    cls notNil ifTrue:[
        cls browse:selector.
    ].

    "Created: / 23-09-2011 / 18:55:50 / cg"
!

resultListMenuCopyList
    |rslt passed failures errors text|

    rslt := resultHolder value.  
    rslt isNil ifTrue:[^ self].

    passed := OrderedCollection new.
    failures := OrderedCollection new.
    errors := OrderedCollection new.

    rslt collectAll:[:each |
        passed addAll:each passed.
        failures addAll:each failures.
        errors addAll:each errors.
    ].
    text := String streamContents:[:s |
        s nextPutLine:('errors: %1' bindWith:errors size).
        errors do:[:each |
            s spaces:4; nextPutLine:each printString
        ].
        s nextPutLine:('failures: %1' bindWith:failures size).
        failures do:[:each |
            s spaces:4; nextPutLine:each printString
        ].
        s nextPutLine:('passed: %1' bindWith:passed size).
        passed do:[:each |
            s spaces:4; nextPutLine:each printString
        ].
    ].
    self window setClipboardText:text
! !

!TestRunner2 methodsFor:'aspects'!

classCategoryOrPackageTabIndexHolder

    classCategoryOrPackageTabIndexHolder ifNil:
        [classCategoryOrPackageTabIndexHolder := nil asValue.
        classCategoryOrPackageTabIndexHolder onChangeEvaluate:
            [classCategoryOrPackageTabIndexHolder value = 1
                ifTrue:[self classCategoryList selectionChanged].
            classCategoryOrPackageTabIndexHolder value = 2
                ifTrue:[self packageList selectionChanged]]].
    ^classCategoryOrPackageTabIndexHolder

    "Created: / 05-06-2008 / 21:59:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-06-2008 / 12:29:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

classCategoryOrPackageTabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#classCategoryOrPackageTabList) isNil ifTrue:[
        builder aspectAt:#classCategoryOrPackageTabList put:(list := self class classCategoryOrPackageTabList).
    ].
    ^ list

    "Created: / 05-06-2008 / 00:00:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

classListInGeneratorHolder
    classListInGeneratorHolder ifNil:
            [ classListInGeneratorHolder := BlockValue with:
                            [:gen | 
                            |testCases|

                            testCases := OrderedCollection new.
                            gen do:[:cls | (self isTestCaseLike:cls) ifTrue:[ testCases add:cls ] ].
                            testCases ]
                        argument:self classListOutGeneratorHolder ].
    ^ classListInGeneratorHolder

    "Created: / 01-02-2010 / 09:50:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-07-2013 / 19:28:47 / cg"
!

classListOutGeneratorHolder

    classListOutGeneratorHolder ifNil:
        [classListOutGeneratorHolder := ValueHolder with:#()].
    ^classListOutGeneratorHolder

    "Created: / 01-02-2010 / 09:46:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

detailsHolder
    "return/create the 'detailsHolder' value holder (automatically generated)"

    detailsHolder isNil ifTrue:[
        detailsHolder := ValueHolder new.
    ].
    ^ detailsHolder

    "Created: / 18-01-2008 / 18:44:29 / janfrog"
!

errorListHolder
    "return/create the 'errorListHolder' value holder (automatically generated)"

    errorListHolder isNil ifTrue:[
        errorListHolder := ValueHolder new.
    ].
    ^ errorListHolder

    "Created: / 06-06-2008 / 08:55:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

errorSelectionHolder
    "return/create the 'errorSelectionHolder' value holder (automatically generated)"

    errorSelectionHolder isNil ifTrue:[
        errorSelectionHolder := ValueHolder new.
    ].
    ^ errorSelectionHolder

    "Created: / 06-06-2008 / 08:55:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

failureListHolder
    "return/create the 'failureListHolder' value holder (automatically generated)"

    failureListHolder isNil ifTrue:[
        failureListHolder := ValueHolder new.
    ].
    ^ failureListHolder

    "Created: / 06-06-2008 / 08:55:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

failureSelectionHolder
    "return/create the 'failureSelectionHolder' value holder (automatically generated)"

    failureSelectionHolder isNil ifTrue:[
        failureSelectionHolder := ValueHolder new.
    ].
    ^ failureSelectionHolder

    "Created: / 06-06-2008 / 08:55:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

hasErrorsAspect

    ^(AspectAdaptor forAspect:#notEmpty)
        subjectChannel: self errorListHolder

    "Created: / 06-06-2008 / 09:17:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

hasFailuresAspect

    ^(AspectAdaptor forAspect:#notEmpty)
        subjectChannel: self failureListHolder

    "Created: / 06-06-2008 / 09:17:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

hasTestCasesAspect

    ^(AspectAdaptor forAspect:#notEmpty)
        subjectChannel: self classListInGeneratorHolder

    "Created: / 06-06-2008 / 09:54:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 01-02-2010 / 09:53:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

historyHolder
    "return/create the 'resultHolder' value holder (automatically generated)"

    History ifNil:[self class initializeHistory].
    ^History

    "Created: / 19-03-2010 / 08:43:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modeHolder
    "return/create the 'modeHolder' value holder (automatically generated)"

    modeHolder isNil ifTrue:[
        modeHolder := ValueHolder new.
    ].
    ^ modeHolder

    "Created: / 18-01-2008 / 18:44:29 / janfrog"
!

resultAndHistoryTabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#resultAndHistoryTabList) isNil ifTrue:[
        builder aspectAt:#resultAndHistoryTabList put:(list := self class resultAndHistoryTabList).
    ].
    ^ list
!

resultHolder
    "return/create the 'resultHolder' value holder (automatically generated)"

    resultHolder isNil ifTrue:[
        resultHolder := ValueHolder new.
    ].
    ^ resultHolder
!

selectedResultHolder
    selectedResultHolder isNil ifTrue:[
        selectedResultHolder := ValueHolder new.
    ].
    ^ selectedResultHolder

    "Created: / 23-09-2011 / 19:14:51 / cg"
!

selectedTestCaseHasCoveredClassesHolder
    selectedTestCaseHasCoveredClassesHolder isNil ifTrue:[
        selectedTestCaseHasCoveredClassesHolder := false asValue
    ].
    ^ selectedTestCaseHasCoveredClassesHolder

    "Created: / 18-01-2008 / 18:44:29 / janfrog"
! !

!TestRunner2 methodsFor:'displaying'!

displayColor: aColorValue

        (builder componentAt: #Mode) widget insideColor: aColorValue.
        (builder componentAt: #Details) widget insideColor: aColorValue.

    "Modified: / 02-04-2000 / 14:21:42 / Sames"
    "Created: / 18-01-2008 / 20:22:39 / janfrog"
!

displayDetails: details

        self detailsHolder value: details

    "Modified: / 02-04-2000 / 14:21:42 / Sames"
    "Created: / 18-01-2008 / 20:33:51 / janfrog"
!

displayFail:result 
    self displayColor:self errorColor.
    self displayMode:'Fail'.
    self displayDetails:result printString.

    "Created: / 06-06-2008 / 08:49:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-02-2010 / 14:43:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayMode: mode

        self modeHolder value: mode

    "Modified: / 02-04-2000 / 14:21:42 / Sames"
    "Created: / 18-01-2008 / 20:33:35 / janfrog"
!

displayPass:result 
    self displayColor:self passedColor.
    self displayMode:'Pass '.
    self 
        displayDetails:result printString , ' ' , (self timeSinceLastPassAsString)
!

displayResult: aTestResult

    self displayResult: aTestResult keepFailures: false keepErrors: false.

    "Modified: / 21-06-2000 / 12:14:52 / Sames"
    "Created: / 06-06-2008 / 08:49:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-06-2008 / 19:24:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

displayResult: aTestResult keepFailures: keepFailures keepErrors: keepErrors
    |sortByPrintString|

    resultHolder value: (Array with: aTestResult).

    aTestResult hasPassed ifTrue:[
        self displayPass: aTestResult
    ] ifFalse:[
        self displayFail: aTestResult
    ].
    sortByPrintString := [:a :b|a printString < b printString].

    keepFailures ifFalse:[
        failureListHolder value: (aTestResult failures asSortedCollection:sortByPrintString)
    ].
    keepErrors ifFalse:[
        errorListHolder value: (aTestResult errors asSortedCollection:sortByPrintString)
    ].
    self repairDamage

    "Modified: / 21-06-2000 / 12:14:52 / Sames"
    "Created: / 06-06-2008 / 09:12:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-03-2010 / 08:33:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayRunning: result test: test total: total

    self displayColor: (result hasPassed ifTrue:[self class currentlyRunningColor] ifFalse:[Color orange]).
    self displayMode: 'Running ' , test printString.
    self displayDetails: total printString , ' total, ' , result printString

    "Modified: / 21-06-2000 / 12:14:52 / Sames"
    "Created: / 06-06-2008 / 19:38:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-07-2011 / 14:14:42 / cg"
! !

!TestRunner2 methodsFor:'hooks'!

commonPostOpen

    self 
        displayMode:'SUnit Test Runner Tool';
        displayDetails:'Select tests and press ''Run Selected'''.

    self classCategoryOrPackageTabIndexHolder value:2

    "Created: / 05-06-2008 / 21:58:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-06-2008 / 10:06:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 30-06-2011 / 20:20:40 / cg"
! !

!TestRunner2 methodsFor:'private'!

buildSuiteFromClass: testCaseCls 
    "Bit hackish, but no time to redesign sUnit from
     scratch"
    
    ^  testCaseCls buildSuite.

    "Modified: / 01-03-2011 / 22:53:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-05-2011 / 21:03:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

formatTime: aTime 
        aTime hours > 0 ifTrue: [^aTime hours printString , 'h'].
        aTime minutes > 0 ifTrue: [^aTime minutes printString , 'min'].
        ^aTime seconds printString , ' sec'

    "Created: / 18-01-2008 / 18:57:08 / janfrog"
!

isTestCaseLike:cls 

    ^cls isTestCaseLike

    "Modified: / 28-02-2011 / 21:31:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repairDamage
    |wg|

    (wg := self windowGroup) notNil ifTrue:[wg  repairDamage].

    "Created: / 18-01-2008 / 18:45:39 / janfrog"
!

timeSinceLastPassAsString
        lastPass isNil ifTrue: [^''].
        ^', ' , (self formatTime: (Time now subtractTime: lastPass getSeconds)) , ' since last Pass'

    "Modified: / 03-04-2000 / 19:17:11 / Sames"
    "Created: / 18-01-2008 / 18:51:21 / janfrog"
! !

!TestRunner2::ClassList class methodsFor:'documentation'!

version
    ^'$Header$'
! !

!TestRunner2::ClassList methodsFor:'private'!

nameListEntryFor:aClass withNameSpace:useFullName

    | nm |

    nm := super nameListEntryFor:aClass withNameSpace:useFullName.
    (aClass isTestCaseLike) ifFalse:[
        self breakPoint: #jv.
        ^nm
    ].
    aClass isAbstract ifTrue:[
        nm := (nm,' ') allItalic withColor:Color gray
    ].
    ^nm

    "Created: / 27-11-2008 / 17:24:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-02-2011 / 21:42:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunner2::ResultList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TestRunner2::ResultList andSelector:#windowSpec
     Tools::TestRunner2::ResultList new openInterface:#windowSpec
     Tools::TestRunner2::ResultList open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Test Result List'
          name: 'Test Result List'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (HierarchicalListViewSpec
              name: 'List'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: selectionHolder
              menu: resultListMenu
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: listHolder
              useIndex: false
              highlightMode: line
              doubleClickSelector: debugTest:
              showLines: false
              useDefaultIcons: false
            )
           )
         
        )
      )
! !

!TestRunner2::ResultList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #resultsHolder
        #selectionHolder
      ).

! !

!TestRunner2::ResultList methodsFor:'actions'!

debugTest:entryIndex 
    |entry test caughtEx|

    test := (entry := listHolder value at:entryIndex) test.
    test ifNil:[ ^ self ].

    [
        caughtEx := nil.
        [test debug] on:GenericException do:[:ex | caughtEx := ex. ex pass].
        caughtEx 
            ifNil:
                [self setResult: #passed in: entry]
            ifNotNil:
                [((caughtEx isKindOf:TestResult resumableFailure) 
                    or:[ caughtEx isKindOf:TestResult failure ]) 
                        ifTrue:
                            [self setResult: #failed in: entry]
                        ifFalse:
                            [self setResult: #error in: entry]].
    ] fork

    "Modified: / 07-02-2010 / 18:59:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 08-02-2010 / 10:08:30 / Jan Vrany <jan,vrany@fit.cvut.cz>"
! !

!TestRunner2::ResultList methodsFor:'aspects'!

listHolder
    "return/create the 'listHolder' value holder (automatically generated)"

    listHolder isNil ifTrue:[
        listHolder := ValueHolder new.
    ].
    ^ listHolder
!

resultsHolder
    "return/create the 'resultHolder' value holder (automatically generated)"

    resultsHolder isNil ifTrue:[
        resultsHolder := ValueHolder new.
        resultsHolder addDependent:self.
    ].
    ^ resultsHolder

    "Created: / 19-03-2010 / 08:31:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resultsHolder:aValueModel
    "set the 'resultHolder' value holder (automatically generated)"

    |oldValue newValue|

    resultsHolder notNil ifTrue:[
        oldValue := resultsHolder value.
        resultsHolder removeDependent:self.
    ].
    resultsHolder := aValueModel.
    resultsHolder notNil ifTrue:[
        resultsHolder addDependent:self.
    ].
    newValue := resultsHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:resultsHolder.
    ].

    "Created: / 19-03-2010 / 08:32:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionHolder
    selectionHolder isNil ifTrue:[
        selectionHolder := ValueHolder new.
    ].
    ^ selectionHolder

    "Created: / 23-09-2011 / 19:01:57 / cg"
!

selectionHolder:something
    selectionHolder := something.

    "Created: / 23-09-2011 / 19:02:06 / cg"
! !

!TestRunner2::ResultList methodsFor:'change & update'!

update:aspect with:param from:sender

    sender == resultsHolder ifTrue:
        [results := self resultsHolder value. 
        self updateTimestampFormat.
        self updateList.
        ^self].

    super update:aspect with:param from:sender

    "Modified: / 19-03-2010 / 08:50:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList

    | list |
    list := HierarchicalList new.
    list root: self makeRootEntry.            
    list showRoot: false.    
    self listHolder value: list.

    "Created: / 07-02-2010 / 11:03:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-02-2010 / 13:41:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateTimestampFormat

    (results isEmptyOrNil or:[results size = 1])
        ifTrue:[timestampFormat := nil].

    ((results collect:[:each|each timestamp] as:Set) size = 1)
        ifTrue: [timestampFormat := ' (%h:%m)']
        ifFalse:[timestampFormat := ' (%(month)-%(day) %h:%m)']

    "Created: / 19-03-2010 / 08:50:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-09-2010 / 09:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2011 / 19:05:57 / cg"
! !

!TestRunner2::ResultList methodsFor:'private'!

invalidate

    ^(self componentAt: #List) scrolledView redraw

    "Created: / 07-02-2010 / 18:57:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setResult: testResult in: entry

    entry result ~= testResult ifTrue:
        [entry result: testResult.
        self invalidate].

    "Created: / 08-02-2010 / 10:28:53 / Jan Vrany <jan,vrany@fit.cvut.cz>"
! !

!TestRunner2::ResultList methodsFor:'private-list'!

makeClassEntryFor: class result: result tests: tests

    | entry children |
    entry := ListEntry labeled: (class perform:#sunitName ifNotUnderstood:[class name]).
    children := (tests asSortedCollection: [:a :b|a selector < b selector])
        collect:[:test|self makeTestEntryFor: test result: result].
    entry setChildren: children.
    (entry result ~= #passed and:[results size = 1]) ifTrue:[entry expand].
    ^entry

    "Created: / 19-03-2010 / 08:41:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeResultEntryFor: result
    | entry children classes label |

    label := result name ? ''.
    result timestamp notNil ifTrue:[
        label := label , (result timestamp printStringFormat: timestampFormat)
    ].
    entry := ListEntry labeled: label.
    classes := Dictionary new.
    result tests do: [:test|
        (classes at: test class ifAbsentPut:[OrderedCollection new])
            add: test
    ].
    children := 
        classes keysAndValuesCollect: [:class :tests|
            self makeClassEntryFor: class result: result tests: tests
        ].
    entry setChildren: children.
    ^entry.

    "Created: / 19-03-2010 / 08:36:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-07-2013 / 19:29:10 / cg"
!

makeRootEntry

    | entry children |
    entry := ListEntry labeled: 'Test Results'.
    results isEmptyOrNil ifTrue:[^entry].
    children := results size = 1 
                    ifTrue:
                        [(self makeResultEntryFor: results anyOne) getChildren]
                    ifFalse:
                        [results collect:[:result|self makeResultEntryFor:result]].
    entry setChildren: children.
    ^entry.

    "Created: / 07-02-2010 / 13:39:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2010 / 08:39:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2011 / 19:05:55 / cg"
!

makeTestEntryFor: test result: result

    | entry |
    entry := ListEntry labeled: test selector.
    entry test: test.
    (result errors includes: test)
        ifTrue:
            [entry result: #error]
        ifFalse:
            [(result failures includes: test)
                ifTrue:
                    [entry result: #failed]
                ifFalse:
                    [entry result: #passed]].
    ^entry

    "Created: / 19-03-2010 / 08:41:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunner2::ResultList::ListEntry class methodsFor:'initialization'!

errorText
    ErrorText isNil ifTrue:[
        ErrorText := ' [','error' allBold,']' withColor: Tools::TestRunner2 errorColor "darker".    
    ].
    ^ ErrorText

    "Created: / 06-06-2016 / 14:41:59 / cg"
!

failedText
    FailedText isNil ifTrue:[
        FailedText := ' [','failed' allBold,']' withColor: Tools::TestRunner2 failedColor "darker".
    ].
    ^ FailedText

    "Created: / 06-06-2016 / 14:41:40 / cg"
!

passedText
    PassedText isNil ifTrue:[
        PassedText := ' [passed]' withColor: Tools::TestRunner2 passedColor darker.
    ].
    ^ PassedText

    "Created: / 06-06-2016 / 14:41:16 / cg"
! !

!TestRunner2::ResultList::ListEntry class methodsFor:'instance creation'!

labeled: aStringOrText

    ^self new label: aStringOrText

    "Created: / 07-02-2010 / 13:31:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunner2::ResultList::ListEntry methodsFor:'accessing'!

icon

    ^self result == #passed 
        ifTrue:[SystemBrowser greenThumbUpSmallIcon]
        ifFalse:[SystemBrowser redThumbDownSmallIcon]

    "Created: / 07-02-2010 / 18:34:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    | result |

    result := self result.
    realLabel ifNil:[
        realLabel := label.
        test ifNotNil:[
            result == #passed ifTrue:[realLabel := realLabel , self class passedText].
            result == #error ifTrue:[realLabel := realLabel , self class errorText].
            result == #failed ifTrue:[realLabel := realLabel , self class failedText].
        ] ifNil: [
            realLabel := realLabel , self summary.
        ]        
    ].

    ^ realLabel

    "Modified: / 07-02-2010 / 18:28:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2010 / 10:15:35 / Jan Vrany <jan,vrany@fit.cvut.cz>"
    "Modified (format): / 06-06-2016 / 14:43:01 / cg"
!

label:aText
    label := aText.
    realLabel := nil.

    "Modified: / 07-02-2010 / 14:36:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rawLabel
    ^ label.
!

result

    result ifNil:
        [result := self computeResult].
    ^ result

    "Modified: / 07-02-2010 / 18:30:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

result:aSymbol

    result := aSymbol.
    self reset.
    result := aSymbol.

    "Modified: / 07-02-2010 / 18:55:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test
    ^ test
!

test:aTestCase
    test := aTestCase.
! !

!TestRunner2::ResultList::ListEntry methodsFor:'enumeration'!

leafsDo: aBlock

    self isLeafEntry ifTrue:[^aBlock value: self].
    children do:[:each|each leafsDo: aBlock]

    "Created: / 08-02-2010 / 10:17:32 / Jan Vrany <jan,vrany@fit.cvut.cz>"
!

testsDo: aBlock

    test ifNotNil:[aBlock value: test].
    children do:[:each|each testsDo: aBlock]

    "Created: / 08-02-2010 / 10:10:36 / Jan Vrany <jan,vrany@fit.cvut.cz>"
! !

!TestRunner2::ResultList::ListEntry methodsFor:'initialization'!

reset

    realLabel := result := nil.
    (parent notNil and:[parent class == self class])
        ifTrue:[parent reset]

    "Created: / 07-02-2010 / 18:44:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setChildren: aCollection

    children := aCollection.
    children do:[:e|e parent: self].

    "Created: / 07-02-2010 / 11:41:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunner2::ResultList::ListEntry methodsFor:'private'!

computeResult

    | result |
    result := #passed.
    (children ? #()) do:
        [:entry|
        entry result == #error ifTrue:[^#error].
        entry result == #failed ifTrue:[result := #failed]].
    ^result

    "Created: / 07-02-2010 / 18:30:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

summary

    | passed failed error |
    passed := failed := error := 0.
    self leafsDo:
        [:entry|
        entry isPassed ifTrue:[passed := passed + 1].
        entry isFailed ifTrue:[failed := failed + 1].
        entry isError ifTrue:[error := error + 1]].

    ^' [ ' , passed printString , ' / ' , failed printString , ' / ', error printString , ' ]'

    "Created: / 08-02-2010 / 10:16:52 / Jan Vrany <jan,vrany@fit.cvut.cz>"
! !

!TestRunner2::ResultList::ListEntry methodsFor:'testing'!

isError

    ^self result == #error

    "Created: / 08-02-2010 / 10:18:26 / Jan Vrany <jan,vrany@fit.cvut.cz>"
!

isFailed

    ^self result == #failed

    "Created: / 08-02-2010 / 10:18:21 / Jan Vrany <jan,vrany@fit.cvut.cz>"
!

isLeafEntry

    ^children isEmptyOrNil

    "Created: / 08-02-2010 / 10:11:06 / Jan Vrany <jan,vrany@fit.cvut.cz>"
    "Modified: / 04-08-2011 / 19:05:59 / cg"
!

isPassed

    ^self result == #passed

    "Created: / 08-02-2010 / 10:18:15 / Jan Vrany <jan,vrany@fit.cvut.cz>"
! !

!TestRunner2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


TestRunner2 initialize!
