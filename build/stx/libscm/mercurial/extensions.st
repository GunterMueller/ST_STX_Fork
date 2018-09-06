"{ Package: 'stx:libscm/mercurial' }"!

!AbstractFileBrowser methodsFor:'aspects-hg'!

currentHgRepository
    | root |

    root := HGRepository discover: self currentDirectoryDisplayed.
    root isNil ifTrue:[ ^ self ].
    ^HGRepository on: root cached: true

    "Created: / 14-12-2012 / 19:22:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2013 / 10:04:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-queries-hg'!

hasHGWorkingCopyNotSelected

    ^ self hgMenusAreShown 
        and:[ (Smalltalk at:#HGCommand) isAvailable ]
        and:[((Smalltalk at:#HGRepository) discover:self currentDirectoryDisplayed) isNil]

    "Created: / 13-02-2014 / 12:01:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2016 / 22:12:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-queries-hg'!

hasHGWorkingCopySelected

    ^ self hgMenusAreShown 
        and:[ (Smalltalk at:#HGCommand) isAvailable ]
        and:[((Smalltalk at:#HGRepository) discover:self currentDirectoryDisplayed) notNil]

    "Created: / 14-12-2012 / 18:26:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 23-04-2016 / 22:12:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgBranches  
    self hgExecuteCommand: 'branches' objects: #()

    "Created: / 25-01-2013 / 20:14:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgClone
    | selectedDirectories dialog repoUrlHolder repoDirHolder repodirName repoDir  |

    selectedDirectories := self currentSelectedDirectories.
    repoUrlHolder := nil asValue.
    repoDirHolder := (selectedDirectories size = 1 and:[ selectedDirectories anElement directoryContents isEmpty])
                ifTrue:[ selectedDirectories anElement baseName asValue ]
                ifFalse:[ nil asValue ].
    dialog := DialogBox new.
    dialog title: (resources string: 'Clone repository...').
    dialog addLabelledInputField:(resources string: 'Repository URL:') 
                    adjust:#left 
                    on:repoUrlHolder 
                    tabable:true 
                    separateAtX:0.3.    
    dialog addLabelledInputField:(resources string: 'Directory:') 
                    adjust:#left 
                    on:repoDirHolder 
                    tabable:true 
                    separateAtX:0.3.  
    dialog addAbortButton; addOkButton.
    dialog open.
    dialog accepted ifFalse:[ ^ self ].

    repoUrlHolder value isEmptyOrNil ifTrue:[ 
        Dialog warn: (resources string: 'Empty repository URL')
    ].

    repoDir := self currentDirectoryDisplayed / repoDirHolder value.
    repoDir exists ifTrue:[ 
        repoDir isDirectory ifTrue:[ 
            repoDir directoryContents notEmpty ifTrue:[ 
                Dialog error: (resources string:'Cannot clone repository. Directory %1 is not empty.' with: repodirName).
                ^ self.
            ].
        ] ifFalse:[ 
            Dialog error: (resources string:'Cannot clone repository. %1 is not an empty directory' with: repodirName).
            ^ self.
        ].
    ].
    ProgressIndicator
        displayBusyIndicator: (resources string: 'Cloning %1 to %2...' with: repoUrlHolder value with: repoDirHolder value)
        at:(Screen default center)
        during:[  
            HGRepository clone: repoUrlHolder value to: repoDir.
            self updateCurrentDirectory
        ].

    "Created: / 13-02-2014 / 11:57:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2014 / 16:11:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-queries-hg'!

hgCloneEnabled
    ^ self hasHGWorkingCopyNotSelected

    "Created: / 13-02-2014 / 11:57:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgCommit
    | wc task |

    wc := self currentHgRepository workingCopy.
    task := wc commitTask.
    HGCommitDialog new
        task: task;
        open

    "Created: / 11-01-2013 / 19:27:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2013 / 12:56:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgEditConfig: file
    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl |
            appl openTextEditorForFile: file pathName 
        ].

    "Created: / 04-04-2013 / 19:40:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgEditConfigRepository
    | repo |

    repo := self currentHgRepository.
    self hgEditConfig: repo path / '.hg' / 'hgrc'

    "Modified: / 04-04-2013 / 19:42:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgEditConfigUser
    self hgEditConfig: Filename homeDirectory / '.hgrc'

    "Modified: / 04-04-2013 / 19:42:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgExecuteCommand: command
    "Executes svn command on currently selected objects"

    self hgExecuteCommand: command objects: self currentSelectedObjects.

    "Created: / 12-01-2013 / 12:08:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgExecuteCommand: command objects: givenObjects
    "Executes svn command on given objects (files/dirs)"

    | objects workdir objectsAsString executionBlock |

    objects := givenObjects.

    (self isKindOf: FileBrowserV2) ifTrue:[
        workdir := self currentDirectoryDisplayed.
        workdir isDirectory ifFalse:[
            workdir := workdir directory
        ].
    ] ifFalse:[
        (objects size == 1 and:[objects anElement isDirectory]) ifTrue:[
            workdir := objects anElement
        ] ifFalse:[
            workdir := Filename currentDirectory.
        ]
    ].

    objectsAsString := String streamContents:[:s|
        objects size == 1 ifTrue:[
            workdir asString = objects anElement asString ifTrue:[
                s nextPut:$.
            ] ifFalse:[
                s nextPutAll: objects anElement asString.
            ]
        ] ifFalse:[
            objects do:[:each|s nextPut:$"; nextPutAll:each asString; nextPut:$"]
                separatedBy:[s space]
        ]
    ].

    executionBlock := [:stream |
        | cmd |

        cmd := '"%1" --noninteractive %2 %3' 
                bindWith: HGCommand hgCommand
                    with: command
                    with: objectsAsString.
        stream nextPutAll: cmd; cr; cr.
        (self getExecutionBlockForCommand:cmd inDirectory: workdir) value:stream.
    ].
    self makeExecutionResultProcessFor:executionBlock withName:'Mercurial> hg ', command.

    "Created: / 12-01-2013 / 12:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgHeads  
    self hgExecuteCommand: 'heads' objects: #()

    "Created: / 25-01-2013 / 20:14:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgInit
    | selectedDirectories initial repodirName repodir  |

    selectedDirectories := self currentSelectedDirectories.
    initial := (selectedDirectories size = 1 and:[ selectedDirectories anElement directoryContents isEmpty])
                ifTrue:[ selectedDirectories anElement baseName ]
                ifFalse:[ 'repository' ].
    repodirName := Dialog request: (resources string: 'Enter name of the repository to create') initialAnswer: initial.
    repodir := self currentDirectoryDisplayed / repodirName.
    repodir exists ifTrue:[ 
        repodir isDirectory ifTrue:[ 
            repodir directoryContents notEmpty ifTrue:[ 
                Dialog error: (resources string:'Cannot initialize repository. Directory %1 is not empty.' with: repodirName).
                ^ self.
            ].
        ] ifFalse:[ 
            Dialog error: (resources string:'Cannot initialize repository. %1 is not an empty directory' with: repodirName).
            ^ self.
        ].
    ].
    HGRepository init: repodir.
    self updateCurrentDirectory

    "Created: / 13-02-2014 / 11:59:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2014 / 16:19:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-queries-hg'!

hgInitEnabled
    ^ self hasHGWorkingCopyNotSelected

    "Created: / 13-02-2014 / 11:59:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgLog  
    | browser |

    self withWaitCursorDo:[ 
        browser := HGChangesetBrowser new.
        browser repository: self currentHgRepository.
        browser open.
    ]

    "Created: / 25-03-2014 / 09:31:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-04-2014 / 09:51:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-dynamic-hg'!

hgMenuMerge
    | menu repo wc heads |

    menu := Menu new.
    repo := self currentHgRepository.
    wc := repo workingCopy.
    heads := repo log: 'head() and !! closed() and !! p1() and !! ancestor(p1())' limit: nil.
    heads do:[:head|
        | item label |

        "/ label := head branch name , ' - ' , head id printString.
        label := HGChangesetPresenter new changeset: head.
        item := MenuItem 
                    label: label
                    itemValue: [self hgMerge:head ].
        menu addItem: item.
    ].
    menu addItem:
        (MenuItem 
            label:'Revision...'
            itemValue: [ self hgMergeWithRevision ]).          


    ^menu.

    "Created: / 14-12-2012 / 19:14:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-03-2014 / 00:34:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-dynamic-hg'!

hgMenuPull
    | menu repo remotes |

    menu := Menu new.
    repo := self currentHgRepository.
    remotes := repo remotes.
    remotes notEmptyOrNil ifTrue:[
        remotes do:[:remote|
                menu addItem: (MenuItem new
                                label: remote displayString;
                                value:[ self hgPullFrom: remote repository: repo];
                                yourself).
        ].
        menu addSeparator.
    ].
    menu addItem:
        (MenuItem new
            label: (resources string: 'From...');
            value: [self hgPullFromURLRepository: repo];
            yourself).

    ^menu.

    "Created: / 04-04-2013 / 19:16:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-dynamic-hg'!

hgMenuPush
    | menu repo remotes |

    menu := Menu new.
    repo := self currentHgRepository.
    remotes := repo remotes.
    remotes notEmptyOrNil ifTrue:[
        remotes do:[:remote|
                menu addItem: (MenuItem new
                                label: remote displayString;
                                value:[ self hgPushTo: remote repository: repo];
                                yourself).
        ].
        menu addSeparator.
    ].
    menu addItem:
        (MenuItem new
            label: (resources string: 'To...');
            value: [self hgPushToURLRepository: repo];
            yourself).

    ^menu.

    "Created: / 04-04-2013 / 19:15:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-dynamic-hg'!

hgMenuUpdate
    | menu repo wc heads |

    menu := Menu new.
    repo := self currentHgRepository.
    wc := repo workingCopy.
    heads := repo log: 'head() and !! closed() and !! p1()' limit: nil.
    heads do:[:head|
        | item label |

        "/ label := head branch name , ' - ' , head id printString.
        label := HGChangesetPresenter new changeset: head.
        item := MenuItem 
                    label: label
                    itemValue: [self hgUpdate: head ].
        menu addItem: item.
    ].  
    menu addSeparator.
    menu addItem:
        (MenuItem 
            label:'Revision...'
            itemValue: [ self hgUpdateToRevision ]).


    ^menu.

    "Created: / 28-03-2014 / 00:00:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-04-2014 / 11:49:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgMerge:anHGChangeset 
    | repo  wc  appl  stream |

    appl := self openCommandResultApplication.
    stream := appl resultStream.
    appl changeTabTo:((resources string:'Merging with %1') 
                bindWith:anHGChangeset id printString).
    [
        repo := self currentHgRepository.
        wc := repo workingCopy.
        stream
            nextPutAll:(resources string:'Mercurial > hg merge');
            space;
            nextPutLine:anHGChangeset id printString.
        wc merge:anHGChangeset.
        stream
            nextPutAll:(resources string:'done');
            cr.
        (wc conflicts asSortedCollection:[:a :b | a pathName < b pathName ]) do:[:each | 
            each isUnresolved ifTrue:[
                | merger |

                stream nextPutAll:((resources string:'Resolving conflicts %1...') 
                            bindWith:each pathNameRelative).
                merger := HGMergeTool for:each.
                merger premerge ifTrue:[
                    stream nextPutLine:(resources string:'resolved').
                    each markResolved.
                ] ifFalse:[
                    stream nextPutLine:(resources string:'UNRESOLVED')
                ]
            ]
        ].
        stream nextPutAll:(resources string:'Merge finisged.')
    ] forkAt:Processor userBackgroundPriority

    "Created: / 14-01-2013 / 21:59:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-04-2013 / 19:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgMergeWithRevision
    | repo cs revset dialog |

    repo := self currentHgRepository.
    revset := '!! ancestor(p1())' asHGRevset.
    dialog := HGChangesetDialog new.     
    dialog repository: repo.
    dialog revset: revset.
    dialog open ifFalse:[ ^ self ].
    cs := dialog changeset.
    self hgMerge: cs.

    "Created: / 28-03-2014 / 00:34:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgPullFrom: remote repository:repo
    | appl stream|

    appl := self openCommandResultApplication.
    stream := appl resultStream.
    appl changeTabTo:((resources string: 'Pulling from %1') bindWith: remote asString).
    [
        stream nextPutAll:(resources string: 'Mercurial > hg pull'); space; nextPutLine: remote name.
        [
            | summary |                
            summary := repo pull: remote.
            summary printOn: stream.
            stream cr.
        ] on: Notification do:[:ex|
            stream nextPutLine: ex messageText.
            ex proceed.
        ]
    ] forkAt: Processor userBackgroundPriority

    "Created: / 04-04-2013 / 19:27:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-03-2014 / 12:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgPullFromURLRepository:repo
    | url options |

    options := repo remotes collect:[:r|r url asString].
    url :=  Dialog 
                request:'Enter an URL from which to pull:' 
                initialAnswer:'http://...'  
                list: options. 
    url notEmptyOrNil ifTrue:[
        self hgPullFrom: (HGRemote url: url) repository: repo.
    ]

    "Created: / 04-04-2013 / 19:16:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-03-2014 / 12:09:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgPushTo: remote repository:repo
    | appl stream|

    appl := self openCommandResultApplication.
    stream := appl resultStream.
    appl changeTabTo:((resources string: 'Pushing to %1') bindWith: remote asString).
    [
        stream nextPutAll:(resources string: 'Mercurial > hg push'); space; nextPutLine: remote name.
        [
            | summary |                
            summary := repo push: remote.
            summary printOn: stream.
            stream cr.
        ] on: Notification do:[:ex|
            stream nextPutLine: ex messageText.
            ex proceed.
        ]
    ] forkAt: Processor userBackgroundPriority

    "Created: / 04-04-2013 / 19:23:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-03-2014 / 12:10:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgPushToURLRepository:repo
    | url options |

    options := repo remotes collect:[:r|r url asString].
    url :=  Dialog 
                request:'Enter an URL where to push:' 
                initialAnswer:'http://...'  
                list: options. 
    url notEmptyOrNil ifTrue:[
        self hgPushTo: (HGRemote url: url) repository: repo.
    ]

    "Created: / 04-04-2013 / 19:15:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-03-2014 / 12:09:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgResolve
    | wc prefixsz files |

    wc := self currentHgRepository workingCopy.
    prefixsz := wc pathName size + 1.
    files := self currentSelectedObjects.
    (files size == 1 and:[files anElement isDirectory]) ifTrue:[
        files := wc conflicts asSortedCollection:[:a :b|a pathName < b pathName].
        files := files select:[:e|e isUnresolved].
    ] ifFalse:[
        files := files collect:[:file|
            | path |
            path := file pathName.
            path := path copyFrom: prefixsz.
            wc / path.
        ].
    ].
    files do:[:entry|
        (HGMergeTool for: entry) merge ifTrue:[
            entry markResolved.
        ].
    ]

    "Modified: / 16-01-2013 / 09:19:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgResolveList
    self hgExecuteCommand: 'resolve --list' objects: #()

    "Modified: / 14-01-2013 / 21:55:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgResolveListUnresolved
    | repo wc appl stream|

    appl := self openCommandResultApplication.
    stream := appl resultStream.
    appl changeTabTo:(resources string: 'Unresolved conflicts').
    repo := self currentHgRepository.
    wc := repo workingCopy.
    (wc conflicts asSortedCollection:[:a :b|a pathName < b pathName]) do:[:each|
        each isUnresolved ifTrue:[
            stream nextPutLine: each pathNameRelative
        ].
    ].

    "Modified: / 15-01-2013 / 10:47:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgResolveMark
    self hgExecuteCommand: 'resolve --mark' objects: self currentSelectedObjects.

    "Created: / 14-01-2013 / 21:37:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgRevert
    self hgExecuteCommand: 'revert'

    "Created: / 15-01-2013 / 09:23:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgStatus
    self hgExecuteCommand: 'status'

    "Modified: / 12-01-2013 / 12:09:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgSummary       
    self hgExecuteCommand: 'summary' objects: #()

    "Created: / 25-01-2013 / 17:40:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgUpdate
    ^ self hgUpdate: nil.

    "Created: / 15-01-2013 / 09:23:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-03-2014 / 00:20:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgUpdate: changesetOrNil
    | executionBlock workdir |

    (self isKindOf: FileBrowserV2) ifTrue:[
        workdir := self currentDirectoryDisplayed.
        workdir isDirectory ifFalse:[
            workdir := workdir directory
        ].
    ] ifFalse:[
        (self currentSelectedObjects size == 1 and:[self currentSelectedObjects anElement isDirectory]) ifTrue:[
            workdir := self currentSelectedObjects anElement
        ] ifFalse:[
            workdir := Filename currentDirectory.
        ]
    ].
    
    executionBlock := [:stream |
        | cmd |

        cmd := '%1 --noninteractive %2 %3' 
                bindWith: HGCommand hgCommand
                    with: 'update'
                    with: (changesetOrNil isNil ifTrue:[''] ifFalse:['-r ' , changesetOrNil id printString]).
        stream nextPutAll: cmd; cr; cr.
        (self getExecutionBlockForCommand:cmd inDirectory: workdir) value:stream.
    ].
    self makeExecutionResultProcessFor:executionBlock withName:'Mercurial> hg update'

    "Created: / 28-03-2014 / 00:19:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgUpdateClean
    self hgExecuteCommand: 'update -C' objects: #()

    "Created: / 15-01-2013 / 09:23:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-hg'!

hgUpdateToRevision
    | repo cs revset dialog |

    repo := self currentHgRepository.
    revset := '!! p1()' asHGRevset.
    dialog := HGChangesetDialog new.     
    dialog repository: repo.
    dialog revset: revset.
    dialog open ifFalse:[ ^ self ].
    cs := dialog changeset.
    self hgUpdate: cs.

    "Created: / 28-03-2014 / 00:33:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser class methodsFor:'menu specs-scm'!

hgMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#hgMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser hgMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Commit'
            itemValue: hgCommit
            labelImage: (ResourceRetriever HGIconLibrary commit 'Commit')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Summary'
            itemValue: hgSummary
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Status'
            itemValue: hgStatus
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Browse Revision History'
            itemValue: hgLog
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Branches'
            itemValue: hgBranches
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Heads'
            itemValue: hgHeads
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Update'
            itemValue: hgUpdate
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Update To Revision'
            submenuChannel: hgMenuUpdate
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Revert'
            itemValue: hgRevert
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Revert all Changes'
            itemValue: hgUpdateClean
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Push'
            submenuChannel: hgMenuPush
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Pull'
            submenuChannel: hgMenuPull
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Merge...'
            submenuChannel: hgMenuMerge
            labelImage: (ResourceRetriever HGIconLibrary merge 'Merge...')
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Resolve'
            itemValue: hgResolve
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Mark as Resolved'
            itemValue: hgResolveMark
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Mark as Unresolved'
            itemValue: hgResolveUnmark
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Show Conflicts'
            itemValue: hgResolveList
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Show Unresolved'
            itemValue: hgResolveListUnresolved
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hgCloneEnabled
            label: 'Clone...'
            itemValue: hgClone
          )
         (MenuItem
            enabled: hgInitEnabled
            label: 'Create...'
            itemValue: hgInit
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasHGWorkingCopySelected
            label: 'Edit Repository Config (.hg/hgrc)'
            itemValue: hgEditConfigRepository
          )
         (MenuItem
            label: 'Edit User Config  (~/.hgrc)'
            itemValue: hgEditConfigUser
          )
         )
        nil
        nil
      )
! !

!Annotation class methodsFor:'instance creation'!

HGRevision: aString
    "Used by Mercurial to internally store revision info. Should never appear in source code!!"

    ^HGRevisionAnnotation revision: aString

    "Created: / 20-11-2012 / 23:34:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteArray methodsFor:'converting'!

asHGChangesetId
    ^ HGChangesetId fromBytes:self.

    "Created: / 16-11-2012 / 21:33:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'converting'!

asHGChangesetId
    ^ HGChangesetId fromString:self.

    "Created: / 16-11-2012 / 21:24:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'converting'!

asHGRevset
    ^ HGRevset fromString:self.

    "Created: / 11-03-2014 / 20:51:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurableFeatures class methodsFor:'queries-features'!

hasHGSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^ (Smalltalk at: #'HGSourceCodeManager' ifAbsent:nil) notNil

    "
     ConfigurableFeatures hasGitSupport
    "

    "Created: / 14-12-2012 / 15:38:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurableFeatures class methodsFor:'queries-features'!

hasHGSupportEnabled
    ^ (self hasSCMSupportEnabledFor:#'HGSourceCodeManager') and:[ (Smalltalk at:#HGCommand) askFor: #isAvailable ] 

    "
     self hasHGSupportEnabled
    "

    "Created: / 14-12-2012 / 15:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2016 / 22:47:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Integer methodsFor:'converting'!

asHGChangesetId
    ^ (HGChangesetId new:0) revno:self.

    "Created: / 16-11-2012 / 21:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'converting'!

asHGChangesetId
    HGError 
        raiseErrorString:'Cannot convert arbitrary object to Mercurial nodeid'

    "Created: / 16-11-2012 / 21:23:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'converting'!

asHGRevision
    ^self asHGChangesetId

    "Created: / 20-11-2012 / 23:32:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2012 / 17:56:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'converting'!

asHGRevset
    ^self shouldNotImplement

    "Created: / 11-03-2014 / 20:50:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'testing'!

isHGChangeset
    "Return true, if receiver is sort an Mercurial changeset."

    ^false

    "Created: / 01-02-2013 / 13:42:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - hg'!

hgBinaryRevision

    "
    Answers Mercurial revision from which the package was compiled.
    If no binary revision is available, returns nil."


    | revInfo |

    self binaryRevisionString notNil ifTrue:[
        revInfo := HGRevisionInfo readFrom: self binaryRevisionString onError:[nil].
        revInfo notNil ifTrue:[
            "/ Now, validate the changeset in case it does not exist any longer.
            "/ This may happen when one uses history rewriting (such as histedit,
            "/ rebase or commit --amend) and forgot to recompile (or commit id change
            "/ detection fails.
            "/ If the changeset does not exist eny longer, return nil (meaning
            "/ binary revision is unavailable)
            | rev pkgDir repoDir repo |

            rev := revInfo changesetId.
            pkgDir := Smalltalk getPackageDirectoryForPackage: self package.
            pkgDir notNil ifTrue:[
                repoDir := HGRepository discover: pkgDir.
                repoDir notNil ifTrue:[
                    repo := HGRepository on: repoDir.
                    "/ Check for common case (binary revision is working copy revision
                    "/ This helps to avoid expensive log command
                    repo workingCopy changesetId = rev ifTrue:[ 
                        ^ rev
                    ] ifFalse:[ 
                        [ 
                            repo changesetWithId: rev 
                        ] on: HGUnknownRevisionError do:[ 
                            ^ nil
                        ]
                    ].
                ].        
            ]
        ].
    ].
    ^nil


    "
        stx_libbasic hgBinaryRevision
        stx_libsvn hgBinaryRevision
        stx_libscm_mercurial hgBinaryRevision

    "

    "Created: / 20-11-2012 / 23:58:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-08-2015 / 19:42:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - hg - settings'!

hgEnsureCopyrightMethod
    "If true, then #copyright method is automatically compiled in each class
     (but iff project definition defines it)

     Default is true (compile such method) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to not compile them
     to keep changes against CVS minimal"

    ^true "default"

    "Created: / 09-10-2013 / 11:48:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - hg - settings'!

hgEnsureVersion_HGMethod
    "If true, then #version_HG method is automatically compiled in each class.

     Default is true (compile such method) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to not compile them
     to keep changes against CVS minimal. 

     If false, version_HG is compiled only in classes that has been modified
     and commited.

     Note that Mercurial can live without them
     just fine"

    ^true "default"

    "Created: / 09-10-2013 / 11:50:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - hg'!

hgLogicalRevision

    "
    Answers Mercurial revision on which is this package based on logically.

    Revision is computed as follows:
        1) Look, if receiver's version_HG method has a (hidden) annotation HGRevision:, 
           if so, return its value.
        2) If receiver's binary revision is not nil, return it.
        3) Look into a package directory and if there is a Mercurial repository,
           return working copy's revision"

    | versionMethod versionAnnotation binRev pkgDir repoDir repo |

    "1 --- "

    versionMethod := self class compiledMethodAt: HGSourceCodeManager nameOfVersionMethodInClasses.
    versionMethod notNil ifTrue:[
        versionAnnotation := versionMethod annotationAt: #HGRevision:.
        versionAnnotation notNil ifTrue:[
            ^versionAnnotation revision
        ].
    ] ifFalse:[
        HGSourceCodeManager compileVersionMethod:HGSourceCodeManager nameOfVersionMethodInClasses of:self for:'$Changeset: <not expanded> $'.
        versionMethod := self class compiledMethodAt: HGSourceCodeManager nameOfVersionMethodInClasses.
    ].
    
    "2 --- "
    binRev := self hgBinaryRevision.
    binRev notNil ifTrue:[ 
        "/ Here, remember the revision in annotation to
        "/ avoid (expensive) testing done on #hgBinaryRevision
        "/ when asked a second time.
        self hgLogicalRevision: binRev.  
        ^ binRev 
    ].

    "3 --- "
    pkgDir := Smalltalk getPackageDirectoryForPackage: self package.
    pkgDir notNil ifTrue:[
        repoDir := HGRepository discover: pkgDir.
        repoDir notNil ifTrue:[
            | id |

            repo := HGRepository on: repoDir.
            id := repo workingCopy changeset id.
            versionMethod annotateWith: (HGRevisionAnnotation revision: id).
            ^id
        ]
    ].

    "4 --- "
    "/ self breakPoint: #jv.
    ^nil


    "
        stx_libbasic hgLogicalRevision
        stx_libsvn hgLogicalRevision
        stx_libscm_mercurial hgLogicalRevision

    "

    "Created: / 20-11-2012 / 23:54:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-08-2015 / 12:17:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - hg'!

hgLogicalRevision: anHGChangesetId
    "
    Set Mercurial revision on which is this package based on logically.
    To be called only from Mercurial support upon commit from image.
    "

    | versionMethod |

    versionMethod := self class compiledMethodAt: HGSourceCodeManager nameOfVersionMethodInClasses.
    versionMethod isNil ifTrue:[
        Class withoutUpdatingChangesDo: [  
            self class compile:(self class 
                                        versionMethodTemplateForSourceCodeManager:HGSourceCodeManager)
                                        classified:'documentation'.
            versionMethod := self class compiledMethodAt:HGSourceCodeManager nameOfVersionMethodInClasses.
            versionMethod setPackage:self package.
        ]
    ].
    versionMethod annotateWith: 
        (HGRevisionAnnotation revision: anHGChangesetId)

    "Created: / 20-02-2014 / 00:06:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-08-2015 / 19:44:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'description - actions - hg'!

hgPostLoad
    "possibly update an version_HG"

    <postLoad>

    | dir repo versionMethod |

    HGRepository notNil ifTrue:[
        self binaryRevisionString isNil ifTrue:[
            dir := Smalltalk getPackageDirectoryForPackage: self package.
            dir notNil ifTrue:[  
                dir := HGRepository discover: dir.
                dir notNil ifTrue:[
                    repo := HGRepository on: dir.
                    versionMethod := HGSourceCodeManager ensureVersionMethodInClass: self package: self package.
                    versionMethod annotateWith: 
                        (HGRevisionAnnotation revision: repo workingCopy changesetId)
                ].
            ]
        ].
    ].

    "Created: / 26-11-2012 / 13:06:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-02-2014 / 10:59:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - hg - settings'!

hgRemoveContainesForDeletedClasses
    "If true, then containers for removed classes are __AUTOMATICALLY__ removed from the
     repositoru. If false, obsolete containes are kept.

     Default is true (remove obsolete containers) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to return false to avoid deletions
     of obsolete files. Usefull when branching off an old CVS repo with loads of mess."

    ^true "default"

    "Created: / 21-05-2013 / 16:44:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-hg'!

commonMenuHGBrowseTemporaryWorkingCopy
    self selectedProjectsForHG value do:[:package|
        | pkg  |

        pkg := HGPackageWorkingCopy named: package.
        pkg notNil ifTrue:[
            pkg temporaryWorkingCopy browse 
        ].
    ].

    "Created: / 11-01-2013 / 18:47:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:45:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-hg'!

commonMenuHGBrowseWorkingCopy
    self selectedProjectsForHG value do:[:package|
        | pkg  |

        pkg := HGPackageWorkingCopy named: package.
        pkg notNil ifTrue:[
            pkg repository workingCopy browse 
        ].
    ].

    "Modified: / 05-03-2014 / 21:45:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-hg'!

commonMenuHGPush:repository to: remote
    self 
        showMessage: (resources string: 'Pushing to %1' with: remote url asString) 
        while: [ 
            [ 
                [ 
                    repository push: remote 
                ] on: HGPushWouldCreateNewHeadError do:[:ex1 |  
                    (Dialog confirm: (resources string: 'Push would create a new head (%1)\\Push anyway?' with: ex1 parameter) withCRs) ifTrue:[ 
                        repository push: remote force: true.
                    ].
                ].
            ] on: HGError do:[:ex2 |  
                self inlineMessageApp
                    reset;
                    beWarning;
                    message: (resources string: 'Push failed: %1' with: ex2 description);
                    addButtonOK.                    
            ]
        ]
        inBackground: true.

    "Created: / 26-03-2014 / 15:21:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus-dynamic-hg'!

commonMenuHGPushSlice
    | menu push submenu packages package remotes default |

    menu := Menu new.
    push := MenuItem new
                label: (resources string: 'Push...');
                yourself.
    menu addItem: push.

    packages := self selectedProjectsForHG value collect:[:id|HGPackageWorkingCopy named:id string].
    ((packages size ~~ 1) or:[packages anElement isNil]) ifTrue:[
        push enabled: false.
        ^menu.
    ].

    package := packages anElement.
    remotes := package repository remotes.
    remotes isEmpty ifTrue:[
        push enabled: false.
        ^menu.
    ].
"/    default := package repository remoteDefault.
"/    default notNil ifTrue:[
"/        menu addItem: (MenuItem new
"/                            label:((resources string: 'Push to ') , 'default' asText allBold);
"/                            value:[package repository push: default];
"/                            yourself).
"/    ].
    (remotes size ~~ 1 or:[remotes anElement ~~ default]) ifTrue:[
        submenu := Menu new.
        push submenu: submenu.
        remotes do:[:remote|
            submenu addItem: (MenuItem new
                            label: remote displayString;
                            value:[self commonMenuHGPush: package repository to: remote  ];
                            yourself).
        ].
    ].
    ^menu.

    "Created: / 10-12-2012 / 03:56:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2014 / 15:22:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-hg'!

projectMenuHGBrowseRevisionHistory
    self selectedProjectsForHG value do:[:package|
        | pkg  |

        pkg := HGPackageWorkingCopy named: package.
        pkg notNil ifTrue:[
            | browser |

            self withWaitCursorDo:[  
                browser := HGChangesetBrowser new.
                browser repository: pkg repository.
                browser open. 
            ]
        ].
    ].

    "Created: / 17-04-2014 / 09:41:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'aspects-navigation-hg'!

selectedProjectsForHG

    self selectedProjects value notNil
        ifTrue:[^self selectedProjects value].

    self selectedClasses value notNil
        ifTrue:[^(self selectedClasses value collect:[:cls|cls package]) asSet].

    ^nil

    "Created: / 10-12-2012 / 03:58:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser class methodsFor:'menu specs-SCM-class'!

classMenuSCMExtra_HG
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::NewSystemBrowser andSelector:#classMenuSCMExtra_HG
     (Menu new fromLiteralArrayEncoding:(Tools::NewSystemBrowser classMenuSCMExtra_HG)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Push Slice'
            submenuChannel: commonMenuHGPushSlice
            isMenuSlice: true
          )
          (MenuItem
            label: 'Browse package working copy'
            itemValue: commonMenuHGBrowseWorkingCopy
          )
         (MenuItem
            label: 'Browse temporary working copy (for commits & merges)'
            itemValue: commonMenuHGBrowseTemporaryWorkingCopy
          )
         )
        nil
        nil
      )

    "Modified: / 14-12-2012 / 18:05:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser class methodsFor:'menu specs-SCM-project'!

projectMenuSCMExtra_HG
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::NewSystemBrowser andSelector:#projectMenuSCMExtra_HG
     (Menu new fromLiteralArrayEncoding:(Tools::NewSystemBrowser projectMenuSCMExtra_HG)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Push Slice'
            submenuChannel: commonMenuHGPushSlice
            isMenuSlice: true
          )
         (MenuItem
            label: 'Browse Revision History'
            itemValue: projectMenuHGBrowseRevisionHistory
          )
         (MenuItem
            label: 'Browse Package''s Working Copy'
            itemValue: commonMenuHGBrowseWorkingCopy
          )
         (MenuItem
            label: 'Browse Temporary Working Copy (for commits & merges)'
            itemValue: commonMenuHGBrowseTemporaryWorkingCopy
          )
         )
        nil
        nil
      )

    "Modified: / 17-04-2014 / 09:41:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-mercurial'!

hgAutopush
    "Return true, if changes should be automatically pushed
     to an upstream repository (autopush),  false otherwise"

    ^self at: #hgAutopush ifAbsent:[ false "or true?" ].

    "Created: / 10-12-2012 / 01:23:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-mercurial'!

hgAutopush: aBoolean
    "Set whether changes should be automatically pushed
     to an upstream repository (autopush)"

    ^self at: #hgAutopush put: aBoolean.

    "
    UserPreferences current hgAutopush
    UserPreferences current hgAutopush: true
    UserPreferences current hgAutopush: false
    "

    "Created: / 10-12-2012 / 01:24:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-mercurial'!

hgCommand
    "Returns path svn executable"

    | cmd |

    cmd := self at:#hgCommand ifAbsent:[ nil ].
    ^cmd isEmptyOrNil ifTrue:[ nil ] ifFalse:[ cmd ]

    "Created: / 19-11-2012 / 21:39:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-mercurial'!

hgCommand: aString
    "Set the command to 'hg' executable"

    self at:#hgCommand put: aString.
    HGCommand hgCommand: nil.

    "
        UserPreferences current hgCommand
        UserPreferences current hgCommand:'hg'
        UserPreferences current hgCommand:nil
    "

    "Created: / 19-11-2012 / 21:39:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2014 / 00:10:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-mercurial'!

hgUseSharedRepositories
    "Return true, if shared repositories should be used for
     temporary commit working copies.
     Retrun false, if regular clones should be used.
     See `hg help share`"

    ^self at: #hgUseSharedRepositories ifAbsent:[ false "Experimental feature, will change" ].

    "Created: / 25-08-2015 / 01:59:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-mercurial'!

hgUseSharedRepositories: aBoolean
    "If true, shared repositories will be used for
     temporary commit working copies.
     If false, regular clones will be used instead.
     See `hg help share`"

    ^self at: #hgUseSharedRepositories put: aBoolean

    "Created: / 25-08-2015 / 01:59:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libscm_mercurial class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
