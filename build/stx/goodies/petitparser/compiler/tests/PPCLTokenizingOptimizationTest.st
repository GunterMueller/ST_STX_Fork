"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCLTokenizingOptimizationTest
	instanceVariableNames:'compiler parser result'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Core-Tokenizing'
!


!PPCLTokenizingOptimizationTest methodsFor:'as yet unclassified'!

assert: object type: class
    self assert: (object isKindOf: class)
!

compiler    
    compiler := PPCCompiler new.
    (compiler context options)
        generate:false;
        tokenize:true.
    ^ compiler

    "Created: / 07-09-2015 / 10:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

optimize: aPPParser
    ^ self compiler compile: aPPParser.
!

testCompileToken
    parser := 'foo' asParser token.
    result := self optimize: parser.
    
    self assert: result type: PPCTokenizingParserNode.
    self assert: result parser type: PPCTokenConsumeNode.
    self assert: result parser child type: PPCTokenNode.
    self assert: result parser child child literal = 'foo'.
!

testCompileTrim
    parser := 'foo' asParser token trim.
    result := self optimize: parser.
    
    self assert: result type: PPCTokenizingParserNode.
    self assert: result parser type: PPCTokenConsumeNode.
    self assert: result parser child type: PPCTrimmingTokenNode.
    self assert: result whitespace type: PPCStarNode.
!

testCompileTrimmingToken
    parser := 'foo' asParser trimmingToken.
    result := self optimize: parser.
    
    self assert: result type: PPCTokenizingParserNode.
    self assert: result parser type: PPCTokenConsumeNode.
    self assert: result parser child type: PPCTrimmingTokenNode.
    self assert: result whitespace type: PPCStarNode.
    
    self assert: result tokens children size = 1.
    self assert: (result tokens children anySatisfy: [ :e | e isKindOf: PPCTrimmingTokenNode ])
!

testCompileTrimmingToken2
    | token |
    token := 'foo' asParser trimmingToken.
    parser := token wrapped
        name: 'fooToken';
        yourself.
    result := self optimize: parser.
    
    self assert: result type: PPCTokenizingParserNode.
    self assert: result parser type: PPCTokenConsumeNode.
    self assert: result parser name = 'fooToken'.
    self assert: result parser child name = 'fooToken'.
    
    self assert: result tokens children size = 1.
    self assert: (result tokens children anySatisfy: [ :e | e isKindOf: PPCTrimmingTokenNode ]).
    self assert: (result tokens children anySatisfy: [ :e | e name = 'fooToken']).
! !

!PPCLTokenizingOptimizationTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

