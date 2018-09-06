"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MCAncestry
	instanceVariableNames:'ancestors stepChildren'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!

MCAncestry comment:'Abstract superclass of records of ancestry.'
!


!MCAncestry class methodsFor:'as yet unclassified'!

new
	^ self basicNew initialize
! !

!MCAncestry methodsFor:'ancestry'!

allAncestorsDo: aBlock
	self ancestors do:
		[:ea |
		aBlock value: ea.
		ea allAncestorsDo: aBlock]
!

allAncestorsOnPathTo: aVersionInfo
	^ MCFilteredVersionSorter new
		target: aVersionInfo;
		addAllVersionInfos: self ancestors;
		sortedVersionInfos
!

ancestorString
	^ String streamContents:
		[:s | self ancestors do: [:ea | s nextPutAll: ea name] separatedBy: [s nextPutAll: ', ']]
!

ancestors
        ^ ancestors isNil ifTrue: [#()] ifFalse:[ancestors]

    "Modified: / 07-09-2015 / 15:45:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ancestorsDoWhileTrue: aBlock
	self ancestors do:
		[:ea |
		(aBlock value: ea) ifTrue: 
			[ea ancestorsDoWhileTrue: aBlock]]
!

breadthFirstAncestors
	^ Array streamContents: [:s | self breadthFirstAncestorsDo: [:ea | s nextPut: ea]]
!

breadthFirstAncestorsDo: aBlock
	| seen todo next |
	seen _ Set with: self.
	todo _ OrderedCollection with: self.
	[todo isEmpty] whileFalse:
		[next _ todo removeFirst.
		next ancestors do:
			[:ea |
			(seen includes: ea) ifFalse:
				[aBlock value: ea.
				seen add: ea.
				todo add: ea]]]
!

commonAncestorWith: aNode
	| commonAncestors |
	commonAncestors _ self commonAncestorsWith: aNode.
	^ commonAncestors at: 1 ifAbsent: [nil]
!

commonAncestorsWith: aVersionInfo

	| sharedAncestors mergedOrder sorter |
	sorter _ MCVersionSorter new
						addVersionInfo: self;
						addVersionInfo: aVersionInfo.
	mergedOrder _ sorter sortedVersionInfos.
	sharedAncestors _ (sorter allAncestorsOf: self) intersection: (sorter allAncestorsOf: aVersionInfo).
	^ mergedOrder select: [:ea | sharedAncestors includes: ea]
!

hasAncestor: aVersionInfo
	^ self
		hasAncestor: aVersionInfo
		alreadySeen: OrderedCollection new
!

hasAncestor: aVersionInfo alreadySeen: aList
	(aList includes: self) ifTrue: [^ false].
	aList add: self.

	^ self = aVersionInfo or: [self ancestors anySatisfy: [:ea | ea hasAncestor: aVersionInfo alreadySeen: aList]]
!

isRelatedTo: aVersionInfo
	^ aVersionInfo timeStamp < self timeStamp
		ifTrue: [self hasAncestor: aVersionInfo]
		ifFalse: [aVersionInfo hasAncestor: self]
!

stepChildren
	^ stepChildren ifNil: [#()]
!

stepChildrenString
	^ String streamContents:
		[:s | self stepChildren do: [:ea | s nextPutAll: ea name] separatedBy: [s nextPutAll: ', ']]
!

topologicalAncestors
	| frontier f |
	^ Array streamContents:
		[:s |
		frontier _ MCFrontier frontierOn: self.
		[f _ frontier frontier.
		s nextPutAll: f.
		frontier removeAll: f.
		f isEmpty] whileFalse] 
!

trimAfterVersionInfo: aVersionInfo
	aVersionInfo = self
		ifTrue: [ancestors _ #()]
		ifFalse:
			[aVersionInfo date <= self date ifTrue:
				[ancestors do: [:ea | ea trimAfterVersionInfo: aVersionInfo]]
		]
!

withBreadthFirstAncestors
	^ (Array with: self), self breadthFirstAncestors
! !

!MCAncestry methodsFor:'initializing'!

initialize
	ancestors _ #().
	stepChildren _ #()
! !

!MCAncestry class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCAncestry.st,v 1.2 2012-09-11 21:20:19 cg Exp $'
! !

