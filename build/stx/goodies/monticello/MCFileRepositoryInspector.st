"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCVersionInspector subclass:#MCFileRepositoryInspector
	instanceVariableNames:'repository versions loaded newer inherited selectedPackage
		selectedVersion order versionInfo'
	classVariableNames:'Order'
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!

!MCFileRepositoryInspector class methodsFor:'documentation'!

documentation
"
    I'm a monticello tool composed of three panes to browse repositories and the packages they contain. You get an instance of me when you click on a repository in Monticello browser and press open. 

    My left pane presents the packages, my right one their versions and the bottom one the commit log of the selected package versions.

    I underline the packages you already loaded, and highlight the ones you don't have updated to the last version. I also highlight the versions you did not load yet.

    Example: I can browse packages of PharoInbox with:
    (MCFileRepositoryInspector 
            repository: (MCHttpRepository
                                            location: 'http://www.squeaksource.com/PharoInbox'
                                            user: ''
                                            password: '')
            workingCopy: nil) show.
"
! !

!MCFileRepositoryInspector class methodsFor:'as yet unclassified'!

order
	Order isNil
		ifTrue: [ Order _ 5 ].
	^Order
!

order: anInteger
	Order _ anInteger
!

repository: aFileBasedRepository workingCopy: aWorkingCopy
	^self new
		setRepository: aFileBasedRepository workingCopy: aWorkingCopy;
		yourself
! !

!MCFileRepositoryInspector class methodsFor:'class initialization'!

initialize
	"self initialize"

	self migrateInstances
!

migrateInstances
	self allSubInstancesDo: [:inst |
		#(packageList versionList) do: [:each |
			[(inst findListMorph: each) highlightSelector: nil]
				on: Error do: [:ignore | ]]].
! !

!MCFileRepositoryInspector methodsFor:'as yet unclassified'!

load
	self hasVersion ifTrue:
		[self version isCacheable
			ifTrue: [version workingCopy repositoryGroup addRepository: repository].
		super load.
		self refresh].
!

merge
	super merge.
	self refresh.
!

refresh
	| packageNames name latest av |
	packageNames _ Set new.
	versions _ repository readableFileNames collect: [ :each |
		name _ (each copyUpToLast: $.) copyUpTo: $(.
		name last isDigit ifFalse: [Array with: name with: '' with: '' with: each]
			ifTrue:
				[Array
					with: (packageNames add: (name copyUpToLast:  $-))		"pkg name"
					with: ((name copyAfterLast: $-) upTo: $.)				"user"
					with: ((name copyAfterLast: $-) copyAfter: $.) asInteger	"version"
					with: each]].
	newer _ Set new.
	inherited _ Set new.
	loaded _ Set new.
	(MCWorkingCopy allManagers 
"		select: [ :each | packageNames includes: each packageName]")
		do: [:each |
			each ancestors do: [ :ancestor |
				loaded add: ancestor name.
				ancestor ancestorsDoWhileTrue: [:heir |
					(inherited includes: heir name)
						ifTrue: [false]
						ifFalse: [inherited add: heir name. true]]].
			latest _ (versions select: [:v | v first = each package name])	
				detectMax: [:v | v third].
			(latest notNil and: [
				each ancestors allSatisfy: [:ancestor |
					av _ ((ancestor name copyAfterLast: $-) copyAfter: $.) asInteger.
					av < latest third or: [
						av = latest third and: [((ancestor name copyAfterLast: $-) upTo: $.) ~= latest second]]]])
				ifTrue: [newer add: each package name ]].

	self changed: #packageList; changed: #versionList
!

setRepository: aFileBasedRepository workingCopy: aWorkingCopy
	order _ self class order.
	repository _ aFileBasedRepository.
	self refresh.
	aWorkingCopy
		ifNil: [selectedPackage _ self packageList isEmpty ifFalse: [self packageList first]]
		ifNotNil: [ selectedPackage _ aWorkingCopy ancestry ancestorString copyUpToLast: $- ].
	MCWorkingCopy addDependent: self.
! !

!MCFileRepositoryInspector methodsFor:'morphic ui'!

buttonSpecs
	^#(('Refresh' refresh 'refresh the version-list')) , super buttonSpecs
!

defaultExtent
	^450@300
!

defaultLabel
	^'Repository: ' , repository description
!

hasVersion
	^ selectedVersion notNil
!

order: anInteger
	self class order: (order _ anInteger).
	self changed: #versionList.
!

orderSpecs
	^{
		'unchanged' -> nil.
		'order by package' -> [ :x :y | x first <= y first ].
		'order by author' -> [ :x :y | x second <= y second ].
		'order by version-string' -> [ :x :y | x third <= y third ].
		'order by version-number' -> [ :x :y | x third asNumber >= y third asNumber ].
		'order by filename' -> [ :x :y | x fourth <= y fourth ].
	}
!

orderString: anIndex
	^String streamContents: [ :stream |
		order = anIndex
			ifTrue: [ stream nextPutAll: '<yes>' ]
			ifFalse: [ stream nextPutAll: '<no>' ].
		stream nextPutAll: (self orderSpecs at: anIndex) key ]
!

packageHighlight: aString

	newer ifNil: [newer := #()].
	^(loaded anySatisfy: [:each | (each copyUpToLast: $-) = aString])
		ifTrue: [
			Text string: aString
				attribute: (TextEmphasis new emphasisCode: (
					((newer includes: aString)
						ifTrue: [5] ifFalse: [4])))]
		ifFalse: [aString]
!

packageList
	| result |
	result _ versions
		inject: Set new
		into: [ :set :each | set add: each first; yourself ].

	"sort loaded packages first, then alphabetically"
	result _ result asSortedCollection: [:a :b |
		| loadedA loadedB |
		loadedA _ loaded anySatisfy: [:each | (each copyUpToLast: $-) = a].
		loadedB _ loaded anySatisfy: [:each | (each copyUpToLast: $-) = b].
		loadedA = loadedB 
			ifTrue: [a < b]
			ifFalse: [loadedA]].

	^result collect: [:each | self packageHighlight: each]
!

packageListMenu: aMenu
	^aMenu
!

packageSelection
	^self packageList indexOf: selectedPackage
!

packageSelection: aNumber
	selectedPackage _ aNumber isZero
		ifFalse: [ (self packageList at: aNumber) asString ].
	self versionSelection: 0.
	self changed: #packageSelection; changed: #versionList
!

version
	^ version ifNil:
		[Cursor wait showWhile:
			[version _ repository versionFromFileNamed: selectedVersion].
		version]
!

versionHighlight: aString

	| verName |
	inherited ifNil: [inherited := #()].
	verName := (aString copyUpToLast: $.) copyUpTo: $(.
	^Text
		string: aString
		attribute: (TextEmphasis new emphasisCode: (
			((loaded includes: verName) ifTrue: [ 4 "underlined" ]
				ifFalse: [ (inherited includes: verName)
					ifTrue: [ 0 ]
					ifFalse: [ 1 "bold" ] ])))
!

versionInfo
	^ versionInfo ifNil: [versionInfo _ repository versionInfoFromFileNamed: selectedVersion]
!

versionList
	| result sortBlock |
	result _ selectedPackage isNil
		ifTrue: [ versions ]
		ifFalse: [ versions select: [ :each | selectedPackage = each first ] ].
	sortBlock _ (self orderSpecs at: order) value.
	sortBlock isNil ifFalse: [
		result _ result asSortedCollection: [:a :b | [sortBlock value: a value: b] on: Error do: [true]]].
	^result _ result 
		collect: [ :each | self versionHighlight: each fourth ]
!

versionListMenu: aMenu
	1 to: self orderSpecs size do: [ :index |
		aMenu addUpdating: #orderString: target: self selector: #order: argumentList: { index } ].
	^aMenu
!

versionSelection
	^self versionList indexOf: selectedVersion
!

versionSelection: aNumber
	aNumber isZero 
		ifTrue: [ selectedVersion _ version _ versionInfo _ nil ]
		ifFalse: [ 
			selectedVersion _ (self versionList at: aNumber) asString.
			version _ versionInfo _ nil].
	self changed: #versionSelection; changed: #summary; changed: #hasVersion
!

versionSummary
	^ version
		ifNotNil: [version summary]
		ifNil: [self versionInfo summary]
!

widgetSpecs
	^#(	((buttonRow) (0 0 1 0) (0 0 0 30))
		((listMorph: package) (0 0 0.5 0.6) (0 30 0 0))
		((listMorph: version) (0.5 0 1 0.6) (0 30 0 0))
		((textMorph: summary) (0 0.6 1 1) (0 0 0 0)) )
! !

!MCFileRepositoryInspector class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCFileRepositoryInspector.st,v 1.3 2013-05-15 12:03:44 cg Exp $'
! !


MCFileRepositoryInspector initialize!
