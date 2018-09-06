"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCSnapshotBrowserTest
	instanceVariableNames:'model morph'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCSnapshotBrowserTest class methodsFor:'as yet unclassified'!

resources
	^ Array with: MCSnapshotResource
! !

!MCSnapshotBrowserTest methodsFor:'asserting'!

assertAListIncludes: anArrayOfStrings
	self listMorphs 
			detect: [:m | m getList includesAllOf: anArrayOfStrings]
			ifNone: [self assert: false].
!

assertAListMatches: strings
	| listMorphs list |
	listMorphs _ self listMorphs.
	listMorphs 
		detect: [:m | list _ m getList. (list size = strings size) and: [list includesAllOf: strings]]
		ifNone: [self assert: false].
!

assertButtonExists: aString
	self buttonMorphs detect: [:m | m label = aString] ifNone: [self assert: false].
				
!

assertButtonOn: aString
	self assert: (self findButtonWithLabel: aString) getModelState.
	
!

assertTextIs: aString
	self assert: self textMorph contents = aString.
!

denyAListHasSelection: aString
	| found |
	found _ true.
	self listMorphs 
			detect: [:m | m selection = aString]
			ifNone: [found _ false].
	self deny: found.
!

denyAListIncludesAnyOf: anArrayOfStrings
	| found |
	found _ true.
	self listMorphs 
			detect: [:m | m getList includesAnyOf: anArrayOfStrings]
			ifNone: [found _ false].
	self deny: found.
!

denyButtonOn: aString
	self deny: (self findButtonWithLabel: aString) getModelState.
	
! !

!MCSnapshotBrowserTest methodsFor:'morphic'!

annotationTextMorph
	^ (self morphsOfClass: TextMorph) first
!

buttonMorphs
	^ self morphsOfClass: PluggableButtonMorph
!

findButtonWithLabel: aString
	^ self buttonMorphs detect: [:m | m label = aString]
!

findListContaining: aString
	^ self listMorphs detect: [:m | m getList includes: aString]
!

listMorphs
	^ self morphsOfClass: PluggableListMorph
!

morphsOfClass: aMorphClass
	| morphs |
	morphs _ OrderedCollection new.
	morph allMorphsDo: [:m | (m isKindOf: aMorphClass) ifTrue: [morphs add: m]].
	^ morphs
!

textMorph
	^ (self morphsOfClass: TextMorph) last
! !

!MCSnapshotBrowserTest methodsFor:'private'!

allCategories
	^ Array with: model extensionsCategory with: self mockCategoryName.
!

allMethods
	^ MCSnapshotResource current definitions
		select: [:def | def isMethodDefinition]
		thenCollect: [:def | def selector]		
!

allProtocols
	^ MCSnapshotResource current definitions
		select: [:def | def isMethodDefinition]
		thenCollect: [:def | def category]		
!

classABooleanMethods
	^ #(falsehood moreTruth truth)
!

classAClassProtocols
	^ self protocolsForClass: self mockClassA class.
!

classAComment
	^ self mockClassA organization classComment.
!

classADefinitionString
	^ self mockClassA definition
!

classAProtocols
	^ self protocolsForClass: self mockClassA.
!

definedClasses
	^ MCSnapshotResource current definitions 
		select: [:def | def isClassDefinition] 
		thenCollect: [:def | def className].
!

falsehoodMethodSource
	^ 'falsehood
	^ false'
!

protocolsForClass: aClass
	| protocols |
	protocols _ aClass organization categories.
	protocols size > 1 ifTrue: [protocols _ protocols copyWith: '-- all --'].
	^ protocols.
! !

!MCSnapshotBrowserTest methodsFor:'running'!

setUp
	model _ MCSnapshotBrowser forSnapshot: MCSnapshotResource current snapshot.
	morph _ model buildWindow.
! !

!MCSnapshotBrowserTest methodsFor:'selecting'!

selectMockClassA
	self clickOnListItem: self mockCategoryName.
	self clickOnListItem: 'MCMockClassA'.
	
! !

!MCSnapshotBrowserTest methodsFor:'simulating'!

clickOnButton: aString
	(self findButtonWithLabel: aString) performAction.
!

clickOnListItem: aString
	| listMorph |
	listMorph _ self findListContaining: aString.
	listMorph changeModelSelection: (listMorph getList indexOf: aString).
! !

!MCSnapshotBrowserTest methodsFor:'testing'!

testAnnotationPane
	| oldPref |
	oldPref _ Preferences annotationPanes.

	Preferences disable: #annotationPanes.
	morph _ model buildWindow.
	self assert: (self morphsOfClass: TextMorph) size = 1.

	Preferences enable: #annotationPanes.
	morph _ model buildWindow.
	self assert: (self morphsOfClass: TextMorph) size = 2.

	Preferences setPreference: #annotationPanes toValue: oldPref
!

testButtonMutex
	self assertButtonOn: 'instance'.
	self denyButtonOn: '?'.
	self denyButtonOn: 'class'.
	
	self clickOnButton: '?'.
	self assertButtonOn: '?'.
	self denyButtonOn: 'instance'.
	self denyButtonOn: 'class'.
	
	self clickOnButton: 'class'.
	self assertButtonOn: 'class'.
	self denyButtonOn: '?'.
	self denyButtonOn: 'instance'.
!

testCategorySelected
	self clickOnListItem: self mockCategoryName.
	
	self assertAListMatches: self allCategories.
	self assertAListMatches: self definedClasses.
	self denyAListIncludesAnyOf: self allProtocols.
	self denyAListIncludesAnyOf: self allMethods.
	self assertTextIs: ''.
!

testClassSelected
	self selectMockClassA.
	
	self assertAListMatches: self allCategories.
	self assertAListMatches: self definedClasses.
	self assertAListMatches: self classAProtocols.
	self denyAListIncludesAnyOf: self allMethods.
	self assertTextIs: self classADefinitionString.
!

testClassSideClassSelected
	self clickOnButton: 'class'.
	self selectMockClassA.
	
	self assertAListMatches: self allCategories.
	self assertAListMatches: self definedClasses.
	self assertAListMatches: self classAClassProtocols.
	self denyAListIncludesAnyOf: self allMethods.
	self assertTextIs: self classADefinitionString.
!

testComment
	self clickOnButton: '?'.
	self assertTextIs: ''.
	
	self clickOnListItem: self mockCategoryName.
	self assertTextIs: ''.
	
	self clickOnListItem: 'MCMockClassA'.
	self assertTextIs: self classAComment.
!

testFourColumns
	self assert: self listMorphs size = 4.
!

testMethodIsCleared
	self clickOnListItem: self mockCategoryName.
	self clickOnListItem: 'MCMockClassA'.
	self clickOnListItem: 'boolean'.
	self clickOnListItem: 'falsehood'.
	self clickOnListItem: '-- all --'.
	
	self denyAListHasSelection: 'falsehood'.
!

testMethodSelected
	self clickOnListItem: self mockCategoryName.
	self clickOnListItem: 'MCMockClassA'.
	self clickOnListItem: 'boolean'.
	self clickOnListItem: 'falsehood'.
	
	self assertAListMatches: self allCategories.
	self assertAListMatches: self definedClasses.
	self assertAListMatches: self classAProtocols.
	self assertAListMatches: self classABooleanMethods.
	self assertTextIs: self falsehoodMethodSource.
!

testNoSelection
	self assertAListMatches: self allCategories.
	self denyAListIncludesAnyOf: self definedClasses.
	self denyAListIncludesAnyOf: self allProtocols.
	self denyAListIncludesAnyOf: self allMethods.
	self assertTextIs: ''.
!

testProtocolIsCleared
	self clickOnListItem: self mockCategoryName.
	self clickOnListItem: 'MCMockASubclass'.
	self clickOnListItem: 'as yet unclassified'.
	self clickOnListItem: 'MCMockClassA'.
	
	self denyAListHasSelection: 'as yet unclassified'.
!

testProtocolSelected
	self clickOnListItem: self mockCategoryName.
	self clickOnListItem: 'MCMockClassA'.
	self clickOnListItem: 'boolean'.
	
	self assertAListMatches: self allCategories.
	self assertAListMatches: self definedClasses.
	self assertAListMatches: self classAProtocols.
	self assertAListMatches: self classABooleanMethods.
	self assertTextIs: ''.		
!

testTextPane
	self shouldnt: [self textMorph] raise: Exception.
!

testThreeButtons
	self assertButtonExists: 'instance'.
	self assertButtonExists: '?'.
	self assertButtonExists: 'class'.
! !

!MCSnapshotBrowserTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCSnapshotBrowserTest.st,v 1.2 2013-05-29 00:02:19 vrany Exp $'
! !

