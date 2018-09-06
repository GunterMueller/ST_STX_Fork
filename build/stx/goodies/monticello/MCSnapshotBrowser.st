"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCCodeTool subclass:#MCSnapshotBrowser
	instanceVariableNames:'categorySelection classSelection protocolSelection
		methodSelection switch'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCSnapshotBrowser class methodsFor:'as yet unclassified'!

forSnapshot: aSnapshot
	^ self new snapshot: aSnapshot
! !

!MCSnapshotBrowser methodsFor:'accessing'!

allClassNames
	^ (items 
		select: [:ea | ea isOrganizationDefinition not] 
		thenCollect: [:ea | ea className]) asSet.
!

extensionClassNames
	^ (self allClassNames difference: self packageClassNames) asSortedCollection
!

extensionsCategory
	^ '*Extensions'
!

methodsForSelectedClass
	^ items select: [:ea | (ea className = classSelection) 
									and: [ea isMethodDefinition]
									and: [ea classIsMeta = self switchIsClass]].
!

methodsForSelectedClassCategory
	| visibleClasses |
	visibleClasses _ self visibleClasses.
	^ items select: [:ea | (visibleClasses includes: ea className) 
									and: [ea isMethodDefinition]
									and: [ea classIsMeta = self switchIsClass]].
!

methodsForSelectedProtocol
	| methods |
	protocolSelection ifNil: [^ Array new].
	methods _ self methodsForSelectedClass asOrderedCollection.
	(protocolSelection = '-- all --') 
		ifFalse: [methods removeAllSuchThat: [:ea | ea category ~= protocolSelection]].
	^ methods 
	
								
!

packageClassNames
	^ self packageClasses collect: [:ea | ea className]
!

packageClasses
	^ items select: [:ea | ea isClassDefinition]
!

selectedClass
	classSelection ifNil: [ ^nil ].
	^Smalltalk at: classSelection ifAbsent: [ nil ].
!

selectedClassOrMetaClass
	| class |
	classSelection ifNil: [ ^nil ].
	class _ Smalltalk at: classSelection ifAbsent: [ ^nil ].
	^self switchIsClass ifTrue: [ class class ]
		ifFalse: [ class ].
!

selectedMessageCategoryName
	^protocolSelection
!

selectedMessageName
	^methodSelection ifNotNil: [^ methodSelection selector ].
!

snapshot: aSnapshot
	items _ aSnapshot definitions asSortedCollection.
	self categorySelection: 0.
! !

!MCSnapshotBrowser methodsFor:'listing'!

categoryList
	^ self visibleCategories
!

classList
	^ self visibleClasses
!

methodList
	^ self visibleMethods collect: [:ea | ea selector]
!

protocolList
	^ self visibleProtocols
!

visibleCategories
	^ (self packageClasses collect: [:ea | ea category]) 
			asSet asSortedCollection add: self extensionsCategory; yourself.
!

visibleClasses
	^ categorySelection = self extensionsCategory
		ifTrue: [self extensionClassNames]
		ifFalse: [self packageClasses
					select: [:ea | ea category = categorySelection]
					thenCollect: [:ea | ea className]].
!

visibleMethods
	^ classSelection 
		ifNil: [#()]
		ifNotNil: [self methodsForSelectedProtocol]
!

visibleProtocols
	| methods protocols |
	self switchIsComment ifTrue: [^ Array new].
	methods _ self methodsForSelectedClass.
	protocols _ (methods collect: [:ea | ea category]) asSet asSortedCollection.
	(protocols size > 1) ifTrue: [protocols add: '-- all --'].
	^ protocols 
! !

!MCSnapshotBrowser methodsFor:'menus'!

categoryListMenu: aMenu 
	categorySelection
		ifNotNil: [aMenu
				add: (categorySelection = '*Extensions'
						ifTrue: ['load all extension methods' translated]
						ifFalse: ['load class category {1}' translated format: {categorySelection}])
				action: #loadCategorySelection].
	^ aMenu
!

classListMenu: aMenu 
	classSelection ifNil: [ ^aMenu ].

	super classListMenu: aMenu.

	aMenu
		addLine;
				add: ('load class {1}' translated format: {classSelection})
				action: #loadClassSelection.
	^ aMenu
!

inspectSelection
	^ self methodSelection inspect
!

loadCategorySelection
	"Load the entire selected category"
	categorySelection ifNil: [ ^self ].
	self methodsForSelectedClassCategory do: [ :m | m load ].
!

loadClassSelection
	classSelection ifNil: [ ^self ].
	(self packageClasses detect: [ :ea | ea className = classSelection ] ifNone: [ ^self ]) load.
	self methodsForSelectedClass do: [ :m | m load ].
!

loadMethodSelection
	methodSelection ifNil: [ ^self ].
	methodSelection load.
!

loadProtocolSelection
	protocolSelection ifNil: [ ^self ].
	self methodsForSelectedProtocol do: [ :m | m load ].
!

methodListMenu: aMenu 
	super methodListMenu: aMenu.
	self selectedMessageName
		ifNotNilDo: [:msgName | aMenu addLine; add: 'load method' translated action: #loadMethodSelection].
	^ aMenu
!

protocolListMenu: aMenu 
	protocolSelection
		ifNotNil: [aMenu
				add: ('load protocol ''{1}''' translated format: {protocolSelection})
				action: #loadProtocolSelection ].
	^ aMenu
! !

!MCSnapshotBrowser methodsFor:'morphic ui'!

buttonSpecs
	^ #(('instance' switchBeInstance 'show instance' buttonEnabled switchIsInstance)
		('?' switchBeComment 'show comment' buttonEnabled switchIsComment)
		('class' switchBeClass 'show class' buttonEnabled switchIsClass))
!

defaultExtent
	^ 650@400.
!

defaultLabel
	^ 'Snapshot Browser'
!

widgetSpecs

	Preferences annotationPanes ifFalse: [ ^#(
		((listMorph: category) (0 0 0.25 0.4))
		((listMorph: class) (0.25 0 0.50 0.4) (0 0 0 -30))
		((listMorph: protocol) (0.50 0 0.75 0.4))
		((listMorph:selection:menu:keystroke:  methodList methodSelection methodListMenu: methodListKey:from:) (0.75 0 1 0.4))
		((buttonRow) (0.25 0.4 0.5 0.4) (0 -30 0 0))
		((textMorph: text) (0 0.4 1 1))
		) ].

	^#(
		((listMorph: category) (0 0 0.25 0.4))
		((listMorph: class) (0.25 0 0.50 0.4) (0 0 0 -30))
		((listMorph: protocol) (0.50 0 0.75 0.4))
		((listMorph:selection:menu:keystroke:  methodList methodSelection methodListMenu: methodListKey:from:) (0.75 0 1 0.4))

		((buttonRow) (0.25 0.4 0.5 0.4) (0 -30 0 0))

		((textMorph: annotations) (0 0.4 1 0.4) (0 0 0 30))
		((textMorph: text) (0 0.4 1 1) (0 30 0 0))
		)
! !

!MCSnapshotBrowser methodsFor:'selecting'!

categorySelection
	^ categorySelection ifNil: [0] ifNotNil: [self visibleCategories indexOf: categorySelection]
!

categorySelection: aNumber
	categorySelection _ aNumber = 0 ifFalse: [self visibleCategories at: aNumber].
	self classSelection: 0.
	self changed: #categorySelection;
		changed: #annotations;
		changed: #classList.
!

classSelection
	^ classSelection ifNil: [0] ifNotNil: [self visibleClasses indexOf: classSelection]
!

classSelection: aNumber
	classSelection _ aNumber = 0 ifFalse: [self visibleClasses at: aNumber].
	self protocolSelection: 0.
	self changed: #classSelection; 
		changed: #protocolList;
		changed: #annotations;
		changed: #methodList.
!

methodSelection
	^ methodSelection
			ifNil: [0] 
			ifNotNil: [self visibleMethods indexOf: methodSelection]
!

methodSelection: aNumber
	methodSelection _ aNumber = 0 ifFalse: [self visibleMethods at: aNumber].
	self changed: #methodSelection; changed: #text; changed: #annotations
!

protocolSelection
	^ protocolSelection 
		ifNil: [0]
		ifNotNil: [self visibleProtocols indexOf: protocolSelection]
!

protocolSelection: anInteger
	protocolSelection _ (anInteger = 0 ifFalse: [self visibleProtocols at: anInteger]).
	self methodSelection: 0.
	self changed: #protocolSelection;
		changed: #methodList;	
		changed: #annotations
! !

!MCSnapshotBrowser methodsFor:'switch'!

signalSwitchChanged
	self protocolSelection: 0.
	self 
		changed: #switchIsInstance;
		changed: #switchIsComment;
		changed: #switchIsClass;
		changed: #protocolList;
		changed: #methodList;
		changed: #text.
!

switchBeClass
	switch _ #class.
	self signalSwitchChanged.
!

switchBeComment
	switch _ #comment.
	self signalSwitchChanged.
!

switchBeInstance
	switch _ #instance.
	self signalSwitchChanged.
!

switchIsClass
	^ switch = #class
!

switchIsComment
	^ switch = #comment.
!

switchIsInstance
	switch ifNil: [switch _ #instance].
	^ switch = #instance.
! !

!MCSnapshotBrowser methodsFor:'text'!

annotations
	methodSelection ifNotNil: [^ methodSelection annotations ].
	^ ''
!

annotations: stuff
	self changed: #annotations
!

classCommentString
	^ (items 
		detect: [:ea | ea isClassDefinition and: [ea className = classSelection]]
		ifNone: [^ '']) comment.
!

classDefinitionString
	| defs |
	defs _ items select: [:ea | (ea isClassDefinition or: [ea isClassDefinitionExtension])
			and: [ea className = classSelection]].

	defs isEmpty ifTrue: [^ 'This class is defined elsewhere.'].

	^ String streamContents: [:stream | 
		defs asArray sort 
			do: [:ea | ea printDefinitionOn: stream]
			separatedBy: [stream nextPut: $.; cr]
	].
!

text
	self switchIsComment ifTrue: [^ self classCommentString].
	methodSelection ifNotNil: [^ methodSelection source].
	protocolSelection ifNotNil: [^ ''].
	classSelection ifNotNil: [^ self classDefinitionString].
	^ ''
!

text: aTextOrString
	self changed: #text
! !

!MCSnapshotBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSnapshotBrowser.st,v 1.2 2012-09-11 21:14:41 cg Exp $'
! !

