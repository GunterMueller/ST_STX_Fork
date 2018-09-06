"{ Package: 'stx:goodies/monticello' }"

MCDefinition subclass:#MCClassTraitDefinition
	instanceVariableNames:'baseTrait classTraitComposition category'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCClassTraitDefinition class methodsFor:'as yet unclassified'!

baseTraitName: aString classTraitComposition: classTraitCompositionString
	^self instanceLike: (
		self new
			initializeWithBaseTraitName: aString
			classTraitComposition: classTraitCompositionString).
! !

!MCClassTraitDefinition methodsFor:'accessing'!

= aDefinition
	^ (super = aDefinition)
		and: [baseTrait = aDefinition baseTrait]
		and: [self classTraitCompositionString = aDefinition classTraitCompositionString]


!

actualClass
    ^Smalltalk classNamed: self className
!

baseTrait
	^baseTrait

!

className
	^self baseTrait
!

classTraitComposition
	^classTraitComposition


!

classTraitCompositionString
	^self classTraitComposition ifNil: ['{}'].


!

definitionString
	^self baseTrait , ' classTrait
	uses: ' , self classTraitCompositionString.

!

description
	^Array
		with: baseTrait
		with: classTraitComposition
!

hash
	| hash |
	hash := String stringHash: baseTrait initialHash: 0.
	hash := String stringHash: self classTraitCompositionString initialHash: hash.
	^hash

!

requirements
	^Array with: baseTrait
!

source
	^self definitionString
! !

!MCClassTraitDefinition methodsFor:'comparing'!

sortKey
        ^ self baseTrait "name" , '.classTrait'

    "Modified: / 14-09-2010 / 20:59:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCClassTraitDefinition methodsFor:'converting'!

asChange
    ^TraitClassTraitDefinitionChange new
        mcDefinition: self;
        baseTrait: baseTrait;
        traitComposition: classTraitComposition;
        "/ category: category;
        yourself
! !

!MCClassTraitDefinition methodsFor:'initialization'!

initializeWithBaseTraitName: aTraitName classTraitComposition: aString
	baseTrait := aTraitName.
	classTraitComposition := aString.
! !

!MCClassTraitDefinition methodsFor:'installing'!

load	
	Compiler evaluate: self definitionString
! !

!MCClassTraitDefinition methodsFor:'printing'!

summary
	^self baseTrait , ' classTrait'

! !

!MCClassTraitDefinition methodsFor:'testing'!

isClassDefinition
	"Traits are treated the same like classes."
	
	^ true
! !

!MCClassTraitDefinition methodsFor:'visiting'!

accept: aVisitor
	^ aVisitor visitClassTraitDefinition: self.
! !

!MCClassTraitDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCClassTraitDefinition.st,v 1.7 2014-04-12 13:07:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCClassTraitDefinition.st,v 1.7 2014-04-12 13:07:01 cg Exp $'
!

version_SVN
    ^ '$Id: MCClassTraitDefinition.st,v 1.7 2014-04-12 13:07:01 cg Exp $'
! !

