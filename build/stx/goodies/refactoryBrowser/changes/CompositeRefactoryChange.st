"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryChange subclass:#CompositeRefactoryChange
	instanceVariableNames:'changes'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!

CompositeRefactoryChange comment:'RefactoryBuilder represents a series of changes (RefactoryChange) that need to be performed. It provides transaction-like behavior by defering all changes until it is told to commit them (#doIt).

Instance Variables:
	changes	<SequenceableCollection of: RefactoryChange>	the changes that need to be performed'
!


!CompositeRefactoryChange class methodsFor:'instance creation'!

named: aString 
	^(self new)
		name: aString;
		yourself
! !

!CompositeRefactoryChange methodsFor:'accessing'!

addChange: aRefactoryChange 
	changes add: aRefactoryChange.
	^aRefactoryChange
!

addChangeFirst: aRefactoryChange 
	changes addFirst: aRefactoryChange.
	^aRefactoryChange
!

changeForClass: aRBClass selector: aSelector 
	changes reverseDo: 
			[:each | 
			| change |
			change := each changeForClass: aRBClass selector: aSelector.
			change notNil ifTrue: [^change]].
	^nil
!

changeForMetaclass: aSymbol selector: aSelector 
	changes reverseDo: 
			[:each | 
			| change |
			change := each changeForMetaclass: aSymbol selector: aSelector.
			change notNil ifTrue: [^change]].
	^nil
!

changesSize
	^changes inject: 0 into: [:sum :each | sum + each changesSize]
!

problemCount
	^self changesSize
!

removed

    ^changes allSatisfy: [:e|e removed]
!

removed: aBoolean

    changes do:[:e|e removed: aBoolean]
!

renameChangesForClass: aClassName to: newClassName 
	^(self copy)
		changes: (self changes 
					collect: [:each | each renameChangesForClass: aClassName to: newClassName]);
		yourself
! !

!CompositeRefactoryChange methodsFor:'comparing'!

= aRefactoryBuilder 
	self class = aRefactoryBuilder class ifFalse: [^false].
	changes size = aRefactoryBuilder changes size ifFalse: [^false].
	changes with: aRefactoryBuilder changes
		do: [:each :change | each = change ifFalse: [^false]].
	^true
!

hash
	^changes size
! !

!CompositeRefactoryChange methodsFor:'copying'!

postCopy
	super postCopy.
	changes := changes collect: [:each | each copy]
! !

!CompositeRefactoryChange methodsFor:'enumerating'!

do: aBlock
    "Enumerates all changes evaluation aBlock for each"

    (changes ? #()) do:[:each|each do: aBlock].

    "Created: / 04-02-2012 / 21:19:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompositeRefactoryChange methodsFor:'initialization & release'!

initialize
	super initialize.
	changes := OrderedCollection new
! !

!CompositeRefactoryChange methodsFor:'printing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    aGCOrStream emphasis:#bold.
    super displayOn:aGCOrStream.
    aGCOrStream emphasis:nil.
!

printOn: aStream 
   aStream nextPutAll:(name ? 'unnamed composite change')

    "Modified: / 05-07-2011 / 14:57:19 / cg"
! !

!CompositeRefactoryChange methodsFor:'private'!

executeNotifying: aBlock 
	| undos undo |
	undos := changes collect: [:each | each executeNotifying: aBlock].
	undo := self copy.
	undo changes: undos reverse.
	^undo
!

flattenOnto: aCollection 
	changes do: [:each | each flattenOnto: aCollection]
! !

!CompositeRefactoryChange methodsFor:'private-inspector accessing'!

changes
	^changes
!

changes: aCollection 
	changes := aCollection
!

removeChange: aChange 
	changes remove: aChange ifAbsent: []
! !

!CompositeRefactoryChange methodsFor:'queries'!

shouldBeConfimed
    <resource: #obsolete>
    ^self shouldBeConfirmed

    "Created: / 08-07-2011 / 10:59:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-08-2011 / 17:28:39 / cg"
    "Modified: / 04-04-2012 / 16:30:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldBeConfirmed
    "Return true, if the refactoring change should be confirmed
     before applying - makes sense only if UserPreferences current confirmRefactorings
     is on."

    "A very naive way, cetrainly requires some tuning. 
     Unfortunately, all more complex refactorings are plain
     CompositeRefactorings, sigh"

    "Single change is fine, no need to confirm"
    self changesSize < 2 ifTrue:[^false].

    "We don't want to confirm accessors!!"
    (self name includesString: 'Accessors') ifTrue:[^false].

    ^changes anySatisfy:[:change|
        change isCompositeChange ifTrue:[
            change shouldBeConfirmed
        ] ifFalse:[
            change isMethodCodeChange
        ].
    ]

    "Created: / 04-04-2012 / 14:11:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompositeRefactoryChange methodsFor:'refactory-changes'!

addClassVariable: variableName to: aClass 
	^self addChange: (AddClassVariableChange add: variableName to: aClass)
!

addInstanceVariable: variableName to: aClass 
	^self addChange: (AddInstanceVariableChange add: variableName to: aClass)
!

addPool: aPoolVariable to: aClass 
	^self addChange: (AddPoolVariableChange add: aPoolVariable to: aClass)
!

changeCategoryOf: aSymbol in: aClass to:newCategory
        ^self addChange: (RefactoryMethodCategoryChange changeCategoryOf: aSymbol in: aClass to:newCategory)
!

changeClassCategoryOf:aClass to:newCategory
        ^self addChange: (RefactoryClassCategoryChange changeCategoryOf:aClass to:newCategory)
!

changeProjectOf: aSymbol in: aClass to:newProject
        ^self addChange: (RefactoryMethodProjectChange changeProjectOf:aSymbol in:aClass to:newProject)
!

compile: source in: class 
	^self addChange: (AddMethodChange compile: source in: class)
!

compile: source in: class classified: aProtocol 
	^self addChange: (AddMethodChange 
				compile: source
				in: class
				classified: aProtocol)
!

defineClass: aString 
	^self addChange: (AddClassChange definition: aString)
!

removeClass: aClass 
	^self addChange: (RemoveClassChange removeClassName: aClass name)
!

removeClassNamed: aSymbol 
	self addChange: (RemoveClassChange removeClassName: aSymbol)
!

removeClassVariable: variableName from: aClass 
	^self 
		addChange: (RemoveClassVariableChange remove: variableName from: aClass)
!

removeInstanceVariable: variableName from: aClass 
	^self 
		addChange: (RemoveInstanceVariableChange remove: variableName from: aClass)
!

removeMethod: aSelector from: aClass 
	^self addChange: (RemoveMethodChange remove: aSelector from: aClass)
!

renameClass: class to: newName 
	^self addChange: (RenameClassChange rename: class name to: newName)
! !

!CompositeRefactoryChange methodsFor:'testing'!

isComplexRefactoryChange

    ^changes size > 1

    "Created: / 26-11-2008 / 11:56:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isCompositeChange

    ^true

    "Created: / 26-11-2008 / 11:34:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isCompositeRefactoryChange

    ^true

    "Created: / 26-11-2008 / 11:34:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isOrContainsClassDefinitionChange
    ^ changes contains:[:chg | chg isOrContainsClassDefinitionChange]

    "Created: / 21-02-2014 / 22:45:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompositeRefactoryChange methodsFor:'user interface'!

inspect

    ^super inspect

    "
        CompositeRefactoryChangeInspector openOn: self
    "
! !

!CompositeRefactoryChange methodsFor:'utilities'!

condenseChangesForRemoved

    changes := 
        changes reject:
            [:chg|
            chg isCompositeChange ifTrue:[chg condenseChangesForRemoved].
            chg removed]
! !

!CompositeRefactoryChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/CompositeRefactoryChange.st,v 1.22 2014-02-22 23:37:32 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/CompositeRefactoryChange.st,v 1.22 2014-02-22 23:37:32 vrany Exp $'
! !

