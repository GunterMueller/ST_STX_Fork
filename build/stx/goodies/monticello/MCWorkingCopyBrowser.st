"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCTool subclass:#MCWorkingCopyBrowser
	instanceVariableNames:'workingCopy workingCopyWrapper repository defaults'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCWorkingCopyBrowser class methodsFor:'as yet unclassified'!

initialize
	 (TheWorldMenu respondsTo: #registerOpenCommand:)
         ifTrue: [TheWorldMenu registerOpenCommand: {'Monticello Browser'. {self. #open}}]
!

new
	^ self basicNew initialize
!

open
	self new show
! !

!MCWorkingCopyBrowser methodsFor:'actions'!

addRepository
	self newRepository ifNotNilDo:
		[:repos | self addRepository: repos ].
!

addRepository: aRepository
	self repository: aRepository.
	self repositoryGroup addRepository: aRepository.
	self changed: #repositoryList; changed: #repositorySelection.
	self changedButtons.
!

addRepositoryToPackage
	self repository ifNotNilDo:
		[:repos |
		(self pickWorkingCopySatisfying: [ :p | (p repositoryGroup includes: repos) not ]) ifNotNilDo:
			[:wc |
			workingCopy _ wc.
			workingCopy repositoryGroup addRepository: repos.
			self repository: repos.	
			self
				changed: #workingCopySelection;
				changed: #repositoryList;
				changed: #repositorySelection.
			self changedButtons]]
!

addRepositoryToWorkingCopy
	workingCopy ifNotNilDo:
		[:wc |
			workingCopy repositoryGroup addRepository: self repository.
			self
				changed: #workingCopySelection;
				changed: #repositoryList;
				changed: #repositorySelection.
			self changedButtons]
!

addRequiredPackage
	workingCopy ifNotNilDo:
		[:wc |
		self pickWorkingCopy ifNotNilDo:
			[:required |
			wc requirePackage: required package.
			self workingCopyListChanged]]
!

addWorkingCopy
	|name|
	name _ FillInTheBlankMorph request: 'Name of package:'.
	name isEmptyOrNil ifFalse:
		[PackageInfo registerPackageName: name.
		workingCopy _ MCWorkingCopy forPackage: (MCPackage new name: name).
		workingCopyWrapper _ nil.
		self repositorySelection: 0].
	self workingCopyListChanged; changed: #workingCopySelection; changed: #repositoryList.
	self changedButtons.
!

backportChanges
	self canBackport ifFalse: [^self].
	workingCopy ifNotNil:
		[workingCopy needsSaving ifTrue: [^ self inform: 'You must save the working copy before backporting.'].
		self pickAncestorVersionInfo ifNotNilDo:
			[:baseVersionInfo |
			workingCopy backportChangesTo: baseVersionInfo]]
!

browseWorkingCopy
	workingCopy ifNotNil:
		[(MCSnapshotBrowser forSnapshot: workingCopy package snapshot)
			label: 'Snapshot Browser: ', workingCopy packageName;
			show]
!

canBackport
	^ self hasWorkingCopy and: [workingCopy needsSaving not]
!

checkForNewerVersions
	| newer |
	newer _ workingCopy possiblyNewerVersionsIn: self repository.
	^ newer isEmpty or: [
		self confirm: 'CAUTION!! These versions in the repository may be newer:', 
			String cr, newer asString, String cr,
			'Do you really want to save this version?'].
!

clearRequiredPackages
	workingCopy ifNotNilDo:
		[:wc |
		wc clearRequiredPackages.
		self workingCopyListChanged]
!

deleteWorkingCopy
	workingCopy unregister.
	self workingCopySelection: 0.
	self workingCopyListChanged.
!

editRepository
	| newRepo |
	
	newRepo := self repository openAndEditTemplateCopy.
	newRepo ifNotNil: [ 
		newRepo class = self repository class
			ifTrue: [self repository copyFrom: newRepo]
			ifFalse: [self inform: 'Must not change repository type!!']]
!

flushAllCaches
	| beforeBytes afterBytes beforeVersions afterVersions |
	Cursor wait showWhile: [
		beforeBytes := Smalltalk garbageCollect.
		beforeVersions := MCVersion allSubInstances size.
		MCFileBasedRepository flushAllCaches.
		afterBytes := Smalltalk garbageCollect.
		afterVersions := MCVersion allSubInstances size.
	].
	^self inform: (beforeVersions - afterVersions) asString, ' versions flushed', String cr,
 		(afterBytes - beforeBytes) asStringWithCommas, ' bytes reclaimed'
!

inspectWorkingCopy
	workingCopy ifNotNil: [workingCopy inspect]
!

loadRepositories
	FileStream fileIn: 'MCRepositories.st'.
	self changed: #repositoryList.
	self changedButtons.
!

newRepository
	| types index |
	types _ MCRepository allConcreteSubclasses asArray.
	index _ (PopUpMenu labelArray: (types collect: [:ea | ea description]))
				startUpWithCaption: 'Repository type:'.
	^ index = 0 ifFalse: [(types at: index) morphicConfigure]
!

openRepository
	self repository ifNotNilDo: [:repos | repos morphicOpen: workingCopy ]
!

recompilePackage
	workingCopy package packageInfo methods
		do: [:ea | ea actualClass recompile: ea methodSymbol]
		displayingProgress: 'Recompiling...'
!

removeRepository
	self repository ifNotNilDo:
		[:repos |
		self repositoryGroup removeRepository: repos.
		self repositorySelection: (1 min: self repositories size)].
	self changed: #repositoryList.
	self changedButtons.
!

repository
	workingCopy ifNotNil: [repository _ self defaults at: workingCopy ifAbsent: []].
	^ repository
!

repository: aRepository
	repository _ aRepository.
	workingCopy ifNotNil: [self defaults at: workingCopy put: aRepository]
!

revertPackage
	self pickAncestorVersionInfo ifNotNilDo: [:info |
		(self repositoryGroup versionWithInfo: info
			ifNone: [^self inform: 'No repository found for ', info name]
		) load]
!

saveRepositories
	| f |
	f := FileStream forceNewFileNamed: 'MCRepositories.st'.
	MCRepositoryGroup default repositoriesDo: [:r |
		f nextPutAll: 'MCRepositoryGroup default addRepository: (', r asCreationTemplate, ')!!'; cr.]
!

saveVersion
	| repo |
	self canSave ifFalse: [^self].
	self checkForNewerVersions ifFalse: [^self].
	repo _ self repository.
	workingCopy newVersion ifNotNilDo:
		[:v |
		(MCVersionInspector new version: v) show.
		Cursor wait showWhile: [repo storeVersion: v].
		MCCacheRepository default cacheAllFileNamesDuring: 
			[repo cacheAllFileNamesDuring: 
				[v allAvailableDependenciesDo:
					[:dep |
					(repo includesVersionNamed: dep info name)
						ifFalse: [repo storeVersion: dep]]]]]
!

trimAncestry
	self pickAncestorVersionInfo ifNotNilDo:
		[:ancestor |
		workingCopy ancestry trimAfterVersionInfo: ancestor]
!

unloadPackage
	workingCopy unload.
	self workingCopySelection: 0.
	self workingCopyListChanged.
!

viewChanges
	| patch |
	self canSave ifTrue:
		[patch _ workingCopy changesRelativeToRepository: self repository.
		patch isNil ifTrue: [^ self].
		patch isEmpty
			ifTrue: [ workingCopy modified: false.
				self inform: 'No changes' ]
			ifFalse:
				[ workingCopy modified: true.
				(MCPatchBrowser forPatch: patch)
					label: 'Patch Browser: ', workingCopy description;
					show]]
!

viewHistory
	workingCopy ifNotNil:
		[(MCWorkingHistoryBrowser new
				ancestry: workingCopy ancestry;
				package: workingCopy package)
			label:  'Version History: ',  workingCopy packageName;
			show]
! !

!MCWorkingCopyBrowser methodsFor:'morphic ui'!

buttonSpecs
       ^ #(
               ('+Package' addWorkingCopy 'Add a new package and make it the working copy')
               (Browse browseWorkingCopy 'Browse the working copy of the selected package' hasWorkingCopy)
               (Scripts editLoadScripts 'Edit the load/unload scripts of this package' hasWorkingCopy)
               (History viewHistory 'View the working copy''s history' hasWorkingCopy)
               (Changes viewChanges 'View the working copy''s changes relative to the installed version from the repository' canSave)
               (Backport backportChanges 'Backport the working copy''s changes to an ancestor' canBackport)
               (Save saveVersion 'Save the working copy as a new version to the selected repository' canSave)
             ('+Repository' addRepository 'Add an existing repository to the list of those visible')
               (Open openRepository 'Open a browser on the selected repository' hasRepository)
               )
!

canSave
	^ self hasWorkingCopy and: [self hasRepository]
!

changedButtons
	self changed: #hasWorkingCopy.
	self changed: #canSave.
	self changed: #canBackport.
	self changed: #hasRepository.
!

defaultExtent
	^ 550@200
!

defaultLabel
	^ 'Monticello Browser'
!

defaults
	^ defaults ifNil: [defaults _ Dictionary new]
!

editLoadScripts

	| menu |
	self hasWorkingCopy ifFalse: [^self].
	menu _ MenuMorph new defaultTarget: self.
	menu add: 'edit preamble' selector: #editScript: argument: #preamble.
	menu add: 'edit postscript' selector: #editScript: argument: #postscript.
	menu add: 'edit preambleOfRemoval' selector: #editScript: argument: #preambleOfRemoval.
	menu add: 'edit postscriptOfRemoval' selector: #editScript: argument: #postscriptOfRemoval.
	menu popUpInWorld.
!

editScript: scriptSymbol

| script |
script _ workingCopy packageInfo perform: scriptSymbol.
script openLabel: scriptSymbol asString, ' of the Package ', workingCopy package name.
!

hasRepository
	^ self repository notNil
!

hasWorkingCopy
	^ workingCopy notNil
!

initialize
	MCWorkingCopy addDependent: self.
	self workingCopies do: [:ea | ea addDependent: self].
!

pickAncestorVersionInfo
	| ancestors index |
	ancestors _ workingCopy ancestry breadthFirstAncestors.
	index _ (PopUpMenu labelArray: (ancestors collect: [:ea | ea name]))
				startUpWithCaption: 'Ancestor:'.
	^ index = 0 ifFalse: [ ancestors at: index]
!

pickWorkingCopy
	^self pickWorkingCopySatisfying: [ :c | true ]
!

pickWorkingCopySatisfying: aBlock
	| copies index |
	copies _ self workingCopies select: aBlock.
	copies isEmpty ifTrue: [ ^nil ].
	index _ (PopUpMenu labelArray: (copies collect: [:ea | ea packageName]))
				startUpWithCaption: 'Package:'.
	^ index = 0 ifFalse: [ copies at: index]
!

repositories
	^ self repositoryGroup repositories
!

repositoryGroup
	^ workingCopy
		ifNil: [MCRepositoryGroup default]
		ifNotNil: [workingCopy repositoryGroup]
!

repositoryList
	^ self repositories collect: [:ea | ea description]
!

repositoryListMenu: aMenu
	self repository ifNil: [^ aMenu].
	self fillMenu: aMenu fromSpecs:
		#(('open repository' #openRepository)
		    ('edit repository info' #editRepository)
		   ('add to package...' #addRepositoryToPackage)
		   ('remove repository' #removeRepository)	
		   ('load repositories' #loadRepositories)	
		   ('save repositories' #saveRepositories)
		   ('flush cached versions' #flushAllCaches)	
		).
		aMenu
		add: (self repository alwaysStoreDiffs
					ifTrue: ['store full versions']
					ifFalse: ['store diffs'])
		target: self
		selector: #toggleDiffs.
	^ aMenu
				
!

repositorySelection
	^ self repositories indexOf: self repository
!

repositorySelection: aNumber
	aNumber = 0
		ifTrue: [self repository: nil]
		ifFalse: [self repository: (self repositories at: aNumber)].
	self changed: #repositorySelection.
	self changedButtons.
!

toggleDiffs
	self repository alwaysStoreDiffs
		ifTrue: [self repository doNotAlwaysStoreDiffs]
		ifFalse: [self repository doAlwaysStoreDiffs]
!

unsortedWorkingCopies
	^ MCWorkingCopy allManagers 
!

update: aSymbol
	self unsortedWorkingCopies do: [:ea | ea addDependent: self].
	self workingCopyListChanged.
!

widgetSpecs
	^ #(
		((buttonRow) (0 0 1 0) (0 0 0 30))
		((treeOrListMorph: workingCopy) (0 0 0.5 1) (0 30 0 0))
		((listMorph: repository) (0.5 0 1 1) (0 30 0 0))
		)
!

workingCopies
	^ MCWorkingCopy allManagers asSortedCollection:
		[ :a :b | a package name <= b package name ]
!

workingCopy: wc
	workingCopy _ wc.
	self changed: #workingCopyList; changed: #workingCopySelection; changed: #repositoryList.
	self changedButtons.
!

workingCopyList
	^ self workingCopies collect:
		[:ea |
		(workingCopy notNil and: [workingCopy requiredPackages includes: ea package])
			ifTrue: [Text string: ea description emphasis: (Array with: TextEmphasis bold)]
			ifFalse: [ea description]]
!

workingCopyListChanged
	self changed: #workingCopyList.
	self changed: #workingCopyTree.
	self changedButtons.
!

workingCopyListMenu: aMenu
	workingCopy ifNil: [^ aMenu].
	self fillMenu: aMenu fromSpecs:
		#(('add required package' #addRequiredPackage)
			('clear required packages' #clearRequiredPackages)
			('browse package' #browseWorkingCopy)
			('view changes' #viewChanges)
			('view history' #viewHistory)
			('recompile package' #recompilePackage)
			('revert package...' #revertPackage)
			('trim ancestry' #trimAncestry)
			('unload package' #unloadPackage)
			('delete working copy' #deleteWorkingCopy)).
	(Smalltalk includesKey: #SARMCPackageDumper) ifTrue: [
		aMenu add: 'make SAR' target: self selector: #fileOutAsSAR
	].
	^aMenu
!

workingCopyListMorph
	^ PluggableMultiColumnListMorph
		on: self
		list: #workingCopyList
		selected: #workingCopySelection
		changeSelected: #workingCopySelection:
		menu: #workingCopyListMenu:
!

workingCopySelection
	^ self workingCopies indexOf: workingCopy
!

workingCopySelection: aNumber
	self workingCopy: 
		(aNumber = 0 
			ifTrue:[nil]
			ifFalse:[self workingCopies at: aNumber]).	
!

workingCopySelectionWrapper
	^workingCopyWrapper
!

workingCopySelectionWrapper: aWrapper
	workingCopyWrapper := aWrapper.
	self changed: #workingCopySelectionWrapper.
	self workingCopy: (aWrapper ifNotNil:[aWrapper item])
!

workingCopyTree
	^ self workingCopies collect:[:each| MCDependentsWrapper with: each model: self].
!

workingCopyTreeMenu: aMenu
	workingCopy ifNil: [^ aMenu].
	self fillMenu: aMenu fromSpecs:
		#(('add required package' #addRequiredPackage)
			('clear required packages' #clearRequiredPackages)
			('browse package' #browseWorkingCopy)
			('view changes' #viewChanges)
			('view history' #viewHistory)
			('recompile package' #recompilePackage)
			('revert package...' #revertPackage)
			('unload package' #unloadPackage)
			('trim ancestry' #trimAncestry)
			('delete working copy' #deleteWorkingCopy)
			('inspect working copy' #inspectWorkingCopy)).
	(Smalltalk includesKey: #SARMCPackageDumper) ifTrue: [
		aMenu add: 'make SAR' target: self selector: #fileOutAsSAR
	].
	^aMenu
!

workingCopyTreeMorph
	^ SimpleHierarchicalListMorph
		on: self
		list: #workingCopyTree
		selected: #workingCopyWrapper
		changeSelected: #workingCopyWrapper:
		menu: #workingCopyListMenu:
! !

!MCWorkingCopyBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCWorkingCopyBrowser.st,v 1.2 2012-09-11 21:15:12 cg Exp $'
! !


MCWorkingCopyBrowser initialize!
