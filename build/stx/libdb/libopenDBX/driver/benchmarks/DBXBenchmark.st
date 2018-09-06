"{ Package: 'stx:libdb/libopenDBX/driver/benchmarks' }"

Object subclass:#DBXBenchmark
	instanceVariableNames:'times mutex querySetting benchPriority'
	classVariableNames:'Facility'
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverBenchmarks'
!


!DBXBenchmark class methodsFor:'accessing'!

facility
	^ Facility ifNil: [ Facility := self defaultFacility ]
!

facility: anObject
	Facility := anObject
! !

!DBXBenchmark class methodsFor:'defaults'!

defaultFacility
	^DBXPostgreFacility facilityForBenchmark
!

defaultInserts
	^800
!

defaultRows
	^10
!

defaultRuns
	^10
! !

!DBXBenchmark methodsFor:'accessing'!

benchPriority
	^ benchPriority
!

benchPriority: anObject
	benchPriority := anObject
!

facility
	^self class facility
!

log: aString
	Transcript show: aString; cr.
!

querySetting
	^ querySetting ifNil: [ DBXQuerySettings default ] ifNotNil: [ querySetting ].
!

querySetting: anObject
	querySetting := anObject
!

runs
	^self class defaultRuns 
! !

!DBXBenchmark methodsFor:'initialization'!

initialize
	super initialize.
	mutex := Monitor new. 
!

initializeDatabase
	| conn |
	conn := self createDbxConnection.
	self prepareData: conn rows: 10.
	self prepareData: conn rows: 100.
	self prepareData: conn rows: 1000.
	self prepareData: conn rows: 10000.
	self prepareInsert: conn.
	conn close.
!

prepareData: aConnection rows: aNumber
	[ aConnection execute: 'DROP TABLE tiny_benchmark_', aNumber asString ]
	on: DBXError do: [ :e | "DROP fails" ].
	
		(self facility tinyBenchmarkScript: aNumber)
		do: [:script | aConnection execute: script].
	
!

prepareInsert: aConnection
	[ aConnection execute: 'DROP TABLE tiny_benchmark_insert' ]
	on: DBXError do: [ :e | "DROP fails" ].

	(self facility tinyBenchmarkScript)
		do: [:script | aConnection execute: script].
! !

!DBXBenchmark methodsFor:'private'!

collect: aBlock
	self runs timesRepeat: [
		| timeExpended |
		timeExpended := MessageTally time: aBlock.
		mutex critical: [ times add: timeExpended ]]
!

collectedTimeAverage
	^((times inject: 0 into: [ :v :each | v + each ]) / self class defaultRuns) asFloat
!

createDbxConnection
	| connection |
	connection := DBXConnection
		platform: self facility platform
		settings: self facility connectionSettings.
	connection connect.
	connection open.
	
	^connection
!

findBenchmarks
	^self class allSelectors asSortedCollection asOrderedCollection select: [:each | 
		('benchmark*' match: each) and: [each numArgs isZero]]
!

performIfExists: aSelector
	(self class allSelectors includes: aSelector)
		ifTrue: [ self perform: aSelector ]
!

prepareCollector
	times := OrderedCollection new.
	
! !

!DBXBenchmark methodsFor:'running'!

run: aSelector
	self prepareCollector.
	self setUp.
	self setUpFor: aSelector.
	self collect: [ self perform: aSelector ].
	self tearDownFor: aSelector.
	self tearDown.
	mutex critical: [
		self log: aSelector, ': ', self collectedTimeAverage asString, ' AVG' ].
!

runAll
	self log: 'Benchmarking: ', self class name, ' (', self runs asString, ' runs)'.
	self findBenchmarks do: [ :each | 
		self run: each ].
!

runAll: aQuerySetting
	self querySetting: aQuerySetting.
	self runAll.
!

runAllForked
	self log: 'Benchmarking: ', self class name, ' (', self runs asString, ' runs)'.
	self findBenchmarks do: [ :each | 
		self runForked: each ].
!

runAllForked: aPriorityNumber
	self benchPriority: aPriorityNumber.
	self log: 'Benchmarking: ', self class name, ' (', self runs asString, ' runs)'.
	self findBenchmarks do: [ :each | 
		self runForked: each priority: aPriorityNumber ].
!

runAllForked: aPriorityNumber querySetting: aQuerySetting
	self querySetting: aQuerySetting.
	self log: 'Benchmarking: ', self class name, ' (', self runs asString, ' runs)'.
	self findBenchmarks do: [ :each | 
		self runForked: each priority: aPriorityNumber].
!

runForked: aSelector
	self benchPriority: Processor userBackgroundPriority.
	self runForked: aSelector priority: self benchPriority.
!

runForked: aSelector priority: aPriorityNumber
	[ self run: aSelector ] forkAt: aPriorityNumber.
!

setUp
	
!

setUpFor: aSelector
	self performIfExists: ('setUp', aSelector capitalized) asSymbol
!

tearDown
!

tearDownFor: aSelector
	self performIfExists: ('tearDown', aSelector capitalized) asSymbol
! !

!DBXBenchmark class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/DBXBenchmark.st,v 1.2 2013-04-15 13:12:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/DBXBenchmark.st,v 1.2 2013-04-15 13:12:49 cg Exp $'
! !

