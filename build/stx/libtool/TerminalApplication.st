"
 COPYRIGHT (c) 2001 by eXept Software AG
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

MultiViewToolApplication subclass:#TerminalApplication
	instanceVariableNames:'initialDirectory keepAlive keepAliveProcess'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!TerminalApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    A simple wrapper around a Terminal-View, adding a pullDown menu.

    [author:]
        Claus Gittinger
"
! !

!TerminalApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TerminalApplication andSelector:#windowSpec
     TerminalApplication new openInterface:#windowSpec
     TerminalApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Terminal'
         name: 'Terminal'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 432 241)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (NoteBookViewSpec
             name: 'NoteBook1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             model: selectedWorkspaceIndexHolder
             menu: tabList
             useIndex: true
             accessTabMenuAction: tabMenuAt:
             destroyTabAction: removeWorkspace:
             canvas: workspaceHolder
             canvasInset: 0
             keepCanvasAlive: true
             tabLevel: 1
           )
          )
        
       )
     )
! !

!TerminalApplication class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:TerminalApplication andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(TerminalApplication mainMenu)) startUp
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
                  label: 'New Shell'
                  itemValue: newWorkspace
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Playback File...'
                  itemValue: menuPlayback
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Save As...'
                  itemValue: menuSaveAs
                )
               (MenuItem
                  enabled: hasMultipleBuffersHolder
                  label: 'Save all As...'
                  itemValue: menuSaveAllAs
                )
               (MenuItem
                  label: '-'
                )
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
            label: 'Buffers'
            nameKey: Buffer
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Add Buffer'
                  itemValue: addWorkspace
                )
               (MenuItem
                  label: 'Rename...'
                  itemValue: renameWorkspace
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: canRemoveWorkspace
                  label: 'Remove Buffer'
                  itemValue: removeWorkspace
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
                  label: 'Normal'
                  itemValue: setNormalDisplayMode
                )
               (MenuItem
                  label: 'Reverse'
                  itemValue: setReverseDisplayMode
                )
               (MenuItem
                  label: 'Green'
                  itemValue: setGreenDisplayMode
                )
               (MenuItem
                  label: 'Red'
                  itemValue: setRedDisplayMode
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Ignore Text Color Commands'
                  indication: noColors:
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Edit'
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasSelectionInActiveWorkspace
                  label: 'Copy'
                  itemValue: copySelection
                )
               (MenuItem
                  label: 'Paste'
                  itemValue: paste
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Select All'
                  itemValue: selectAll
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Shell'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Interrupt'
                  itemValue: doSendInterrupt
                )
               (MenuItem
                  label: 'Kill'
                  itemValue: doSendKillSignal
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Send "~." (ssh/telnet quit)'
                  itemValue: doSendTildeStop
                )
               (MenuItem
                  label: 'Keep Connection Alive'
                  indication: keepSSHConnectionAliveHolder
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Reset Terminal'
                  itemValue: doReset
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Help'
            startGroup: right
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
            #label: 'Add Buffer'
            #translateLabel: true
            "/ #triggerOnDown: true
            #value: #addWorkspace
          )
         #(#MenuItem
            #label: 'Rename...'
            #translateLabel: true
            "/ #triggerOnDown: true
            #value: #renameWorkspace:
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Remove Buffer'
            #translateLabel: true
            "/ #triggerOnDown: true
            #value: #removeWorkspace:
            #enabled: #canRemoveWorkspace:
          )
         )
        nil
        nil
      )
! !

!TerminalApplication class methodsFor:'special startup'!

openIn:aDirectory
    "launch a new terminal in some directory"

    |terminal|

    terminal := self new.
    terminal initialDirectory:aDirectory.
    terminal open.
    ^ terminal

    "
     TerminalApplication open
     TerminalApplication openIn:'/etc'
    "
! !

!TerminalApplication methodsFor:'aspects'!

keepSSHConnectionAliveHolder
    keepAlive isNil ifTrue:[
        keepAlive := false asValue.
        keepAlive onChangeSend:#keepSSHConnectionAliveHolderChanged to:self.
    ].
    ^ keepAlive

    "Created: / 30-07-2013 / 07:51:59 / cg"
! !

!TerminalApplication methodsFor:'menu-actions'!

addWorkspace
    self 
        addWindow:(self createWorkspace) 
        named:'Terminal%1'
        "/ tabIcon:(ToolbarIconLibrary console13x13Icon) 
!

createWorkspace
    |scr|

"/    JV@2011-11-30: XTermView disabled as recent changes in
"/    #startShellInSelectedWindow leads to infinite loop.
"/    further investigation needed.        
    "/ sorry jan: XtermView seems to be not ok (masterView:) and also not working
    "/ on all systems (mac). make this a configurable option
    false "(OperatingSystem isUNIXlike and:[XTermView notNil])" ifTrue:[
        scr := XTermView new.
        scr workingDirectory: initialDirectory.
    ] ifFalse:[
        VT100TerminalView isNil ifTrue:[
            self error:'missing: VT100TerminalView'
        ].
        scr := (HVScrollableView for:VT100TerminalView).
        scr autoHideScrollBars:false.
        scr horizontalMini:true.
    ].

    self window realized ifTrue:[
        self window sensor pushUserEvent:#startShellInSelectedWindow for:self.
    ].
    ^ scr

    "Modified: / 08-04-2011 / 14:56:57 / cg"
    "Modified: / 03-04-2012 / 10:19:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doKill
    self selectedWorkspacesTextView doKill.
!

doReset
    self selectedWorkspacesTextView doReset.
!

doSendInterrupt
    self selectedWorkspacesTextView doSendInterrupt.
!

doSendKillSignal
    self selectedWorkspacesTextView doSendKillSignal.
!

doSendTildeStop
    self selectedWorkspacesTextView send:'~.'.

    "Created: / 29-07-2013 / 18:20:36 / cg"
!

keepSSHConnectionAliveHolderChanged
    keepAlive value ifTrue:[
        self startKeepAliveProcess
    ] ifFalse:[
        self stopKeepAliveProcess
    ]

    "Created: / 30-07-2013 / 07:53:12 / cg"
!

menuPlayback
    |file suff|

    suff := 'sh'.

    OperatingSystem isMSDOSlike ifTrue:[ suff := 'bat' ].
    file := Dialog requestFileName:'Playback file' default:('file.',suff) pattern:('*.',suff).
    file size > 0 ifTrue:[
        self playbackFile:file
    ]
!

noColors
    ^ self selectedWorkspacesTextView noColors
!

noColors:aBoolean
    self selectedWorkspacesTextView noColors:aBoolean.
!

openDocumentation
    "opens the documentation file"

    self openHTMLDocument: 'tools/misc/TOP.html#TERMINAL'
!

playbackFile:aFileName 
    |file ws|

    file := aFileName asFilename.
    file exists ifFalse:[
        Dialog warn:(resources string:'File %1 does not exist.' with:file asString).
        ^ self
    ].

    ws := self selectedWorkspacesTextView.
    file readingLinesDo:[:eachLine | ws sendLine:eachLine]
    .
!

setGreenDisplayMode
    self selectedWorkspacesTextView setGreenDisplayMode.
!

setNormalDisplayMode
    self selectedWorkspacesTextView setNormalDisplayMode.
!

setRedDisplayMode
    self selectedWorkspacesTextView setRedDisplayMode.
!

setReverseDisplayMode
    self selectedWorkspacesTextView setReverseDisplayMode.
! !

!TerminalApplication methodsFor:'private'!

isModifiedWorkspace:aView
    ^ false
!

startKeepAliveProcess
    "keep alive, by sending a return from time to time.
     Raise to top, if connection is lost"

    keepAliveProcess isNil ifTrue:[
        keepAliveProcess :=
            [
                [true] whileTrue:[
                    self selectedWorkspacesTextView sendCR:''.
                    Delay waitForSeconds:30.
                ].
            ] newProcess.
        keepAliveProcess resume.
    ].

    "Created: / 30-07-2013 / 09:14:36 / cg"
!

stopKeepAliveProcess
    |p|

    (p := keepAliveProcess) notNil ifTrue:[
        keepAliveProcess := nil.
        p terminate
    ].

    "Created: / 30-07-2013 / 09:15:05 / cg"
! !

!TerminalApplication methodsFor:'startup'!

startShellInSelectedWindow
    |vt|

    vt := self selectedWorkspacesTextView.
    (vt notNil and:[vt superView realized]) ifFalse:[
        self window sensor pushUserEvent:#startShellInSelectedWindow for:self.
        ^ self.
    ].

    vt startShellIn:initialDirectory.
    vt shellTerminateAction:[self shellFinishedInWorkspace:vt].
    vt masterWindow:(self window).  "/ to change window title

    "Modified: / 07-04-2011 / 09:03:55 / cg"
    "Modified: / 03-04-2012 / 10:31:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TerminalApplication methodsFor:'startup & release'!

initialDirectory:aDirectory
    initialDirectory := aDirectory
!

postBuildWith:aBuilder
    |w h|

    super postBuildWith:aBuilder.

    w := self window width max:(workspaces first preferredExtent x).
    h := builder menuBar height + (workspaces first preferredExtent y).
    self window extent:(w@h).
!

postOpenWith:aBuilder
    self startShellInSelectedWindow.
    super postOpenWith:aBuilder
!

release
    self stopKeepAliveProcess.
    super release.

    "Created: / 30-07-2013 / 07:54:16 / cg"
!

shellFinishedInWorkspace:aView
    "/ vt backgroundColor:(Color red).
    aView 
        cr; 
        nextPutLine:('>> shell terminated.' asText allBold colorizeAllWith:Color red).
! !

!TerminalApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/TerminalApplication.st,v 1.23 2014-10-25 12:51:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/TerminalApplication.st,v 1.23 2014-10-25 12:51:00 cg Exp $'
! !

