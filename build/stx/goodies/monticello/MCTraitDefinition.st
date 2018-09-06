"{ Package: 'stx:goodies/monticello' }"

MCClassDefinition subclass:#MCTraitDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCTraitDefinition class methodsFor:'as yet unclassified'!

name: classNameString traitComposition:  traitCompositionString category:  categoryString comment:  commentString commentStamp:   commentStamp
	^ self instanceLike:
		(self new initializeWithName: classNameString 
			traitComposition:  traitCompositionString
			category:  categoryString
			comment:  commentString  
			commentStamp:   commentStamp)

! !

!MCTraitDefinition methodsFor:'accessing'!

classTraitCompositionString
	^self traitComposition ifNil: ['{}'].
! !

!MCTraitDefinition methodsFor:'comparing'!

hash
	| hash |
	hash := String stringHash: name initialHash: 0.
	hash := String stringHash: self traitCompositionString initialHash: hash.
	hash := String stringHash: (category ifNil: ['']) initialHash: hash.
	^ hash

!

requirements
        "Assuming that traits in a composition can be identified by
        testing for the first character beeing an uppercase character
        (and thus not a special character such as {, # etc.)"

        | tokens traitNames |
        self hasTraitComposition ifFalse: [ ^Array new ].
        tokens := Scanner new scanTokens: self traitComposition.
        traitNames := tokens select: [:each | each isString and:[each first isUppercase]].
        ^traitNames asArray
! !

!MCTraitDefinition methodsFor:'converting'!

asChange
    ^TraitDefinitionChange new
        mcDefinition: self;
        baseTrait: superclassName;
        traitComposition: traitComposition;
        className: name;
        category: category;
        yourself
! !

!MCTraitDefinition methodsFor:'initializing'!

initializeWithName: classNameString 
        traitComposition:  traitCompositionString
        category:  categoryString
        comment:  commentString  
        commentStamp:   commentStampString
                                        
                name := classNameString asSymbol.
                traitComposition := traitCompositionString.
             category := categoryString.
                comment := commentString asStringWithSqueakLineEndings.
                commentStamp :=  commentStampString ifNil: [self defaultCommentStamp]

    "Modified: / 12-09-2010 / 16:06:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCTraitDefinition methodsFor:'installing'!

load
	| trait |
	(trait := self createClass) ifNotNil: [
		self hasComment ifTrue: [trait classComment: comment stamp: commentStamp]]
! !

!MCTraitDefinition methodsFor:'printing'!

printDefinitionOn: stream
	stream nextPutAll: 'Trait named: #', self className;
		 cr;
		 tab;
		 nextPutAll: 'uses: ';
		 nextPutAll: self traitCompositionString;
		 cr;
		 tab;
		 nextPutAll: 'category: ';
		 store: self category asString

! !

!MCTraitDefinition methodsFor:'testing'!

hasClassInstanceVariables
	^ false


! !

!MCTraitDefinition methodsFor:'visiting'!

= aDefinition
        "/self flag: #traits. "Ugly we harcoded the super superclass method.  We will have to refactor the definition hierarchy"
        
        ^ (self isRevisionOf: aDefinition)
                and: [self traitCompositionString = aDefinition traitCompositionString]
                and: [category = aDefinition category]
                and: [comment = aDefinition comment]

    "Modified: / 14-09-2010 / 20:48:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

accept: aVisitor
	^ aVisitor visitTraitDefinition: self

!

createClass
	^Trait
		named: name
		uses: (Compiler evaluate: self traitCompositionString)
		category: category
		

! !

!MCTraitDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCTraitDefinition.st,v 1.6 2013-04-02 19:24:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCTraitDefinition.st,v 1.6 2013-04-02 19:24:41 cg Exp $'
!

version_SVN
    ^ '§Id: MCTraitDefinition.st 17 2010-10-13 12:07:52Z vranyj1 §'
! !

