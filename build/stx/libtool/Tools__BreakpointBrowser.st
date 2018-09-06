"
 COPYRIGHT (c) 2008 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ApplicationModel subclass:#BreakpointBrowser
	instanceVariableNames:'updatingLabelShown breakpointList shownCopyOfBreakpointList
		selectionIndexHolder currentSortColumn currentSortIsReverse
		showHalts showOthers showAssertions showAssertionsInTests
		showCodeBreakpoints showCodeBreakpointsFor showMethodBreakpoints
		showLineBreakpoints showDebugCode showTracepoints codeView
		infoHolder updateProcess showWhichHaltsHolder packageFilter
		classNameFilter'
	classVariableNames:'MessagesAndTypes'
	poolDictionaries:''
	category:'Interface-Debugger'
!

Object subclass:#BreakpointListEntry
	instanceVariableNames:'type ignoredInfo arg className selector lineNumber info enabled'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BreakpointBrowser
!

BreakpointBrowser::BreakpointListEntry subclass:#BreakpointListEntryForLineBreak
	instanceVariableNames:'breakPoint'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BreakpointBrowser
!

RBProgramNodeVisitor subclass:#MessageArgumentExtractor
	instanceVariableNames:'callBack selectorToSearch'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BreakpointBrowser
!

!BreakpointBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
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
    tool to list breakpoints (breakPoint/halt/assert)

    [author:]
	cg (cg@FUSI)
"
! !

!BreakpointBrowser class methodsFor:'initialization'!

defaultListOfMessagesAndTypes
    "the set of messages which are shown; 
     you can add your own one's with a #other categorization"

    ^ #(
        (#breakPoint:           #breakPoint)
        (#breakPoint:info:      #breakPoint)
        (#debuggingCodeFor:is:  #debugCode)
        (#halt                  #halt)
        (#halt:                 #halt)
        (#assert:               #assertion)
        (#assert:message:       #assertion)
        (#todo                  #todo)
        (#todo:                 #todo)
        (#tracePoint:           #tracepoint)
        (#tracePoint:message:   #tracepoint)
    ).
!

messagesAndTypes
    "the spec of selectors to search for coded breakpoints"

    MessagesAndTypes isNil ifTrue:[
        MessagesAndTypes := self defaultListOfMessagesAndTypes
    ].
    ^ MessagesAndTypes
! !

!BreakpointBrowser class methodsFor:'defaults'!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary openBreakpointBrowserIcon
! !

!BreakpointBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::BreakpointBrowser andSelector:#windowSpec
     Tools::BreakpointBrowser new openInterface:#windowSpec
     Tools::BreakpointBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Breakpoint Browser'
          name: 'Breakpoint Browser'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 680 691)
          menu: mainMenu
          icon: defaultIcon
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'ToolBar1'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 40 0)
              menu: toolBarMenu
              textDefault: true
            )
           (VariableVerticalPanelSpec
              name: 'VariableVerticalPanel1'
              layout: (LayoutFrame 0 0 40 0 0 1 0 1)
              snapMode: both
              component: 
             (SpecCollection
                collection: (
                 (DataSetSpec
                    name: 'Table'
                    model: selectionIndexHolder
                    menu: itemMenu
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    dataList: shownCopyOfBreakpointList
                    doubleClickSelector: itemDoubleClicked:
                    columnHolder: tableColumns
                  )
                 (TextEditorSpec
                    name: 'TextEditor1'
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    hasKeyboardFocusInitially: false
                    viewClassName: 'codeViewClass'
                    postBuildCallback: postBuildCodeView:
                  )
                 )
               
              )
              handles: (Any 0.5 1.0)
            )
           (LabelSpec
              label: 'Updating - Please Wait...'
              name: 'Label1'
              layout: (LayoutFrame 0 0 40 0 0 1 0 1)
              visibilityChannel: updatingLabelShown
              backgroundColor: (Color 100.0 49.9992370489052 49.9992370489052)
              translateLabel: true
            )
           (ViewSpec
              name: 'InfoBox'
              layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
              visibilityChannel: updatingLabelShown
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Label'
                    name: 'Label2'
                    layout: (LayoutFrame 2 0 2 0 680 0 30 0)
                    level: -1
                    translateLabel: true
                    labelChannel: infoHolder
                    adjust: left
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!BreakpointBrowser class methodsFor:'menu specs'!

itemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::BreakpointBrowser andSelector:#itemMenu
     (Menu new fromLiteralArrayEncoding:(Tools::BreakpointBrowser itemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Browse'
            itemValue: browseSelectedItem
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: selectedItemIsIgnoredHalt
            label: 'Stop Ignoring this Halt'
            itemValue: reenableHalt
          )
         (MenuItem
            enabled: selectedItemIsEnabledLineBreak
            label: 'Disable this Breakpoint'
            itemValue: disableLineBreak
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
     MenuEditor new openOnClass:Tools::BreakpointBrowser andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::BreakpointBrowser mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Selection'
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasSelectionHolder
                  label: 'Browse'
                  itemValue: browseSelectedItem
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: selectedItemIsIgnoredHalt
                  label: 'Stop Ignoring this Halt'
                  itemValue: reenableHalt
                )
               (MenuItem
                  enabled: selectedItemIsEnabledLineBreak
                  label: 'Disable this Breakpoint'
                  itemValue: disableLineBreak
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'View'
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: false
                  label: '-- Coded --'
                )
               (MenuItem
                  label: 'Assertions'
                  itemValue: showAssertions:
                  hideMenuOnActivated: false
                  indication: showAssertions
                )
               (MenuItem
                  enabled: showAssertions
                  label: 'Assertions in Tests'
                  itemValue: showAssertionsInTests:
                  hideMenuOnActivated: false
                  indication: showAssertionsInTests
                )
               (MenuItem
                  label: 'Halts'
                  itemValue: showHalts:
                  hideMenuOnActivated: false
                  indication: showHalts
                )
               (MenuItem
                  enabled: showHalts
                  label: ' '
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        label: 'All Halts'
                        nameKey: AllHalts
                        choice: showWhichHaltsHolder
                        choiceValue: all
                      )
                     (MenuItem
                        label: 'Enabled Halts'
                        nameKey: EnabledHalts
                        choice: showWhichHaltsHolder
                        choiceValue: enabled
                      )
                     (MenuItem
                        label: 'Ignored Halts'
                        nameKey: IgnoredHalts
                        choice: showWhichHaltsHolder
                        choiceValue: ignored
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: 'Coded Breakpoints'
                  itemValue: showCodeBreakpoints:
                  hideMenuOnActivated: false
                  indication: showCodeBreakpoints
                )
               (MenuItem
                  enabled: showCodeBreakpoints
                  label: ' '
                  submenuChannel: codeBreakpointMenu
                )
               (MenuItem
                  label: 'Debug Code'
                  itemValue: showDebugCode:
                  hideMenuOnActivated: false
                  indication: showDebugCode
                )
               (MenuItem
                  label: 'Tracepoints'
                  itemValue: showTracepoints:
                  hideMenuOnActivated: false
                  indication: showTracepoints
                )
               (MenuItem
                  label: 'Other Debug Messages'
                  itemValue: showOthers:
                  hideMenuOnActivated: false
                  indication: showOthers
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: false
                  label: '-- Dynamic --'
                )
               (MenuItem
                  label: 'Method Breakpoints'
                  itemValue: showMethodBreakpoints:
                  hideMenuOnActivated: false
                  indication: showMethodBreakpoints
                )
               (MenuItem
                  label: 'Line Breakpoints'
                  itemValue: showLineBreakpoints:
                  hideMenuOnActivated: false
                  indication: showLineBreakpoints
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Toggle All'
                  itemValue: toggleAllShownTypes
                  hideMenuOnActivated: false
                )
               (MenuItem
                  label: 'All On'
                  itemValue: showAllTypes
                  hideMenuOnActivated: false
                )
               (MenuItem
                  label: 'All Off'
                  itemValue: hideAllTypes
                  hideMenuOnActivated: false
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Update List'
                  itemValue: updateList
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Filter'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Package Filter...'
                  itemValue: openPackageFilterDialog
                )
               (MenuItem
                  label: 'Class Filter...'
                  itemValue: openClassFilterDialog
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Enable'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Assertions'
                  itemValue: enableAssertions:
                  hideMenuOnActivated: false
                  indication: enableAssertions
                )
               (MenuItem
                  label: 'Halts'
                  itemValue: enableHalts:
                  hideMenuOnActivated: false
                  indication: enableHalts
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Coded Break & Tracepoints'
                  submenuChannel: enabledCodeBreakpointMenu
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application...'
                  itemValue: openAboutThisApplication
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
     MenuEditor new openOnClass:Tools::BreakpointBrowser andSelector:#toolBarMenu
     (Menu new fromLiteralArrayEncoding:(Tools::BreakpointBrowser toolBarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Update List'
            itemValue: updateList
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary reloadIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Browse Selected Method'
            itemValue: browseSelectedItem
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary startNewSystemBrowserIcon)
          )
         )
        nil
        nil
      )
! !

!BreakpointBrowser class methodsFor:'tableColumns specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::BreakpointBrowser andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Type'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'type'
         width: 70
         model: typeString
         menuFromApplication: false
         writeSelector: type:
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Arg'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'type'
         width: 50
         model: arg
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Class'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'className'
         width: 150
         model: className
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Method'
         labelAlignment: left
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'selector'
         width: 200
         model: selector
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Ign'
         labelButtonType: Button
         columnAlignment: center
         width: 50
         model: isIgnoredString
         menuFromApplication: false
         writeSelector: isIgnored:
       )
      (DataSetColumnSpec
         label: 'Info'
         labelAlignment: left
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'info'
         model: info
         canSelect: false
       )
      )
    
!

tableColumns_v1
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::BreakpointBrowser andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
	 label: 'Enabled'
	 activeHelpKey: ''
	 activeHelpKeyForLabel: ''
	 labelButtonType: Button
	 width: 50
	 editorType: CheckToggle
	 rendererType: CheckToggle
	 model: enabled
       )
      (DataSetColumnSpec
	 label: 'Type'
	 activeHelpKey: ''
	 activeHelpKeyForLabel: ''
	 labelButtonType: Button
	 labelActionSelector: sortBy:
	 labelActionArgument: 'type'
	 width: 60
	 model: type
	 canSelect: false
       )
      (DataSetColumnSpec
	 label: 'Arg'
	 activeHelpKey: ''
	 activeHelpKeyForLabel: ''
	 labelButtonType: Button
	 labelActionSelector: sortBy:
	 labelActionArgument: 'type'
	 width: 50
	 model: arg
	 canSelect: false
       )
      (DataSetColumnSpec
	 label: 'Class'
	 activeHelpKey: ''
	 activeHelpKeyForLabel: ''
	 labelButtonType: Button
	 labelActionSelector: sortBy:
	 labelActionArgument: 'className'
	 width: 150
	 model: className
	 canSelect: false
       )
      (DataSetColumnSpec
	 label: 'Method'
	 labelAlignment: left
	 activeHelpKey: ''
	 activeHelpKeyForLabel: ''
	 labelButtonType: Button
	 labelActionSelector: sortBy:
	 labelActionArgument: 'selector'
	 width: 200
	 model: selector
	 canSelect: false
       )
      (DataSetColumnSpec
	 label: 'Line'
	 labelAlignment: left
	 activeHelpKey: ''
	 activeHelpKeyForLabel: ''
	 labelButtonType: Button
	 labelActionSelector: sortBy:
	 labelActionArgument: 'lineNumber'
	 width: 35
	 model: lineNumber
	 canSelect: false
       )
      (DataSetColumnSpec
	 label: 'Info'
	 labelAlignment: left
	 activeHelpKey: ''
	 activeHelpKeyForLabel: ''
	 labelButtonType: Button
	 labelActionSelector: sortBy:
	 labelActionArgument: 'info'
	 model: info
	 canSelect: false
       )
      )
!

tableColumns_v2
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::BreakpointBrowser andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Type'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'type'
         width: 70
         model: type
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Arg'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'type'
         width: 50
         model: arg
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Class'
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'className'
         width: 150
         model: className
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Method'
         labelAlignment: left
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'selector'
         width: 200
         model: selector
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Line'
         labelAlignment: left
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'lineNumber'
         width: 35
         model: lineNumber
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Info'
         labelAlignment: left
         activeHelpKey: ''
         activeHelpKeyForLabel: ''
         labelButtonType: Button
         labelActionSelector: sortBy:
         labelActionArgument: 'info'
         model: info
         canSelect: false
       )
      )
! !

!BreakpointBrowser methodsFor:'accessing'!

aboutThisApplicationText
    |msg|

    msg := super aboutThisApplicationText.
    msg := msg , '\\Written by Claus Gittinger (cg@exept.de).'.
    ^msg withCRs.
!

breakpointListEntryAtIndex:idx
    ^ shownCopyOfBreakpointList at:idx ifAbsent:nil





!

messagesAndTypes
    "the spec of selectors to search for coded breakpoints"

    ^ self class messagesAndTypes
!

selectedBreakpointListEntry
    self selectionIndex isNil ifTrue:[^ nil].
    ^ self breakpointListEntryAtIndex:(self selectionIndex).
!

selectionIndex
    ^ self selectionIndexHolder value
!

shownCopyOfBreakpointList
    shownCopyOfBreakpointList isNil ifTrue:[
	shownCopyOfBreakpointList := List new
    ].
    ^ shownCopyOfBreakpointList

    "Created: / 18-02-2007 / 12:53:01 / cg"
!

updatingLabelShown
    updatingLabelShown isNil ifTrue:[
	updatingLabelShown := true asValue
    ].
    ^ updatingLabelShown
! !

!BreakpointBrowser methodsFor:'aspects'!

enableAssertions
    ^ Smalltalk ignoreAssertions not
!

enableAssertions:aBoolean
    Smalltalk ignoreAssertions:aBoolean not.
!

enableHalts
    ^ Smalltalk ignoreHalt not

    "Modified: / 18-11-2010 / 11:24:11 / cg"
!

enableHalts:aBoolean
    ^ Smalltalk ignoreHalt:aBoolean not

    "Modified: / 18-11-2010 / 11:30:03 / cg"
!

hasSelectionHolder
    ^ BlockValue
	with:[:selIndex | selIndex notNil and:[selIndex ~~ 0]]
	argument:self selectionIndexHolder
!

infoHolder
    infoHolder isNil ifTrue:[
        infoHolder := nil asValue.
    ].
    ^ infoHolder

    "Created: / 22-10-2006 / 02:00:41 / cg"
!

selectedItemIsEnabledLineBreak
    |selIndex entry|

    (selIndex := self selectionIndexHolder value) isNil ifTrue:[^ false].
    entry := self breakpointListEntryAtIndex:selIndex.
    ^ entry isLineBreakpoint and:[entry breakPoint isEnabled]
!

selectedItemIsIgnoredHalt
    |selIndex entry info|

    (selIndex := self selectionIndexHolder value) isNil ifTrue:[^ false].
    (selIndex == 0) ifTrue:[^ false].

    entry := self breakpointListEntryAtIndex:selIndex.
    info := Debugger haltIgnoreInformationFor:(entry method) atLineNr:(entry lineNumber).
    ^ info notNil and:[ info isHaltIgnored ].
!

selectionIndexHolder
    selectionIndexHolder isNil ifTrue:[
	selectionIndexHolder := nil asValue.
	selectionIndexHolder onChangeSend:#updateCode to:self
    ].
    ^ selectionIndexHolder

    "Created: / 22-10-2006 / 02:00:41 / cg"
!

showAssertions
    ^ showAssertions ? true
!

showAssertions:aBoolean
    showAssertions := aBoolean.
    self updateShownBreakpointList
!

showAssertionsInTests
    ^ showAssertionsInTests ? false
!

showAssertionsInTests:aBoolean
    showAssertionsInTests := aBoolean.
    self updateShownBreakpointList
!

showCodeBreakpoints
    ^ showCodeBreakpoints ? true
!

showCodeBreakpoints:aBoolean
    showCodeBreakpoints := aBoolean.
    self updateShownBreakpointList
!

showDebugCode
    ^ showDebugCode ? true
!

showDebugCode:aBoolean
    showDebugCode := aBoolean.
    self updateShownBreakpointList
!

showHalts
    ^ showHalts ? true
!

showHalts:aBoolean
    showHalts := aBoolean.
    self updateShownBreakpointList
!

showLineBreakpoints
    ^ showLineBreakpoints ? true
!

showLineBreakpoints:aBoolean
    showLineBreakpoints := aBoolean.
    self updateShownBreakpointList
!

showMethodBreakpoints
    ^ showMethodBreakpoints ? true
!

showMethodBreakpoints:aBoolean
    showMethodBreakpoints := aBoolean.
    self updateShownBreakpointList
!

showOthers
    ^ showOthers ? true
!

showOthers:aBoolean
    showOthers := aBoolean.
    self updateShownBreakpointList
!

showTracepoints
    ^ showTracepoints ? true
!

showTracepoints:aBoolean
    showTracepoints := aBoolean.
    self updateShownBreakpointList
!

showWhichHaltsHolder
    showWhichHaltsHolder isNil ifTrue:[
        showWhichHaltsHolder := #all asValue.
        showWhichHaltsHolder onChangeSend:#updateShownBreakpointList to:self
    ].
    ^ showWhichHaltsHolder
! !

!BreakpointBrowser methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    changedObject == Smalltalk ifTrue:[
        something == #methodInClass ifTrue:[
            self updateForClass:(aParameter first) selector:(aParameter second).
            ^ self.
        ].
        something == #methodInClassRemoved ifTrue:[
            self updateForClass:(aParameter first) selector:(aParameter second).
            ^ self.
        ].
        something == #ignoredHalts ifTrue:[
            self updateShownBreakpointList.
            ^ self.
        ].
    ].
!

filter
    "filter those items which are to be shown from the complete list"

    |newList showWhichHalt|

    newList := breakpointList.

    classNameFilter notEmptyOrNil ifTrue:[
        newList := newList select:[:entry | entry relatedToClass:classNameFilter].
    ].
    packageFilter notEmptyOrNil ifTrue:[
        newList := newList select:[:entry | entry relatedToPackage:packageFilter].
    ].

    self showOthers ifFalse:[
        newList := newList reject:[:entry | entry isOther or:[ entry isTodo] ].
    ].
    self showDebugCode ifFalse:[
        newList := newList reject:[:entry | entry isDebugCode].
    ].
    self showMethodBreakpoints ifFalse:[
        newList := newList reject:[:entry | entry isMethodBreakpoint].
    ].
    self showLineBreakpoints ifFalse:[
        newList := newList reject:[:entry | entry isLineBreakpoint].
    ].
    self showTracepoints ifFalse:[
        newList := newList reject:[:entry | entry isTracepoint].
    ].
    self showAssertions ifFalse:[
        newList := newList reject:[:entry | entry isAssertion].
    ] ifTrue:[
        self showAssertionsInTests ifFalse:[
            newList := newList reject:[:entry | |cls|
                                                entry isAssertion
                                                and:[ (entry selector startsWith:'test')
                                                and:[ (cls := Smalltalk classNamed: entry className) notNil
                                                      and:[ cls theNonMetaclass isTestCaseLike ]]]].
        ].
    ].

    self showHalts ifFalse:[
        newList := newList reject:[:entry | entry isHalt].
    ] ifTrue:[
        showWhichHalt := showWhichHaltsHolder value.
        showWhichHalt ~~ #all ifTrue:[  
            newList := newList reject:[:entry | 
                entry isHalt
                and:[
                    |showInList isIgnored info|

                    entry ignoredInfo:nil.

                    showInList := true.
                    info := Debugger haltIgnoreInformationFor:(entry method) atLineNr:(entry lineNumber).
                    isIgnored := info notNil and:[ info isHaltIgnored ].
                    info notNil ifTrue:[ entry ignoredInfo:info haltIgnoredInfoString ].
                    showWhichHalt == #ignored ifTrue:[
                        showInList := isIgnored.
                    ] ifFalse:[
                        showInList := isIgnored not
                    ].
                    showInList not]
            ].
        ].
    ].

    self showCodeBreakpoints ifFalse:[
        newList := newList reject:[:entry | entry isCodeBreakpoint].
    ] ifTrue:[
        newList := newList reject:[:entry |
                                |flag|

                                flag := (showCodeBreakpointsFor at:(entry arg ? '<nil>') ifAbsentPut:[true asValue]) value.
                                entry isCodeBreakpoint
                                and:[ flag not ]
                           ].
    ].

    shownCopyOfBreakpointList contents:newList.
!

messageSelectors
    ^ self messagesAndTypes collect:[:each | each first] as:Set.
!

update:something with:aParameter from:changedObject
    changedObject == Smalltalk ifTrue:[
        self enqueueDelayedUpdate:something with:aParameter from:changedObject.
        ^ self.
    ].
!

updateBreakpointList
    |newShowCodeBreakpointsFor messages messageSelectors update |

    breakpointList removeAll.
    newShowCodeBreakpointsFor := Dictionary new.

    messages := self messagesAndTypes.
    messageSelectors := self messageSelectors.

    update := [:cls :mthd :sel |
        self
            withBreakpointListEntriesFor:mthd class:cls selector:sel 
            messages:messages
            messageSelectors:messageSelectors
            rememberingCodeBreakpointTypesIn:newShowCodeBreakpointsFor
            do:[:newEntry | breakpointList add:newEntry ].
    ].

    Smalltalk allClassesDo:[:cls |
        cls selectorsAndMethodsDo:[:sel :mthd |
            update value:cls value:mthd value:sel
        ].
        cls class selectorsAndMethodsDo:[:sel :mthd |
            update value:cls class value:mthd value:sel
        ].
    ].

    showCodeBreakpointsFor := newShowCodeBreakpointsFor.
!

updateCode
    |entry method class|

    entry := self selectedBreakpointListEntry.
    entry isNil ifTrue:[
        codeView contents:nil.
        ^ self
    ].
    method := entry method.
    codeView editedMethodOrClass:method.
    method isNil ifTrue:[
        codeView contents:'OOPS - no source found'.
    ] ifFalse:[
        codeView contents:(method source).
        entry lineNumber notNil ifTrue:[
            codeView cursorLine:entry lineNumber col:1.
            codeView selectLine:entry lineNumber.
        ] ifFalse:[
            self breakPoint:#cg.
        ].
        codeView 
            acceptAction:[:newText |
                class := method mclass ? (Smalltalk classNamed:entry className).
                class 
                    compilerClass
                        compile:newText asString
                        forClass:class
                        inCategory:method category
                        notifying:codeView.
            ]
    ].
!

updateEntry:entry
    "after a change, update the list entry.
     (or remove it if required)"

    |mthd cls sel newShowCodeBreakpointsFor any|

    newShowCodeBreakpointsFor := Dictionary new.

    breakpointList remove:entry ifAbsent:[].

    mthd := entry method.
    cls := Smalltalk classNamed:entry className.
    sel := entry selector.

    any := false.    
    self
        withBreakpointListEntriesFor:mthd class:cls selector:sel 
        messages:(self messagesAndTypes)
        messageSelectors:(self messageSelectors)
        rememberingCodeBreakpointTypesIn:newShowCodeBreakpointsFor
        do:[:newEntry |
            any := true.
            breakpointList add:newEntry. 
        ].
!

updateForClass:aClass selector:selector
    |selectionIndexBefore mthd affectedEntries newShowCodeBreakpointsFor|

    selectionIndexBefore := selectionIndexHolder value.    

    affectedEntries := breakpointList select:[:entry |
                            entry selector = selector
                            and:[ entry className = aClass name ]
                       ].
    affectedEntries do:[:eachEntry |
        breakpointList remove:eachEntry ifAbsent:[].
    ].

    mthd := aClass compiledMethodAt:selector.
    mthd notNil ifTrue:[
        newShowCodeBreakpointsFor := Dictionary new.

        self
            withBreakpointListEntriesFor:mthd class:aClass selector:selector 
            messages:(self messagesAndTypes)
            messageSelectors:(self messageSelectors)
            rememberingCodeBreakpointTypesIn:newShowCodeBreakpointsFor
            do:[:newEntry |
                breakpointList add:newEntry. 
            ].
    ].

    self updateShownBreakpointList.
    self selectionIndexHolder value:selectionIndexBefore.
    self updateCode
!

updateList
    updateProcess notNil ifTrue:[^ self ].

    self updatingLabelShown value:true.
    "/ cg: mhmh why is this needed ????
    Delay waitForSeconds:0.1.
    self windowGroup repairDamage.

    updateProcess := 
        [
            [
                ActivityNotification handle:[:ex |
                    self infoHolder value:ex errorString.
                    self windowGroup processExposeEvents.
                    ex proceed.
                ] do:[
                    self updateBreakpointList.
                    self updateShownBreakpointList.
                ]
            ] ensure:[
                updateProcess := nil.
                self updatingLabelShown value:false.
            ].
        ] newProcess.
    updateProcess resume.
!

updateShownBreakpointList

    self shownCopyOfBreakpointList contents:breakpointList.
    self filter.
    self resort.


!

withBreakpointListEntriesFor:mthd class:cls selector:sel 
    messages:messages
    messageSelectors:messageSelectors
    rememberingCodeBreakpointTypesIn:newShowCodeBreakpointsFor
    do:aBlock 

    |entry type messagesSent showWhichHalt|

    showWhichHalt := self showWhichHaltsHolder value.

    mthd isWrapped ifTrue:[
        mthd isBreakpointed ifTrue:[
            type := #trap
        ] ifFalse:[
            mthd isTraced ifTrue:[
                type := #trace
            ] ifFalse:[
                type := #probe
            ].
        ].
        entry := BreakpointListEntry new.
        entry
            type:#wrap
            arg:type
            className:cls name
            selector:sel
            lineNumber:nil
            info:nil
            enabled:true.
        aBlock value:entry 
    ].

    (mthd literalsDetect:[:lit | 
        (messageSelectors includes:lit)
        or:[lit class == Breakpoint]
    ] ifNone:nil) notNil ifTrue:[
        messagesSent := mthd messagesSent.

        messages pairsDo:[:bpSel :type|
            |tree extractor|

            "/ used to be (mthd sends:bpSel);
            "/ however, the sends requires an expensive parse of the methods source
            "/ to fetch all message selectors. This should be done only once,
            "/ and not for every selector we look for)
            (messagesSent includesIdentical:bpSel) ifTrue:[
                tree := RBParser 
                    parseMethod:mthd source
                    onError:[:aString :pos | 
                        ('BreakPointBrowser [info]: error while parsing "%1": %2'
                            bindWith:mthd whoString with:aString) infoPrintCR.
                        nil
                    ].

                tree isNil ifTrue:[
                    entry := BreakpointListEntry new.
                    entry
                        type:type
                        arg:nil
                        className:cls name
                        selector:sel
                        lineNumber:nil
                        info:nil
                        enabled:true.
                    aBlock value:entry 
                ] ifFalse:[
                    extractor := MessageArgumentExtractor new.
                    extractor selectorToSearch:bpSel.
                    extractor 
                        callBack:[:lineNo :argument :infoMessage |
                            |showIt isIgnored|

                            argument notNil ifTrue:[
                                newShowCodeBreakpointsFor
                                    at:argument
                                    put:(showCodeBreakpointsFor
                                            at:argument
                                            ifAbsent:[true asValue])
                            ].
                            entry := BreakpointListEntry new.
                            entry
                                type:type
                                arg:argument
                                className:cls name
                                selector:sel
                                lineNumber:lineNo
                                info:infoMessage
                                enabled:true.

                            aBlock value:entry 
                        ].

                    tree acceptVisitor:extractor.
                ]
            ].
        ].

        mthd isMethodWithBreakpoints ifTrue:[
            mthd breakpointsDo:[:bp | 
                bp isVisible ifTrue:[
                    entry := BreakpointListEntryForLineBreak new.
                    entry
                        type:#line
                        arg:nil
                        className:cls name
                        selector:sel
                        lineNumber:(bp line)
                        info:nil
                        enabled:true.
                    entry breakPoint:bp.
                    aBlock value:entry 
                ]
            ].        
        ]
    ].

    "Modified: / 03-02-2014 / 10:35:14 / cg"
! !

!BreakpointBrowser methodsFor:'initialization & release'!

codeViewClass
    "the type of codeview to use"

    ^ (UserPreferences current useCodeView2In: #Browser)
        ifTrue:[ Tools::CodeView2 ? CodeView ]
        ifFalse:[ CodeView ]
!

initialize
    super initialize.

    showCodeBreakpointsFor := Dictionary new.
    breakpointList := List new.

    currentSortColumn := #type.
    currentSortIsReverse := false.

    Smalltalk addDependent:self.
!

postBuildCodeView:aView
    codeView := aView
!

postOpenWith:aBuilder
    super postOpenWith:aBuilder.

    self enqueueMessage:#updateList for:self arguments:#().

    "Modified: / 18-02-2007 / 12:55:57 / cg"
!

release
    |p|

    (p := updateProcess) notNil ifTrue:[
        updateProcess := nil.
        p terminate
    ].
    Smalltalk removeDependent:self.
    super release
! !

!BreakpointBrowser methodsFor:'menu actions-item'!

browseItem
    self withWaitCursorDo:[
        (self breakpointListEntryAtIndex:self selectionIndexHolder value) browse
    ].
!

reenableHalt
    |entry|

    entry := self breakpointListEntryAtIndex:self selectionIndexHolder value.
    Debugger 
        ignoreHaltIn:(entry method) at:(entry lineNumber) 
        forCount:nil orTimeDuration:nil orUntilShiftKey:false
        orReceiverClass:nil orProcess:nil.
        
    self updateShownBreakpointList

    "Modified: / 27-01-2012 / 11:34:11 / cg"
!

removeItem
    breakpointList remove:(self selectedBreakpointListEntry)

    "Created: / 22-10-2006 / 10:45:52 / cg"
    "Modified: / 18-02-2007 / 12:57:58 / cg"
! !

!BreakpointBrowser methodsFor:'menus-dynamic'!

codeBreakpointMenu
    <resource: #programMenu >

    |breakpointArgs menu|

    breakpointArgs := Set new.
    breakpointList
                        select:[:entry | entry arg notNil]
                        thenDo:[:entry | breakpointArgs add:entry arg].
    (breakpointList contains:[:entry | entry arg isNil]) ifTrue:[
        breakpointArgs add:'<nil>'.
    ].
    breakpointArgs := breakpointArgs asSortedCollection.

    menu := Menu new.
    menu addItem:(
            MenuItem new
                hideMenuOnActivated:false;
                label:'Toggle All'
                itemValue:
                    [
                        showCodeBreakpointsFor do:[:each |
                            each value:(each value not)
                        ]
                    ]).
    menu addSeparator.

    breakpointArgs do:[:arg|
        | menuItem |

        menuItem := MenuItem 
            label:arg
            itemValue:
                [:onOff |
                    (showCodeBreakpointsFor at:arg ifAbsentPut:[true asValue]) value:onOff.
                    self updateShownBreakpointList
                ]
            translateLabel:false.
        menuItem indication:(showCodeBreakpointsFor at:arg ifAbsentPut:[true asValue]).
        menuItem hideMenuOnActivated:false.

        menu addItem:menuItem.
    ].
    menu findGuiResourcesIn:self.
    ^ menu

    "Modified (format): / 09-09-2012 / 13:11:14 / cg"
!

enabledCodeBreakpointMenu
    <resource: #programMenu >

    |breakpointArgs menu enabledCodeBreakpointHolders|

    enabledCodeBreakpointHolders := Dictionary new.

    breakpointArgs := Set new.
    breakpointList
        select:[:entry | entry arg notNil]
        thenDo:[:entry | breakpointArgs add:entry arg].

    (breakpointList contains:[:entry | entry arg isNil]) ifTrue:[
        breakpointArgs add:'<nil>'.
    ].
    breakpointArgs := breakpointArgs asSortedCollection.

    menu := Menu new.
    menu addItem:(
            MenuItem new
                hideMenuOnActivated:false;
                label:'Toggle All'
                itemValue:
                    [
                        enabledCodeBreakpointHolders keysAndValuesDo:[:arg :each |
                            each value:(each value not).
                            each value ifTrue:[
                                Object enableBreakPoint:arg
                            ] ifFalse:[
                                Object disableBreakPoint:arg
                            ].
                        ]
                    ]).
    menu addSeparator.

    breakpointArgs do:[:arg|
        | menuItem |

        menuItem := MenuItem 
                        label:arg
                        itemValue:
                            [:onOff |
                                (enabledCodeBreakpointHolders at:arg ifAbsentPut:[(Object isBreakPointEnabled:arg) asValue]) value:onOff.
                                onOff ifFalse:[
                                    Object disableBreakPoint:arg
                                ] ifTrue:[
                                    Object enableBreakPoint:arg
                                ].
                            ]
                        translateLabel:false.
        menuItem indication:(enabledCodeBreakpointHolders at:arg ifAbsentPut:[ (Object isBreakPointEnabled:arg) asValue ]).
        menuItem hideMenuOnActivated:false.
        menu addItem:menuItem.
    ].
    menu findGuiResourcesIn:self.
    ^ menu

    "Modified: / 09-09-2012 / 13:11:30 / cg"
! !

!BreakpointBrowser methodsFor:'tests'!

aMethodWith_assert
    "only here for demonstration purposes - should be found in the list"

    self assert:(3 > 4)
!

aMethodWith_assert2
    "only here for demonstration purposes - should be found in the breakpoint browser''s list"

    self assert:(3 > 4) message:'well - that ought to work'
!

aMethodWith_breakPoint
    "only here for demonstration purposes - should be found in the breakpoint browser''s list"

    self breakPoint:#cg
!

aMethodWith_breakPoint2
    "only here for demonstration purposes - should be found in the breakpoint browser''s list"

    self breakPoint:#cg info:'hello there'
!

aMethodWith_debugCode
    "only here for demonstration purposes - should be found in the breakpoint browser''s list"

    self 
        debuggingCodeFor:#cg
        is:[
            self bla.
            Transcript show:'some debug prints here'
        ].
!

aMethodWith_halt
    "only here for demonstration purposes - should be found in the breakpoint browser''s list"

    self halt "/ should be highlighted in breakpoint browser

    "after the first halt, in the debugger, ignore this halt for some time and see what
     the breakpoint browser shows...

     10 timesRepeat:[
        self new aMethodWith_halt
     ].
    "
!

aMethodWith_halt2
    "only here for demonstration purposes - should be found in the breakpoint browser''s list"

    self halt:'some message' "/ should be highlighted in breakpoint browser
!

aMethodWith_todo
    "only here for demonstration purposes - should be found in the breakpoint browser''s list"

    self todo
! !

!BreakpointBrowser methodsFor:'user actions'!

browseSelectedItem
    self withWaitCursorDo:[
        (self selectedBreakpointListEntry) browse
    ].

    "Created: / 22-10-2006 / 01:49:13 / cg"
    "Modified: / 18-02-2007 / 12:56:30 / cg"
!

disableLineBreak
    (self selectedBreakpointListEntry) breakPoint disable
!

hideAllTypes
    self setShowAllTypesTo:false
!

itemDoubleClicked:itemIndex
    self browseSelectedItem

    "Created: / 22-10-2006 / 01:49:13 / cg"
    "Modified: / 18-02-2007 / 12:56:30 / cg"
!

openClassFilterDialog
    |nameOrPattern|

    nameOrPattern := Dialog 
                        requestClassName:'Only show breakpoints for class(es) matching (empty to show all):'
                        initialAnswer:(classNameFilter ? '*').
    nameOrPattern isNil ifTrue:[^ self].    "/ cancel
    (nameOrPattern isEmpty or:[nameOrPattern = '*']) ifTrue:[
        classNameFilter := nil.
    ] ifFalse:[    
        classNameFilter := nameOrPattern.
    ].
    self updateShownBreakpointList
!

openDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'tools/misc/TOP.html#BREAKPOINTLIST'.
!

openPackageFilterDialog
    |nameOrPattern|

    nameOrPattern := Dialog 
                        request:'Only show breakpoints for code in package(s) matching (empty to show all):'
                        list:(Smalltalk allPackageIDs)
                        initialAnswer:(packageFilter ? '*').
    nameOrPattern isNil ifTrue:[^ self].    "/ cancel
    (nameOrPattern isEmpty or:[nameOrPattern = '*']) ifTrue:[
        packageFilter := nil.
    ] ifFalse:[    
        packageFilter := nameOrPattern.
    ].
    self updateShownBreakpointList
!

resort
    |sortBlock sortBlock1|

    currentSortColumn isNil ifTrue:[^ self ].

    sortBlock := sortBlock1 := [:a :b |
				    |vA vB|

				    vA := (a perform:currentSortColumn).
				    vB := (b perform:currentSortColumn).
				    vA = vB ifTrue:[
					currentSortColumn == #type ifTrue:[
					    vA := a arg.
					    vB := b arg.
					    vA = vB ifTrue:[
						vA := a className.
						vB := b className.
						vA = vB ifTrue:[
						    vA := a selector.
						    vB := b selector.
						    vA = vB ifTrue:[
							vA := a lineNumber.
							vB := b lineNumber.
						    ]
						]
					    ]
					]
				    ].
				    (vA ? '') < (vB ? '')
			       ].

    currentSortIsReverse ifTrue:[
	sortBlock := [:a :b | (sortBlock1 value:a value:b) not ].
    ].

    "/ temporary hack - should make a copy of the real list
    self shownCopyOfBreakpointList sort:sortBlock

    "Created: / 25-10-2006 / 01:01:26 / cg"
    "Modified: / 18-02-2007 / 13:02:19 / cg"
!

setShowAllTypesTo:aBoolean
    self showAssertions:aBoolean.
    self showHalts:aBoolean.
    self showCodeBreakpoints:aBoolean.
    self showDebugCode:aBoolean.
    self showLineBreakpoints:aBoolean.
    self showMethodBreakpoints:aBoolean.
    self showOthers:aBoolean.
    self showTracepoints:aBoolean.
!

showAllTypes
    self setShowAllTypesTo:true
!

sortBy:instanceName
    self sortBy:instanceName withReverse:true

    "Created: / 25-10-2006 / 00:53:55 / cg"
!

sortBy:instanceName withReverse:aBoolean
    |aSymbol|

    aSymbol := instanceName asSymbol.

    currentSortColumn isNil ifTrue:[
	currentSortColumn := aSymbol.
	currentSortIsReverse := false.
    ] ifFalse:[
	currentSortColumn = aSymbol ifTrue:[
	    "/ same column like before - change sort order ifReverse is true
	    aBoolean ifTrue:[
		currentSortIsReverse := currentSortIsReverse not.
	    ].
	] ifFalse:[
	    "/ another column - remark column
	    currentSortColumn := aSymbol.
	]
    ].
    self resort.

    "Created: / 25-10-2006 / 00:54:59 / cg"
!

toggleAllShownTypes
    self showAssertions:(self showAssertions not).
    self showHalts:(self showHalts not).
    self showCodeBreakpoints:(self showCodeBreakpoints not).
    self showDebugCode:(self showDebugCode not).
    self showLineBreakpoints:(self showLineBreakpoints not).
    self showMethodBreakpoints:(self showMethodBreakpoints not).
    self showOthers:(self showOthers not).
    self showTracepoints:(self showTracepoints not).
! !

!BreakpointBrowser::BreakpointListEntry methodsFor:'accessing'!

arg
    ^ arg
!

className
    ^ className
!

enabled
    ^ enabled
!

ignoredInfo
    ^ ignoredInfo
!

ignoredInfo:something
    ignoredInfo := something.
!

info
    ^ ignoredInfo ? info
!

isIgnored
    type == #halt ifTrue:[
        ^ (Debugger haltIgnoreInformationFor:self method atLineNr:lineNumber) notNil
    ].
    ^ false
!

isIgnoredString
    self isIgnored ifTrue:[^ 'Yes'].
    ^ ''
!

lineNumber
    ^ lineNumber
!

selector
    ^ selector
!

type
    ^ type
!

type:typeArg arg:argArg className:classNameArg selector:selectorArg lineNumber:lineNumberArg info:infoArg enabled:enabledArg
    type := typeArg.
    arg := argArg.
    className := classNameArg.
    selector := selectorArg.
    lineNumber := lineNumberArg.
    info := infoArg.
    enabled := enabledArg.
!

typeString
"/ loks ugly
"/    self isIgnored ifTrue:[
"/        ^ type asText allStrikedOut
"/    ].
    ^ type
! !

!BreakpointBrowser::BreakpointListEntry methodsFor:'actions'!

browse
    |browser|

    browser := UserPreferences systemBrowserClass
        openInClass:(Smalltalk classNamed:className) selector:selector.

    lineNumber notNil ifTrue:[
        browser codeView 
            cursorLine:lineNumber col:1;
            selectLine:lineNumber.
    ].
!

method
    ^ (Smalltalk classNamed:className) compiledMethodAt:selector.
! !

!BreakpointBrowser::BreakpointListEntry methodsFor:'queries'!

relatedToClass:aClassNamePattern
    className isNil ifTrue:[^ true].
    (aClassNamePattern includesMatchCharacters) ifTrue:[
         ^ aClassNamePattern match: className
    ].
    ^ className startsWith:aClassNamePattern
!

relatedToPackage:aPackagePattern
    |mthd package|

    (mthd := self method) isNil ifTrue:[^ false].
    package := mthd package.
    (aPackagePattern includesMatchCharacters) ifTrue:[
         ^ aPackagePattern match: package
    ].
    ^ package startsWith:aPackagePattern
! !

!BreakpointBrowser::BreakpointListEntry methodsFor:'testing'!

isAssertion

    ^ type == #assertion
!

isCodeBreakpoint
    ^ type == #breakPoint
!

isDebugCode
    ^ type == #debugCode
!

isHalt
    ^ type == #halt
!

isLineBreakpoint
    ^ type == #line
!

isMethodBreakpoint
    ^ type == #wrap
!

isOther
    ^ type == #other
!

isTodo
    ^ type == #todo
!

isTracepoint
    ^ type == #tracepoint
! !

!BreakpointBrowser::BreakpointListEntryForLineBreak methodsFor:'accessing'!

breakPoint
    "return the BreakPoint-instance"

    ^ breakPoint
!

breakPoint:something
    breakPoint := something.
! !

!BreakpointBrowser::MessageArgumentExtractor methodsFor:'accessing'!

callBack:something
    callBack := something.
!

selectorToSearch:something
    selectorToSearch := something.
! !

!BreakpointBrowser::MessageArgumentExtractor methodsFor:'visiting'!

acceptMessageNode: aMessageNode
    |arg1Node arg1 arg2Node arg2 argument infoMessage|

    aMessageNode selector == selectorToSearch ifTrue:[
        aMessageNode arguments size > 0 ifTrue:[
            arg1Node := aMessageNode arguments first.
            arg1Node isLiteral ifTrue:[
                arg1 := arg1Node value.
            ] ifFalse:[
                arg1 := '(...)'.
            ].
            aMessageNode arguments size > 1 ifTrue:[
                arg2Node := aMessageNode arguments second.
                arg2Node isLiteral ifTrue:[
                    arg2 := arg2Node value.
                ] ifFalse:[
                    arg2 := '(...)'.
                ].
            ].
        ].

        selectorToSearch == #halt: ifTrue:[
            infoMessage := arg1.
        ].
        selectorToSearch == #todo: ifTrue:[
            infoMessage := arg1.
        ].
        selectorToSearch == #breakPoint: ifTrue:[
            argument := arg1.
        ].
        selectorToSearch == #breakPoint:info: ifTrue:[
            argument := arg1.
            infoMessage := arg2.
        ].
        selectorToSearch == #debuggingCodeFor:is: ifTrue:[
            argument := arg1.
        ].
        selectorToSearch == #tracePoint: ifTrue:[
            argument := arg1.
        ].
        selectorToSearch == #tracePoint:info: ifTrue:[
            argument := arg1.
            infoMessage := arg2.
        ].
        selectorToSearch == #assert: ifTrue:[
        ].
        selectorToSearch == #assert:message: ifTrue:[
            infoMessage := arg2.
        ].

        callBack
            value:aMessageNode firstLineNumber
            value:argument
            value:infoMessage
    ].
    super acceptMessageNode: aMessageNode
! !

!BreakpointBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

