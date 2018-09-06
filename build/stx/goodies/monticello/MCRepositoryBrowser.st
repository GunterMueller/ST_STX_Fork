"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#MCRepositoryBrowser
	instanceVariableNames:'repositoriesHolder packagesHolder versionsHolder
		selectedVersionHolder worker selectedVersionDetailsHolder
		selectedRepositoryHolder targetPackage targetNamespace
		lastPackage targetPackageHolder targetNamespaceNameHolder
		updateChangefileHolder selectedPackageHolder'
	classVariableNames:'LastAddedRepository LastAddedURLString'
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!


!MCRepositoryBrowser class methodsFor:'initialization'!

initialize
    "/ self installInLauncher.            - now done in phase 2
    ObjectMemory addDependent:self.
!

installInLauncher
    |menuItem action|

    NewLauncher isNil ifTrue:[^ self].
    ToolbarIconLibrary isNil ifTrue:[^ self].

    "/ NewLauncher removeUserTool:#TestRunner2.

    "Class may be changed, and we want to start the changed class"
    "/ action := (MessageSend receiver:(Smalltalk at:self name) selector:#open).
    action := [ (Smalltalk at:self name) open ].


    "Install in Tools menu"
    menuItem := (MenuItem label:'Monticello Browser')
                nameKey:#MonticelloBrowser;
                "/labelImage:self startSUnitIcon;
                value:action;
                isButton:false.
    NewLauncher 
        addMenuItem:menuItem
        from:self
        in:'menu.tools.programming'
        position:nil
        space:false.

    "Created: / 05-05-2012 / 19:12:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    something == #initialized ifTrue:[
        changedObject == ObjectMemory ifTrue:[
            self installInLauncher.
            ObjectMemory removeDependent:self.
        ]
    ].
! !

!MCRepositoryBrowser class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:MCRepositoryBrowser    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#browseVersion
'Open a changelist browser on the selected version'

#loadVersion
'Load the selected version'

#targetNamespace
'Namespace override. Change via the "Loading"-Menu'

#targetPackage
'ST/X Package override. Change via the "Loading"-Menu'

)

    "Created: / 07-09-2011 / 15:13:00 / cg"
! !

!MCRepositoryBrowser class methodsFor:'interface specs'!

packageDetailsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MCRepositoryBrowser andSelector:#packageDetailsSpec
     MCRepositoryBrowser new openInterface:#packageDetailsSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: packageDetailsSpec
        window: 
       (WindowSpec
          label: 'MC Package Details'
          name: 'MC Package Details'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 533 326)
        )
        component: 
       (SpecCollection
          collection: (
           (TextEditorSpec
              name: 'PackageDetails'
              layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
              model: selectedVersionDetailsHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              isReadOnly: true
              hasKeyboardFocusInitially: false
            )
           (LabelSpec
              name: 'Label1'
              layout: (LayoutFrame 2 0 -30 1 -1 0.5 -2 1)
              activeHelpKey: targetNamespace
              level: -1
              translateLabel: true
              labelChannel: targetNamespaceNameHolder
              adjust: left
            )
           (LabelSpec
              name: 'Label2'
              layout: (LayoutFrame 1 0.5 -30 1 -2 1 -2 1)
              activeHelpKey: targetPackage
              level: -1
              translateLabel: true
              labelChannel: targetPackageHolder
              adjust: left
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
     UIPainter new openOnClass:MCRepositoryBrowser andSelector:#windowSpec
     MCRepositoryBrowser new openInterface:#windowSpec
     MCRepositoryBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'MC Repository Browser'
          name: 'MC Repository Browser'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 796 497)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (VariableVerticalPanelSpec
              name: 'VariableVerticalPanel1'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              component: 
             (SpecCollection
                collection: (
                 (VariableHorizontalPanelSpec
                    name: 'VariableHorizontalPanel1'
                    component: 
                   (SpecCollection
                      collection: (
                       (SubCanvasSpec
                          name: 'RepositoryList'
                          hasHorizontalScrollBar: false
                          hasVerticalScrollBar: false
                          majorKey: MCRepositoryList
                          subAspectHolders: 
                         (Array
                            
                           (SubChannelInfoSpec
                              subAspect: menuHolder
                              aspect: repositoryListMenu
                            ) 
                           (SubChannelInfoSpec
                              subAspect: inGeneratorHolder
                              aspect: repositoriesHolder
                            )
                            
                           (SubChannelInfoSpec
                              subAspect: outGeneratorHolder
                              aspect: packagesHolder
                            ) 
                           (SubChannelInfoSpec
                              subAspect: selectionHolder
                              aspect: selectedRepositoryHolder
                            )
                          )
                          createNewApplication: true
                          createNewBuilder: true
                        )
                       (SubCanvasSpec
                          name: 'PackageList'
                          hasHorizontalScrollBar: false
                          hasVerticalScrollBar: false
                          majorKey: MCPackageList
                          subAspectHolders: 
                         (Array
                            
                           (SubChannelInfoSpec
                              subAspect: menuHolder
                              aspect: packageListMenu
                            ) 
                           (SubChannelInfoSpec
                              subAspect: inGeneratorHolder
                              aspect: packagesHolder
                            )
                            
                           (SubChannelInfoSpec
                              subAspect: outGeneratorHolder
                              aspect: versionsHolder
                            ) 
                           (SubChannelInfoSpec
                              subAspect: selectionHolder
                              aspect: selectedPackageHolder
                            )
                          )
                          createNewApplication: true
                          createNewBuilder: true
                        )
                       (ViewSpec
                          name: 'Box1'
                          component: 
                         (SpecCollection
                            collection: (
                             (SubCanvasSpec
                                name: 'VersionList'
                                layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
                                hasHorizontalScrollBar: false
                                hasVerticalScrollBar: false
                                majorKey: MCVersionList
                                subAspectHolders: 
                               (Array
                                  
                                 (SubChannelInfoSpec
                                    subAspect: inGeneratorHolder
                                    aspect: versionsHolder
                                  ) 
                                 (SubChannelInfoSpec
                                    subAspect: menuHolder
                                    aspect: versionsMenu
                                  )
                                  
                                 (SubChannelInfoSpec
                                    subAspect: selectionHolder
                                    aspect: selectedVersionHolder
                                  )
                                )
                                createNewApplication: true
                                createNewBuilder: true
                              )
                             (ActionButtonSpec
                                label: 'Browse'
                                name: 'Button1'
                                layout: (LayoutFrame 0 0 -30 1 0 0.5 0 1)
                                activeHelpKey: browseVersion
                                translateLabel: true
                                model: versionBrowser
                                enableChannel: hasVersionSelectedHolder
                              )
                             (ActionButtonSpec
                                label: 'Load'
                                name: 'LoadButton'
                                layout: (LayoutFrame 0 0.5 -30 1 0 1 0 1)
                                activeHelpKey: loadVersion
                                translateLabel: true
                                model: versionLoad
                                enableChannel: hasVersionSelectedHolder
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                    handles: (Any 0.333333333333333 0.666666666666667 1.0)
                  )
                 (UISubSpecification
                    name: 'SubSpecification1'
                    minorKey: packageDetailsSpec
                  )
                 )
               
              )
              handles: (Any 0.5 1.0)
            )
           )
         
        )
      )

    "Modified: / 16-03-2012 / 10:51:24 / cg"
! !

!MCRepositoryBrowser class methodsFor:'menu specs'!

loadingMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:MCRepositoryBrowser andSelector:#loadingMenu
     (Menu new fromLiteralArrayEncoding:(MCRepositoryBrowser loadingMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Set Target Package...'
            itemValue: setTargetPackage
          )
         (MenuItem
            label: 'Set Target Namespace...'
            itemValue: setTargetNamespace
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Update Changefile when Loading'
            indication: updateChangefileHolder
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
     MenuEditor new openOnClass:MCRepositoryBrowser andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(MCRepositoryBrowser mainMenu)) startUp
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
            label: 'Repository'
            translateLabel: true
            submenuChannel: repositoryListMenu
          )
         (MenuItem
            label: 'Package'
            translateLabel: true
            submenuChannel: packageListMenu
          )
         (MenuItem
            label: 'Version'
            translateLabel: true
            submenuChannel: versionsMenu
          )
         (MenuItem
            label: 'Loading'
            translateLabel: true
            submenuChannel: loadingMenu
          )
         (MenuItem
            label: 'Help'
            translateLabel: true
            startGroup: conditionalRight
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
     MenuEditor new openOnClass:MCRepositoryBrowser andSelector:#packageListMenu
     (Menu new fromLiteralArrayEncoding:(MCRepositoryBrowser packageListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: packageSelectedAndOperatingSystemIsWindows
            label: 'No Menuentry Yet'
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Modified: / 07-09-2011 / 11:44:38 / cg"
!

repositoryListMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:MCRepositoryBrowser andSelector:#repositoryListMenu
     (Menu new fromLiteralArrayEncoding:(MCRepositoryBrowser repositoryListMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Add Repository (URL)...'
            itemValue: repositoryAdd
          )
         (MenuItem
            label: 'Add Repository (Expression)...'
            itemValue: repositoryAddFromExpressionString
          )
         (MenuItem
            label: 'Add Directory Repository...'
            itemValue: directoryRepositoryAdd
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasRepositorySelectedHolder
            label: 'Remove from List'
            itemValue: repositoryRemove
          )
         (MenuItem
            enabled: hasRepositorySelectedHolder
            label: 'Flush Cache'
            itemValue: repositoryFlushCache
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: repositoryIsDirectory
            label: 'Browse Directory'
            itemValue: repositoryBrowseDirectory
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Inspect'
            itemValue: repositoryInspect
          )
         )
        nil
        nil
      )
!

versionsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:MCRepositoryBrowser andSelector:#versionsMenu
     (Menu new fromLiteralArrayEncoding:(MCRepositoryBrowser versionsMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasVersionSelectedHolder
            label: 'Load'
            itemValue: versionLoad
          )
         (MenuItem
            enabled: hasVersionSelectedHolder
            label: 'Load into Package...'
            itemValue: versionLoadIntoPackage
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasVersionSelectedHolder
            label: 'Browse'
            itemValue: versionBrowser
          )
         (MenuItem
            enabled: hasVersionSelectedHolder
            label: 'Browse Unloadable'
            itemValue: versionBrowseUnloadable
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Compare'
            itemValue: versionCompareWithImage
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Update Code...'
            itemValue: versionUpdateCode
          )
         (MenuItem
            enabled: canUpdateSplicemap
            label: 'Update Splicemap...'
            itemValue: versionUpdateSplicemap
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Save .mcz File As...'
            itemValue: saveMCZFileAs
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Show in File Browser'
            itemValue: showPackageInFileBrowser
          )
         (MenuItem
            enabled: hasVersionSelectedAndOperatingSystemIsWindowsHolder
            label: 'Show in Winzip'
            itemValue: showPackageInWinZip
          )
         (MenuItem
            enabled: hasVersionSelectedHolder
            label: 'Inspect'
            itemValue: versionInspect
          )
         )
        nil
        nil
      )
! !

!MCRepositoryBrowser class methodsFor:'menu-about'!

aboutThisApplicationText
    |msg|

    msg := super aboutThisApplicationText.
    msg := msg , '\\Written by:\\  Jan Vrany (jan.vrany@fit.cvut.cz)\  Claus Gittinger (cg@exept.de).'.
    ^msg withCRs.

    "Created: / 05-05-2012 / 19:23:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCRepositoryBrowser class methodsFor:'startup'!

openOnPrimaryRepository
    "the primary repository is the one into which we checkin by default.
     (see MCSettingsApplication)"

    ^ self openOnPrimaryRepositoryForPackage:nil

    "Created: / 03-12-2011 / 10:41:03 / cg"
!

openOnPrimaryRepositoryForPackage:anSTXPackageIdOrNil
    "the primary repository is the one into which we checkin by default.
     (see MCSettingsApplication)"

    |repository|

    repository := UserPreferences current at:#mcPrimaryRepository ifAbsent:nil.
    ^ self openOnRepository:repository forPackage:anSTXPackageIdOrNil

    "Created: / 03-12-2011 / 10:42:01 / cg"
!

openOnRepository:aRepository forPackage:anSTXPackageIdOrNil
    "the primary repository is the one into which we checkin by default.
     (see MCSettingsApplication)"

    |browser|

    browser := self new.
    browser allButOpen.
    browser selectedRepository:aRepository.
    anSTXPackageIdOrNil notNil ifTrue:[
        browser selectedPackage:anSTXPackageIdOrNil.
    ].
    browser openWindow.
    ^ browser.

    "Created: / 03-12-2011 / 10:42:01 / cg"
! !

!MCRepositoryBrowser methodsFor:'accessing'!

selectedPackage:aPackageName
    |listEntry packageListApp|

    packageListApp := (builder componentAt:#PackageList) application.
    listEntry := packageListApp listHolder value detect:[:listEntry | listEntry name = aPackageName] ifNone:nil.
    packageListApp selectionHolder value:listEntry.

    "Created: / 04-12-2011 / 09:30:00 / cg"
!

selectedRepository:aRepository
    |rep fakeEntry listEntry repListApp|

    rep := self repositoriesHolder value detect:[:e | e = aRepository] ifNone:nil.
    rep notNil ifTrue:[
        repListApp := (builder componentAt:#RepositoryList) application.
        fakeEntry := repListApp makeEntry:rep.
        listEntry := repListApp listHolder value detect:[:listEntry | listEntry repository = fakeEntry repository].
        repListApp selectionHolder value:listEntry.
    ]

    "Created: / 03-12-2011 / 10:44:16 / cg"
!

selectedVersion
    "return the value in 'selectedVersionHolder'"

    ^ self selectedVersionHolder value

    "Modified (comment): / 04-12-2011 / 09:28:52 / cg"
!

selectedVersion: newValue
    "set the value in 'selectedVersionHolder'"

    self selectedVersionHolder value: newValue
!

selectedVersionAsMCVersion
    | entry |

    entry :=  self selectedVersionHolder value.
    ^entry ifNil:[nil] ifNotNil:[entry asMCVersion].

    "Created: / 13-10-2010 / 17:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-12-2011 / 09:29:01 / cg"
! !

!MCRepositoryBrowser methodsFor:'aspect-queries'!

canUpdateSplicemap
    ^ ConfigurableFeatures hasMercurialSupport

    "Created: / 08-09-2015 / 00:56:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasRepositorySelectedHolder
    ^ BlockValue
        with:[:h | h value notNil]
        argument:(self selectedRepositoryHolder)

    "Created: / 13-10-2010 / 17:08:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 13:14:17 / cg"
    "Created: / 07-09-2011 / 15:00:44 / cg"
!

hasVersionSelectedAndOperatingSystemIsWindowsHolder
    ^[self hasVersionSelectedHolder value
      and:[ OperatingSystem isMSWINDOWSlike ]]

    "Created: / 25-08-2011 / 08:49:24 / cg"
!

hasVersionSelectedHolder
    ^ BlockValue
        with:[:h | h value notNil]
        argument:(self selectedVersionHolder)

    "Created: / 13-10-2010 / 17:08:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 13:14:17 / cg"
!

packageSelectedAndOperatingSystemIsWindows

    ^[
        OperatingSystem isMSWINDOWSlike 
            and:[selectedPackageHolder value notNil]
    ]

    "Created: / 05-05-2012 / 19:20:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryIsDirectory
    ^ BlockValue
        with:[:h | h value notNil
                   and:[ h value repository isKindOf: MCDirectoryRepository ]]
        argument:[ self selectedRepositoryHolder ]

    "Created: / 31-08-2011 / 09:08:54 / cg"
! !

!MCRepositoryBrowser methodsFor:'aspects'!

packagesHolder
    packagesHolder isNil ifTrue:[
        packagesHolder := ValueHolder new.
    ].
    ^ packagesHolder

    "Modified (comment): / 04-12-2011 / 09:27:57 / cg"
!

packagesHolder:something
    packagesHolder := something.

    "Modified (comment): / 04-12-2011 / 09:28:01 / cg"
!

repositoriesHolder
    repositoriesHolder isNil ifTrue:[
        repositoriesHolder := ValueHolder with:(MCRepositoryGroup default repositories).
    ].
    ^ repositoriesHolder

    "Modified: / 16-09-2010 / 18:33:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-12-2011 / 09:28:06 / cg"
!

repositoriesHolder:something
    repositoriesHolder := something.

    "Modified (comment): / 04-12-2011 / 09:28:09 / cg"
!

selectedPackageHolder
    selectedPackageHolder isNil ifTrue:[
        selectedPackageHolder := nil asValue.
    ].
    ^ selectedPackageHolder

    "Created: / 04-12-2011 / 09:27:50 / cg"
!

selectedRepositoryHolder
    selectedRepositoryHolder isNil ifTrue:[
        selectedRepositoryHolder := nil asValue.
    ].
    ^ selectedRepositoryHolder

    "Created: / 31-08-2011 / 09:09:56 / cg"
!

selectedVersionDetailsHolder
    <resource: #uiAspect>

    selectedVersionDetailsHolder isNil ifTrue:[
        selectedVersionDetailsHolder := '' asValue.
    ].
    ^ selectedVersionDetailsHolder.

    "Modified: / 17-09-2010 / 15:17:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-12-2011 / 11:08:52 / cg"
!

selectedVersionHolder
    selectedVersionHolder isNil ifTrue:[
        selectedVersionHolder := ValueHolder with:nil "defaultValue here".
        selectedVersionHolder onChangeSend: #updateVersionDetails to: self.        
    ].
    ^ selectedVersionHolder

    "Modified: / 17-09-2010 / 15:23:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-12-2011 / 09:28:21 / cg"
!

selectedVersionHolder:something
    selectedVersionHolder := something.
!

targetNamespaceNameHolder
    <resource: #uiAspect>

    targetNamespaceNameHolder isNil ifTrue:[
        targetNamespaceNameHolder := ValueHolder new.
    ].
    ^ targetNamespaceNameHolder.

    "Modified (comment): / 03-12-2011 / 11:09:03 / cg"
!

targetPackageHolder
    <resource: #uiAspect>

    targetPackageHolder isNil ifTrue:[
        targetPackageHolder := ValueHolder new.
    ].
    ^ targetPackageHolder.

    "Modified (comment): / 03-12-2011 / 11:09:09 / cg"
!

updateChangefileHolder
    updateChangefileHolder isNil ifTrue:[
        updateChangefileHolder := false asValue.
    ].
    ^ updateChangefileHolder

    "Created: / 07-09-2011 / 15:54:03 / cg"
!

versionsHolder
    versionsHolder isNil ifTrue:[
        versionsHolder := ValueHolder new.
    ].
    ^ versionsHolder

    "Modified (comment): / 04-12-2011 / 09:28:30 / cg"
!

versionsHolder:something
    versionsHolder := something.

    "Modified (comment): / 04-12-2011 / 09:28:33 / cg"
! !

!MCRepositoryBrowser methodsFor:'menu actions'!

addRepository:rep
    | files didWarn |

    didWarn := false.    
    Error handle:[:ex |
        Dialog warn:'Exception: ',ex description.
        didWarn := true.
    ] do:[
        files := rep allFileNames.
    ].
    files isNil ifTrue:[
        didWarn ifFalse:[
            Dialog warn:'repository does not exist or is inaccessable.'.
        ].
        ^ self.
    ].

    MCRepositoryGroup default addRepository:rep.
    self repositoriesHolder value:(MCRepositoryGroup default repositories)

    "Created: / 20-03-2012 / 17:37:17 / cg"
!

directoryRepositoryAdd
    |repStr rep|

    repStr := Dialog requestDirectoryName:'Directory repository to add:'.
    repStr isEmptyOrNil ifTrue:[^ self].

    rep := MCDirectoryRepository directory:repStr.
    self addRepository:rep

    "Created: / 29-08-2011 / 12:25:40 / cg"
!

openDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'tools/misc/monticellobrowser.html'.

    "Created: / 05-05-2012 / 19:26:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeRepository:rep
    MCRepositoryGroup default removeRepository:rep.
    self repositoriesHolder value:(MCRepositoryGroup default repositories)
!

repositoryAdd
    |repStr rep url initialURL|

    initialURL := LastAddedURLString ? 'http://www.squeaksource.com/project'.
    repStr := Dialog 
                request:'Repository to add (file- or HTTP-URL):' 
                initialAnswer:initialURL
                initialSelection:((initialURL findString:'project') to:(initialURL size)).

    repStr isEmptyOrNil ifTrue:[^ self].

    (repStr startsWith:'www.') ifTrue:[
        repStr := 'http://',repStr.
    ].

    Error handle:[:ex |
        LastAddedURLString := repStr.
        Dialog warn:'Invalid URL (',ex description,')'.
        ^ self
    ] do:[
        url := URI fromString:repStr.
    ].
    url isNil ifTrue:[
        LastAddedURLString := repStr.
        Dialog warn:'Invalid URL'.
        ^ self
    ].

    url method = 'http' ifTrue:[
        rep := MCHttpRepository
                location: repStr
                user: ''
                password: ''
    ] ifFalse:[ 
        url method = 'ftp' ifTrue:[
            rep := MCFtpRepository
                    host: url host 
                    directory: url path 
                    user: url user
                    password: (url password ? 'anonymous')
        ] ifFalse:[
            url isFileScheme ifTrue:[
                rep := MCDirectoryRepository directory:repStr.
            ].
        ]
    ].
    rep isNil ifTrue:[
        LastAddedURLString := repStr.
        Dialog warn:'Cannot figure out access scheme from URL.'.
        ^ self.
    ].  
    self withWaitCursorDo:[
        self addRepository:rep
    ].

    "Created: / 29-08-2011 / 12:25:40 / cg"
!

repositoryAddFromExpressionString
    |str repStr rep|

    rep := LastAddedRepository ? 'XMLSchemaCodeGen'.

    str := 'MCHttpRepository
    location: ''http://www.squeaksource.com/',rep,'''
    user: ''''
    password: ''''
'.
    repStr := Dialog 
                requestText:'Repository to add:'
                initialAnswer:str
                initialSelection:(str findRangeOfString:rep).

    repStr isEmptyOrNil ifTrue:[^ self].

    Error handle:[:ex |
        Transcript showCR:ex description
    ] do:[
        rep := Parser evaluate:repStr.
    ].
    rep isNil ifTrue:[
        Dialog warn:'cannot figure out access scheme.'.
        ^ self.
    ].
    self withWaitCursorDo:[
        self addRepository:rep
    ]

    "Created: / 20-03-2012 / 17:34:33 / cg"
!

repositoryBrowseDirectory
    "open a filebrowser on the selected directory-repository"

    |fn|

    fn := self selectedRepositoryHolder value repository directory asFilename.
    fn exists ifFalse:[
        Dialog warn:'No such directory'.
        ^ self.
    ].
    UserPreferences current fileBrowserClass openIn:fn

    "Created: / 31-08-2011 / 09:16:33 / cg"
!

repositoryFlushCache
    "flush the repository cache - useful only in case of an aborted file load"

    self selectedRepositoryHolder value repository flushCache

    "Created: / 07-09-2011 / 15:02:21 / cg"
!

repositoryInspect
    "for debugging"

    self selectedRepositoryHolder value repository inspect

    "Created: / 25-11-2011 / 11:33:09 / cg"
!

repositoryRemove
    |entry rep|

    entry := self selectedRepositoryHolder value.
    entry isNil ifTrue:[^ self].
    rep := entry repository.
    self withWaitCursorDo:[
        self removeRepository:rep
    ].
!

saveMCZFileAs
    |entry fn|

    entry := self selectedVersionHolder value.
    fn := Dialog 
            requestFileNameForSave:'Save MCZ file as:'
            default:entry name 
            fromDirectory:nil.

    self saveVersionFileToTempThenDo:[:tempFile |
        tempFile moveTo:(fn asFilename).
    ].
!

saveVersionFileToTempThenDo:aBlock
    |entry tempFile fileStream|

    tempFile := Filename newTemporary withSuffix:'zip'.

    self withReadCursorDo:[
        entry := self selectedVersionHolder value.
        entry repository
            readStreamForFileNamed:entry name do:[:s |
                fileStream := tempFile writeStream.
                s reset.
                s copyToEndInto:fileStream.
                fileStream close.
            ].
    ].
    aBlock value:tempFile
!

setTargetNamespace
    "specify an st/x namespace to be used as default"

    | nsName |

    nsName := Dialog 
                requestNameSpace:'Namepace to load code into:' 
                initialAnswer:targetNamespace.    
    nsName isEmptyOrNil ifTrue:[^self].

    targetNamespace := nsName.
    self targetNamespaceNameHolder value:('Target-Namespace: ',targetNamespace).

    "Created: / 07-09-2011 / 12:49:42 / cg"
!

setTargetPackage
    "specify an st/x package identifier to be used as default"
    
    | package |

    package := Dialog 
            requestProject:'Default Smalltalk/X package to load code into:'
            initialAnswer:targetPackage
            suggestions:#().
    package isNil ifTrue:[
        ^ self
    ].
    targetPackage := lastPackage := package.
    self targetPackageHolder value:('Target-Package: ' , targetPackage).

    "Created: / 07-09-2011 / 12:47:15 / cg"
    "Modified: / 06-10-2014 / 23:38:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showPackageInFileBrowser
    self saveVersionFileToTempThenDo:[:tempFile |
        UserPreferences current fileBrowserClass
            openOnFileNamed:tempFile
    ].
!

showPackageInWinZip
    self saveVersionFileToTempThenDo:[:tempFile |
        Win32OperatingSystem
            openApplicationForDocument:tempFile operation:#open
    ].

    "Created: / 07-09-2011 / 11:46:08 / cg"
!

versionBrowseUnloadable

     | version snapshot loader unloadables |
    version := self selectedVersionAsMCVersion.
    version ifNil:[^self].
    snapshot := version snapshot.
    loader := MCPackageLoader new 
                installSnapshot: snapshot;
                yourself.
    loader analyze.      
    unloadables := ChangeSet withAll:
        (loader unloadableDefinitions collect:
            [:def|def asChange]).

    (Tools::ChangeSetBrowser2
            on: unloadables 
            label: version info name  , ' (unloadable definitions)')
        beTwoColumn;
        targetNamespace:targetNamespace;
        targetPackage:targetPackage;
        open

    "Modified: / 26-10-2010 / 23:04:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 20:17:15 / cg"
!

versionBrowser

    | version snapshot |

    self withWaitCursorDo:[
        version := self selectedVersionAsMCVersion.
        version ifNil:[^self].
        snapshot := version snapshot.
        (Tools::ChangeSetBrowser2 
                on: (snapshot asChangeSet name:('ChangeSet for: ',version fileName))
                label: version info name)
            beTwoColumn;
            targetNamespace:targetNamespace;
            targetPackage:targetPackage;
            open
    ].

    "Modified: / 04-08-2011 / 19:03:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 20:17:36 / cg"
!

versionCompareWithImage

    | version package |

    self withWaitCursorDo:[
        version := self selectedVersionAsMCVersion.
        version isNil ifTrue:[ ^ self ].
        package := Dialog requestProject:(resources string: 'Package to compare with') initialAnswer:package suggestions: nil.
        package isNil ifTrue:[ ^ self ].
        self versionCompareWithImagePackage: package.  
    ].

    "Modified: / 02-10-2015 / 16:27:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionCompareWithImagePackage: package

    | version snapshot snapshotCS packageCS diffset diffCS |

    self withWaitCursorDo:[
        version := self selectedVersionAsMCVersion.
        version isNil ifTrue:[ ^ self ].
        snapshot := version snapshot.
        snapshotCS := snapshot asChangeSet.
        snapshotCS name: version info name.     
        packageCS := ChangeSet forPackage: package.
        "/ Remove St/X specific method and classes (used for package management)
        packageCS := packageCS reject:[:chg |  
            chg changeClass theNonMetaclass isProjectDefinition or:[ chg isMethodDefinitionChange and:[ AbstractSourceCodeManager isVersionMethodSelector: chg selector ]]
        ].
        diffset := snapshotCS diffSetsAgainst: packageCS.  
        diffCS := ChangeSet new.
        diffCS addAll: (diffset onlyInReceiver).
        diffCS addAll: (diffset changed collect:[:pair | pair first ]).
        diffCS addAll: (diffset onlyInArg collect:[ :chg | chg asAntiChange ]).
        "/ Filter out Organization change - not needed for Smalltalk/X
        (diffCS first isOtherChange and:[ diffCS first source startsWith: '" Organization:' ]) ifTrue:[ 
            diffCS removeFirst.
        ].
        "/ Sort so that class definitions are first and
        "/ class removals last.
        diffCS sort:[ :a :b | (a isClassDefinitionChange and:[b isClassDefinitionChange not]) or:[ a isClassRemoveChange not  and:[ b isClassRemoveChange ] ] ].
        "/ Set the package so when applied, the change goes to the 
        "/ correct package (if not overriden by 'target package'.
        diffCS do:[:each | each package: package ].

        diffCS name: (resources string: 'Diffs between %1 (MC version) and %2 (in image)' with: version info name with: package).
        (Tools::ChangeSetBrowser2 on: diffCS)
            beOneColumn;
            showSame: false;
            targetNamespace:targetNamespace;
            targetPackage:targetPackage;
            allowRemove: true;        
            open       
    ].

    "Created: / 07-09-2015 / 18:41:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-10-2015 / 16:27:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionInspect

    | v |
    v := self selectedVersionAsMCVersion.
    v ifNotNil:[v inspect]

    "Modified: / 13-10-2010 / 17:48:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionLoad
    "load into the default (or previously set) package"

    | entry |

    entry := self selectedVersionHolder value.
    entry notNil ifTrue:[
        self withWaitCursorDo:[
            | version package |

            version := entry asMCVersion.
            package := targetPackage.
            package isNil ifTrue:[ 
                version package name notNil ifTrue:[ 
                    "/ Just a guess...
                    package := 'stx:goodies/', (version package name asLowercase replaceAll: $- with: $_)
                ] ifFalse:[ 
                    package := PackageId noProjectID.
                ].
                package := Dialog 
                        requestProject:'Smalltalk/X package to load code into:'
                        initialAnswer:package
                        suggestions:#().
                package isNil ifTrue:[
                    ^ self
                ].  
            ].
            self versionLoad: version into:package
        ]
    ].

    "Modified: / 07-09-2011 / 14:51:57 / cg"
    "Modified: / 06-10-2014 / 23:39:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionLoad: version into: package

    self withWaitCursorDo:[
        MCStXNamespaceQuery 
            answer:(NameSpace name:targetNamespace ? 'Smalltalk')   
            do: [
                MCStXPackageQuery 
                    answer: package   
                    do: [
                        MCInteractiveLoadingQuery answer: true do:[
                            self updateChangefileHolder value ifTrue:[
                                version load
                            ] ifFalse:[
                                Class withoutUpdatingChangesDo:[
                                    version load
                                ]
                            ].
                        ]
                    ].
            ].
    ].

    "Created: / 09-11-2010 / 13:25:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2011 / 20:44:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 20:16:19 / cg"
!

versionLoadIntoPackage
    "specify an st/x package identifier"

    | version package |

    version := self selectedVersionAsMCVersion.
    version ifNil:[^self].

    package := Dialog 
                requestProject:'Smalltalk/X package to load code into' 
                initialAnswer:lastPackage
                suggestions:#().    
    package ifNil:[^self].

    lastPackage := package.
    self versionLoad: version into: package

    "Modified: / 09-11-2010 / 13:33:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 12:47:51 / cg"
!

versionUpdateCode

    | version package snapshot snapshotCS |

    self withWaitCursorDo:[
        version := self selectedVersionAsMCVersion.
        version isNil ifTrue:[ ^ self ].
        snapshot := version snapshot.
        snapshotCS := snapshot asChangeSet.
        snapshotCS name: version info name.
        ProjectDefinition allSubclassesDo:[ :def |
            ((def class compiledMethodAt: #monticelloName) notNil and:[
                def monticelloName = version package name]) ifTrue:[ 
                package := def package.
            ].
        ].
        package isNil ifTrue:[ 
            Dialog warn: (resources string: 'No package found for Monticello package ''%1''' with: version package name).
            ^ self
        ].
        self versionCompareWithImagePackage: package.  
    ].

    "Created: / 07-09-2015 / 18:36:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionUpdateSplicemap

    | version package dialog revset packageDef splicemap |

    self withWaitCursorDo:[
        version := self selectedVersionAsMCVersion.
        version isNil ifTrue:[ ^ self ].
        ProjectDefinition allSubclassesDo:[ :def |
            ((def class compiledMethodAt: #monticelloName) notNil and:[
                def monticelloName = version package name]) ifTrue:[ 
                package := def package.
                packageDef := def.
            ].
        ].
        package isNil ifTrue:[ 
            Dialog warn: (resources string: 'No package found for Monticello package ''%1''' with: version package name).
            ^ self
        ].
        revset := 'grep(''%1'')' bindWith: version info name.

        dialog := HGChangesetDialog new.
        dialog repository: (HGPackageWorkingCopy named:package) repository .
        dialog revset: revset asHGRevset.
        dialog open ifFalse:[ ^ self ].
        splicemap := { dialog changeset id literalArrayEncoding . version info literalArrayEncodingWithoutAncestors } 
                        , packageDef monticelloSplicemap.
        packageDef theMetaclass 
                compile: (packageDef monticelloSplicemap_codeFor:splicemap)
                classified:(packageDef class lookupMethodFor: #monticelloSplicemap) category

    ].

    "Created: / 07-09-2015 / 18:37:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2015 / 00:07:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCRepositoryBrowser methodsFor:'updating'!

updateVersionDetails
    |  versionEntry version |

    worker ifNotNil:[worker terminate. worker := nil].
    versionEntry := self selectedVersion.
    versionEntry ifNil:[selectedVersionDetailsHolder value:'No version selected'. ^self].
    "/ async is not a good idea - if it takes long, user might start to click around...
"/    worker := 
"/        [[selectedVersionDetailsHolder value:'Reading ',versionEntry name,'...'.
"/        version := versionEntry asMCVersion.
"/        version ifNotNil:
"/            [selectedVersionDetailsHolder value: version summary]] ensure:[worker := nil]] newProcess.
"/    worker resume.

    self withWaitCursorDo:[
        selectedVersionDetailsHolder value:'Reading ',versionEntry name,'...'.
        ZipArchive zipFileFormatErrorSignal handle:[:ex |
            (Dialog confirm:'Zipfile format error encountered while reading (corrupt file?).\\Debug?' withCRs)
                ifTrue:[ex reject].
        ] do:[
            version := versionEntry asMCVersion.
        ].
        version ifNotNil:[
            selectedVersionDetailsHolder value: version summary
        ]
    ].

    "Created: / 17-09-2010 / 15:23:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2010 / 22:08:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-12-2011 / 11:11:28 / cg"
! !

!MCRepositoryBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepositoryBrowser.st,v 1.38 2015-02-09 13:57:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepositoryBrowser.st,v 1.38 2015-02-09 13:57:08 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: MCRepositoryBrowser.st,v 1.38 2015-02-09 13:57:08 cg Exp $'
! !


MCRepositoryBrowser initialize!
