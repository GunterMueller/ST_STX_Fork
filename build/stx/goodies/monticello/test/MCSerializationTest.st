"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCSerializationTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCSerializationTest methodsFor:'asserting'!

assertClass: readerClass providesServices: labels
	| services suffix |
	suffix _ readerClass extension.
	self assert: (FileList isReaderNamedRegistered: readerClass name).
	services _ readerClass fileReaderServicesForFile: 'foo' suffix: suffix.
	self assert: ((services collect: [:service | service buttonLabel]) includesAllOf: labels)
!

assertDependenciesMatchWith: writerClass
	| stream readerClass expected actual |
	readerClass _ writerClass readerClass.
	expected _ self mockVersionWithDependencies.
	stream _ RWBinaryOrTextStream on: String new.
	writerClass fileOut: expected on: stream.
	actual _ (readerClass on: stream reset) dependencies.
	self assert: actual = expected dependencies.
!

assertExtensionProvidedBy: aClass
	self shouldnt: [aClass readerClass extension] raise: Exception.
!

assertSnapshotsMatchWith: writerClass
	| readerClass expected stream actual |
	readerClass _ writerClass readerClass.
	expected _ self mockSnapshot.
	stream _ RWBinaryOrTextStream on: String new.
	(writerClass on: stream) writeSnapshot: expected.
	actual _ readerClass snapshotFromStream: stream reset.
	self assertSnapshot: actual matches: expected.
!

assertVersionInfosMatchWith: writerClass
	| stream readerClass expected actual |
	readerClass _ writerClass readerClass.
	expected _ self mockVersion.
	stream _ RWBinaryOrTextStream on: String new.
	writerClass fileOut: expected on: stream.
	actual _ readerClass versionInfoFromStream: stream reset.
	self assert: actual = expected info.
!

assertVersionsMatchWith: writerClass
	| stream readerClass expected actual |
	readerClass _ writerClass readerClass.
	expected _ self mockVersion.
	stream _ RWBinaryOrTextStream on: String new.
	writerClass fileOut: expected on: stream.
	actual _ readerClass versionFromStream: stream reset.
	self assertVersion: actual matches: expected.
! !

!MCSerializationTest methodsFor:'mocks'!

mockDiffyVersion
	| repos workingCopy base next |
	repos _ MCDictionaryRepository new.
	workingCopy _ MCWorkingCopy forPackage: self mockPackage.
	workingCopy repositoryGroup addRepository: repos.
	MCRepositoryGroup default removeRepository: repos.
	base _ self mockVersion.
	repos storeVersion: base.
	self change: #a toReturn: 'a2'.
	next _ self mockVersionWithAncestor: base.
	^ next asDiffAgainst: base	
! !

!MCSerializationTest methodsFor:'testing'!

testMcdSerialization
	| stream expected actual |
	expected _ self mockDiffyVersion.
	stream _ RWBinaryOrTextStream on: String new.
	MCMcdWriter fileOut: expected on: stream.
	actual _ MCMcdReader versionFromStream: stream reset.
	self assertVersion: actual matches: expected.
!

testMczSerialization
	self assertVersionsMatchWith: MCMczWriter.
	self assertExtensionProvidedBy: MCMczWriter.
	self assertVersionInfosMatchWith: MCMczWriter.
	self assertDependenciesMatchWith: MCMczWriter.
!

testStSerialization
	self assertSnapshotsMatchWith: MCStWriter.
! !

!MCSerializationTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCSerializationTest.st,v 1.2 2013-05-29 00:02:33 vrany Exp $'
! !

