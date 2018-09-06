"
 COPYRIGHT (c) 2001 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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

MultiViewToolApplication subclass:#WorkspaceApplication
	instanceVariableNames:'autoDefineVariables syntaxHolder poolsConsideredInDoIts
		smalltalkMenuEnabledHolder clipBoardWatcherProcess
		fetchClipboardLines cursorLineHolder cursorColHolder
		modeLabelHolder toolBarView namespaceHolder
		canChangeLanguageHolder cursorLineAndColumnInfoHolder
		cursorLineAndColumnLabelHolder'
	classVariableNames:'LastFilterBlockString LastProcessingBlockString
		LastGeneratorBlockString LastTeaWaitTime DefaultToolBarVisible
		ClipBoardFetchingInstance LastLanguage MyWorkspaceOpened
		LastNamespace LastSnippetFilename'
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!WorkspaceApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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
    A simple wrapper around a WorkSpace-View, adding a pullDown menu.

    [author:]
        Claus Gittinger
"
! !

!WorkspaceApplication class methodsFor:'defaults'!

default
    "a place where the default workspaceApplication could be hooked in;
     see SystemBrowser default and FileBrowser default on the intention..."

    ^ self
!

defaultEditToolbarVisible
    ^ UserPreferences current editToolbarVisibleInWorkspace

    "Created: / 14-07-2007 / 16:42:50 / cg"
!

defaultInfoVisible
    ^ UserPreferences current infoVisibleInWorkspace

    "Created: / 14-07-2007 / 16:43:21 / cg"
!

defaultMyWorkspaceDotWspFile
    |stxFolder f |

    stxFolder := Filename homeDirectory / '.smalltalk'. 
    f := stxFolder / 'MyWorkspace.wsp'.
    f exists ifFalse:[
        stxFolder makeDirectory.

        f writingFileDo:[:s|
            'MyWorkspace.wsp' asFilename exists ifTrue:[
                s nextPutAll:('MyWorkspace.wsp' asFilename contentsAsString)   
            ] ifFalse:[
                s nextPutLine: '"This is your personal workspace..."'.
                s nextPutLine: '"Edit and save as  ', f pathName , '"'.

                'MyWorkspaceSample.wsp' asFilename exists ifTrue:[
                    s nextPutAll:('MyWorkspaceSample.wsp' asFilename contentsAsString)   
                ]
            ].
            s syncData.
        ].
    ].
    ^f

    "Created: / 21-06-2011 / 08:45:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-07-2011 / 13:08:30 / Administrator"
    "Modified: / 10-08-2011 / 21:40:31 / cg"
!

defaultToolbarVisible
    ^ UserPreferences current toolbarVisibleInWorkspace

    "Created: / 14-07-2007 / 16:42:50 / cg"
!

filterTemplate
    ^
'"/ general text filter;
"/ the following block should evaluate to true for all lines
"/ you want to KEEP.
"/ Lines for which the block returns false, will be removed.
"/ Beginner warning: Smalltalk know-how is useful here.

[:line :lineNr :previousLine :nextLine|
     "/ any condition on line.
     "/ Notice, that line might be a Text object (i.e. non-string),
     "/ so you may want to use ''line string''.
     "/ 
     "/ Useful queries on the line are:
     "/     - size                   the length of the line
     "/     - hasChangeOfEmphasis    any bold, italic etc.
     "/     - startsWith:someString
     "/     - endsWith:someString
     "/     - includesString:someString
     "/     - pattern match: 

     "/ example filters
     "/
     "/ -------- removes all empty lines ---------------
     "/
     "/ line size > 0

     "/ -------- removes all lines which do not end with some suffix ----------
     "/
     "/ (line asLowercase endsWith:''foo'') not

     "/ -------- removes duplicates ----------
     "/
     "/ (line = nextLine) not

     "/ -------- keep lines which start with some suffix ----------
     "/
     "/ (line asLowercase startsWith:''foo'') 

     "/ -------- keep lines which include some substring ----------
     "/
     "/ (line asLowercase includesString:''foo'') 

     "/ dummy filter (keeps all lines)
     "/
     true
]
'.
!

generatorTemplate
    ^
'"/ general text generator;
"/ the following block is called with a write stream argument
"/ and the generated text is inserted at the current cursor position
"/ or replaces the current selection.
"/ Beginner warning: Smalltalk know-how is useful here.

[:outputStream :selectedText |
     "/ example generators

     "/ -------- generates N empty lines ---------------
     "/
"/     |n|
"/     n := Dialog requestNumber:''how many empty lines:''.
"/     n timesRepeat:[ outputStream nextPutLine:'''' ].

     "/ -------- generates a table of binary numbers
     "/
"/     |n|
"/     n := Dialog requestNumber:''how many numbers:''.
"/     1 to:n do:[:i | outputStream nextPutLine:(i raisedTo:i) printString ].
]
'
!

textProcessorTemplate
    ^
'"/ general text processor;
"/ the following block should evaluate to a new line, 
"/ given the original line as argument.
"/ Beginner warning: Smalltalk know-how is useful here.

[:line |
     "/ any processing on line.
     "/ Notice, that line might be a Text object (i.e. non-string),
     "/ 
     "/ Useful operations on the line are:
     "/     - '' .... '' ,                      concatenation of any prefix/suffix
     "/     - leftPaddedTo:size                 padding
     "/     - rightPaddedTo:size                padding
     "/     - copyTo:(size min:N)               
     "/     - asUppercase 
     "/     - asLowercase
     "/     - withoutSeparators                 remove whiteSpace
     "/     - asCollectionOfWords               words

     "/ makes everything bold
     "/
     "/ line allBold

     "/ first word only
     "/
     "/ line withoutSeparators asCollectionOfWords first

     "/ dummy filter (keeps all lines as-is)
     "/
     line
]
'
!

webServiceLinkName
    ^ '/workspace'
! !

!WorkspaceApplication class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#editCopy
'Copy the selected text to the clipboard'

#editCut
'Cut the selected text to the clipboard'

#editDelete
'Delete the selected text'

#addTerminal
'Add a tab with an embedded console-terminal'

#addTerminalWindows
'Add a tab with an embedded console-terminal (windows users: ignore the no-echo bug, please)'

#lineAndColumnLabel
'The text-cursor''s line and column number'

#columnLabel
'The text-cursor''s column number'

#lineLabel
'The text-cursor''s line number. Double-click to change'

#modeLabel
'The editing mode (insert vs. overwrite). Right-click to change'

#editRedo
'Redo'

#doIndent
'Indent (shift right)'

#doUndent
'Undent (shift left)'

#languageSelection
'Syntax for doits, syntax checks and coloring. Right-click for menu to change'

#namespaceSelection
'Namespace for doits. Right-click for menu to change'

#menuSave
'Save the page''s contents in the original file'

#menuSaveAs
'Ask for a file and save the page''s contents there'

#snippedPaste
'Paste the selected snippet''s text into the text'

#snippedDefine
'Add the above definition to the list of snippets'

#snippedRemove
'Remove the above selected snippet from the list of snippets'

#snippedKey
'The key of the snippet. This is the abbreviation you will have to type before pressing Shift-Space'

#snippedList
'The list of defined snippets.'

#snippedText
'The text of the snippet. This is the text that will be inserted when pressing Shift-Space'

)

    "Modified: / 08-07-2011 / 08:29:51 / cg"
! !

!WorkspaceApplication class methodsFor:'interface specs'!

manageSnippetsDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:WorkspaceApplication andSelector:#manageSnippetsDialogSpec
     WorkspaceApplication new openInterface:#manageSnippetsDialogSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: manageSnippetsDialogSpec
       window: 
      (WindowSpec
         label: 'Manage Snippets'
         name: 'Manage Snippets'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 379 590)
         menu: manageSnippetDialogMenuSpec
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Snippet:'
             name: 'Label1'
             layout: (LayoutFrame 0 0 0 0 0 1 30 0)
             translateLabel: true
             adjust: left
           )
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0 30 0 0 1 -80 1)
             component: 
            (SpecCollection
               collection: (
                (SequenceViewSpec
                   name: 'List1'
                   activeHelpKey: snippedList
                   model: selectedSnippet
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   useIndex: true
                   sequenceList: listOfSnippets
                 )
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (TextEditorSpec
                         name: 'TextEditor1'
                         layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                         activeHelpKey: snippedText
                         model: selectedSnippetsText
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         acceptChannel: snippetTextAcceptHolder
                         modifiedChannel: snippetTextModified
                         hasKeyboardFocusInitially: false
                         viewClassName: ''
                       )
                      (LabelSpec
                         label: 'Snippet Key:'
                         name: 'Label2'
                         layout: (LayoutFrame 0 0 2 0 100 0 28 0)
                         translateLabel: true
                         adjust: left
                       )
                      (InputFieldSpec
                         name: 'EntryField1'
                         layout: (LayoutFrame 100 0.0 2 0 0 1.0 28 0)
                         activeHelpKey: snippedKey
                         model: selectedSnippetsKeyHolder
                         immediateAccept: true
                         acceptOnReturn: true
                         acceptOnTab: true
                         acceptOnPointerLeave: true
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          (HorizontalPanelViewSpec
             name: 'ButtonPanel'
             layout: (LayoutFrame 0 0 -70 1 0 1 -40 1)
             horizontalLayout: center
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Define'
                   name: 'DefineButton'
                   activeHelpKey: snippedDefine
                   translateLabel: true
                   model: defineSelectedSnippet
                   enableChannel: defineEnabled
                   extent: (Point 125 22)
                 )
                (ActionButtonSpec
                   label: 'Remove'
                   name: 'RemoveButton'
                   activeHelpKey: snippedRemove
                   translateLabel: true
                   model: removeSelectedSnippet
                   enableChannel: removeEnabled
                   extent: (Point 125 22)
                 )
                (ActionButtonSpec
                   label: 'Paste'
                   name: 'PasteButton'
                   activeHelpKey: snippedPaste
                   translateLabel: true
                   model: pasteSelectedSnippet
                   enableChannel: pasteEnabled
                   extent: (Point 125 22)
                 )
                )
              
             )
           )
          (DividerSpec
             name: 'Separator1'
             layout: (LayoutFrame 0 0.0 557 0 0 1.0 561 0)
           )
          (HorizontalPanelViewSpec
             name: 'CloseButtonPanel'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             horizontalLayout: fitSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Close'
                   name: 'Button1'
                   translateLabel: true
                   model: cancel
                   extent: (Point 373 22)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

toolBarSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:WorkspaceApplication andSelector:#toolBarSpec
     WorkspaceApplication new openInterface:#toolBarSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: toolBarSpec
        window: 
       (WindowSpec
          label: 'Toolbar'
          name: 'Toolbar'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 728 48)
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'ToolBarMenu'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              level: 0
              visibilityChannel: toolBarVisibleHolder
              menu: toolBarMenu
              textDefault: true
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
     UIPainter new openOnClass:WorkspaceApplication andSelector:#windowSpec
     WorkspaceApplication new openInterface:#windowSpec
     WorkspaceApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Workspace'
         name: 'Workspace'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 640 480)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'ToolBar'
             layout: (LayoutFrame 0 0 0 0 0 1 32 0)
             level: #'application.toolbarLevel'
             visibilityChannel: toolBarVisibleHolder
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'hideToolBarIcon'
                   name: 'HideToolBarButton'
                   layout: (LayoutFrame 0 0 0 0 13 0 0 1)
                   activeHelpKey: hideToolBar
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: hideToolbar
                   postBuildCallback: hideToolBarButtonCreated:
                 )
                (NonScrollableArbitraryComponentSpec
                   name: 'ToolBarView'
                   layout: (LayoutFrame 13 0.0 0 0.0 0 1.0 0 1.0)
                   visibilityChannel: toolBarVisibleHolder
                   component: toolBarView
                 )
                )
              
             )
           )
          (ViewSpec
             name: 'EditToolBar'
             layout: (LayoutFrame 0 0 32 0 0 1 64 0)
             visibilityChannel: editToolBarVisibleHolder
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'hideToolBarIcon'
                   name: 'HideEditToolBarButton'
                   layout: (LayoutFrame 0 0 0 0 13 0 0 1)
                   activeHelpKey: hideEditToolBar
                   hasCharacterOrientedLabel: false
                   translateLabel: true
                   model: hideEditToolbar
                   postBuildCallback: hideToolBarButtonCreated:
                 )
                (MenuPanelSpec
                   name: 'EditToolBar1'
                   layout: (LayoutFrame 13 0.0 0 0.0 0 1.0 0 1.0)
                   visibilityChannel: editToolBarVisibleHolder
                   menu: editToolBarMenu
                   textDefault: true
                 )
                )
              
             )
           )
          (NoteBookViewSpec
             name: 'NoteBook'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -26 1.0)
             model: selectedWorkspaceIndexHolder
             menu: tabList
             useIndex: true
             accessTabMenuAction: tabMenuAt:
             translateLabel: true
             destroyTabAction: destroyTab:
             canvas: workspaceHolder
             canvasInset: 0
             keepCanvasAlive: true
             tabLevel: 1
           )
          (UISubSpecification
             name: 'infoBarSubSpec'
             layout: (LayoutFrame 0 0.0 -26 1 -16 1.0 0 1.0)
             level: #'infobar.level'
             visibilityChannel: infoVisibleHolder
             majorKey: WorkspaceApplication
             minorKey: windowSpecForInfoBar
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
!

windowSpecForInfoBar
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:WorkspaceApplication andSelector:#windowSpecForInfoBar
     WorkspaceApplication new openInterface:#windowSpecForInfoBar
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpecForInfoBar
       window: 
      (WindowSpec
         label: 'Info Bar'
         name: 'Info Bar'
         bounds: (Rectangle 0 0 473 30)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'infoView'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   name: 'infoLabel'
                   layout: (LayoutFrame 0 0.0 0 0.0 -220 1.0 0 1.0)
                   level: -1
                   translateLabel: true
                   labelChannel: infoLabelHolder
                   resizeForLabel: false
                   adjust: left
                 )
                (LabelSpec
                   name: 'namespaceInfoLabelHolder'
                   layout: (LayoutFrame -220 1.0 0 0.0 -136 1.0 0 1.0)
                   activeHelpKey: namespaceSelection
                   level: -1
                   translateLabel: true
                   labelChannel: namespaceInfoLabelHolder
                   resizeForLabel: false
                   adjust: left
                   menu: namespaceInfoLabelMenuHolder
                 )
                (LabelSpec
                   name: 'LanguageLabel'
                   layout: (LayoutFrame -136 1.0 0 0.0 -65 1.0 0 1.0)
                   activeHelpKey: languageSelection
                   level: -1
                   translateLabel: true
                   labelChannel: languageInfoLabelHolder
                   resizeForLabel: false
                   adjust: left
                   menu: languageInfoLabelMenu
                 )
                (LabelSpec
                   name: 'ModeLabel'
                   layout: (LayoutFrame -65 1 0 0.0 -50 1 0 1.0)
                   activeHelpKey: modeLabel
                   level: -1
                   translateLabel: true
                   labelChannel: modeLabelHolder
                   postBuildCallback: postBuildEditModeInfoLabel:
                 )
                (LabelSpec
                   name: 'CursorLineAndColLabel'
                   layout: (LayoutFrame -50 1 0 0.0 0 1 0 1.0)
                   activeHelpKey: lineAndColumnLabel
                   level: -1
                   labelChannel: cursorLineAndColumnLabelHolder
                   adjust: left
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!WorkspaceApplication class methodsFor:'menu specs'!

bufferAddMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#bufferAddMenuSlice
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication bufferAddMenuSlice)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Terminal'
	    itemValue: addTerminal
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Web Browser'
	    itemValue: addWebBrowser
	    translateLabel: true
	    isVisible: isWebBrowserAvailable
	  )
	 (MenuItem
	    enabled: isSQLWorkspaceAvailable
	    label: 'SQL Workspace'
	    itemValue: addSQLWorkspace
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Tea Timer'
	    itemValue: addTeaTimer
	    translateLabel: true
	  )
	 (MenuItem
            label: 'Stopwatch'
	    itemValue: addStopWatch
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
!

bufferMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#bufferMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication bufferMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Add Buffer'
            itemValue: addWorkspace
            translateLabel: true
            shortcutKey: Ctrlt
          )
         (MenuItem
            label: '-'
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: 'Add Buffer on MyWorkspace'
            itemValue: addMyWorkspace
            translateLabel: true
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            enabled: anyWorkspaceVariableIsDefined
            label: 'Add Buffer on Workspace Variables'
            itemValue: addWorkspaceVariableInspector
            translateLabel: true
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: 'Add Buffer on Global Variables'
            itemValue: addGlobalVariableInspector
            translateLabel: true
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: 'Add Buffer on Namespace...'
            itemValue: addNamespaceInspector
            translateLabel: true
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: 'Add Buffer on SharedPool...'
            itemValue: addSharedPoolInspector
            translateLabel: true
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: 'Add Buffer on Class Variables'
            itemValue: addClassVariableInspector
            translateLabel: true
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: '-'
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: 'Add Evaluation Buffer'
            itemValue: addEvaluationWorkspace
            translateLabel: true
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Menu Slice'
            translateLabel: true
            submenuChannel: bufferAddMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Rename...'
            itemValue: renameWorkspace
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canRemoveWorkspace
            label: 'Remove Buffer'
            itemValue: removeWorkspace
            translateLabel: true
          )
         )
        nil
        nil
      )
!

editMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#editMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication editMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'Cut'
            itemValue: cutSelection
            shortcutKey: Cut
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'Copy'
            itemValue: copySelection
            shortcutKey: Copy
          )
         (MenuItem
            label: 'Paste'
            itemValue: paste
            shortcutKey: Paste
          )
         (MenuItem
            enabled: hasHistory
            label: 'Paste Last'
            itemValue: pasteLastDoIt
            isVisible: thisIsASmalltalkWorkspace
            submenuChannel: pasteRecentDoItMenu
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'Copy as Snippet...'
            itemValue: addSelectionToSnippets
          )
         (MenuItem
            enabled: selectedWorkspaceIsTextView
            label: 'Paste Snippet...'
            itemValue: pasteSnippet
          )
         (MenuItem
            enabled: selectedWorkspaceIsTextView
            label: 'Manage Snippets...'
            itemValue: manageSnippets
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Select All'
            itemValue: selectAll
          )
         (MenuItem
            label: '-'
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            enabled: selectedWorkspaceIsTextView
            label: 'Filter Text...'
            itemValue: filterText
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            enabled: selectedWorkspaceIsTextView
            label: 'Process Text...'
            itemValue: processText
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: 'Generate Text...'
            itemValue: generateText
          )
         (MenuItem
            label: 'Compare Text Against...'
            itemValue: compareTextAgainst
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Services'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Autofetch Selection'
                  itemValue: autoFetchSelection:
                  hideMenuOnActivated: false
                  indication: autoFetchSelection
                )
               (MenuItem
                  enabled: autoFetchSelection
                  label: 'Insert as Line (Append CR)'
                  hideMenuOnActivated: false
                  indication: autoFetchSelectionLines
                )
               (MenuItem
                  label: '-'
                  isVisible: thisIsASmalltalkWorkspace
                )
               (MenuItem
                  enabled: hasSelectionInActiveWorkspace
                  label: 'Google Spell'
                  itemValue: googleSpellingSuggestion
                  isVisible: thisIsASmalltalkWorkspace
                )
               (MenuItem
                  enabled: hasSelectionInActiveWorkspace
                  label: 'Translate (babelFish)'
                  isVisible: thisIsASmalltalkWorkspace
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasSelectionInActiveWorkspace
                        label: 'English -> German'
                        itemValue: babelFishTranslate:
                        argument: 'en_de'
                      )
                     (MenuItem
                        enabled: hasSelectionInActiveWorkspace
                        label: 'English -> French'
                        itemValue: babelFishTranslate:
                        argument: 'en_fr'
                      )
                     (MenuItem
                        enabled: hasSelectionInActiveWorkspace
                        label: 'English -> Spanish'
                        itemValue: babelFishTranslate:
                        argument: 'en_es'
                      )
                     (MenuItem
                        enabled: hasSelectionInActiveWorkspace
                        label: 'English -> Portuguese'
                        itemValue: babelFishTranslate:
                        argument: 'en_pt'
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasSelectionInActiveWorkspace
                        label: 'German -> English'
                        itemValue: babelFishTranslate:
                        argument: 'de_en'
                      )
                     (MenuItem
                        enabled: hasSelectionInActiveWorkspace
                        label: 'French -> English'
                        itemValue: babelFishTranslate:
                        argument: 'fr_en'
                      )
                     (MenuItem
                        enabled: hasSelectionInActiveWorkspace
                        label: 'Spanish -> English'
                        itemValue: babelFishTranslate:
                        argument: 'es_en'
                      )
                     (MenuItem
                        enabled: hasSelectionInActiveWorkspace
                        label: 'Portuguese -> English'
                        itemValue: babelFishTranslate:
                        argument: 'pt_en'
                      )
                     (MenuItem
                        enabled: hasSelectionInActiveWorkspace
                        label: 'Russian -> English'
                        itemValue: babelFishTranslate:
                        argument: 'ru_en'
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
         )
        nil
        nil
      )
!

editModeInfoLabelMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::NewSystemBrowser andSelector:#editModeInfoLabelMenu
     (Menu new fromLiteralArrayEncoding:(Tools::NewSystemBrowser editModeInfoLabelMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Insert'
            itemValue: editModeInsert
            translateLabel: true
          )
         (MenuItem
            label: 'Overwrite'
            itemValue: editModeOverwrite
            translateLabel: true
          )
         (MenuItem
            label: 'Insert Selecting'
            itemValue: editModeInsertAndSelect
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Created: / 22-01-2011 / 11:50:05 / cg"
!

editToolBarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#editToolBarMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication editToolBarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: editCut
            label: 'Cut'
            itemValue: cutSelection
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary cut16x16Icon)
            isButton: true
          )
         (MenuItem
            activeHelpKey: editCopy
            label: 'Copy'
            itemValue: copySelection
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary copy16x16Icon)
            isButton: true
          )
         (MenuItem
            activeHelpKey: editPaste
            label: 'Paste'
            itemValue: paste
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary paste16x16Icon)
            isButton: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editUndo
            label: 'Undo'
            itemValue: undo
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary undo16x16Icon)
            isButton: true
          )
         (MenuItem
            activeHelpKey: editRedo
            label: 'Redo'
            itemValue: redo
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary redo16x16Icon)
            isButton: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editSearch
            label: 'Search'
            itemValue: search
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary search16x16Icon)
            isButton: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: doUndent
            label: 'Undent'
            itemValue: undent
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary undent16x16Icon)
          )
         (MenuItem
            activeHelpKey: doIndent
            label: 'Indent'
            itemValue: indent
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary indent16x16Icon)
          )
         )
        nil
        nil
      )
!

executionMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#executionMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication executionMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasHistory
            label: 'Redo Last'
            itemValue: redoLastDoIt
            submenuChannel: redoRecentDoItMenu
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'DoIt'
            itemValue: doIt
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspaceAndEditorIsNotReadonly
            label: 'PrintIt'
            itemValue: printIt
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'InspectIt'
            itemValue: inspectIt
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'TimeIt'
            itemValue: timeIt
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'SpyOnIt (Transcript)'
            itemValue: spyOnIt
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'ProfileIt (Visual)'
            itemValue: profileIt
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'Browse Class'
            itemValue: browseIt
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'Browse Implementors of It'
            itemValue: browseImplementorsOfIt
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'Browse References to It'
            itemValue: browseReferencesToIt
          )
         )
        nil
        nil
      )
!

fileMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#fileMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication fileMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: 'Connect...'
            itemValue: menuSQLConnect
            translateLabel: true
            isVisible: isSQLWorkspaceSelected
          )
         (MenuItem
            label: '-'
            isVisible: isSQLWorkspaceSelected
          )
         (MenuItem
            label: 'New Workspace'
            itemValue: newWorkspace
            translateLabel: true
            shortcutKey: Ctrln
          )
         (MenuItem
            label: 'New Tab'
            itemValue: addWorkspace
            translateLabel: true
            isVisible: false
            shortcutKey: Ctrlt
          )
         (MenuItem
            label: 'New SystemWorkspace'
            itemValue: newSystemWorkspace
            translateLabel: true
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: 'New EvaluationWorkspace'
            itemValue: newEvaluationWorkspace
            translateLabel: true
            isVisible: thisIsASmalltalkWorkspace
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Open File...'
            itemValue: menuLoad
            translateLabel: true
            shortcutKey: Ctrlo
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Save'
            itemValue: menuSave
            translateLabel: true
            shortcutKey: Ctrls
          )
         (MenuItem
            label: 'Save As...'
            itemValue: menuSaveAs
            translateLabel: true
            shortcutKey: SaveAs
          )
         (MenuItem
            enabled: hasMultipleBuffersHolder
            label: 'Save all As...'
            itemValue: menuSaveAllAs
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasTextInActiveWorkspace
            label: 'Print...'
            itemValue: menuPrint
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
!

helpMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#helpMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication helpMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Workspace Documentation'
            itemValue: openDocumentation
          )
         (MenuItem
            label: 'Editing Text'
            itemValue: openEditingDocumentation
          )
         (MenuItem
            label: 'Documentation on Smalltalk/X'
            itemValue: openSTXDocumentation
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
!

languageInfoLabelMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#workspaceMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication workspaceMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
                    (
                     (MenuItem
                        label: 'Language List Slice'
                        translateLabel: true
                        submenuChannel: languageListMenuSlice
                        isMenuSlice: true
                      )
                     )
                    nil
                    nil
                  )

    "Created: / 24-12-2010 / 02:03:59 / cg"
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenuChannel: fileMenu
          )
         (MenuItem
            label: 'Buffers'
            submenuChannel: bufferMenu
          )
         (MenuItem
            label: 'Edit'
            submenuChannel: editMenu
          )
         (MenuItem
            label: 'View'
            submenuChannel: viewMenu
          )
         (MenuItem
            label: 'Bookmarks'
            submenuChannel: bookmarkMenu
          )
         (MenuItem
            label: 'Execute'
            isVisible: executeMenuVisible
            submenuChannel: executionMenu
          )
         (MenuItem
            label: 'Workspace'
            isVisible: thisIsASmalltalkWorkspace
            submenuChannel: workspaceMenu
          )
         (MenuItem
            enabled: smalltalkMenuEnabledHolder
            label: 'Smalltalk'
            isVisible: thisIsASmalltalkWorkspace
            submenuChannel: smalltalkMenu
          )
         (MenuItem
            label: 'MENU_Help'
            submenuChannel: helpMenu
          )
         )
        nil
        nil
      )
!

manageSnippetDialogMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#manageSnippetDialogMenuSpec
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication manageSnippetDialogMenuSpec)) startUp
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
                  label: 'Open Snippet File...'
                  itemValue: menuOpenSnippetFile
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Save As Snipped File...'
                  itemValue: menuSaveSnippetFileAs
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Close'
                  itemValue: closeSnippetDialog
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
                  itemValue: openSnippetDocumentation
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

smalltalkMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#smalltalkMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication smalltalkMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'FileIn Text'
            itemValue: fileInText
            translateLabel: true
          )
         (MenuItem
            enabled: hasSelectionInActiveWorkspace
            label: 'ChangeList on Text'
            itemValue: changesBrowserOnText
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: selectedWorkspaceIsTextView
            label: 'Add Global Variable...'
            itemValue: addGlobalVariable
            translateLabel: true
          )
         (MenuItem
            enabled: selectedWorkspaceIsTextView
            label: 'Remove Global Variable...'
            itemValue: removeGlobalVariable
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: selectedWorkspaceIsTextView
            label: 'Add SharedPool...'
            itemValue: addSharedPool
            translateLabel: true
          )
         (MenuItem
            enabled: selectedWorkspaceIsTextView
            label: 'Remove SharedPool...'
            itemValue: removeSharedPool
            translateLabel: true
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
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#toolBarMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication toolBarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: ''
          )
         (MenuItem
            label: 'Add Buffer'
            itemValue: addWorkspace
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary addBufferIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: menuSaveOrSaveAs
            label: 'Save Text'
            itemValue: menuSave
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary saveToFileIcon)
          )
         (MenuItem
            label: '-'
            isVisible: doItMenuButtonVisible
          )
         (MenuItem
            activeHelpKey: #'help_doIt'
            label: 'DoIt'
            itemValue: doIt
            isButton: true
            isVisible: doItMenuButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary doItIcon)
          )
         (MenuItem
            activeHelpKey: #'help_printIt'
            label: 'PrintIt'
            itemValue: printIt
            isButton: true
            isVisible: printItMenuButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary printItIcon)
          )
         (MenuItem
            activeHelpKey: #'help_inspectIt'
            label: 'InspectIt'
            itemValue: inspectIt
            isButton: true
            isVisible: inspectItMenuButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary inspectItIcon)
          )
         (MenuItem
            activeHelpKey: #'help_browseIt'
            label: 'BrowseIt'
            itemValue: browseIt
            isButton: true
            isVisible: browseItMenuButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary browseItIcon)
          )
         (MenuItem
            activeHelpKey: #'help_profileIt'
            label: 'ProfileIt'
            itemValue: profileIt
            isButton: true
            isVisible: profileItMenuButtonVisible
            labelImage: (ResourceRetriever ToolbarIconLibrary profileItIcon)
          )
         (MenuItem
            activeHelpKey: addTerminal
            label: 'Web Browser'
            itemValue: addWebBrowser
            isButton: true
            startGroup: right
            isVisible: isWebBrowserAvailable
            labelImage: (ResourceRetriever ToolbarIconLibrary webKit22x22)
          )
         (MenuItem
            activeHelpKey: addTerminal
            label: 'Terminal'
            itemValue: addTerminal
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary shellTerminalIcon)
          )
         )
        nil
        nil
      )
!

workspaceMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#workspaceMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication workspaceMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Language List Slice'
            submenuChannel: languageListMenuSlice
            isMenuSlice: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Namespace for DoIt'
            submenuChannel: namespaceInfoLabelMenuHolder
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: selectedWorkspaceIsTextView
            label: 'Add Workspace Variable...'
            itemValue: addWorkspaceVariable
          )
         (MenuItem
            enabled: anyWorkspaceVariableIsDefined
            label: 'Remove Workspace Variable...'
            itemValue: removeWorkspaceVariable
          )
         (MenuItem
            enabled: anyWorkspaceVariableIsDefined
            label: 'Remove all Workspace Variables...'
            itemValue: removeAllWorkspaceVariables
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: anyWorkspaceVariableIsDefined
            label: 'Inspect Workspace Variables'
            itemValue: inspectWorkspaceVariables
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Autodefine Variables'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'As Workspace Variable'
                  hideMenuOnActivated: false
                  choice: autoDefineVariables
                  choiceValue: workspace
                )
               (MenuItem
                  label: 'As DoIt Variable'
                  hideMenuOnActivated: false
                  choice: autoDefineVariables
                  choiceValue: doIt
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Do not Autodefine'
                  hideMenuOnActivated: false
                  choice: autoDefineVariables
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
            label: 'Terminate Processes Forked Here'
            itemValue: terminateBackgroundProcesses
          )
         )
        nil
        nil
      )
! !

!WorkspaceApplication class methodsFor:'private'!

createWorkspaceView
    | view |

    view := (UserPreferences current useCodeView2In:#Workspace)
                ifTrue:[Tools::CodeView2 new]
                ifFalse:[HVScrollableView for:Workspace].
    ^ view

    "Modified: / 27-09-2013 / 10:23:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspaceApplication class methodsFor:'special startup'!

openEvaluationWorkspace
    |wsApp needRemove|

    needRemove := true.

    wsApp := self new.
    wsApp allButOpen.
    wsApp window extent:400@500.

    wsApp addEvaluationWorkspace.
    wsApp removeWorkspace:1.
    wsApp renameWorkspace:1 to:'Evaluator'.

    wsApp openWindow.
    wsApp selectedWorkspaceIndexHolder value:1.
    ^ wsApp

    "
     self openEvaluationWorkspace
    "

    "Created: / 13-10-2006 / 12:14:13 / cg"
    "Modified: / 25-09-2007 / 21:00:45 / cg"
!

openForSinglePageDoing:aBlock
    |wsApp needRemove|

    needRemove := true.

    wsApp := self new.
    wsApp allButOpen.

    (wsApp builder componentAt:'NoteBook') destroyTabAction:nil.

    wsApp window height:500.

    aBlock value:wsApp.
    wsApp removeWorkspace:1.  "/ the original Workspace
    "/ wsApp renameWorkspace:1 to:'LICENCE README'.

    wsApp openWindow.
    wsApp selectedWorkspaceIndexHolder value:1.
    ^ wsApp

    "
     self openWithGlobalsInspector
    "
!

openMyWorkspace
    |ws|

    "/ openMyWorkspace_new leads to an error in root /, which we don't understand...
    ws := self openMyWorkspace_new.
    "/ self openMyWorkspace_old.
    MyWorkspaceOpened := true.
    ^ ws

    "
      WorkspaceApplication openMyWorkspace
    "

    "Modified: / 21-06-2011 / 08:58:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-07-2011 / 13:12:04 / Administrator"
    "Modified (comment): / 09-08-2011 / 22:59:13 / cg"
!

openMyWorkspace_new
    "open showing tabs for ALL bookmarked workspace files"

    |workspace|

"/    workspace := self openWith: nil.
"/    workspace enqueueDelayedAction:[
"/        Error handle:[:ex |
"/            "/ no time to debug that stuff now...
"/            Dialog information:'Error in bookmark handling: ',ex description
"/        ] do:[
"/            BookmarkList forWorkspace myWorkspaces do:[:bookmark|
"/                workspace switchToBookmarkEntry: bookmark
"/            ].
"/
"/
"/
"/        ].
"/        workspace selectedWorkspaceIndexHolder value: 1.
"/    ].

    workspace := self new.
    workspace allButOpen.
    workspace initialSyntax:SmalltalkLanguage instance.

    Error handle:[:ex |
        ex reject.
        "/ no time to debug that stuff now...
        Dialog information:'Error in bookmark handling: ',ex description
    ] do:[
        BookmarkList forWorkspace myWorkspaces do:[:bookmark|
            workspace switchToBookmarkEntry: bookmark
        ].
    ].
    workspace selectedWorkspaceIndexHolder value: 1.
    workspace openWindow.
    ^ workspace

    "
     WorkspaceApplication openMyWorkspace
    "

    "Modified: / 21-06-2011 / 08:58:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 14-07-2011 / 13:11:32 / Administrator"
    "Modified: / 26-04-2012 / 12:45:50 / cg"
!

openMyWorkspace_old
    "open showing the single file: MyWorkspace.wsp"

    ^ self openOnFile:'MyWorkspace.wsp'

    "
     self openMyWorkspace.
    "

    "Created: / 21-06-2011 / 08:51:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-09-2011 / 07:48:07 / cg"
!

openOnFile:aFilename
    "launch a new workspace on the contents of some file"

    |ws|

    ws := self openWith:nil.

    "/ let the ws load the file - instead of the caller.
    "/ so the error dialog is shown in its context, 
    "/ and the caller (Launcher) is not blocked.
    ws enqueueDelayedAction:[ws loadFile:aFilename].
"/    ws loadFile:aFilename.
    ^ ws

    "
     WorkspaceApplication openOnFile:'Makefile'
    "
!

openSystemWorkspace
    ^ self new openSystemWorkspace.

    "
     |ws b|
     ws := self openSystemWorkspace.
     ws addMyWorkspace.
     ws selectedWorkspaceIndexHolder value:(ws workspaces size).
     ws selectedWorkspace contents:'Tools::NewSystemBrowser open'; selectAll.
     ws selectedWorkspace 
        add:(b := Button label:'DoIt' action:[ws doIt. b destroy])
    "
    "
     |ws b|
     ws := self new.
     ws open. 
     ws selectedWorkspace contents:'Tools::NewSystemBrowser open'; selectAll.
    "

    "Modified: / 14-02-2010 / 23:02:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 15:34:40 / cg"
!

openWith:initialText
    "launch a new workspace with some initial contents.
     The workspace will be opened in smalltalk syntax mode"

    ^ self openWith:initialText selected:false

    "
     WorkspaceApplication openWith:'Transcript showCR:''hello world'''
    "
!

openWith:initialText selected:selectedBoolean
    "launch a new workspace with some initial contents.
     The workspace will be opened in smalltalk syntax mode"

    |workspace|

    workspace := self new.
    workspace open.
    workspace selectedWorkspace contents:initialText selected:selectedBoolean.
    ^ workspace

    "
     WorkspaceApplication openWith:'Transcript showCR:''hello world'''
    "
!

openWith:initialText selected:selectedBoolean title:titleString
    "launch a new workspace with some initial contents.
     The workspace will be opened in smalltalk syntax mode"

    |workspace|

    workspace := self new.
    workspace open.
    titleString notNil ifTrue:[workspace setLabel:titleString].
    workspace selectedWorkspace contents:initialText selected:selectedBoolean.
    ^ workspace

    "
     WorkspaceApplication 
        openWith:'Transcript showCR:''hello world''' 
        selected:false
        title:'hello'
    "
!

openWithGlobalsInspector
    "open a workspaceApp with a single initial pane, showing global variables.
     Same as Smalltalk inspect, but looks nicer..."

    ^ self openForSinglePageDoing:[:wsApp | wsApp addNamespaceInspectorFor:Smalltalk]

    "
     self openWithGlobalsInspector
    "
!

openWithText:initialText
    "like openWith, but will set the language to 'text', so it is not incorrectly syntax highlighted"

    |ws|

    ws := self openWith:initialText selected:false.
    ws syntax:nil.
    ^ ws.

    "
     WorkspaceApplication openWithText:'foo 1 2 3 4'
    "
!

openWithWorkspaceVariableInspector
    "open a workspaceApp with a single initial pane, showing workspace variables.
     Same as Workspace workspaceVariables inspect, but looks nicer..."

    ^ self openForSinglePageDoing:[:wsApp | wsApp addWorkspaceVariableInspector]

    "
     self openWithWorkspaceVariableInspector
    "
! !

!WorkspaceApplication class methodsFor:'startup'!

open
    "/ the very first open opens a MyWorkspace

    (MyWorkspaceOpened == true) ifTrue:[
        ^ self openRegularWorkspace
    ] ifFalse:[
        ^ self openMyWorkspace
    ].

    "
     MyWorkspaceOpened := nil.
     WorkspaceApplication open.
    "

    "Created: / 21-06-2011 / 09:03:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 05-07-2011 / 15:23:53 / cg"
!

openRegularWorkspace
    "/ always open a normal MyWorkspace

    ^ super open

    "
     MyWorkspaceOpened := nil.
     WorkspaceApplication open.
    "
! !

!WorkspaceApplication methodsFor:'aspects'!

autoDefineVariables
    autoDefineVariables isNil ifTrue:[
        autoDefineVariables := ValueHolder new.
        (UserPreferences current autoDefineWorkspaceVariables) ifTrue:[
            autoDefineVariables value:#workspace.
        ] ifFalse:[
            autoDefineVariables value:#doIt.
        ].
        autoDefineVariables onChangeSend:#autoDefineVariablesChanged to:self.
    ].
    ^ autoDefineVariables.
!

bookmarks
    |ws app|

    ws := self selectedWorkspace scrolledView.
    ws isTextView ifTrue:[
        ^ BookmarkList forWorkspace
    ].
    (ws isApplicationSubView) ifTrue:[
        app := ws application.
        (app respondsTo:#bookmarks) ifTrue:[
            ^ app bookmarks
        ].
        (app respondsTo:#bookmarkListHolder) ifTrue:[
            ^ app bookmarkListHolder value
        ].
    ].
    ^ BookmarkList new.

    "Created: / 20-06-2011 / 22:23:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2011 / 08:13:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-07-2011 / 14:21:10 / cg"
!

browseItMenuButtonVisibile
    "/ typo in previous version
    ^ self browseItMenuButtonVisible

    "Modified: / 17-12-2013 / 16:34:59 / cg"
!

browseItMenuButtonVisible
    ^ self thisIsASmalltalkWorkspace

    "Created: / 17-12-2013 / 16:34:04 / cg"
!

canChangeLanguageHolder
    "return/create the 'canChangeLanguageHolder' value holder (automatically generated)"

    canChangeLanguageHolder isNil ifTrue:[
	canChangeLanguageHolder := ValueHolder with: true.
    ].
    ^ canChangeLanguageHolder

    "Modified: / 10-05-2012 / 23:43:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canChangeLanguageHolder:something
    "set the 'canChangeLanguageHolder' value holder (automatically generated)"

    canChangeLanguageHolder := something.
!

cursorColHolder
    cursorColHolder isNil ifTrue:[
        cursorColHolder := IndirectValue for:(ValueHolder with:1)
    ].
    ^ cursorColHolder

    "Created: / 22-01-2011 / 11:36:00 / cg"
!

cursorColLabelHolder
    ^ BlockValue 
            with:[:v | v isNil ifTrue:[''] ifFalse:[v printString]]
            argument:self cursorColHolder.

    "Created: / 22-01-2011 / 11:36:08 / cg"
!

cursorLineAndColumnLabelHolder
    cursorLineAndColumnLabelHolder isNil ifTrue:[
        cursorLineAndColumnLabelHolder := IndirectValue for:(ValueHolder with:1)
    ].
    ^ cursorLineAndColumnLabelHolder
!

cursorLineHolder
    cursorLineHolder isNil ifTrue:[
        cursorLineHolder := IndirectValue for:(ValueHolder with:1)
    ].
    ^ cursorLineHolder

    "Created: / 22-01-2011 / 11:35:22 / cg"
!

cursorLineLabelHolder
    ^ BlockValue 
            with:[:v | v isNil ifTrue:[''] ifFalse:[v printString]]
            argument:self cursorLineHolder.

    "Modified: / 22-01-2011 / 11:42:56 / cg"
!

doItMenuButtonVisibile
    "/ typo in previous version
    ^ self doItMenuButtonVisible

    "Modified: / 17-12-2013 / 16:35:05 / cg"
!

doItMenuButtonVisible
    ^ self thisIsASmalltalkWorkspace

    "Created: / 17-12-2013 / 16:34:10 / cg"
!

hasHistory
    ^ Workspace doItHistory notEmptyOrNil.
!

hasInfoLabel
    ^ true
!

inspectItMenuButtonVisibile
    "/ typo in previous version
    ^ self inspectItMenuButtonVisible

    "Modified: / 17-12-2013 / 16:35:17 / cg"
!

inspectItMenuButtonVisible
    ^ self thisIsASmalltalkWorkspace

    "Created: / 17-12-2013 / 16:34:17 / cg"
!

languageInfoLabelHolder
    ^ BlockValue
        with:[:syntax | 
                syntax notNil ifTrue:[
                    "'Syntax: ',"syntax name 
                ] ifFalse:[
                    'Text'
                ]
             ]
        argument:self syntaxHolder

    "Modified: / 19-07-2012 / 16:53:30 / cg"
!

modeLabelHolder
    modeLabelHolder isNil ifTrue:[
        modeLabelHolder := IndirectValue for:(ValueHolder with:'I')
    ].
    ^ modeLabelHolder

    "Created: / 22-01-2011 / 11:37:25 / cg"
!

namespaceHolder
    namespaceHolder isNil ifTrue:[
        namespaceHolder := self defaultNameSpaceForDoIts asValue.
        namespaceHolder onChangeSend:#setNameSpaceForDoIts to:self
    ].
    ^ namespaceHolder
!

namespaceInfoLabelHolder
    ^ BlockValue
        with:[:ns | 
                ns notNil ifTrue:[
                    ns name
                ] ifFalse:[
                    ''
                ]
             ]
        argument:self namespaceHolder
!

printItMenuButtonVisibile
    "/ typo in previous version
    ^ self printItMenuButtonVisible

    "Modified: / 17-12-2013 / 16:35:11 / cg"
!

printItMenuButtonVisible
    ^ self thisIsASmalltalkWorkspace

    "Created: / 17-12-2013 / 16:34:23 / cg"
!

profileItMenuButtonVisible
    ^ self thisIsASmalltalkWorkspace

    "Created: / 17-12-2013 / 16:34:04 / cg"
!

setWindowLabel: label 

    self setWindowLabel: label language: self syntaxHolder value
!

setWindowLabel: label language: language
    |languageName|

    language notNil ifTrue:[
	languageName := ' - ', language name.
    ] ifFalse:[
	languageName := ''.
    ].
    self window label:label, ' - ' , languageName
!

smalltalkMenuEnabledHolder
    smalltalkMenuEnabledHolder isNil ifTrue:[
        smalltalkMenuEnabledHolder := ValueHolder with:true.
    ].
    ^ smalltalkMenuEnabledHolder
!

syntax:aProgrammingLanguageOrNil
    "the argument must sth. like SmalltalkLanguage"

    self syntaxHolder value:aProgrammingLanguageOrNil
!

syntaxHolder
    syntaxHolder isNil ifTrue:[
        syntaxHolder := self defaultEvaluatorSyntax asValue.
        syntaxHolder onChangeSend:#setCompilerForSyntax to:self
    ].
    ^ syntaxHolder
!

toolBarView

    toolBarView isNil ifTrue:[
        toolBarView := SubCanvas new.
        toolBarView level: 0.
        toolBarView client: self spec: #toolBarSpec builder: builder.
    ].
    ^toolBarView

    "Created: / 10-06-2011 / 22:52:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2011 / 00:06:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspaceApplication methodsFor:'aspects-queries'!

anyWorkspaceVariableIsDefined
    ^ Workspace anyWorkspaceVariableIsDefined

    "Modified: / 20-04-2005 / 11:57:59 / cg"
!

canAddBookmark

    | ws |

    ws := self selectedWorkspace scrolledView.
    ws isTextView ifFalse:[^ true].

    ^ ws defaultFileNameForFileDialog notNil.

    "Created: / 20-06-2011 / 22:43:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSQLWorkspaceAvailable

    ^(Smalltalk at:#'SQL::WorkspacePage') notNil

    "Created: / 10-05-2012 / 18:49:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSQLWorkspaceSelected

    builder isNil ifTrue:[self createBuilder].
    ^ builder bindings at: #isSQLWorkspaceSelected ifAbsentPut: [
        BlockValue
            with:[:ignored|
                self selectedWorkspaceApplication isKindOf: (Smalltalk at:#'SQL::WorkspacePage')
            ]
            argument: self selectedWorkspaceIndexHolder
    ]

    "Created: / 11-05-2012 / 09:41:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-03-2014 / 16:38:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isWebBrowserAvailable

    ^(Smalltalk at:#WebKitView) notNil

    "Created: / 11-06-2011 / 00:30:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedWorkspaceIsTextView
    ^ self selectedWorkspacesTextView notNil
! !

!WorkspaceApplication methodsFor:'autofetch selection'!

autoFetchSelection
    ^ clipBoardWatcherProcess notNil

    "Created: / 16-11-2010 / 14:55:39 / cg"
!

autoFetchSelection:aBoolean
    Screen current isWindowsPlatform ifTrue:[
        aBoolean ifTrue:[
            self startClipboardWatcher
        ] ifFalse:[
            self stopClipboardWatcher
        ].
        ^ self.
    ].

    aBoolean ifTrue:[
        self window windowGroup addPreEventHook:self.
        device addSelectionHandler:self
    ] ifFalse:[
        self window windowGroup removePreEventHook:self.
        device removeSelectionHandler:self
    ].

    "Created: / 16-11-2010 / 14:34:15 / cg"
!

autoFetchSelectionLines
    fetchClipboardLines isNil ifTrue:[
        fetchClipboardLines := ValueHolder with:true
    ].
    ^ fetchClipboardLines

    "Created: / 04-02-2011 / 17:52:34 / cg"
!

itemFromClipboard
    |text|

    text := self window getClipboardText.
    (text notNil and:[text isString]) ifTrue:[
        self autoFetchSelectionLines value ifTrue:[
            text := text , Character cr
        ].
        self paste:text.
    ].

    "Created: / 16-11-2010 / 14:44:26 / cg"
    "Modified: / 04-02-2011 / 17:53:46 / cg"
!

startClipboardWatcher
    clipBoardWatcherProcess isNil ifTrue:[
        ClipBoardFetchingInstance notNil ifTrue:[
            ClipBoardFetchingInstance stopClipboardWatcher
        ].
        clipBoardWatcherProcess := 
            [
                [true] whileTrue:[
                    self waitForClipBoardToChange.
                ].
            ] newProcess.

        clipBoardWatcherProcess resume.
        ClipBoardFetchingInstance := self.
    ].

    "Created: / 16-11-2010 / 14:35:55 / cg"
!

stopClipboardWatcher
    |p|

    (p := clipBoardWatcherProcess) notNil ifTrue:[
        ClipBoardFetchingInstance := nil.
        clipBoardWatcherProcess := nil.
        p terminate
    ].

    "Created: / 16-11-2010 / 14:36:12 / cg"
!

waitForClipBoardToChange
    |prev|

    prev := self window getClipboardText.
    [ 
        Delay waitForSeconds:0.2.
        self window getClipboardText = prev
    ] whileTrue.
    self itemFromClipboard.

    "Created: / 16-11-2010 / 14:44:05 / cg"
! !

!WorkspaceApplication methodsFor:'defaults'!

defaultEvaluatorSyntax
    LastLanguage notNil ifTrue:[^ LastLanguage].
    ^ SmalltalkLanguage instance.

    "Modified: / 01-12-2010 / 12:21:41 / cg"
!

defaultFileNameForLoad
   ^ 'file.wsp'

    "Created: / 25-10-2006 / 14:56:10 / cg"
!

defaultFileNameForSave
    |ws|

    ws := self selectedWorkspace scrolledView.
    ws isTextView ifFalse:[
        "/ eval-ws
        ^ super defaultFileNameForSave
    ].
    ^ ws defaultFileNameForFileDialog ? super defaultFileNameForSave

    "Modified: / 22-01-2011 / 12:01:27 / cg"
!

defaultFileNameForSaveAll
   ^ 'file.wsp'

    "Created: / 25-10-2006 / 14:56:04 / cg"
!

defaultNameSpaceForDoIts
    LastNamespace notNil ifTrue:[^ LastNamespace].
    ^ Smalltalk.
!

defaultPatternLoad
   ^ '*.wsp; *.txt; *.rc'

    "Created: / 25-10-2006 / 14:57:25 / cg"
!

executeMenuVisible 
    ^ self thisIsASmalltalkWorkspace
!

thisIsASmalltalkWorkspace
    "can be redefined in a subclass to disable smalltalk-specific menu items
     (expecco uses workspaces as scratchpads)"

    ^ true
! !

!WorkspaceApplication methodsFor:'drag & drop'!

droppedFile:aFilename in:aComponent
    "this is a notification from my textView component"

    self 
        renameWorkspace:(self selectedWorkspaceIndexHolder value)
        to:aFilename asFilename baseName
! !


!WorkspaceApplication methodsFor:'help'!

flyByHelpSpec
    "/ dynamically adjust the menuSave item's flyByhelpText
    ^ self updateHelpSpec:(super flyByHelpSpec)

    "Created: / 05-07-2011 / 15:42:25 / cg"
!

updateHelpSpec:aSpec
    |file ws|

    "/ dynamically adjust the menuSave item's flyByhelpText
    ws := self selectedWorkspace scrolledView.
    ws isTextView ifTrue:[
        file := ws defaultFileNameForFileDialog.
    ].

    aSpec
        at:#menuSaveOrSaveAs 
        put:(file isNil ifTrue:[aSpec at:#menuSaveAs] ifFalse:[aSpec at:#menuSave]).

    OperatingSystem isMSWINDOWSlike ifTrue:[
        aSpec
            at:#addTerminal 
            put:(aSpec at:#addTerminalWindows).

    ].
    ^ aSpec

    "Created: / 06-07-2011 / 16:32:13 / cg"
! !

!WorkspaceApplication methodsFor:'initialization & release'!

closeRequest
    "asks for permission before closing"

    (self askIfAnyModified:'Text in %1 was not saved. Close anyway ?' yesButton:'Close') ifFalse:[
        ^ self
    ].

    ^ super closeRequest
!

initialSyntax: aLanguage
    self syntaxHolder value: aLanguage.

    "Created: / 26-04-2012 / 12:26:48 / cg"
!

postBuildEditModeInfoLabel:aLabel
    aLabel menuHolder:self; menuMessage:#editModeInfoLabelMenu.

    "Created: / 22-01-2011 / 11:32:57 / cg"
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.
    self setCompilerForSyntax.

    self infoVisibilityChanged.         "/ force geometry update
    self autoDefineVariablesChanged.    "/ force workspaceView update
!

postOpenWith:aBuilder
    self windowGroup addPreEventHook:self.
    super postOpenWith:aBuilder.

    "Created: / 22-01-2011 / 12:09:20 / cg"
    "Modified: / 08-02-2011 / 21:33:49 / cg"
!

processEvent:anEvent
    "filter double click in line-label.
     Return true, if I have eaten the event"

    anEvent isButtonMultiPressEvent ifTrue:[
        anEvent view name = 'CursorLineLabel' ifTrue:[
            self selectedWorkspace scrolledView gotoLine.
            ^ true
        ].
    ].
    ^ false

    "Created: / 22-01-2011 / 12:10:01 / cg"
! !

!WorkspaceApplication methodsFor:'menu-actions'!

askForFilterBlock:message template:template rememberIn:nameOfClassVar
    |filterBlockString filterBlock dialog textHolder classVarValue|

    classVarValue := self class classVarAt:nameOfClassVar ifAbsent:nil.
    classVarValue isNil ifTrue:[
        self class classVarAt:nameOfClassVar put:template. 
        classVarValue := template.
    ].

    textHolder := ValueHolder new.
    dialog := Dialog 
                 forRequestText:(resources string:message)
                 editViewClass:CodeView
                 lines:25 
                 columns:70
                 initialAnswer:classVarValue
                 model:textHolder.
    dialog addButton:(Button label:'Template' action:[textHolder value:template. textHolder changed:#value.]).
    dialog open.
    dialog accepted ifFalse:[^ nil].

    filterBlockString := textHolder value.
    self class classVarAt:nameOfClassVar put:filterBlockString. 

    filterBlock := Parser evaluate:filterBlockString.
    filterBlock isBlock ifFalse:[
        self error:'bad input for block' mayProceed:true.
        ^ nil
    ].

    ^ filterBlock
!

autoDefineVariablesChanged
    |autoDefine|

    autoDefine := autoDefineVariables value.
    UserPreferences current autoDefineWorkspaceVariables:(autoDefine == #workspace).
    workspaces do:[:each |
        each autoDefineVariables:autoDefine
    ].
!

basicInspectIt
    self inspectIt:true
!

browseImplementorsOfIt
    self selectedWorkspacesTextView browseImplementorsOfIt
!

browseIt
    |ws|

    ws := self selectedWorkspacesTextView.
    ws notNil ifTrue:[
        ws browseIt
    ]
!

browseReferencesToIt
    self selectedWorkspacesTextView browseReferencesToIt
!

clearHistory
    Workspace clearDoItHistory
!

compareTextAgainst
    |ws otherText thisText|

    ws := self selectedWorkspace scrolledView.
    ws isTextView ifFalse:[
        ^ self 
    ].

    ws hasSelection ifTrue:[
        thisText := ws selectionAsString.
    ] ifFalse:[
        thisText := ws contents asString.
    ].

    otherText := Dialog requestText:'Paste other text below:'.
    otherText isEmptyOrNil ifTrue:[^ self ].

    DiffTextView 
        openOn: thisText label: 'Workspace' 
        and: otherText label: 'Other Text' 
        title: 'Comparing Workspace Contents'

    "Created: / 04-05-2012 / 15:35:32 / cg"
!

doIt
    |ws|

    ws := self selectedWorkspacesTextView.
    ws notNil ifTrue:[
        ws doIt
    ]
!

inspectIt
    self inspectIt:false
!

inspectIt:isBasicInspector
    |ws|

    ws := self selectedWorkspacesTextView.
    ws isNil ifTrue:[
        "there is none - i.e. it is a HTMLDocumentView"
        ^ self.
    ].
    ws
        do:(ws selection) 
        withValueDo:[:result | 
                        self addInspectorOn:result basic:isBasicInspector suppressPseudoSlots:false
                    ]

"/    self selectedWorkspace inspectIt
!

inspectWorkspaceVariables
    |wsvars|

    wsvars := Workspace workspaceVariables.
    wsvars size == 0 ifTrue:[
        Dialog information:'No Workspace Variables are defined'.
        ^ self
    ].
    wsvars inspect
!

loadFile:aFileName encoding:encodingSymbolOrNil label:label

    "This small hack allows programmers to have their own
    MyWorkspace.wsp in their ~/.smalltalk directory"

    | f |
    f := aFileName asFilename.
    (f exists not and:[f isAbsolute not]) ifTrue:[
    f := Filename homeDirectory / '.smalltalk' / f pathName.
    f exists ifFalse:[
        (aFileName = 'MyWorkspace.wsp') 
            ifTrue:
                [| s|
                s := f writeStream.
                [s nextPutAll:'"Edit and save as  ', f pathName , '"']
                    ensure:[s close]]
            ifFalse:
                [f := aFileName asFilename]
    ]].
    ^super loadFile:f pathName encoding:encodingSymbolOrNil label:label

    "Created: / 23-12-2009 / 10:13:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2010 / 10:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

manageSnippets
    |bindings listOfSnippets removeAction pasteAction
     hasSelectionHolder removeEnabledHolder pasteEnabledHolder
     selectedSnippetHolder selectedSnippetsTextHolder selectedSnippetsKeyHolder
     selectedSnippetsName
     snippetsDictionary defineEnabledHolder defineAction 
     snippetTextAcceptHolder snippetTextModifiedHolder
     loadFileAction saveFileAction|

    snippetsDictionary := Workspace snippets.
    snippetsDictionary isEmptyOrNil ifTrue:[
        Dialog information:(resources string:'No Snippets to Manage').
        ^ self.
    ].

    listOfSnippets := List withAll:(snippetsDictionary keysSorted).
    selectedSnippetsTextHolder := ValueHolder with:''.
    selectedSnippetsKeyHolder := ValueHolder with:''. 

    selectedSnippetHolder := nil asValue.
    selectedSnippetHolder 
        onChangeEvaluate:[
            (selectedSnippetHolder value) isNil ifTrue:[
                selectedSnippetsName := nil.
                selectedSnippetsTextHolder value:''.
                selectedSnippetsKeyHolder value:nil.   
            ] ifFalse:[
                selectedSnippetsName := listOfSnippets at:(selectedSnippetHolder value).
                selectedSnippetsKeyHolder value:selectedSnippetsName.   
                selectedSnippetsTextHolder value:(snippetsDictionary at:selectedSnippetsName).
            ].
        ].

    hasSelectionHolder := BlockValue with:[:m | m value notNil] argument:selectedSnippetHolder.
    removeEnabledHolder := hasSelectionHolder.
    pasteEnabledHolder := hasSelectionHolder.
    defineEnabledHolder := 
            BlockValue 
                with:[:key :text|
                    key notEmptyOrNil
                    and:[(snippetsDictionary includesKey:key) not
                         or:[ (snippetsDictionary at:key) ~= text]]
                ] 
                argument: selectedSnippetsKeyHolder argument: selectedSnippetsTextHolder.

    removeAction := 
        [
            snippetsDictionary removeKey:selectedSnippetsName.
            listOfSnippets remove:selectedSnippetsName.
        ].

    pasteAction := 
        [
            |text|
            text := snippetsDictionary at:selectedSnippetsName.
            self paste:text
        ].

    defineAction := 
        [
            |originalText newText key|

            key := selectedSnippetsKeyHolder value.
            key notEmptyOrNil ifTrue:[
                originalText := snippetsDictionary at:key ifAbsent:nil. "/ selectedSnippetsName.
                newText := selectedSnippetsTextHolder value withoutTrailingSeparators.
                originalText ~= newText ifTrue:[
                    snippetsDictionary at: key put: newText.
                    snippetTextModifiedHolder value:false.
                ].
            ].
            defineEnabledHolder recomputeValue.
        ].

    loadFileAction :=
        [
            |file fileSnippets|

            file := Dialog requestFileName:'Load Snippet Definition File' default:(LastSnippetFilename ? 'snippets.txt').
            file notEmptyOrNil ifTrue:[
                LastSnippetFilename := file.
                file asFilename readingFileDo:[:s |
                    fileSnippets := (Object readFrom:s onError:#()) decodeAsLiteralArray.
                ].
                fileSnippets notEmptyOrNil ifTrue:[
                    snippetsDictionary declareAllFrom:fileSnippets.
                    listOfSnippets contents:(snippetsDictionary keysSorted).
                    selectedSnippetHolder value:nil.
                    selectedSnippetsTextHolder value:''.
                    selectedSnippetsKeyHolder value:''. 
                ]
            ]
        ].

    saveFileAction :=
        [
            |file|

            file := Dialog requestFileName:'Save Snippet Definition File' default:(LastSnippetFilename ? 'snippets.txt').
            file notEmptyOrNil ifTrue:[
                LastSnippetFilename := file.
                file asFilename writingFileDo:[:s |
                    s nextPutLine:'#( Dictionary'.
                    snippetsDictionary keys asSortedCollection do:[:k |
                        k storeOn:s.
                        s spaces:2.
                        (snippetsDictionary at:k) storeOn:s.
                        s cr.
                    ].
                    s nextPutLine:')'.
                ]
            ]
        ].

    bindings := IdentityDictionary new.
    bindings at:#listOfSnippets put:listOfSnippets.
    bindings at:#selectedSnippet put:selectedSnippetHolder asValue.
    bindings at:#selectedSnippetsKeyHolder put:selectedSnippetsKeyHolder.
    bindings at:#selectedSnippetsText put:selectedSnippetsTextHolder.
    bindings at:#removeSelectedSnippet put:removeAction.
    bindings at:#pasteSelectedSnippet put:pasteAction.
    bindings at:#defineSelectedSnippet put:defineAction.
    bindings at:#removeEnabled put:removeEnabledHolder.
    bindings at:#pasteEnabled put:pasteEnabledHolder.
    bindings at:#defineEnabled put:defineEnabledHolder.
    bindings at:#menuOpenSnippetFile put:loadFileAction.
    bindings at:#menuSaveSnippetFileAs put:saveFileAction.
    bindings at:#closeSnippetDialog put:[:a :menu | menu topView closeRequest].
    bindings at:#snippetTextAcceptHolder put:(snippetTextAcceptHolder := TriggerValue new).
    bindings at:#snippetTextModified put:(snippetTextModifiedHolder := TriggerValue new).
    bindings at:#openSnippetDocumentation put:[self halt. self openHTMLDocument: 'tools/misc/TOP.html#WORKSPACE'].

    snippetTextModifiedHolder onChangeEvaluate:[snippetTextAcceptHolder value:true. defineEnabledHolder recomputeValue ].
    selectedSnippetsKeyHolder onChangeEvaluate:[defineEnabledHolder recomputeValue ].

    self openDialogInterface:#manageSnippetsDialogSpec withBindings:bindings
!

menuSQLConnect

    self selectedWorkspaceApplication menuConnect

    "Created: / 11-05-2012 / 10:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuSave
    |ws file|

    ws := self selectedWorkspace scrolledView.
    ws isTextView ifFalse:[
        self shouldImplement:'Functionality not yet implemented'.
    ].
    file := ws defaultFileNameForFileDialog.
    file 
        ifNil:[
            self menuSaveAs.
            ^ self
        ].
    ws saveAs:file doAppend:false.
    ws isCodeView2 ifTrue:[
        ws beUnmodified
    ]

    "Created: / 21-06-2011 / 11:42:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-07-2011 / 15:44:27 / cg"
    "Modified: / 08-10-2011 / 12:51:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newEvaluationWorkspace
    self class openEvaluationWorkspace

    "Created: / 13-10-2006 / 12:19:47 / cg"
!

newSystemWorkspace
    self class openSystemWorkspace
!

openDocumentation
    "opens the documentation file"

    self openHTMLDocument: 'tools/misc/TOP.html#WORKSPACE'
!

openEditingDocumentation
    "opens the documentation file"

    self openHTMLDocument: 'tools/codeeditor.html'
!

pasteAndExecute:aString
    self paste:aString.
    self printIt
!

pasteSnippet
    |allSnippets snippetToPaste snippetsDictionary|

    snippetsDictionary := Workspace snippets.
    snippetsDictionary isEmptyOrNil ifTrue:[
        Dialog information:(resources string:'No Snippet to Paste').
        ^ self.
    ].
    allSnippets := snippetsDictionary keysSorted.

    snippetToPaste := Dialog 
                choose:(resources string:'Paste Snippet:')
                fromList:allSnippets
                lines:10.
    snippetToPaste isNil ifTrue:[
        ^ self
    ].
    self paste:(snippetsDictionary at:snippetToPaste) withCRs.

    "Modified: / 29-10-2010 / 10:21:29 / cg"
!

printIt
    |ws|

    ws := self selectedWorkspacesTextView.
    ws notNil ifTrue:[
        ws printIt
    ]
!

profileIt
    self selectedWorkspacesTextView profileIt
!

redoLastDoIt
    |s|

    s := self lastDoItsString.
    s notNil ifTrue:[
        self pasteAndExecute:s
    ]
!

removeAllWorkspaceVariables
    (Dialog confirm:(resources string:'Do you really want to remove all Workspace Variables ?'))
    ifTrue:[
        Workspace removeAllWorkspaceVariables
   ].
!

removeGlobalVariable
    |name nameKey selection value|

    selection := self selectedWorkspacesTextView selection ? ''.

    name := Dialog 
                request:'Remove Global Variable:'
                initialAnswer:(selection asString string)
                okLabel:'Remove'
                title:'Remove Global'.

    name size == 0 ifTrue:[^ self].
    nameKey := name asSymbolIfInterned.
    nameKey isNil ifTrue:[^ self].

    (Smalltalk includesKey:nameKey) ifFalse:[
        self warn:('No such Global Binding: ''%1''.' bindWith:name).
        ^ self.
    ].

    value := Smalltalk at:nameKey.
    value notNil ifTrue:[
        (self confirm:('Global ''%1'' is currently bound to %2\\Remove Binding ?' bindWith:name with:value) withCRs)
        ifFalse:[
            ^ self.
        ].
    ].
    Smalltalk at:nameKey put:nil.
    Smalltalk removeKey:nameKey
!

removeSharedPool
    |poolToRemove|

    poolsConsideredInDoIts isEmptyOrNil ifTrue:[
        Dialog information:'No pools have been added yet'.
        ^ self.
    ].

    poolToRemove := Dialog 
                choose:'Pool to Remove (No longer known in doIt-Evaluations):'
                fromList:(poolsConsideredInDoIts asOrderedCollection sort)
                lines:10.

    poolToRemove isNil ifTrue:[
        ^ self
    ].
    poolsConsideredInDoIts remove:poolToRemove.
    workspaces do:[:eachWs |    
        |ws|
        ws := self workspaceViewOfView:eachWs.
        ws notNil ifTrue:[
            ws poolsConsideredInDoIts:poolsConsideredInDoIts.
        ].
    ].

    "Modified: / 24-11-2006 / 12:44:16 / cg"
!

removeWorkspaceVariable
    |name selection wsVarNames|

    wsVarNames := Workspace workspaceVariableNames.
    wsVarNames isEmpty ifTrue:[
        Dialog information:'No Workspace Variables are defined'.
        ^ self
    ].

    selection := self selectedWorkspacesTextView selection ? ''.

    name := Dialog 
                request:'Variable to remove:'
                initialAnswer:(selection asString string)
                okLabel:'Remove'
                title:'Enter Variable Name'
                list:(wsVarNames asOrderedCollection sort).      
    name isEmptyOrNil ifTrue:[
        ^ self
    ].
    Workspace removeWorkspaceVariable:name.

    "Modified: / 20-04-2005 / 11:56:28 / cg"
!

renameWorkspace:wsIndex to:newName
    |tabList|

    tabList := self tabList.
    tabList notEmpty ifTrue:[
        tabList at:wsIndex put:newName.
    ].
    wsIndex == self selectedWorkspaceIndexHolder value ifTrue:[
        self setWindowLabel: newName.
    ].
!

setCompilerForSyntax
    |selectedWorkspace ws|

    (selectedWorkspace := self selectedWorkspace) notNil ifTrue:[
        (ws := self workspaceViewOfView:selectedWorkspace) notNil ifTrue:[
            self setCompilerForSyntaxIn:ws.
        ]
    ].

    "Modified: / 26-09-2012 / 11:55:59 / cg"
!

setCompilerForSyntaxIn:aWorkspace
    |compilerClass language|

    language := self syntaxHolder value.
    language isSymbol ifTrue:[
        language := ProgrammingLanguage named:language  
    ].
    language isNil ifTrue:[
        compilerClass := nil
    ] ifFalse:[
        compilerClass := (language evaluatorClass "self compilerClassForSyntaxName:syntax").
    ].
    [
        "/ could be a non-text view (VT100Terminal)
        aWorkspace compilerClass:compilerClass.
        aWorkspace editedLanguage:language.
    ] on:MessageNotUnderstood do:[].

    self smalltalkMenuEnabledHolder value:(language notNil and:[language isSmalltalk]).

    "Created: / 08-02-2011 / 21:32:39 / cg"
    "Modified: / 17-08-2011 / 08:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-09-2012 / 19:55:18 / cg"
!

setNameSpaceForDoIts
    |selectedWorkspace ws|

    (selectedWorkspace := self selectedWorkspace) notNil ifTrue:[
        (ws := self workspaceViewOfView:selectedWorkspace) notNil ifTrue:[
            (self compilerClassOf:selectedWorkspace) notNil ifTrue:[
                ws nameSpaceForDoits:(self namespaceHolder value).
            ].
        ]
    ].
!

spyOnIt
    self selectedWorkspacesTextView spyOnIt
!

switchToBookmarkEntry: bookmark
    | ws file app |

    ws := self selectedWorkspace scrolledView.
    (ws isApplicationSubView) ifTrue:[
        ((app := ws application) respondsTo:#switchToBookmarkEntry:) ifTrue:[
            app switchToBookmarkEntry: bookmark
        ].
        ^ self.
    ].

    bookmark isFileBookmark ifTrue:[
        file := bookmark path asFilename.
        (ws isTextView not or:[ws contents notEmpty]) ifTrue:[
            self addWindow: (self createWorkspace) named:  file withoutSuffix baseName.
        ].
        file exists ifFalse:[
            Transcript showCR:('Bookmarked workspace file no longer exists: %1' bindWith:file)
        ] ifTrue:[
            self loadFile: file.
        ].
        ^ self.
    ].

    "Created: / 20-06-2011 / 22:45:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2011 / 08:18:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-09-2011 / 07:44:53 / cg"
!

terminateBackgroundProcesses
    Processor activeProcess terminateAllSubprocessesInGroup
!

timeIt
    self selectedWorkspacesTextView timeIt
! !

!WorkspaceApplication methodsFor:'menu-actions-adding'!

addBookmark

    self menuAddBookmarkTo: self bookmarks root.

    "Created: / 20-06-2011 / 22:34:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2011 / 08:56:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addClassVariableInspector
    |v|

    ClassVariablesInspectorView isNil ifTrue:[
        self error:'Missing class: "ClassVariablesInspectorView"'.
        ^ self.
    ].
    v := self addInspectorOn:Smalltalk inspectorClass:ClassVariablesInspectorView suppressPseudoSlots:true.

    v fieldListLabel:'Name'.
    self renameWorkspace:(self selectedWorkspaceIndexHolder value) to:'Class Variables'.

    "Modified: / 22-10-2006 / 11:28:14 / cg"
!

addEvaluationWorkspace
    ^ self addWindow:(self createEvaluationWorkspace) named:'Eval%1'

    "Modified: / 13-10-2006 / 12:16:35 / cg"
!

addGlobalVariable
    |name nameKey selection|

    selection := self selectedWorkspacesTextView selection ? ''.

    name := Dialog 
                request:'Name of new Global Variable:'
                initialAnswer:(selection asString string)
                okLabel:'Add'
                title:'Enter Variable Name'.
    name size == 0 ifTrue:[
        ^ self
    ].
    nameKey := name asSymbol.

    (Smalltalk includesKey:nameKey) ifTrue:[
        self warn:'Global named ''' , name , ''' already exists.'.
        ^ self.
    ].
    Smalltalk at:nameKey put:nil.
!

addGlobalVariableInspector
    ^ self addNamespaceInspectorFor:Smalltalk

    "Modified: / 29-05-2007 / 19:08:58 / cg"
!

addInspectorOn:aValue basic:isBasicInspector suppressPseudoSlots:suppressPseudoSlots
    |inspectorClass|

    isBasicInspector ifFalse:[
        "/ Inspector2 does not work yet!!
        "(Tools::Inspector2 notNil and:[UserPreferences current useInspector2])" false ifTrue:[
            inspectorClass := Tools::Inspector2.
        ] ifFalse:[
            inspectorClass := aValue inspectorClass.
        ].
    ].
    inspectorClass isNil ifTrue:[
        inspectorClass := InspectorView
    ].

    ^ self
        addInspectorOn:aValue 
        inspectorClass:inspectorClass 
        suppressPseudoSlots:suppressPseudoSlots
!

addInspectorOn:aValue inspectorClass:inspectorClass suppressPseudoSlots:suppressPseudoSlots
    |view resultString|

    view := inspectorClass new.
    view suppressPseudoSlots:suppressPseudoSlots.
    view inspect:aValue.
    "/ v allowFollow:true.
    aValue isBehavior ifTrue:[
        resultString := aValue name
    ] ifFalse:[
        resultString := aValue classNameWithArticle
    ].
    self addWindow:view named:('Inspecting: ' , resultString).
    ^ view
!

addMyWorkspace
    |ws f|

    self 
        addWindow:(ws := self createWorkspaceView)
        named:'My Workspace'
        asFirst:false.

    f := Filename homeDirectory / 'MyWorkspace.wsp'.
    f exists ifFalse:[
        f := Filename homeDirectory / '.smalltalk' / 'MyWorkspace.wsp'.
        f exists ifFalse:[
            f := 'MyWorkspace.wsp' asFilename 
        ]
    ].
    f exists ifTrue:[
        self loadFile:f label:'My Workspace'.
    ] ifFalse:[
        ws defaultFileNameForFileDialog: f pathName.
    ].

    "Modified: / 21-06-2010 / 08:40:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 15:39:08 / cg"
!

addNamespaceInspector
    |ns|

    ns := Dialog requestNameSpace:'Namespace' initialAnswer:nil.
    ns isEmptyOrNil ifTrue:[^ self].
    ^ self addNamespaceInspectorFor:(Smalltalk at:ns asSymbol)

    "Created: / 29-05-2007 / 19:10:50 / cg"
!

addNamespaceInspectorFor:aNameSpaceOrSharedPool
    |v label|

    SmalltalkInspectorView isNil ifTrue:[
        self error:'Missing class: "SmalltalkInspectorView"'.
        ^ nil.
    ].

    v := self 
            addInspectorOn:aNameSpaceOrSharedPool 
            inspectorClass:SmalltalkInspectorView 
            suppressPseudoSlots:true.

    v fieldListLabel:'Name'.
    aNameSpaceOrSharedPool == Smalltalk ifTrue:[
        label := 'Smalltalk (Globals)'
    ] ifFalse:[
        aNameSpaceOrSharedPool isSharedPool ifTrue:[
            label := aNameSpaceOrSharedPool name,' (SharedPool)'
        ] ifFalse:[
            label := aNameSpaceOrSharedPool name,' (Namespace)'
        ].
    ].

    self 
        renameWorkspace:(self selectedWorkspaceIndexHolder value) 
        to:label.
    ^ v

    "Created: / 29-05-2007 / 19:08:45 / cg"
!

addSQLWorkspace
    |page view |

    page := (Smalltalk at:#'SQL::WorkspacePage') new.
    view := ApplicationSubView new.
    view client:page spec:#windowSpec.
    self addWindow:view named:'SQL Workspace %1'.

    "Created: / 10-05-2012 / 18:48:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addSelectionToSnippets
    |selection snippetsBaseName snippetsName nr snippetsDictionary|

    selection := (self selectedWorkspacesTextView selection ? '') asString.
    selection isEmpty ifTrue:[
        Dialog information:(resources string:'Nothing Selected').
        ^ self
    ].

    snippetsBaseName := Dialog request:(resources string:'Name of Snippet:').
    snippetsBaseName isNil ifTrue:[
        ^ self
    ].
    snippetsBaseName isEmpty ifTrue:[
        snippetsBaseName := Time now asString.
    ].
    snippetsDictionary := Workspace snippets.

    snippetsName := snippetsBaseName.
    (snippetsDictionary includesKey:snippetsName) ifTrue:[
        (Dialog confirm:(resources string:'Replace existing snippet named "%1" ?' with:snippetsName))
        ifFalse:[
            [snippetsDictionary includesKey:snippetsName] whileTrue:[
                nr := (nr ? 1) + 1.
                snippetsName := (snippetsBaseName,'(%1)') bindWith:nr
            ].
        ]
    ].
    snippetsDictionary at:snippetsName put:selection

    "Modified: / 24-11-2006 / 12:44:16 / cg"
!

addSharedPool
    |allPools poolToAdd|

    allPools := SharedPool allSubclasses collect:[:p | p name].
    allPools removeAll:(poolsConsideredInDoIts ? #()).
    allPools sort.

    poolToAdd := Dialog 
                choose:'Select a SharedPool to Add (To be known in doIt-Evaluations):'
                fromList:allPools
                lines:15.
    poolToAdd isNil ifTrue:[
        ^ self
    ].
    poolsConsideredInDoIts isNil ifTrue:[
        poolsConsideredInDoIts := (Set new).
    ].
    poolsConsideredInDoIts add:poolToAdd.
    workspaces do:[:eachWs |    
        |ws|
        ws := self workspaceViewOfView:eachWs.
        ws notNil ifTrue:[
            ws poolsConsideredInDoIts:poolsConsideredInDoIts.
        ].
    ].

    "Modified: / 24-11-2006 / 12:44:16 / cg"
!

addSharedPoolInspector
    |pool|

    pool := Dialog requestSharedPool:'SharedPool' title:nil initialAnswer:nil.
    pool isEmptyOrNil ifTrue:[^ self].
    ^ self addNamespaceInspectorFor:(Smalltalk at:pool asSymbol)

    "Created: / 29-05-2007 / 19:10:50 / cg"
!

addStopWatch
    |v clockViewClass clock|

    v := View new.
    v viewBackground:Color white.
    "/ avoid making stx:libwidg3 a prerequisite. 
    Smalltalk loadPackage:#'stx:libwidg3'. "/ ClockView package
    clockViewClass := Smalltalk at:#ClockView.
        
    clock := clockViewClass in:v.
    clock beStopWatch.

    clock 
        origin:[ 
            |ext|

            ext := (v height) min:(v width).
            (v extent - ext) // 2
        ]
        extent:[        
            |ext|

            ext := (v height) min:(v width).
            ext @ ext
        ].

    self addWindow:v named:'StopWatch%1' tabIcon:(ToolbarIconLibrary clock13x13Icon).
!

addTeaTimer
    "you think that is a useless gimmick ?
     I use it in the office and as a wakeup clock timer"

    |l dt tEnd dur answer confirmed confirmButton|

    dt := LastTeaWaitTime ? (3*60).
    answer := Dialog 
                request:'Delta-Time (seconds), Duration (n s/m/h) or End-Time (hh:mm:ss):' 
                initialAnswer:(TimeDuration seconds:dt) printString.
    answer isEmptyOrNil ifTrue:[^ self].

    "/ allow 3 formats:
    "/  hh:mm:ss       -> endTime
    "/  nnn s          -> x seconds
    "/  nnn m          -> x minutes
    "/  nnn h          -> x hours
    "/  nnn            -> seconds

    tEnd := Time readFromString:answer onError:nil.
    tEnd isNil ifTrue:[
        dur := TimeDuration readFromString:answer onError:nil.
        dur isNil ifTrue:[
            dt := Number readFromString:answer onError:[^ self].
            LastTeaWaitTime := dt.
            tEnd := Timestamp now addSeconds:dt.
        ] ifFalse:[
            dt := dur asSeconds.
            tEnd := Timestamp now + dur.
        ].                
    ] ifFalse:[
        tEnd < Time now ifTrue:[
            (Dialog confirm:'Tomorrow ?') ifFalse:[^ self].
            tEnd := tEnd asTimestamp addDays:1.
            dt := tEnd - Timestamp now.
        ] ifFalse:[
            dt := tEnd - Time now.
            tEnd := tEnd asTimestamp.
        ].
    ].

    l := Label new.
    l sizeFixed:true.
    l label:'Waiting... [', dt printString, ']'.
    l viewBackground:Color red.
    confirmButton := (Button label:'OK') action:[ confirmed := true. confirmButton beInvisible. ].
    confirmButton beInvisible.
    l add:confirmButton.

    self addWindow:l named:'TeaTimer%1' tabIcon:(ToolbarIconLibrary clock13x13Icon).

    [
        Error handle:[ 
            self error:'check this, please'.
            #intentionallyLeftBlank
        ] do:[
            |remaining wg waitTime|

            waitTime := TimeDuration fromSeconds:1.
            confirmed := false.
            [Timestamp now < tEnd ] whileTrue:[
                remaining := (tEnd - Timestamp now) roundTo:waitTime.
                l label:'Waiting... [', remaining printString, ']'.
                Delay waitFor:waitTime.
            ].

            l label:'TEA is ready !!'.
            self window topView raiseDeiconified.
            "/ could have been removed in the meantime....
            (wg := confirmButton windowGroup) notNil ifTrue:[
                confirmButton beVisible.
                wg repairDamage.

                [ confirmed ] whileFalse:[
                    self window topView raiseDeiconified.
                    3 timesRepeat:[ l beep. Delay waitForSeconds:0.4 ].
                    Delay waitForSeconds:5.
                ].

                l viewBackground:Color green.
            ].
        ]
    ] fork.

    "Modified: / 16-11-2010 / 14:54:05 / cg"
    "Modified (comment): / 05-07-2011 / 14:30:48 / cg"
!

addTerminal
    | v termView |

    (OperatingSystem isUNIXlike 
            "/ mhm - xterm embedding seems to no longer work; the default from user prefs is therefore false
            and:[UserPreferences current useXTermViewIfAvailable 
            and:[XTermView notNil 
            and:[XTermView isAvailable]]]) ifTrue:[
        v := termView := XTermView new
    ] ifFalse:[
        VT100TerminalView isNil ifTrue:[
            Dialog warn:('Missing class: ' , 'VT100TerminalView' allBold).
            AbortOperationRequest raise 
        ].
        v := (HVScrollableView for:VT100TerminalView).
        termView := v scrolledView.
        v autoHideScrollBars:false.
        v horizontalMini:true.
        "/ the startShell seems to realize the view, which is not allowed.
        "/ do it later (after adding to myself)
"/        termView startShellIn: Filename currentDirectory asString.
    ].

    self addWindow:v named:'Terminal%1' tabIcon:(ToolbarIconLibrary console13x13Icon).

    termView shellTerminateAction:[ termView cr; nextPutLine:'*** shell terminated ***' allBold; cr.].
    termView startShellIn: Filename currentDirectory asString.

    "Modified: / 09-12-2010 / 23:22:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 14:42:39 / cg"
!

addWebBrowser
    |view browser|

    browser := Tools::WebBrowserPage new.
    browser toolBarVisibleHolder value:false.
    view := ApplicationSubView new.
    view client:browser spec:#windowSpec.
    self addWindow:view named:'Web Browser %1'.

    "Created: / 10-06-2011 / 23:27:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-07-2011 / 14:30:59 / cg"
    "Modified: / 10-05-2012 / 18:49:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addWorkspaceVariable
    |name selectedWorkspacesTextView selection|

    selectedWorkspacesTextView := self selectedWorkspacesTextView.
    selectedWorkspacesTextView notNil ifTrue:[
        selection := selectedWorkspacesTextView selection.
    ].

    name := Dialog 
                request:'Name of new Workspace Variable:'
                initialAnswer:(selection ? '') asString string
                okLabel:'Add'
                title:'Enter Variable Name'.
    name size == 0 ifTrue:[
        ^ self
    ].
    Workspace addWorkspaceVariable:name.

    "Modified: / 24-11-2006 / 12:44:16 / cg"
!

addWorkspaceVariableInspector
    |v|

    v := self addInspectorOn:(Workspace workspaceVariables) basic:false suppressPseudoSlots:true.
    v dereferenceValueHolders:true.
    v fieldListLabel:'Name'.
    self renameWorkspace:(self selectedWorkspaceIndexHolder value) to:'Workspace Variables'.
!

menuAddBookmarkTo: folder

    | ws file |

    ws := self selectedWorkspace scrolledView.
    ws isTextView ifTrue:[
        file := ws defaultFileNameForFileDialog.
        file ifNotNil:[folder add: (Bookmark forFile: file)].
        folder model save.
    ] ifFalse:[
        self shouldImplement
    ]

    "Created: / 21-06-2011 / 08:56:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspaceApplication methodsFor:'menu-actions-editing'!

babelFishTranslate:fromToModeString
    "translate the selected text and paste it after the selection.
     This is now obsolete, as that web service no longer exists (sigh)"

    SOAP::BabelFishClient isNil ifTrue:[
        Dialog information:'Sorry the SOAP-BabelFish translation-client is not available'.
        ^ self.
    ].
    self selectedWorkspace babelFishTranslate:fromToModeString

    "Modified: / 01-12-2010 / 12:24:34 / cg"
!

changesBrowserOnText
    (UserPreferences current changeSetBrowserClass) 
        openOn:(ChangeSet fromStream:self selectedWorkspacesTextView contentsAsString readStream)

    "Created: / 27-08-2007 / 10:57:30 / cg"
!

editBookmarks

    BookmarkListEditor new
        bookmarkList: self bookmarks;
        open.

    "Created: / 20-06-2011 / 22:34:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editModeInsert
    self selectedWorkspace editModeInsert

    "Created: / 22-01-2011 / 11:51:12 / cg"
!

editModeInsertAndSelect
    self selectedWorkspace editModeInsertAndSelect

    "Created: / 22-01-2011 / 11:52:52 / cg"
!

editModeOverwrite
    self selectedWorkspace editModeOverwrite

    "Created: / 22-01-2011 / 11:52:15 / cg"
!

fileInText
    "filein the selected workspace's contents as if read from a file"

    self selectedWorkspacesTextView contentsAsString readStream fileIn
!

filterText
    "a filterblock is asked for, which is applied to the
     selected line range.
     Each line for which the filter evaluats to false is removed"

    |template filterBlock newList oldList answer nDeleted deletedLines
     prevLine nextLine line|

    template := self class filterTemplate.

    filterBlock := self askForFilterBlock:'Filter block (to remove lines):'
                        template:template
                        rememberIn:#LastFilterBlockString.
    filterBlock isNil ifTrue:[^ self].

    oldList := self selectedWorkspacesTextView list.
    newList := StringCollection new.
    deletedLines := OrderedCollection new.

    oldList notEmptyOrNil ifTrue:[
        line := nil.
        nextLine := oldList at: 1.
        1 to: oldList size do:[:lineNr |
            prevLine := line.
            line := nextLine.
            nextLine := oldList at: lineNr + 1 ifAbsent: nil.

            (filterBlock 
                value:(line ? '') 
                value: lineNr 
                value: (prevLine ? '')  
                value: (nextLine ? '') 
            ) ifTrue: [
                newList add: line
            ] ifFalse:[
                deletedLines add: line.
            ]
        ].

        newList := newList collect:[:line | (line isString and:[line size == 0]) ifTrue:[nil] ifFalse:[line]].
    ].

    nDeleted := deletedLines size.
    nDeleted == 0 ifTrue:[
        self information:'No lines were deleted.'.
        ^ self
    ].

    answer := OptionBox 
                request:(resources 
                        string:'%1 lines remain (%2 deleted). Change text ?'
                        with:newList size
                        with:nDeleted)
                buttonLabels:#( 'Cancel' 'No, Show Deleted' 'Yes, but Show Deleted' 'Yes')
                values:#(nil false yesAndShow true)
                default:true.
    answer isNil ifTrue:[^ self].
    (answer ~~ true) ifTrue:[
        TextBox openOn:(deletedLines asStringCollection) title:'Filtered lines'.
        (answer == false) ifTrue:[
            ^ self.
        ].
    ].

    self selectedWorkspacesTextView list:newList.

    "Modified: / 04-05-2012 / 16:03:32 / cg"
!

generateText
    "a generatorblock is asked for, which is evaluated to generate
     lines onto an output stream.
     The generated text is inserted (or replaces the current selection)"

    |template generatorBlock oldText outStream|

    template := self class generatorTemplate.

    generatorBlock := self askForFilterBlock:'Generator block (to insert text):'
                        template:template
                        rememberIn:#LastGeneratorBlockString.
    generatorBlock isNil ifTrue:[^ self].

    oldText := self selectedWorkspacesTextView selection.
    outStream := '' writeStream.
    generatorBlock
                value:outStream
                value:oldText.

    self selectedWorkspacesTextView pasteOrReplace:(outStream contents).
!

googleSpellingSuggestion
    self selectedWorkspacesTextView googleSpellingSuggestion
!

indent
    self selectedWorkspacesTextView indentBy4.
!

pasteLastDoIt
    |s|

    s := self lastDoItsString.
    s notNil ifTrue:[
        self paste:s
    ]
!

processText
    "a block is asked for, which is applied to each line of the selected line range.
     Each line is replaced by the corresponding output of the processing block"

    |template filterBlock newList oldList answer nChanged changedLines flags|

    template := self class textProcessorTemplate.

    filterBlock := self askForFilterBlock:'Processing block:'
                        template:template
                        rememberIn:#LastProcessingBlockString.
    filterBlock isNil ifTrue:[^ self].

    oldList := self selectedWorkspacesTextView list.
    oldList := oldList collect:[:lineOrNil | lineOrNil ? ''].
    newList := oldList collect:[:line | |newLine|
                newLine := line.
                Error handle:[:ex |
                ] do:[
                    newLine := filterBlock value:line
                ].
                newLine
               ].
    newList := newList collect:[:line | (line isString and:[line size == 0]) ifTrue:[nil] ifFalse:[line]].

    flags := (1 to:oldList size) collect:[:i | (oldList at:i) ~= (newList at:i)].
    flags := flags select:[:flag | flag].
    nChanged := flags size.
    nChanged == 0 ifTrue:[
        self information:'No lines were changed.'.
        ^ self
    ].

    answer := Dialog confirmWithCancel:(resources 
                        string:'%1 lines changed. Change text ?'
                        with:nChanged)
                labels:#( 'Cancel' 'No, Show Changed' 'Yes').
    answer isNil ifTrue:[^ self].
    answer ifFalse:[
        changedLines := (1 to:oldList size) select:[:i | (oldList at:i) ~= (newList at:i)].
        changedLines := changedLines collect:[:i | (newList at:i)].
        TextBox openOn:(changedLines asStringCollection) title:'Changed lines'.
        ^ self.
    ].

    self selectedWorkspacesTextView list:newList.
!

undent
    self selectedWorkspacesTextView undentBy4.
! !

!WorkspaceApplication methodsFor:'menu-dynamic'!

bookmarkMenu
    <resource: #programMenu >

    | menu item |

    menu := self bookmarks asMenuUsingBuilder: (BookmarkMenuBuilder new resources:resources).
    menu hasItems ifTrue:[menu addSeparator].

    item := MenuItem 
                label:(resources string:'Add Bookmark')
                itemValue:#addBookmark
                enabled:[self canAddBookmark].
    menu addItem: item.

    menu addSeparator.
    
    item := MenuItem 
                label:(resources string:'Edit Bookmarks')
                itemValue:#editBookmarks.
    menu addItem: item.
    ^menu

    "Created: / 20-06-2011 / 22:21:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2011 / 08:05:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-09-2012 / 13:25:48 / cg"
!

editModeInfoLabelMenu
    ^ self class editModeInfoLabelMenu

    "Created: / 22-01-2011 / 11:50:35 / cg"
!

languageListMenuSlice
    "dynamicall generate a slice containing the available
     programming languages"
     
    <resource: #programMenu >

    |m allLanguages |

    allLanguages := OrderedCollection new.
    ProgrammingLanguage allDo:[:eachLanguage |
        eachLanguage isSmalltalk ifFalse:[
            allLanguages add:eachLanguage
        ]
    ].
    allLanguages sort:[:a :b | a name < b name].

    m := Menu new.
    m addItem:((MenuItem 
                label:'Text'
                choice: #syntaxHolder
                choiceValue:nil)
                itemValue:#syntaxChangedByUser).
    m addItem:((MenuItem
                label:'Smalltalk'
                choice:#syntaxHolder
                choiceValue:SmalltalkLanguage instance)
                translateLabel:false;
                enabled: self canChangeLanguageHolder).

"/    allLanguages notEmpty ifTrue:[
"/        m addItem:(MenuItem separator).

        allLanguages do:[:eachLanguage |
            "JV@2012-02-18: Add language only iff it supports
             evaluation (most of then do, but some may not -
             such as Java)"
            (eachLanguage isJava not 
                "/ Java is funny - we don't have an evaluator for Java
                "/ but we have to define evaluatorClass to return GroovyEvaluator
                "/ to be able to inspect code in debugger/inspector. Hence this hack.
                "/ We may need something like evaluatorClassForInspector/Debugger.
                and:[eachLanguage evaluatorClass notNil
                and:[true "eachLanguage evaluatorClass canUnderstand: #evaluate:in:receiver:notifying:logged:ifFail:"]
            ]) 
            ifTrue:[
                m addItem:((MenuItem
                            label:(eachLanguage name)
                            choice:#syntaxHolder
                            choiceValue:eachLanguage)
                            translateLabel:false;
                            enabled: self canChangeLanguageHolder).
            ].
        ].
"/    ].
    ^ m

    "Modified: / 04-02-2012 / 11:52:07 / cg"
    "Modified: / 29-08-2013 / 12:18:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeRecentDoItsMenuFor:aSelector
    <resource: #programMenu >

    |doIts m cmdLabelLen|

    cmdLabelLen := 40.

    doIts := Workspace doItHistory.
    doIts size > 0 ifTrue:[
        m := Menu new.
        doIts do:[:doItEntry |
            |lines label item|

            lines := doItEntry withoutLeadingSeparators asStringCollection.
            label := lines first.
            (label size > cmdLabelLen) ifTrue:[
                label := (label contractTo:cmdLabelLen)
            ]. 
            (lines size > 1) ifTrue:[
                label := label , ' [...]'
            ].
            label := '''' , label , ''''.

            item := MenuItem label:label itemValue:aSelector argument:doItEntry.
            m addItem:item.
        ].
        m addSeparator.
        m addItem: (MenuItem new 
                    label: (resources string:'Clear History') 
                    itemValue: #clearHistory
                    translateLabel:false;
                    activeHelpKey: #historyEmptyMenu ).
   ].
   ^ m

    "Modified: / 09-09-2012 / 13:25:30 / cg"
!

namespaceInfoLabelMenu
    |m allNamespaces|

    allNamespaces := NameSpace allNameSpaces asNewOrderedCollection.
    allNamespaces sort:[:a :b | a name < b name].
    allNamespaces remove:Smalltalk.
    allNamespaces addFirst:Smalltalk.

    m := Menu new.

    allNamespaces do:[:eachNameSpace |
        m addItem:((MenuItem 
                    label:(eachNameSpace name) 
                    choice: #namespaceHolder
                    choiceValue:eachNameSpace)
                    translateLabel:false;
                    itemValue:#namespaceChangedByUser).
        eachNameSpace == Smalltalk ifTrue:[
            m addSeparator
        ].
    ].
    ^ m
!

namespaceInfoLabelMenuHolder
    ^ [self namespaceInfoLabelMenu]
!

pasteRecentDoItMenu
    <resource: #programMenu >

    ^ self recentDoItsMenuFor:#'paste:'
!

recentDoItsMenuFor:aSelector
    <resource: #programMenu >

    ^ [
        self makeRecentDoItsMenuFor:aSelector
    ].
!

redoRecentDoItMenu
    <resource: #programMenu >

    ^ self recentDoItsMenuFor:#'pasteAndExecute:'
! !

!WorkspaceApplication methodsFor:'private'!

askIfAnyModified:question yesButton:yesButtonText
    |someModifiedWorkspace index label|

    someModifiedWorkspace := workspaces detect:[:aView | self isModifiedWorkspace:aView]
                                        ifNone:nil.
    someModifiedWorkspace isNil ifTrue:[^ true].

    index := workspaces indexOf:someModifiedWorkspace.
    label := tabList at:index ifAbsent:'Edit Window'.

    (Dialog 
        confirm:(resources stringWithCRs:question with:label)
        yesLabel:(resources string:yesButtonText)
        noLabel:(resources string:'Cancel'))
    ifTrue:[
        "/ reset modified flag so question is asked only once
        workspaces 
            select:[:aView | (self isModifiedWorkspace:aView)]
            thenDo:[:eachModifiedTextView |
                        eachModifiedTextView 
                                perform:#modified: with:false
                                ifNotUnderstood:[].
                    ].
        ^ true
    ].
    ^ false
!

compilerClassForSyntaxName:syntax
    syntax == #Smalltalk ifTrue:[
        ^ Compiler
    ].
    syntax == #JavaScript ifTrue:[
        ^ JavaScriptCompiler
    ].
    ^ Compiler
!

compilerClassOf:aWorkspace
    |compilerClass|

    [    
        "/ catch, because it could be a non-edit view there (VT100, TeaTimer etc.)
        compilerClass := aWorkspace compilerClass. 
    ] on:MessageNotUnderstood do:[].
    ^ compilerClass
!

createEvaluationWorkspace
    |ws l b box resultView environmentView panel workspaceVariables timeLabel|

    workspaceVariables := Workspace workspaceVariables.

    panel := VariableVerticalPanel new.
    panel showHandle:true.

      box := View new.
      l := Label new.
      l label:(resources string:'Eval:').
      l layout:((0.0@0.0 corner:0.5@0.0) asLayout bottomOffset:22).
      l adjust:#left.
      box add:l.

      ws := HVScrollableView for:Workspace.
      ws scrolledView name:#'Workspace'.  
      ws autoDefineVariables:#workspace.
      ws layout:((0.0@0.0 corner:1.0@1.0) asLayout topOffset:22; bottomOffset:-22).
      box add:ws.

      b := Button new.
      b label:'DoIt'.
      b layout:((0.25@1.0 corner:0.5@1.0) asLayout topOffset:-22).
      b adjust:#left.
      b action:[ws doIt].
      box add:b.

      b := Button new.
      b label:'InspectIt'.
      b layout:((0.5@1.0 corner:0.75@1.0) asLayout topOffset:-22).
      b adjust:#left.
      b action:[ws inspectIt].
      box add:b.

      b := Button new.
      b label:'BrowseIt'.
      b layout:((0.75@1.0 corner:1.0@1.0) asLayout topOffset:-22).
      b adjust:#left.
      b action:[ws browseIt].
      box add:b.

    panel add:box.

      box := View new.
      box add:(Label new label:(resources string:'Value:'); adjust:#left; layout:((0.0@0.0 corner:0.5@0.0) asLayout bottomOffset:22)).
      box add:(timeLabel := Label new label:''; adjust:#right; layout:((0.5@0.0 corner:1.0@0.0) asLayout bottomOffset:22)).
      resultView := HVScrollableView for:TextCollector.
      box add:(resultView layout:((0@0 corner:1.0@1.0) asLayout topOffset:22); yourself).

    panel add:box.

      box := View new.
      box add:(Label new label:(resources string:'Environment:'); adjust:#left; layout:((0.0@0.0 corner:1.0@0.0) asLayout bottomOffset:22)).
      environmentView := DictionaryInspectorView new.
      environmentView suppressPseudoSlots:true.
      environmentView inspect:workspaceVariables.
      environmentView dereferenceValueHolders:true.
      environmentView fieldListLabel:'Variable'.
      box add:(environmentView layout:((0@0 corner:1.0@1.0) asLayout topOffset:22); yourself).

    panel add:box.

"/     self renameWorkspace:(self selectedWorkspaceIndexHolder value) to:'Eval'.

    ws doItAction:[:theCode |
        |t result resultString|

        t := TimeDuration toRun:[
            result := ws executeDoIt:theCode.
        ].
        timeLabel label:(resources string:'Exec. Time: %1' with:t printString).

        resultString := [
                            result storeString
                        ] on:Error do:[
                            result printString
                        ].  
                        
        resultView showCR:resultString.
        Workspace rememberResultAsWorkspaceVariable:result.
        environmentView doUpdate.
        result.
    ].
    panel relativeCorners:#(0.4 0.6 1.0).
    ^ panel

    "Modified: / 24-11-2006 / 11:06:33 / cg"
!

createWorkspace
    |ws|

    ws := self createWorkspaceView.
    ws autoDefineVariables:self autoDefineVariables value.
    ws poolsConsideredInDoIts:poolsConsideredInDoIts.
    ^ ws

    "Modified (format): / 05-07-2011 / 14:18:52 / cg"
    "Modified: / 18-03-2012 / 23:37:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createWorkspaceView
    |ws language|

    ws := self class createWorkspaceView.

    ws codeAspect: SyntaxHighlighter codeAspectExpression.
    ws acceptAction:[:code | self menuSave ].

"/    (ws respondsTo:#languageHolder:) ifTrue:[
"/        ws languageHolder:self syntaxHolder
"/    ].
    language := self syntaxHolder value ? Smalltalk programmingLanguage.
    language notNil ifTrue:[
        ws compilerClass:(language evaluatorClass).
        ws editedLanguage:language.
    ].
    ^ ws

    "Modified: / 19-07-2012 / 16:39:15 / cg"
    "Modified: / 21-08-2012 / 17:20:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createWorkspaceViewForText
    "creates a language unaware workspace"

    |ws|

    ws := self class createWorkspaceView.

    ws acceptAction:[:code | self menuSave ].
"/    (ws respondsTo:#languageHolder:) ifTrue:[
"/        ws languageHolder:nil
"/    ].
    ws compilerClass:(Smalltalk programmingLanguage).
    ws editedLanguage:nil.
    ws codeAspect:nil.
    ^ ws
!

isModifiedWorkspace:aView 
    |view|

    aView isNil ifTrue:[
        ^ false
    ].
    view := self workspaceViewOfView:aView.
    (view isNil 
        or:[ view modified not 
        or:[ view contentsWasSaved 
        or:[ view contents withoutSeparators isEmpty ]]]) 
    ifTrue:[ 
        ^ false 
    ].
    ^ true

    "Modified: / 03-06-2011 / 11:03:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-07-2011 / 15:01:08 / cg"
!

lastDoItsString
    |history|

    history := Workspace doItHistory.
    history size > 0 ifFalse:[
        self selectedWorkspacesTextView flash.
        ^ nil
    ].
    ^ history first
!

syntaxFromEvaluatorClass:aClass
    "knowing the evaluator class, determine the syntax highlighter class"

    aClass notNil ifTrue:[
        ProgrammingLanguage allDo:[:lang | 
            lang evaluatorClass = aClass ifTrue:[
                ^ lang
            ]
        ].
    ].
    "Unknown language - should not happen :-)"
    ^ nil

    "Created: / 26-04-2012 / 12:59:32 / cg"
!

workspaceSelectionChanged
    "attach line, col and mode holders to the current workspace window"

    |compilerClass selectedWorkspace selectedWorkspaceApp |

    "JV@2012-05-10: Modified to better support complex application models as tabs"

    super workspaceSelectionChanged.

    selectedWorkspace := self selectedWorkspace.
    selectedWorkspaceApp  := self selectedWorkspaceApplication.

    (selectedWorkspace notNil and:[selectedWorkspace isScrollWrapper]) ifTrue:[
        selectedWorkspace := selectedWorkspace scrolledView
    ].

    compilerClass := self compilerClassOf: selectedWorkspaceApp ? selectedWorkspace.
    self canChangeLanguageHolder value:
        (selectedWorkspaceApp ? selectedWorkspace respondsTo: #compilerClass:).

    self syntaxHolder value:(self syntaxFromEvaluatorClass:compilerClass).

    (selectedWorkspace notNil and:[ selectedWorkspace scrolledView isTextView or:[selectedWorkspaceApp notNil] ]) ifTrue:[
        self cursorLineAndColumnLabelHolder valueHolder:( selectedWorkspaceApp ? selectedWorkspace perform:#cursorLineAndColumnLabelHolder ifNotUnderstood:nil ).
        self cursorLineHolder valueHolder:( selectedWorkspaceApp ? selectedWorkspace perform:#cursorLineHolder ifNotUnderstood:nil ).
        self cursorColHolder valueHolder:( selectedWorkspaceApp ? selectedWorkspace perform:#cursorColHolder ifNotUnderstood:nil ).
        self modeLabelHolder valueHolder:( selectedWorkspaceApp ? selectedWorkspace perform:#modeLabelHolder ifNotUnderstood:nil ).
    ] ifFalse:[
        self cursorLineAndColumnLabelHolder valueHolder:nil.
        self cursorLineHolder valueHolder:nil.
        self cursorColHolder valueHolder:nil.
        self modeLabelHolder valueHolder:nil.
    ].

    "Update toolbar"
    (selectedWorkspaceApp notNil 
    and:[ (selectedWorkspaceApp class respondsTo: #toolBarSpec) ]) ifTrue:[
        "/ client provides one
        self toolBarView client: selectedWorkspaceApp spec: #toolBarSpec
    ] ifFalse:[
        "/ I provide it
        self toolBarView client: self spec: #toolBarSpec builder: builder.
    ]
! !

!WorkspaceApplication methodsFor:'special startup'!

openSystemWorkspace
    "create the tabs for the initial welcome system workspace"

    |path needRemove font|

    needRemove := true.

    self allButOpen.

    (self builder componentAt:'NoteBook')
        destroyTabAction:[:tabIndex| self removeWorkspace:tabIndex].

    self window extent:640@400.

    path := (Smalltalk getSystemFileName:'README') ?  '../../README'.
    path := path asFilename.
    path isReadable ifTrue:[
        self addWindow:(self createWorkspaceViewForText) named:'README' asFirst:false.
        self loadFile:path.
        self removeWorkspace:1.  "/ the original Workspace
        self renameWorkspace:1 to:'LICENCE README'.
        needRemove := false.
    ].

"/    path := (Smalltalk getSystemFileName:'doc/online/english/LICENCE_STX.html') ?  '../../doc/online/english/LICENCE_STX.html'.
"/    path asFilename exists ifTrue:[
"/        self addWindow:(licenceView := HVScrollableView for:HTMLDocumentView) named:'License' asFirst:false.
"/        licenceView homeDocument:'../../doc/online/english/LICENCE_STX.html'.
"/        licenceView updateLabelFlag:false.
"/        needRemove ifTrue:[self removeWorkspace:1].  "/ the original Workspace
"/        needRemove := false.
"/    ].

    device platformName == #X11 ifTrue:[
"/        font := Font family:'DejaVuSansMono' face:'medium' style:'roman' size:16 encoding:'iso10646-1'.
"/        font := font onDevice:device ifAbsent:nil.
        font isNil ifTrue:[    
            font := Font family:'FreeMono' face:'regular' style:'roman' size:16 encoding:'iso10646-1'.
            font := font onDevice:device ifAbsent:nil.
            font isNil ifTrue:[    
                font := Font family:'unifont' face:'medium' style:'roman' size:16 encoding:'iso10646-1'.
                font := font onDevice:device ifAbsent:nil.
                font isNil ifTrue:[    
                    font := Font family:'arial' face:'medium' style:'roman' size:12 encoding:'iso10646-1'.
                    font := font onDevice:device ifAbsent:nil.
                ].
            ].
        ].
    ] ifFalse:[
        "/ font := Font family:'Arial Unicode MS' face:'medium' style:'roman' size:10 encoding:'ms-ansi'.
        font := Font family:'arial' face:'medium' style:'roman' size:10 encoding:'ms-ansi'.
        font := font onDevice:device ifAbsent:nil.
    ].

    #(  "/ file                     resourceKey             title                       forcedEncoding  type
        ('Hello_utf8.wsp'           HELLO_UTF_FILE          'Hello'                     #'utf8'         #text)
        ('Welcome.wsp'              WELCOME_FILE            'This Release'              nil             #text)
"/        ('Setup.wsp'                SETUP_FILE              'Setup'                     nil             #text)
        ('Keyboard.wsp'             KEYBOARD_FILE           'Keyboard'                  nil             #text)
"/        ('GettingStarted.wsp'       GETTING_STARTED_FILE    'Getting Started'           nil             #text)
        ('../../doc/online/english/GettingStarted.html'   GETTING_STARTED_TML_FILE  'Getting Started'           nil             #html)
        ('../../doc/books/JoyOfST/IntroToST.html'         INTRO_TO_ST_FILE          'Smalltalk Introduction'    nil             #html)
    "/ if these are present, show them.
        ('Private.wsp'              PRIVATE_FILE            'Private Workspace'         nil             #code)
        ('MyWorkspace.wsp'          MYWORKSPACE_FILE        'My Workspace'              nil             #code)
        ('PackageLoading.wsp'       PACKAGELOADING_FILE     'Packages'                  nil             #code)
    ) do:[:tuple |
        |file resKey title forcedEncoding type pane encoding htmlView|

        file := tuple at:1.
        resKey := tuple at:2.
        file := self resources string:resKey default:file.

        title := tuple at:3.
        forcedEncoding := tuple at:4.
        type := tuple at:5.

        path := Smalltalk getSystemFileName:file.
        (path notNil and:[path asFilename isReadable]) ifTrue:[
            type == #html ifTrue:[
                self addWindow:(htmlView := HVScrollableView for:HTMLDocumentView) named:title asFirst:false.
                htmlView homeDocument:path.
                htmlView infoHolder:self infoLabelHolder.
                htmlView updateTopViewsTitleFlag:false.
            ] ifFalse:[
                type == #code ifTrue:[
                    self addWindow:(pane := self createWorkspaceView) named:title asFirst:false.
                ] ifFalse:[
                    self addWindow:(pane := self createWorkspaceViewForText) named:title asFirst:false.
                ].
                forcedEncoding notNil ifTrue:[
                    encoding := forcedEncoding.
                    font notNil ifTrue:[
                        pane font:font.
                    ]
                ] ifFalse:[
                    encoding := CharacterEncoder guessEncodingOfFile:path.
                    (encoding == #'iso8859-1' or:[encoding == #'ascii']) ifTrue:[
                        encoding := nil
                    ].
                ].
                self loadFile:path encoding:encoding label:title.
            ].
            needRemove ifTrue:[self removeWorkspace:1].  "/ the original Workspace
            needRemove := false.
        ].
    ].
    self openWindow.
    self selectedWorkspaceIndexHolder value:2.

    "
     |ws b|
     ws := self openSystemWorkspace.
     ws addMyWorkspace.
     ws selectedWorkspaceIndexHolder value:(ws workspaces size).
     ws selectedWorkspace contents:'Tools::NewSystemBrowser open'; selectAll.
     ws selectedWorkspace 
        add:(b := Button label:'DoIt' action:[ws doIt. b destroy])
    "
    "
     |ws b|
     ws := self new.
     ws open. 
     ws selectedWorkspace contents:'Tools::NewSystemBrowser open'; selectAll.
    "

    "Modified: / 14-02-2010 / 23:02:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 15:34:40 / cg"
! !

!WorkspaceApplication methodsFor:'user actions'!

infoVisibilityChanged
    super infoVisibilityChanged.
    UserPreferences current infoVisibleInWorkspace:(self infoVisibleHolder value)

    "Created: / 14-07-2007 / 16:46:58 / cg"
!

namespaceChangedByUser
    "remember as default for next new workspace"

    LastNamespace := self namespaceHolder value.
!

syntaxChangedByUser
    "remember as default for next new workspace"
    LastLanguage := self syntaxHolder value.

    "Created: / 26-04-2012 / 12:31:04 / cg"
!

toolBarVisibilityChanged
    super toolBarVisibilityChanged.
    UserPreferences current toolbarVisibleInWorkspace:(self toolBarVisibleHolder value).
    UserPreferences current editToolbarVisibleInWorkspace:(self editToolBarVisibleHolder value).

    "Created: / 14-07-2007 / 16:45:31 / cg"
! !

!WorkspaceApplication class methodsFor:'documentation'!

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

