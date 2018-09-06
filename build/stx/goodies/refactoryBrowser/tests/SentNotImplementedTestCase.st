"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

TestCase subclass:#SentNotImplementedTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing-Squeak'
!


!SentNotImplementedTestCase methodsFor:'running'!

checker
	"^ self checkerForAllRules"
	"^ self checkerForSentNotImplemented"

	^ CompositeLintRule rules: (OrderedCollection new add: BlockLintRule utilityMethods;
		 yourself)
!

checkerForAllRules
	^ CompositeLintRule rules: (OrderedCollection new addAll: 
	(((BlockLintRule class methodDictionary keys asArray select: [:sel | sel 
	argumentCount == 0]) 
	collect: [:sel | BlockLintRule perform: sel]) 
	select: [:each | each isKindOf: LintRule]); 
	 addAll: (((ParseTreeLintRule class methodDictionary keys asArray 
	select: [:sel | sel argumentCount == 0]) 
	collect: [:sel | ParseTreeLintRule perform: sel]) 
	select: [:each | each isKindOf: LintRule]); 
	 yourself)
!

checkerForBugs
	^CompositeLintRule ruleFor:BasicLintRule protocol:'bugs'.
!

checkerForSentNotImplemented
	^ CompositeLintRule rules: (OrderedCollection new add: BlockLintRule sentNotImplemented;
		 yourself)
!

checkerForSpecific
	^CompositeLintRule rules:(OrderedCollection new       
		add:BlockLintRule sentNotImplemented;      
		add:BlockLintRule subclassResponsibilityNotDefined;      
		add:BlockLintRule usesTrue ;      
		add:BlockLintRule overridesSpecialMessage;      
		add:ParseTreeLintRule booleanPrecedence ;      
		add:BlockLintRule definesEqualNotHash ;      
		add:BlockLintRule undeclaredReference ;      
		yourself).
!

classes
	self needsWork. "for complete testing, be sure to uncomment classesForAllClasses line.  This is very slow though."

	"^ self classesForAllClasses"
	"^ self classesForObject"
	^ self classesForRefactoryClasses
!

classesForAllClasses
	^ Object withAllSubclasses
!

classesForObject
	^ Array with:Object " {Object} "
!

classesForRefactoryClasses
	^ Object withAllSubclasses select: [:class | class theNonMetaClass category asString beginsWith: 'Refactory']
!

setUp

        
!

test
	| checker context |
	checker _ self checker.
	context _ SmalllintContext newNoCache.
	checker resetResult.
	self classes do: 
		[:aClass | 
		Transcript show: aClass printString;
		 cr.
		context selectedClass: aClass.
		checker checkClass: context.
		aClass methodDictionary keys do: [:each | (ExtraParsingAndFormattingTests methodsNotToTest includes: aClass >> each)
				| (each = #DoIt)
				ifFalse: 
					[context selector: each.
					checker checkMethod: context]]].
	checker isEmpty ifTrue: ['Nobody' inspect].
	Transcript cr;cr;cr.
	(checker rules select: [:rule | rule result isEmpty not])
		do: [:rule | rule result logOrInspect]
! !

!SentNotImplementedTestCase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/SentNotImplementedTestCase.st,v 1.5 2003-10-06 14:39:34 cg Exp $'
! !
