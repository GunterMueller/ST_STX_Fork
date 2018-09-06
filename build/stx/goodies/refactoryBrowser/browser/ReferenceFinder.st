"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

Object subclass:#ReferenceFinder
	instanceVariableNames:'backlinks objectsLeft testBlock foundBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Browser'
!


!ReferenceFinder class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
! !

!ReferenceFinder class methodsFor:'accessing'!

findAllPathsTo: anObject 
	"self findAllPathsTo: (Object compiledMethodAt: #printString)"

	^self findAllPathsTo: anObject from: Smalltalk
!

findAllPathsTo: anObject from: fromObject 
	"self findAllPathsTo: (Object compiledMethodAt: #printString) from: Object"

	^(self new)
		startFrom: fromObject;
		findAllPaths: [:each | each == anObject]
!

findAllPathsToInstanceOf: aBehavior 
	"self findAllPathsToInstanceOf: RefactoringBrowser"

	^self findAllPathsToInstanceOf: aBehavior from: Smalltalk
!

findAllPathsToInstanceOf: aBehavior from: fromObject 
	"self findAllPathsToInstanceOf: RefactoringBrowser from: ScheduledControllers"

	^(self new)
		startFrom: fromObject;
		findAllPaths: [:each | each class == aBehavior]
!

findPathTo: anObject 
	^self findPathTo: anObject from: Smalltalk
!

findPathTo: anObject from: fromObject 
	"self findPathTo: RefactoringManager instance from: Object"

	^(self new)
		startFrom: fromObject;
		findPath: [:each | each == anObject]
!

findPathToInstanceOf: aBehavior 
	^self findPathToInstanceOf: aBehavior from: Smalltalk
!

findPathToInstanceOf: aBehavior from: fromObject 
	"self findPathToInstanceOf: RefactoringManager from: Object"

	^(self new)
		startFrom: fromObject;
		findPath: [:each | each class == aBehavior]
! !

!ReferenceFinder methodsFor:'accessing'!

findAllPaths: aBlock 
	| paths |
	paths := OrderedCollection new.
	foundBlock := [:path | paths add: path].
	testBlock := aBlock.
	self find.
	^paths
!

findPath: aBlock 
	foundBlock := [:path | ^path].
	testBlock := aBlock.
	self find.
	^nil
! !

!ReferenceFinder methodsFor:'initialize-release'!

initialize
	self startFrom: Smalltalk
!

startFrom: anObject 
	backlinks := OrderedCollection new.
	self addBacklinkLevel.
	objectsLeft := OrderedCollection with: anObject.
	backlinks last at: anObject put: nil
! !

!ReferenceFinder methodsFor:'private'!

addBacklinkFrom: newObject to: anObject 
	backlinks last at: newObject put: anObject
!

addBacklinkLevel
	backlinks add: self identityDictionaryClass new
!

backlinkFor: anObject 
	| toObject |
	backlinks do: 
			[:each | 
			toObject := each at: anObject ifAbsent: [nil].
			toObject notNil ifTrue: [^toObject]].
	^nil
!

computePathFor: anObject 
	| path object |
	path := OrderedCollection new.
	object := anObject.
	[object isNil] whileFalse: 
			[path add: object.
			object := self backlinkFor: object].
	^path reverse
!

find
	self searchForObject
!

hasSearched: newObject 
	^(backlinks detect: [:each | each includesKey: newObject] ifNone: [nil]) 
		notNil
!

identityDictionaryClass
	^IdentityDictionary
!

printToDoNotice
	Transcript
		show: 'Level ';
		show: backlinks size printString;
		show: ' with ';
		show: objectsLeft size printString;
		show: ' objects to search';
		cr
!

processLinkTo: newObject from: anObject 
	newObject class instSize + newObject basicSize = 0 
		ifTrue: 
			[^(testBlock value: newObject) 
				ifTrue: 
					[(self computePathFor: anObject)
						add: newObject;
						yourself]
				ifFalse: [nil]].
	(self hasSearched: newObject) 
		ifFalse: 
			[(testBlock value: newObject) 
				ifTrue: 
					[^(self computePathFor: anObject)
						add: newObject;
						yourself].
			objectsLeft add: newObject.
			self addBacklinkFrom: newObject to: anObject].
	^nil
!

searchForObject
        
	[| objects |
	self printToDoNotice.
	objects := objectsLeft.
	objectsLeft := OrderedCollection new.
	self addBacklinkLevel.
	objects do: 
			[:each | 
			| path |
			(path := self searchVariablesIn: each) notNil 
				ifTrue: [foundBlock value: path].
			(path := self searchIndicesIn: each) notNil 
				ifTrue: [foundBlock value: path]].
	objectsLeft isEmpty] 
			whileFalse: []
!

searchIndicesIn: anObject
        anObject == Smalltalk ifTrue:[
            ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
                " special case for the Smalltalk dictionary "
                Smalltalk keysAndValuesDo:[:key :val |
                    | path |
                    (path := self processLinkTo:key from:anObject) notNil 
                            ifTrue: [^path].
                    (path := self processLinkTo:val from:anObject) notNil 
                            ifTrue: [^path].
                ].
            ]        
        ].
        1 to: anObject basicSize
                do: 
                        [:i | 
                        | path |
                        (path := self processLinkTo: (anObject basicAt: i) from: anObject) notNil 
                                ifTrue: [^path]].
        ^nil
!

searchVariablesIn: anObject 
	1 to: anObject class instSize
		do: 
			[:i | 
			| path |
			(path := self processLinkTo: (anObject instVarAt: i) from: anObject) 
				notNil ifTrue: [^path]].
	^nil
! !

!ReferenceFinder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/ReferenceFinder.st,v 1.6 2012-11-05 21:00:51 cg Exp $'
! !
