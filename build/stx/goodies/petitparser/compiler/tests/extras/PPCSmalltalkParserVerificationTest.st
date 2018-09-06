"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCAbstractParserTest subclass:#PPCSmalltalkParserVerificationTest
	instanceVariableNames:'parser result context resource fileResources'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Smalltalk'
!

!PPCSmalltalkParserVerificationTest class methodsFor:'as yet unclassified'!

resources
    ^ (OrderedCollection with: PPCResources)
        addAll: super resources;
        yourself
! !

!PPCSmalltalkParserVerificationTest class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == PPCSmalltalkParserVerificationTest.
! !

!PPCSmalltalkParserVerificationTest methodsFor:'accessing'!

petitParserClass
    "Return the name of the petit parser to compile"

    ^ PPSmalltalkGrammar

    "Created: / 29-07-2015 / 19:52:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSmalltalkParserVerificationTest methodsFor:'setup'!

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

!PPCSmalltalkParserVerificationTest methodsFor:'tests'!

testSmalltalk
    | compiledParser normalParser expected actual |
    normalParser := self petitParser.
    compiledParser := self compiledParser.
    
    fileResources smalltalkSourcesBig do: [ :source |
        expected := normalParser parse: source.
        expected isPetitFailure ifFalse: [ 
     				actual := (compiledParser parse: source withContext: self context). 
            self assert: expected equals: actual.
        ]
    ].
!

testSmalltalkClass
    | compiledParser normalParser |
    normalParser := self petitParser.
    compiledParser := self compiledParser.
    
    fileResources smalltalkClassMethods do: [ :source |
        self assert: (normalParser parse: source) 
              equals: (compiledParser parse: source withContext: self context). 
    ].
!

testSmalltalkObject
    | compiledParser normalParser |
    normalParser := self petitParser.
    compiledParser := self compiledParser.
    
    fileResources smalltalkObjectMethods do: [ :source |
        self assert: (normalParser parse: source) 
              equals: (compiledParser parse: source withContext: self context). 
    ].
! !

