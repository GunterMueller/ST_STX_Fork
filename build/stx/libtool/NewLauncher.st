"
 COPYRIGHT (c) 1997-1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

AbstractLauncherApplication subclass:#NewLauncher
	instanceVariableNames:'isMainLauncher helpIsOn errorListCanvas infoLineTemplate'
	classVariableNames:'UserAddedMenuItems UserAddedToolBarItems
		PreviousPackageDialogItems PreviousPackageDialogExtent'
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

Object subclass:#AddedToolInfo
	instanceVariableNames:'item resourceProvider where positionSpec space before
		menuWithNewItem originalLabel'
	classVariableNames:''
	poolDictionaries:''
	privateIn:NewLauncher
!

!NewLauncher class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997-1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    The new launcher.
    This one provides all of the Launchers functionality,
    but has been written using the new GUI painter tools.
    (i.e. its menu and toolbar is defined by specs, which can be
     easily modified).
    Functionality which can be shared with the old launcher
    has been moved to a common superclass.

    If you want to write your own (application-)launcher, we recommend
    creating a subclass, and redefining the appropriate menu & menuToolBar
    methods there.

    [start with:]
	NewLauncher open

    [see also:]
	Launcher

    [author:]
	Thomas Zwick, eXept Software AG
	Claus Gittinger, eXept Software AG
"

!

examples
"
    reopening a standard launcher (without any added tools)
									[exBegin]
     NewLauncher removeAllUserAddedTools.
     NewLauncher open.
									[exEnd]



    adding your own menu items (for user-applications)

    an additional item in the tools menu:
									[exBegin]
     Transcript topView application
	addMenuItem:(MenuItem new
			label: 'Foo';
			value: [Transcript showCR:'foo invoked'];
			isButton: false;
			labelImage: nil;
			nameKey: #foo;
			activeHelpKey: #Foo)
	in:#menu
	position:#(before workspace)
	space:true
									[exEnd]

    an additional item in the tools menu:
									[exBegin]
     Transcript topView application
	addMenuItem:(MenuItem new
			label: 'Foo';
			value: [Transcript showCR:'foo invoked'];
			isButton: false;
			labelImage: nil;
			activeHelpKey: #Foo)
	in:#menu
	position:#(after guiPainter)
	space:true
									[exEnd]

    an additional item in one of the tools sub menus:
									[exBegin]
     Transcript topView application
	addMenuItem:(MenuItem new
			label: 'Foo';
			value: [Transcript showCR:'foo invoked'];
			isButton: false;
			labelImage: nil;
			activeHelpKey: #Foo)
	in:#menu
	position:#(after Workspace)
	space:true
									[exEnd]
"
! !

!NewLauncher class methodsFor:'accessing'!

label

    ^'ST/X Launcher'


! !

!NewLauncher class methodsFor:'defaults'!

defaultInfoLineTemplate
    "available values:
	PACKAGE         - the current packageID
	PACKAGEOREMPTY  - the current packageID or empty if its __NoPackage__
	IMAGE           - the current snapshot image
	CVS             - the CVS source repository or empty
	DB              - the Store source repository DB or empty
	SVN_WORKING_COPY- the SVN working copy dir or empty
	NOREPOSITORY    - the tring 'No Repository' empty
	NS              - the default namespace, or empty (if Smalltalk)
	PROJECTDIR      - the default fileOut directory or empty (if current)
    "

    (SVN::RepositoryManager notNil
    and:[ SVN::RepositoryManager isLoaded
    and:[ SVN::RepositoryManager enabled ]]) ifTrue:[
	^ '%(PACKAGEOREMPTY)%(IMAGE) %(CVS)%(DB)%(SVN_WORKING_COPY)'
    ].
    ^ '%(PACKAGEOREMPTY)%(IMAGE)%(CVS)%(DB)%(NOREPOSITORY)%(NS)'

    "/ ^ '%(PACKAGEOREMPTY)%(IMAGE)%(CVS)%(DB)%(NOREPOSITORY)%(NS)'
    "/ ^ '%(PACKAGE)%(IMAGE)%(CVS)%(DB)%(NOREPOSITORY)%(NS)%(PROJECTDIR)'

    "Modified: / 30-09-2008 / 12:45:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

windowIcon
    ^ Icon stxIcon

    "Created: / 16.8.1998 / 13:11:58 / cg"
    "Modified: / 17.8.1998 / 10:07:09 / cg"
! !

!NewLauncher class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^super flyByHelpSpec addPairsFrom:#(

#fileFileBrowser
'FileBrowser'

#fileBrowserV2
'New FileBrowser / Recently visited folders'

#fileSaveImage
'Save Image'

#fileSaveImageAs
'Save Image'

#helpSTXOnlineDocumentation
'Online Manual'

#classesSystemBrowserOnClass
'Browser history'

#classesSystemBrowser
'SystemBrowser'

#newSystemBrowser
'New SystemBrowser / Recently visited classes'

#systemGarbageCollect
'GarbageCollect - force free space reclamation to be done now.\(Normally not needed, the system does this automatically for you)'

#systemGarbageCollectAndCompress
'GarbageCollect - force free space reclamation now and compress memory.\(Normally not needed, the system does this automatically for you)'

#toolsGUIPainter
'GUIPainter - a tool for interactive UI construction.\Normally opened via the browser by double clicking on an interface spec method'

#toolsImageEditor
'BitmapEditor - a tool to create/modify icons and bitmaps used in the UI.\Normally opened via the browser by double clicking on an image spec method'

#toolsMenuEditor
'MenuEditor - a tool for interactive UI-menu construction.\Normally opened via the browser by double clicking on a menu spec method'

#toolsChangesBrowser
'Changes Browser'

toolsChangesBrowserOrNavigateToRecentChange
'Changes Browser / Uncommitted recent changes'

#toolsMiscProjectsNewProject
'New Project'

#toolsNewChangesBrowser
'ChangesBrowser (new GUI)'

#toolsOldChangesBrowser
'ChangesBrowser (old GUI)'

#toolsWorkspace
'Workspace - a scratchpad for text and expression evaluator'

#toolsMyWorkspace
'Workspace on the "MyWorkspace.wsp" file'

#toolsSystemWorkspace
'The SystemWorkspace with Welcome Messages'

#toolsEvaluationWorkspace
'A 3-pane EvaluationWorkspace - good for lectures and Smalltalk courses'

#toolsInternationalLanguageTranslationEditor
'National Language Translation Editor'
)

    "Modified: / 28-08-2013 / 14:56:20 / cg"
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:NewLauncher    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#aboutLicenseConditions
'Show the license conditions of ST/X'

#breakPointBrowser
''

#chickenFun
'Watch your views'

#classBrowserOnChangedClasses
'Open a Browser on changed classes'

#classBrowserOnChangedMethod
'Open a Browser on a that changed method'

#classBrowserOnChangedMethods
'Open a Browser on changed methods'

#classes
'Class functions'

#classesClassBrowser
'Open a dialog for defining and opening a Class Browser on a class'

#classesClassBrowserOnChanges
'Open a Browser on changed classes'

#classesClassHierarchyBrowser
'Open a dialog for defining and opening a Class Hierarchy Browser on a class'

#classesClassTreeBrowser
'Open a Class Tree View'

#classesFullClassBrowser
'Open a dialog for defining and opening a Full Class Browser on a class'

#classesImplementors
'Find all methods which implement a particular message'

#classesRemoveAllTracePoints
'Remove all trace- and break-points'

#classesResourceMethods
'Open a dialog for searching resource methods'

#classesSenders
'Find all methods which send a particular message'

#classesShowTracePoints
'Browse mthods with a Trace- or Break-point'

#classesSpecial
'Special class functions'

#classesSpecialReferencesToUnboundGlobals
'rbowse methods refering to unbound globals'

#classesSpecialReferencesToUndeclared
'Browse methods refering to undeclared variables'

#classesStopIgnoringHalts
'Stop ignoring Halts in the debugger'

#classesStringSearch
''

#classesSystemBrowser
'Open a System Browser'

#classesSystemBrowserOnClass
'Open a System Browser on a previously visited class'

#demos
'Demo programs'

#demos3D
'3D GL graphic demos'

#demos3DcubeSolid
'A rotating solid cube'

#demos3DcubeWire
'A rotating wireframe cube'

#demos3Ddoughnut
'A rotating wireframe doughnut'

#demos3Dlogo
'The ST/X logo'

#demos3Dplane
'A rotating plane'

#demos3Dplanet
'Two spheres - one rotating around the other'

#demos3Drubics
'A rubics cube - with interaction'

#demos3Dsphere
'A rotating wireframe sphere'

#demos3Dteapot
'A teopot'

#demos3Dtetra
'A rotating tetrahedron'

#demosAnimations
'Simple animation demos'

#demosBabelFish
'A Language Translator'

#demosCalculator
'Opens a calculator with decimal to hex conversion'

#demosCalendar
'Opens a GUI on the cal program (unix only)'

#demosClock
'Opens an analog clock application'

#demosCommander
'Opens a demo for the Commander class'

#demosDigitalClock
'Opens a digital clock application'

#demosDrawingProtocol
'Drawing protocol demo (for programmers)'

#demosFTP
'Opens a simple FTP interface demo'

#demosFractalPatterns
'Opens a view displaying fractal patterns'

#demosFractalPlants
'Opens a view displaying fractal plants (iterated function systems)'

#demosGUI
'GUI builder demos'

#demosGUICalculator
'Calculator built using the GUI builder'

#demosGUIWidgets
'GUI widgets usage'

#demosGames
'Games'

#demosGeometric
'Various demos displaying geometric designs'

#demosGlobe
'Opens a rotating globe animation demo'

#demosGoodies
'Goodies and Utilities'

#demosGraphicEditors
'Graphic editing demos'

#demosGraphicEditorsDrawTool
'Object drawing demo'

#demosGraphicEditorsLogicTool
'Simulating Logic demo'

#demosGraphicEditorsPaintTool
'Painting demo'

#demosLSystems
'Opens a view displaying fractal patterns using Lindenmayer Systems'

#demosMail
'Opens a simple mail viewer demo'

#demosMandel
'Opens a view displaying the mandelbrot set'

#demosMoreFractalPatterns
'Opens a view with more fractal patterns'

#demosNews
'Opens a simple news reader demo'

#demosOldStuff
'Very old demos'

#demosPen
'Opens a demo for the Pen class'

#demosRemoteLauncher
'Opens a launcher on a remote display'

#demosTelnet
'Opens a Telnet terminal demo'

#demosWalkingMan
'Opens a walking man animation demo'

#enableGlobalCoverageAnalysis
'Enable coverage statistic gathering in all processes (global covarage analysis)'

#fileApplicationBuilder
'Open an Application Builder for building stand alone ST/X-applications'

#fileBrowserV2
'Open a FileBrowser to edit or load files and folders'

#fileFileBrowser
'Open a FileBrowser to edit or load files and folders'

#fileLibraryBuilder
'Open a Library Builder for building binary class libraries'

#fileModules
'Show class libraries and other modules'

#fileSaveImage
'Save the complete state of ST/X into the current snapshot file ("%1")'

#fileSaveImageAs
'Save the complete state of ST/X into a snapshot file'

#fileSaveSessionChangesAs
'Save changes made in this session as a patch file, which is automatically loaded when ST/X is started.'

#findClassAndBrowse
'Find and browse a class by name'

#flyByWindowInformation
'Show flyby info about the window under the pointer. Easy access to View, Application and Model'

#gamesPingPong
'Play classic PingPong against the computer'

#gamesPingPong2
'Play classic PingPong against a friend'

#gamesReversi
'The game of reversi (an embedded Java applet)'

#gamesTetris
'The tetris game - written in Smalltalk'

#gamesTicTacToe
'Play TicTacToe against the computer'

#gamesTicTacToe2
'Play TicTacToe against a friend'

#helpActiveHelp
'Toggle display of active help texts in browsers'

#helpClassDocumentation
'Show the smalltalk class documentation'

#helpCredits
'Say thanks to some friends'

#helpIndex
'Show the index of the online documentation'

#helpPrintDocumentation
'Print various parts of the ST/X documentation'

#helpProgrammersGuide
'Show the programmer''s guide'

#helpRFC
'Show an RFC by number'

#helpSTXOnlineDocumentation
'Show the ST/X online documentation'

#helpShowTipOfTheDay
'Show a tip-of-the-day'

#helpSmalltalkTutorial
'Show the Smalltalk Language Tutorial'

#helpToolsDocumentation
'Show the tool documentation'

#helpTutorial
'Show the ST/X Tutorial'

#helpWhatsNew
'Show the latest news about the ST/X documentation'

#helpWhatsNewInSTX
'Show the latest news about ST/X'

#newSystemBrowser
'Open a System Browser or revisit a class'

#openTestRunner
'Open the SUnit test runner for executing unit tests'

#settingsCommunications
'Change communication settings'

#settingsCompilation
'Change compiler settings'

#settingsFonts
'Change of the font defaults'

#settingsKeyboardMappings
'Show the keyboard mappings'

#settingsLanguage
'Change the national language'

#settingsLoadSettings
'Restore the settings from a file'

#settingsMessages
'Change the settings for info- / error-messagess'

#settingsMisc
'Misc other settings'

#settingsMouse
'Configure the mouse'

#settingsObjectMemory
'Change the object memory settings'

#settingsPrinter
'Change the printer setup'

#settingsSaveSettings
'Save the current settings to a file'

#settingsScreen
'Change the display screen settings'

#settingsSourceAndDebugger
'Change the settings of the source code management'

#settingsTools
'Change tool settings'

#settingsViewStyle
'Change the current view style'

#startChangeSetBrowser
'Open a Browser on recent changes (the ChangeSet)'

#startSQLScratchpad
'SQLScratchpad - a scratchpad for SQL statement execution (ODBC or SQLite)'

#startSQLWorkspace
'SQLWorkspace - a workspace for SQL statement execution'

#system
'System tools'

#systemEventTrace
'Select a view to toggle the event trace for it'

#systemEventView
'Open a view and trace its window events on the console'

#systemGarbageCollect
'Reclaim unused memory'

#systemGarbageCollectAndCompress
'Reclaim unused memory and minimize the amount of used memory'

#systemInterruptLatency
'Open an Interrupt Latency Monitor displaying methods which block interrupts for longer than a given time goal'

#systemMemory
'Display object memory statistics'

#systemMemoryUsage
'Display object memory usage by class'

#systemProcesses
'Open a Process Monitor displaying ST/X processes'

#systemReloadResources
'Reload Language Resources (National language strings)'

#systemSemaphores
'Open a Semaphore Monitor displaying ST/X semaphores'

#systemSettings
'Open a Settings Dialog'

#tools
'Tools'

#toolsChangesBrowser
'Open a Changes Browser'

#toolsChangesBrowserOrNavigateToRecentChange
'Open a Changes Browser or navigate to a recent change'

#toolsEvaluationWorkspace
'A 3-pane EvaluationWorkspace - good for lectures and Smalltalk courses'

#toolsGUIPainter
'Open a GUI Painter for graphical user interface construction'

#toolsImageEditor
'Open a Bitmap Image Editor for editing small images for toolbars and buttons'

#toolsInternationalLanguageTranslationEditor
'Open the National Language Translation Editor'

#toolsMenuEditor
'Open a Menu Editor for building menus and toolbars'

#toolsMisc
'Misc Tools'

#toolsMiscNewChangesBrowser
'Open a ChangesBrowser (new GUI)'

#toolsMiscNewLauncher
'(Re-)open a Launcher (new GUI)'

#toolsMiscOldChangesBrowser
'Open a ChangesBrowser (old GUI)'

#toolsMiscOldLauncher
'Open an OldLauncher'

#toolsMiscProjects
'Project functions'

#toolsMiscProjectsNewProject
'Create a new project'

#toolsMiscProjectsSelectProject
'Select an existing project and reopen its windows'

#toolsMyWorkspace
'Workspace on the "MyWorkspace.wsp" file'

#toolsNewChangesBrowser
'Open the new changes browser'

#toolsOOM
'Open the Object Oriented Metrics (OOM) tool'

#toolsOldChangesBrowser
'Open the old changes browser'

#toolsProjects
'Open the project tool'

#toolsSUnit
'Open the SUnit test runner for executing unit tests'

#toolsSmaCC
'Open the SmaCC parser generator Tool'

#toolsSystemWorkspace
'The SystemWorkspace with welcome messages'

#toolsTerminal
'Open a terminal view (aka xterm)'

#toolsWorkspace
'Open a Workspace for evaluating Smalltalk expressions.\The first click opens the customizable MyWorkspace'

#windows
'Window functions'

#windowsDeiconifyAll
'Restore all minimized ST/X windows'

#windowsFindAndDestroy
'Select an ST/X window by name and destroy it'

#windowsFindAndMigrate
'Select an ST/X window by name and move it to another display'

#windowsFindAndMigrateBack
'Select an ST/X window by name and move it (back) to this screen'

#windowsFindAndRaise
'Select an ST/X window by name and raise it'

#windowsGrapScreen
'Grab the whole screen and save it to a bitmap-file'

#windowsGrapScreenArea
'Grab an area of the screen and save it to a bitmap-file'

#windowsGrapWidget
'Grab a single widget and save it to a bitmap-file'

#windowsGrapWindow
'Grab a window and save it to a bitmap-file'

#windowsIconifyAll
'Minimize all ST/X windows to icons'

#windowsMigrateAllWindows
'Migrate all ST/X windows to some other display'

#windowsRedrawAll
'Redraw all ST/X windows'

#windowsSelectAndDestroy
'Select a window and destroy it'

#windowsSelectAndInspect
'Select an ST/X window and open an Inspector on it'

#windowsSelectAndMigrate
'Select an ST/X window and move it to another display'

#windowsViewTree
'Select an ST/X window and display its widget hierarchy'

#windowsViewTreeAllScreens
'Display the widget hierarchies of all ST/X windows (on all displays)'

#windowsViewTreeAllViews
'Display the widget hierarchies of all ST/X windows (on this display)'

)
! !

!NewLauncher class methodsFor:'interface specs'!

windowSpec
    ^ self windowSpec_old.
    "/ ^ self windowSpec_new.
!

windowSpec_new
    "This resource specification was automatically generated
     by the UIPainter of ST/X."


    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NewLauncher andSelector:#windowSpec_new
     NewLauncher new openInterface:#windowSpec_new
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: #'windowSpec_new'
        window:
       (WindowSpec
          label: 'ST/X Launcher'
          name: 'ST/X Launcher'
          min: (Point 374 44)
          bounds: (Rectangle 0 0 374 202)
          menu: menu
          icon: windowIcon
        )
        component:
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'menuToolbarView'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 40 0)
              menu: menuToolbar
            )
           (NoteBookViewSpec
              name: 'NoteBook1'
              layout: (LayoutFrame 0 0.0 40 0.0 0 1.0 -26 1.0)
              level: 0
              model: selectedTabHolder
              menu: tabList
              direction: bottom
              useIndex: true
              translateLabel: true
              canvas: noteBookCanvasHolder
              keepCanvasAlive: true
            )
           (UISubSpecification
              name: 'infoBarSubSpec'
              layout: (LayoutFrame 0 0.0 -26 1 -16 1.0 0 1.0)
              majorKey: ToolApplicationModel
              minorKey: windowSpecForInfoBarWithClock
              keepSpaceForOSXResizeHandleH: true
            )
           )

        )
      )

    "Modified (format): / 24-02-2014 / 15:01:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpec_old
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NewLauncher andSelector:#windowSpec_old
     NewLauncher new openInterface:#windowSpec_old
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: #'windowSpec_old'
       window: 
      (WindowSpec
         label: 'ST/X Launcher'
         name: 'ST/X Launcher'
         min: (Point 300 300)
         bounds: (Rectangle 0 0 540 300)
         menu: menu
         icon: windowIcon
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'menuToolbarView'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 40 0)
             menu: menuToolbar
           )
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame 0 0.0 40 0.0 0 1.0 -26 1.0)
             component: 
            (SpecCollection
               collection: (
                (WorkspaceSpec
                   name: 'transcriptView'
                   layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                   level: #'launcher.editorLevel'
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   miniScrollerHorizontal: true
                   hasKeyboardFocusInitially: false
                 )
                )
              
             )
           )
          (UISubSpecification
             name: 'infoBarSubSpec'
             layout: (LayoutFrame 0 0.0 -26 1 -16 1.0 0 1.0)
             level: #'infobar.level'
             majorKey: ToolApplicationModel
             minorKey: windowSpecForInfoBarWithClock
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
!

windowSpec_pda
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NewLauncher andSelector:#windowSpec_pda
     NewLauncher new openInterface:#windowSpec_pda
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: #'windowSpec_pda'
	window:
       (WindowSpec
	  label: 'Launcher'
	  name: 'Launcher'
	  min: (Point 100 20)
	  max: (Point 240 300)
	  bounds: (Rectangle 13 23 197 224)
	  menu: #'menu_pda'
	  icon: windowIcon
	)
	component:
       (SpecCollection
	  collection: (
	   (MenuPanelSpec
	      name: 'menuToolbarView'
	      layout: (LayoutFrame 0 0.0 0 0 0 1.0 38 0)
	      menu: #'menuToolbar_pda'
	    )
	   (WorkspaceSpec
	      name: 'transcriptView'
	      layout: (LayoutFrame 0 0.0 40 0.0 0 1.0 -26 1.0)
	      hasHorizontalScrollBar: true
	      hasVerticalScrollBar: true
	      miniScrollerHorizontal: true
	      miniScrollerVertical: false
	    )
	   (UISubSpecification
	      name: 'infoBarSubSpec'
	      layout: (LayoutFrame 0 0.0 -24 1 0 1.0 0 1.0)
	      majorKey: ToolApplicationModel
	      minorKey: windowSpecForInfoBarWithClock
	    )
	   )

	)
      )
! !

!NewLauncher class methodsFor:'menu configuration'!

addMenuItem:newItem from:anApplicationWhichProvidesResourcesOrNil in:where position:positionSpecOrNilArg space:space
    |positionSpecOrNil itemNameOrNil before launcherApp|

    (Transcript isView
     and:[(launcherApp := Transcript application) isKindOf:self]) ifTrue:[
        "/ add to instance
        launcherApp addMenuItem:newItem from:anApplicationWhichProvidesResourcesOrNil in:where position:positionSpecOrNilArg space:space.
        ^ self
    ].

    positionSpecOrNil := positionSpecOrNilArg.
    positionSpecOrNil isArray ifTrue:[
        positionSpecOrNil size > 1 ifTrue:[
            itemNameOrNil := positionSpecOrNil at:2.
        ].
        positionSpecOrNil := positionSpecOrNil at:1.
    ].
    before := (positionSpecOrNil == #first) or:[positionSpecOrNil == #before].

    (where isNil or: [where = #toolbar]) ifTrue:[
        UserAddedToolBarItems isNil ifTrue: [UserAddedToolBarItems := Dictionary new].
        (UserAddedToolBarItems contains:[:info | info item nameKey = newItem nameKey])
        ifTrue:[
            'NewLauncher class: menu item already present:' infoPrint. newItem nameKey infoPrintCR.
        ]
        ifFalse:[
            UserAddedToolBarItems
                at:newItem put:(AddedToolInfo new
                                            item:newItem;
                                            resourceProvider:anApplicationWhichProvidesResourcesOrNil;
                                            where:where;
                                            positionSpec:positionSpecOrNilArg;
                                            space:space;
                                            before:before;
                                            menuWithNewItem:nil;
                                            yourself)
        ]
    ].
    (where isNil or:[where startsWith:#menu]) ifTrue:[
        UserAddedMenuItems isNil ifTrue: [UserAddedMenuItems := Dictionary new].
        (UserAddedMenuItems contains:[:info | info item nameKey = newItem nameKey])
        ifTrue:[
            Transcript show:'NewLauncher class: menu item already present:'; showCR:newItem nameKey.
        ]
        ifFalse:[
            UserAddedMenuItems
                at:newItem put:(AddedToolInfo new
                                            item:newItem;
                                            resourceProvider:anApplicationWhichProvidesResourcesOrNil;
                                            where:where;
                                            positionSpec:positionSpecOrNilArg;
                                            space:space;
                                            before:before;
                                            menuWithNewItem:nil;
                                            yourself)
        ]
    ]

    "Modified: / 09-08-2011 / 22:39:44 / cg"
!

addMenuItem:newItem in:where position:positionSpecOrNilArg space:space
    ^ self
	addMenuItem:newItem
	from:nil
	in:where
	position:positionSpecOrNilArg
	space:space
!

addToolMenuEntryNamed:aString action:aBlock
    |menuItem|

    menuItem := MenuItem new
                    value: aBlock;
                    isButton: false;
                    translateLabel: true;
                    label:aString icon:nil;
                    nameKey: aString;
                    activeHelpKey: aString;
                    submenuChannel: nil;
                    showBusyCursorWhilePerforming:true.

    self
        addMenuItem:menuItem
        from:self
        in:'menu.tools'
        position:#(before workspace)
        space:true.

    "
     NewLauncher addToolMenuEntryNamed:'My Workspace' action:[Workspace open]
     NewLauncher addToolMenuEntryNamed:'Bla' action:[self halt]
    "
!

removeAllUserAddedTools
    UserAddedToolBarItems := nil.
    UserAddedMenuItems := nil.

    "
     self removeAllUserAddedTools
    "
!

removeUserTool:toolNameOrMenuItem
    "removes a menu item labeled toolName
     This can be invoked by a classes #deinitialize method,
     to remove its item from the toolbar or menu.
    "

    self removeUserTool:toolNameOrMenuItem from:UserAddedToolBarItems.
    self removeUserTool:toolNameOrMenuItem from:UserAddedMenuItems.

    "
     Transcript topView application
	removeUserTool:'Bar'
    "
    "
     Transcript topView application
	removeUserTool:'Foo'
    "


!

removeUserTool:toolNameOrMenuItem from:addedToolsCollection
    "removes a menu item labeled toolName
     This can be invoked by a classes #deinitialize method,
     to remove its item from the toolbar or menu.
    "

    |info space menuIndex whichMenu before menuItemToRemove|

    addedToolsCollection size == 0 ifTrue: [^nil].

    [true] whileTrue:[
	(toolNameOrMenuItem isString or:[toolNameOrMenuItem isSymbol]) ifTrue:[
	    info := addedToolsCollection detect:[:eachInfo | |eachItem|
					    eachItem := eachInfo item.
					    (eachItem nameKey notNil and:[ toolNameOrMenuItem = eachItem nameKey])
					    or:[ (eachItem activeHelpKey notNil and:[ toolNameOrMenuItem = eachItem activeHelpKey])
					    or:[ (eachItem label notNil and:[ toolNameOrMenuItem = eachItem label])]]
					  ]
				   ifNone:nil.
	] ifFalse:[
	    info := addedToolsCollection detect:[:eachInfo | |eachItem| eachItem := eachInfo item. (eachItem == toolNameOrMenuItem)] ifNone:nil.
	].
	info isNil ifTrue:[^ self].

	space     := info space.
	whichMenu := info menuWithNewItem.
	menuItemToRemove := info item.
	before := info before.

	whichMenu notNil ifTrue:[
	    menuIndex := whichMenu findFirst:[:item |
						    (item nameKey notNil and:[item nameKey == menuItemToRemove nameKey])
						    or:[ (item activeHelpKey notNil and:[item activeHelpKey == menuItemToRemove activeHelpKey])
						    or:[ (item label notNil and:[item label = menuItemToRemove label]) ]]
					     ].
	    menuIndex ~~ 0 ifTrue:[
		whichMenu remove: menuIndex.
		space ifTrue: [
		    whichMenu remove:(menuIndex - (before ifTrue:0 ifFalse:1))
		].
	    ].
	].
	addedToolsCollection removeKey:menuItemToRemove.
	^ self
    ].


    "
     Transcript topView application
	removeUserTool:'Bar'
    "
    "
     Transcript topView application
	removeUserTool:'Foo'
    "
! !

!NewLauncher class methodsFor:'menu specs'!

aboutMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NewLauncher andSelector:#aboutMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher aboutMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'About Smalltalk/X...'
	    #translateLabel: true
	    #value: #openAbout
	    #activeHelpKey: #aboutSTX
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Licence Conditions'
	    #translateLabel: true
	    #value: #openLicenseConditions
	    #activeHelpKey: #aboutLicenseConditions
	  )
	 )
	nil
	nil
      )
!

classesMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:NewLauncher andSelector:#classesMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher classesMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: classesSystemBrowser
            label: 'System Browser'
            itemValue: openApplication:
            nameKey: systemBrowser
            submenuChannel: menuClassHistory
            labelImage: (ResourceRetriever ToolbarIconLibrary startSystemBrowserIcon 'System Browser')
            argument: 'Tools::NewSystemBrowser'
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: findClassAndBrowse
            label: 'Find Class...'
            itemValue: findClassAndBrowse
            nameKey: findClassAndBrowse
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            activeHelpKey: classesImplementors
            label: 'Implementors Of...'
            itemValue: browseImplementors
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            activeHelpKey: classesSenders
            label: 'Senders Of...'
            itemValue: browseSenders
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            activeHelpKey: classesStringSearch
            label: 'With String...'
            itemValue: browseMethodsWithString
            isVisible: false
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            activeHelpKey: classesResourceMethods
            label: 'Find Resource Methods...'
            itemValue: browseResources
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: startChangeSetBrowser
            label: 'Recent Changes'
            itemValue: startChangeSetBrowser
            nameKey: startChangeSetBrowser
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            activeHelpKey: classesClassBrowserOnChanges
            label: 'Changed Classes'
            itemValue: startClassBrowserOnChanges
            nameKey: classBrowserOnChanges
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            activeHelpKey: classBrowserOnChangedMethods
            label: 'Changed Methods'
            itemValue: startClassBrowserOnChangedMethods
            nameKey: classBrowserOnChangedMethods
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            activeHelpKey: startSmallTeamChangeSetBrowser
            label: 'Recent Changes on SmallTeam Host'
            isVisible: smallTeamAvailable
            submenuChannel: startBrowserOnSmallTeamChangesMenu
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Special Browsers'
            submenuChannel: classesSpecialBrowserMenu
          )
         (MenuItem
            activeHelpKey: classesClassTreeBrowser
            label: 'Class Tree'
            itemValue: openApplication:
            argument: 'ClassTreeGraphView'
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Method Finder (Semantic Search)'
            itemValue: openMethodFinder
            labelImage: (ResourceRetriever ToolbarIconLibrary methodFinder24x24Icon 'Method Finder (Semantic Search)')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: classesSpecial
            label: 'Special'
            nameKey: special
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: classesSpecialReferencesToUnboundGlobals
                  label: 'References to Unbound Globals'
                  itemValue: browseUnboundGlobals
                )
               (MenuItem
                  activeHelpKey: classesSpecialReferencesToUndeclared
                  label: 'References to Undeclared'
                  itemValue: browseUndeclared
                )
               (MenuItem
                  activeHelpKey: classesSpecialReferencesToUndeclared
                  label: 'Clear Undeclared Variables'
                  itemValue: clearUndeclaredVariables
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

classesSpecialBrowserMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:NewLauncher andSelector:#classesSpecialBrowserMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher classesSpecialBrowserMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    activeHelpKey: classesClassBrowser
	    label: 'Class Browser On...'
	    itemValue: startClassBrowser
	    nameKey: classBrowserOn
	    translateLabel: true
	    showBusyCursorWhilePerforming: true
	  )
	 (MenuItem
	    activeHelpKey: classesFullClassBrowser
	    label: 'Full Class Browser On...'
	    itemValue: startFullClassBrowser
	    translateLabel: true
	    showBusyCursorWhilePerforming: true
	  )
	 (MenuItem
	    activeHelpKey: classesClassHierarchyBrowser
	    label: 'Class Hierarchy Browser On...'
	    itemValue: startClassHierarchyBrowser
	    translateLabel: true
	    showBusyCursorWhilePerforming: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    label: 'Snapshot Image Browser...'
	    itemValue: startSnapshotImageBrowser
	    translateLabel: true
	    showBusyCursorWhilePerforming: true
	  )
	 (MenuItem
	    enabled: remoteImageBrowserAvailable
	    label: 'Remote Image Browser...'
	    itemValue: startRemoteImageBrowser
	    translateLabel: true
	    showBusyCursorWhilePerforming: true
	  )
	 )
	nil
	nil
      )
!

demosMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:NewLauncher andSelector:#demosMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher demosMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    activeHelpKey: demosGoodies
	    label: 'Goodies'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  activeHelpKey: demosClock
		  label: 'Clock'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Clock'
		)
	       (MenuItem
		  activeHelpKey: demosDigitalClock
		  label: 'Digital Clock'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'DigitalClockView'
		)
	       (MenuItem
		  activeHelpKey: demosDigitalClock
		  label: 'QlockTwoWatch'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'QlockTwoWatch'
		)
	       (MenuItem
		  activeHelpKey: demosBabelFish
		  label: 'BabelFish'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'SOAP::TranslationServiceApplication'
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    activeHelpKey: demosGames
	    label: 'Games'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  activeHelpKey: gamesTetris
		  label: 'Blocks (Tetris look alike)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Games::Tetris'
		)
	       (MenuItem
		  activeHelpKey: gamesTicTacToe
		  label: 'Tic Tac Toe'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Games::TicTacToeGame'
		)
	       (MenuItem
		  activeHelpKey: gamesTicTacToe2
		  label: 'Tic Tac Toe (2 Players)'
		  itemValue: startTicTacToe2
		  translateLabel: true
		)
	       (MenuItem
		  activeHelpKey: gamesPingPong
		  label: 'PingPong'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Games::PingPongGame'
		)
	       (MenuItem
		  activeHelpKey: gamesPingPong2
		  label: 'PingPong - (2 Players)'
		  itemValue: startPingPong2
		  translateLabel: true
		)
	       (MenuItem
		  activeHelpKey: gamesReversi
		  label: 'Reversi (Java)'
		  itemValue: startReversi
		  translateLabel: true
		)
	       (MenuItem
		  label: 'Towers of Hanoi (Prolog)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Prolog::TowersOfHanoiApplication'
		)
	       (MenuItem
		  label: 'MasterMind (Prolog)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Prolog::MasterMind'
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    activeHelpKey: demosGeometric
	    label: 'Geometric Designs'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  activeHelpKey: demosPen
		  label: 'Pen Demo'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'PenDemo'
		)
	       (MenuItem
		  activeHelpKey: demosCommander
		  label: 'Commander Demo'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'CommanderDemo'
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  activeHelpKey: demosMandel
		  label: 'Mandel'
		  itemValue: openMandelbrotDemo
		  translateLabel: true
		)
	       (MenuItem
		  activeHelpKey: demosFractalPlants
		  label: 'Fractal Plants Demo'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'FractalPlantsDemo'
		)
	       (MenuItem
		  activeHelpKey: demosFractalPatterns
		  label: 'Fractal Patterns Demo'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'FractalPatternsDemo'
		)
	       (MenuItem
		  activeHelpKey: demosLSystems
		  label: 'Lindenmayer Patterns Demo'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'LSystemsDemo'
		)
	       (MenuItem
		  activeHelpKey: demosMoreFractalPatterns
		  label: 'More Fractal Patterns Demo'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'ArmchairUniverseDemo'
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  label: 'Jan''s FractalApplication'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Demos::FractalApplication'
		)
	       (MenuItem
		  label: 'Jan''s Superformula'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Demos::SuperFormulaApplication'
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    activeHelpKey: demosAnimations
	    label: 'Simple Animations'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  activeHelpKey: demosWalkingMan
		  label: 'Walking Man'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Animation'
		)
	       (MenuItem
		  activeHelpKey: demosWalkingMan
		  label: 'Walking Girl'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'WalkingGirl'
		)
	       (MenuItem
		  activeHelpKey: demosGlobe
		  label: 'Globe Demo'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GlobeDemo'
		)
	       (MenuItem
		  activeHelpKey: chickenFun
		  label: 'Chicken Fun'
		  itemValue: startStopDemo:
		  translateLabel: true
		  indication: chickenFunIsRunning
		  argument: 'ChickenFun'
		)
	       (MenuItem
		  activeHelpKey: chickenFun
		  label: 'Chicks Eyes'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'ChickenEyes'
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    activeHelpKey: demos3D
	    label: '3D GL Graphics'
	    translateLabel: true
	    isVisible: displaySupportsGLDrawing
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  activeHelpKey: demos3Dplane
		  label: 'Plane'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLPlaneDemoView2'
		)
	       (MenuItem
		  activeHelpKey: demos3Dtetra
		  label: 'Tetra'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLTetraDemoView'
		)
	       (MenuItem
		  activeHelpKey: demos3DcubeWire
		  label: 'Cube (Wireframe)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLWireCubeDemoView'
		)
	       (MenuItem
		  activeHelpKey: demos3DcubeSolid
		  label: 'Cube (Solid)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLCubeDemoView'
		)
	       (MenuItem
		  activeHelpKey: demos3Dsphere
		  label: 'Sphere (Wireframe)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLWireSphereDemoView'
		)
	       (MenuItem
		  activeHelpKey: demos3Ddoughnut
		  label: 'Doughnut (Wireframe)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLDoughnutDemoView'
		)
	       (MenuItem
		  activeHelpKey: demos3Dplanet
		  label: 'Planet'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLPlanetDemoView'
		)
	       (MenuItem
		  activeHelpKey: demos3Dteapot
		  label: 'Teapot'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLTeapotDemo'
		)
	       (MenuItem
		  activeHelpKey: demos3Dlogo
		  label: 'Logo'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Logo3DView1'
		)
	       (MenuItem
		  activeHelpKey: demosCommander
		  label: 'Rubics Cube'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'RubicsCubeView'
		)
	       (MenuItem
		  label: 'X/Y Graph'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLXYGraph'
		)
	       (MenuItem
		  label: 'X/Y Graph Widget'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'CodingExamples_GUI::GLXYGraph3DDemo'
		)
	       (MenuItem
		  label: 'X/Y Graph Animated'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'CodingExamples_GUI::AnimatedGLXYGraph3DDemo'
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  label: 'Cube (Light)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLCubeDemoView2'
		)
	       (MenuItem
		  label: 'Cube (Light and Texture)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLBrickCubeDemoView'
		)
	       (MenuItem
		  label: 'Sphere (Light)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLSphereDemoView2'
		)
	       (MenuItem
		  label: 'Colored Octahedron'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'GLOctaHedronDemoView'
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    activeHelpKey: demosGraphicEditors
	    label: 'Graphic Editors'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  activeHelpKey: demosGraphicEditorsDrawTool
		  label: 'Draw Tool'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'DrawTool'
		)
	       (MenuItem
		  activeHelpKey: demosGraphicEditorsLogicTool
		  label: 'Logic Tool'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'LogicTool'
		)
	       (MenuItem
		  activeHelpKey: demosGraphicEditorsPaintTool
		  label: 'Paint Demo'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'ColorDrawDemo3'
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    activeHelpKey: demosGUI
	    label: 'GUI'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  activeHelpKey: demosGUIWidgets
		  label: 'Widget Gallery'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'CodingExamples_GUI::GUIDemo'
		)
	       (MenuItem
		  activeHelpKey: demosDrawingProtocol
		  label: 'Drawing Protocol Demo'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'CodingExamples_GUI::DrawingProtocolDemonstration'
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  activeHelpKey: demosGUICalculator
		  label: 'Calculator (simple)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'CodingExamples_GUI::GUIDemoCalculator'
		)
	       (MenuItem
		  activeHelpKey: demosGUICalculator
		  label: 'Calculator (nice)'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'CodingExamples_GUI::GUIDemoFoxCalculatorClone'
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    activeHelpKey: demosOldStuff
	    label: 'Old Stuff'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  activeHelpKey: demosCalendar
		  label: 'Calendar'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'Calendar'
		)
	       (MenuItem
		  activeHelpKey: demosCalculator
		  label: 'Calculator'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'CalculatorView'
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  activeHelpKey: demosMail
		  label: 'Mail Tool'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'MailView'
		)
	       (MenuItem
		  activeHelpKey: demosNews
		  label: 'News Tool'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'NewsView'
		)
	       (MenuItem
		  activeHelpKey: demosFTP
		  label: 'FTP Tool'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'FTPTool'
		)
	       (MenuItem
		  activeHelpKey: demosTelnet
		  label: 'Telnet Tool'
		  itemValue: openDemo:
		  translateLabel: true
		  argument: 'TelnetTool'
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

fileMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NewLauncher andSelector:#fileMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher fileMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: fileFileBrowser
            label: 'File Browser'
            itemValue: openFileBrowser
            nameKey: fileBrowser
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary startFileBrowserIcon 'File Browser')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fileLoadPackage
            enabled: enableDangerousMenuItemsInRemoteLauncher
            label: 'Load Package...'
            itemValue: fileLoadPackage
            nameKey: fileLoadPackage
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fileSaveImage
            enabled: enableDangerousMenuItemsInRemoteLauncher
            label: 'Save Image'
            itemValue: saveImage
            nameKey: saveImage
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary saveImageIcon 'Save Image')
          )
         (MenuItem
            activeHelpKey: fileSaveImageAs
            enabled: enableDangerousMenuItemsInRemoteLauncher
            label: 'Save Image As...'
            itemValue: saveImageAs
            nameKey: saveImageAs
            translateLabel: true
          )
         (MenuItem
            activeHelpKey: fileSaveSessionChangesAs
            enabled: enableDangerousMenuItemsInRemoteLauncher
            label: 'Save Session Changes As...'
            itemValue: saveSessionChangesAs
            nameKey: saveImageAs
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fileExit
            enabled: enableDangerousMenuItemsInRemoteLauncher
            label: 'Exit Smalltalk...'
            itemValue: exit
            nameKey: exitSmalltalk
            translateLabel: true
            isVisible: isMainLauncherHolder
          )
         (MenuItem
            activeHelpKey: fileClose
            label: 'Close...'
            itemValue: closeRequest
            translateLabel: true
            isVisible: isNotMainLauncherHolder
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
     MenuEditor new openOnClass:NewLauncher andSelector:#helpMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher helpMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: helpWhatsNewInSTX
            label: 'Launcher Documentation'
            itemValue: startLauncherDocumentation
          )
         (MenuItem
            activeHelpKey: helpToolsDocumentation
            label: 'Tool Documentation'
            itemValue: startToolsDocumentation
          )
         (MenuItem
            activeHelpKey: helpWhatsNewInSTX
            label: 'What''s New in ST/X'
            itemValue: startWhatsNewSTX
          )
         (MenuItem
            activeHelpKey: helpWhatsNew
            label: 'What''s New in the Documentation'
            itemValue: startWhatsNewDocumentation
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: helpSTXOnlineDocumentation
            label: 'ST/X Online Documentation'
            itemValue: startDocumentationTool
            labelImage: (ResourceRetriever ToolbarIconLibrary helpIcon2 'ST/X Online Documentation')
          )
         (MenuItem
            activeHelpKey: helpIndex
            label: 'Keyword Index'
            itemValue: startDocumentationIndex
          )
         (MenuItem
            activeHelpKey: helpTutorial
            label: 'Smalltalk/X Tutorial'
            itemValue: startTutorial
          )
         (MenuItem
            activeHelpKey: helpSmalltalkTutorial
            label: 'Smalltalk Language Tutorial'
            itemValue: startSmalltalkTutorial
          )
         (MenuItem
            activeHelpKey: helpProgrammersGuide
            label: 'Programmer''s Guide'
            itemValue: startProgrammersGuide
          )
         (MenuItem
            activeHelpKey: helpClassDocumentation
            label: 'Class Documentation'
            itemValue: startClassDocumentation
          )
         (MenuItem
            label: 'Web-Documents'
            isVisible: webDocumentsItemShownInHelpMenu
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: helpRFC
                  label: 'RFCs...'
                  itemValue: showRFC
                )
               (MenuItem
                  activeHelpKey: helpPortInfo
                  label: 'TCP/UDP Ports...'
                  itemValue: showPortInfo
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
            activeHelpKey: helpPrintDocumentation
            label: 'Print Documentation...'
            itemValue: showBookPrintDocument
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: helpShowTipOfTheDay
            label: 'Tip of the Day'
            itemValue: showTipOfTheDay
          )
         (MenuItem
            activeHelpKey: helpActiveHelp
            label: 'Tooltips (FlyBy Help)'
            itemValue: toggleFlyByHelp:
            indication: activeHelp
          )
         (MenuItem
            activeHelpKey: helpShowHelp
            label: 'Show Help Texts'
            isVisible: false
            indication: showingHelp:
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: helpCredits
            label: 'Credits'
            itemValue: showCredits
          )
         )
        nil
        nil
      )
!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NewLauncher andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(NewLauncher menu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: 'About'
            nameKey: about
            translateLabel: true
            submenuChannel: aboutMenu
            labelImage: (ResourceRetriever nil menuIcon)
          )
         (MenuItem
            label: 'File'
            nameKey: file
            translateLabel: true
            submenuChannel: fileMenu
          )
         (MenuItem
            label: 'Classes'
            nameKey: classes
            translateLabel: true
            submenuChannel: classesMenu
          )
         (MenuItem
            label: 'Tools'
            nameKey: tools
            translateLabel: true
            submenuChannel: toolsMenu
          )
         (MenuItem
            label: 'System'
            nameKey: system
            translateLabel: true
            submenuChannel: systemMenu
          )
         (MenuItem
            label: 'Settings'
            nameKey: settings
            translateLabel: true
            isVisible: useOldSettingsApplication
            submenuChannel: settingsMenu
          )
         (MenuItem
            label: 'Windows'
            nameKey: windows
            translateLabel: true
            submenuChannel: windowsMenu
          )
         (MenuItem
            label: 'Demos'
            nameKey: demos
            translateLabel: true
            submenuChannel: demosMenu
          )
         (MenuItem
            label: 'MENU_Help'
            nameKey: help
            translateLabel: true
            startGroup: conditionalRight
            submenuChannel: helpMenu
          )
         )
        nil
        nil
      )
!

menuOpenWorkspaceTypes
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NewLauncher andSelector:#systemMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher systemMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            activeHelpKey: toolsWorkspace
            label: 'Normal'
            itemValue: openRegularWorkspace
            translateLabel: true
          )
         (MenuItem
            activeHelpKey: toolsMyWorkspace
            label: 'My Workspace'
            itemValue: openMyWorkspace
            translateLabel: true
          )
         (MenuItem
            activeHelpKey: toolsSystemWorkspace
            label: 'System Workspace'
            itemValue: openSystemWorkspace
            translateLabel: true
          )
         (MenuItem
            activeHelpKey: toolsEvaluationWorkspace
            label: 'Evaluation Workspace'
            itemValue: openEvaluationWorkspace
            translateLabel: true
          )
         )
        nil
        nil
      )
!

menuToolbar
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:NewLauncher andSelector:#menuToolbar
     (Menu new fromLiteralArrayEncoding:(NewLauncher menuToolbar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: fileSaveImage
            enabled: enableDangerousMenuItemsInRemoteLauncher
            label: 'save image'
            itemValue: saveImage
            nameKey: saveImage
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary saveImageIcon)
          )
         (MenuItem
            activeHelpKey: fileFileBrowser
            label: 'open file browser'
            itemValue: openFileBrowser
            nameKey: fileBrowser
            isButton: true
            isVisible: fileBrowserItemVisible
            submenuChannel: menuFileHistory
            labelImage: (ResourceRetriever ToolbarIconLibrary startFileBrowserIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: toolsWorkspace
            label: 'open workspace'
            itemValue: openWorkspace
            nameKey: workspace
            isButton: true
            submenuChannel: menuOpenWorkspaceTypes
            labelImage: (ResourceRetriever ToolbarIconLibrary startWorkspaceIcon)
          )
         (MenuItem
            activeHelpKey: newSystemBrowser
            label: 'open system browser'
            itemValue: openApplication:
            nameKey: systemBrowser
            isButton: true
            submenuChannel: menuClassHistory
            labelImage: (ResourceRetriever ToolbarIconLibrary startNewSystemBrowserIcon)
            argument: 'Tools::NewSystemBrowser'
          )
         (MenuItem
            activeHelpKey: classesSystemBrowserOnClass
            label: 'System Browser On Class'
            isButton: true
            isVisible: false
            submenuChannel: menuClassHistory
            labelImage: (ResourceRetriever ToolbarIconLibrary startSystemBrowserOnHistoryClassIcon)
          )
         (MenuItem
            activeHelpKey: toolsChangesBrowserOrNavigateToRecentChange
            label: 'open changes browser'
            itemValue: startChangesBrowser
            nameKey: changesBrowser
            isButton: true
            submenuChannel: menuChangeHistory
            labelImage: (ResourceRetriever ToolbarIconLibrary startChangesBrowserIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: toolsGUIPainter
            label: 'open GUI Builder'
            itemValue: openApplication:
            nameKey: guiBuilder
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary startUIPainterIcon)
            argument: 'UIPainter'
          )
         (MenuItem
            activeHelpKey: toolsMenuEditor
            label: 'open menu editor'
            itemValue: openApplication:
            nameKey: menuEditor
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary startMenuEditorIcon)
            argument: 'MenuEditor'
          )
         (MenuItem
            activeHelpKey: toolsImageEditor
            label: 'open image editor'
            itemValue: openApplication:
            nameKey: imageEditor
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary startImageEditorIcon)
            argument: 'ImageEditor'
          )
         (MenuItem
            label: ''
          )
         (MenuItem
            activeHelpKey: systemGarbageCollectAndCompress
            label: 'garbage collect and compress'
            itemValue: compressingGarbageCollect
            nameKey: garbageCollect
            isButton: true
            isVisible: false
            labelImage: (ResourceRetriever ToolbarIconLibrary garbageCollectIcon)
          )
         (MenuItem
            activeHelpKey: helpSTXOnlineDocumentation
            label: 'help'
            itemValue: startDocumentationTool
            nameKey: help
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever XPToolbarIconLibrary stxHelpIcon)
          )
         )
        nil
        nil
      )
!

menuToolbar_pda
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NewLauncher andSelector:#menuToolbar_pda
     (Menu new fromLiteralArrayEncoding:(NewLauncher menuToolbar_pda)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'open file browser'
	    #isButton: true
	    #nameKey: #fileBrowser
	    #value: #openFileBrowser
	    #activeHelpKey: #fileFileBrowser
	    #labelImage: #(#ResourceRetriever ToolbarIconLibrary #startFileBrowserIcon)
	  )
	 #(#MenuItem
	    #label: ''
	  )
	 #(#MenuItem
	    #label: 'open system browser'
	    #isButton: true
	    #nameKey: #systemBrowser
	    #value: #openApplication:
	    #activeHelpKey: #classesSystemBrowser
	    #argument: 'SystemBrowser'
	    #labelImage: #(#ResourceRetriever ToolbarIconLibrary #startSystemBrowserIcon)
	    #submenuChannel: #menuClassHistory
	  )
	 #(#MenuItem
	    #label: ''
	  )
	 #(#MenuItem
	    #label: 'help'
	    #translateLabel: true
	    #isButton: true
	    #nameKey: #help
	    #startGroup: #right
	    #value: #startDocumentationTool
	    #activeHelpKey: #helpSTXOnlineDocumentation
	    #labelImage: #(#ResourceRetriever ToolbarIconLibrary #helpIcon2)
	  )
	 )
	nil
	nil
      )

    "Modified: / 05-11-2007 / 11:16:57 / cg"
!

menu_pda
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NewLauncher andSelector:#menu_pda
     (Menu new fromLiteralArrayEncoding:(NewLauncher menu_pda)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'About'
	    #translateLabel: true
	    #nameKey: #about
	    #activeHelpKey: #settings
	    #labelImage: #(#ResourceRetriever nil #menuIcon)
	    #submenuChannel: #aboutMenu
	    #keepLinkedMenu: true
	  )
	 #(#MenuItem
	    #label: '&File'
	    #translateLabel: true
	    #nameKey: #file
	    #activeHelpKey: #settings
	    #submenuChannel: #fileMenu
	    #keepLinkedMenu: true
	  )
	 #(#MenuItem
	    #label: 'Apps'
	    #translateLabel: true
	    #submenu:
	   #(#Menu
	      #(
	       #(#MenuItem
		  #label: 'Classes'
		  #translateLabel: true
		  #nameKey: #classes
		  #activeHelpKey: #settings
		  #submenuChannel: #classesMenu
		  #keepLinkedMenu: true
		)
	       #(#MenuItem
		  #label: 'Tools'
		  #translateLabel: true
		  #nameKey: #tools
		  #activeHelpKey: #settings
		  #submenuChannel: #toolsMenu
		  #keepLinkedMenu: true
		)
	       #(#MenuItem
		  #label: 'System'
		  #translateLabel: true
		  #nameKey: #system
		  #activeHelpKey: #settings
		  #submenuChannel: #systemMenu
		  #keepLinkedMenu: true
		)
	       #(#MenuItem
		  #label: 'Demos'
		  #translateLabel: true
		  #nameKey: #demos
		  #activeHelpKey: #settings
		  #submenuChannel: #demosMenu
		  #keepLinkedMenu: true
		)
	       )
	      nil
	      nil
	    )
	  )
	 #(#MenuItem
	    #label: 'Windows'
	    #translateLabel: true
	    #nameKey: #windows
	    #activeHelpKey: #settings
	    #submenuChannel: #windowsMenu
	    #keepLinkedMenu: true
	  )
	 #(#MenuItem
	    #label: '&Help'
	    #translateLabel: true
	    #nameKey: #help
	    #startGroup: #right
	    #activeHelpKey: #settings
	    #submenuChannel: #helpMenu
	    #keepLinkedMenu: true
	  )
	 )
	nil
	nil
      )

    "Modified: / 19-09-2006 / 20:48:22 / cg"
!

systemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:NewLauncher andSelector:#systemMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher systemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: systemMemory
            label: 'Memory'
            itemValue: openApplication:
            argument: 'MemoryMonitor'
          )
         (MenuItem
            activeHelpKey: systemMemoryUsage
            label: 'Memory Usage'
            itemValue: openApplication:
            argument: 'MemoryUsageView'
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: systemProcesses
            label: 'Processes'
            itemValue: startProcessMonitor
          )
         (MenuItem
            activeHelpKey: systemSemaphores
            label: 'Semaphores'
            itemValue: openApplication:
            argument: 'SemaphoreMonitor'
          )
         (MenuItem
            activeHelpKey: systemExternalStreams
            label: 'External Streams'
            itemValue: openApplication:
            argument: 'ExternalStreamMonitor'
          )
         (MenuItem
            activeHelpKey: fileModules
            enabled: enableDangerousMenuItemsInRemoteLauncher
            label: 'Modules...'
            itemValue: objectModuleDialog
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: systemGarbageCollect
            label: 'Collect Garbage'
            itemValue: garbageCollect
            labelImage: (ResourceRetriever nil garbageCollectIcon 'Collect Garbage')
          )
         (MenuItem
            activeHelpKey: systemGarbageCollectAndCompress
            label: 'Collect Garbage and Compress'
            itemValue: compressingGarbageCollect
            labelImage: (ResourceRetriever nil garbageCollectIcon 'Collect Garbage and Compress')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: systemReloadResources
            label: 'Reload Resources'
            itemValue: flushCachedResources
            labelImage: (ResourceRetriever nil garbageCollectIcon 'Reload Resources')
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            label: '-'
            isVisible: useNewSettingsApplication
          )
         (MenuItem
            activeHelpKey: systemSettings
            label: 'Settings...'
            itemValue: openSettings
            isVisible: useNewSettingsApplication
            labelImage: (ResourceRetriever ToolbarIconLibrary settings16x16Icon 'Settings...')
          )
         )
        nil
        nil
      )
!

toolsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:NewLauncher andSelector:#toolsMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher toolsMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: toolsOpenApplication
            label: 'Open Application...'
            itemValue: findApplicationAndOpen
            nameKey: openApplication
          )
         (MenuItem
            label: 'Recently Opened'
            submenuChannel: recentlyOpenedApplicationsMenu
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: toolsWorkspace
            label: 'Workspace'
            itemValue: openWorkspace
            nameKey: workspace
            labelImage: (ResourceRetriever ToolbarIconLibrary startWorkspaceIcon 'Workspace')
          )
         (MenuItem
            enabled: monticelloRepositoryAvailable
            label: 'Monticello Repository Browser'
            itemValue: startMonticelloRepositoryBrowser
            showBusyCursorWhilePerforming: true
          )
         (MenuItem
            label: 'Programming'
            nameKey: programming
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: toolsChangesBrowser
                  label: 'Change File Browser'
                  itemValue: startChangesBrowser
                  nameKey: changesBrowser
                  labelImage: (ResourceRetriever ToolbarIconLibrary startChangesBrowserIcon 'Change File Browser')
                )
               (MenuItem
                  activeHelpKey: toolsSUnit
                  label: 'SUnit Test Runner'
                  itemValue: startSUnitTestRunner
                  nameKey: startSUnitTestRunner
                  isVisible: false
                  labelImage: (ResourceRetriever NewLauncher startSUnitIcon 'SUnit Test Runner')
                )
               (MenuItem
                  activeHelpKey: toolsToDoList
                  label: 'Programmer''s ToDo List'
                  itemValue: startToDoListBrowser
                  nameKey: startToDoListBrowser
                )
               (MenuItem
                  activeHelpKey: toolsOOM
                  enabled: oomPackageLoaded
                  label: 'Code Metrics Browser'
                  itemValue: startOOMBrowser
                  nameKey: startOOMBrowser
                )
               (MenuItem
                  activeHelpKey: toolsSmaCC
                  enabled: smaccPackageLoaded
                  label: 'SmaCC ParserGenerator'
                  itemValue: startSmaCCParserGenerator
                  nameKey: startSmaCCParserGenerator
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: toolsInternationalLanguageTranslationEditor
                  label: 'International Language Translation Editor'
                  itemValue: startInternationalLanguageTranslationEditor
                  labelImage: (ResourceRetriever ToolbarIconLibrary languagesIcon 'International Language Translation Editor')
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: startSQLWorkspace
                  label: 'SQL Workspace'
                  itemValue: startSQLWorkspace
                  isVisible: false
                )
               (MenuItem
                  activeHelpKey: startSQLScratchpad
                  label: 'SQL Scratchpad'
                  itemValue: startSQLScratchpad
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            activeHelpKey: classesDebugging
            label: 'Debugging'
            nameKey: debugging
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: breakPointBrowser
                  label: 'Breakpoint Browser'
                  itemValue: openApplication:
                  labelImage: (ResourceRetriever ToolbarIconLibrary openBreakpointBrowserIcon 'Breakpoint Browser')
                  argument: 'Tools::BreakpointBrowser'
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: classesShowTracePoints
                  label: 'Show All Break && Trace Points'
                  itemValue: browseAllBreakAndTracePoints
                )
               (MenuItem
                  activeHelpKey: classesRemoveAllTracePoints
                  label: 'Remove All Break && Trace Points'
                  itemValue: removeAllBreakAndTracePoints
                )
               (MenuItem
                  activeHelpKey: classesStopIgnoringHalts
                  enabled: debuggerHasIgnoredHaltsOrSmalltalkIsIgnoringHalts
                  label: 'Stop Ignoring Halts/Breakpoints'
                  itemValue: stopIgnoringHalts
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Halt when Text is Sent to Transcript...'
                  itemValue: openTranscriptDebugDialog
                )
               (MenuItem
                  label: 'Trace when Text is Sent to Transcript...'
                  itemValue: openTranscriptTraceDialog
                )
               (MenuItem
                  label: 'Timestamp Transcript Messages'
                  itemValue: timestampTranscriptMessages:
                  indication: timestampTranscriptMessages
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: systemInterruptLatency
                  label: 'Interrupt Latency'
                  itemValue: startLatencyMonitor
                  isVisible: false
                )
               (MenuItem
                  label: '-'
                  isVisible: false
                )
               (MenuItem
                  activeHelpKey: systemEventView
                  label: 'Event View'
                  itemValue: openApplication:
                  argument: 'EventMonitor'
                )
               (MenuItem
                  activeHelpKey: systemEventTrace
                  label: 'Event Trace'
                  itemValue: startStopEventTrace
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: enableGlobalCoverageAnalysis
                  label: 'Clear all Coverage Info (Systemwide)'
                  itemValue: clearAllCoverageInfo
                )
               (MenuItem
                  activeHelpKey: enableGlobalCoverageAnalysis
                  label: 'Enable Coverage Analysis in all Processes'
                  itemValue: enableGlobalCoverageAnalysis
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'GUI'
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: toolsGUIPainter
                  label: 'GUI Painter'
                  itemValue: openApplication:
                  nameKey: guiPainter
                  labelImage: (ResourceRetriever ToolbarIconLibrary startUIPainterIcon 'GUI Painter')
                  argument: 'UIPainter'
                )
               (MenuItem
                  activeHelpKey: toolsMenuEditor
                  label: 'Menu Editor'
                  itemValue: openApplication:
                  nameKey: menuEditor
                  labelImage: (ResourceRetriever ToolbarIconLibrary startMenuEditorIcon 'Menu Editor')
                  argument: 'MenuEditor'
                )
               (MenuItem
                  activeHelpKey: toolsImageEditor
                  label: 'Image Editor'
                  itemValue: openApplication:
                  nameKey: imageEditor
                  labelImage: (ResourceRetriever ToolbarIconLibrary startImageEditorIcon 'Image Editor')
                  argument: 'ImageEditor'
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
            label: 'Bug Reporter'
            itemValue: startBugMessages
            nameKey: bugMessages
            isVisible: bugReporterAvailable
            labelImage: (ResourceRetriever NewLauncher bugReporterIcon 'Bug Reporter')
          )
         (MenuItem
            activeHelpKey: fileApplicationBuilder
            label: 'Application Packager (exe-Builder)'
            itemValue: openApplication:
            labelImage: (ResourceRetriever ToolbarIconLibrary projectBuilderIcon 'Application Packager (exe-Builder)')
            argument: 'Tools::ProjectBuilderAssistantApplication'
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: toolsMisc
            label: 'Misc'
            nameKey: misc
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: toolsMiscProjects
                  label: 'Projects'
                  isVisible: false
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        activeHelpKey: toolsMiscProjectsNewProject
                        label: 'New Project'
                        itemValue: newProject
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        activeHelpKey: toolsMiscProjectsSelectProject
                        label: 'Select Project...'
                        itemValue: selectProject
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: '-'
                  isVisible: false
                )
               (MenuItem
                  activeHelpKey: toolsMiscNewLauncher
                  label: 'Reopen Launcher'
                  itemValue: startNewLauncher
                )
               (MenuItem
                  activeHelpKey: demosRemoteLauncher
                  enabled: canOpenRemoteLauncher
                  label: 'Remote Launcher...'
                  itemValue: startRemoteLauncher
                )
               (MenuItem
                  activeHelpKey: demosPDALauncher
                  label: 'PDA Launcher...'
                  itemValue: startPDALauncher
                  isVisible: hasPDALauncher
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: toolsMiscNewChangesBrowser
                  label: 'New Changes Browser'
                  itemValue: startNewChangesBrowser
                )
               (MenuItem
                  activeHelpKey: toolsMiscOldChangesBrowser
                  label: 'Old Changes Browser'
                  itemValue: startOldChangesBrowser
                )
               (MenuItem
                  label: '-'
                  isVisible: canDoTerminal
                )
               (MenuItem
                  activeHelpKey: toolsTerminal
                  label: 'Terminal'
                  itemValue: openTerminal
                  isVisible: canDoTerminal
                )
               (MenuItem
                  label: 'Text Diff'
                  itemValue: openTextDiffTool
                )
               (MenuItem
                  label: '-'
                  isVisible: canDoTerminal
                )
               (MenuItem
                  label: 'Inspect Global Variables'
                  itemValue: inspectGlobalVariables
                )
               (MenuItem
                  label: 'Inspect Workspace Variables'
                  itemValue: inspectWorkspaceVariables
                )
               (MenuItem
                  label: 'Remove all Workspace Variables'
                  itemValue: removeAllWorkspaceVariables
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

windowsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:NewLauncher andSelector:#windowsMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher windowsMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Window'
            submenuChannel: allWindowsMenu
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: windowsIconifyAll
            label: 'Iconify All'
            itemValue: iconifyAllWindows
          )
         (MenuItem
            activeHelpKey: windowsDeiconifyAll
            label: 'Deiconify All'
            itemValue: deIconifyAllWindows
          )
         (MenuItem
            activeHelpKey: windowsRedrawAll
            label: 'Redraw All'
            itemValue: redrawAllWindows
          )
         (MenuItem
            label: 'Migrate'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Bring All Windows onto Screen'
                  itemValue: bringAllWindowsOntoScreen
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: windowsMigrateAllWindows
                  enabled: windowMigrationFunctionsAreShown
                  label: 'Migrate All To...'
                  itemValue: migrateAllWindows
                )
               (MenuItem
                  activeHelpKey: windowsSelectAndMigrate
                  enabled: windowMigrationFunctionsAreShown
                  label: 'Select and Migrate To...'
                  itemValue: viewMigrate
                )
               (MenuItem
                  activeHelpKey: windowsSelectAndMigrate
                  enabled: windowMigrationFunctionsAreShown
                  label: 'Select and Shrink...'
                  itemValue: viewSelectAndShrink
                )
               (MenuItem
                  activeHelpKey: windowsFindAndMigrate
                  enabled: windowMigrationFunctionsAreShown
                  label: 'Find by Name and Migrate To...'
                  itemValue: findAndMigrateWindow
                )
               (MenuItem
                  activeHelpKey: windowsFindAndMigrateBack
                  enabled: windowMigrationFunctionsAreShown
                  label: 'Find by Name and Migrate Back...'
                  itemValue: findAndMigrateWindowBack
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
            activeHelpKey: windowsViewTree
            label: 'Window Tree'
            itemValue: startWindowTreeView
            isVisible: windowTreeViewAvailable
          )
         (MenuItem
            activeHelpKey: windowsViewTreeAllViews
            label: 'Window Tree (All Windows)'
            itemValue: openApplication:
            isVisible: windowTreeViewAvailable
            argument: 'WindowTreeView'
          )
         (MenuItem
            activeHelpKey: windowsViewTreeAllScreens
            label: 'Window Tree (All Windows on All Screens)'
            itemValue: startWindowTreeViewForAll
            isVisible: windowTreeViewAvailable
          )
         (MenuItem
            activeHelpKey: flyByWindowInformation
            label: 'FlyBy Window Information'
            itemValue: showFlyByWindowInformation
            labelImage: (ResourceRetriever ToolbarIconLibrary viewFlyByInfo22x22Icon 'FlyBy Window Information')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: windowsViewTree
            label: 'Select and Inspect Hierarchy...'
            itemValue: openWindowTreeInspector
            labelImage: (ResourceRetriever ToolbarIconLibrary viewInspect22x22Icon 'Select and Inspect Hierarchy...')
          )
         (MenuItem
            activeHelpKey: windowsSelectAndInspect
            label: 'Select and Inspect...'
            itemValue: viewInspect
          )
         (MenuItem
            activeHelpKey: windowsSelectAndInspect
            label: 'Select and Browse...'
            itemValue: viewBrowse
          )
         (MenuItem
            activeHelpKey: windowsSelectAndDestroy
            label: 'Select and Destroy...'
            itemValue: viewDestroy
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: windowsFindAndRaise
            enabled: enableDangerousMenuItemsInRemoteLauncher
            label: 'Find by Name and Raise...'
            itemValue: findAndRaiseWindow
          )
         (MenuItem
            activeHelpKey: windowsFindAndDestroy
            enabled: enableDangerousMenuItemsInRemoteLauncher
            label: 'Find by Name and Destroy...'
            itemValue: findAndDestroyWindow
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: windowsGrapWindow
            label: 'Select and Grab Window...'
            itemValue: viewHardcopy
            labelImage: (ResourceRetriever ToolbarIconLibrary snapshot24x24Icon 'Select and Grab Window...')
          )
         (MenuItem
            activeHelpKey: windowsGrapWidget
            label: 'Select and Grab Widget...'
            itemValue: widgetHardcopy
          )
         (MenuItem
            activeHelpKey: windowsGrapScreen
            label: 'Grab Screen...'
            itemValue: fullScreenHardcopy
          )
         (MenuItem
            activeHelpKey: windowsGrapScreenArea
            label: 'Grab Screen Area...'
            itemValue: screenHardcopy
          )
         (MenuItem
            activeHelpKey: windowsGrapScreenArea
            label: 'Grab Screen Area with Delay...'
            itemValue: screenHardcopyWithDelay
          )
         )
        nil
        nil
      )
! !

!NewLauncher class methodsFor:'oldstyle-menu specs'!

settingsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NewLauncher andSelector:#settingsMenu
     (Menu new fromLiteralArrayEncoding:(NewLauncher settingsMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #activeHelpKey: #settingsLanguage
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Language...'
	    #itemValue: #languageSetting
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsKeyboardMappings
	    #label: 'Keyboard Mappings...'
	    #itemValue: #keyboardSetting
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsViewStyle
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'View Style...'
	    #itemValue: #viewStyleSetting
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsFonts
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Fonts...'
	    #itemValue: #fontSettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsMessages
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Messages...'
	    #itemValue: #messageSettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsCompilation
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Compilation...'
	    #itemValue: #compilerSettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsObjectMemory
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Object Memory...'
	    #itemValue: #memorySettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsSourceAndDebugger
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Source and Debugger...'
	    #itemValue: #sourceAndDebuggerSettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsTools
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Tools...'
	    #itemValue: #toolSettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsJava
	    #label: 'Java...'
	    #itemValue: #javaSettings
	    #translateLabel: true
	    #isVisible: #javaSupportPresent
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsPrinter
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Printer...'
	    #itemValue: #printerSettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsScreen
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Screen...'
	    #itemValue: #displaySettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsMisc
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Editing...'
	    #itemValue: #editSettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsMisc
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Misc...'
	    #itemValue: #miscSettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsCommunications
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Communications...'
	    #itemValue: #communicationsSettings
	    #translateLabel: true
	    #isVisible: false
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsSaveSettings
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Save Settings...'
	    #itemValue: #saveSettings
	    #translateLabel: true
	  )
	 #(#MenuItem
	    #activeHelpKey: #settingsLoadSettings
	    #enabled: #enableDangerousMenuItemsInRemoteLauncher
	    #label: 'Load Settings...'
	    #itemValue: #loadSettings
	    #translateLabel: true
	  )
	 )
	nil
	nil
      )
! !

!NewLauncher methodsFor:'accessing'!

errorListCanvas
    errorListCanvas isNil ifTrue:[
	errorListCanvas := DataSetView new.
    ].
    ^ errorListCanvas
!

examples
"
    reopening a standard launcher (without any added tools)
									[exBegin]
     NewLauncher removeAllUserAddedTools.
     NewLauncher open.
									[exEnd]



    adding your own menu items (for user-applications)

    an additional item in the tools menu:
									[exBegin]
     Transcript topView application
	addMenuItem:(MenuItem new
			label: 'Foo';
			value: [Transcript showCR:'foo invoked'];
			isButton: false;
			labelImage: nil;
			nameKey: #foo;
			activeHelpKey: #Foo)
	in:#menu
	position:#(before workspace)
	space:true
									[exEnd]

    an additional item in the tools menu:
									[exBegin]
     Transcript topView application
	addMenuItem:(MenuItem new
			label: 'Foo';
			value: [Transcript showCR:'foo invoked'];
			isButton: false;
			labelImage: nil;
			activeHelpKey: #Foo)
	in:#menu
	position:#(after guiPainter)
	space:true
									[exEnd]

    an additional item in one of the tools sub menus:
									[exBegin]
     Transcript topView application
	addMenuItem:(MenuItem new
			label: 'Foo';
			value: [Transcript showCR:'foo invoked'];
			isButton: false;
			labelImage: nil;
			activeHelpKey: #Foo)
	in:#toolbar
	position:#(after Workspace)
	space:true
									[exEnd]
"
!

infoLineTemplate
    "controls what is shown in the lower info - line.
     See classes defaultInfoLineTemplate and updateInfo for desription."

    ^ infoLineTemplate ? (self class defaultInfoLineTemplate)
!

infoLineTemplate:aString
    "controls what is shown in the lower info - line.
     See classes defaultInfoLineTemplate and updateInfo for desription."

    infoLineTemplate := aString.
!

menuToolbar
    "provide access to my toolBar"

    |menu|

    menu := Menu decodeFromLiteralArray:(self class menuToolbar).
    "/ menu receiver:self. -- now done in findGuiResources ...
    menu findGuiResourcesIn:self.

    ^ menu

    "Modified: / 27-03-2007 / 08:43:32 / cg"
!

transcriptView
    "provide access to my transcript view"

    transcript isNil ifTrue:[
	(self componentAt: #transcriptView) notNil ifTrue:[
	    transcript := (self componentAt: #transcriptView) subViews first.
	] ifFalse:[
	    transcript := Workspace new.
	]
    ].
    ^ transcript
! !

!NewLauncher methodsFor:'aspects'!

canDoTerminal
    "return a 'valueHolder', which returns true if the terminal application
     is available. For now, this is true if we run under unix"

    ^ OperatingSystem isUNIXlike
      or:[OperatingSystem isMSWINDOWSlike]

    "Created: / 27.7.1998 / 12:47:54 / cg"
    "Modified: / 28.4.1999 / 11:55:24 / cg"
!

canOpenRemoteLauncher
    ^ XWorkstation notNil and:[ XWorkstation isLoaded ]

    "Created: / 09-11-2007 / 12:10:51 / cg"
!

chickenFunIsRunning
    "return a 'valueHolder', which returns true if the chickenFun demo is running."

    ^ [Demos::ChickenFun notNil
      and:[Demos::ChickenFun isLoaded
      and:[Demos::ChickenFun isRunning]]]
!

debuggerHasIgnoredHalts
    ^ DebugView notNil and:[ DebugView hasIgnoredHalts or:[ Smalltalk ignoreHalt ]]

    "Modified: / 10-07-2010 / 18:47:36 / cg"
!

debuggerHasIgnoredHaltsOrSmalltalkIsIgnoringHalts
    ^ DebugView notNil and:[ DebugView hasIgnoredHalts or:[ Smalltalk ignoreHalt ]]

    "Modified: / 10-07-2010 / 18:47:36 / cg"
!

displaySupportsGLDrawing
    "return a 'valueHolder', which returns true if the GL support
     is available."

    ^ [Screen current supportsGLDrawing]

    "Modified: / 13.2.1998 / 14:26:31 / cg"
    "Created: / 3.5.1999 / 16:47:22 / cg"
!

enableDangerousMenuItemsInRemoteLauncher

    |holder|

    (holder := builder bindingAt:#enableDangerousMenuItemsInRemoteLauncher) isNil ifTrue:[
        builder aspectAt:#enableDangerousMenuItemsInRemoteLauncher 
                put:(holder := ValueHolder with:true).
    ].
    ^ holder
!

fileBrowserItemVisible
    |holder|

    (holder := builder bindingAt:#fileBrowserItemVisible) isNil ifTrue:[
        builder
            aspectAt:#fileBrowserItemVisible
            put:(holder := ValueHolder with:UserPreferences current useNewFileBrowser not)
    ].
    ^ holder
!

historyManagerActive
    "Answer whether the history manager is active."

    ^[HistoryManager isActive]

    "Created: / 20-06-2004 / 16:05:41 / masca"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

isMainLauncherHolder
    ^ [ isMainLauncher ]
!

isNotMainLauncherHolder
    ^ [ isMainLauncher not ]
!

javaSupportPresent
    "return a 'valueHolder', which returns true if the java support
     is available."

    ^ [JavaVM notNil and:[JavaVM isBehavior and:[JavaVM isLoaded]]]

    "Created: / 13.2.1998 / 14:25:59 / cg"
    "Modified: / 13.2.1998 / 14:26:31 / cg"
!

libraryBuilderAvailable
    ^ false

    "Created: / 20.6.1998 / 16:54:31 / cg"
!

noteBookCanvasHolder
    |holder|

    (holder := builder bindingAt:#noteBookCanvasHolder) isNil ifTrue:[
        builder aspectAt:#noteBookCanvasHolder put:(holder := ValueHolder with:nil).
        holder value:self transcriptView.
    ].
    ^ holder
!

oomPackageLoaded
    "true if the oom (metrics) package is loaded"

    "/ access via at: to prevent preference-detector from including oom as
    "/ prerequisite for NewLaucher.
    ^ (Smalltalk at:#'OOM::MetricVisualizer') isBehavior
!

selectedTabHolder
    |holder|

    (holder := builder bindingAt:#selectedTabHolder) isNil ifTrue:[
        builder aspectAt:#selectedTabHolder put:(holder := ValueHolder with:1).
        holder addDependent:self.
    ].
    ^ holder
!

showActiveHelpMenuItem
    ^ false
!

smaccPackageLoaded
    "true if the smacc (compiler-compiler) package is loaded"

    "/ access via at: to prevent preference-detector from including smacc as
    "/ prerequisite for NewLaucher.
    ^ (Smalltalk at:#'SmaCC::SmaCCParserGenerator') isBehavior
!

smallTeamAvailable
    ^ SmallTeam notNil

    "Created: / 12-11-2006 / 16:09:18 / cg"
!

sqlWorkspaceItemVisible
    ^ (Smalltalk at:#'SQL::ODBCScratchpad') notNil
!

tabList
    ^ resources array:#('Transcript' 'Errors').
!

webDocumentsItemShownInHelpMenu
    ^ false
! !

!NewLauncher methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "care for project changes & update my infoView"

    ((something == #currentProject) 
    or:[ (changedObject == Project)
    or:[ (something == #finishedSnapshot)]]) ifTrue: [self updateInfo].

    
    changedObject == self selectedTabHolder ifTrue: [
        changedObject value == 1 ifTrue:[
            self noteBookCanvasHolder value:self transcriptView.
            ^ self.
        ].
        changedObject value == 2 ifTrue:[
            self noteBookCanvasHolder value:self errorListCanvas.
            ^ self.
        ].
    ].
    super update:something with:aParameter from:changedObject.
!

updateInfo
    "update the infoLabel (at the bottom) from the current project"

    |project projectDir packageName packageNameOrNil defNameSpace projectInfo
     cvsRepository storeDB image bindings makeInfoString 
     svnRepositoryManagerClass svnWorkDirBaseName|

    (Project notNil and:[(project := Project current) notNil]) ifTrue:[
        projectDir := project directory.
        packageName := packageNameOrNil := project package.
        defNameSpace := project defaultNameSpace.
        packageNameOrNil = PackageId noProjectID ifTrue:[
            packageNameOrNil := nil
        ].
    ].
    defNameSpace isNil ifTrue:[
        defNameSpace := Smalltalk.
    ].
    image := ((ObjectMemory imageName ? 'none') asFilename baseName).

    SourceCodeManager notNil ifTrue:[
        SourceCodeManager isCVS ifTrue:[
            cvsRepository := SourceCodeManager repositoryName.
            (cvsRepository notNil) ifTrue:[
                cvsRepository := cvsRepository withoutPrefix:':pserver:'.
            ].
        ] ifFalse:[
            SourceCodeManager isStore ifTrue:[
                storeDB := SourceCodeManager hostAndDBName
            ]
        ]
    ].

    makeInfoString := 
        [:title :value |
            |v|
            v := value.
            value isString ifFalse:[v := '***' ].
            (resources string:title) allBold
            ,': '
            ,(v withColor:(Color blue darkened))
            ,' '
        ].

    bindings := Dictionary new.
    bindings at:'PACKAGE'
             put:( packageName isNil 
                    ifTrue:[ '' ]
                    ifFalse:[ (makeInfoString value:'Pkg' value:packageName) ]).
    
    bindings at:'PACKAGEOREMPTY'
             put:( packageNameOrNil isNil 
                    ifTrue:[ '' ]
                    ifFalse:[ (makeInfoString value:'Pkg' value:packageNameOrNil) ]).

    bindings at:'IMAGE'
             put:(makeInfoString value:'Img' value:image).

    bindings at:'NS' 
             put:( defNameSpace == Smalltalk
                    ifTrue:[ '' ]
                    ifFalse:[ '"',defNameSpace name,'" '] ).

    bindings at:'PROJECTDIR'
             put:(makeInfoString value:'Dir' value:(projectDir contractTo: 30)).

    bindings at:'CVS' 
             put:( cvsRepository isNil 
                    ifTrue:[ '' ] 
                    ifFalse:[ (makeInfoString value:'CVS' value:cvsRepository) ]).
    
    bindings at:'DB' 
             put:( storeDB isNil 
                    ifTrue:[ '' ] 
                    ifFalse:[ (makeInfoString value:'DB' value:storeDB) ]).
    
    bindings at:'NOREPOSITORY' 
             put: ((cvsRepository isNil and:[storeDB isNil])
                    ifTrue:[ (' >','No Repository'allBold,'< ') ]
                    ifFalse:[ '' ]).

    svnRepositoryManagerClass := Smalltalk at:#'SVN::RepositoryManager'.
    (svnRepositoryManagerClass notNil
        and:[ svnRepositoryManagerClass isLoaded
        and:[ svnRepositoryManagerClass enabled ]]
    ) ifTrue:[
        svnWorkDirBaseName := svnRepositoryManagerClass current workingCopyBase asFilename baseName.

        bindings
            at:  'SVN_WORKING_COPY'
            put: (makeInfoString value:'SVN Work' value:svnWorkDirBaseName).
    ] ifFalse:[
        bindings
            at:  'SVN_WORKING_COPY'
            put: ''
    ].

    projectInfo := self infoLineTemplate bindWithArguments:bindings.
    self infoLabelHolder value:projectInfo.
    ^ projectInfo.
! !

!NewLauncher methodsFor:'help'!

defaultInfoLabel

    ^self updateInfo

!

flyByHelpTextForKey:aKey
    |text|

    text := super flyByHelpTextForKey:aKey.
    aKey == #fileSaveImage ifTrue:[
	^ text bindWith:(ObjectMemory nameForSnapshot)
    ].
    ^ text
! !

!NewLauncher methodsFor:'menu configuration'!

addMenuItem:newItem from:anApplicationClassWhichProvidesResourcesOrNil in:where position:positionSpecOrNilArg space:space
    "adds a menu item;
       where == #menu        - menu item is added at the end of the sub menu 'Tools',
       where == #toolbar     - menu item is added at the end of the tool bar,
       where == #menu.<name> - menu item is added at the end of the sub menu named 'name',

    position may be one of:
        #(before <someItemPath>)
        #(after  <someItemPath>)
        #( #first )   or #first
        #( #last )    or #last   or nil

     If space is true, some empty space is inserted.
     This can be invoked by a classes #initialize method, to add an item
     for itself to the toolbar or menu."

    |what menuPanel freeMenuIndex mainMenuPanel item subViews subMenuPath
     rest subMenu subItem positionSpecOrNil itemNameOrNil before itemsOriginalLabel|

    itemsOriginalLabel := newItem label.
    newItem findGuiResourcesIn:anApplicationClassWhichProvidesResourcesOrNil rememberResourcesIn:nil.

    positionSpecOrNil := positionSpecOrNilArg.
    positionSpecOrNil isArray ifTrue:[
        positionSpecOrNil size > 1 ifTrue:[
            itemNameOrNil := positionSpecOrNil at:2.
        ].
        positionSpecOrNil := positionSpecOrNil at:1.
    ].
    before := (positionSpecOrNil == #first) or:[positionSpecOrNil == #before].

    what := where.
    (what isNil or:[what = 'toolbar']) ifTrue:[
        menuPanel := builder namedComponents at:#menuToolbarView ifAbsent:nil.
        menuPanel isNil ifTrue:[
            'NewLauncher [warning]: addUserTool failed - no menuPanel' infoPrintCR.
            ^ self
        ].
        "/ look if not already in the toolBar
        (self findItem:newItem inMenuPanel:menuPanel) ~~ 0 ifTrue:[
            "item already exists - do nothing"
            'NewLauncher: menu item already present:' infoPrint. newItem nameKey infoPrintCR.
            ^ self.
        ].

        "/ ok, not there; search for the position to put the item
        freeMenuIndex := 0.
        itemNameOrNil notNil ifTrue:[
            freeMenuIndex := menuPanel findFirst: [:i| i nameKey = itemNameOrNil].
            freeMenuIndex == 0 ifTrue:[
                freeMenuIndex := menuPanel findFirst: [:i| i activeHelpKey = itemNameOrNil
                                                           or:[i label = itemNameOrNil]].
            ]
        ].

        freeMenuIndex == 0 ifTrue:[
            "item to insert relative to not found, insert at the begin or end"
            freeMenuIndex := before ifTrue:[1] ifFalse:[menuPanel numberOfItems + 1].
        ] ifFalse:[
            before ifFalse:[freeMenuIndex := freeMenuIndex +1].
        ].

        space ifTrue:[
            "want an empty entry before or after newItem"
            (menuPanel createAtIndex:freeMenuIndex) menuItem:(MenuItem label:'').
            before ifFalse:[
                freeMenuIndex := freeMenuIndex + 1.
            ].
        ].

        (menuPanel createAtIndex:freeMenuIndex) menuItem:newItem.

        UserAddedToolBarItems isNil ifTrue: [UserAddedToolBarItems := Dictionary new].
        UserAddedToolBarItems at:newItem put:(AddedToolInfo new
                                            item:newItem;
                                            originalLabel:itemsOriginalLabel;
                                            resourceProvider:anApplicationClassWhichProvidesResourcesOrNil;
                                            where:where;
                                            positionSpec:positionSpecOrNilArg;
                                            space:space;
                                            before:before;
                                            menuWithNewItem:menuPanel;
                                            yourself)
    ].

    what isNil ifTrue:[
        what := #menu
    ].

    (what includes:$.) ifTrue:[
        subMenuPath := what asCollectionOfSubstringsSeparatedBy:$..
        what := subMenuPath at:1.
        subMenuPath := subMenuPath copyFrom:2.
    ] ifFalse:[
        subMenuPath := #('tools').
    ].

    what = 'menu' ifTrue:[
        mainMenuPanel := self builder menuBar.
        mainMenuPanel isNil ifTrue:[
            subViews := self builder window subViews.
            subViews notNil ifTrue:[
                mainMenuPanel := subViews at:1 ifAbsent:nil.
            ]
        ].
        mainMenuPanel isNil ifTrue:[
            'NewLauncher [warning]: addUserTool failed - no mainMenu' infoPrintCR.
            ^ self
        ].

        (subMenuPath isEmptyOrNil or:[subMenuPath first isEmptyOrNil]) ifTrue:[
            "add to top menu"
            menuPanel := mainMenuPanel.
        ] ifFalse:[
            "lookup sub menu"
            item := mainMenuPanel itemAt:subMenuPath first.
            item isNil ifTrue:[
                item := mainMenuPanel itemAt:'tools'.
                item isNil ifTrue:[
                    'NewLauncher [warning]: addUserTool failed - no tools menu' infoPrintCR.
                    ^ self
                ].
            ].
            rest := subMenuPath copyFrom:2.
            menuPanel := subMenu := item submenu.

            rest do:[:pathComponent|
                subMenu notNil ifTrue:[
                    menuPanel := subMenu.
                    subItem := subMenu itemAt:pathComponent.
                    subItem isNil ifTrue:[
                        subMenu := nil
                    ] ifFalse:[
                        subMenu := subItem submenu.
                    ]
                ].
            ].
            subMenu notNil ifTrue:[
                menuPanel := subMenu.
            ]
        ].

        "/ look if not already in the panel
        (self findItem:newItem inMenuPanel:menuPanel) ~~ 0 ifTrue:[
            "item already exists - do nothing"
            Transcript show:'NewLauncher: menu item already present:'; showCR:newItem nameKey.
            ^ self.
        ].

        "/ ok, search for the position to put the item

        freeMenuIndex := 0.
        itemNameOrNil notNil ifTrue:[
            freeMenuIndex := menuPanel findFirst:[:i| i nameKey = itemNameOrNil].
            freeMenuIndex == 0 ifTrue:[
                freeMenuIndex := menuPanel findFirst:[:i| i itemValue = itemNameOrNil].
                freeMenuIndex == 0 ifTrue:[
                    freeMenuIndex := menuPanel findFirst:[:i| i activeHelpKey = itemNameOrNil
                                                              or:[i label = itemNameOrNil]].
                ]
            ]
        ].
        freeMenuIndex == 0 ifTrue:[
            freeMenuIndex := before ifTrue:[1] ifFalse:[menuPanel numberOfItems + 1].
        ] ifFalse:[
            before ifFalse:[freeMenuIndex := freeMenuIndex +1].
        ].
        space ifTrue:[
            "want a line before or after newItem"
            (menuPanel createAtIndex:freeMenuIndex) menuItem:(MenuItem label: '-').
            before ifFalse:[
                freeMenuIndex := freeMenuIndex + 1.
            ].
        ].

        (menuPanel createAtIndex:freeMenuIndex) menuItem:newItem.

        UserAddedMenuItems isNil ifTrue: [UserAddedMenuItems := Dictionary new].
        UserAddedMenuItems at:newItem put:(AddedToolInfo new
                                            item:newItem;
                                            originalLabel:itemsOriginalLabel;
                                            resourceProvider:anApplicationClassWhichProvidesResourcesOrNil;
                                            where:where;
                                            positionSpec:positionSpecOrNilArg;
                                            space:space;
                                            before:before;
                                            menuWithNewItem:menuPanel;
                                            yourself)
    ].

    "
     UserAddedToolBarItems := nil.
     UserAddedMenuItems := nil.
     NewLauncher open.

     Transcript topView application
        addMenuItem:(MenuItem new
                        label: 'Foo';
                        value: [Transcript showCR:'foo'];
                        isButton: false;
                        labelImage: nil;
                        nameKey: #foo)
        in:'menu.'
        position:#(last)
        space:true.

     Transcript topView application
        addMenuItem:(MenuItem new
                        label: 'Foo';
                        value: [Transcript showCR:'foo'];
                        isButton: false;
                        labelImage: nil;
                        nameKey: #foo)
        in:#menu
        position:#(before Workspace)
        space:true.

     Transcript topView application
        addMenuItem:(MenuItem new
                        label: 'Bar';
                        value: [Transcript showCR:'bar'];
                        isButton: false;
                        labelImage: nil;
                        nameKey: #bar)
        in:#menu
        position:#(after foo)
        space:true.

     Transcript topView application
        addMenuItem:(MenuItem new
                        label: 'Baz';
                        value: [Transcript showCR:'baz'];
                        isButton: false;
                        labelImage: nil;
                        nameKey: #baz)
        in:#menu
        position:#(before bar)
        space:false.

     Transcript topView application
        addMenuItem:(MenuItem new
                        label: 'Baz2';
                        value: [Transcript showCR:'baz2'];
                        isButton: false;
                        labelImage: nil;
                        nameKey: #baz2)
        in:#menu
        position:#(after bar)
        space:false.

     Transcript topView application
        addMenuItem:(MenuItem new
                        label: 'Foo2';
                        value: [Transcript showCR:'foo2'];
                        isButton: false;
                        labelImage: nil;
                        nameKey: #foo2)
        in:'menu.classes'
        position:#last
        space:false.

     Transcript topView application
        addMenuItem:(MenuItem new
                        label: 'Foo3';
                        value: [Transcript showCR:'foo3'];
                        isButton: false;
                        labelImage: nil;
                        nameKey: #foo3)
        in:'menu.classes.special'
        position:#first
        space:true.
    "

    "Modified: / 19-08-2011 / 12:17:30 / cg"
!

addMenuItem:newItem in:where position:positionSpecOrNilArg space:space
    "adds a menu item;
       where == #menu        - menu item is added at the end of the sub menu 'Tools',
       where == #toolbar     - menu item is added at the end of the tool bar,
       where == #menu.<name> - menu item is added at the end of the sub menu named 'name',

    position may be one of:
	#(before <someItemPath>)
	#(after  <someItemPath>)
	#( #first )   or #first
	#( #last )    or #last   or nil

     If space is true, some empty space is inserted.
     This can be invoked by a classes #initialize method, to add an item
     for itself to the toolbar or menu."

    ^ self
	addMenuItem:newItem from:self in:where position:positionSpecOrNilArg space:space
!

findItem:menuItem inMenuPanel:menuPanel
    "find a menu item in the menupanel.
     Return the index of the item in the panel or 0
     if not found"

    |idx|

    idx := 0.
    menuItem nameKey notNil ifTrue:[
	idx := menuPanel findFirst: [:i| i nameKey = menuItem nameKey].
    ].
    idx == 0 ifTrue:[
	idx := menuPanel findFirst: [:i| (menuItem activeHelpKey notNil
					  and:[i activeHelpKey = menuItem activeHelpKey])
					 or:[menuItem label notNil
					     and:[i label = menuItem label]]]
    ].

    ^ idx
!

removeUserTool:toolNameOrMenuItem
    "removes a menu item labeled toolName
     This can be invoked by a classes #deinitialize method,
     to remove its item from the toolbar or menu.
    "
    self class removeUserTool:toolNameOrMenuItem
!

removeUserTool:toolNameOrMenuItem from:addedToolsCollection
    "removes a menu item labeled toolName
     This can be invoked by a classes #deinitialize method,
     to remove its item from the toolbar or menu.
    "

    self class removeUserTool:toolNameOrMenuItem from:addedToolsCollection

    "
     Transcript topView application
	removeUserTool:'Bar'
    "
    "
     Transcript topView application
	removeUserTool:'Foo'
    "

!

userAddedMenuItems
    "return a dictionary of user-added menu item infos.
    "

    ^ UserAddedMenuItems ? #()


!

userAddedToolBarItems
    "return a dictionary of user-added toolBar item infos.
    "

    ^ UserAddedToolBarItems ? #()


! !

!NewLauncher methodsFor:'menus-dynamic'!

allWindowsMenu
    "returns a subMenu with one oeprations-submenu entry per open window"

    |menu allViewsAndLabels|

    menu := Menu new receiver: self.
    allViewsAndLabels := self allTopViewsAndLabelsSortedFilteringWindowGroups:nil.
    allViewsAndLabels do:[:assoc |
        |view label submenu likeThis info item|

        view := assoc value.
        label := assoc key.

        submenu := Menu new.
        submenu addItem:((MenuItem 
                            label: 'Raise Deiconified'
                            itemValue: [view raiseDeiconified; setForegroundWindow])
                                hideMenuOnActivated:false).
        submenu addItem:((item := MenuItem 
                            label: 'Iconify'
                            itemValue: [view collapse])
                                hideMenuOnActivated:false).
        view topView isCollapsed ifTrue:[  
            item disable
        ].
        submenu addItem:(MenuItem 
                            label: 'Migrate...'
                            itemValue: [self migrateWindow:view]
                            enabled:(view windowGroup isModal not) ).
        submenu addItem:((MenuItem 
                            label: 'Bring onto Screen...'
                            itemValue: [self bringWindowOntoScreen:view] )
                                hideMenuOnActivated:false).

        submenu addSeparator.
        submenu addItem:(MenuItem 
                            label: 'Hardcopy'
                            itemValue: [self hardcopyOfView:view] ).
        submenu addItem:(MenuItem 
                            label: 'Inspect View'
                            itemValue: [view inspect] ).
        submenu addItem:(MenuItem 
                            label: 'Inspect Application'
                            itemValue: [view application inspect]
                            enabled:(view application notNil) ).
        submenu addSeparator.
        submenu addItem:(MenuItem 
                            label: 'Browse View Class'
                            itemValue: [view class browse] ).
        submenu addItem:(MenuItem 
                            label: 'Browse Application Class'
                            itemValue: [view application class browse]
                            enabled:(view application notNil) ).
        submenu addItem:(MenuItem 
                            label: 'Debug Application'
                            itemValue: [Debugger openOn:view windowGroup process] ).

        submenu addSeparator.
        submenu addItem:((MenuItem 
                            label: 'Close'
                            itemValue: [view destroy] )
                                hideMenuOnActivated:false).

        likeThis :=
            allViewsAndLabels
                select:[:assoc |
                    |otherView|

                    otherView := assoc value.
                    otherView class == view class
                        and:[ otherView application class == view application class]
                ]
                thenCollect:[:assoc | assoc value ].

        likeThis size > 1 ifTrue:[
            info := view application notNil
                        ifTrue:[ view application class name ]
                        ifFalse:[ view class name ].
            info := ' ("',info,'")'.
        ] ifFalse:[
            info := ''
        ].

        submenu addItem:(MenuItem new
                            label: (resources string:'Close all like This%1' with:info);
                            itemValue: [likeThis do:[:eachView | eachView destroy]];
                            translateLabel: false;
                            enabled:(likeThis size > 1)).

        submenu addItem:(MenuItem new
                            label: (resources string:'Iconify all like This%1' with:info);
                            itemValue: [likeThis do:[:eachView | eachView collapse]];
                            translateLabel: false;
                            enabled:(likeThis size > 1)).

        submenu addItem:(MenuItem new
                            label: (resources string:'Deiconify all like This%1' with:info);
                            itemValue: [likeThis do:[:eachView | eachView raiseDeiconified]];
                            translateLabel: false;
                            enabled:(likeThis size > 1)).


        menu addItem:(MenuItem new
                            label: label
                            itemValue: [view raiseDeiconified; setForegroundWindow]
                            translateLabel: false;
                            submenu: submenu
                            ).
    ].

    menu findGuiResourcesIn:self.
    ^menu

    "Created: / 27-04-2012 / 13:20:06 / cg"
!

menuChangeHistory
    "returns a sub menu on the last changes"

    |changeSet menu changeHistory|

    changeSet := ChangeSet current.
    changeHistory := OrderedCollection new.

    [:exit |
        changeSet reverseDo:[:change |
            change isMethodChange ifTrue:[
                change changeClass notNil ifTrue:[
                    (changeHistory contains:[:chg | chg className = change className
                                                 and:[chg selector = change selector]])
                    ifFalse:[
                        changeHistory add:change.
                        changeHistory size > 15 ifTrue:[
                            exit value:nil
                        ]
                    ].
                ].
            ].
        ]
    ] valueWithExit.

    menu := Menu new receiver: self.

    changeHistory isEmpty ifTrue:[
        menu addItem:(MenuItem new
                        label:'>> no uncommitted changes yet <<';
                        enabled:false).
    ] ifFalse:[
        menu addItemGroup:
            (changeHistory collect:[:change|
                MenuItem new
                    label: (change className , ' ' , (change selector ? '???'))
                    itemValue: [UserPreferences systemBrowserClass openInClass:change changeClass selector:change selector]
                    translateLabel: false;
                    activeHelpKey: #classBrowserOnChangedMethod
            ]).
    ].

    menu addItemGroup:
        {
            MenuItem new
                label: (resources string:'Open Change Set Browser on all Changes')
                itemValue:#startChangeSetBrowser
                translateLabel: false;
                activeHelpKey: #startChangeSetBrowser
            .
            MenuItem new
                label: (resources string:'Open Change Browser on File...')
                itemValue: 
                    [ 
                        |file|

                        file := Dialog requestFileName:'Change or Source File' default:ObjectMemory nameForChanges.
                        file notEmptyOrNil ifTrue:[
                            UserPreferences current changesBrowserClass openOn:file
                        ]
                    ]
                translateLabel: false;
                activeHelpKey: #changeBrowserOnFile
        }.

    menu findGuiResourcesIn:self.
    ^menu

    "Modified: / 25-01-2011 / 16:45:51 / cg"
!

menuClassHistory
    "returns a sub menu on the history of the classes"

    ^ self menuClassHistoryFor:(UserPreferences systemBrowserClass)
!

menuClassHistoryFor:whichBrowserClass
    "returns a sub menu on the history of the classes"

    |menu classHistory|

    menu := Menu new receiver: self.

    whichBrowserClass checkClassHistory.

    classHistory := whichBrowserClass classHistory.
    classHistory isEmptyOrNil ifTrue:[
        menu addItemGroup:{
                (MenuItem new
                        label:'>> no visited history yet <<';
                        enabled:false).
             }
    ] ifFalse:[
        menu addItemGroup:
            (classHistory collect:[:histEntry|
                MenuItem new
                    label: (histEntry className)
                    itemValue: [whichBrowserClass openInClass:histEntry theClass selector:histEntry selector]
                    translateLabel: false;
                    activeHelpKey: #classesSystemBrowserOnClass
            ]
        ).
    ].

    menu addItem: (MenuItem new
                        label: 'Find Class...'
                        itemValue: [self findClassAndBrowse];
                        activeHelpKey: #findClassAndBrowse).
    menu addItem: (MenuItem new
                        label: 'Implementors Of...'
                        itemValue: [self browseImplementors];
                        activeHelpKey: #browseImplementors).
    menu addItem: (MenuItem new
                        label: 'Senders Of...'
                        itemValue: [self browseSenders];
                        activeHelpKey: #browseSenders).
    menu addItem: (MenuItem new
                        label: 'References to Class...'
                        itemValue: [self browseReferencesToClass];
                        activeHelpKey: #browseReferencesToClass).
    menu addItem: (MenuItem new
                        label: 'Search String...'
                        itemValue: [self browseContainingString];
                        activeHelpKey: #browseContainingString).
    classHistory notEmptyOrNil ifTrue:[
        menu addSeparator.
        menu addItem: (MenuItem new
                            label: 'Clear History'
                            itemValue: [classHistory removeAll]
                            enabled:(classHistory notEmpty);
                            activeHelpKey: #historyEmptyMenu).
    ].

    menu findGuiResourcesIn:self.
    ^ menu

    "Modified: / 09-09-2012 / 13:09:49 / cg"
!

menuClassHistoryNew
    "returns a sub menu on the history of the classes"

    ^ self menuClassHistoryFor:(Tools::NewSystemBrowser ? NewSystemBrowser)
!

menuFileHistory
    "returns a subMenu on the history of the filebrowsers directories"

    |menu dirHistory|

    menu := Menu new receiver: self.

    dirHistory := AbstractFileBrowser directoryHistory.
    dirHistory isEmpty ifTrue:[
        menu addItem:(MenuItem new
                        label:(resources string:'>> no visited files yet <<');
                        enabled:false).
        ^ menu
    ].

    menu addItemGroup:
        (dirHistory collect:[:item|
            |dirNameString|
            dirNameString := item path.
            MenuItem new
                label: dirNameString
                itemValue: [UserPreferences fileBrowserClass openOn:dirNameString]
                translateLabel: false;
                activeHelpKey: #FileBrowserOnDirectory
        ]
    ).
    menu addItem: (MenuItem new
                        label: 'Clear History'
                        itemValue: [dirHistory removeAll]
                        enabled:(dirHistory notEmpty);
                        activeHelpKey: #historyEmptyMenu).

    menu findGuiResourcesIn:self.
    ^menu

    "Modified: / 09-09-2012 / 13:09:58 / cg"
!

recentlyOpenedApplicationsMenu
    |menu appHistory|

    appHistory := ApplicationModel recentlyOpenedApplications.
    appHistory isEmpty ifTrue:[^nil].

    menu := Menu new receiver: self.
    menu addItemGroup:
        (appHistory collect:[:appClassName|
            |item appClass label|

            appClass := Smalltalk classNamed:appClassName.
            appClass isNil ifTrue:[
                label := appClassName.
            ] ifFalse:[
                label := appClass nameWithoutPrefix
            ].
            item := MenuItem 
                label: label
                itemValue: #openApplication: argument: appClassName.

            appClass isNil ifTrue:[
                item enabled:false.
                item label:(LabelAndIcon icon:(ToolbarIconLibrary erase16x16Icon2) string:appClassName)
            ].
            item
        ]
    ).
    menu addItem: (MenuItem new
                        label: 'Clear History'
                        itemValue: [ ApplicationModel forgetRecentlyOpenedApplications ]
                        enabled:(appHistory notEmpty);
                        activeHelpKey: #historyEmptyMenu).

    menu findGuiResourcesIn:self.
    ^menu

    "Modified: / 09-09-2012 / 13:10:12 / cg"
!

startBrowserOnSmallTeamChangesMenu
    "returns a subMenu on the history of the filebrowsers directories"

    <resource: #programMenu >

    ^ [
        |m anyItem hosts|

        m := Menu new.

        SmallTeam notNil ifTrue:[
            hosts := SmallTeam hostsWithChanges asSortedCollection.
            hosts do:[:eachHost |
                |item|

                item := MenuItem label:eachHost.
                item itemValue:#'startBrowserOnChangesOnSmallTeamHost:' argument:eachHost.
                m addItem:item.
                anyItem := true.
            ].
        ].
        hosts isEmptyOrNil ifTrue:[ nil ] ifFalse:[ m ]
    ].

    "Created: / 12-11-2006 / 16:06:06 / cg"
! !

!NewLauncher methodsFor:'private-settings callBacks'!

reopenLauncher
    "reopen a new launcher.
     for now (since style & language settings currently do
     not affect living views ...)
     WARNING: bad design: Message known in LauncherDialogs"

    |newLauncher wasShowingHelp|

    wasShowingHelp := self showingHelp.
    newLauncher := super reopenLauncher.
    newLauncher showingHelp:wasShowingHelp.
    ^ newLauncher
! !

!NewLauncher methodsFor:'queries'!

preferredExtent

    ^ super preferredExtent min: Screen current extent // (2.5 @ 3.5)
!

useNewSettingsApplication
    ^ UserPreferences current useNewSettingsApplication.
!

useOldSettingsApplication

    ^ self useNewSettingsApplication not
!

windowMigrationFunctionsAreShown
    ^ XWorkstation notNil
! !

!NewLauncher methodsFor:'startup & release'!

allButOpenInterface:anInterface
    "sent by my superclass to open up my interface"

    "/ if there is already a transcript on my device,
    "/ I am a slave launcher with limited functionality.

    Transcript notNil ifTrue:[
        Transcript ~~ Stderr ifTrue:[
            isMainLauncher := (Transcript graphicsDevice == device).
            self enableDangerousMenuItemsInRemoteLauncher value: isMainLauncher.
        ] ifFalse:[
            isMainLauncher := true
        ]
    ] ifFalse:[
        isMainLauncher := true
    ].

    super allButOpenInterface:anInterface.

    self setupTranscript.
    Project notNil ifTrue: [Project addDependent:self].
    ObjectMemory addDependent:self.
    self class openLaunchers add: self.
    ^ builder

    "Created: / 5.2.1998 / 19:45:07 / cg"
    "Modified: / 20.6.1998 / 14:53:58 / cg"
!

postBuildWith:aBuilder
    "setup my preferred size"

    |win hMin|

    super postBuildWith:aBuilder.
    win := aBuilder window .
    win extent:(self preferredExtent).

"/
"/ TODO: somehow find out how much decoration is added by the window manager ...
"/

    hMin := (aBuilder window margin * 2)
	    + aBuilder menuBar preferredHeight
	    + (aBuilder componentAt:#infoBarSubSpec) height
	    + (aBuilder componentAt:#menuToolbarView) preferredHeight
	    -3 "+ 8".   "/ I guess this is menuToolbar level abs + textCollector level abs...

    win minExtent:( win minExtent x @ hMin ).

    "Modified: / 16-11-2006 / 14:23:17 / cg"
!

postOpenWith:aBuilder
    |toolInfo addMenuForToolInfo|

    self updateInfo.

    "/ increase my priority"
"/    self windowGroup process priority:(Processor userSchedulingPriority + 1).
    Processor activeProcess priority:(Processor userSchedulingPriority + 1).

    addMenuForToolInfo :=
        [:eachToolInfo|
            |menuItem originalLabel|

            menuItem := eachToolInfo item.
            originalLabel := eachToolInfo originalLabel.
            originalLabel notNil ifTrue:[ menuItem label:originalLabel ].
            self
                addMenuItem:menuItem
                from:(eachToolInfo resourceProvider)
                in:eachToolInfo where
                position:eachToolInfo positionSpec
                space:eachToolInfo space
        ].

    "/ add user tools
    UserAddedToolBarItems notNil ifTrue:[
        toolInfo := UserAddedToolBarItems.
        [
            UserAddedToolBarItems := nil.
             toolInfo do:addMenuForToolInfo.
        ] ifCurtailed:[
            UserAddedToolBarItems := toolInfo
        ]
    ].
    UserAddedMenuItems notNil ifTrue:[
        toolInfo := UserAddedMenuItems.
        [
            UserAddedMenuItems := nil.
            toolInfo do:addMenuForToolInfo.
        ] ifCurtailed:[
            UserAddedMenuItems := toolInfo
        ]
    ].

    super postOpenWith:aBuilder.

    "/ set the time-block
    UserPreferences current showClockInLauncher ifTrue:[
        self startClock
    ].

    "Modified: / 16-11-2006 / 12:50:21 / cg"
!

release

    super release.

    OpenLaunchers notNil ifTrue:[OpenLaunchers remove:self ifAbsent:nil].
    Project notNil ifTrue:[Project removeDependent:self].
    ObjectMemory removeDependent:self.
!

requestForWindowClose
    |answer|

    isMainLauncher ifFalse:[
	"/ remote launchers may not finish ST/X

	answer := Dialog
		    confirmWithCancel:(resources string:'Really close %1 (slave)?' with:self class name)
		    labels:(resources array:#('Cancel' 'Close'))
		    values:#(nil true)
		    default:1.
	answer isNil ifTrue:[
	    "/ cancel
	    ^ false
	].
	^ true
    ].

    ^ super requestForWindowClose
!

setupTranscript
    "create the transcript view"

    |launcher oldLauncherClass|

    "/ check if this is an additional launcher on a remote display.
    "/ if so, do not close the real launcher.

    (Transcript notNil and:[Transcript ~~ Stderr]) ifTrue:[
	isMainLauncher ifTrue:[
	    launcher := Transcript topView application
	] ifFalse:[
	    launcher := self class current.
	].

	(launcher notNil and:[launcher ~~ self]) ifTrue:[
	    launcher window graphicsDevice == device ifTrue:[
		OpenLaunchers notNil ifTrue:[
		    OpenLaunchers remove:launcher ifAbsent:nil.
		].
		((oldLauncherClass := Smalltalk at:#Launcher) notNil
		and:[oldLauncherClass isLoaded]) ifTrue: [
		    oldLauncherClass openLaunchers remove:launcher ifAbsent:nil
		].
		launcher close
	    ]
	]
    ].

    transcript := self transcriptView. "/ (self componentAt: #transcriptView) subViews first.

    isMainLauncher ifTrue:[
	transcript beTranscript.
    ] ifFalse:[
	transcript showCR:'**************** Notice ***********************'.
	transcript showCR:'**       this is NOT the Transcript          **'.
	transcript showCR:'** The real Transcript is on the main screen **'.
	transcript showCR:'**                                           **'.
	transcript showCR:'** Menus affecting common state are disabled **'.
	transcript showCR:'***********************************************'.
    ]

    "Modified: / 5.3.1999 / 18:00:36 / cg"
! !

!NewLauncher methodsFor:'user actions-classes'!

enableGlobalCoverageAnalysis
    InstrumentationContext new beActiveEverywhere.

    "Created: / 28-10-2011 / 20:31:28 / cg"
!

findApplicationAndOpen
    |cls|

    cls := SystemBrowser default askForClassWithFilter:[:cls | cls isVisualStartable].
    cls notNil ifTrue:[
        cls open
    ]
!

findClassAndBrowse
    |cls|

    cls := SystemBrowser default askForClass.
    cls notNil ifTrue:[
        SystemBrowser default openInClass:cls selector:nil
    ]
!

openMethodFinder
    "open the methodFinder (ported from squeak)"

    self openApplication:'MethodFinderWindow'
    "/ MethodFinderWindow open

    "Modified: / 16-10-2006 / 13:36:36 / cg"
!

startBrowserOnChangesOnSmallTeamHost:aHostName
    (UserPreferences current changeSetBrowserClass)
	openOn:(SmallTeam changesOnHost:aHostName)

    "Created: / 12-11-2006 / 16:07:12 / cg"
    "Modified: / 01-07-2011 / 16:46:48 / cg"
    "Modified (format): / 27-07-2012 / 20:39:06 / cg"
!

startOOMBrowser
    self openApplication:'OOM::MetricVisualizer'

    "Created: / 23-10-2006 / 16:00:25 / cg"
    "Modified: / 23-10-2006 / 20:38:34 / cg"
!

startToDoListBrowser
    self openApplication:'Tools::ToDoListBrowser'

    "Created: / 23-10-2006 / 16:00:25 / cg"
    "Modified: / 23-10-2006 / 20:38:34 / cg"
!

stopIgnoringHalts
    DebugView stopIgnoringHalts.
    Smalltalk ignoreHalt:false.
! !

!NewLauncher methodsFor:'user actions-debugging'!

openTranscriptDebugDialog
    |pattern|

    pattern := Dialog
                request:('Enter GLOB matchpattern for message text\(Breakpoint if matching text is sent to the Transcript)\\Empty to disable, * for any text.' withCRs)
                initialAnswer:(TextCollector debugSendersOfMessagePattern).
    pattern isNil ifTrue:[^ self].

    TextCollector debugSendersOfMessagePattern:pattern

    "Created: / 02-02-2012 / 12:05:05 / cg"
!

openTranscriptTraceDialog
    |pattern|

    pattern := Dialog
                request:('Enter GLOB matchpattern for message text\(Trace who sends matching text to the Transcript)\\Empty to disable, * for any.' withCRs)
                initialAnswer:(TextCollector traceSendersOfMessagePattern).
    pattern isNil ifTrue:[^ self].

    TextCollector traceSendersOfMessagePattern:pattern

    "Created: / 02-02-2012 / 12:06:10 / cg"
!

timestampTranscriptMessages
    ^ TextCollector perform: #timestampMessages ifNotUnderstood:[false]

    "Modified: / 25-07-2013 / 12:16:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timestampTranscriptMessages:aBoolean
    ^ TextCollector timestampMessages:aBoolean
! !

!NewLauncher methodsFor:'user actions-demos'!

openDemo:className
    "open a demo, given its name.
     Looks in both the Smalltalk- and the Demos-Namespace
     for that class."

    self openApplication:className nameSpace:Demos

!

openMandelbrotDemo
    self openDemo:#ComplexIterationView

    "Created: / 8.7.1998 / 20:36:37 / cg"
!

startPingPong2
    "opens a 2-user PingPong game"

    self openApplication:'PingPongGame' nameSpace:Games with:#open2PlayerGame

    "Modified: / 13.12.1999 / 22:24:15 / cg"
!

startReversi
    "opens a reversi game (java)"

    self openApplication:'JavaAppletDemo3' nameSpace:CodingExamples_GUI

    "Modified: / 13.12.1999 / 22:24:15 / cg"
!

startStopDemo:className
    "start/stop a demo, given its name.
     Looks in both the Smalltalk- and the Demos-Namespace
     for that class."

    |cls|

    cls := self findApplicationClass:className nameSpace:Demos.
    cls isNil ifTrue:[
	^ self
    ].

    Autoload autoloadFailedSignal handle:[:ex |
	self warn:(resources string:'Sorry, the %1 class seems to be not available.' with:cls name)
    ] do:[
	self withWaitCursorDo:[
	    cls isRunning ifTrue:[
		cls stop
	    ] ifFalse:[
		cls start
	    ]
	]
    ]
!

startTicTacToe2
    "opens a 2-user ticTacToe game"

    self openApplication:'TicTacToeGame' nameSpace:Games with:#open2UserGame
! !

!NewLauncher methodsFor:'user actions-file'!

clearTranscript
    Transcript current contents:''

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

saveImage
    "save image"

    [
	self saveImageAs:ObjectMemory nameForSnapshot.
    ] on:SnapshotError do:[:ex|
	self warn:ex description.
    ]
!

saveImageAs
    "save image, after asking for a file name"

    |imageFilename|

    imageFilename := Dialog
			requestFileName:(resources string:'Save Image As')
			default:ObjectMemory nameForSnapshot
			pattern:'*.img'
			fromDirectory:Filename currentDirectory.

    imageFilename notNil ifTrue:[
	[
	    self saveImageAs:imageFilename
	] on:SnapshotError do:[:ex|
	    self warn:ex description.
	].
    ].
!

saveSessionChangesAs
    "save the current default changeset as a patch file,
     after asking for a file name"

    |dir d changesFilename currentChangeSet|

    (d := Filename homeDirectory construct:'.smalltalk') exists ifTrue:[
        d := d construct:'userPatches'.
        d exists ifFalse:[
            d makeDirectory.
        ].
        dir := d.
    ] ifFalse:[
        dir := Filename currentDirectory.
    ].

    changesFilename := Timestamp now
         printStringFormat:'changes_%(year)-%(month)-%(day)__%h:%m:%s.chg'.
    OperatingSystem isMSWINDOWSlike ifTrue:[ changesFilename replaceAll:$: with:$_ ].

    currentChangeSet := ChangeSet current.
    changesFilename := Dialog
                        requestFileName:(resources 
                                            string:'Save %1 Changes (for %2 Selectors in %3 Classes) As' 
                                            with:currentChangeSet size
                                            with:currentChangeSet changeSelectors size
                                            with:currentChangeSet changedClasses size)
                        default:changesFilename
                        pattern:'*.chg'
                        fromDirectory:dir.

    changesFilename notEmptyOrNil ifTrue:[
        self saveSessionChangesAs:changesFilename.
        Transcript showCR:'session changes save in ',changesFilename asFilename pathName.
    ].
!

saveSessionChangesAs:changesFilename
    "save the current default changeset as a patch file"

    ChangeSet current fileOutAs: changesFilename
! !

!NewLauncher methodsFor:'user actions-help'!

activeHelp

    helpIsOn isNil ifTrue:[
        helpIsOn := PluggableAdaptor new
                        getBlock:[:m | UserPreferences current flyByHelpActive and:[FlyByHelp isActive]]
                        putBlock:[:m :newValue | UserPreferences current flyByHelpActive:newValue]
                        updateBlock:[:m :aspect :param | true].
        "/ helpIsOn addDependent:self.
    ].
    ^ helpIsOn
!

toggleFlyByHelp:aBoolean
    "turn on/off active help"

    UserPreferences current flyByHelpActive:aBoolean.

    "Modified: / 18.8.1998 / 16:06:27 / cg"
! !

!NewLauncher methodsFor:'user actions-system'!

initJavaVM
    JavaVM initializeVM

    "Created: / 9.2.1998 / 12:06:07 / cg"
!

startLatencyMonitor
    "open an interruptLatencyMonitor view"

    InterruptLatencyMonitor notNil ifTrue:[
	Autoload autoloadFailedSignal catch:[
	    InterruptLatencyMonitor open.
	    ^ self.
	].
    ].
    self warn:'Sorry - the irq latency monitor is not available
in this release'.
!

startProcessMonitor
    "open an ProcessMonitor view"

    self openApplication:(
	(UserPreferences current useProcessMonitorV2
	and:[ProcessMonitorV2 notNil])
	    ifTrue:['ProcessMonitorV2']
	    ifFalse:['ProcessMonitor']).
!

startSQLScratchpad
    ((Smalltalk at:#'SQL::ODBCScratchpad') notNil 
    and:[ (Smalltalk at:#'SQL::ODBCScratchpad') isLoaded ]) ifFalse:[
        Smalltalk loadPackage:'stx:libdb/libodbc/applications'.
    ].

    self openApplication:'SQL::ODBCScratchpad'.
!

startSQLWorkspace
    ((Smalltalk at:#'SQL::WorkspacePage') notNil 
    and:[ (Smalltalk at:#'SQL::WorkspacePage') isLoaded ]) ifFalse:[
        Smalltalk loadPackage:'stx:libdb/devtools'.
    ].

    self openApplication:'SQL::WorkspacePage'.
!

toggleHistoryManager
    "Toggle history manager usage."

    HistoryManager isActive
	ifTrue: [HistoryManager deactivate]
	ifFalse: [HistoryManager activate]

    "Created: / 20-06-2004 / 16:08:09 / masca"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
! !

!NewLauncher methodsFor:'user actions-windows'!

redrawAllWindows
    device redrawAllWindows.
! !

!NewLauncher::AddedToolInfo methodsFor:'accessing'!

before

    ^ before
!

before:something
    before := something.
!

item
    ^ item
!

item:something
    item := something.
!

menuWithNewItem
    ^ menuWithNewItem
!

menuWithNewItem:something
    menuWithNewItem := something.
!

originalLabel
    ^ originalLabel
!

originalLabel:something
    originalLabel := something.
!

positionSpec
    ^ positionSpec
!

positionSpec:something
    positionSpec := something.
!

resourceProvider
    ^ resourceProvider
!

resourceProvider:something
    resourceProvider := something.
!

space
    ^ space
!

space:something
    space := something.
!

where
    ^ where
!

where:something
    where := something.
! !

!NewLauncher class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

