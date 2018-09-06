"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCGuardTest
	instanceVariableNames:'guard compiler'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Guards'
!


!PPCGuardTest methodsFor:'as yet unclassified'!

setUp
    super setUp.
    compiler := PPCMockCompiler new.
!

testCompiling
    guard := PPCGuard new initializeFor: ($a asParser / $b asParser) asCompilerTree.
    guard id: #foo.
    guard compileGuard: compiler.
    
    self assert: compiler lines size = 1.
    self assert: compiler lines first = '(foo at: context peek asInteger)'.
!

testCompiling2
    guard := PPCGuard new initializeFor: (#letter asParser / #digit asParser) asCompilerTree.
    guard id: #foo.
    guard compileGuard: compiler.
    
    self assert: compiler lines size = 1.
    self assert: compiler lines first = '(context peek isAlphaNumeric)'.
!

testCompiling3
    guard := PPCGuard new initializeFor: ($a asParser, (#letter asParser / #digit asParser)) asCompilerTree.
    guard id: #foo.
    guard compileGuard: compiler.
    
    self assert: compiler lines size = 1.
    self assert: compiler lines first = ('(context peek == ', $a storeString ,')').
!

testCompiling4
    guard := PPCGuard new initializeFor: ('foo' asParser / 'foobar' asParser) asCompilerTree.
    guard id: #foo.
    guard compileGuard: compiler.
    
    self assert: compiler lines size = 1.
    self assert: compiler lines first = ('(context peek == ', $f storeString ,')').
!

testIdentifierToken
    | id ws letterNode node |
    letterNode := PPCMessagePredicateNode new
        message: #isLetter;
        yourself.
        
    id := PPCPlusNode new
        child: letterNode;
        name: 'identifier';
        yourself.
    ws := PPCSentinelNode new.
        
    node := PPCTrimmingTokenNode new
        child: id;
        whitespace: ws;
        name: 'kw';
        yourself.

    guard := PPCGuard new initializeFor: node.
    self assert: (guard classification at: $a asInteger).
    self assert: (guard classification at: $z asInteger).
!

testMakesSense
    guard := PPCGuard new initializeFor: #letter asParser asCompilerTree.
    self assert: guard makesSense.
    
    guard := PPCGuard new initializeFor: nil asParser asCompilerTree.
    self assert: guard makesSense not.
    
    guard := PPCGuard new initializeFor: (#letter asParser / nil asParser) asCompilerTree.
    self assert: guard makesSense not.
    
    guard := PPCGuard new initializeFor: (#letter asParser / #digit asParser) asCompilerTree.
    self assert: guard makesSense.

    guard := PPCGuard new initializeFor: (#letter asParser / #digit asParser optional) asCompilerTree.
    self assert: guard makesSense not.
!

testMessage
    guard := PPCGuard new initializeFor: #letter asParser asCompilerTree.
    self assert: (guard message = #isLetter).
    self assert: (guard message = #isAlphaNumeric) not.
    
    guard := PPCGuard new initializeFor: #word asParser asCompilerTree.
    self assert: (guard message = #isAlphaNumeric).
    
    guard := PPCGuard new initializeFor: #digit asParser asCompilerTree.
    self assert: (guard message = #isDigit).
    
    guard := PPCGuard new initializeFor: 'a' asParser asCompilerTree.
    self assert: (guard message = #isDigit) not.
    self assert: (guard message = #isLetter) not.
    self assert: (guard message = #isAlphaNumeric) not.
    
!

testMessage2
    guard := PPCGuard new initializeFor: (#letter asParser / #digit asParser) asCompilerTree.
    self assert: guard message = #isAlphaNumeric
    
!

testNot
    guard := PPCGuard new initializeFor: ('foo' asParser not, 'fee' asParser) asCompilerTree.
    self assert: (guard classification at: $f asInteger).
!

testNot2
    | fee notFoo node |
    fee := PPCLiteralNode new
        literal: 'fee';
        yourself.
    notFoo := PPCNotLiteralNode new
        literal: 'foo';
        yourself.
    node := PPCSequenceNode new
        children: { notFoo . fee };
        yourself.
        
    guard := PPCGuard new initializeFor: node.
    self assert: (guard classification at: $f asInteger).
!

testNot3
    | letter  letterNegateStar node |
    letter := PPCMessagePredicateNode new
        message: #isLetter; yourself.
    letterNegateStar := PPCStarNode new
        child: #letter asParser negate asCompilerNode;
        yourself.
    node := PPCSequenceNode new
        children: { letterNegateStar . letter };
        yourself.
    guard := PPCGuard new initializeFor: node.
    self assert: (guard classification allSatisfy: [ :e | e]).
!

testTestMessage
    guard := PPCGuard new initializeFor: #letter asParser asCompilerTree.
    self assert: (guard testMessage: #isLetter).
    self assert: (guard testMessage: #isAlphaNumeric) not.
    
    guard := PPCGuard new initializeFor: #word asParser asCompilerTree.
    self assert: (guard testMessage: #isAlphaNumeric).
    
    guard := PPCGuard new initializeFor: #digit asParser asCompilerTree.
    self assert: (guard testMessage: #isDigit).
    
    guard := PPCGuard new initializeFor: 'a' asParser asCompilerTree.
    self assert: (guard testMessage: #isDigit) not.
    self assert: (guard testMessage: #isLetter) not.
    self assert: (guard testMessage: #isAlphaNumeric) not.
    
!

testTestSingleCharacter
    guard := PPCGuard new initializeFor: $a asParser asCompilerTree.
    self assert: guard testSingleCharacter.
    
    guard := PPCGuard new initializeFor: 'foo' asParser asCompilerTree.
    self assert: guard testSingleCharacter.
    
    guard := PPCGuard new initializeFor: ('foo' asParser / 'bar' asParser) asCompilerTree.
    self assert: guard testSingleCharacter not.

    guard := PPCGuard new initializeFor: ($a asParser, (#letter asParser / #digit asParser)) asCompilerTree.
    self assert: guard testSingleCharacter.
    
    guard := PPCGuard new initializeFor: ('foo' asParser / 'fee' asParser) asCompilerTree.
    self assert: guard testSingleCharacter.
! !

!PPCGuardTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

