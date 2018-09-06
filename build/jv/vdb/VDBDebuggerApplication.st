"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractApplication subclass:#VDBDebuggerApplication
	instanceVariableNames:'layoutSpecHolder selectedThreadGroupHolder selectedThreadHolder
		selectedFrameHolder containerBottom canExecRestartHolder
		canExecResumeHolder canExecRunHolder canExecStepIntoHolder
		canExecStepOverHolder canExecStepReturnHolder
		canExecSuspendHolder canExecTerminateHolder canExecBackIntoHolder
		canExecBackOverHolder canExecBackReturnHolder
		canExecReverseHolder targetIsRR'
	classVariableNames:''
	poolDictionaries:'GDBStopReasons'
	category:'VDB-UI'
!

!VDBDebuggerApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBDebuggerApplication class methodsFor:'initialization'!

initializeDefaultKeyboardMap
    defaultKeyboardMap := DebugView defaultKeyboardMap copy.
    defaultKeyboardMap bindValue: #DebuggerRestart to: ('Ctrl', (defaultKeyboardMap bindingForLogical: #DebuggerContinue)) asSymbol.

    "Created: / 05-06-2017 / 23:01:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2017 / 20:08:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication class methodsFor:'accessing - defaults'!

defaultUserInit
    "Return path to user-specific VDB initi file (as Filename).
     Use this to customize VDB upon startup.
     If it does not exist, try create one with some defaults."
    
    | gdbinit |

    gdbinit := Filename homeDirectory / '.vdbinit.st'.
    gdbinit exists ifFalse:[
        [
            gdbinit 
                writingFileDo:[:s | 
                    s
                        nextPutLine:'"/ VDB init script';
                        nextPutLine:'"/ Current VDB instance can be accessed in via variable `vdb`';
                        nextPutLine:'"/';
                        nextPutLine:'"/ Set prompt';
                        nextPutLine:'vdb debugger send: ''set prompt (vdb) ''.';
                        cr;
                        nextPutLine:'"/ Set default font:';
                        nextPutLine:'"/ VDBAbstractApplication defaultTextFont: (CodeView defaultFont asSize: 16).';
                        yourself.
                ].
        ] on:Error
                do:[:ex | 
            gdbinit exists ifTrue:[
                gdbinit remove
            ].
            ^ nil
        ].
    ].
    ^ gdbinit

    "
     VDBDebuggerApplication defaultUserInit"

    "Created: / 31-08-2018 / 07:03:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication class methodsFor:'interface opening'!

open
    ^ self openFor: GDBDebugger new.

    "Created: / 23-09-2014 / 16:39:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication class methodsFor:'interface specs'!

layoutEclipseSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBDebuggerApplication andSelector:#layoutEclipseSpec
     VDBDebuggerApplication new openInterface:#layoutEclipseSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: layoutEclipseSpec
       window: 
      (WindowSpec
         label: 'Visual Debugger'
         name: 'Visual Debugger'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 718 390)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             showHandle: true
             snapMode: both
             component: 
            (SpecCollection
               collection: (
                (VariableHorizontalPanelSpec
                   name: 'StackAndFrameCanvas'
                   snapMode: both
                   component: 
                  (SpecCollection
                     collection: (
                      (SubCanvasSpec
                         name: 'StackCanvas'
                         level: 0
                         hasHorizontalScrollBar: false
                         hasVerticalScrollBar: false
                         majorKey: VDBStackApplication
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: selectedFrameHolder
                             aspect: selectedFrameHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: selectedThreadGroupHolder
                             aspect: selectedThreadGroupHolder
                           )
                           
                          (SubChannelInfoSpec
                             subAspect: selectedThreadHolder
                             aspect: selectedThreadHolder
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      (SubCanvasSpec
                         name: 'FrameCanvas'
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         majorKey: VDBFrameApplication
                         subAspectHolders: 
                        (Array
                           
                          (SubChannelInfoSpec
                             subAspect: debuggerHolder
                             aspect: debuggerHolder
                           ) 
                          (SubChannelInfoSpec
                             subAspect: frameHolder
                             aspect: selectedFrameHolder
                           )
                         )
                         createNewApplication: true
                         createNewBuilder: true
                       )
                      )
                    
                   )
                   handles: (Any 0.5 1.0)
                 )
                (SubCanvasSpec
                   name: 'SourceCanvas'
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   majorKey: VDBSourceApplication
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: frameHolder
                       aspect: selectedFrameHolder
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (SubCanvasSpec
                   name: 'ContainerBottom'
                   level: 0
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   clientHolder: containerBottom
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: debuggerHolder
                       aspect: debuggerHolder
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.33333333333333337 0.66666666666666674 1.0)
           )
          )
        
       )
     )

    "Modified: / 06-06-2017 / 08:12:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

layoutSingleSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBDebuggerApplication andSelector:#windowSpec
     VDBDebuggerApplication new openInterface:#windowSpec
     VDBDebuggerApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Visual Debugger'
         name: 'Visual Debugger'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 718 390)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (SubCanvasSpec
             name: 'ContainerBottom'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             level: 0
             hasHorizontalScrollBar: false
             hasVerticalScrollBar: false
             clientHolder: containerBottom
             subAspectHolders: 
            (Array
               
              (SubChannelInfoSpec
                 subAspect: debuggerHolder
                 aspect: debuggerHolder
               )
             )
             createNewApplication: true
             createNewBuilder: true
           )
          )
        
       )
     )

    "Created: / 17-09-2014 / 22:34:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBDebuggerApplication andSelector:#windowSpec
     VDBDebuggerApplication new openInterface:#windowSpec
     VDBDebuggerApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Visual/VM Debugger'
         name: 'Visual/VM Debugger'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 800 600)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'ToolBar'
             layout: (LayoutFrame 0 0 0 0 0 1 25 0)
             menu: toolbarMenu
             textDefault: true
           )
          (SubCanvasSpec
             name: 'Layout'
             layout: (LayoutFrame 0 0 25 0 0 1 0 1)
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             specHolder: layoutSpecHolder
             createNewBuilder: false
           )
          )
        
       )
     )

    "Modified: / 02-06-2017 / 08:34:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication class methodsFor:'menu specs'!

execMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBDebuggerApplication andSelector:#execMenu
     (Menu new fromLiteralArrayEncoding:(VDBDebuggerApplication execMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: canExecRunHolder
            label: 'Run'
            itemValue: doExecRun
            isVisible: true
            labelImage: (ResourceRetriever VDBIconLibrary actionRun16x16 'Run')
          )
         (MenuItem
            enabled: canExecResumeHolder
            label: 'Resume'
            itemValue: doExecResume
            isVisible: true
            shortcutKey: DebuggerContinue
            labelImage: (ResourceRetriever VDBIconLibrary actionContinue16x16 'Resume')
          )
         (MenuItem
            enabled: canExecSuspendHolder
            label: 'Suspend'
            itemValue: doExecSuspend
            isVisible: true
            labelImage: (ResourceRetriever VDBIconLibrary actionStop16x16 'Suspend')
          )
         (MenuItem
            enabled: canExecTerminateHolder
            label: 'Terminate'
            itemValue: doExecTerminate
            isVisible: true
            labelImage: (ResourceRetriever VDBIconLibrary actionTerminate6x16 'Terminate')
          )
         (MenuItem
            enabled: canExecRestartHolder
            label: 'Restart'
            itemValue: doExecRestart
            isVisible: true
            shortcutKey: DebuggerRestart
            labelImage: (ResourceRetriever VDBIconLibrary actionTerminateAndRun6x16 'Restart')
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            enabled: canExecStepOverHolder
            label: 'Step Over'
            itemValue: doExecStepOver
            isVisible: true
            shortcutKey: DebuggerNext
            labelImage: (ResourceRetriever VDBIconLibrary actionStepOver6x16 'Step Over')
          )
         (MenuItem
            enabled: canExecStepIntoHolder
            label: 'Step Into'
            itemValue: doExecStepInto
            isVisible: true
            shortcutKey: DebuggerSend
            labelImage: (ResourceRetriever VDBIconLibrary actionStepInto6x16 'Step Into')
          )
         (MenuItem
            enabled: canExecStepReturnHolder
            label: 'Step Return'
            itemValue: doExecStepReturn
            isVisible: true
            shortcutKey: DebuggerReturn
            labelImage: (ResourceRetriever VDBIconLibrary actionStepReturn6x16 'Step Return')
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            enabled: canExecBackOverHolder
            label: 'Back Over'
            itemValue: doExecBackOver
            isVisible: true
            shortcutKey: DebuggerBackOver
          )
         (MenuItem
            enabled: canExecBackIntoHolder
            label: 'Back Into'
            itemValue: doExecBackInto
            isVisible: true
            shortcutKey: DebuggerBackInto
          )
         (MenuItem
            enabled: canExecBackReturnHolder
            label: 'Back Return'
            itemValue: doExecBackReturn
            isVisible: true
            shortcutKey: DebuggerBackReturn
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            enabled: canExecReverseHolder
            label: 'Reverse'
            itemValue: doExecReverse
            isVisible: true
            shortcutKey: DebuggerBackReturn
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Pin Menu'
            itemValue: doPinMenuAs:item:
            isVisible: true
            labelImage: (ResourceRetriever VDBIconLibrary pin 'Pin Menu')
            argument: 'Execute'
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
     MenuEditor new openOnClass:VDBDebuggerApplication andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(VDBDebuggerApplication mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            isVisible: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Open Executable'
                  itemValue: doOpenExecutable
                  isVisible: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: canAttachToRR
                  label: 'Attach to Replay Server'
                  itemValue: doAttachToRR
                  isVisible: true
                )
               (MenuItem
                  label: '-'
                  isVisible: true
                )
               (MenuItem
                  label: 'Quit'
                  itemValue: doQuit
                  isVisible: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Run'
            isVisible: true
            submenuChannel: execMenu
          )
         (MenuItem
            label: 'View'
            isVisible: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Stack'
                  itemValue: doOpenToolApplicationClass:
                  isVisible: true
                  argument: VDBStackApplication
                )
               (MenuItem
                  label: 'Frame'
                  itemValue: doOpenToolApplicationClass:
                  isVisible: true
                  argument: VDBFrameApplication
                )
               (MenuItem
                  label: 'Breakpoints'
                  itemValue: doOpenToolApplicationClass:
                  isVisible: true
                  argument: VDBBreakpointListApplication
                )
               (MenuItem
                  label: 'Memory'
                  itemValue: doOpenToolApplicationClass:
                  isVisible: true
                  argument: VDBMemoryApplication
                )
               (MenuItem
                  label: '-'
                  isVisible: true
                )
               (MenuItem
                  enabled: canViewEnableFrameFilters
                  label: 'Enable Frame Filters'
                  itemValue: doViewEnableFrameFilters
                  isVisible: true
                )
               (MenuItem
                  enabled: canViewEnablePrettyPrinting
                  label: 'Enable Pretty Printing'
                  itemValue: doViewEnablePrettyPrinting
                  isVisible: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Debug'
            startGroup: right
            isVisible: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Inspect Debugger'
                  itemValue: doInspectDebugger
                  isVisible: true
                )
               (MenuItem
                  label: 'Inspect Session Record'
                  itemValue: doInspectSessionRecord
                  isVisible: true
                )
               (MenuItem
                  label: '-'
                  isVisible: true
                )
               (MenuItem
                  label: 'Reopen'
                  itemValue: doDebugReopenDebugger
                  isVisible: true
                )
               (MenuItem
                  label: 'Launcher'
                  itemValue: doDebugReopenLauncher
                  isVisible: true
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

toolbarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBDebuggerApplication andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(VDBDebuggerApplication toolbarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Exec Slice'
            submenuChannel: toolbarMenuExecSlice
            isMenuSlice: true
          )
         )
        nil
        nil
      )
!

toolbarMenuExecSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBDebuggerApplication andSelector:#toolbarMenuExecSlice
     (Menu new fromLiteralArrayEncoding:(VDBDebuggerApplication toolbarMenuExecSlice)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: canExecRunHolder
            label: 'Run'
            itemValue: doExecRun
            labelImage: (ResourceRetriever VDBIconLibrary actionRun16x16)
          )
         (MenuItem
            enabled: canExecResumeHolder
            label: 'Resume'
            itemValue: doExecResume
            labelImage: (ResourceRetriever VDBIconLibrary actionContinue16x16)
          )
         (MenuItem
            enabled: canExecSuspendHolder
            label: 'Suspend'
            itemValue: doExecSuspend
            labelImage: (ResourceRetriever VDBIconLibrary actionStop16x16)
          )
         (MenuItem
            enabled: canExecTerminateHolder
            label: 'Terminate'
            itemValue: doExecTerminate
            labelImage: (ResourceRetriever VDBIconLibrary actionTerminate6x16)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canExecStepOverHolder
            label: 'Step Over'
            itemValue: doExecStepOver
            labelImage: (ResourceRetriever VDBIconLibrary actionStepOver6x16)
          )
         (MenuItem
            enabled: canExecStepIntoHolder
            label: 'Step Into'
            itemValue: doExecStepInto
            labelImage: (ResourceRetriever VDBIconLibrary actionStepInto6x16)
          )
         (MenuItem
            enabled: canExecStepReturnHolder
            label: 'Step Return'
            itemValue: doExecStepReturn
            labelImage: (ResourceRetriever VDBIconLibrary actionStepReturn6x16)
          )
         )
        nil
        nil
      )
! !

!VDBDebuggerApplication class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #debuggerHolder
        #selectedFrameHolder
        #selectedThreadGroupHolder
        #selectedThreadHolder
      ).

    "Modified: / 01-06-2017 / 23:32:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication methodsFor:'accessing'!

currentThreadGroup
    "Return 'current' thread group (inferior) or nil. 'Current' thread group is
     either the selected one or, if none's selected or the only one thread group
     (if there's only one)"

    | tg |

    tg := self selectedThreadGroup.
    tg isNil ifTrue:[
        | tgs |

        tgs := debugger inferiors.
        tgs size == 1 ifTrue:[ 
            tg := tgs anyOne.
        ].
    ].
    ^ tg.

    "Created: / 03-07-2017 / 06:58:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedThreadGroup
    ^ self selectedThreadGroupHolder value

    "Created: / 03-07-2017 / 06:51:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication methodsFor:'aspects'!

layoutSpecHolder
    "return/create the 'layoutSpecHolder' value holder (automatically generated)"

    layoutSpecHolder isNil ifTrue:[
        layoutSpecHolder := ValueHolder with: #layoutEclipseSpec.
    ].
    ^ layoutSpecHolder

    "Modified: / 18-09-2014 / 23:35:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedFrameHolder
    "return/create the 'selectionHolder' value holder (automatically generated)"

    selectedFrameHolder isNil ifTrue:[
        selectedFrameHolder := ValueHolder new.
        selectedFrameHolder addDependent:self.
    ].
    ^ selectedFrameHolder

    "Created: / 21-09-2014 / 23:51:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedFrameHolder:aValueModel
    "set the 'selectionHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedFrameHolder notNil ifTrue:[
        oldValue := selectedFrameHolder value.
        selectedFrameHolder removeDependent:self.
    ].
    selectedFrameHolder := aValueModel.
    selectedFrameHolder notNil ifTrue:[
        selectedFrameHolder addDependent:self.
    ].
    newValue := selectedFrameHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selectedFrameHolder.
    ].

    "Created: / 21-09-2014 / 23:50:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedThreadGroupHolder
    "return/create the 'selectedThreadGroupHolder' value holder (automatically generated)"

    selectedThreadGroupHolder isNil ifTrue:[
        selectedThreadGroupHolder := ValueHolder new.
        selectedThreadGroupHolder addDependent:self.
    ].
    ^ selectedThreadGroupHolder
!

selectedThreadGroupHolder:something
    "set the 'selectedThreadGroupHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedThreadGroupHolder notNil ifTrue:[
        oldValue := selectedThreadGroupHolder value.
        selectedThreadGroupHolder removeDependent:self.
    ].
    selectedThreadGroupHolder := something.
    selectedThreadGroupHolder notNil ifTrue:[
        selectedThreadGroupHolder addDependent:self.
    ].
    newValue := selectedThreadGroupHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selectedThreadGroupHolder.
    ].
!

selectedThreadHolder
    "return/create the 'selectedThreadHolder' value holder (automatically generated)"

    selectedThreadHolder isNil ifTrue:[
        selectedThreadHolder := ValueHolder new.
        selectedThreadHolder addDependent:self.
    ].
    ^ selectedThreadHolder
!

selectedThreadHolder:something
    "set the 'selectedThreadHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedThreadHolder notNil ifTrue:[
        oldValue := selectedThreadHolder value.
        selectedThreadHolder removeDependent:self.
    ].
    selectedThreadHolder := something.
    selectedThreadHolder notNil ifTrue:[
        selectedThreadHolder addDependent:self.
    ].
    newValue := selectedThreadHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selectedThreadHolder.
    ].
! !

!VDBDebuggerApplication methodsFor:'aspects-containers'!

containerBottom
    containerBottom isNil ifTrue:[
        containerBottom := VDBTabbingContainer new.
        OperatingSystem isMSWINDOWSlike ifTrue:[
            containerBottom addApplication:VDBWindowsDebuggerConsoleApplication new.
        ] ifFalse:[ 
            containerBottom addApplication:VDBUnixDebuggerConsoleApplication new.
            containerBottom addApplication:VDBUnixInferiorConsoleApplication new.
        ].
        containerBottom addApplication:VDBEventLogApplication new.
    ].
    ^ containerBottom

    "Created: / 10-06-2014 / 17:29:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-01-2018 / 18:57:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 00:10:46 / jv"
! !

!VDBDebuggerApplication methodsFor:'change & update'!

update:aspect with:parameter from:sender
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    sender == selectedThreadGroupHolder ifTrue:[ 
        self updateAfterSelectedThreadGroupHolderChanged.
    ].

    sender == selectedFrameHolder ifTrue:[ 
        self updateAfterSelectedFrameHolderChanged.
    ].

    super update:aspect with:parameter from:sender

    "Modified: / 01-06-2017 / 23:34:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterSelectedFrameHolderChanged
    | frame |

    frame := selectedFrameHolder value.
    frame notNil ifTrue:[ 
        debugger 
              send:(GDBMI_thread_select new arguments:(Array with:frame thread id))
              andWait:false.  
        debugger 
              send:(GDBMI_stack_select_frame new arguments:(Array with:frame level))
              andWait:false.  
    ].

    "Created: / 27-02-2015 / 13:24:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterSelectedThreadGroupHolderChanged
    self updateButtonEnablements

    "Created: / 01-06-2017 / 23:34:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateButtonEnablements
    | inferior inferiorIsStopped inferiorIsRunning canReverse hasAsync |

    inferior := self currentThreadGroup.
    inferiorIsStopped := inferior notNil and:[ inferior isStopped ].
    inferiorIsRunning := inferior notNil and:[ inferior isRunning ].
    canReverse := debugger hasFeature: 'reverse'.
    hasAsync := debugger hasFeature: 'async'.

    self canExecResumeHolder value:     inferiorIsRunning & inferiorIsStopped .
    self canExecStepIntoHolder value:   inferiorIsRunning & inferiorIsStopped.
    self canExecStepOverHolder value:   inferiorIsRunning & inferiorIsStopped.
    self canExecStepReturnHolder value: inferiorIsRunning & inferiorIsStopped.
    self canExecSuspendHolder value:    hasAsync & inferiorIsRunning & inferiorIsStopped not.

    self canExecBackIntoHolder value:   inferiorIsRunning & inferiorIsStopped & canReverse.
    self canExecBackOverHolder value:   inferiorIsRunning & inferiorIsStopped & canReverse.
    self canExecBackReturnHolder value: inferiorIsRunning & inferiorIsStopped & canReverse.
    self canExecReverseHolder value: inferiorIsRunning & inferiorIsStopped & canReverse.

    self canExecTerminateHolder value:  inferiorIsRunning & (hasAsync | inferiorIsStopped).
    self canExecRestartHolder value:    hasAsync.

    self canExecRunHolder value: ( inferiorIsRunning not ).

    "Created: / 01-06-2017 / 23:18:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2018 / 21:31:41 / jv"
    "Modified: / 30-07-2018 / 08:57:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication methodsFor:'event handling'!

onCommandResultEvent: aGDBStoppedEvent
    self updateButtonEnablements

    "Created: / 01-06-2017 / 23:43:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onExitEvent: aGDBExitEvent
    "/ Check if GDB terminateg gracefully, if not,
    "/ show warning and allow user to inspect the
    "/ record.
    "/ 
    "/ Yes, even GDB has bugs and crashes.
    aGDBExitEvent status status == #signal ifTrue:[ 
        (Dialog confirm: 
            (resources stringWithCRs: 'GDB terminated by signal %1 (%2)\Show MI trace?' 
                                with: aGDBExitEvent status code 
                                with:(OperatingSystem nameForSignal: aGDBExitEvent status code)))
            ifTrue:[  aGDBExitEvent trace inspect ]
    ].
    self closeDownViews

    "Created: / 01-06-2017 / 13:42:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-05-2018 / 23:00:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onLogOutputEvent:aGDBLogOutputEvent 

    Transcript nextPutAll: aGDBLogOutputEvent value.
    Transcript isView ifTrue:[ 
        | flasher |

        flasher := [ 
            debugger announcer unsubscribe: flasher.
            Transcript topView raise; flash.
        ].
        debugger announcer when: GDBEventSetProcessingFinished  do: flasher    
    ].

    "Created: / 02-02-2018 / 11:46:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-02-2018 / 21:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onRRExitEvent: anRRExitEvent
    targetIsRR := false.
    anRRExitEvent rr announcer unsubscribe: self.

    "Created: / 03-08-2018 / 13:29:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2018 / 22:50:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onRRStartEvent: anRRStartEvent

    "Created: / 03-08-2018 / 13:38:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onRunningEvent: aGDBStoppedEvent
    self updateButtonEnablements

    "Created: / 21-09-2014 / 22:44:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 23:18:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onStoppedEvent: aGDBStoppedEvent
    self updateButtonEnablements

    "Created: / 21-09-2014 / 22:44:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 23:18:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onThreadGroupExitedEvent: aGDBStoppedEvent
    self updateButtonEnablements

    "Created: / 21-09-2014 / 22:45:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 23:41:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onThreadSelectedEvent: aGDBThreadSelectedEvent
    | frame thread group |

    frame := aGDBThreadSelectedEvent frame.
    thread := aGDBThreadSelectedEvent thread.
    group := aGDBThreadSelectedEvent threadGroup.

    self selectedFrameHolder value: frame.
    self selectedThreadHolder value: thread.
    self selectedThreadGroupHolder value: group.

    "Created: / 30-07-2018 / 07:33:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication methodsFor:'initialization'!

initializeKeyboardMap
    | mapping |

    super initializeKeyboardMap.
    #(
        DebuggerBackOver   DebuggerNext 
        DebuggerBackInto   DebuggerSend
        DebuggerBackReturn DebuggerReturn
    ) pairWiseDo: [:backwardKey :forwardKey |
        ((keyboardMap hasMappingFor: backwardKey) not 
            and:[ (mapping := keyboardMap bindingForLogical: forwardKey) notNil
            and:[ (mapping includesString:'Ctrl') not]]) ifTrue:[ 
                keyboardMap bindValue: backwardKey to: ('Ctrl', mapping) asSymbol  
            ].
    ]

    "Created: / 14-03-2018 / 11:28:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication methodsFor:'initialization & release'!

commonPostOpen
    self updateButtonEnablements

    "Created: / 05-06-2017 / 22:50:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    "remove all dependencies from the receiver"

    super release.
    self unsubscribe.
    (debugger notNil and:[debugger isConnected]) ifTrue:[ 
        debugger send: GDBMI_gdb_exit new andWait: false.
    ].

    "Created: / 01-06-2017 / 13:41:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-06-2017 / 12:48:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subscribe   
    "Register for debugger events. To be overrided by subclasses"

    | init |

    "/ Read init file
    init := self class defaultUserInit.  
    (init notNil and:[ init exists ]) ifTrue:[ 
        [ 
            [
            Workspace workspaceVariableAt: 'vdb' put: self.
                init fileIn.
            ] ensure:[
                Workspace workspaceVariables removeKey: 'vdb'.
            ].
        ] on: Error do:[:ex | 
            Transcript 
                showCR: ('Error while reading VGB init file (%1)' bindWith: init pathName);
                showCR: ('Description: %1' bindWith: ex description);
                showCR: ('Backtrace:');
                cr.
            ex suspendedContext fullPrintAllOn: Transcript.
            Transcript showCR:'------'.
        ].

    ].

    UserPreferences current vdbPrettyPrintingEnabled ifTrue:[ 
        debugger enablePrettyPrinting
    ].
    UserPreferences current vdbFrameFiltersEnabled ifTrue:[ 
        debugger enableFrameFilters
    ].
    debugger announcer
        when: GDBStoppedEvent       send: #onStoppedEvent:  to: self;
        when: GDBRunningEvent       send: #onRunningEvent:  to: self;
        when: GDBExitEvent          send: #onExitEvent:     to: self;
        when: GDBCommandResultEvent send: #onCommandResultEvent: to: self;
        when: GDBThreadGroupExitedEvent send: #onThreadGroupExitedEvent:  to: self;
        when: GDBThreadSelectedEvent send: #onThreadSelectedEvent:          to: self;
        when: GDBLogOutputEvent     send: #onLogOutputEvent:          to: self.

    "Created: / 21-09-2014 / 22:43:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2018 / 07:24:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication methodsFor:'menu actions'!

doAttachToRR
    self doAttachToRR: RR replay.

    "Modified: / 03-08-2018 / 13:33:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doAttachToRR: rr
    rr announcer
        when: RRStartEvent send: #onRRStartEvent: to: self;
        when: RRExitEvent send: #onRRExitEvent: to: self.
    rr start.
    (VDBUnixReplayServerConsoleApplication new)
        debugger:debugger;
        rr:rr;
        open.
    debugger targetConnectRR:rr.
    targetIsRR := true.

    "Created: / 03-08-2018 / 13:33:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2018 / 22:51:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doDebugReopenDebugger
    | d |

    d := debugger.
    self unsubscribe.
    debugger := nil.
    debuggerHolder setValue: nil.
    self closeDownViews.
    (Smalltalk at: self class name) openFor: d.

    "Created: / 20-06-2017 / 20:56:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doDebugReopenLauncher
    NewLauncher open

    "Created: / 20-06-2017 / 20:58:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenExecutable
    | file |

    file := Dialog requestFileName:'Selected executable to debug' pattern:'*'.
    file isNil ifTrue:[ ^ self ].
    file := file asFilename.
    debugger send:(GDBMI_file_exec_and_symbols arguments:{ file asString }) andWait:false.

    "Modified: / 12-06-2014 / 01:12:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 08-03-2015 / 15:49:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doQuit
    self closeRequest.

    "Modified: / 01-06-2017 / 13:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doViewEnableFrameFilters
    debugger enableFrameFilters.

    "Modified (format): / 12-06-2017 / 09:42:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doViewEnablePrettyPrinting
    debugger enablePrettyPrinting

    "Modified: / 12-06-2017 / 09:42:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication methodsFor:'menu actions-exec'!

doExec: command
    debugger send: command andWait: false.

    "Created: / 21-09-2014 / 21:50:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2018 / 17:57:15 / jv"
!

doExecBackInto
    self doExec: (GDBMI_exec_step arguments: #('--reverse')).

    "Modified: / 13-03-2018 / 10:22:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecBackOver
    self doExec: (GDBMI_exec_next arguments: #('--reverse')).

    "Modified: / 13-03-2018 / 10:22:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecBackReturn
    self doExec: (GDBMI_exec_finish arguments: #('--reverse')).

    "Modified: / 13-03-2018 / 10:39:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecRestart
    <resource: #uiCallback>

    self doExecTerminate; doExecRun.

    "Modified: / 11-06-2017 / 20:12:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecResume
    self doExec: GDBMI_exec_continue new.

    "Modified: / 21-09-2014 / 21:50:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecReverse
    | handler |

    "/ It seems that RR (as of 2018-08-31) has a funny bug:
    "/ when a program is stopped due to a signal, reverse-contine
    "/ will stop at the same place (when signal is reveiver) and
    "/ second reverse-contine does the job.
    "/ 
    "/ To somegow hide this from user, issue the second 
    "/ reverse-continue automagically. 
    "/ 
    "/ This is horible hack and maybe not a great idea, but
    "/ it looks beter when doing demos :-)

    targetIsRR ifTrue:[
        handler := [ :ev |
            debugger announcer unsubscribe: handler.   
            ev reason = SignalReceived ifTrue:[
                debugger send: (GDBMI_exec_continue arguments: #('--reverse')) andWait: false.
            ]
        ].
        debugger announcer when: GDBStoppedEvent do: handler.
    ].
    debugger send: (GDBMI_exec_continue arguments: #('--reverse')) andWait: false.

    "Created: / 30-07-2018 / 08:58:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2018 / 23:28:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecRun
    self doExec: GDBMI_exec_run new.

    "Modified: / 21-09-2014 / 21:51:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecStepInto
    self doExec: GDBMI_exec_step new.

    "Modified: / 21-09-2014 / 21:52:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecStepOver
    self doExec: GDBMI_exec_next new.

    "Modified: / 21-09-2014 / 21:52:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecStepReturn
    self doExec: GDBMI_exec_finish new.

    "Modified: / 13-03-2018 / 10:39:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecSuspend
    self doExec: (GDBMI_exec_interrupt arguments: #('--all'))

    "Modified: / 29-09-2014 / 23:50:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExecTerminate
    self doExec: 'kill'

    "Modified: / 05-06-2017 / 23:13:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication methodsFor:'menu apects'!

canAttachToRR
    ^ RR available

    "Modified: / 26-07-2018 / 22:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canViewEnableFrameFilters
    ^ [ debugger isFrameFiltersEnabled not ]

    "Modified: / 12-06-2017 / 09:54:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canViewEnablePrettyPrinting
    ^ [ debugger isPrettyPrintingEnabled not ].

    "Modified: / 12-06-2017 / 09:54:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication methodsFor:'menu aspects-exec'!

canExecBackIntoHolder
    canExecBackIntoHolder isNil ifTrue:[
        canExecBackIntoHolder := ValueHolder with: false.
    ].
    ^ canExecBackIntoHolder

    "Modified: / 13-03-2018 / 10:23:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecBackOverHolder
    canExecBackOverHolder isNil ifTrue:[
        canExecBackOverHolder := ValueHolder with: false.
    ].
    ^ canExecBackOverHolder

    "Modified: / 13-03-2018 / 10:24:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecBackReturnHolder
    canExecBackReturnHolder isNil ifTrue:[
        canExecBackReturnHolder := ValueHolder with: false.
    ].
    ^ canExecBackReturnHolder

    "Modified: / 13-03-2018 / 10:24:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecRestartHolder
    "return/create the 'canExecRestartHolder' value holder (automatically generated)"

    canExecRestartHolder isNil ifTrue:[
        canExecRestartHolder := ValueHolder with: false.
    ].
    ^ canExecRestartHolder

    "Modified: / 01-06-2017 / 23:15:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecResumeHolder
    "return/create the 'canExecResumeHolder' value holder (automatically generated)"

    canExecResumeHolder isNil ifTrue:[
        canExecResumeHolder := ValueHolder with: false.
    ].
    ^ canExecResumeHolder

    "Modified: / 01-06-2017 / 23:15:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecReverseHolder
    canExecReverseHolder isNil ifTrue:[
        canExecReverseHolder := ValueHolder with: false.
    ].
    ^ canExecReverseHolder

    "Created: / 30-07-2018 / 08:57:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecRunHolder
    "return/create the 'canExecRunHolder' value holder (automatically generated)"

    canExecRunHolder isNil ifTrue:[
        canExecRunHolder := ValueHolder with: false.
    ].
    ^ canExecRunHolder

    "Modified: / 01-06-2017 / 23:15:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecStepIntoHolder
    "return/create the 'canExecStepIntoHolder' value holder (automatically generated)"

    canExecStepIntoHolder isNil ifTrue:[
        canExecStepIntoHolder := ValueHolder with: false.
    ].
    ^ canExecStepIntoHolder

    "Modified: / 01-06-2017 / 23:15:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecStepOverHolder
    "return/create the 'canExecStepOverHolder' value holder (automatically generated)"

    canExecStepOverHolder isNil ifTrue:[
        canExecStepOverHolder := ValueHolder with: false.
    ].
    ^ canExecStepOverHolder

    "Modified: / 01-06-2017 / 23:15:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecStepReturnHolder
    "return/create the 'canExecStepReturn' value holder (automatically generated)"

    canExecStepReturnHolder isNil ifTrue:[
        canExecStepReturnHolder := ValueHolder with: false.
    ].
    ^ canExecStepReturnHolder

    "Created: / 05-06-2017 / 22:41:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecSuspendHolder
    "return/create the 'canExecSuspendHolder' value holder (automatically generated)"

    canExecSuspendHolder isNil ifTrue:[
        canExecSuspendHolder := ValueHolder with: false.
    ].
    ^ canExecSuspendHolder

    "Modified: / 01-06-2017 / 23:15:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExecTerminateHolder
    "return/create the 'canExecTerminateHolder' value holder (automatically generated)"

    canExecTerminateHolder isNil ifTrue:[
        canExecTerminateHolder := ValueHolder with: false.
    ].
    ^ canExecTerminateHolder

    "Modified: / 01-06-2017 / 23:16:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication methodsFor:'startup & release'!

closeRequestFor:aTopView
    aTopView == self window ifTrue:[ 
        super closeRequestFor:aTopView
    ] ifFalse:[ 
        | app |

        app := aTopView application.
        app notNil ifTrue:[
            app release
        ].
        aTopView destroy.
    ].

    "Created: / 29-07-2018 / 16:34:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2018 / 17:44:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBDebuggerApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

