"{ Package: 'stx:goodies/monticello' }"

MCVersion subclass:#MCDiffyVersion
	instanceVariableNames:'base patch'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCDiffyVersion class methodsFor:'instance creation'!

package: aPackage info: aVersionInfo dependencies: aCollection baseInfo: baseVersionInfo patch:
aPatch
	^ self basicNew initializeWithPackage: aPackage info: aVersionInfo dependencies: aCollection baseInfo: baseVersionInfo patch:
aPatch
!

package: aPackage info: aVersionInfo snapshot: aSnapshot dependencies: aCollection baseVersion: aVersion
	^ self
		package: aPackage
		info: aVersionInfo
		dependencies: aCollection
		baseInfo: aVersion info
		patch: (aSnapshot patchRelativeToBase: aVersion snapshot)
! !

!MCDiffyVersion class methodsFor:'name utilities'!

baseNameFrom: diffName
	| baseId verName |
	baseId := (diffName copyAfter: $() copyUpTo: $).
	baseId ifEmpty: [^baseId].
	(baseId beginsWith: '@')
		ifTrue: [^baseId copyAfter: $@].
	verName := self verNameFrom: diffName.
	^(baseId includes: $.)
		ifTrue: [(verName copyUpToLast: $-), '-', baseId]
		ifFalse: [(verName copyUpToLast: $.), '.', baseId]
!

canonicalNameFor: aFileName
	^(self nameForVer: (self verNameFrom: aFileName)
		base: (self baseNameFrom: aFileName))
			, '.', MCMcdReader extension
!

nameForVer: versionName base: baseName
	| baseId |
	baseId := (versionName copyUpToLast: $.) = (baseName copyUpToLast: $.)
		ifTrue: [baseName copyAfterLast: $.]
		ifFalse: [(versionName copyUpToLast: $-) = (baseName copyUpToLast: $-)
			ifTrue: [baseName copyAfterLast: $-]
			ifFalse: ['@', baseName]].
	^ versionName, '(', baseId, ')'
!

verNameFrom: diffName
	^diffName copyUpTo: $(
! !

!MCDiffyVersion methodsFor:'as yet unclassified'!

baseInfo
	^ base
!

baseSnapshot
	^ (self workingCopy repositoryGroup versionWithInfo: base) snapshot
!

canOptimizeLoading
	"Answer whether I can provide a patch for the working copy without the usual diff pass"
	^ package hasWorkingCopy
		and: [package workingCopy modified not
			and: [package workingCopy ancestors includes: self baseInfo]]
!

fileName
	^ (self class nameForVer: info name base: base name), '.', self writerClass extension
!

initializeWithPackage: aPackage info: aVersionInfo dependencies: aCollection baseInfo: baseVersionInfo patch: aPatch
	patch _ aPatch.
	base _ baseVersionInfo.
	super initializeWithPackage: aPackage info: aVersionInfo snapshot: nil dependencies: aCollection.
!

isDiffy
	^ true
!

patch
	^ patch
!

snapshot
	^ snapshot ifNil: [snapshot _ MCPatcher apply: patch to: self baseSnapshot]
!

summary
	^ '(Diff against ', self baseInfo name, ')', String cr, super summary
!

writerClass
	^ MCMcdWriter
! !

!MCDiffyVersion class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDiffyVersion.st,v 1.3 2013-07-27 13:50:33 cg Exp $'
! !
