"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

StandardSystemView subclass:#OldLauncher
	instanceVariableNames:'myMenu logoLabel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!OldLauncher class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    WARNING:
        This is a very old part of the ST/X system, and no longer maintained.
        This used to be the launcher many years ago (in the early 90s).
        It has been replaced by the Launcher, 
        which itself got obsoleted by the NewLauncher.

    OldLauncher allows startup of smalltalk applications.

    If you like this kind of permanent menu for your applications,
    create a subclass of this, and redefine #initializeLogo and
    #initializeMenu (thats why those two have been implemented as
    separate methods).

    If you like to add more entries to the menu (or a submenu),
    add an entry to the menu (in #initializeMenu) and create a corresponding
    action method, to be called from the menu.
    Then start a new OldLauncher with:
        OldLauncher open
    start a new one, BEFORE you close the old one - otherwise you may be
    left without any windows on the screen ...

    If you want to change the launchers menu WITHOUT closing the active one,
    use #addSelector... (see MenuView).
"
! !

!OldLauncher class methodsFor:'defaults '!

defaultLabel
    ^ 'ST/X'
!

isVisualStartable
    ^ true
! !

!OldLauncher methodsFor:'accessing'!

menu
    ^ myMenu
! !

!OldLauncher methodsFor:'demo menu actions'!

openDemo:className
    |cls|

    cls := (Smalltalk at:className).
    cls isNil ifTrue:[
        Demos notNil ifTrue:[
            cls := Demos at:className.
        ].
        cls isNil ifTrue:[
            Games notNil ifTrue:[
                cls := Games at:className.
            ].
            cls isNil ifTrue:[
                self warn:'Demo not found: ', className.
                ^ self.
            ].
        ].
    ].
    cls open
!

startAnimation
    self openDemo:#Animation 
!

startCommanderDemo
    self openDemo:#CommanderDemo 
!

startGlobeDemo
    self openDemo:#GlobeDemo 
!

startLogicTool
    self openDemo:#LogicTool 
!

startPenDemo
    self openDemo:#PenDemo 
!

startTetris
    self openDemo:#Tetris
!

startTicTacToe
    self openDemo:#TicTacToe 
! !

!OldLauncher methodsFor:'doc menu actions'!

showAbout
    AboutBox new show
!

showCustomizing
    self showOnlineHelp:'custom/TOP'
!

showGettingStarted
    self showOnlineHelp:'getstart/TOP'
!

showHTMLDocumentation
    (HTMLDocumentView notNil 
    and:[HTMLDocumentView isLoaded]) ifTrue:[
        HTMLDocumentView openFullOnDocumentationFile:'TOP.html'. 
    ] ifFalse:[
        self warn:'No HTMLDocumentView-class available'
    ].

!

showOnlineHelp:baseName
    self showDocumentFile:baseName
!

showOverview
    self showDocumentFile:'overview/TOP'
!

warnIfAbsent:aPath
    |s|

    s := Smalltalk systemFileStreamFor:aPath.
    s isNil ifTrue:[
	self warn:('document ' , aPath , ' not available').
	^ nil
    ].
    ^ s  pathName
! !

!OldLauncher methodsFor:'event handling'!

saveAndTerminate
    "
     some windowManagers can send this, to shutDown an application
     but let it save its state before, for restart. We are already
     prepared for this ;-)"

    ObjectMemory snapShotOn:name
! !

!OldLauncher methodsFor:'goody menu actions'!

startAddressBook
    self openDemo:#AddressBook 
!

startCalendar
    self openDemo:#Calendar 
!

startClock
    self openDemo:#Clock 
!

startDrawTool
    self openDemo:#DrawView 
!

startMailTool
    self openDemo:#MailView 
!

startNewsTool
    self openDemo:#NewsView 
!

startRoundClock
    self openDemo:#RoundClock2 
!

startXterm
    OperatingSystem executeCommand:'xterm &'
! !

!OldLauncher methodsFor:'initialize / release'!

addToCurrentProject
    "ignored here - the launcher is always global."

    ^ self
!

destroy
    "re-confirm when closing Launcher - we do this,
     since if you close the last launcher, you might loose the possibility to
     communicate with the system ..."

    (self confirm:(resources string:'close ' , self class name , ' ?')) ifTrue:[
	super destroy
    ]
!

initialize
    super initialize.

    self initializeMenu.
    self initializeLogo.

    myMenu level:0.
"/    myMenu borderWidth:0.
    myMenu origin:(0.0 @ logoLabel height).
    myMenu resize.
"/    myMenu font:(self font).
"/    self extent:(myMenu extent).
!

initializeLogo
    logoLabel := Label in:self.
    logoLabel form:(Image fromFile:'bitmaps/SmalltalkX.xbm').
    logoLabel origin:0.0 @ 0.0.
    logoLabel borderWidth:0.
    logoLabel viewBackground:viewBackground.
    logoLabel backgroundColor:viewBackground.
!

initializeMenu
    myMenu := ClickMenuView 
                labels:(resources array:#(
                                'Browsers'
                                'Workspace'
                                'File Browser'
                                'Projects'
                                '-'
                                'Utilities'
                                'Goodies'
                                'Games & Demos'
                                '-'
                                'Info & Help'
                                '-'
                                'Snapshot'
                                '-'
                                'Exit'
                        ))
                selectors:#(browserMenu
                            startWorkspace
                            startFileBrowser
                            projectMenu
                            nil
                            utilityMenu
                            goodyMenu
                            gamesMenu
                            nil
                            helpMenu
                            nil
                            saveImage
                            nil
                            exitSmalltalk
                           )
                receiver:self
                      in:self.

    myMenu subMenuAt:#browserMenu put:(
        PopUpMenu labels:(resources array:#(
                            'System Browser'
                            'Class Hierarchy...'
                            'Implementors...'
                            'Senders...'
                            '-'
                            'Changes Browser'
                            '-'
                            'Directory'
                           ))
               selectors:#(
                            startSystemBrowser
                            startHierarchyBrowser
                            startImplementorsBrowser
                            startSendersBrowser
                            nil
                            startChangesBrowser
                            nil
                            startDirectoryBrowser
                           )
                receiver:self
                     for:self

    ).

    myMenu subMenuAt:#utilityMenu put:(
        PopUpMenu labels:(resources array:#(
                            'Transcript'
                            'New Launcher'
                            '-'
                            'Window tree'
                            'View inspect'
                            'View destroy'
                            'Class tree'
                            '-'
                            'Event monitor'
                            'Process monitor'
                            'Memory monitor'
                            'Memory usage'
                            '-'
                            'Collect Garbage'
                            'Collect Garbage & compress'
                            '-'
                            'Full screen Hardcopy'
                            'Screen area Hardcopy'
                            'View Hardcopy'
                            '-'
                            'ScreenSaver'
                           ))
               selectors:#(
                            startTranscript
                            startNewLauncher
                            nil
                            startWindowTreeView
                            viewInspector
                            viewKiller
                            startClassTreeView
                            nil
                            startEventMonitor
                            startProcessMonitor
                            startMemoryMonitor
                            startMemoryUsage
                            nil
                            garbageCollect
                            compressingGarbageCollect
                            nil
                            fullScreenHardcopy
                            screenHardcopy
                            viewHardcopy
                            nil
                            screenSaverMenu
                           )
                receiver:self
                     for:self
    ).

    (myMenu subMenuAt:#utilityMenu) subMenuAt:#screenSaverMenu put:(
        PopUpMenu labels:(resources array:#(
                            'Simple'
                            'Spotlight'
                            'Moving spotlight'
                           ))
               selectors:#(
                            startScreenSaver1
                            startScreenSaver2
                            startScreenSaver3
                           )
                receiver:self
                     for:self
    ).

    (Screen current isKindOf:GLXWorkstation) ifTrue:[
        myMenu subMenuAt:#gamesMenu put:(
            PopUpMenu labels:(resources array:#(
                                'Tetris'
                                'TicTacToe'
                                '-'
                                'PenDemo'
                                'CommanderDemo' 
                                '-'
                                'Animation'
                                'Globe'
                                '-'
                                'GL 3D demos'
                                '-'
                                'LogicTool'
                               ))
                   selectors:#(
                                startTetris
                                startTicTacToe
                                nil
                                startPenDemo
                                startCommanderDemo
                                nil
                                startAnimation
                                startGlobeDemo
                                nil
                                glDemos
                                nil
                                startLogicTool
                              )
                    receiver:self
                         for:self
        ).
        (myMenu subMenuAt:#gamesMenu) subMenuAt:#glDemos put:(
            PopUpMenu labels:(resources array:#(
                                'plane'
                                'tetra'
                                'cube (wireframe)'
                                'cube (solid)'
                                'cube (light)'
                                'cube (light & texture)'
                                'sphere (wireframe)'
                                'sphere (light)'
                                'planet'
                                'teapot'
                                'logo'
                               ))
                    selector:#openDemo:
                        args:#(
                                GLPlaneDemoView2
                                GLTetraDemoView
                                GLWireCubeDemoView
                                GLCubeDemoView
                                GLCubeDemoView2
                                GLBrickCubeDemoView
                                GLWireSphereDemoView
                                GLSphereDemoView2
                                GLPlanetDemoView
                                GLTeapotDemo
                                Logo3DView1
                              )
                    receiver:self
                         for:self
        ).
    ] ifFalse:[
        myMenu subMenuAt:#gamesMenu put:(
            PopUpMenu labels:(resources array:#(
                                'Tetris'
                                'TicTacToe'
                                '-'
                                'PenDemo'
                                'CommanderDemo' 
                                '-'
                                'Animation'
                                'Globe'
                                '-'
                                'LogicTool'
                               ))
                    selector:#openDemo:
                        args:#(
                                Tetris
                                TicTacToe
                                nil
                                PenDemo
                                CommanderDemo
                                nil
                                Animation
                                GlobeDemo
                                nil
                                LogicTool
                              )
                    receiver:self
                         for:self
        )
    ].

    Project notNil ifTrue:[
        myMenu subMenuAt:#projectMenu put:(
            PopUpMenu labels:(resources array:#(
                                'New project'
                                '-'
                                'Select project'
                               ))
                   selectors:#(
                                newProject
                                nil
                                selectProject
                              )
                    receiver:self
                         for:self
        ).
    ].

    myMenu subMenuAt:#goodyMenu put:(
        PopUpMenu labels:(resources array:#(
                            'Clock'
                            'Round Clock'
"
                            'Address Book'
"
                            '-'
                            'Calendar'
                            'Directory View'
                            'MailTool'
                            'NewsTool'
                            '-'
                            'DrawTool'
                           ))
               selectors:#(
                            startClock
                            startRoundClock
"
                            startAddressBook
"
                            nil
                            startCalendar
                            startDirectoryView
                            startMailTool
                            startNewsTool
                            nil
                            startDrawTool
                          )
                receiver:self
                     for:self

    ).

    myMenu subMenuAt:#helpMenu put:(
        PopUpMenu labels:(resources array:#(
                            'About'
                            'Online HTML Documentation'
                            '-'
                            'Overview'
                            'Getting started'
                            'Customizing'
                            'Tools'
                            'programming'
                            'other topics'
"/                            '-'
"/                            'Help Browser'
                           ))
               selectors:#(
                            showAbout
                            showHTMLDocumentation
                            nil
                            showOverview
                            showGettingStarted
                            showCustomizing
                            tools
                            programming
                            otherTopics
"/                            nil
"/                            startOnlineHelpView
                          )
                receiver:self
                     for:self

    ).

    (myMenu subMenuAt:#helpMenu) subMenuAt:#tools put:(
        PopUpMenu labels:(resources array:#(
                            'System Browser'
                            'File Browser'
                            'Changes Browser'
                            'Debugger'
                            'Inspector'
                           ))
                selector:#showOnlineHelp:
                    args:#('tools/sbrowser/TOP'
                           'tools/fbrowser/TOP'
                           'tools/cbrowser/TOP'
                           'tools/debugger/TOP'
                           'tools/misc/TOP')
                receiver:self
                     for:self

    ).

    (myMenu subMenuAt:#helpMenu) subMenuAt:#otherTopics put:(
        PopUpMenu labels:(resources array:#(
                            'ST/X history'
                            'Garbage collection'
                            'Language & primitives'
                            'Error messages'
                            '-'
                            'Stc manual page'
                            'Smalltalk manual page'
                           ))
                selector:#showOnlineHelp:
                    args:#('misc/history'
                           'programming/GC'
                           'programming/language'
                           'programming/errormsg'
                            nil
                           'misc/stc'
                           'misc/smalltalk')
                receiver:self
                     for:self

    ).

    (myMenu subMenuAt:#helpMenu) subMenuAt:#programming put:(
        PopUpMenu labels:(resources array:#(
                            'Useful selectors'
                            'Views - quick intro'
                            'Breakpoints & tracing'
                            'Processes'
                            'Timers & delays'
                            'Exceptions & signals'
                            'GL 3D graphics'
                           ))
                selector:#showOnlineHelp:
                    args:#('programming/selectors'
                           'programming/viewintro'
                           'programming/debugging'
                           'programming/processes'
                           'programming/timing'
                           'programming/exceptions'
                           'programming/GL')
                receiver:self
                     for:self

    ).
!

realize
    |myExtent|

    myExtent := (myMenu extent + (0 @ (logoLabel height))).
    self extent:myExtent.
    self minExtent:myExtent.
    self maxExtent:myExtent.
    super realize.

    "
     catch errors - don't want a debugger here ...
     (this must be done here, since #initialize runs under another process)
    "
    Processor activeProcess emergencySignalHandler:[:ex |
        |box|

"/ old:
"/        box := YesNoBox title:('Error while launching ...\' , ex errorString , '\\debug ?') withCRs.
"/        "
"/         icon should be whatever WarnBoxes use as icon
"/        "
"/        box formLabel form:(WarningBox new formLabel label).
"/        box yesAction:[Debugger 
"/                           enter:ex suspendedContext
"/                           withMessage:ex errorString].

"/ new:
        box := OptionBox 
                title:('Error while launching ...\' , ex errorString , '\\') withCRs
                numberOfOptions:3.
        box label:'Warning'.
        "
         icon should be whatever WarnBoxes use as icon
        "
        box form:(WarningBox new formLabel label).
        box buttonTitles:(resources array:#('abort' 'continue' 'debug')).
        box actions:(Array with:[AbortSignal raise]
                           with:[ex resume]
                           with:[Debugger 
                                        enter:ex suspendedContext
                                        withMessage:ex errorString.
                                 ex resume.]
                    ).

        box showAtPointer.
        AbortSignal raise.
    ].
!

reinitialize
    "sent after snapin - first reinit menuview,
     then adjust my size"

    super reinitialize.
"/    myMenu reinitialize.
"/    self extent:(myMenu extent).
! !

!OldLauncher methodsFor:'menu actions'!

exitSmalltalk
    |exitBox|

    exitBox := EnterBox2 title:(resources at:'save state before exiting ?\\filename for image:') withCRs.
    exitBox okText:(resources at:'exit').
    exitBox okText2:(resources at:'save & exit').
    exitBox label:'exit Smalltalk'.

    exitBox action:[:dummyName | 
	self closeDownViews.
	Smalltalk exit
    ].

    exitBox action2:[:fileName | 
	(ObjectMemory snapShotOn:fileName) ifFalse:[
	    "
	     snapshot failed for some reason (disk full, no permission etc.)
	     Do NOT exit in this case.
	    "
	    self warn:(resources string:'failed to save snapshot image (disk full or not writable)').
	] ifTrue:[
	    "
	     closeDownViews tells all views to shutdown neatly 
	     (i.e. offer a chance to save the contents to a file).

	     This is NOT required - all data should be in the snapshot ...
	     ... however, if remote disks/mountable filesystems are involved,
	     which may not be present the next time, it may make sense to 
	     uncomment it and query for saving - time will show which is better.
	    "
"
	    self closeDownViews.
"
	    Smalltalk exit
	]
    ].

    exitBox initialText:(ObjectMemory nameForSnapshot).
    exitBox showAtPointer
!

saveImage
    |saveBox|

    saveBox := EnterBox title:(resources at:'filename for image:') withCRs.
    saveBox okText:(resources at:'save').
    saveBox action:[:fileName | 
	(ObjectMemory snapShotOn:fileName) ifFalse:[
	    "
	     snapshot failed for some reason (disk full, no permission etc.)
	     Do NOT exit in this case.
	    "
	    self warn:(resources string:'failed to save snapshot image (disk full or not writable)').
	]
    ].

    saveBox initialText:(ObjectMemory nameForSnapshot).
    saveBox label:'save image'.
    saveBox showAtPointer
!

startChangesBrowser
    ChangesBrowser open
!

startDirectoryBrowser
    DirectoryBrowser open
!

startDirectoryView
    DirectoryView open
!

startFileBrowser
    FileBrowser open
!

startHierarchyBrowser
    |enterBox|

    enterBox := EnterBox title:(resources at:'name of class:') withCRs.
    " enterBox abortText:(resources at:'abort')." "this is the default anyway"
    enterBox okText:(resources at:'browse').

    enterBox action:[:className |
	|class|

	class := Smalltalk at:className asSymbol ifAbsent:[nil].
	class isBehavior ifFalse:[
	    self warn:'no such class'
	] ifTrue:[
	    SystemBrowser browseClassHierarchy:class
	]
    ].
    enterBox showAtPointer
!

startImplementorsBrowser
    |enterBox|

    enterBox := EnterBox title:(resources at:'selector:') withCRs.
    " enterBox abortText:(resources at:'abort')." "this is the default anyway"
    enterBox okText:(resources at:'browse').

    enterBox action:[:selectorName |
	SystemBrowser browseImplementorsOf:selectorName  
    ].
    enterBox showAtPointer
!

startNewLauncher
    NewLauncher open.
    super destroy
!

startSendersBrowser
    |enterBox|

    enterBox := EnterBox title:(resources at:'selector:') withCRs.
    " enterBox abortText:(resources at:'abort')." "this is the default anyway"
    enterBox okText:(resources at:'browse').

    enterBox action:[:selectorName |
	SystemBrowser browseAllCallsOn:selectorName 
    ].
    enterBox showAtPointer
!

startSystemBrowser
    SystemBrowser open
!

startWorkspace
    Workspace open
! !

!OldLauncher methodsFor:'misc'!

processName
    "the name of my process - for the processMonitor only"

    ^ 'OldLauncher'.

    "Modified: 9.9.1996 / 22:45:17 / stefan"
! !

!OldLauncher methodsFor:'private'!

closeDownViews
    "tell each topview that we are going to terminate and give it chance
     to save its contents."

    ObjectMemory changed:#aboutToExit
!

saveScreenImage:anImage
    "save an image into a file 
     - ask user for filename using a fileSelectionBox."

    |fileName|

    fileName := Dialog
		    requestFileName:'save image in:'
		    default:''
		    ok:'save'
		    abort:'abort'
		    pattern:'*.tiff'.

    fileName notNil ifTrue:[
	anImage saveOn:fileName
    ].
!

showDocumentFile:name
    |s f relPath isHtml isRTF|

    s := Smalltalk systemFileStreamFor:('doc/online/english/' , name , '.html').
    s notNil ifTrue:[
        s close.
        HTMLDocumentView openFullOnDocumentationFile:name , '.html'. 
        ^ self
    ].

    relPath := 'doc/online/english/' , name.

    isRTF := true.
    s := Smalltalk systemFileStreamFor:relPath , '.rtf'.
    s isNil ifTrue:[
        isRTF := false.
        s := Smalltalk systemFileStreamFor:relPath , '.doc'.
        s isNil ifTrue:[
            self warn:('document ' , relPath , ' (.rtf/.doc) not available.\\check your installation.' withCRs).
            ^ nil
        ].
    ].
    f := s pathName.

    isRTF ifTrue:[
        DocumentView openOn:f.
        ^ self
    ].

    (Workspace openOn:f) readOnly
! !

!OldLauncher methodsFor:'project menu actions'!

newProject
    (ProjectView for:(Project new)) open
!

projectMenu
    "this is sent, if ST/X has been built without Projects/ChangeSets."

    self warn:'The system has been built without support for projects'.
!

selectProject
    |list box|

    list := Project allInstances.
    box := ListSelectionBox new.
    box list:(list collect:[:p | p name]).
    box title:(resources string:'select a project').
    box action:[:selection |
	|project|

	project := list detect:[:p | p name = selection] ifNone:[nil].
	project isNil ifTrue:[
	    Transcript showCR:'no such project'
	] ifFalse:[
	    project showViews.
	    Project current:project
	]
    ].
    box showAtPointer
! !

!OldLauncher methodsFor:'utility menu actions'!

compressingGarbageCollect
    ObjectMemory verboseGarbageCollect
!

fullScreenHardcopy
    "after a second (to allow redraw of views under menu ...),
     save the contents of the whole screen."

    Processor addTimedBlock:[
	self saveScreenImage:(Image fromScreen)
    ] afterSeconds:1
!

garbageCollect
    ObjectMemory markAndSweep
!

screenHardcopy
    "after a second (to allow redraw of views under menu ...),
     let user specify a rectangular area on the screen
     and save its contents."

    |area|

    Processor addTimedBlock:[
	area := Rectangle fromUser.
	(area width > 0 and:[area height > 0]) ifTrue:[
	    self saveScreenImage:(Image fromScreen:area)
	]
    ] afterSeconds:1
!

startClassTreeView
    ClassTreeGraphView open
!

startEventMonitor
    EventMonitor open
!

startMemoryMonitor
    MemoryMonitor open
!

startMemoryUsage
    MemoryUsageView open
!

startProcessMonitor
    ProcessMonitor open
!

startScreenSaver1
    ScreenSaver open
!

startScreenSaver2
    LightInTheDark open
!

startScreenSaver3
    LightInTheDark2 open
!

startTranscript
    (Transcript isKindOf:TextCollector) ifTrue:[
	"there is only one transcript - rais it"
	Transcript topView raiseDeiconified.
    ] ifFalse:[
	Transcript := TextCollector newTranscript
    ]
!

startWindowTreeView
    WindowTreeView isNil ifTrue:[
        self warn:'Class not loaded: WindowTreeView'.
        ^ self.
    ].
    WindowTreeView open
!

viewHardcopy
    "after a second (to allow redraw of views under menu ...),
     let user specify a view and save its contents."

    Processor addTimedBlock:[
	|v|

	v := Screen current viewFromUser.
	v notNil ifTrue:[
	    self saveScreenImage:(Image fromView:(v topView))
	]
    ] afterSeconds:1
!

viewInspector
    |v|

    (Delay forSeconds:1) wait.
    v := Screen current viewFromUser.
    v isNil ifTrue:[
	self warn:'sorry, this is not a smalltalk view'
    ] ifFalse:[
	v topView inspect
    ]
!

viewKiller
    |v|

    (Delay forSeconds:1) wait.
    v := Screen current viewFromUser.
    v isNil ifTrue:[
	self warn:'sorry, this is not a smalltalk view'
    ] ifFalse:[
	v topView destroy
    ]
! !

!OldLauncher class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

