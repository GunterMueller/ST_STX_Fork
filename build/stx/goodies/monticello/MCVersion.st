"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCVersion
	instanceVariableNames:'package info snapshot dependencies cachable'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCVersion class methodsFor:'instance creation'!

package: aPackageOrPackageID
	aPackageOrPackageID isSymbol ifTrue:[
	    "/ an ST/X package-ID
	    ^ super package: aPackageOrPackageID
	].
	"/ a monticello package-ID
	^ self package: aPackageOrPackageID info: MCVersionInfo new

    "Modified: / 22-11-2006 / 14:16:22 / cg"
!

package: aPackage info: aVersionInfo
	^ self package: aPackage info: aVersionInfo snapshot: aPackage snapshot
!

package: aPackage info: aVersionInfo snapshot: aSnapshot
	^ self package: aPackage info: aVersionInfo snapshot: aSnapshot dependencies: #()
!

package: aPackage info: aVersionInfo snapshot: aSnapshot dependencies: aCollection
	^ self new initializeWithPackage: aPackage info: aVersionInfo snapshot: aSnapshot dependencies: aCollection
! !

!MCVersion methodsFor:'accessing'!

cachable:something
    cachable := something.
!

changes
	^ self snapshot patchRelativeToBase: package snapshot
!

dependencies
	^ dependencies ifNil: [#()]
!

fileName
    |rawName cookedName legalName|

    rawName := info name.
    cookedName := rawName copy replaceAny:'/:' with:$_.
    legalName := cookedName asFilename makeLegalFilename name.
    ^ legalName, '.', self writerClass extension

    "Modified: / 24-07-2012 / 16:30:13 / cg"
!

info
	^ info
!

info: anMCAncestry
    info := anMCAncestry.

    "Modified (format): / 07-06-2013 / 01:01:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package
	^ package
!

snapshot
	^ snapshot
!

snapshot:anMCSnapshot
   snapshot := anMCSnapshot

    "Created: / 02-12-2011 / 16:10:18 / cg"
!

summary
	^ String streamContents:
		[:s |
		s nextPutAll: info summaryHeader.
		(dependencies isNil or: [dependencies isEmpty]) ifFalse:
			[s cr; nextPutAll: 'Dependencies: '.
			dependencies
				do: [:ea | s nextPutAll: ea versionInfo name]
				separatedBy: [s nextPutAll: ', ']].
		s cr; cr; nextPutAll: info message]
!

workingCopy
	^ package workingCopy
!

writerClass
    Smalltalk isSmalltalkX ifTrue:[
	^ MCStxMczWriter
    ] ifFalse:[
	^ MCMczWriter
    ]
! !

!MCVersion methodsFor:'actions'!

addToCache
	MCCacheRepository default storeVersion: self
!

adopt
	self workingCopy adopt: self
!

browse
	(MCSnapshotBrowser forSnapshot: self snapshot)
		showLabelled: 'Snapshot of ', self fileName
!

fileOutOn: aStream
	self writerClass fileOut: self on: aStream
!

load
	MCVersionLoader loadVersion: self
!

merge
	MCVersionMerger mergeVersion: self
!

open
	(MCVersionInspector new version: self) show
! !

!MCVersion methodsFor:'converting'!

asDiffAgainst: aVersion
	aVersion info = self info ifTrue: [self error: 'Cannot diff against self!!'].
	^ MCDiffyVersion
		package: self package
		info: self info
		snapshot: self snapshot
		dependencies: self dependencies
		baseVersion: aVersion
! !

!MCVersion methodsFor:'enumerating'!

allAvailableDependenciesDo: aBlock
	| version |
	self dependencies do:
		[:ea |
		[version _ ea resolve.
		version allAvailableDependenciesDo: aBlock.
		aBlock value: version]
			on: Error do: []]
!

allDependenciesDo: aBlock
	self allDependenciesDo: aBlock ifUnresolved: [:ignored | true]
!

allDependenciesDo: aBlock ifUnresolved: failBlock
	| dict |
	dict _ Dictionary new.
	self allDependenciesNotIn: dict do: aBlock ifUnresolved: failBlock
!

allDependenciesNotIn: aDictionary do: aBlock ifUnresolved: failBlock
	| version |
	self dependencies do:
		[:ea |
		version := aDictionary at: ea ifAbsent: [ea resolve].
		version
			ifNil: [failBlock value: ea]
			ifNotNil: [(aDictionary includes: version) ifFalse:
						[aDictionary at: ea put: version.
						version
							allDependenciesNotIn: aDictionary
							do: aBlock
							ifUnresolved: failBlock.
						aBlock value: version]]]
!

withAllDependenciesDo: aBlock
	self allDependenciesDo: aBlock ifUnresolved: [:ignored].
	aBlock value: self
!

withAllDependenciesDo: aBlock ifUnresolved: failBlock
	| dict |
	dict _ Dictionary new.
	self allDependenciesNotIn: dict do: aBlock ifUnresolved: failBlock.
	aBlock value: self
! !

!MCVersion methodsFor:'initialize-release'!

initializeWithPackage: aPackage info: aVersionInfo snapshot: aSnapshot dependencies: aCollection
	package _ aPackage.
	info _ aVersionInfo.
	snapshot _ aSnapshot.
	dependencies _ aCollection.
	self addToCache.
!

setPackage: aPackage info: aVersionInfo snapshot: aSnapshot dependencies: aCollection
	package _ aPackage.
	info _ aVersionInfo.
	snapshot _ aSnapshot.
	dependencies _ aCollection
! !

!MCVersion methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self info name.
	aStream nextPut: $).
! !

!MCVersion methodsFor:'testing'!

canOptimizeLoading
	"Answer whether I can provide a patch for the working copy without the usual diff pass"
	^false
!

isCacheable
	^ cachable ? true
!

isDiffy
	^ false
! !

!MCVersion class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersion.st,v 1.10 2013-07-27 13:50:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersion.st,v 1.10 2013-07-27 13:50:54 cg Exp $'
! !

