"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCMczInstallerTest
	instanceVariableNames:'expected diff'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCMczInstallerTest class methodsFor:'as yet unclassified'!

isAbstract
        ^ (Smalltalk classNamed: #MczInstaller) isNil

    "Modified: / 16-11-2006 / 16:43:59 / cg"
!

suite
	^ (Smalltalk hasClassNamed: #MczInstaller)
		ifTrue: [super suite]
		ifFalse: [TestSuite new name: self name asString]
! !

!MCMczInstallerTest methodsFor:'as yet unclassified'!

assertDict: dict matchesInfo: info
	#(name id message date time author)
		do: [:sel |  (info perform: sel) ifNotNilDo: [:i | dict at: sel ifPresent: [:d | self assert: i = d]]].
	info ancestors 
			with: (dict at: #ancestors) 
			do: [:i :d | self assertDict: d matchesInfo: i]
!

assertNoChange
	| actual |
	actual _ MCSnapshotResource takeSnapshot.
	diff _ actual patchRelativeToBase: expected snapshot.
	self assert: diff isEmpty
!

assertVersionInfoPresent
	| dict info |
	dict _ MczInstaller versionInfo at: self mockPackage name.
	info _ expected info.
	self assertDict: dict matchesInfo: info.
!

deleteFile
	(FileDirectory default fileExists: self fileName)
		ifTrue: [FileDirectory default deleteFileNamed: self fileName]
!

fileName
	^ 'InstallerTest.mcz'
!

fileStream
	^ FileStream forceNewFileNamed: self fileName.
!

setUp
	expected _ self mockVersion.
	self change: #one toReturn: 2.
!

tearDown
	expected snapshot updatePackage: self mockPackage.
	self deleteFile.
!

testInstallFromFile
	MCMczWriter fileOut: expected on: self fileStream.
	MczInstaller installFileNamed: self fileName.
	self assertNoChange.
!

testInstallFromStream
	| stream |
	stream _ RWBinaryOrTextStream on: String new.
	MCMczWriter fileOut: expected on: stream.
	MczInstaller installStream: stream reset.
	self assertNoChange.
	self assertVersionInfoPresent.
	
! !

!MCMczInstallerTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCMczInstallerTest.st,v 1.2 2013-05-28 23:59:55 vrany Exp $'
! !

