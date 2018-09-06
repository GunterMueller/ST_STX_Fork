"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

AbstractLauncherApplication subclass:#Launcher
	instanceVariableNames:'myMenu buttonPanel infoView projectInfoHolder helpIsOn
		isMainLauncher'
	classVariableNames:'CachedAboutIcon'
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!Launcher class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

customization
"
    Of course, it is possible to change the Launcher class itself
    as appropriate, however, we suggest you create a subclass (say MyLauncher),
    define it as autoloaded in the patches file, and redefine some methods
    in that class. 
    That way, your changes are easier to reintroduce in case of an ST/X upgrade.


    adding more buttons to the button-panel:

      see the method #buttonPanelSpec;
	it defines a list of selectors and icons, which is used by 
	#setupButtonPanelIn:. 
	There, for each entry, a button with that icon is created, 
	which sends a selector-message to the launcher.

	Add entries to that list, and define appropriate methods.
	For example, to add a button which opens a drawTool,
	change #buttonPanelSpec to:

	buttonPanelSpec
	    ^ #(
		#(startSystemBrowser  'SBrowser32x32.xbm')
		#(startFileBrowser    'FBrowser32x32.xbm')
		#(nil nil)
		#(startChangesBrowser 'CBrowser32x32.xbm')
		#(nil nil)
		#(nil nil)
		#(startDrawTool       'DrawTool.xbm')
	     )

	the panel adjusts its height as appropriate - you may want to
	create new (small) icons for a good look.

    adding an entry to a menu:

	see the #setupMenu method; either add another top-menu, or
	add entries to an existing menu.
	All menu setup has been extracted into separate init-methods,
	so there is often only a need to redefine one of those
	(for example, to add your own demos, only redefine setupDemoMenu).
	To add a new master-item with its own pullDown, redefine setupMainMenu
	to include another selector and add the correspoonding menu there.
"
!

documentation
"
    WARNING:
        This is a old part of the ST/X system, and no longer maintained.
        This used to be the launcher some time ago (in the late 90s).
        It has been obsoleted by the NewLauncher, which provides
        a similar look, but is completely implemented using the
        new GUI framework.
        (this older launcher is hand-written)


    This combines the old Launcher's menu and Transcript into one view. 
    (you no longer have to move two views around all the time...).

    Also, this is the first app to make use of the new compatibility framework;
    you will notice, that this is a subclass of ApplicationModel.
    New applications will no longer be built as subclasses of StandardSystemView.

    See #customization for information regarding your own private
    launcher functions.

    Notice:
        Since there can only be one SystemTranscript, opening a new launcher
        will automatically close the current one (except for a remote launcher,
        opened on another display).

    Notice2:
        By the time you read this, this 'new launcher' is already old again;
        we have written a completely new newLauncher, using the GUI painter tools,
        which provides the same functionality, but has all of its GUI, menus and
        icon bitmaps been generated using convenient tools.
        Look into NewLauncher if you need coding examples on GUI programming.

    [author:]
        Claus Gittinger

    [see also:]
        Examples_misc::MyLauncher

    [start with:]
        Launcher open
"
!

examples
"
    As ST/X can handle multiple screens, there is nothing (except fear ;-)
    from preventing you to work with your friend in the same image.
    To do this, evaluate (replace localhost by whatever):
									[exBegin]
	|display2|

	display2 := XWorkstation new initializeFor:'localhost:0'.
	display2 isNil ifTrue:[
	    self warn:'cannot connect.'.
	] ifFalse:[
	    display2 startDispatch.
	    display2 keyboardMap:(Display keyboardMap).
	    Launcher openOnDevice:display2.
	]
									[exEnd]
    But you should be somewhat careful, the other guy may change things so
    that you are blocked (start high prio processes, change classes etc.)
    Anyway, a nice demo ....
"
! !

!Launcher class methodsFor:'defaults'!

aboutIcon
    "return the icon shown in the about menu-item and used
     as ST/X about icon"

    |image|

    CachedAboutIcon notNil ifTrue:[^ CachedAboutIcon].

    image := Image fromFile:'SmalltalkX.xbm'.
    image notNil ifTrue:[
	|green dark|

	Screen current hasColors ifTrue:[
	    green := (Color redPercent:0 greenPercent:80 bluePercent:20) "darkened".
	    dark := Color grayPercent:10.
	    image photometric:#palette.
	] ifFalse:[
	    dark := Color black.
	    green := Color white.
	    image photometric:#blackIs0.
	].
	image colorMap:(Array with:dark with:green).
"/        Screen current depth > 2 ifTrue:[
"/            image := (Image implementorForDepth:Screen current depth) fromImage:image.
"/        ]
    ].
    CachedAboutIcon := image.
    ^ image

    "
     CachedAboutIcon := nil.
     Launcher aboutIcon
    "

    "Modified: 9.9.1996 / 22:41:23 / stefan"
    "Modified: 8.1.1997 / 15:01:30 / cg"
!

buttonImageSize
    "images in buttonPanel are sized to this.
     Can be redefined in subclasses to return nil (no scaling)
     or any other useful size"

    <resource: #style (#'launcher.buttonSize')>

    ^ View styleSheet at:'launcher.buttonSize' default:(32@32)

    "Modified: / 26.10.1997 / 17:07:40 / cg"
!

smallAboutIcon
    "return the icon shown in the about menu-item"

    |image|

    image := self aboutIcon.
    image notNil ifTrue:[
	image := image magnifiedBy:0.4.
    ].
    ^ image

    "
     CachedAboutIcon := nil.
     Launcher aboutIcon.
     Launcher smallAboutIcon.
    "

    "Modified: 9.9.1996 / 22:42:12 / stefan"
    "Modified: 8.1.1997 / 15:02:56 / cg"
! !

!Launcher methodsFor:'actions - about & help'!

startLauncherHelp
    "open an HTML browser on the 'launcher-help' document"

    self showDocumentation:'help/launcher/launcher.html'

    "Modified: / 31.8.1995 / 13:11:28 / claus"
    "Modified: / 8.1.1997 / 14:41:23 / cg"
    "Created: / 31.10.1997 / 15:59:28 / cg"
!

toggleActiveHelp:aBoolean
    "turn on/off active help"

    ActiveHelp notNil ifTrue:[
	helpIsOn := aBoolean.
	helpIsOn ifTrue:[
	    ActiveHelp start
	] ifFalse:[
	    ActiveHelp stop
	]
    ].

    "Modified: 8.1.1997 / 14:37:30 / cg"
! !

!Launcher methodsFor:'actions - classes'!

startClassTreeView
    "open a classHierarchyTree view"

    self withWaitCursorDo:[ClassTreeGraphView open]

    "Modified: 8.1.1997 / 14:48:38 / cg"
!

startFileBrowser
    "open a fileBrowser"

    self withWaitCursorDo:[FileBrowser open]

    "Modified: 8.1.1997 / 14:48:47 / cg"
!

startJavaBrowser
    "open a javaBrowser (not included in the standard distribution)"

    |jb|

    (jb := Smalltalk at:#JavaBrowser) notNil ifTrue:[
        self withWaitCursorDo:[jb open]
    ]

    "Created: 18.4.1996 / 15:55:44 / cg"
    "Modified: 8.1.1997 / 14:47:31 / cg"
!

startSystemBrowser
    "open a systemBrowser"

    self withWaitCursorDo:[SystemBrowser open]

    "Modified: 8.1.1997 / 14:47:43 / cg"
!

startWorkspace
    "open a workspace"

    Workspace open

    "Modified: 8.1.1997 / 14:47:49 / cg"
! !

!Launcher methodsFor:'actions - demos'!

openDemo:className
    "open a demo, given its name.
     Looks in both the Smalltalk- and the Demos-Namespace
     for that class."

    self openApplication:className nameSpace:Demos

    "Modified: 8.1.1997 / 14:51:02 / cg"
!

openGame:className
    "open a game, given its name.
     Looks in both the Smalltalk- and the Games-Namespace
     for that class."

    self openApplication:className nameSpace:Games

    "Modified: 8.1.1997 / 14:51:18 / cg"
    "Created: 28.1.1997 / 00:49:21 / cg"
!

startTetris
    "opens a tetris game"

    self openGame:'Tetris'

    "Modified: 28.1.1997 / 00:49:40 / cg"
!

startTicTacToe
    "opens a ticTacToe game against the machine"

    self openGame:'TicTacToeGame'

    "Modified: 28.1.1997 / 00:49:44 / cg"
!

startTicTacToe2
    "opens a 2-user ticTacToe game"

    self openApplication:'TicTacToeGame' nameSpace:Games with:#open2UserGame

    "Modified: 28.1.1997 / 00:49:50 / cg"
! !

!Launcher methodsFor:'actions - file'!

exit
    "stop ST/X - after asking for confirmation"

    (self confirm:(resources string:'Are you certain you want to exit without saving ?'))
    ifTrue:[
        Smalltalk exit
    ]

    "Modified: 8.1.1997 / 14:50:00 / cg"
!

snapshot
    "saves a snapshot image, after asking for a fileName"

    |fileName|

    fileName := DialogBox
		    request:(resources at:'filename for image:') withCRs
	      initialAnswer:(ObjectMemory nameForSnapshot) 
		    okLabel:(resources at:'save')
		      title:(resources string:'save image')
		   onCancel:nil.

    fileName notNil ifTrue:[
	self showCursor:Cursor write.
	[
	    (ObjectMemory snapShotOn:fileName) ifFalse:[
		"
		 snapshot failed for some reason (disk full, no permission etc.)
		"
		self warn:(resources string:'failed to save snapshot image (disk full or not writable)').
	    ]
	] valueNowOrOnUnwindDo:[
	    self restoreCursors.
	].
    ].

    "Modified: 8.1.1997 / 14:50:29 / cg"
!

snapshotAndExit
    "saves a snapshot image and exits, after asking for a fileName"

    |fileName ok|

    fileName := DialogBox
		    request:(resources at:'filename for image:') withCRs
	      initialAnswer:(ObjectMemory nameForSnapshot) 
		    okLabel:(resources at:'save & exit')
		      title:(resources string:'save image & exit')
		   onCancel:nil.

    fileName notNil ifTrue:[
	self showCursor:Cursor write.
	[
	    ok := ObjectMemory snapShotOn:fileName.
	] valueNowOrOnUnwindDo:[
	    self restoreCursors.
	].

	ok ifFalse:[
	    "
	     snapshot failed for some reason (disk full, no permission etc.)
	     Do NOT exit in this case.
	    "
	    self warn:(resources string:'failed to save snapshot image (disk full or not writable)').
	] ifTrue:[
	    "
	     saveAllViews tells all views to shutdown neatly 
	     (i.e. offer a chance to save the contents to a file).

	     This is NOT required - all data should be in the snapshot ...
	     ... however, if remote disks/mountable filesystems are involved,
	     which may not be present the next time, it may make sense to 
	     uncomment it and query for saving - time will show which is better.
	    "
"
	    self saveAllViews.
"
	    Smalltalk exit
	]
    ].

    "Modified: 8.1.1997 / 14:50:36 / cg"
! !

!Launcher methodsFor:'actions - goodies'!

openGoodie:className
    "open a goodie, given its name.
     Looks in both the Smalltalk- and the Goodies-Namespace
     for that class."

    self openApplication:className nameSpace:Goodies

    "Modified: 8.1.1997 / 14:51:18 / cg"
!

startCalendar
    "open a calendar goodie"

    self openGoodie:'Calendar'

    "Modified: 8.1.1997 / 14:51:29 / cg"
!

startClock
    "open a clock goodie"

    self openGoodie:'RoundClock'

    "Modified: 8.1.1997 / 14:51:34 / cg"
!

startMailTool
    "open a mailView goodie"

    self openGoodie:'MailView'

    "Modified: 8.1.1997 / 14:51:42 / cg"
!

startNewsTool
    "open a newsTool goodie"

    self openGoodie:'NewsView'

    "Modified: 8.1.1997 / 14:51:48 / cg"
! !

!Launcher methodsFor:'actions - tools'!

globalGarbageCollect
    "perform a non-compressing garbageCollect"

    self withWaitCursorDo:[ObjectMemory reclaimSymbols]

    "Created: / 12.5.1996 / 15:28:13 / cg"
    "Modified: / 16.5.1998 / 02:43:50 / cg"
!

startApplication:aSymbol
    "start an application,
     popup warnbox if application is not present or autoload failed"

    |app|

    app := Smalltalk classNamed:aSymbol.
    app isBehavior ifTrue:[
	app isLoaded ifFalse:[
	    Autoload autoloadFailedSignal handle:[:ex|
		^ self warn:(resources string:'Sorry - cannot load %1' with:app name).
	    ] do:[
		app autoload.
	    ].
	].
	app open.
    ] ifFalse:[
	self warn:(resources 
			string:'Sorry - %1 is not available in this release'
			with:aSymbol asString).
    ]

    "Created: / 19.12.1997 / 13:00:29 / stefan"
    "Modified: / 19.12.1997 / 14:09:46 / stefan"
    "Modified: / 14.8.1998 / 13:04:59 / cg"
!

startFullWindowTreeView
    "open a windowTree view (on all views)"

    WindowTreeView open

    "Modified: 8.1.1997 / 14:56:04 / cg"
!

startGUIBuilder
    "open a GUIBuilder view"

    UIPainter isNil ifTrue:[
	^ self warn:'The UIPainter is not available in this release.'
    ].
    UIPainter open

    "Created: / 25.7.1997 / 10:56:30 / cg"
    "Modified: / 14.8.1998 / 13:05:42 / cg"
! !

!Launcher methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "care for project changes & update my infoView"

    ((something == #currentProject)
    or:[changedObject == Project]) ifTrue:[
	self updateInfo.
	^ self
    ].

    "Modified: 28.7.1997 / 18:39:39 / cg"
! !

!Launcher methodsFor:'drag & drop'!

canDrop:aCollectionOfDropObjects in:aComponent
    "I accept fileObjects in the fileBrowser button
     and open a fileBrowser ..."

    aCollectionOfDropObjects size ~~ 1 ifTrue:[^ false].
    ^ aCollectionOfDropObjects first isFileObject

    "Modified: 11.4.1997 / 12:42:59 / cg"
!

drop:aCollectionOfDropObjects in:aComponent at:aPoint 
    "I accept fileObjects and will open a fileBrowser ..."

    |singleDropObject|

    aCollectionOfDropObjects size == 1 ifFalse:[
	transcript showCR:'can only drop single objects'.
	^ self
    ].
    singleDropObject := aCollectionOfDropObjects first.

    singleDropObject isFileObject ifTrue:[
	FileBrowser openOnFileNamed:(singleDropObject theObject pathName)
    ].

    "Modified: 11.4.1997 / 12:44:29 / cg"
! !

!Launcher methodsFor:'dynamic menus'!

addMenu:name withItems:items actions:actions
    "dynamically add a new (user-)menu to the menu panel.
     This allows applications to install items for themself
     dynamically in the launcher."

    |subMenu|

    myMenu add:name selector:(name asSymbol) before:#help.
    subMenu := MenuView forMenu:myMenu.
    subMenu labels:items.
    subMenu actions:actions.
    myMenu at:name putMenu:subMenu

    "
     |launcher actionBlocks|

     actionBlocks := Array new:3.
     actionBlocks at:1 put:[Transcript showCR:'foo'].
     actionBlocks at:2 put:[Transcript showCR:'bar'].

     launcher := Transcript topView application.
     launcher 
	addMenu:'misc' 
	withItems:#('foo' 'bar')
	actions:actionBlocks
    "

    "
     |launcher actionBlocks|

     actionBlocks := Array new:3.
     actionBlocks at:1 put:[RDoItServer startServer].
     actionBlocks at:2 put:[RDoItServer killServer].
                
     launcher := Transcript topView application.
     launcher 
	addMenu:'misc' 
	withItems:#('start rdoit server' 'stop rdoit server')
	actions:actionBlocks
    "

    "Modified: 5.7.1996 / 11:45:19 / cg"
!

menuAt:nameSymbol
    "return a menu by name"

    ^ myMenu subMenuAt:nameSymbol

    "
     |launcher demoMenu|

     launcher := Transcript topView application.
     demoMenu := launcher menuAt:#demos.
     demoMenu
	addLabels:#('-' 'fooBar')
	selectors:#(nil fooBar).
     demoMenu actionAt:#fooBar put:[Transcript showCR:'fooBar']
    "

    "Created: 11.7.1996 / 15:35:13 / cg"
    "Modified: 11.7.1996 / 15:42:25 / cg"
!

removeMenu:name
    "dynamically remove a (user-)menu from the menu panel.
     This allows applications to de-install items for themself
     dynamically in the launcher."

    myMenu remove:name 

    "
     |launcher actionBlocks|

     actionBlocks := Array new:3.
     actionBlocks at:1 put:[Transcript showCR:'foo'].
     actionBlocks at:2 put:[Transcript showCR:'bar'].

     launcher := Transcript topView application.
     launcher 
	addMenu:'misc' 
	withItems:#('foo' 'bar')
	actions:actionBlocks.

     Delay waitForSeconds:10.

     launcher removeMenu:'misc'
    "

    "Created: 5.7.1996 / 11:44:54 / cg"
    "Modified: 5.7.1996 / 11:54:36 / cg"
! !

!Launcher methodsFor:'help'!

helpTextFor:aComponent
    "activeHelp interface: return some help text for a component"

    |sel s buttons|

    aComponent == transcript ifTrue:[
	s := 'TRANSCRIPT_HELP'
    ].

    aComponent == infoView ifTrue:[
	s := 'INFOVIEW_HELP'
    ].

    buttons := buttonPanel subViews.
    (buttons notNil and:[buttons includes:aComponent]) ifTrue:[
	"kludge: look for its change selector"
	sel := aComponent changeMessage.
	sel == #startSystemBrowser ifTrue:[
	    s := 'SBROWSER_BUTTON_HELP'
	].
	sel == #startFileBrowser ifTrue:[
	    s := 'FBROWSER_BUTTON_HELP'
	].
	sel == #startChangesBrowser ifTrue:[
	    s := 'CBROWSER_BUTTON_HELP'
	].
    ].
    s notNil ifTrue:[
	^ resources string:s
    ].
    ^ nil

    "Modified: 8.1.1997 / 14:57:34 / cg"
! !

!Launcher methodsFor:'infoview update'!

showActivity:someMessage
    "some activityNotification to be forwarded to the user;
     show it in the transcript here."

    transcript showCR:someMessage; endEntry

    "Created: 23.12.1995 / 12:38:29 / cg"
    "Modified: 5.7.1996 / 13:13:15 / cg"
!

updateInfo
    "update the infoView from the current project"

    |project projectName projectDir packageName defNameSpace msg args|

    (Project isNil or:[(project := Project current) isNil]) ifTrue:[
        projectName := '* none *'.
        projectDir := '.'.
        packageName := '* none *'.
    ] ifFalse:[
        projectName := project name.
        projectDir := project directory.
        packageName := project package.
        defNameSpace := project defaultNameSpace.
    ].
    defNameSpace isNil ifTrue:[
        defNameSpace := Smalltalk.
    ].

    defNameSpace == Smalltalk ifTrue:[
        msg := 'project: ''%1''  fileOut to: ''%3''  package: ''%2'''.
        args := Array 
                    with:projectName
                    with:packageName 
                    with:(projectDir contractTo:30).
    ] ifFalse:[
        msg := 'project: ''%1''  fileOut to: ''%3''  package: ''%2''  nameSpace: %4'.
        args := Array 
                        with:projectName
                        with:packageName 
                        with:(projectDir contractTo:30)
                        with:defNameSpace name.
    ].
        
    projectInfoHolder value:(resources string:msg withArgs:args)

    "Created: 28.7.1997 / 18:39:15 / cg"
    "Modified: 28.7.1997 / 18:42:40 / cg"
! !

!Launcher methodsFor:'initialize - menus'!

disableDangerousMenuItemsInRemoteLauncher
    "if I am a remote launcher (multidisplay operation),
     disable menus which are dangerous or affect common state. 
     These operations have to
     be performed on the main screen."

    isMainLauncher ifFalse:[
	(myMenu menuAt:#file) disableAll:#(snapshot snapshotAndExit objectModuleDialog exit).
	(myMenu menuAt:#projects) disableAll.
	(myMenu menuAt:#settings) disableAll:#(languageSetting viewStyleSetting fontSettings printerSettings messageSettings compilerSettings sourceAndDebuggerSettings memorySettings miscSettings saveSettings restoreSettings).
    ].

    "Created: 5.7.1996 / 17:00:50 / cg"
    "Modified: 11.4.1997 / 09:19:51 / cg"
!

setupAboutMenu
    <resource: #programMenu >

    "setup the about- pulldown menu"

    myMenu at:#about 
           putLabels:(resources array:#(
                                        'About Smalltalk/X...'
                                        '-'
                                        'Licence Conditions'
                                       ))
           selectors:#(
                                        #openAbout 
                                        nil
                                        #openLicenseConditions 
                      )
           receiver:self.

    "Created: / 8.1.1997 / 14:03:20 / cg"
    "Modified: / 29.10.1997 / 03:40:36 / cg"
!

setupClassesMenu
    <resource: #programMenu >

    |m labels selectors jb|

    "setup the classes- pulldown menu"

    labels := #(
        'System Browser'
        'Class Browser...'
        'Full Class Browser...'
        'Class Hierarchy Browser...'
        'Class Tree'
        '-'
        'Implementors...'
        'Senders...'
        'Special'
        '-'
        'Change Browser'
        ).

    selectors := #(
        #startSystemBrowser 
        #startClassBrowser 
        #startFullClassBrowser 
        #startClassHierarchyBrowser 
        #startClassTreeView 
        nil
        #browseImplementors 
        #browseSenders 
        #special 
        nil
        #startChangesBrowser 
        ).

    myMenu at:#classes 
           putLabels:(resources array:labels)
           selectors:selectors
           receiver:self.

    m := myMenu menuAt:#classes.
    m subMenuAt:#special 
      put:(PopUpMenu
                itemList: #(
                            ('References to Undeclared'      #browseUndeclared             )
                            ('Resource Methods...'           #browseResources              )
                            ('Show Break/Trace Points'       #browseAllBreakAndTracePoints )
                            ('-'                                                           )
                            ('Remove all Break/trace Points' #removeAllBreakAndTracePoints )
                           )
                resources:resources
          ).

    ((jb := Smalltalk at:#JavaBrowser) notNil 
    and:[jb isLoaded]) ifTrue:[
        (myMenu subMenuAt:#classes)
            addLabels:(resources array:#('-' 'Java Browser'))
            selectors:#(nil startJavaBrowser)
            after:#startClassTreeView
    ].

    "Created: / 8.1.1997 / 14:05:44 / cg"
    "Modified: / 13.1.1998 / 09:57:46 / cg"
!

setupDemoMenu
    "setup the demo- pulldown menu"

    <resource: #programMenu>

    |m|

    myMenu at:#demos 
           putLabels:(resources array:#(
                                        'Goodies'
                                        'Games'
                                        'Geometric Designs'
                                        'Simple Animations'
                                        '3D Graphics'
                                        'Graphic Editors'
                                       ))
           selectors:#(
                                        goodies
                                        games
                                        geometricDesigns
                                        simpleAnimations
                                        #'3Dgraphics'
                                        #graphicEditors
                      )
           receiver:self.

    "
     only to show two different ways of defining a popUpMenu,
     we use labels:selectors:receiver: here:
    "
    m := myMenu menuAt:#demos.
    m subMenuAt:#games
      put:(PopUpMenu
                itemList:#(
                           ('Tetris'                  startTetris     )
                           ('Tic Tac Toe'             startTicTacToe  )
                           ('Tic Tac Toe (2 players)' startTicTacToe2 )
                          )
                resources:resources).

    "
     and labels:selector:args:receiver: here:
    "
    m subMenuAt:#geometricDesigns
      put:(PopUpMenu
                itemList:#(
                           ('Pen demo'                   #openDemo:  nil PenDemo              )
                           ('Commander demo'             #openDemo:  nil CommanderDemo        )
                           ('-'                                                               )
                           ('Mandelbrot demo'            #openDemo:  nil ComplexIterationView )
                           ('Fractal plants demo'        #openDemo:  nil FractalPlantsDemo    )
                           ('Fractal patterns demo'      #openDemo:  nil FractalPatternsDemo  )
                           ('more fractal patterns demo' #openDemo:  nil ArmchairUniverseDemo )
                          )
                resources:resources).

    m subMenuAt:#simpleAnimations 
      put:(PopUpMenu
                itemList:#(
                           ('Animation'     #openDemo: nil Animation )
                           ('Globe demo'    #openDemo: nil GlobeDemo )
                         )
                resources:resources).

    m subMenuAt:#'3Dgraphics' 
      put:(PopUpMenu
                itemList:#( 
                            ('plane'                  #openDemo:  nil  GLPlaneDemoView2      )
                            ('tetra'                  #openDemo:  nil  GLTetraDemoView       )
                            ('cube (wireframe)'       #openDemo:  nil  GLWireCubeDemoView    )
                            ('cube (solid)'           #openDemo:  nil  GLCubeDemoView        )
                            ('sphere (wireframe)'     #openDemo:  nil  GLWireSphereDemoView  )
                            ('doughnut (wireframe)'   #openDemo:  nil  GLDoughnutDemoView    )
                            ('planet'                 #openDemo:  nil  GLPlanetDemoView      )
                            ('teapot'                 #openDemo:  nil  GLTeapotDemo          )
                            ('logo'                   #openDemo:  nil  Logo3DView1           )
                            ('rubics cube'            #openDemo:  nil  RubicsCubeView        )
                            ('x/y graph'              #openDemo:  nil  GLXYGraph             )
                            ('x/y graph widget'       #openDemo:  nil  #'CodingExamples_GUI::GLXYGraph3DDemo'        )
                            ('x/y graph animated'     #openDemo:  nil  #'CodingExamples_GUI::AnimatedGLXYGraph3DDemo')
                            ('-'                                                             )
                            ('cube (light)'           #openDemo:  nil  GLCubeDemoView2       )
                            ('cube (light & texture)' #openDemo:  nil  GLBrickCubeDemoView   )
                            ('sphere (light)'         #openDemo:  nil  GLSphereDemoView2     )
                            ('colored octahedron'     #openDemo:  nil  GLOctaHedronDemoView  )
                          )
                resources:resources).

    m subMenuAt:#graphicEditors 
      put:(PopUpMenu
                itemList:#(
                           ('DrawTool'   #openDemo:  nil  DrawTool       )
                           ('LogicTool'  #openDemo:  nil  LogicTool      )
                           ('Paint Demo' #openDemo:  nil  ColorDrawDemo3 )
                          )
                resources:resources).

    m subMenuAt:#goodies 
      put:(PopUpMenu
                itemList:#(
                            ('clock'          #openDemo:  nil  Clock            )
                            ('digital clock'  #openDemo:  nil  DigitalClockView )
                            ('calendar'       #openDemo:  nil  Calendar         )
                            ('calculator'     #openDemo:  nil  CalculatorView   )
                            ('-'                                                )
                            ('mail tool'      #openDemo:  nil  MailView         )
                            ('news tool'      #openDemo:  nil  NewsView         )
                            ('ftp tool'       #openDemo:  nil  FTPTool          )
                            ('telnet tool'    #openDemo:  nil  TelnetTool       )
                           )
                resources:resources).

    "Modified: / 28.7.1998 / 15:17:12 / cg"
!

setupFileMenu
    <resource: #programMenu >

    "setup the file- pulldown menu"

    |l s|

    l := #(
                'File Browser'
                '-'
                'Modules...'
                '-'
                'Snapshot...'
                'Snapshot & Exit...'
                'Exit Smalltalk...'
         ).
    s := #(
                #startFileBrowser
                nil
                #objectModuleDialog 
                nil
                #snapshot
                #snapshotAndExit
                #exit
         ).

    myMenu at:#file
           putLabels:(resources array:l)
           selectors:s
           receiver:self.

    "Created: / 8.1.1997 / 14:04:15 / cg"
    "Modified: / 29.10.1997 / 03:40:49 / cg"
!

setupHelpMenu
    <resource: #programMenu >

    "setup the help- pulldown menu"

    |l s|

    ActiveHelp notNil ifTrue:[
        l := #(
                'What''s New'
                'Index'
                '-'
                'ST/X Online Documentation'
                'Class Documentation'
                '-'
                'Print Documentation...'
                '-'
                'Active Help \c'
              ).
        s := #(
                #startWhatsNewDocumentation
                #startDocumentationIndex
                nil
                #startDocumentationTool
                #startClassDocumentation
                nil
                #showBookPrintDocument
                nil
                #toggleActiveHelp:
              )
    ] ifFalse:[
        l := #(
                'what''s new'
                'index'
                '-'
                'ST/X online documentation'
                'class documentation'
                '-'
                'print documentation ...'
              ).
        s := #(
                #startWhatsNewDocumentation
                #startDocumentationIndex
                nil
                #startDocumentationTool
                #startClassDocumentation
                nil
                #showBookPrintDocument
              )
    ].

    myMenu at:#help 
           putLabels:(resources array:l)
           selectors:s
           receiver:self.

    (ActiveHelp notNil
    and:[ActiveHelp isActive]) ifTrue:[
        (myMenu menuAt:#help) checkToggleAt:#toggleActiveHelp: put:true
    ].

    "Created: / 8.1.1997 / 14:08:09 / cg"
    "Modified: / 29.10.1997 / 03:40:53 / cg"
!

setupMainMenu
    "setup the pulldown menus main items.
     Extracted into a separate method, to allow subclasses to
     add their own entries"

    <resource: #programMenu >

    |icon|

    myMenu labels:(resources array:#(
                                     'About'
                                     'File'
                                     'Classes'
                                     'Tools'
                                     'Projects'
                                     'Settings'
                                     'Demos'
                                     'Help')).
    "
     if there is a bitmap, change 'about' to the ST/X icon
    "
    icon := self class smallAboutIcon.
    icon notNil ifTrue:[
"/        icon := icon on:device.
        myMenu labels at:1 put:icon.
        myMenu height:(myMenu height max:(icon height + (View viewSpacing * 2)))
    ].

    myMenu selectors:#(
                                     #about
                                     #file
                                     #classes 
                                     #tools 
                                     #projects 
                                     #settings
                                     #demos
                                     #help).

    "Created: / 8.1.1997 / 13:58:50 / cg"
    "Modified: / 29.10.1997 / 03:41:00 / cg"
!

setupMenu
    "setup the pulldown menu"

    |mainItems|

    self setupMainMenu.

    mainItems := myMenu selectors.

    (mainItems includes:#about) ifTrue:[
	"/ if not redefined without an about-menu ...
	self setupAboutMenu
    ].
    (mainItems includes:#file) ifTrue:[
	"/ if not redefined without a file-menu ...
	self setupFileMenu
    ].
    (mainItems includes:#classes) ifTrue:[
	"/ if not redefined without a classes-menu ...
	self setupClassesMenu
    ].
    (mainItems includes:#projects) ifTrue:[
	"/ if not redefined without a projects-menu ...
	self setupProjectsMenu
    ].
    (mainItems includes:#settings) ifTrue:[
	"/ if not redefined without a settings-menu ...
	self setupSettingsMenu
    ].
    (mainItems includes:#tools) ifTrue:[
	"/ if not redefined without a tools-menu ...
	self setupToolsMenu
    ].
    (mainItems includes:#demos) ifTrue:[
	"/ if not redefined without a demos-menu ...
	self setupDemoMenu
    ].
    (mainItems includes:#help) ifTrue:[
	"/ if not redefined without a help-menu ...
	self setupHelpMenu
    ].

    self disableDangerousMenuItemsInRemoteLauncher

    "Modified: 8.1.1997 / 14:09:47 / cg"
!

setupProjectsMenu
    "setup the projects- pulldown menu"

    <resource: #programMenu >

    myMenu at:#projects 
           putLabels:(resources array:#(
                                        'New Project'
                                        '-'
                                        'Select Project...'
                                        ))
           selectors:#(
                                        #newProject 
                                        nil
                                        #selectProject 
                      )
           receiver:self.

    "Created: / 8.1.1997 / 14:06:18 / cg"
    "Modified: / 29.10.1997 / 03:41:09 / cg"
!

setupSettingsMenu
    "setup the settings- pulldown menu"

    <resource: #programMenu >

    myMenu at:#settings 
           putLabels:(resources array:#(
                                        'Language...'
                                        'Show keyboard mappings...'
                                        'View style...'
                                        'Fonts...'
                                        'Printer...'
                                        'Messages...'
                                        'Compilation...'
                                        'Source & debugger...'
                                        'Tools...'
                                        'Object memory...'
                                        'Screen...'
"/                                        'Java...'
                                        'Editing...'
                                        'Misc...'
                                        '='
                                        'Save settings...'
                                        'Restore settings...'
                                        ))
           selectors:#(
                                        #languageSetting 
                                        #keyboardSetting 
                                        #viewStyleSetting 
                                        #fontSettings 
                                        #printerSettings 
                                        #messageSettings 
                                        #compilerSettings 
                                        #sourceAndDebuggerSettings 
                                        #toolSettings
                                        #memorySettings 
                                        #displaySettings 
"/                                        #javaSettings
                                        #editSettings
                                        #miscSettings
                                        nil
                                        #saveSettings 
                                        #restoreSettings 
                      )
           receiver:self.

    "Created: / 8.1.1997 / 14:07:00 / cg"
    "Modified: / 6.1.1999 / 14:13:57 / cg"
!

setupToolsMenu
    "setup the tools- pulldown menu"

    <resource: #programMenu>

    |m |

    myMenu at:#tools 
           putLabels:(resources array:#(
                                        'Workspace'
                                        '-'
                                        'GUI builder'
                                        '-'
                                        'New Launcher'
                                        '-'
                                        'Monitors'
                                        '-'
                                        'Views'
                                        '-'
                                        'Hardcopy'
                                        '-'
                                        'misc'
                                        ))
           selectors:#(
                                        #startWorkspace 
                                        nil
                                        #startGUIBuilder
                                        nil
                                        #startNewLauncher
                                        nil
                                        #monitors
                                        nil
                                        #views
                                        nil
                                        #hardcopy 
                                        nil
                                        #misc 
                      )
           receiver:self.


    m := myMenu menuAt:#tools.
    m subMenuAt:#monitors 
      put:(PopUpMenu
                itemList:#(
                           ('Process'      #startApplication:  nil  #ProcessMonitor          )
                           ('Semaphores'   #startApplication:  nil  #SemaphoreMonitor        )
                           ('Memory'       #startApplication:  nil  #MemoryMonitor           )
                           ('Irq Latency'  #startApplication:  nil  #InterruptLatencyMonitor )
                           ('Event View'   #startApplication:  nil  #EventMonitor            )
                           ('Event Trace'  #startApplication:  nil  #StopEventTrace          )
                           ('-'                                                              )
                           ('Memory usage' #startApplication:  nil  #MemoryUsageView         )
                          )
                resources:resources).

    m subMenuAt:#views 
      put:(PopUpMenu
                itemList:#(
                           ('Iconify all'           #iconifyAllWindows        )
                           ('Deiconify all'         #deIconifyAllWindows      )
                           ('-'                                               )
                           ('Find & Raise...'       #findAndRaiseWindow       )
                           ('-'                                               )
                           ('View Tree (all views)' #startFullWindowTreeView  )
                           ('View Tree'             #startWindowTreeView      )
                           ('-'                                               )
                           ('Select & Inspect View' #viewInspect              )
                           ('-'                                               )
                           ('Select & Destroy View' #viewDestroy              )
                           ('Find & Destroy...'     #findAndDestroyWindow     )
                          )
                resources:resources).

    m subMenuAt:#misc 
      put:(PopUpMenu
                itemList:#(
                           ('Garbage Collect'            #garbageCollect            )
                           ('Garbage Collect & Compress' #compressingGarbageCollect )
                          )
                resources:resources).

    m subMenuAt:#hardcopy 
      put:(PopUpMenu
                itemList:#(
                           ('Screen' #fullScreenHardcopy )
                           ('Area'   #screenHardcopy     )
                           ('View'   #viewHardcopy       )
                          )
                resources:resources).

    "Modified: / 31.10.1997 / 16:01:53 / cg"
    "Modified: / 19.12.1997 / 13:15:27 / stefan"
! !

!Launcher methodsFor:'initialize / release'!

buttonPanelSpec
    "return a spec for the buttons in the panel;
     entries consists of selector and bitmap-filename.
     nil selectors are taken as separators (see setupButtonPanel)"

    ^ #(
	#(startSystemBrowser 'SBrowser32x32.xbm')
	#(startFileBrowser   'FBrowser32x32.xbm')
"/        #(startWorkspace      'Workspace32x32.xbm')
	#(nil nil)
	#(startChangesBrowser 'CBrowser32x32.xbm')
"/        #(nil nil)
"/        #(nil nil)
"/        #(startDocumentationTool 'book11.ico')
     )

    "Created: 4.12.1995 / 20:16:18 / cg"
    "Modified: 19.4.1996 / 16:37:46 / cg"
!

closeDownViews
    OpenLaunchers removeIdentical:self ifAbsent:nil.
    super closeDownViews.

    "Created: 5.7.1996 / 13:33:36 / cg"
    "Modified: 1.2.1997 / 12:07:53 / cg"
!

focusSequence
    ^ (Array with:myMenu) 
      , 
      (buttonPanel subViews select:[:element | element isKindOf:Button])
"/      , (Array with:Transcript)
!

openInterface
    "sent by my superclass to open up my interface"

    ^ self openInterfaceAt:nil

    "Modified: / 5.2.1998 / 19:57:39 / cg"
!

openInterfaceAt:aPoint
    "sent by my superclass to open up my interface"

    |top icn w sz|

    "/ if there is already a transcript on my device,
    "/ I am a slave launcher with limited functionality.

    Transcript notNil ifTrue:[
	Transcript ~~ Stderr ifTrue:[
	    isMainLauncher := (Transcript graphicsDevice == device).
	] ifFalse:[
	    isMainLauncher := true
	]
    ] ifFalse:[
	isMainLauncher := true
    ].

    top := StandardSystemView onDevice:device.
    top label:'Smalltalk/X'; iconLabel:'ST/X Launcher'.
    top extent:(400@300 ).
    aPoint notNil ifTrue:[
	top origin:aPoint
    ].

    icn := self class aboutIcon.
    icn notNil ifTrue:[
	icn := icn magnifiedTo:(sz := device preferredIconSize).
    ].

    icn notNil ifTrue:[
	(device supportsDeepIcons not
	and:[device supportsIconViews
	and:[device depth > 1]]) ifTrue:[    
	    w := View extent:sz. 
	    w viewBackground:icn.
	    top iconView:w
	] ifFalse:[
	    top icon:icn.
	]
    ].

"/    device supportsDeepIcons ifTrue:[
"/        icn := self class aboutIcon.
"/        icn notNil ifTrue:[
"/            icn := icn magnifiedTo:(sz := device preferredIconSize).
"/            icn := Depth8Image fromImage:icn.
"/            top icon:icn
"/        ].

"/    ] ifFalse:[
"/        device supportsIconViews ifTrue:[
"/            icn := self class aboutIcon.
"/            icn notNil ifTrue:[
"/                icn := icn magnifiedTo:(sz := device preferredIconSize).
"/                w := View extent:sz. 
"/                w viewBackground:icn.
"/                top iconView:w
"/            ].
"/        ]
"/    ].

    self createBuilder.
    self setupViewsIn:top.
    top application:self.   

    "
     open with higher prio to allow interaction even while things
     are running ...
    "
    top openWithPriority:(Processor userSchedulingPriority + 1).

    OpenLaunchers isNil ifTrue:[
	OpenLaunchers := OrderedCollection new.
    ].
    OpenLaunchers add:self.

    ^ builder

    "Created: / 5.2.1998 / 19:43:44 / cg"
    "Modified: / 19.6.1998 / 03:35:41 / cg"
!

release
    OpenLaunchers removeIdentical:self ifAbsent:nil.
    super release

    "Modified: 28.7.1997 / 18:40:55 / cg"
!

restarted
    "image restart - since WindowGroup recreates the process with
     the default priority, we have to raise the prio again.
     Mhmh - this looks like a bug to me ...
     Also, the cursor (which was stored as a write or waitCursor) must
     be reset to normal."

    Processor activeProcess priority:(Processor userSchedulingPriority + 1).

    super restarted

    "Modified: 1.6.1996 / 16:58:25 / cg"
!

setupButtonPanelIn:aTopView
    "create the buttonPanel"

    |spc mh buttonSize|

    spc := View viewSpacing // 2.
    buttonPanel := HorizontalPanelView in:aTopView.
    buttonPanel level:-1; borderWidth:0.
    buttonPanel horizontalLayout:#leftSpace.
"/    buttonPanel verticalLayout:#centerSpace.

    buttonSize := self class buttonImageSize.

    "/
    "/ the buttonSpec is a collection of:
    "/   #( selector  iconFileName )
    "/ or:
    "/   #( selector  (className iconQuerySelector) )
    "/ or"
    "/   #( nil )
    "/
    self buttonPanelSpec do:[:entry |
        |sel b sep img iconSpec v|

        sel := entry at:1.
        sel isNil ifTrue:[
            sep := View in:buttonPanel.
            sep extent:32@1; borderWidth:0.
        ] ifFalse:[
            iconSpec := entry at:2.
            iconSpec isArray ifTrue:[
                img := (Smalltalk classNamed:(iconSpec at:1)) perform:(iconSpec at:2).
            ] ifFalse:[
                img := Smalltalk imageFromFileNamed:iconSpec forClass:self class.
                img isNil ifTrue:[
                    img := Smalltalk imageFromFileNamed:iconSpec forClass:Launcher.
                ]
            ].
            (img notNil and:[buttonSize notNil]) ifTrue:[
                img extent ~= buttonSize ifTrue:[
                    img := img magnifiedTo:buttonSize       
                ]
            ].

            b := Button new.
            b form:img.
            b model:self; changeMessage:sel.

            b styleSheet name = 'win95' ifTrue:[

                false ifTrue:[
                    "/ make buttons flat, popping up when entered ...

                    b enterLevel: 1.
                    b leaveLevel: 0.
                    buttonPanel addSubView:b.

                ] ifFalse:[
                    "/ make buttons flat, but given them a 3D frame ...

                    v := View in:buttonPanel.
                    v addSubView:b.
                    v level:-1.
                    b passiveLevel:1; activeLevel:-1.
                    v extent:(b preferredExtent 
                              + b borderWidth + b borderWidth 
                              + b margin + b margin 
                              + v margin + v margin).
                    v preferredExtent:v extent.
                    b origin:(v margin asPoint).
                ].
                b enteredBackgroundColor:(Color grey:80).
            ] ifFalse:[
                buttonPanel addSubView:b.
            ].
        ]
    ].

    mh := myMenu height.
    buttonPanel origin:0.0 @ (mh + spc)
                corner:(1.0 @ (mh + spc + buttonPanel preferredExtent y)).

    buttonPanel leftInset:spc; rightInset:spc.

    "Modified: 26.4.1997 / 21:02:39 / cg"
!

setupInfoViewIn:topView 
    "create the infoView"

    |spc halfSpc|

    spc := View viewSpacing.
    infoView := Label label:'' in:topView.
    infoView adjust:#left; borderWidth:0.
    infoView level:-1.
    transcript superView bottomInset:(infoView height + spc).

    infoView is3D ifTrue:[
	halfSpc := spc // 2.
    ] ifFalse:[
	halfSpc := 0
    ].
    infoView topInset:(infoView height negated - spc + transcript borderWidth);
	     bottomInset:halfSpc;
	     leftInset:halfSpc; 
	     rightInset:halfSpc.
    infoView origin:0.0 @ 1.0 corner:1.0 @ 1.0.
    projectInfoHolder := '' asValue.
    infoView labelChannel:projectInfoHolder.
    self updateInfo.

    Project notNil ifTrue:[
	Project addDependent:self.
    ]

    "
     Launcher open
    "

    "Modified: 9.9.1996 / 22:44:15 / stefan"
    "Modified: 28.7.1997 / 18:42:30 / cg"
!

setupOtherViewsIn:aTopView
    "a hook - allows redefinition in your personal subclass.
     For example, add a clock:"

"
    |sz clock space halfSpace|

    sz := buttonPanel innerHeight - (buttonPanel level abs*2).
    space := View viewSpacing.
    halfSpace := space // 2.

    buttonPanel rightInset:sz+(space  * 2).

    clock := ClockView in:buttonPanel topView.
    clock borderWidth:1.
    clock showSeconds:false.
    clock extent:(sz @ sz).
    clock origin:(1.0 @ (buttonPanel origin y + halfSpace)).
    clock leftInset:sz negated - 2 - halfSpace.
    clock rightInset:halfSpace.
    clock level:1.
"
!

setupTranscriptIn:aView 
    "create the transcript view"

    |v launcher|

    "/ check if this is an additional launcher on a remote display.
    "/ if so, do not close the real launcher.

    (Transcript notNil and:[Transcript ~~ Stderr]) ifTrue:[
        isMainLauncher ifTrue:[
            launcher := Transcript topView application
        ] ifFalse:[
            launcher := self class current.
            (launcher isNil and: [NewLauncher notNil]) ifTrue: [launcher := NewLauncher current].
        ].

        launcher notNil ifTrue:[
            launcher window graphicsDevice == device ifTrue:[
                OpenLaunchers notNil ifTrue:[
                    OpenLaunchers removeIdentical:launcher ifAbsent:nil.
                ].
                launcher class = NewLauncher
                    ifTrue:  [launcher close]
                    ifFalse: [launcher window destroy]
            ]
        ]
    ].

    v := HVScrollableView 
                for:TextCollector
                miniScrollerH:true 
                miniScrollerV:false 
                in:aView.

    v origin:(0.0 @ (buttonPanel corner y + View viewSpacing)) 
      corner:(1.0 @ 1.0).
    transcript := v scrolledView.

    isMainLauncher ifTrue:[
        transcript beTranscript.
        transcript showCR:'**************** Notice ***********************'.
        transcript showCR:'**  This Launcher is obsolete and no longer  **'.
        transcript showCR:'**  maintained. Please use the new launcher: **'.
        transcript showCR:'**             NewLauncher open              **'.
        transcript showCR:'**                                           **'.
        transcript showCR:'***********************************************'.
    ] ifFalse:[
        transcript showCR:'**************** Notice ***********************'.
        transcript showCR:'**       this is NOT the Transcript          **'.
        transcript showCR:'** The real Transcript is on the main screen **'.
        transcript showCR:'**                                           **'.
        transcript showCR:'** Menus affecting common state are disabled **'.
        transcript showCR:'***********************************************'.
    ]

    "Modified: / 18.8.1998 / 15:03:54 / cg"
!

setupViewsIn:topView 
    "create the pulldown menu, buttonPanel and transcript view"

    |tFont|

    topView model:self.

    myMenu := PullDownMenu in:topView.
    myMenu origin:0.0 @ 0.0 corner:(1.0 @ myMenu height).

    self setupMenu.
    self setupButtonPanelIn:topView.
    self setupTranscriptIn:topView.
    self setupInfoViewIn:topView.
    self setupOtherViewsIn:topView.

    tFont := transcript font.
    topView extent:(((tFont widthOf:'3')*60) max:myMenu preferredExtent x)
		    @ 
		    ((tFont height) * 20).

    "
     Launcher open
    "

    "Modified: 9.9.1996 / 22:44:31 / stefan"
! !

!Launcher class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Launcher.st,v 1.407 2015-01-31 13:28:01 cg Exp $'
! !

