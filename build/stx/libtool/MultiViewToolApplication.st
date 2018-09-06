"
 COPYRIGHT (c) 2004 by eXept Software AG
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

ToolApplicationModel subclass:#MultiViewToolApplication
	instanceVariableNames:'workspaces tabList selectedWorkspaceIndexHolder workspaceHolder'
	classVariableNames:'DefaultInfoVisible DefaultEditToolBarVisible
		DefaultToolBarVisible'
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!MultiViewToolApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    Common code for multiView applications (Workspace, Terminal app and maybe more later)

    [author:]
        Claus Gittinger
"
! !

!MultiViewToolApplication class methodsFor:'defaults'!

defaultEditToolbarVisible
    ^ DefaultEditToolBarVisible ? false

    "Created: / 14-07-2007 / 16:38:47 / cg"
!

defaultInfoVisible
    ^ DefaultInfoVisible ? true

    "Created: / 14-07-2007 / 16:38:32 / cg"
!

defaultToolbarVisible
    ^ DefaultToolBarVisible ? false

    "Created: / 14-07-2007 / 16:38:47 / cg"
! !

!MultiViewToolApplication class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#addWorkspace
'Add another page (tab)'

#hideToolBar
'Hide the toolbar. Show again via the "View"-menu'

#hideEditToolBar
'Hide the edit-toolbar. Show again via the "View"-menu'

)

    "Modified: / 06-07-2011 / 18:08:57 / cg"
! !

!MultiViewToolApplication class methodsFor:'image specs'!

hideToolBarIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary hideToolBarIcon

    "Created: / 18-02-2007 / 14:53:38 / cg"
! !

!MultiViewToolApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MultiViewToolApplication andSelector:#windowSpec
     MultiViewToolApplication new openInterface:#windowSpec
     MultiViewToolApplication open
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
                 (MenuPanelSpec
                    name: 'ToolBarMenu'
                    layout: (LayoutFrame 13 0.0 0 0.0 0 1.0 0 1.0)
                    visibilityChannel: toolBarVisibleHolder
                    menu: toolBarMenu
                    textDefault: true
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
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              model: selectedWorkspaceIndexHolder
              menu: tabList
              useIndex: true
              accessTabMenuAction: tabMenuAt:
              destroyTabAction: destroyTab:
              canvas: workspaceHolder
              canvasInset: 0
              keepCanvasAlive: true
              tabLevel: 1
            )
           )
         
        )
      )

    "Modified: / 11-05-2012 / 11:43:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MultiViewToolApplication class methodsFor:'menu specs'!

editToolBarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MultiViewToolApplication andSelector:#toolBarMenu
     (Menu new fromLiteralArrayEncoding:(MultiViewToolApplication toolBarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         )
        nil
        nil
      )

    "Modified: / 18-02-2007 / 14:59:21 / cg"
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MultiViewToolApplication andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(MultiViewToolApplication mainMenu)) startUp
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
                  label: 'New Editor'
                  itemValue: newWorkspace
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Load File...'
                  itemValue: menuLoad
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Save As...'
                  itemValue: menuSaveAs
                  translateLabel: true
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
          )
         (MenuItem
            label: 'Buffers'
            nameKey: Buffer
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Add Buffer'
                  itemValue: addWorkspace
                  translateLabel: true
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
          )
         (MenuItem
            label: 'Edit'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasSelectionInActiveWorkspace
                  label: 'Cut'
                  itemValue: cutSelection
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasSelectionInActiveWorkspace
                  label: 'Copy'
                  itemValue: copySelection
                  translateLabel: true
                )
               (MenuItem
                  label: 'Paste'
                  itemValue: paste
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Select All'
                  itemValue: selectAll
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
            submenuChannel: viewMenu
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

tabMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:WorkspaceApplication andSelector:#tabMenu
     (Menu new fromLiteralArrayEncoding:(WorkspaceApplication tabMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Add Tab'
            #translateLabel: true
            "/ #triggerOnDown: true
            #value: #addWorkspace
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Remove Tab'
            #translateLabel: true
            "/ #triggerOnDown: true
            #value: #removeWorkspace:
            #enabled: #canRemoveWorkspace:
          )
         #(#MenuItem
            #label: 'Remove all other Tabs'
            #translateLabel: true
            "/ #triggerOnDown: true
            #value: #removeAllWorkspacesExcept:
            #enabled: #canRemoveAllWorkspacesExcept:
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Rename...'
            #translateLabel: true
            "/ #triggerOnDown: true
            #value: #renameWorkspace:
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
     MenuEditor new openOnClass:MultiViewToolApplication andSelector:#toolBarMenu
     (Menu new fromLiteralArrayEncoding:(MultiViewToolApplication toolBarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: ''
          )
         (MenuItem
"/            activeHelpKey: addWorkspace
            label: 'Add Buffer'
            itemValue: addWorkspace
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary addBufferIcon)
          )
         )
        nil
        nil
      )

    "Modified: / 18-02-2007 / 14:59:21 / cg"
!

viewMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:MultiViewToolApplication andSelector:#viewMenu
     (Menu new fromLiteralArrayEncoding:(MultiViewToolApplication viewMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Toolbar'
            hideMenuOnActivated: false
            indication: toolBarVisibleHolder
          )
         (MenuItem
            label: 'Editor Toolbar'
            isVisible: hasEditToolBar
            hideMenuOnActivated: false
            indication: editToolBarVisibleHolder
          )
         (MenuItem
            label: 'Info'
            isVisible: hasInfoLabel
            hideMenuOnActivated: false
            indication: infoVisibleHolder
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Font...'
            itemValue: openFontDialog
          )
         (MenuItem
            label: 'Settings...'
            itemValue: openSettingsDialog
          )
         )
        nil
        nil
      )
! !

!MultiViewToolApplication class methodsFor:'queries'!

isAbstract
    ^ self == MultiViewToolApplication
!

isVisualStartable
    "return true, if this application can be started via #open.
     (to allow start of a change browser via double-click in the browser)"

    self == MultiViewToolApplication ifTrue:[^false].
    ^ super isVisualStartable
! !

!MultiViewToolApplication methodsFor:'accessing'!

selectedWorkspace
    |wsIndex|

    workspaces isNil ifTrue:[
        workspaces := OrderedCollection new.
    ].
    wsIndex := self selectedWorkspaceIndexHolder value.
    wsIndex == 0 ifTrue:[
        ^ nil
    ].

    workspaces size < wsIndex ifTrue:[
        workspaces grow:wsIndex.
        workspaces at:wsIndex put:(self createWorkspace).
    ].
    ^ workspaces at:wsIndex
!

selectedWorkspaceApplication
    "Return an aoplication of selected workspace or nil,
     is currently selected workspace is not an embedded
     ApplicationModel"

    | ws |
    ws := self selectedWorkspace.
    ^(ws notNil and:[ws isApplicationSubView]) ifTrue:[
        ws application
    ] ifFalse:[
        nil
    ]

    "Created: / 11-05-2012 / 09:38:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tabMenuAt:index
    <resource: #programMenu>

    |m i ws|

    m := self class tabMenu.
    m := m decodeAsLiteralArray.

    i := m detectItem:[:item | item value == #removeWorkspace:] ifNone:nil.
    i notNil ifTrue:[
        i argument:index.
        index ~~ self selectedWorkspaceIndexHolder value ifTrue:[
            "/ for now: if that buffer is modified, do not allow removing.
            "/ (must be brought to front, in order for check-for-modification to work)
            ws := workspaces at:index.
            ws isScrollWrapper ifTrue:[
                ws := ws scrolledView
            ].
            (ws isTextView not
             or:[ ws modified ]) ifTrue:[
                i disable
            ].
        ].
    ].

    i := m detectItem:[:item | item value == #removeAllWorkspacesExcept:] ifNone:nil.
    i notNil ifTrue:[
        i argument:index.
        "/ for now: if any buffer is modified, do not allow removing.
        "/ (must be brought to front, in order for check-for-modification to work)
        workspaces doWithIndex:[:wsArg :idx |
            |ws|

            idx ~~ index ifTrue:[
                ws := wsArg.
                ws isScrollWrapper ifTrue:[
                    ws := ws scrolledView
                ].
                (ws isTextView and:[ ws modified ]) ifTrue:[
                    i disable
                ].
            ].
        ].
    ].

    i := m detectItem:[:item | item value == #renameWorkspace:] ifNone:nil.
    i notNil ifTrue:[
        i argument:index.
    ].

    m findGuiResourcesIn:self.
    ^ m
!

workspaceHolder
    workspaceHolder isNil ifTrue:[
        workspaceHolder := ValueHolder with:(self selectedWorkspace).
    ].
    ^ workspaceHolder
!

workspaces
    ^ workspaces
! !

!MultiViewToolApplication methodsFor:'aspects'!

editToolBarVisibleHolder
    |holder|

    (holder := builder bindingAt:#editToolBarVisibleHolder) isNil ifTrue:[
        holder := self class defaultEditToolbarVisible asValue.
        builder aspectAt:#editToolBarVisibleHolder put: holder.
        holder addDependent:self.
    ].
    ^ holder

    "Created: / 18-02-2007 / 14:43:39 / cg"
    "Modified: / 14-07-2007 / 16:39:55 / cg"
!

hasEditToolBar
    ^ (self menuFor:#editToolBarMenu) decodeAsLiteralArray hasItems 
!

hasInfoLabel
    ^ false
!

infoVisibleHolder
    |holder|

    (holder := builder bindingAt:#infoVisibleHolder) isNil ifTrue:[
        holder := self class defaultInfoVisible asValue.
        builder aspectAt:#infoVisibleHolder put: holder.
        holder addDependent:self.
    ].
    ^ holder

    "Created: / 18-02-2007 / 15:01:05 / cg"
    "Modified: / 14-07-2007 / 16:39:20 / cg"
!

selectedWorkspaceIndexHolder
    selectedWorkspaceIndexHolder isNil ifTrue:[
        selectedWorkspaceIndexHolder := 1 asValue.
        selectedWorkspaceIndexHolder onChangeSend:#workspaceSelectionChanged to:self.
    ].
    ^ selectedWorkspaceIndexHolder.
!

tabList
    tabList isNil ifTrue:[
        tabList := List new.
    ].
    ^ tabList.
!

toolBarVisibleHolder
    |holder|

    (holder := builder bindingAt:#toolBarVisibleHolder) isNil ifTrue:[
        holder := self class defaultToolbarVisible asValue.
        builder aspectAt:#toolBarVisibleHolder put: holder.
        holder addDependent:self.
    ].
    ^ holder

    "Created: / 18-02-2007 / 14:43:39 / cg"
    "Modified: / 14-07-2007 / 16:39:55 / cg"
! !

!MultiViewToolApplication methodsFor:'aspects-queries'!

canRemoveAllWorkspacesExcept:idx
    ^ [ self tabList size > 1 ]
!

canRemoveWorkspace
    ^ self canRemoveWorkspace:(self selectedWorkspaceIndexHolder value)
!

canRemoveWorkspace:idx
    ^ self tabList size > 1
"/       and:[ (self workspacesTextViewAt:(self selectedWorkspaceIndexHolder value))
!

hasMultipleBuffersHolder
    ^ [ workspaces size > 1 ]
!

hasSelectionInActiveWorkspace
    |v|

    v := self selectedWorkspacesTextView.
    ^ v notNil and:[v selectionAsString size > 0]
!

hasSelectionInActiveWorkspaceAndEditorIsNotReadonly
    |v|

    v := self selectedWorkspacesTextView.
    ^ v notNil and:[v enabled and:[v selectionAsString size > 0]]
!

hasTextInActiveWorkspace
    |v|

    v := self selectedWorkspacesTextView.
    ^ v notNil 
      and:[v list notEmptyOrNil 
      and:[v list contains:[:l | l notEmptyOrNil]]] 
! !

!MultiViewToolApplication methodsFor:'change & update'!

infoVisibilityChanged
    |visible cFrame bottomOffset|

    visible := self infoVisibleHolder value.

    cFrame := builder findComponentAt:#NoteBook. "/ #CodeView.
    cFrame notNil ifTrue:[    
        visible ifFalse:[
            bottomOffset := 0.   
        ] ifTrue:[
            bottomOffset := -25.   
        ].
        cFrame layout bottomOffset:bottomOffset.   
        cFrame container notNil ifTrue:[
            cFrame containerChangedSize.
        ].
    ].
    DefaultInfoVisible := visible

    "Created: / 18-02-2007 / 15:01:55 / cg"
!

toolBarVisibilityChanged
    |toolBarVisible editToolBarVisible toolBar editToolBar noteBook topOffset|

    topOffset := 0.

    toolBar := self componentAt:#ToolBar.
    toolBar notNil ifTrue:[
        toolBarVisible := self toolBarVisibleHolder value.
        DefaultToolBarVisible := toolBarVisible.
        toolBarVisible ifTrue:[
            topOffset := topOffset + toolBar height.
        ]
    ].

    editToolBar := self componentAt:#EditToolBar.
    editToolBar notNil ifTrue:[
        editToolBar layout 
            topOffset:topOffset bottomOffset:(topOffset + editToolBar height).
        "/ force it to recompute its dimension
        editToolBar container notNil ifTrue:[
            editToolBar containerChangedSize.
        ].
        editToolBarVisible := self editToolBarVisibleHolder value.
        DefaultEditToolBarVisible := editToolBarVisible.
        editToolBarVisible ifTrue:[
            topOffset := topOffset + editToolBar height.
        ]
    ].

    noteBook := self componentAt:#NoteBook.
    noteBook notNil ifTrue:[
        noteBook layout topOffset:topOffset.
        "/ force it to recompute its dimension
        noteBook container notNil ifTrue:[
            noteBook containerChangedSize.
        ].
    ].

    "Created: / 18-02-2007 / 14:46:22 / cg"
!

update:something with:aParameter from:changedObject
    ((changedObject == self toolBarVisibleHolder)
    or:[ changedObject == self editToolBarVisibleHolder ]) ifTrue:[
        self toolBarVisibilityChanged.
        ^ self
    ].
    changedObject == self infoVisibleHolder ifTrue:[
        self infoVisibilityChanged.
        ^ self
    ].
    ^ super update:something with:aParameter from:changedObject

    "Modified: / 14-07-2007 / 16:46:14 / cg"
!

windowLabelPrefix
    |nm|

    nm := self class nameWithoutPrefix.
    (nm endsWith:'Application') ifTrue:[
        nm := nm copyButLast:'Application' size
    ].
    ^ nm
!

workspaceSelectionChanged
    |wsIndex windowLabel v prefix|

    "/ self selected
    self workspaceHolder value:(v := self selectedWorkspace).
    wsIndex := self selectedWorkspaceIndexHolder value.

    wsIndex ~~ 0 ifTrue:[
        prefix := self windowLabelPrefix.
        windowLabel := tabList at:wsIndex ifAbsent:nil.
        windowLabel notNil ifTrue:[self window label:prefix,': ',windowLabel].
    ].

    v notNil ifTrue:[ v takeFocusWhenMapped:true ]
! !

!MultiViewToolApplication methodsFor:'defaults'!

defaultFileNameForLoad
   ^ 'file.txt'

    "Created: / 25-10-2006 / 14:56:19 / cg"
!

defaultFileNameForSave
    ^ 'file.txt'

    "Modified: / 25-10-2006 / 14:54:13 / cg"
!

defaultFileNameForSaveAll
   ^ 'file.txt'

    "Modified: / 25-10-2006 / 14:55:50 / cg"
!

defaultPatternLoad
   ^ '*.txt'

    "Created: / 25-10-2006 / 14:57:18 / cg"
! !

!MultiViewToolApplication methodsFor:'initialization'!

hideToolBarButtonCreated:aButton
    aButton passiveLevel:(MenuPanel defaultLevel). 
"/    aButton passiveLevel:1.
    aButton activeLevel:-1.
    aButton backgroundColor:(MenuPanel defaultBackgroundColor).

    "Created: / 18-02-2007 / 14:48:28 / cg"
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.

    self infoVisibleHolder value ifTrue:[ self infoVisibilityChanged ].
    (self toolBarVisibleHolder value 
    or:[ self editToolBarVisibleHolder value ]) ifTrue:[ self toolBarVisibilityChanged ].

    self workspaceSelectionChanged.

    "Created: / 18-02-2007 / 15:03:08 / cg"
    "Modified: / 22-01-2011 / 11:46:35 / cg"
! !

!MultiViewToolApplication methodsFor:'menu-actions'!

addWindow:aWindow named:name
    ^ self addWindow:aWindow named:name asFirst:false
!

addWindow:aWindow named:name asFirst:asFirst
    ^ self addWindow:aWindow named:name tabIcon:nil asFirst:asFirst
!

addWindow:aWindow named:name tabIcon:iconOrNil
    ^ self addWindow:aWindow named:name tabIcon:iconOrNil asFirst:false
!

addWindow:aWindow named:name tabIcon:iconOrNil asFirst:asFirst
    |tabList tabItem wsIndex newSelectedIndex initialFocusView|

    tabList := self tabList.
    wsIndex := tabList size + 1.
    wsIndex == 1 ifTrue:[
        "/ first - add a name for the first tab
        tabList add:(self window label). "/ 'Workspace'.
        wsIndex := wsIndex + 1.
    ].

    tabItem := name bindWith:wsIndex.
    iconOrNil notNil ifTrue:[
        tabItem := LabelAndIcon icon:iconOrNil string:tabItem.
    ].

    workspaces grow:wsIndex.
    asFirst ifTrue:[
        tabList addFirst:tabItem.
        workspaces replaceFrom:2 to:wsIndex with:workspaces startingAt:1.
        newSelectedIndex := 1.
    ] ifFalse:[
        tabList addLast:tabItem.
        newSelectedIndex := wsIndex.
    ].

    (aWindow isKeyboardConsumer) ifTrue:[
        initialFocusView := aWindow.
    ] ifFalse:[
        (aWindow scrolledView isKeyboardConsumer) ifTrue:[
            initialFocusView := aWindow scrolledView
        ] ifFalse:[
            initialFocusView := aWindow scrolledView allSubViewsDetect:[:v | v isKeyboardConsumer] ifNone:nil.
        ]
    ].
    (initialFocusView notNil "and:[w isKeyboardConsumer]") ifTrue:[
        initialFocusView takeFocusWhenMapped:true.
    ].

    workspaces at:newSelectedIndex put:aWindow.
    self selectedWorkspaceIndexHolder value:newSelectedIndex.
    self workspaceSelectionChanged.

"/    workspaceHolder value:aWindow.

    "Modified: / 22-01-2011 / 12:02:59 / cg"
    "Modified: / 11-06-2011 / 00:05:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addWorkspace
    self addWindow:(self createWorkspace) named:'Workspace%1'
!

destroyTab:tabIndex
    self removeWorkspace:tabIndex
!

doIt
    |v|

    (v := self selectedWorkspacesTextView) notNil ifTrue:[
        v doIt.
    ]
!

loadFile:aFileName 
    self loadFile:aFileName encoding:nil
!

loadFile:aFileName encoding:encodingSymbolOrNil
    |lbl|

    lbl := aFileName asFilename withoutSuffix baseName.
    self loadFile:aFileName encoding:encodingSymbolOrNil label:lbl.
!

loadFile:aFileName encoding:encodingSymbolOrNil label:label
    |file ws|

    file := aFileName asFilename.
    ws := self selectedWorkspacesTextView.
    [
        |contents|

        contents := file contents.
        encodingSymbolOrNil notNil ifTrue:[
            contents := contents encodeFrom:encodingSymbolOrNil into:#'unicode'.
            ws externalEncoding:encodingSymbolOrNil.
        ].
        ws contents:contents.
        ws defaultFileNameForFileDialog:file pathName.
    ] on:StreamError do:[:ex|
        Dialog warn:(resources stringWithCRs:'Cannot open "%1":\\%2' with:file asString with:ex description).
        ^ self
    ].
    ws modified:false.
    self setLabel:label.
!

loadFile:aFileName label:lbl
    |encoding|

    encoding := CharacterEncoder guessEncodingOfFile:aFileName.
    (encoding == #'iso8859-1' or:[encoding == #'ascii']) ifTrue:[
        encoding := nil
    ].
    self loadFile:aFileName encoding:encoding label:lbl.

    "Created: / 15-03-2007 / 11:52:21 / cg"
!

menuLoad
    |file|

    (self askIfModified:'Text was modified. Load anyway ?' yesButton:'Load') ifFalse:[ ^ self].

    file := Dialog 
                requestFileName:(resources string:'Load file') 
                default:(self defaultFileNameForLoad) 
                pattern:(self defaultPatternLoad).
    file size ~~ 0 ifTrue:[
        self loadFile:file
    ]

    "Modified: / 25-10-2006 / 14:57:34 / cg"
!

menuPrint
    |ws|

    ws := self selectedWorkspacesTextView.
    ws doPrint

    "Created: / 25-10-2006 / 15:01:51 / cg"
!

menuSaveAllAs
    self 
        askForFile:'Save all Buffers into:' 
        default:(self defaultFileNameForSaveAll)
        thenDo:[:file :doAppend |
            |ws append|

            append := doAppend.
            workspaces do:[:subView |
                |ws|

                ws := self workspaceViewOfView:subView.
                ws notNil ifTrue:[
                    ws saveAs:file doAppend:append.
                    ws modified:false.
                ].
                append := true.
            ].
        ]
!

menuSaveAs
    self 
        askForFile:'Save Buffer into:'
        default:(self defaultFileNameForSave)
        thenDo:[:file :doAppend |
            |ws lbl|

            ws := self selectedWorkspacesTextView.
            ws saveAs:file doAppend:doAppend.
            ws modified:false.
            "/ ws defaultFileNameForFileDialog:file asFilename baseName.

            lbl := file asFilename withoutSuffix baseName.
            self setLabel:lbl.
        ]
!

newWorkspace
    self class new openWithExtent:(self builder window extent).

    "Modified: / 25-10-2006 / 14:39:15 / cg"
!

openFontDialog
    self selectedWorkspace changeFont
!

openSTXDocumentation
    "opens the top documentation file"

    self openHTMLDocument: 'TOP.html'
!

openSettingsDialog
    |settingsList|

    settingsList := 
        #(
           #('Keyboard Mappings'    #'AbstractSettingsApplication::KbdMappingSettingsAppl'          )
"/           #('Debugger'             #'AbstractSettingsApplication::DebuggerSettingsAppl'            )
           #('Editor'               #'AbstractSettingsApplication::EditSettingsAppl'                )
"/           #('Syntax Color'         #'AbstractSettingsApplication::SyntaxColorSettingsAppl'         )
"/           #('Code Format'          #'AbstractSettingsApplication::SourceCodeFormatSettingsAppl'    )
        ).

    SettingsDialog 
        openWithList:settingsList 
        label:(resources string:'Settings').
!

printIt
!

removeAllWorkspacesExcept:wsIndex
    tabList size downTo:wsIndex+1 do:[:idx |
        self removeWorkspace:idx.
    ].
    1 to:wsIndex-1 do:[:idx |
        self removeWorkspace:1.
    ].
!

removeWorkspace
    self removeWorkspace:(self selectedWorkspaceIndexHolder value)
!

removeWorkspace:wsIndex
    |tabList newWsIndex|

    wsIndex == self selectedWorkspaceIndexHolder value ifTrue:[
        (self askIfModified:'Text was modified. Remove buffer anyway ?' yesButton:'Remove Buffer') ifFalse:[
            ^ self
        ].
    ].

    tabList := self tabList.

    wsIndex == tabList size ifTrue:[
        newWsIndex := wsIndex - 1.
    ] ifFalse:[
        newWsIndex := wsIndex.
    ].

    tabList removeIndex:wsIndex.
    (workspaces at:wsIndex) destroy.
    workspaces removeIndex:wsIndex.

    tabList size == 1 ifTrue:[
        self window label:(tabList at:1).
        tabList removeIndex:1
    ].

    workspaceHolder value:(workspaces at:newWsIndex).
    self selectedWorkspaceIndexHolder value:newWsIndex.
    "/ to force change (update workspaceHolder - even if same index)
    self selectedWorkspaceIndexHolder changed:#value.   
!

renameWorkspace
    self renameWorkspace:(self selectedWorkspaceIndexHolder value)
!

renameWorkspace:wsIndex
    |tabList oldName newName|

    tabList := self tabList.
    tabList isEmpty ifTrue:[
        oldName := self window label
    ] ifFalse:[
        oldName := tabList at:wsIndex.
    ].
    newName := Dialog request:(resources string:'New Name for "%1":' with:oldName) initialAnswer:oldName.
    newName size == 0 ifTrue:[ ^ self].

    self renameWorkspace:wsIndex to:newName.

    "Modified: / 20-07-2012 / 10:21:29 / cg"
!

renameWorkspace:wsIndex to:newName
    |tabList|

    tabList := self tabList.
    tabList notEmpty ifTrue:[
        tabList at:wsIndex put:newName.
    ].
    wsIndex == self selectedWorkspaceIndexHolder value ifTrue:[
        self window label:newName.
    ].
! !

!MultiViewToolApplication methodsFor:'menu-actions-editing'!

copySelection
    |v|

    (v := self selectedWorkspacesTextView) notNil ifTrue:[
        v copySelection
    ]
!

cutSelection
    |v|

    (v := self selectedWorkspacesTextView) notNil ifTrue:[
        v cutSelection
    ].
!

paste
    |v|

    (v := self selectedWorkspacesTextView) notNil ifTrue:[
        v pasteOrReplace
    ]

    "Modified: / 18-07-2018 / 14:35:49 / jv"
!

paste:aString
    |v|

    v := (workspaceHolder value) ? (self selectedWorkspacesTextView).
    [
        v perform:#paste: with:aString.
    ] on:MessageNotUnderstood do:[:ex|
        "special code, to catch exeception sent from a scrolled view,
         which has a different receiver tha v"
        (ex selector ~~ #paste:) ifTrue:[
            ex reject.
        ].
        "else ignore it"
    ].

    "Modified: / 16-11-2010 / 15:27:39 / cg"
!

redo
    |v|

    (v := self selectedWorkspacesTextView) notNil ifTrue:[
        v redo.
    ]
!

search
    |v|

    (v := self selectedWorkspacesTextView) notNil ifTrue:[
        v search.
    ]
!

selectAll
    |v|

    (v := self selectedWorkspacesTextView) notNil ifTrue:[
        v selectAll.
    ]
!

undo
    |v|

    (v := self selectedWorkspacesTextView) notNil ifTrue:[
        v undo.
    ]
! !

!MultiViewToolApplication methodsFor:'private'!

askForFile:question default:defaultFilename thenDo:aBlock
    Dialog
        requestSaveFileName:(resources string:question) 
        default:defaultFilename 
        fromDirectory:nil 
        action:[:fileName | aBlock value:fileName value:false] 
        appendAction:[:fileName | aBlock value:fileName value:true]

"/    |file doAppend|
"/
"/    doAppend := false.
"/    Dialog aboutToOpenBoxNotificationSignal handle:[:n |
"/        |box|
"/
"/        box := n parameter.
"/        box addButton:(Button label:'Append' action:[doAppend := true. box okPressed]).
"/        n proceed.
"/    ] do:[
"/        file := Dialog requestFileName:question default:'file.wsp'. 
"/    ].
"/    file isEmptyOrNil ifFalse:[
"/        aBlock value:file value:doAppend
"/    ].
!

askForFile:question thenDo:aBlock
    ^ self
        askForFile:question default:'file.wsp' thenDo:aBlock
!

askIfAnyModified:arg1 yesButton:arg2 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

askIfModified:question yesButton:yesButtonText
    "tell user, that code has been modified - let her confirm"

    |textView|

    textView := self selectedWorkspace.
    (self isModifiedWorkspace:textView) ifFalse:[^ true].

    (Dialog 
        confirm:(resources stringWithCRs:question)
        yesLabel:(resources string:yesButtonText)
        noLabel:(resources string:'Cancel'))
    ifTrue:[
        "/ reset modified flag so question is asked only once
        textView modified:false.
        ^ true
    ].
    ^ false

    "Modified: 2.10.1997 / 14:23:47 / stefan"
!

createWorkspace
    |ws|

    ws := (HVScrollableView for:EditTextView).
    ^ ws

    "Modified: / 09-12-2010 / 10:55:25 / cg"
!

isModifiedWorkspace:aView
    self subclassResponsibility
!

selectedWorkspacesTextView
    ^ self workspaceViewOfView:(self selectedWorkspace)
!

setLabel:label
    tabList size > 1 ifTrue:[
        tabList at:self selectedWorkspaceIndexHolder value put:label
    ].
    self window label:label.
!

workspaceViewOfView:aView
    |view|

    view := aView.

    (view isScrollWrapper) ifTrue:[
        view := view scrolledView.
        view isNil ifTrue:[^ nil].
    ].

    (view isTextView) ifFalse:[
        (view isKindOf:InspectorView) ifTrue:[
            view := view workspace.
            (view isScrollWrapper) ifTrue:[
                view := view scrolledView
            ].
        ].
    ].
    (view isTextView) ifTrue:[^ view].
    ^ view allSubViewsDetect:[:v| v name = #Workspace] ifNone:nil.
! !

!MultiViewToolApplication methodsFor:'user actions'!

hideEditToolbar
    self editToolBarVisibleHolder value:false
!

hideToolbar
    self toolBarVisibleHolder value:false

    "Created: / 18-02-2007 / 14:55:54 / cg"
! !

!MultiViewToolApplication class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

