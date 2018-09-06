"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCAbstractParserTest subclass:#PPCExpressionGrammarVerificationTest
	instanceVariableNames:'parser result context resource fileResources'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Expressions'
!

!PPCExpressionGrammarVerificationTest class methodsFor:'accessing'!

resources
    ^ (OrderedCollection with: PPCResources)
        addAll: super resources;
        yourself
! !

!PPCExpressionGrammarVerificationTest class methodsFor:'testing'!

isAbstract
    ^ self == PPCExpressionGrammarVerificationTest

    "Modified: / 29-07-2015 / 18:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCExpressionGrammarVerificationTest methodsFor:'accessing'!

petitParserClass
    "Return the name of the petit parser to compile"

    ^ PPExpressionGrammar

    "Modified: / 29-07-2015 / 17:08:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCExpressionGrammarVerificationTest methodsFor:'setup'!

setUp
    super setUp.
    fileResources := (self resources detect: [:e | e = PPCResources ]) current.
!

tearDown
    super tearDown.
    "
    self compiledSmalltalkGrammarClass isNil ifFalse:[ 
        self compiledSmalltalkGrammarClass removeFromSystem
    ].
    "
! !

!PPCExpressionGrammarVerificationTest methodsFor:'tests'!

testExpressions
    | compiledParser petitParser expected actual |
    petitParser := self petitParser.
    compiledParser := self compiledParser.
    
    fileResources expressionSourcesMedium do: [ :source |
        expected := petitParser parse: source.
        expected isPetitFailure ifFalse: [ 
                actual := (compiledParser parse: source withContext: self context). 
            self assert: expected equals: actual.
        ]
    ].

    "Modified: / 29-07-2015 / 17:03:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSanity
    | compiledParser petitParser source |
    petitParser := self petitParser.
    compiledParser := self compiledParser.
    
    source := fileResources expressionOfSize: 100. 
    result := petitParser parse: source.
    
    self assert: (((self deepFlattened: result) select: [ :e | e isNumber ]) size) = 100.
    self assert: (((self deepFlattened: result)select: [ :e | e isNumber ]) size) = 100.

    "Modified: / 29-07-2015 / 17:03:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCExpressionGrammarVerificationTest methodsFor:'utilities'!

deepFlatten: anObject into: aCollection
    (anObject isCollection and:[anObject isString not]) ifTrue:[
        anObject do:[:each|self deepFlatten: each into: aCollection]
    ] ifFalse:[
        aCollection add: anObject 
    ].
    ^aCollection
!

deepFlattened: aCollection
    ^self deepFlatten: aCollection into: OrderedCollection new.
! !

