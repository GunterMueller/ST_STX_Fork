"{ Package: 'stx:goodies/monticello' }"

MCTool subclass:#MCVersionInspector
	instanceVariableNames:'version'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!

!MCVersionInspector class methodsFor:'documentation'!

documentation
"
    I am a tool that visually represents an MCVersion.

    While I can be opened on anMCVersion, you've probably seen me most often
    after saving a package in the Monticello Browser.

    I have buttons to perform common version-related actions - like browsing,
    loading, and viewing changes. In my main text area, I display the following
    information about my version - name, author, timestamp, UUID, ancestors and
    log message.    
"
! !

!MCVersionInspector methodsFor:'as yet unclassified'!

adopt
	(self confirm:
'Modifying ancestry can be dangerous unless you know
what you are doing.  Are you sure you want to adopt
',self version info name, ' as an ancestor of your working copy?')
		ifTrue: [self version adopt]
!

browse
	self version browse
!

changes
	(MCPatchBrowser forPatch: self version changes)
		showLabelled: 'Changes from ', self version info name
!

diff
	| ancestorVersion |
	self pickAncestor ifNotNilDo:
		[:ancestor |
		ancestorVersion _ self version workingCopy repositoryGroup versionWithInfo: ancestor.
		(self version asDiffAgainst: ancestorVersion) open]
!

hasVersion
	^version notNil
!

history
	(MCVersionHistoryBrowser new ancestry: self versionInfo) show
!

load
	Cursor wait showWhile: [self version load]
!

merge
	self version merge
!

save
	self pickRepository ifNotNilDo:
		[:ea |
		ea storeVersion: self version]
!

summary
	^self hasVersion
		ifTrue: [ self versionSummary ]
		ifFalse: [ String new ]
!

version
	^ version
!

version: aVersion
	version _ aVersion
!

versionInfo
	^ self version info
!

versionSummary
	^ self version summary
! !

!MCVersionInspector methodsFor:'morphic ui'!

buttonSpecs
       ^ #((Browse browse 'Browse this version' hasVersion)
               (History history 'Browse the history of this version' hasVersion)
               (Changes changes 'Browse the changes this version would make to the
image' hasVersion)
               (Load load 'Load this version into the image' hasVersion)
               (Merge merge 'Merge this version into the image' hasVersion)
               (Adopt adopt 'Adopt this version as an ancestor of your working copy'
hasVersion)
               (Copy save 'Copy this version to another repository' hasVersion)
               (Diff diff 'Create an equivalent version based on an earlier release'
hasVersion))
!

defaultExtent
	^ 400@200
!

defaultLabel
	^ 'Version: ', self version info name
!

pickAncestor
	| index versions |
	versions _ self version info breadthFirstAncestors.
	index _ (PopUpMenu labelArray: (versions collect: [:ea | ea name]))
				startUpWithCaption: 'Ancestor:'.
	^ index = 0 ifFalse: [versions at: index]
!

pickRepository
	| index |
	index _ (PopUpMenu labelArray: (self repositories collect: [:ea | ea description]))
				startUpWithCaption: 'Repository:'.
	^ index = 0 ifFalse: [self repositories at: index]
!

repositories
	^ MCRepositoryGroup default repositories
!

widgetSpecs
	^ #(
		((buttonRow) (0 0 1 0) (0 0 0 30))
		((textMorph: summary) (0 0 1 1) (0 30 0 0))
		)
! !

!MCVersionInspector class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionInspector.st,v 1.3 2013-05-15 10:49:35 cg Exp $'
! !

