"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCVersionSorter
	instanceVariableNames:'layers depthIndex depths stepparents roots'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCVersionSorter class methodsFor:'as yet unclassified'!

new
	^ self basicNew initialize
! !

!MCVersionSorter methodsFor:'as yet unclassified'!

addAllAncestorsOf: aVersionInfo to: aSet
	(aSet includes: aVersionInfo) ifTrue: [^ self].
	aSet add: aVersionInfo.
	(self knownAncestorsOf: aVersionInfo) do:
		[:ea |
		self addAllAncestorsOf: ea to: aSet]
!

addAllVersionInfos: aCollection
	aCollection do: [:ea | self addVersionInfo: ea]
!

addToCurrentLayer: aVersionInfo
	| layer |
	layer _ layers at: depthIndex.
	(layer includes: aVersionInfo) ifFalse:
		[depths at: aVersionInfo ifPresent:
			[:i |
			i < depthIndex
				ifTrue: [(layers at: i) remove: aVersionInfo]
				ifFalse: [^ false]].
		layer add: aVersionInfo.
		depths at: aVersionInfo put: depthIndex.
		^ true].
	^ false 
!

addVersionInfo: aVersionInfo
	roots add: aVersionInfo.
	self registerStepChildrenOf: aVersionInfo seen: Set new
!

allAncestorsOf: aVersionInfo
	| all |
	all _ Set new.
	self addAllAncestorsOf: aVersionInfo to: all.
	^ all
!

initialize
	stepparents _ Dictionary new.
	roots _ OrderedCollection new.
!

knownAncestorsOf: aVersionInfo
	^ aVersionInfo ancestors, (self stepParentsOf: aVersionInfo) asArray
!

layers
	^ layers
!

popLayer
	depthIndex _ depthIndex - 1
!

processVersionInfo: aVersionInfo
	(self addToCurrentLayer: aVersionInfo) ifTrue:
		[self pushLayer.
		(self knownAncestorsOf: aVersionInfo) do: [:ea | self processVersionInfo: ea].
		self popLayer]
!

pushLayer
	depthIndex _ depthIndex + 1.
	depthIndex > layers size ifTrue: [layers add: OrderedCollection new].
	
!

registerStepChildrenOf: aVersionInfo seen: aSet
	(aSet includes: aVersionInfo) ifTrue: [^ self].
	aSet add: aVersionInfo.
	aVersionInfo stepChildren do: [:ea | (self stepParentsOf: ea) add: aVersionInfo].
	aVersionInfo ancestors do: [:ea | self registerStepChildrenOf: ea seen: aSet].
!

sortedVersionInfos
	layers _ OrderedCollection with: OrderedCollection new.
	depthIndex _ 1.
	depths _ Dictionary new.
	roots do: [:ea | self processVersionInfo: ea].
	^ layers gather: [:ea | ea]
!

stepParentsOf: aVersionInfo
	^ (stepparents at: aVersionInfo ifAbsentPut: [Set new])
! !

!MCVersionSorter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionSorter.st,v 1.2 2012-09-11 21:31:08 cg Exp $'
! !
