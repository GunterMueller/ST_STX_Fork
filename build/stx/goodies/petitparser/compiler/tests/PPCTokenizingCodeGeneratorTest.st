"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPCTokenizingCodeGeneratorTest
	instanceVariableNames:'visitor node result compiler parser context options tokenizer
		whitespace'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Visitors'
!

!PPCTokenizingCodeGeneratorTest methodsFor:'setup'!

cleanClass
    | parserClass scannerClass |
    parserClass := (Smalltalk at: options parserName ifAbsent: [nil]).
    parserClass notNil ifTrue:[ 
        parserClass removeFromSystem
    ].

    scannerClass := (Smalltalk at: options scannerName ifAbsent: [nil]).
    scannerClass notNil ifTrue:[ 
        scannerClass removeFromSystem
    ].
!

compileTree: root
    parser := compiler compile: root.
    
!

context	
    ^ context := PPCProfilingContext new
!

setUp
    options := (PPCCompilationOptions new)
            profile:true;
            tokenize:true;
            yourself.
    self cleanClass.
    compiler := PPCCompiler new.
    compiler passes:{
                PPCCacheFirstFollowPass.
                PPCTokenizingCodeGenerator.
                PPCFSAVisitor.
                PPCTokenCodeGenerator.
                PPCScannerCodeGenerator
            }.
    compiler options:options.

    "Modified: / 07-09-2015 / 10:22:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    "nothing to do now"
! !

!PPCTokenizingCodeGeneratorTest methodsFor:'support'!

assert: whatever parse: input
    result := super assert: whatever parse: input.
!

literalNode: literal
    ^ PPCLiteralNode new
        literal: literal;
        yourself
!

tokenNodeForEOF
    | eof |
    eof := PPCEndOfFileNode new
        yourself;
        markForInline.
        
    ^ PPCTokenNode new
        child: eof;
        tokenClass: PPToken;
        yourself.
!

tokenNodeForLiteral: literal
    | literalNode |
    literalNode := self literalNode: literal.
    ^ self trimmingTokenNode: literalNode
!

trimmingTokenNode: child
    | ws |
    ws := PPCStarNode new
        child: (PPCMessagePredicateNode new
            message: #isSeparator ;
            markForInline ;
            yourself);
        yourself.

    child markForInline.
    
    ^ PPCTrimmingTokenNode new
        child: child;
        whitespace: ws;
        tokenClass: PPToken;
        yourself
! !

!PPCTokenizingCodeGeneratorTest methodsFor:'testing'!

testSimpleChoice1
    | token1 token2 token1Consume token2Consume  tokenNode eof choiceNode wsNode |

    token1 := (self tokenNodeForLiteral: 'foo') yourself.
    token2 := (self tokenNodeForLiteral: 'bar') yourself.
    eof := (self tokenNodeForEOF) yourself.
    
    token1Consume := PPCTokenConsumeNode new
                            child: token1;
                            yourself.
    token2Consume := PPCTokenConsumeNode new
                            child: token2;
                            yourself.

    choiceNode := PPCDeterministicChoiceNode new
        children: { token1Consume . token2Consume };
        yourself.
        
    tokenNode := PPCListNode new
        children: { token1 . token2 . eof };
        name: 'nextToken';
        yourself.
        
    wsNode := PPCNilNode new
        name: 'consumeWhitespace';
        yourself.
        
    node := PPCTokenizingParserNode new
        tokens: tokenNode;
        whitespace: wsNode;
        parser: choiceNode;
        yourself.
    
    self compileTree: node.
    
    parser := parser class new.
    self assert: parser parse: 'foo'.
    self assert: result inputValue = 'foo'.

    parser := parser class new.
    self assert: parser parse: 'bar'.
    self assert: result inputValue = 'bar'.

    parser := parser class new.
    self assert: parser fail: 'baz'.	
!

testTokenizingParserNode
    |  tokenNode tokenizerNode consumeNode eof wsNode |
    tokenNode := (self tokenNodeForLiteral: 'bar') yourself.
    eof := (self tokenNodeForEOF) yourself.	
        
    tokenizerNode := PPCListNode new
        children: { tokenNode . eof };
        name: 'nextToken';
        yourself.
    consumeNode := PPCTokenConsumeNode new
                            child: tokenNode;
                            yourself.
    wsNode := PPCNilNode new
        name: 'consumeWhitespace';
        yourself.
    
    node := PPCTokenizingParserNode new
        parser: consumeNode;
        tokens: tokenizerNode;
        whitespace: wsNode;
        yourself.

    
    self compileTree: node.
    
    parser := parser class new.
    self assert: parser parse: 'bar'.
    self assert: result inputValue = 'bar'.

    parser := parser class new.
    self assert: parser fail: 'foo'.
!

testTrimmingToken1
    | token tokenConsume tokensNode eof  wsNode separatorNode |

    token := self trimmingTokenNode: (self literalNode: 'foo').
    eof := (self tokenNodeForEOF) yourself.
    
    tokenConsume := PPCTokenConsumeNode new
                            child: token;
                            yourself.

    tokensNode := PPCListNode new
        children: { token . eof };
        name: 'nextToken';
        yourself.
    
    separatorNode := PPCLiteralNode new
        literal: ' ';
        name: 'separator';
        yourself.
    
    wsNode := PPCStarNode new
        name: 'consumeWhitespace';
        child: separatorNode;
        yourself.

    node := PPCTokenizingParserNode new
        tokens: tokensNode;
        whitespace: wsNode;
        parser: tokenConsume;
        yourself.
    
    
    self compileTree: node.

    
    parser := parser class new.
    self assert: parser parse: ' foo'.
    self assert: result inputValue = 'foo'.

    
    parser := parser class new.
    self assert: parser parse: ' foo  '.
    self assert: result inputValue = 'foo'.


    parser := parser class new.
    self assert: parser fail: 'baz'.	
! !

