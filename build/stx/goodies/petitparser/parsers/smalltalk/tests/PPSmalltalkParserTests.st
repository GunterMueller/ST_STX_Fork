"{ Package: 'stx:goodies/petitparser/parsers/smalltalk/tests' }"

PPSmalltalkGrammarTests subclass:#PPSmalltalkParserTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitSmalltalk-Tests'
!


!PPSmalltalkParserTests methodsFor:'accessing'!

parserClass
	^ PPSmalltalkParser
! !

!PPSmalltalkParserTests methodsFor:'private'!

assert: aNode format: aString
    | formatter savedSpaceAfterKeywordSelector |

    ((Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[ 
        savedSpaceAfterKeywordSelector := RBFormatter spaceAfterKeywordSelector.
        RBFormatter spaceAfterKeywordSelector:true.
        formatter := RBFormatter new
    ] ifFalse:[ 
        formatter := RBConfigurableFormatter
    ].
    [ 
        aNode isCollection
                ifFalse: [ ^ self assert: (Array with: aNode) format: (Array with: aString) ].
        self assert: aNode size equals: aString size.
        aNode with: aString do: [ :node :string | self assert: (formatter format: node) equals: string ]
    ] ensure:[ 
        ((Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[ 
            RBFormatter spaceAfterKeywordSelector:savedSpaceAfterKeywordSelector.
        ]
    ].

    "Modified: / 07-10-2014 / 23:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPSmalltalkParserTests methodsFor:'testing'!

testArray1
	super testArray1.
	self assert: result isArray.
	self assert: result statements isEmpty.
	self assert: result periods isEmpty
!

testArray2
	super testArray2.
	self assert: result isArray.
	self assert: result periods isEmpty.
	self assert: result statements size equals: 1.
	self assert: result statements first isMessage.
	self assert: result statements first selector equals: #foo
!

testArray3
	super testArray3.
	self assert: result isArray.
	self assert: result periods size equals: 1.
	self assert: result statements size equals: 2.
	self assert: result statements first isMessage.
	self assert: result statements first selector equals: #foo.
	self assert: result statements last isMessage.
	self assert: result statements last selector equals: #bar
!

testArray4
	super testArray4.
	self assert: result isArray.
	self assert: result periods size equals: 2.
	self assert: result statements size equals: 2.
	self assert: result statements first isMessage.
	self assert: result statements first selector equals: #foo.
	self assert: result statements last isMessage.
	self assert: result statements last selector equals: #bar
!

testAssignment1
	super testAssignment1.
	self assert: result isLiteralNode.
	self assert: result value equals: 1
!

testAssignment2
	super testAssignment2.
	self assert: result isAssignment.
	self assert: result variable isVariable.
	self assert: result variable name equals: 'a'.
	self assert: result value isLiteralNode.
	self assert: result value value equals: 1
!

testAssignment3
	super testAssignment3.
	self assert: result isAssignment.
	self assert: result variable isVariable.
	self assert: result variable name equals: 'a'.
	self assert: result value isAssignment.
	self assert: result value variable isVariable.
	self assert: result value variable name equals: 'b'.
	self assert: result value value isLiteralNode.
	self assert: result value value value equals: 1
!

testAssignment4
	super testAssignment4.
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifFalse: [ ^ self ].
	self assert: result isAssignment.
	self assert: result variable isVariable.
	self assert: result variable name equals: 'a'.
	self assert: result value isLiteralNode.
	self assert: result value value equals: 1
!

testAssignment5
	super testAssignment5.
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifFalse: [ ^ self ].
	self assert: result isAssignment.
	self assert: result variable isVariable.
	self assert: result variable name equals: 'a'.
	self assert: result value isAssignment.
	self assert: result value variable isVariable.
	self assert: result value variable name equals: 'b'.
	self assert: result value value isLiteralNode.
	self assert: result value value value equals: 1
!

testAssignment6
	super testAssignment6.
	self assert: result isAssignment.
	self assert: result variable isVariable.
	self assert: result variable name equals: 'a'.
	self assert: result value isAssignment.
	self assert: result value variable isVariable.
	self assert: result value variable name equals: 'b'.
	self assert: result value value isVariable.
	self assert: result value value name equals: 'c'
!

testComment1
	super testComment1.
	self assert: result isMessage.
	self assert: result receiver isValue.
	self assert: result selector equals: #+.
	self assert: result arguments first isValue
!

testComment2
	super testComment2.
	self assert: result isMessage.
	self assert: result receiver isValue.
	self assert: result selector equals: #+.
	self assert: result arguments first isValue
!

testComment3
	super testComment3.
	self assert: result isMessage.
	self assert: result receiver isValue.
	self assert: result selector equals: #+.
	self assert: result arguments first isValue
!

testComment4
	super testComment4.
	self assert: result isMessage.
	self assert: result receiver isValue.
	self assert: result selector equals: #+.
	self assert: result arguments first isValue
!

testComment5
	super testComment5.
	self assert: result isMessage.
	self assert: result receiver isValue.
	self assert: result selector equals: #+.
	self assert: result arguments first isValue
!

testComment6a
        super testComment6a.
        self assert: result isMessage.
        self assert: result receiver isValue.
        self assert: result selector equals: #+.
        self assert: result arguments first isValue

    "Created: / 07-11-2014 / 01:53:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment6b
        super testComment6b.
        self assert: result isMessage.
        self assert: result receiver isValue.
        self assert: result selector equals: #+.
        self assert: result arguments first isValue

    "Created: / 07-11-2014 / 01:53:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment6c
        super testComment6c.
        self assert: result isMessage.
        self assert: result receiver isValue.
        self assert: result selector equals: #+.
        self assert: result arguments first isValue

    "Created: / 07-11-2014 / 01:53:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment6d
        super testComment6d.
        self assert: result isMessage.
        self assert: result receiver isValue.
        self assert: result selector equals: #+.
        self assert: result arguments first isValue

    "Created: / 07-11-2014 / 01:53:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment6e
        super testComment6e.
        self assert: result isMessage.
        self assert: result receiver isValue.
        self assert: result selector equals: #+.
        self assert: result arguments first isValue

    "Created: / 07-11-2014 / 01:53:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testMethod1
	super testMethod1.
	self assert: result isMethod.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size equals: 1.
	self assert: result body statements first isReturn.
	self assert: result body statements first value isMessage.
	self assert: result body statements first value receiver isLiteralNode.
	self assert: result body statements first value selector equals: #-.
	self assert: result body statements first value arguments size equals: 1.
	self assert: result body statements first value arguments first isVariable
!

testMethod2
	super testMethod2.
	self assert: result isMethod.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size equals: 1.
	self assert: result body statements first isReturn.
	self assert: result body statements first value isMessage.
	self assert: result body statements first value receiver isLiteralNode.
	self assert: result body statements first value selector equals: #-.
	self assert: result body statements first value arguments size equals: 1.
	self assert: result body statements first value arguments first isVariable
!

testMethod3
	super testMethod3.
	self assert: result isMethod.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size equals: 1.
	self assert: result body statements first isReturn.
	self assert: result body statements first value isMessage.
	self assert: result body statements first value receiver isLiteralNode.
	self assert: result body statements first value selector equals: #-.
	self assert: result body statements first value arguments size equals: 1.
	self assert: result body statements first value arguments first isVariable
!

testSequence1
	super testSequence1.
	self assert: result isSequence.
	self assert: result temporaries size equals: 1.
	self assert: result temporaries first isVariable.
	self assert: result temporaries first name equals: 'a'.
	self assert: result statements size equals: 2.
	self assert: result statements first isLiteralNode.
	self assert: result statements first value equals: 1.
	self assert: result statements second isLiteralNode.
	self assert: result statements second value equals: 2
!

testStatements1
	super testStatements1.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size equals: 1.
	self assert: result statements first isLiteralNode.
	self assert: result statements first value equals: 1.
	self assert: result statements first value isInteger
!

testStatements2
	super testStatements2.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size equals: 2.
	self assert: result statements first isLiteralNode.
	self assert: result statements first value equals: 1.
	self assert: result statements first value isInteger.
	self assert: result statements second isLiteralNode.
	self assert: result statements second value equals: 2.
	self assert: result statements second value isInteger
!

testStatements3
	super testStatements3.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size equals: 3.
	self assert: result statements first isLiteralNode.
	self assert: result statements first value equals: 1.
	self assert: result statements first value isInteger.
	self assert: result statements second isLiteralNode.
	self assert: result statements second value equals: 2.
	self assert: result statements second value isInteger.
	self assert: result statements third isLiteralNode.
	self assert: result statements third value equals: 3.
	self assert: result statements third value isInteger
!

testStatements4
	super testStatements4.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size equals: 3.
	self assert: result statements first isLiteralNode.
	self assert: result statements first value equals: 1.
	self assert: result statements first value isInteger.
	self assert: result statements second isLiteralNode.
	self assert: result statements second value equals: 2.
	self assert: result statements second value isInteger.
	self assert: result statements third isLiteralNode.
	self assert: result statements third value equals: 3.
	self assert: result statements third value isInteger
!

testStatements5
	super testStatements5.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size equals: 2.
	self assert: result statements first isLiteralNode.
	self assert: result statements first value equals: 1.
	self assert: result statements first value isInteger.
	self assert: result statements second isLiteralNode.
	self assert: result statements second value equals: 2.
	self assert: result statements second value isInteger
!

testStatements6
	super testStatements6.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size equals: 2.
	self assert: result statements first isLiteralNode.
	self assert: result statements first value equals: 1.
	self assert: result statements first value isInteger.
	self assert: result statements second isLiteralNode.
	self assert: result statements second value equals: 2.
	self assert: result statements second value isInteger
!

testStatements7
	super testStatements7.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size equals: 1.
	self assert: result statements first isLiteralNode.
	self assert: result statements first value equals: 1.
	self assert: result statements first value isInteger
!

testStatements8
	super testStatements8.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size equals: 1.
	self assert: result statements first isLiteralNode.
	self assert: result statements first value equals: 1.
	self assert: result statements first value isInteger
!

testStatements9
	super testStatements9.
	self assert: result isEmpty.
!

testTemporaries1
	super testTemporaries1.
	self assert: result isSequence.
	self assert: result temporaries size equals: 1.
	self assert: result temporaries first isVariable.
	self assert: result temporaries first name equals: 'a'.
	self assert: result statements isEmpty
!

testTemporaries2
	super testTemporaries2.
	self assert: result isSequence.
	self assert: result temporaries size equals: 2.
	self assert: result temporaries first isVariable.
	self assert: result temporaries first name equals: 'a'.
	self assert: result temporaries second isVariable.
	self assert: result temporaries second name equals: 'b'.
	self assert: result statements isEmpty
!

testTemporaries3
	super testTemporaries3.
	self assert: result isSequence.
	self assert: result temporaries size equals: 3.
	self assert: result temporaries first isVariable.
	self assert: result temporaries first name equals: 'a'.
	self assert: result temporaries second isVariable.
	self assert: result temporaries second name equals: 'b'.
	self assert: result temporaries third isVariable.
	self assert: result temporaries third name equals: 'c'.
	self assert: result statements isEmpty
!

testVariable1
	super testVariable1.
	self assert: result isVariable.
	self assert: result name equals: 'trueBinding'
!

testVariable2
	super testVariable2.
	self assert: result isVariable.
	self assert: result name equals: 'falseBinding'
!

testVariable3
	super testVariable3.
	self assert: result isVariable.
	self assert: result name equals: 'nilly'
!

testVariable4
	super testVariable4.
	self assert: result isVariable.
	self assert: result name equals: 'selfish'
!

testVariable5
	super testVariable5.
	self assert: result isVariable.
	self assert: result name equals: 'supernanny'
!

testVariable6
	super testVariable6.
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifTrue: [ ^ self ].
	self assert: result isVariable.
	self assert: result name equals: 'super_nanny'
!

testVariable7
	super testVariable7.
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifTrue: [ ^ self ].
	self assert: result isVariable.
	self assert: result name equals: '__gen_var_123__'
! !

!PPSmalltalkParserTests methodsFor:'testing-blocks'!

testArgumentsBlock1
	super testArgumentsBlock1.
	self assert: result isBlock.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testArgumentsBlock2
	super testArgumentsBlock2.
	self assert: result isBlock.
	self assert: result arguments size equals: 2.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result arguments second isVariable.
	self assert: result arguments second name equals: 'b'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testArgumentsBlock3
	super testArgumentsBlock3.
	self assert: result isBlock.
	self assert: result arguments size equals: 3.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result arguments second isVariable.
	self assert: result arguments second name equals: 'b'.
	self assert: result arguments third isVariable.
	self assert: result arguments third name equals: 'c'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testBlock1
	super testBlock1.
	self assert: result isBlock.
	self assert: result arguments size equals: 0.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testComplexBlock1
	super testComplexBlock1.
	self assert: result isBlock.
	self assert: result arguments size equals: 1.
	self assert: result body temporaries size equals: 1.
	self assert: result body statements size equals: 1
!

testComplexBlock2
	super testComplexBlock2.
	self assert: result isBlock.
	self assert: result arguments size equals: 1.
	self assert: result body temporaries size equals: 1.
	self assert: result body statements size equals: 1
!

testSimpleBlock1
	super testSimpleBlock1.
	self assert: result isBlock.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testSimpleBlock2
	super testSimpleBlock2.
	self assert: result isBlock.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size equals: 1
!

testSimpleBlock3
	super testSimpleBlock3.
	self assert: result isBlock.
	self assert: result arguments size equals: 1.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testStatementBlock1
	super testStatementBlock1.
	self assert: result isBlock.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size equals: 1
!

testStatementBlock2
	super testStatementBlock2.
	self assert: result isBlock.
	self assert: result arguments isEmpty.
	self assert: result body temporaries size equals: 1.
	self assert: result body statements size equals: 1
!

testStatementBlock3
	super testStatementBlock3.
	self assert: result isBlock.
	self assert: result arguments isEmpty.
	self assert: result body temporaries size equals: 2.
	self assert: result body statements size equals: 1
! !

!PPSmalltalkParserTests methodsFor:'testing-literals'!

testArrayLiteral1
	super testArrayLiteral1.
	self assert: result isLiteralNode.
	self assert: result value equals: #()
!

testArrayLiteral10
	super testArrayLiteral10.
	self assert: result isLiteralNode.
	self assert: result value equals: #(#(1 2) #(1 2 3))
!

testArrayLiteral11
	super testArrayLiteral11.
	self assert: result isLiteralNode.
	self assert: result value size equals: 2.
	self assert: (result value first isKindOf: ByteArray).
	self assert: result value first size equals: 2.
	self assert: (result value last isKindOf: ByteArray).
	self assert: result value last size equals: 3
!

testArrayLiteral2
	super testArrayLiteral2.
	self assert: result isLiteralNode.
	self assert: result value equals: #(1)
!

testArrayLiteral3
	super testArrayLiteral3.
	self assert: result isLiteralNode.
	self assert: result value equals: #(1 2)
!

testArrayLiteral4
	super testArrayLiteral4.
	self assert: result isLiteralNode.
	self assert: result value equals: #(true false nil)
!

testArrayLiteral5
	super testArrayLiteral5.
	self assert: result isLiteralNode.
	self assert: result value equals: #($a)
!

testArrayLiteral6
	super testArrayLiteral6.
	self assert: result isLiteralNode.
	self assert: result value equals: #(1.2)
!

testArrayLiteral7
	super testArrayLiteral7.
	self assert: result isLiteralNode.
	self assert: result value equals: #(#size #at: #at:put: #==).
	result value do: [ :each | self assert: each isSymbol ]
!

testArrayLiteral8
	super testArrayLiteral8.
	self assert: result isLiteralNode.
	self assert: result value equals: #('baz').
	self assert: result value first isString.
	self assert: result value first isSymbol not
!

testArrayLiteral9
	super testArrayLiteral9.
	self assert: result isLiteralNode.
	self assert: result value equals: #(#(1) 2)
!

testByteLiteral1
	super testByteLiteral1.
	self assert: result isLiteralNode.
	self assert: (result value isKindOf: ByteArray).
	self assert: result value isEmpty
!

testByteLiteral2
	super testByteLiteral2.
	self assert: result isLiteralNode.
	self assert: (result value isKindOf: ByteArray).
	self assert: result value size equals: 1.
	self assert: result value first equals: 0
!

testByteLiteral3
	super testByteLiteral3.
	self assert: result isLiteralNode.
	self assert: (result value isKindOf: ByteArray).
	self assert: result value size equals: 1.
	self assert: result value first equals: 255
!

testByteLiteral4
	super testByteLiteral4.
	self assert: result isLiteralNode.
	self assert: (result value isKindOf: ByteArray).
	self assert: result value size equals: 2.
	self assert: result value first equals: 1.
	self assert: result value last equals: 2
!

testByteLiteral5
	super testByteLiteral5.
	self assert: result isLiteralNode.
	self assert: (result value isKindOf: ByteArray).
	self assert: result value size equals: 3.
	self assert: result value first equals: 10.
	self assert: result value second equals: 63.
	self assert: result value last equals: 255
!

testCharLiteral1
	super testCharLiteral1.
	self assert: result isLiteralNode.
	self assert: result value equals: $a
!

testCharLiteral2
	super testCharLiteral2.
	self assert: result isLiteralNode.
	self assert: result value equals: Character space
!

testCharLiteral3
	super testCharLiteral3.
	self assert: result isLiteralNode.
	self assert: result value equals: $$
!

testNumberLiteral1
	super testNumberLiteral1.
	self assert: result isLiteralNode.
	self assert: result value equals: 0.
	self assert: result value isInteger
!

testNumberLiteral10
	super testNumberLiteral10.
	self assert: result isLiteralNode.
	self assert: result value equals: 10.
	self assert: result value isInteger
!

testNumberLiteral11
	super testNumberLiteral11.
	self assert: result isLiteralNode.
	self assert: result value equals: 511.
	self assert: result value isInteger
!

testNumberLiteral12
	super testNumberLiteral12.
	self assert: result isLiteralNode.
	self assert: result value equals: 175.
	self assert: result value isInteger
!

testNumberLiteral13
	super testNumberLiteral13.
	self assert: result isLiteralNode.
	self assert: result value equals: 202.9921875.
	self assert: result value isFloat
!

testNumberLiteral14
	super testNumberLiteral14.
	self assert: result isLiteralNode.
	self assert: result value floor equals: -9.
	self assert: result value isFloat
!

testNumberLiteral15
    ((Smalltalk respondsTo: #isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[ 
        ^ self.
    ]. 
    super testNumberLiteral15.
    self assert: result isLiteralNode.
    self assert: result value equals: 1 / 2

    "Modified: / 07-10-2014 / 23:02:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testNumberLiteral2
	super testNumberLiteral2.
	self assert: result isLiteralNode.
	self assert: result value equals: 0.1.
	self assert: result value isFloat
!

testNumberLiteral3
	super testNumberLiteral3.
	self assert: result isLiteralNode.
	self assert: result value equals: 123.
	self assert: result value isInteger
!

testNumberLiteral4
	super testNumberLiteral4.
	self assert: result isLiteralNode.
	self assert: result value equals: 123.456.
	self assert: result value isFloat
!

testNumberLiteral5
	super testNumberLiteral5.
	self assert: result isLiteralNode.
	self assert: result value equals: 0.
	self assert: result value isInteger
!

testNumberLiteral6
	super testNumberLiteral6.
	self assert: result isLiteralNode.
	self assert: result value equals: -0.1.
	self assert: result value isFloat
!

testNumberLiteral7
	super testNumberLiteral7.
	self assert: result isLiteralNode.
	self assert: result value equals: -123.
	self assert: result value isInteger
!

testNumberLiteral8
	super testNumberLiteral8.
	self assert: result isLiteralNode.
	self assert: result value equals: -123.
	self assert: result value isInteger
!

testNumberLiteral9
	super testNumberLiteral9.
	self assert: result isLiteralNode.
	self assert: result value equals: -123.456.
	self assert: result value isFloat
!

testSpecialLiteral1
	super testSpecialLiteral1.
	self assert: result isLiteralNode.
	self assert: result value equals: true
!

testSpecialLiteral2
	super testSpecialLiteral2.
	self assert: result isLiteralNode.
	self assert: result value equals: false
!

testSpecialLiteral3
	super testSpecialLiteral3.
	self assert: result isLiteralNode.
	self assert: result value equals: nil
!

testStringLiteral1
	super testStringLiteral1.
	self assert: result isLiteralNode.
	self assert: result value equals: ''
!

testStringLiteral2
	super testStringLiteral2.
	self assert: result isLiteralNode.
	self assert: result value equals: 'ab'
!

testStringLiteral3
	super testStringLiteral3.
	self assert: result isLiteralNode.
	self assert: result value equals: 'ab''cd'
!

testSymbolLiteral1
	super testSymbolLiteral1.
	self assert: result isLiteralNode.
	self assert: result value equals: #foo.
	self assert: result value isSymbol
!

testSymbolLiteral2
	super testSymbolLiteral2.
	self assert: result isLiteralNode.
	self assert: result value equals: #+.
	self assert: result value isSymbol
!

testSymbolLiteral3
	super testSymbolLiteral3.
	self assert: result isLiteralNode.
	self assert: result value equals: #key:.
	self assert: result value isSymbol
!

testSymbolLiteral4
	super testSymbolLiteral4.
	self assert: result isLiteralNode.
	self assert: result value equals: #key:value:.
	self assert: result value isSymbol
!

testSymbolLiteral5
	super testSymbolLiteral5.
	self assert: result isLiteralNode.
	self assert: result value equals: #'testing-result'.
	self assert: result value isSymbol
!

testSymbolLiteral6
	super testSymbolLiteral6.
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifTrue: [ ^ self ].
	self assert: result isLiteralNode.
	self assert: result value equals: #'__gen__binding'.
	self assert: result value isSymbol
!

testSymbolLiteral7
	super testSymbolLiteral7.
	self assert: result isLiteralNode.
	self assert: result value equals: #fucker.
	self assert: result value isSymbol
!

testSymbolLiteral8
	super testSymbolLiteral8.
	self assert: result isLiteralNode.
	self assert: result value equals: #fucker.
	self assert: result value isSymbol
!

testSymbolLiteral9
	super testSymbolLiteral9.
	self assert: result isLiteralNode.
	self assert: result value equals: #fucker.
	self assert: result value isSymbol
! !

!PPSmalltalkParserTests methodsFor:'testing-messages'!

testBinaryExpression1
	super testBinaryExpression1.
	self assert: result isMessage.
	self assert: result receiver isLiteralNode.
	self assert: result receiver value equals: 1.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isLiteralNode.
	self assert: result arguments first value equals: 2
!

testBinaryExpression2
	super testBinaryExpression2.
	self assert: result isMessage.
	self assert: result receiver isMessage.
	self assert: result receiver receiver isLiteralNode.
	self assert: result receiver receiver value equals: 1.
	self assert: result receiver arguments size equals: 1.
	self assert: result receiver arguments first isLiteralNode.
	self assert: result receiver arguments first value equals: 2.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isLiteralNode.
	self assert: result arguments first value equals: 3
!

testBinaryExpression3
	super testBinaryExpression3.
	self assert: result isMessage.
	self assert: result receiver isLiteralNode.
	self assert: result receiver value equals: 1.
	self assert: result selector equals: #//.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isLiteralNode.
	self assert: result arguments first value equals: 2
!

testBinaryExpression4
	super testBinaryExpression4.
	self assert: result isMessage.
	self assert: result receiver isLiteralNode.
	self assert: result receiver value equals: 1.
	self assert: result selector equals: #--.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isLiteralNode.
	self assert: result arguments first value equals: 2
!

testBinaryExpression5
        super testBinaryExpression5.
        self assert: result isMessage.
        self assert: result receiver isLiteralNode.
        self assert: result receiver value equals: 1.
        self assert: result selector equals: #'==>'.
        self assert: result arguments size equals: 1.
        self assert: result arguments first isLiteralNode.
        self assert: result arguments first value equals: 2

    "Created: / 07-10-2014 / 00:22:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testBinaryMethod1
	super testBinaryMethod1.
	self assert: result isMethod.
	self assert: result selector equals: #+.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testBinaryMethod2
	super testBinaryMethod2.
	self assert: result isMethod.
	self assert: result selector equals: #+.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result body temporaries size equals: 1.
	self assert: result body statements isEmpty
!

testBinaryMethod3
	super testBinaryMethod3.
	self assert: result isMethod.
	self assert: result selector equals: #+.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size equals: 1
!

testBinaryMethod4
	super testBinaryMethod4.
	self assert: result isMethod.
	self assert: result selector equals: #+.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result body temporaries size equals: 1.
	self assert: result body statements size equals: 1
!

testBinaryMethod5
	super testBinaryMethod5.
	self assert: result isMethod.
	self assert: result selector equals: #--.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testCascadeExpression1
	super testCascadeExpression1.
	self assert: result isCascade.
	self assert: result receiver isLiteralNode.
	self assert: result messages size equals: 2.
	self assert: result messages first receiver equals: result receiver.
	self assert: result messages first selector equals: #abs.
	self assert: result messages second receiver equals: result receiver.
	self assert: result messages second selector equals: #negated
!

testCascadeExpression2
	super testCascadeExpression2.
	self assert: result isCascade.
	self assert: result receiver isMessage.
	self assert: result receiver receiver isLiteralNode.
	self assert: result receiver receiver value equals: 1.
	self assert: result receiver selector equals: #abs.
	self assert: result messages size equals: 3.
	self assert: result messages first receiver equals: result receiver.
	self assert: result messages first selector equals: #negated.
	self assert: result messages second receiver equals: result receiver.
	self assert: result messages second selector equals: #raisedTo:.
	self assert: result messages third receiver equals: result receiver.
	self assert: result messages third selector equals: #negated
!

testCascadeExpression3
	super testCascadeExpression3.
	self assert: result isCascade.
	self assert: result receiver isLiteralNode.
	self assert: result receiver value equals: 1.
	self assert: result messages size equals: 2.
	self assert: result messages first receiver equals: result receiver.
	self assert: result messages first selector equals: #+.
	self assert: result messages first arguments size equals: 1.
	self assert: result messages second receiver equals: result receiver.
	self assert: result messages second selector equals: #-.
	self assert: result messages second arguments size equals: 1
!

testKeywordExpression1
	super testKeywordExpression1.
	self assert: result isMessage.
	self assert: result receiver isLiteralNode.
	self assert: result receiver value equals: 1.
	self assert: result selector equals: #to:.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isLiteralNode.
	self assert: result arguments first value equals: 2
!

testKeywordExpression2
	super testKeywordExpression2.
	self assert: result isMessage.
	self assert: result receiver isLiteralNode.
	self assert: result selector equals: #to:by:.
	self assert: result arguments size equals: 2.
	self assert: result arguments first isLiteralNode.
	self assert: result arguments first value equals: 2.
	self assert: result arguments second isLiteralNode.
	self assert: result arguments second value equals: 3
!

testKeywordExpression3
	super testKeywordExpression3.
	self assert: result isMessage.
	self assert: result receiver isLiteralNode.
	self assert: result selector equals: #to:by:do:.
	self assert: result arguments size equals: 3.
	self assert: result arguments first isLiteralNode.
	self assert: result arguments first value equals: 2.
	self assert: result arguments second isLiteralNode.
	self assert: result arguments second value equals: 3.
	self assert: result arguments third isLiteralNode.
	self assert: result arguments third value equals: 4
!

testKeywordMethod1
	super testKeywordMethod1.
	self assert: result isMethod.
	self assert: result selector equals: #to:.
	self assert: result arguments size equals: 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testKeywordMethod2
	super testKeywordMethod2.
	self assert: result isMethod.
	self assert: result selector equals: #to:do:.
	self assert: result arguments size equals: 2.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result arguments second isVariable.
	self assert: result arguments second name equals: 'b'.
	self assert: result body temporaries size equals: 1.
	self assert: result body statements isEmpty
!

testKeywordMethod3
	super testKeywordMethod3.
	self assert: result isMethod.
	self assert: result selector equals: #to:do:by:.
	self assert: result arguments size equals: 3.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result arguments second isVariable.
	self assert: result arguments second name equals: 'b'.
	self assert: result arguments third isVariable.
	self assert: result arguments third name equals: 'c'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size equals: 1
!

testKeywordMethod4
	super testKeywordMethod4.
	self assert: result isMethod.
	self assert: result selector equals: #to:do:by:.
	self assert: result arguments size equals: 3.
	self assert: result arguments first isVariable.
	self assert: result arguments first name equals: 'a'.
	self assert: result arguments second isVariable.
	self assert: result arguments second name equals: 'b'.
	self assert: result arguments third isVariable.
	self assert: result arguments third name equals: 'c'.
	self assert: result body temporaries size equals: 1.
	self assert: result body statements size equals: 1
!

testUnaryExpression1
	super testUnaryExpression1.
	self assert: result isMessage.
	self assert: result receiver isLiteralNode.
	self assert: result selector equals: #abs.
	self assert: result arguments isEmpty
!

testUnaryExpression2
	super testUnaryExpression2.
	self assert: result isMessage.
	self assert: result receiver isMessage.
	self assert: result receiver receiver isLiteralNode.
	self assert: result receiver receiver value equals: 1.
	self assert: result receiver selector equals: #abs.
	self assert: result receiver arguments isEmpty.
	self assert: result selector equals: #negated.
	self assert: result arguments isEmpty
!

testUnaryMethod1
	super testUnaryMethod1.
	self assert: result isMethod.
	self assert: result selector equals: #abs.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testUnaryMethod2
	super testUnaryMethod2.
	self assert: result isMethod.
	self assert: result selector equals: #abs.
	self assert: result arguments isEmpty.
	self assert: result body temporaries size equals: 1.
	self assert: result body statements isEmpty
!

testUnaryMethod3
	super testUnaryMethod3.
	self assert: result isMethod.
	self assert: result selector equals: #abs.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size equals: 1
!

testUnaryMethod4
	super testUnaryMethod4.
	self assert: result isMethod.
	self assert: result selector equals: #abs.
	self assert: result arguments isEmpty.
	self assert: result body temporaries size equals: 1.
	self assert: result body statements size equals: 1
!

testUnaryMethod5
	super testUnaryMethod5.
	self assert: result isMethod.
	self assert: result selector equals: #abs.
	self assert: result arguments isEmpty.
	self assert: result body temporaries size equals: 1.
	self assert: result body statements isEmpty
! !

!PPSmalltalkParserTests methodsFor:'testing-pragmas'!

testPragma1
	super testPragma1.
	self 
		assert: result pragmas
		format: #('<foo>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma10
	super testPragma10.
	self 
		assert: result pragmas
		format: #('<foo: #bar>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma11
	super testPragma11.
	self 
		assert: result pragmas
		format: #('<foo: true>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma12
	super testPragma12.
	self 
		assert: result pragmas
		format: #('<foo: false>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma13
	super testPragma13.
	self 
		assert: result pragmas
		format: #('<foo: nil>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma14
	super testPragma14.
	self 
		assert: result pragmas
		format: #('<foo: #()>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma15
	super testPragma15.
	self 
		assert: result pragmas
		format: #('<foo: #()>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma16
	super testPragma16.
	self 
		assert: result pragmas
		format: #('< + 1>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma2
	super testPragma2.
	self 
		assert: result pragmas
		format: #('<foo>' '<bar>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma3
	super testPragma3.
	self assert: result pragmas format: #('<foo>').
	self assert: result body temporaries size equals: 1.
	self assert: result body statements isEmpty
!

testPragma4
	super testPragma4.
	self assert: result pragmas format: #('<foo>').
	self assert: result body temporaries size equals: 1.
	self assert: result body statements isEmpty
!

testPragma5
	super testPragma5.
	self assert: result pragmas format: #('<foo>' '<bar>').
	self assert: result body temporaries size equals: 1.
	self assert: result body statements isEmpty
!

testPragma6
	super testPragma6.
	self 
		assert: result pragmas
		format: #('<foo: 1>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma7
	super testPragma7.
	self 
		assert: result pragmas
		format: #('<foo: 1.2>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma8
	super testPragma8.
	self 
		assert: result pragmas
		format: #('<foo: ''bar''>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
!

testPragma9
	super testPragma9.
	self 
		assert: result pragmas
		format: #('<foo: #bar>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
! !

!PPSmalltalkParserTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

