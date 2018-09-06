"{ Package: 'stx:libsvn' }"!

!AbstractFileBrowser methodsFor:'menu-queries-svn'!

canSubversionMerge
    "Return true, if file is in conflict an can be merged"

    | files |    

    files := self currentSelectedFiles.
    files size ~~ 1 ifTrue:[ ^ false ].
    self svnMergeFilesFor: files anElement do:[:base :wc :merge :output| ^ true ].
    ^false

    "Modified: / 20-03-2012 / 15:50:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-queries-svn'!

canSubversionMergeAuto
    "Return true, if file is in conflict an can be merged"

    | files |    

    files := self currentSelectedFiles copy.
    files isEmptyOrNil ifTrue:[
        files := self currentDirectory directoryContentsAsFilenames select:[:e|e isRegularFile].
    ].
    files do:[:file|
        self svnMergeFilesFor: file inDirectoryContaining: files do:[:base :wc :merge :output| ^true ].
        files remove: file ifAbsent:[nil].
    ].
    ^false

    "Created: / 21-03-2012 / 00:07:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-queries-svn'!

canSubversionMergeWithExternalDiff3

    | cmd |

    cmd := UserPreferences current svnDiff3Command.
    ^cmd notEmptyOrNil 
        and:[(OperatingSystem canExecuteCommand: cmd)
            and:[self canSubversionMerge]].

    "Modified: / 20-03-2012 / 15:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-queries-svn'!

canSubversionResolve
    "Return true, if file can be marked as resolved"

    ^false

    "Modified: / 20-03-2012 / 15:50:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 27-03-2012 / 17:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-queries-svn'!

hasSubversionWorkingCopySelected

    ^((self currentDirectory  / '.svn') exists) and:
        [(self currentDirectory  / '.svn' / 'entries') exists].

    "Created: / 24-06-2010 / 20:13:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu-queries-svn'!

hasSubversionWorkingCopySelectedAndDiff3CmdDefined

    | cmd |

    cmd := UserPreferences current svnDiff3Command.
    ^cmd notEmptyOrNil 
        and:[(OperatingSystem canExecuteCommand: cmd) 
            and:[self hasSubversionWorkingCopySelected]].

    "Modified: / 17-02-2012 / 10:18:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnAdd

    self svnExecuteCommand: 'add'

    "Modified: / 08-02-2012 / 09:28:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnCommit
    | wc task |

    wc := self svnWorkingCopy.
    task := SVN::CommitTask new workingCopy: wc.
    SVN::CommitDialog2 new
        task: task;
        open

    "Modified: / 30-03-2012 / 10:35:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnCompare

    Dialog warn: 'Not (yet) implemented'

    "Modified: / 30-03-2012 / 10:11:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnCompare: rev

    | wc wcfile revfile |
    wc := self svnWorkingCopy.
    wcfile := self currentSelectedFiles anyOne.
    revfile := wc cat: wcfile asString revision: rev.
    "/Argh...backward compatibility..."
        (Tools::TextDiff2Tool ? Tools::TextDiffTool) new
            labelA: 'Working copy';
            labelB: ('r %1' bindWith: rev printString);
            textA: wcfile contents asString; 
            textB: revfile asString;
            title:('%1: Diffbetween working copy and rev. %2 ' bindWith: wcfile asFilename baseName with: rev printString);
            open

    "Created: / 14-02-2012 / 19:13:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnCompareWithBASE

    self svnCompare: SVN::Revision base

    "Modified: / 14-02-2012 / 19:13:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnCompareWithHEAD

    self svnCompare: SVN::Revision head

    "Modified: / 14-02-2012 / 19:13:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnDebugOpenWorkingCopyBrowser
    | wcPath wc |

    wcPath := self currentDirectory asFilename.
    wcPath isDirectory ifFalse:[wcPath := wcPath directory].
    wc := SVN::WorkingCopy path: wcPath.
    (SVN::WorkingCopyBrowser on: wc) open

    "Modified: / 07-02-2012 / 22:51:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnDiff

    self svnExecuteCommand: 'diff'

    "Created: / 04-02-2012 / 19:26:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnExecuteCommand: command
    "Executes svn command on currently selected objects"

    self svnExecuteCommand: command objects: self currentSelectedObjects.

    "Created: / 04-02-2012 / 19:22:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnExecuteCommand: command objects: givenObjects
    "Executes svn command on given objects (files/dirs)"

    | objects workdir objectsAsString executionBlock |

    objects := givenObjects.

    (self isKindOf: FileBrowserV2) ifTrue:[
        workdir := self fileEntryFieldHolder value asFilename.
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

        cmd := '%1 --non-interactive %2 %3' 
                bindWith: SVN::Command executable
                    with: command
                    with: objectsAsString.
        stream nextPutAll: cmd; cr; cr.
        (self getExecutionBlockForCommand:cmd inDirectory: workdir) value:stream.
    ].
    self makeExecutionResultProcessFor:executionBlock withName:'SubVersion> svn ', command.

    "Created: / 21-03-2012 / 10:08:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnInfo
    self svnExecuteCommand: 'info'

    "Modified: / 08-02-2012 / 09:33:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnLog: limit

    self svnExecuteCommand: 'log --verbose' , (limit notNil ifTrue:[' --limit ' , limit printString] ifFalse:[''])

    "Created: / 11-04-2012 / 18:11:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnMerge
    "Return true, if file is in conflict an can be merged"

    | files |    

    files := self currentSelectedFiles.
    files size ~~ 1 ifTrue:[ ^ self ].
    self svnMergeFilesFor: files anElement do:[:base :wc :merge :output|
        output suffix = 'st' ifTrue:[
            | info |

            Tools::ChangeSetDiffInfo isNil ifTrue:[
                Dialog warn: 'ChangeSet merge tool not available, JV''s libtool required'.
                ^self.
            ].
            info := Tools::ChangeSetDiffInfo
                        specA: (Tools::ChangeSetSpec file: wc pathName)
                        specB: (Tools::ChangeSetSpec file: merge pathName)
                        specBase: (Tools::ChangeSetSpec file: base pathName)
                        specMerge: (Tools::ChangeSetSpec file: output pathName).        
            Tools::ChangeSetDiffTool new
                        open;
                        fileMenuOpenOnDiffInfo: info.
        ] ifFalse:[
            Dialog warn: 'Merging non .st files not yet supported\Use ''Merge (with external diff3)'' instead' withCRs.                        
        ]
    ]

    "Modified: / 21-03-2012 / 00:06:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnMergeAuto
    "Return true, if file is in conflict an can be merged"

    | files unmerged |    

    files := self currentSelectedFiles copy.
    files isEmptyOrNil ifTrue:[
        files := self currentDirectory directoryContentsAsFilenames select:[:e|e isRegularFile].
    ].

    unmerged := OrderedCollection new.
    self makeExecutionResultProcessFor:[:stream|
        [ files isEmpty ] whileFalse:[
            | file |    

            file := files first.
            self svnMergeFilesFor: file inDirectoryContaining: files do:[:base :wc :merge :output|
                | nm |    

                files remove: base ifAbsent:[nil].
                files remove: wc ifAbsent:[nil].
                files remove: merge ifAbsent:[nil].
                files remove: output ifAbsent:[nil].

                nm := output baseName.
                stream nextPutAll: nm; space; next: (40 - nm size) put: $.; space.

                output suffix = 'st' ifTrue:[
                    | info tool  |

                    Tools::ChangeSetDiffInfo isNil ifTrue:[
                        Dialog warn: 'ChangeSet merge tool not available, JV''s libtool required'.
                        ^self.
                    ].
                    info := Tools::ChangeSetDiffInfo
                                specA: (Tools::ChangeSetSpec file: wc pathName)
                                specB: (Tools::ChangeSetSpec file: merge pathName)
                                specBase: (Tools::ChangeSetSpec file: base pathName)
                                specMerge: (Tools::ChangeSetSpec file: output pathName).        

                    [
                        tool := Tools::ChangeSetDiffTool new.
                        tool fileMenuOpenOnDiffInfo: info.
                        Delay waitForSeconds: 2.
                        tool canSave ifTrue:[
                            tool fileMenuSave.
                            stream nextPutLine: 'MERGED (auto)'
                        ] ifFalse:[
                            unmerged add: output.
                            stream nextPutLine: 'FAILED (conflicts)'
                        ]
                    ] on: Error do:[:ex|
                        unmerged add: output.
                        stream nextPutLine: 'FAILED (ERROR: ',ex description, ')'.
                        ex pass
                    ]
                ] ifFalse:[
                    unmerged add: output.
                    stream nextPutLine: 'FAILED (no text merge not, use ''Merge (with external diff3)'' instead'
                ].
            ].
            files remove: file ifAbsent:[nil].
        ].
        stream cr;cr.
        unmerged notEmpty ifTrue:[
            stream nextPutLine:'=== SUMMARY ==='.
            stream nextPutLine:'List of __UNMERGED__ files'.
            unmerged do:[:each|
                stream  nextPutAll: '  '; 
                        nextPutAll: each baseName asString;
                        cr.
            ]

        ].
    ] withName:'SVN merge (auto)'.

    "Created: / 21-03-2012 / 00:04:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnMergeBranch

    | branch | 
    branch := Dialog request: 'Enter URL of SVN branch to merge:' initialAnswer:'^/trunk'.
    branch notEmptyOrNil ifTrue:[
        self svnExecuteCommand: 'merge ',branch objects: #()
    ].

    "Modified: / 13-04-2012 / 13:41:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnMergeFilesFor: file do: aBlock

    self 
        svnMergeFilesFor: file 
        inDirectoryContaining: file directory directoryContentsAsFilenames 
        do: aBlock

    "Created: / 20-03-2012 / 15:50:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnMergeFilesFor: file inDirectoryContaining: files do: aBlock

    | nm i base wc merge output |

    "Find out base name..."
    nm := file pathName.
    ((i := nm indexOfSubCollection: '.working') ~~ 0) ifTrue:[
        nm := nm copyTo: i - 1
    ] ifFalse:[((i := nm indexOfSubCollection: '.merge-left.') ~~ 0) ifTrue:[
        nm := nm copyTo: i - 1
    ] ifFalse:[((i := nm indexOfSubCollection: '.merge-right.') ~~ 0) ifTrue:[
        nm := nm copyTo: i - 1
    ]]].

    output := nm asFilename.
    output exists ifFalse:[ ^ self ].
    wc := (nm , '.working') asFilename.
    wc exists ifFalse:[ ^ self ].

    "Now, search for base and version to merge..."

    files do:[:each|
        (each pathName startsWith:nm , '.merge-left.') ifTrue:[
            base := each
        ].
        (each pathName startsWith:nm , '.merge-right.') ifTrue:[
            merge := each
        ].
    ].
    (base isNil or:[merge isNil]) ifTrue:[ ^ self ].

    aBlock value: base value:wc value:merge value:output.

    "Created: / 21-03-2012 / 10:19:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnMergeWithExternalDiff3
    | files |    

    files := self currentSelectedFiles.
    files size ~~ 1 ifTrue:[ ^ self ].
    self svnMergeFilesFor: files anElement do:[:base :wc :merge :output|
        OperatingSystem executeCommand:
            ('%1 %2 %3 %4 -o %5'
                bindWith: UserPreferences current svnDiff3Command
                    with: base pathName
                    with: wc pathName
                    with: merge pathName
                    with: output pathName)
    ]

    "Modified: / 20-03-2012 / 23:21:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnRemove

    self svnExecuteCommand: 'remove'

    "Created: / 08-02-2012 / 09:28:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnRevert

    self svnExecuteCommand: 'revert'

    "Modified: / 21-03-2012 / 01:53:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnStatus

    self svnExecuteCommand: 'status'

    "Modified: / 04-02-2012 / 19:22:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnStatusShowUpdates

    self svnExecuteCommand: 'status --show-updates --verbose'

    "Modified: / 04-02-2012 / 19:22:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 07-02-2012 / 19:25:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnUpdate

    self svnExecuteCommand:'update'

    "Modified: / 08-02-2012 / 09:29:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnUpdateWithExternalDiff3
    | cmd |

    cmd := UserPreferences current svnDiff3Command.
    self svnExecuteCommand:
        (' --diff3-cmd="%1" update' bindWith: cmd).

    "Modified: / 24-07-2012 / 16:28:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-svn'!

svnWorkingCopy
    | wcPath |

    wcPath := self currentDirectory asFilename.
    wcPath isDirectory ifFalse:[wcPath := wcPath directory].
    ^ SVN::WorkingCopy path: wcPath.

    "Modified: / 08-02-2012 / 18:24:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 30-03-2012 / 10:35:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser class methodsFor:'menu specs-scm'!

svnMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#svnMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser svnMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Commit'
            itemValue: svnCommit
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' commit 'Commit')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Update'
            itemValue: svnUpdate
            translateLabel: true
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelectedAndDiff3CmdDefined
            label: 'Update (external diff3) '
            itemValue: svnUpdateWithExternalDiff3
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Add'
            itemValue: svnAdd
            translateLabel: true
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Remove'
            itemValue: svnRemove
            translateLabel: true
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Revert'
            itemValue: svnRevert
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Status'
            itemValue: svnStatus
            translateLabel: true
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Status (show updates)'
            itemValue: svnStatusShowUpdates
            translateLabel: true
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Info'
            itemValue: svnInfo
            translateLabel: true
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Log (last 10 revisions)'
            itemValue: svnLog:
            translateLabel: true
            argument: 10
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Log (all revisions)'
            itemValue: svnLog:
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canSubversionMerge
            label: 'Merge...'
            itemValue: svnMerge
            translateLabel: true
          )
         (MenuItem
            enabled: canSubversionMergeAuto
            label: 'Merge (auto)'
            itemValue: svnMergeAuto
            translateLabel: true
          )
         (MenuItem
            enabled: canSubversionMergeWithExternalDiff3
            label: 'Merge (external diff3)'
            itemValue: svnMergeWithExternalDiff3
            translateLabel: true
          )
         (MenuItem
            enabled: canSubversionResolve
            label: 'Resolve'
            itemValue: svnResolve
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Merge Branch...'
            itemValue: svnMergeBranch
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Compare'
            itemValue: svnCompareWithBASE
            translateLabel: true
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Compare with HEAD'
            itemValue: svnCompareWithHEAD
            translateLabel: true
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Compare with Revision...'
            itemValue: svnCompare
            translateLabel: true
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Diff (svn diff ...)'
            itemValue: svnDiff
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSubversionWorkingCopySelected
            label: 'Debug'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasSubversionWorkingCopySelected
                  label: 'Open Working Copy Browser'
                  itemValue: svnDebugOpenWorkingCopyBrowser
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
! !

!ChangeSet methodsFor:'utilities'!

condenseChangesForPackage2:aPackageSymbol
    "remove more changes for aPackageSymbol
     This is invoked when a project is checked into the repository."

    |changesToRemove|

    changesToRemove := self select:[:aChange |
	|removeThis mClass mthd|

	removeThis := false.
	(aChange isMethodChange or:[aChange isMethodRemoveChange]) ifTrue:[
	    mClass := aChange changeClass.
	    mClass notNil ifTrue:[
		mthd := mClass compiledMethodAt:(aChange selector).
		mthd isNil ifTrue:[
		    removeThis := (mClass package = aPackageSymbol)
		] ifFalse:[
		    removeThis := (mthd package = aPackageSymbol)
		]
	    ].
	] ifFalse:[
	    (aChange isClassChange) ifTrue:[
		(aChange changeClass notNil) ifTrue:[
		    removeThis := (aChange changeClass package = aPackageSymbol)
		].
	    ].
	].
	removeThis
    ].

    self condenseChanges:changesToRemove

    "Modified: / 12-10-2006 / 16:51:27 / cg"
    "Created: / 09-08-2009 / 14:29:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Class methodsFor:'fileOut'!

fileOutAsMethodIn: class selector: selector

    ^self fileOutAsMethodIn: class selector: selector category: 'sources'

    "Created: / 08-04-2009 / 20:58:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Class methodsFor:'accessing'!

svnBranch

    ^self svnRepository branch

    "Created: / 19-04-2008 / 18:24:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Class methodsFor:'accessing'!

svnRepository

    ^SVN::RepositoryManager repositoryForPackage: self package

    "Created: / 19-04-2008 / 18:24:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Date methodsFor:'converting'!

asSVNRevisionSpec

    ^SVNv2::RevisionSpec date: self

    "Created: / 03-02-2011 / 00:01:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Filename methodsFor:'reading-directories'!

directoryContentsAsFilenamesMatching: patternOrCollectionOfThose

    "
	Same as directoryContentsAsFilenames, but returns only files
	that matches given patterns. This uses String>>matches:
	for pattern matching
    "

    |names|

    names := self directoryContentsMatching: patternOrCollectionOfThose .
    names isNil ifTrue:[^ nil].
    ^ names asOrderedCollection collect:[:entry | self construct:entry].

    "
    '/etc' asFilename
	directoryContentsAsFilenamesMatching: 'pass*'

    '/etc' asFilename
	    directoryContentsAsFilenamesMatching: #('pass*' 'nsswitch.conf')
    "

    "Created: / 03-06-2009 / 09:57:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Filename methodsFor:'reading-directories'!

directoryContentsMatching: patternOrCollectionOfThose

    "
	Same as directoryContants, but returns only files
	that matches given patterns. This uses String>>matches:
	for pattern matching
    "

    | names patterns |
    patterns := patternOrCollectionOfThose isString
		    ifTrue: [Array with: patternOrCollectionOfThose]
		    ifFalse:[patternOrCollectionOfThose].
    names := self directoryContents.
    names ifNil:[^nil].
    ^names select:
	[:e|patterns anySatisfy:[:pattern|e matches: pattern]]

    "
     '/etc' asFilename
	directoryContentsMatching: 'pass*'

    '/etc' asFilename
	directoryContentsMatching: #('pass*' 'nsswitch.conf')

    '/etc' asFilename
	directoryContentsMatching: #('does-not-exists.txt')

    "

    "Created: / 03-06-2009 / 09:52:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FilenameWidgetWithHistory methodsFor:'accessing'!

historyList:aList
    "set the history - useful when two or more such fields shall share a common history"

    history := aList.
    fileNameEntryField listHolder: aList.

    "Modified: / 27-11-2009 / 13:05:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FilenameWidgetWithHistory methodsFor:'accessing-channels'!

modifiedChannel:aValueHolder
    fileNameEntryField modifiedChannel:aValueHolder.

    "Created: / 27-11-2009 / 12:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Integer methodsFor:'converting'!

asSVNRevisionSpec

    ^SVNv2::RevisionSpec number: self

    "Created: / 03-02-2011 / 00:01:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'accessing'!

makeSourceFileAbsolute

    "
        Makes a source file reference absolute.
        This is required by SVN, because svn working copy
        is in package path, so it's existence may corrupt source
        files.
    "

    | fileStream |

    "check whether my source is in external file. If not, this is noop"
    sourcePosition ifNil:[^nil].
    "already absolute"
    source asFilename isAbsolute ifTrue:[^self].
    fileStream := self rawSourceStreamUsingCache: false.
    fileStream isFileStream ifTrue:
        [source := fileStream fileName asAbsoluteFilename pathName].

    "
        (Method compiledMethodAt:#mclass:)
            makeSourceFileAbsolute
    "

    "Created: / 21-08-2009 / 17:24:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-02-2010 / 22:21:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodChange methodsFor:'converting'!

asAntiChange

    ^self isMethodCodeChange
	ifTrue:[MethodRemoveChange className: self className selector: self selector]
	ifFalse:[super asAntiChange]

    "Created: / 02-11-2009 / 11:13:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodChange methodsFor:'queries'!

isForGeneratedSubject
    "
    Answers true iff subject of this method is somewhat
    auto-generated by some tool - just like version methods
    are.
    "

    ^self isForMeta
	and:[((self selector) == #version)
	  or:[self selector startsWith:'version_' ]
	]

    "Created: / 17-08-2009 / 18:56:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'code generation'!

forEachContentsMethodsCodeToCompileDo:aTwoArgBlock ignoreOldEntries: ignoreOldEntries ignoreOldDefinition:ignoreOldDefinition
    aTwoArgBlock 
        value:(self classNamesAndAttributes_code_ignoreOldEntries:ignoreOldEntries ignoreOldDefinition:ignoreOldDefinition)
        value:'description - contents'.

    aTwoArgBlock 
        value: (self extensionMethodNames_code_ignoreOldEntries:ignoreOldEntries)
        value: 'description - contents'.

    aTwoArgBlock 
        value: self mandatoryPreRequisites_code
        value: 'description'.

    aTwoArgBlock 
        value: self referencedPreRequisites_code
        value: 'description'.

    aTwoArgBlock 
        value: self excludedFromPreRequisites_code
        value: 'description'.

    "Created: / 09-07-2010 / 14:12:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-03-2013 / 22:01:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - svn'!

svnRepositoryUrl

    | url |

    (self respondsTo:#svnRepositoryUrlString) ifFalse:[^nil].
    url := self svnRepositoryUrlString.
    (url startsWith: '$' , 'URL: ')
        ifTrue:[url := url copyFrom: 7 to: (url lastIndexOf: $/) - 1]
        ifFalse:[nil].
    ^url


    "
        stx_libjava svnRepositoryUrl    
    "

    "Created: / 08-04-2011 / 16:20:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'code generation'!

svnRepositoryUrlString_code

    ^'svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
     Do not make the string shorter!!!!!! We have to use fixed-length keyword!!!!!!
    "        

    ^ ''$','URL::', (String new: 120),'$'''

    "
     self svnRepositoryUrlString_code
     stx_libbasic3 svnRepositoryUrlString_code
    "

    "Created: / 08-04-2011 / 16:01:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - svn'!

svnRevision

    "
        Answers SVN revision of given package. The revision is computed
        as follows:
        1) Look at package directory if there is .svn administration
           directory. If so, uses SVN to obtain SVN revision & return
        2) If svnRevisionNr return non-nil, use that as SVN revision & return
        3) If everything fails, compute maximum from all revision of all
           classes & extensions
    "
    | pkgDir revNr |

    "1)"
    pkgDir := self packageDirectory.
    (pkgDir notNil and: [pkgDir exists and: [(pkgDir / '.svn') exists]]) ifTrue:
        [[revNr := (SVN::InfoCommand new
                    workingCopy: (SVN::WorkingCopy branch: (SVN::Branch new) path: pkgDir);
                    execute) anyOne revision]
                        value
                        "/on: Error do: [revNr := nil]
                        ].
    revNr ifNotNil:[^SVN::Revision number:revNr].
    "2)"
    "We have to explicitly check for existence of svnRevisionNr,
     because we don't want to invoke inherited method"
    (self class methodDictionary includesKey: #svnRevisionNr)
        ifTrue:[revNr := self perform:#svnRevisionNr].
    revNr ifNotNil:[
        (revNr startsWith: 'nil') ifTrue:[ ^ SVN::Revision head].      
        ^SVN::Revision number:(revNr asString select:[:e|e isDigit])
    ].

    "3)"
    revNr := (self searchForClassesWithProject: self package)
                inject: 0
                into:
                    [:rev :cls|
                    ((cls revision ? '.') includes: $.)"/ CVS revision number?
                        ifTrue:[rev]
                        ifFalse:[rev max: (cls revision ? '0') asNumber]].
    ^revNr ~= 0
        ifTrue: [SVN::Revision number:revNr]
        ifFalse:[SVN::Revision head]

    "
        stx_libbasic svnRevision
        stx_goodies_libsvn svnRevision
        stx_goodies_libsvn revision

    "

    "Created: / 15-06-2009 / 11:54:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-08-2009 / 09:06:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-07-2012 / 18:08:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!String methodsFor:'converting'!

asSVNRevisionSpec

    | number date |

    self = 'HEAD' ifTrue:[^SVNv2::RevisionSpec head].
    self = 'head' ifTrue:[^SVNv2::RevisionSpec head].

    number := Integer fromString: self onError:[nil].  
    number ifNotNil:[^SVNv2::RevisionSpec number: number].

    date := Date readFrom: self onError:[nil].  
    date ifNotNil:[^SVNv2::RevisionSpec date: date].

    self error: 'Not a SVN revision spec'.

    "
        'HEAD' asSVNRevisionSpec  
        '123' asSVNRevisionSpec 
        '2010-12-12' asSVNRevisionSpec 
        'bla bla' asSVNRevisionSpec
        123 asSVNRevisionSpec  
    "

    "Created: / 03-02-2011 / 00:06:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-class'!

classMenuDiffsetFor:classes againstBranch:branch revision:revision
    |diffset|
    diffset := (ChangeSetDiffSet new)
                name:'Differences between image and ', branch name asString , '@' , revision printString;
                versionALabel: 'Current (image)';
                versionBLabel: revision printString.
    classes do:
            [:cls |
            diffset add:(branch diffSetForClass:cls betweenImageAndRevision:revision)].
    ^diffset

    "Created: / 19-04-2008 / 18:56:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-09-2011 / 12:28:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-class'!

classMenuSubversionBrowseWorkingCopy
    "automatically generated by UIEditor ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."
    "*** (and replace this comment by something more useful ;-)"

    "action to be added ..."

    Transcript showCR:self class name, ': action for #classMenuSubversionBrowseWorkingCopy ...'.
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-class'!

classMenuSubversionChangeset
    |classes|
    classes := self selectedNonMetaclasses.
    (SVN::BranchAndRevisionSelectionDialog new)
        title:'Changeset for ' , (self infoStringForClasses:classes withPrefix:'');
        repository:classes anyOne svnRepository;
        branch:classes anyOne svnRepository trunk;
        onAccept:
                [:dlg |
                dlg showProgressWhile:
                        [self
                            classMenuSubversionChangeset:classes
                            againstBranch:dlg branch
                            revision:dlg revision]];
        open
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-class'!

classMenuSubversionChangeset: classes againstBranch: branch revision: rev

    | diffset changeset |
    diffset := self classMenuDiffsetFor:classes againstBranch:branch revision: rev.
    changeset := diffset changesetA.

    (Smalltalk at:#'Tools::ChangeSetBrowser')
        ifNil:[ChangeSetBrowser openOn: changeset]
        ifNotNil:[(Tools::ChangeSetBrowser on: changeset) open]
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-class'!

classMenuSubversionCommit

    | classesPerPackage |
    classesPerPackage := Dictionary new.
    self selectedClasses value do:
        [:class|
        (classesPerPackage at: class theNonMetaclass package ifAbsentPut:[Set new])
            add: class theNonMetaclass].
    classesPerPackage keysAndValuesDo:
        [:package :classes| | repo |
        repo := SVN::RepositoryManager repositoryForPackage:package.
        "/SVN::CommitWizard new
        SVN::CommitDialog2 new
                task: (repo workingCopy commitTask
                        classes: classes;
                        extensionMethods: #()
                        yourself);
                open]

    "Modified: / 16-06-2009 / 21:05:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 10:32:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-class'!

classMenuSubversionCompare
    |classes|
    classes := self selectedNonMetaclasses.
    (SVN::BranchAndRevisionSelectionDialog new)
	title:'Compare ' , (self infoStringForClasses:classes withPrefix:'');
	repository:classes anyOne svnRepository;
	branch:classes anyOne svnRepository trunk;
	onAccept:
		[:dlg |
		dlg showProgressWhile:
			[self
			    classMenuSubversionCompare:classes
			    withBranch:dlg branch
			    revision:dlg revision]];
	open

    "Modified: / 01-11-2009 / 15:50:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-class'!

classMenuSubversionCompare:classes withBranch:branch revision:revision
    |diffset|
    diffset := self classMenuDiffsetFor:classes againstBranch:branch revision:revision.
    diffset isEmpty ifTrue:
        [^Dialog inform: 'No differences found'].
    (Tools::ChangeSetDiffTool new)
        beTwoColumn:(classes size > 1);
        diffset:diffset;
        open

    "Created: / 19-04-2008 / 18:56:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-12-2009 / 11:14:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 23:08:33 / jv"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-class'!

classMenuSubversionCompare:classes withRevision:revision
    self
	classMenuSubversionCompare:classes
	withBranch:classes anyOne svnBranch
	revision:revision

    "Created: / 19-04-2008 / 18:56:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-class'!

classMenuSubversionCompareWithRevisionHead

    | classes |
    classes := self selectedNonMetaclasses.

    SVN::ProgressDialog
	openOn:[
	    self
		classMenuSubversionCompare:classes
		withRevision:SVN::Revision head
	]
	title:'Compare ',(self infoStringForClasses:classes withPrefix:''),' with rev. HEAD'

    "Created: / 19-04-2008 / 18:56:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 01-11-2009 / 15:51:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-class'!

classMenuSubversionUpdate

    self classMenuSubversionLoadRevision: SVN::Revision head

    "Modified: / 10-12-2009 / 13:37:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus-dynamic-subversion'!

classSubversionChangesetMenu

    <resource: #programMenu >

    |menu repo branches|

    menu := Menu decodeFromLiteralArray: self class classSubversionChangesetMenu.
    repo := SVN::RepositoryManager repositoryForPackage:self theSingleSelectedProjectFromClasses.
    branches := repo branches.
    branches size = 1 ifTrue:[
        menu removeItemAt:2.
        ^ menu.
    ].


    branches do:[:branch |
        menu addItem:
            (MenuItem new
                label: (LabelAndIcon
                            label: ('Changeset against ', branch name)
                            icon: (branch icon));
                value: [self classMenuSubversionChangeset: self selectedClasses value againstBranch: branch revision: SVN::Revision head];
                enabled: (repo branch = branch) not)
    ].
    ^menu

    "Created: / 25-11-2009 / 14:10:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2009 / 16:48:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion'!

commonMenuSubversionBrowseWorkingCopy

    self selectedProjectsForSubversion value do:
        [:package|
        | repo wc |
        repo := self svnRepositoryManager repositoryForPackage: package.
        wc := repo workingCopy.
        wc exists ifFalse:[
            wc checkout.
        ].
        FileBrowserV2 openOn: wc path]

    "Modified: / 09-12-2010 / 23:45:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion'!

commonMenuSubversionFlushCaches

    self svnRepositoryManager reset
! !

!Tools::NewSystemBrowser methodsFor:'aspects-queries-subversion'!

hasClassesSelectedAndSubversionRepositoryExistsAndBranchSelectedHolder
    ^ [
	| classes |
	classes := self selectedClasses value.
	classes isEmptyOrNil
	    ifTrue:
		[false]
	    ifFalse:
		[classes
		allSatisfy:
		    [:cls | self hasSubversionRepositoryAndBranchFor: cls theNonMetaclass package]
	]
    ]
! !

!Tools::NewSystemBrowser methodsFor:'aspects-queries-subversion'!

hasProjectSelectedSubversionRepositoryExistsAndBranchSelectedHolder
    ^ [ self hasProjectSelected
	    and:[self selectedProjects value size = 1
		and:[self hasSubversionRepositoryAndBranchFor: self selectedProjects value anyOne]]]

    "Created: / 31-03-2008 / 15:07:52 / janfrog"
! !

!Tools::NewSystemBrowser methodsFor:'aspects-queries-subversion'!

hasSingleClassAndSubversionRepositoryExists
    ^ self hasSingleClassSelected
	and:[self hasSubversionRepositoryFor: self theSingleSelectedClass package]

    "Created: / 19-04-2008 / 17:40:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'aspects-queries-subversion'!

hasSubversionRepositoryAndBranchFor: package

    | repo |

    ^ self hasSubversionSupport
    and:[(repo := self svnRepositoryManager repositoryForPackage: package) notNil
    and:[repo workingCopy hasBranch]]

    "Created: / 31-03-2008 / 15:08:13 / janfrog"
    "Modified: / 22-08-2009 / 10:49:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionChangeset
    |repo|
    repo := SVN::RepositoryManager
                repositoryForPackage:self theSingleSelectedProject.
    (SVN::BranchAndRevisionSelectionDialog new)
        title:'Changeset ' , self theSingleSelectedProject asText allItalic;
        repository:repo;
        branch:repo trunk;
        onAccept:
                [:dlg |
                dlg showProgressWhile:
                        [self projectMenuSubversionChangesetAgainstBranch:dlg branch
                            revision:dlg revision]];
        open

    "Created: / 20-05-2008 / 18:09:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-11-2009 / 16:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionChangesetAgainstBranch:branch revision:revision
    |changeset diffset|
    diffset := branch diffSetBetweenImageAndRevision:revision.
    changeset := diffset changesetA.
    (Smalltalk at:#'Tools::ChangeSetBrowser')
        ifNil:[ChangeSetBrowser openOn: changeset]
        ifNotNil:[(Tools::ChangeSetBrowser on: changeset) open]

    "Modified: / 09-08-2009 / 14:14:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 02-11-2009 / 13:41:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2009 / 11:14:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionCommit

    self selectedProjects value do:
        [:package|
        | repo |
        repo := SVN::RepositoryManager repositoryForPackage:package.
        "/SVN::CommitWizard new
        SVN::CommitDialog2 new
            task: repo workingCopy commitTask;
            open]

    "Created: / 01-04-2008 / 19:02:42 / janfrog"
    "Modified: / 16-08-2009 / 19:17:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 10:32:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionCommitMode

    ^(PluggableAdaptor on: self theSingleSelectedProject)
	getBlock:
	    [:prjHolder| | wc |
	    wc := SVN::RepositoryManager workingCopyForPackage: self theSingleSelectedProject value.
	    wc ifNotNil:[wc commitMode] ifNil:[nil]]
	putBlock:
	    [:prjHolder :value| | wc |
	    wc := SVN::RepositoryManager workingCopyForPackage: self theSingleSelectedProject value.
	    wc ifNotNil:[wc commitMode:value]]
	updateBlock:
	    [:prjHolder :aspect :value|true].

    "Created: / 13-08-2009 / 15:05:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionCompare
    |repo|
    repo := SVN::RepositoryManager
		repositoryForPackage:self theSingleSelectedProject.
    (SVN::BranchAndRevisionSelectionDialog new)
	title:'Compare ' , self theSingleSelectedProject asText allItalic;
	repository:repo;
	branch:repo trunk;
	onAccept:
		[:dlg |
		dlg showProgressWhile:
			[self projectMenuSubversionCompareWithBranch:dlg branch
			    revision:dlg revision]];
	open

    "Created: / 20-05-2008 / 18:09:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-11-2009 / 16:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionCompareWithBranch:branch revision:revision
    |diffset|
    diffset := branch diffSetBetweenImageAndRevision:revision.
    (Tools::ChangeSetDiffTool new)
        diffset:diffset;
        title:'Differences between image and rev. ' , revision printString;
        open

    "Modified: / 09-08-2009 / 14:14:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 02-11-2009 / 13:41:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2009 / 11:14:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 23:08:37 / jv"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionCompareWithRevisionHead
    |branch|
    branch := (SVN::RepositoryManager
		repositoryForPackage:self theSingleSelectedProject value) branch.
    SVN::ProgressDialog openOn:
	    [self projectMenuSubversionCompareWithBranch:branch
		revision:SVN::Revision head]
	title:'Comparing ' , self theSingleSelectedProject value asText allItalic.

    "Created: / 20-05-2008 / 18:10:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-11-2009 / 13:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionLoadRevision

    ^self projectMenuSubversionLoadRevision: nil

    "Created: / 22-10-2008 / 11:49:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 09:38:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionLoadRevision:aRevision
    self selectedProjects value do:[:package |
	|pkg task|

	pkg := self theSingleSelectedProject.
	task := (SVN::RepositoryManager repositoryForPackage:pkg) updateTask.
	task revision:aRevision.
	SVN::UpdateLikeWizard openOn:task
    ]

    "Created: / 09-04-2009 / 09:38:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-11-2009 / 13:53:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionMergeWith:branch revision:revision
    |package|

    package := self theSingleSelectedProject.
    (SVN::UpdateLikeWizard new)
	task:branch repository workingCopy mergeTask;
	branch:branch;
	revision:revision;
	open

    "Created: / 25-11-2009 / 16:48:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2009 / 20:10:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionRemoveWorkingCopy

    self selectedProjects value do:
	[:package|
	| pkg repo |
	pkg := self theSingleSelectedProject.
	repo := (SVN::RepositoryManager repositoryForPackage: pkg) .
	repo workingCopy path asFilename recursiveRemove]

    "Created: / 09-04-2009 / 13:19:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionShowRevisionLog

    | pkg branch |
    pkg := self theSingleSelectedProjectForSubversion.
    branch := (self svnRepositoryFor: pkg) branch.
    SVN::RevisionLogBrowser new
	branch: branch;
	open

    "Created: / 21-05-2008 / 09:37:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-10-2008 / 19:52:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-subversion-project'!

projectMenuSubversionUpdate

    ^self projectMenuSubversionLoadRevision: SVN::Revision head

    "Created: / 22-10-2008 / 11:49:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 09:38:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus-dynamic-subversion'!

projectSubversionChangesetMenu

    <resource: #programMenu >

    |menu repo branches|

    menu := Menu decodeFromLiteralArray: self class projectSubversionChangesetMenu.
    repo := SVN::RepositoryManager repositoryForPackage:self theSingleSelectedProject.
    branches := repo branches.
    branches size = 1 ifTrue:[
        menu removeItemAt:2.
        ^ menu.
    ].


    branches do:[:branch |
        menu addItem:
            (MenuItem new
                label: (LabelAndIcon
                            label: ('Changeset against ', branch name)
                            icon: (branch icon));
                value: [self projectMenuSubversionChangesetAgainstBranch: branch revision: SVN::Revision head];
                enabled: (repo branch = branch) not)
    ].
    ^menu

    "Created: / 25-11-2009 / 14:10:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2009 / 16:48:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus-dynamic-subversion'!

projectSubversionMergeMenu

    <resource: #programMenu >

    |menu repo branches|

    menu := Menu decodeFromLiteralArray: self class projectSubversionMergeMenu.
    repo := SVN::RepositoryManager
		repositoryForPackage:self theSingleSelectedProject.
    branches := repo branches.
    branches size = 1 ifTrue:[
	menu removeItemAt:2.
	^ menu.
    ].
    branches do:[:branch |
	menu addItem:
	    (MenuItem new
		label: (LabelAndIcon
			    label: ('Merge with ', branch name)
			    icon: (branch icon));
		value: [self projectMenuSubversionMergeWith: branch revision: SVN::Revision head];
		enabled: (repo branch = branch) not)
    ].
    ^menu

    "Created: / 25-11-2009 / 14:10:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2009 / 16:48:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'private-helpers-subversion'!

selectedProjectSubversionRepository

    | project |
    project := self theSingleSelectedProjectForSubversion.
    ^project
	ifNil:[nil]
	ifNotNil:[self svnRepositoryManager repositoryForPackage:project]

    "Created: / 19-04-2008 / 11:09:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'aspects-navigation-subversion'!

selectedProjectsForSubversion

    self selectedProjects value
	ifNotNil:[^self selectedProjects value].

    self selectedClasses value
	ifNotNil:[^(self selectedClasses value collect:[:cls|cls package]) asSet].

    ^nil
! !

!Tools::NewSystemBrowser methodsFor:'private-helpers-subversion'!

selectedProjectsFromClasses


    ^(self selectedClasses value collect:[:cls|cls package] thenSelect:[:pkg|pkg notNil]) asSet



    "Created: / 24.2.2000 / 21:51:33 / cg"
! !

!Tools::NewSystemBrowser methodsFor:'private-helpers-subversion'!

svnRepositoryFor: packageId

    ^self svnRepositoryManager repositoryForPackage: packageId
! !

!Tools::NewSystemBrowser methodsFor:'private-helpers-subversion'!

svnRepositoryManager

    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^(Smalltalk at:#'SVN::RepositoryManager')
! !

!Tools::NewSystemBrowser methodsFor:'private-helpers-subversion'!

theSingleSelectedProjectForSubversion

    | projects |
    projects := self selectedProjectsForSubversion.
    ^projects size == 1
	ifTrue:[projects anyOne]
	ifFalse:[nil]

    "Created: / 24.2.2000 / 21:51:33 / cg"
! !

!Tools::NewSystemBrowser methodsFor:'private-helpers-subversion'!

theSingleSelectedProjectFromClasses

    | projects |
    ^(projects := self selectedProjectsFromClasses) size = 1
        ifTrue:[projects anyOne]
        ifFalse:[nil]
! !

!Tools::NewSystemBrowser class methodsFor:'menu specs-subversion'!

classMenuSubversion

    <resource: #obsolete>
    self obsoleteMethodWarning: 'use #classSubversionMenu'.

    ^self classSubversionMenu
! !

!Tools::NewSystemBrowser class methodsFor:'menu specs-subversion'!

classSubversionChangesetMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::NewSystemBrowser andSelector:#classSubversionChangesetMenu
     (Menu new fromLiteralArrayEncoding:(Tools::NewSystemBrowser classSubversionChangesetMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Changeset against...'
            itemValue: classMenuSubversionChangeset
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         )
        nil
        nil
      )
! !

!Tools::NewSystemBrowser class methodsFor:'menu specs-subversion'!

classSubversionCompareMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::NewSystemBrowser andSelector:#classSubversionCompareMenu
     (Menu new fromLiteralArrayEncoding:(Tools::NewSystemBrowser classSubversionCompareMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: hasClassesSelectedAndSubversionRepositoryExistsAndBranchSelectedHolder
	    label: 'Compare...'
	    itemValue: classMenuSubversionCompare
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: hasClassesSelectedAndSubversionRepositoryExistsAndBranchSelectedHolder
	    label: 'Compare with HEAD'
	    itemValue: classMenuSubversionCompareWithRevisionHead
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
! !

!Tools::NewSystemBrowser class methodsFor:'menu specs-subversion'!

projectMenuSubversion

    <resource: #obsolete>
    self obsoleteMethodWarning: 'use #projectSubversionMenu'.

    ^self projectSubversionMenu

    "Modified: / 04-12-2009 / 21:53:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser class methodsFor:'menu specs-subversion'!

projectSubversionChangesetMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::NewSystemBrowser andSelector:#projectSubversionChangesetMenu
     (Menu new fromLiteralArrayEncoding:(Tools::NewSystemBrowser projectSubversionChangesetMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Changeset against...'
            itemValue: projectMenuSubversionChangeset
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         )
        nil
        nil
      )
! !

!Tools::NewSystemBrowser class methodsFor:'menu specs-subversion'!

projectSubversionCompareMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::NewSystemBrowser andSelector:#projectSubversionCompareMenu
     (Menu new fromLiteralArrayEncoding:(Tools::NewSystemBrowser projectSubversionCompareMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: hasProjectSelectedSubversionRepositoryExistsAndBranchSelectedHolder
	    label: 'Compare...'
	    itemValue: projectMenuSubversionCompare
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: hasProjectSelectedSubversionRepositoryExistsAndBranchSelectedHolder
	    label: 'Compare with HEAD'
	    itemValue: projectMenuSubversionCompareWithRevisionHead
	    translateLabel: true
	    auxValue: 'ni'
	  )
	 )
	nil
	nil
      )
! !

!Tools::NewSystemBrowser class methodsFor:'menu specs-subversion'!

projectSubversionMergeMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::NewSystemBrowser andSelector:#projectSubversionMergeMenu
     (Menu new fromLiteralArrayEncoding:(Tools::NewSystemBrowser projectSubversionMergeMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: false
	    label: 'Merge'
	    itemValue: projectSubversionMergeMenu
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 )
	nil
	nil
      )
! !

!UserNotification class methodsFor:'instance creation'!

notify: message progress: progress

    ^ProgressNotification new
	messageText: message;
	parameter: progress;
	raiseRequest
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnCommand
    "Returns path svn executable"

    ^self at:#svnCommand ifAbsent:[ nil ]

    "Created: / 03-10-2008 / 11:14:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:08:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 12-03-2012 / 11:22:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnCommand: aString
    "Set the command to svn executable"

    ^self at:#svnCommand put: aString

    "
        UserPreferences current svnCommand
        UserPreferences current svnCommand:'svn'
        UserPreferences current svnCommand:nil
    "

    "Created: / 12-03-2012 / 11:22:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnConfigurations2
    "subversion source control configurations"

    ^(self at:#'libsvn.Configuration.configurations' ifAbsent:
        [Array with:(SVN::Configuration named: SVN::Configuration defaultName)])
        collect:[:cfg|cfg decodeAsLiteralArray]

    "Modified: / 19-08-2009 / 12:08:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 09-01-2010 / 15:34:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2010 / 18:56:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnConfigurations2: aCollection
    "subversion source control configurations"

    

    (Smalltalk at: #'SVN::Configuration') ifNotNil:
        [(Smalltalk at: #'SVN::Configuration') flushCaches; setConfigurations: aCollection].

    self
        at: #'libsvn.Configuration.configurations'
        put: (aCollection asArray collect:[:cfg|cfg literalArrayEncoding]).

    "
     UserPreferences current svnConfigurations2: #()
    "

    "Modified: / 19-08-2009 / 12:09:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 09-01-2010 / 15:41:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-03-2010 / 13:26:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnCurrentConfiguration

    | name confs conf |
    name := self at: #'libsvn.Configuration.current' 
                 ifAbsent:[SVN::Configuration defaultName].
    confs := SVN::Configuration configurations. 
    conf := confs detect: [:c|c name = name] ifNone: [nil].
    conf ifNil:
        [confs size == 1 
            ifTrue:
                [conf := confs anyOne]
            ifFalse:
                [conf := SVN::Configuration named: SVN::Configuration defaultName.
                confs := confs copyWith: conf.
                self svnConfigurations2: confs]].
    ^conf

    "
        UserPreferences current svnCurrentConfiguration
    "

    "Modified: / 19-08-2009 / 12:09:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 11-02-2010 / 18:54:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-03-2011 / 14:18:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnCurrentConfiguration: aConfiguration
    "subversion source control configurations"	

    | cName |
    cName := aConfiguration isString
                ifTrue:[aConfiguration]
                ifFalse:[aConfiguration name].

	aConfiguration isString ifFalse:[

    (Smalltalk at: #'SVN::Configuration') ifNotNil:
        [(Smalltalk at: #'SVN::Configuration') setCurrent: aConfiguration].
    ].
    self
        at: #'libsvn.Configuration.current'
        put: cName.


    "Modified: / 19-08-2009 / 12:09:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 09-01-2010 / 15:41:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-03-2011 / 14:25:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnDiff2Command
    "Return external diff2 command passed to svn client"

    ^self at:#svnDiff2Command ifAbsent:[nil]

    "Created: / 03-10-2008 / 11:14:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:08:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 17-02-2012 / 01:29:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnDiff2Command: aString
    "Return external diff2 command passed to svn client"

    ^self at:#svnDiff2Command put: aString

    "
        UserPreferences current svnDiff2Command
        UserPreferences current svnDiff2Command:'kdiff3'
        UserPreferences current svnDiff2Command:nil
    "

    "Created: / 03-10-2008 / 11:14:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:08:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 17-02-2012 / 01:30:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnDiff3Command
    "Return external diff3 command passed to svn client"

    ^self at:#svnDiff3Command ifAbsent:[nil]

    "Created: / 03-10-2008 / 11:14:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:08:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 17-02-2012 / 01:31:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnDiff3Command: aString
    "Return external diff2 command passed to svn client"

    ^self at:#svnDiff3Command put: aString

    "
        UserPreferences current svnDiff3Command
        UserPreferences current svnDiff3Command:'kdiff3'
        UserPreferences current svnDiff3Command:nil
    "

    "Created: / 03-10-2008 / 11:14:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:08:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 17-02-2012 / 01:31:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnEnabled
    "subversion source control is enabled"

    ^self at:#svnEnabled ifAbsent:[false]

    "Created: / 03-10-2008 / 11:11:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnEnabled: aBoolean
    "subversion source control is enabled"

    ^self at:#svnEnabled put: aBoolean

    "Created: / 03-10-2008 / 11:13:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnVerbose
    "verbose messages from subversion source control (if enabled)"

    ^self at:#svnVerbose ifAbsent: false

    "Created: / 19-03-2009 / 14:00:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-subversion'!

svnVerbose: aBoolean
    "verbose messages from subversion source control (if enabled)"

    ^self at:#svnVerbose put: aBoolean

    "Created: / 19-03-2009 / 13:59:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!stx_libsvn class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
