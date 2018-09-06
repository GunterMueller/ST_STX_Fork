"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCStWriterTest
	instanceVariableNames:'stream writer'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCStWriterTest methodsFor:'asserting'!

assertAllChunksAreWellFormed
	stream reset.
	stream 
		untilEnd: [self assertChunkIsWellFormed: stream nextChunk]
		displayingProgress: 'Checking syntax...'
!

assertChunkIsWellFormed: chunk
	Parser new
		parse: chunk readStream 
		class: UndefinedObject 
		noPattern: true
		context: nil
		notifying: nil
		ifFail: [self assert: false]
!

assertContentsOf: strm match: expected 
	| actual |
	actual := strm contents.
	self assert: actual size = expected size.
	actual with: expected do: [:a :e | self assert: a = e]
!

assertMethodChunkIsWellFormed: chunk
	Parser new
		parse: chunk readStream 
		class: UndefinedObject 
		noPattern: false
		context: nil
		notifying: nil
		ifFail: [self assert: false]
! !

!MCStWriterTest methodsFor:'data'!

expectedClassDefinitionA
 ^ '
MCMock subclass: #MCMockClassA
	instanceVariableNames: ''ivar''
	classVariableNames: ''CVar''
	poolDictionaries: ''''
	category: ''Monticello-Mocks''!!

!!MCMockClassA commentStamp: ''cwp 8/10/2003 16:43'' prior: 0!!
This is a mock class. The Monticello tests manipulated it to simulate a developer modifying code in the image.!!
'
!

expectedClassDefinitionB
 ^ '
MCMock subclass: #MCMockClassB
	instanceVariableNames: ''ivarb''
	classVariableNames: ''CVar''
	poolDictionaries: ''MCMockAPoolDictionary''
	category: ''Monticello-Mocks''!!

MCMockClassB class
	instanceVariableNames: ''ciVar''!!

!!MCMockClassB commentStamp: '''' prior: 0!!
This comment has a bang!!!! Bang!!!! Bang!!!!!!
'
!

expectedClassMethodDefinition
	^ '
!!MCMockClassA class methodsFor: ''as yet unclassified'' stamp: ''ab 7/7/2003 23:21''!!
one

	^ 1!! !!
'
!

expectedMethodDefinition
	^ '
!!MCMockClassA methodsFor: ''numeric'' stamp: ''cwp 8/2/2003 17:26''!!
one
	^ 1!! !!
'
!

expectedMethodDefinitionWithBangs
	^ '
!!MCStWriterTest methodsFor: ''testing'' stamp: ''cwp 8/9/2003 14:55''!!
methodWithBangs
	^ ''
	^ ReadStream on: 
''''MCRevisionInfo packageName: ''''MonticelloCompatibilityTest''''!!!!!!!!
MCOrganizationDeclaration categories: 
  #(
  ''''Monticello-Mocks'''')!!!!!!!!

MCClassDeclaration
  name: #MCMockClassD
  superclassName: #Object
  category: #''''Monticello-Mocks''''
  instVarNames: #()
  comment: ''''''''!!!!!!!!

MCMethodDeclaration className: #MCMockClassD selector: #one category: #''''as yet unclassified'''' timeStamp: ''''cwp 7/8/2003 21:21'''' source: 
''''one
	^ 1''''!!!!!!!!
''''
''
!! !!
'
!

expectedOrganizationDefinition
	^ 'SystemOrganization addCategory: ''Monticello-Mocks''!!
'
! !

!MCStWriterTest methodsFor:'testing'!

expectedInitializerA
	^ 'MCMockClassA initialize'
!

methodWithBangs
	^ '
	^ ReadStream on: 
''MCRevisionInfo packageName: ''MonticelloCompatibilityTest''!!!!
MCOrganizationDeclaration categories: 
  #(
  ''Monticello-Mocks'')!!!!

MCClassDeclaration
  name: #MCMockClassD
  superclassName: #Object
  category: #''Monticello-Mocks''
  instVarNames: #()
  comment: ''''!!!!

MCMethodDeclaration className: #MCMockClassD selector: #one category: #''as yet unclassified'' timeStamp: ''cwp 7/8/2003 21:21'' source: 
''one
	^ 1''!!!!
''
'
!

setUp
	stream _ RWBinaryOrTextStream on: String new.
	writer _ MCStWriter on: stream.
!

testClassDefinitionA
	writer visitClassDefinition: (self mockClassA asClassDefinition).
	self assertContentsOf: stream match: self expectedClassDefinitionA.
	stream reset.
	2 timesRepeat: [self assertChunkIsWellFormed: stream nextChunk]
!

testClassDefinitionB
	writer visitClassDefinition: (self mockClassB asClassDefinition).
	self assertContentsOf: stream match: self expectedClassDefinitionB.
	
!

testClassMethodDefinition
	writer visitMethodDefinition: (MethodReference class: self mockClassA class selector: #one) 									asMethodDefinition.
	self assertContentsOf: stream match: self expectedClassMethodDefinition.
	stream reset.
	self assert: stream nextChunk isAllSeparators.
	self assertChunkIsWellFormed: stream nextChunk.
	self assertMethodChunkIsWellFormed: stream nextChunk.
	self assert: stream nextChunk isAllSeparators 
!

testInitializerDefinition
	|chunk lastChunk|
	writer writeSnapshot: self mockSnapshot.
	stream reset.
	[stream atEnd] whileFalse:
		[chunk _ stream nextChunk.
		chunk isAllSeparators ifFalse: [lastChunk _ chunk]].
	self assertContentsOf: lastChunk readStream match: self expectedInitializerA
!

testMethodDefinition
	writer visitMethodDefinition: (MethodReference class: self mockClassA selector: #one) 									asMethodDefinition.
	self assertContentsOf: stream match: self expectedMethodDefinition.
	stream reset.
	self assert: stream nextChunk isAllSeparators.
	self assertChunkIsWellFormed: stream nextChunk.
	self assertMethodChunkIsWellFormed: stream nextChunk.
	self assert: stream nextChunk isAllSeparators 
!

testMethodDefinitionWithBangs
	writer visitMethodDefinition: (MethodReference 
									class: self class 
									selector: #methodWithBangs) asMethodDefinition.
	self assertContentsOf: stream match: self expectedMethodDefinitionWithBangs.
	stream reset.
	self assert: stream nextChunk isAllSeparators.
	self assertChunkIsWellFormed: stream nextChunk.
	self assertMethodChunkIsWellFormed: stream nextChunk.
	self assert: stream nextChunk isAllSeparators 
!

testOrganizationDefinition
	| definition |
	definition _ MCOrganizationDefinition categories: 
					(self mockPackage packageInfo systemCategories).
	writer visitOrganizationDefinition: definition.
	self assertContentsOf: stream match: self expectedOrganizationDefinition.
	self assertAllChunksAreWellFormed.
! !

!MCStWriterTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCStWriterTest.st,v 1.2 2013-05-29 00:01:58 vrany Exp $'
! !

