"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PPJavaSyntaxTest subclass:#PPJavaParserTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-Tests'
!

!PPJavaParserTest methodsFor:'accessing'!

parserClass
	^ PPJavaParser 
! !

!PPJavaParserTest methodsFor:'as yet unclassified'!

testCharacterLiteral1
	super testCharacterLiteral1.
	self assert: result class equals: PJCharacterLiteralNode.
	self assert: result literalValue equals: 'a'
!

testCharacterLiteral2
	super testCharacterLiteral2.
	self assert: result class equals: PJCharacterLiteralNode.
	self assert: result literalValue equals: '%'
!

testCharacterLiteral3
	super testCharacterLiteral3.
	self assert: result class equals: PJCharacterLiteralNode.
	self assert: result literalValue equals: '\t'
!

testCharacterLiteral4
	super testCharacterLiteral4.
	self assert: result class equals: PJCharacterLiteralNode.
	self assert: result literalValue equals: '\\'
!

testCharacterLiteral5
	super testCharacterLiteral5.
	self assert: result class equals: PJCharacterLiteralNode.
	self assert: result literalValue equals: '\'''
!

testCharacterLiteral8
	super testCharacterLiteral8.
	self assert: result class equals: PJCharacterLiteralNode.
	self assert: result literalValue equals:  '\177'
!

testComment1 
	super testComment1.
	self assert: result class equals: PJEndOfLineCommentsNode.
	self assert: (result comment ) equals: '' .
!

testComment2
	super testComment2.
	self assert: result class equals: PJEndOfLineCommentsNode.
	self assert: (result comment ) equals: 'comment' .


!

testComment3
	super testComment3.
	self assert: result class equals: PJEndOfLineCommentsNode .
 		self assert: (result comment ) equals: ' comment' .
!

testComment4
	super testComment4.
	self assert: result class equals: PJTraditionalCommentsNode.
 	self assert: (result comment) equals: ' comment ' .
!

testComment6
	super testComment6.
	self assert: result class equals: PJTraditionalCommentsNode.
	self assert: (result comment) equals: ' this comment /* // /** ends here: ' .

!

testComment7
	super testComment7.
	self assert: result class equals: PJTraditionalCommentsNode .
	self assert: (result comment) equals: '*     * @param args      * @return void     '.
!

testComment8cr
        super testComment8cr.
        self assert: result class equals: PJTraditionalCommentsNode .
        self assert: (result comment) equals: ''.

    "Created: / 21-04-2015 / 17:08:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment8crlf
        super testComment8crlf.
        self assert: result class equals: PJTraditionalCommentsNode .
        self assert: (result comment) equals: ''.

    "Created: / 21-04-2015 / 17:08:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment8lf
        super testComment8lf.
        self assert: result class equals: PJTraditionalCommentsNode .
        self assert: (result comment) equals: ''.

    "Created: / 21-04-2015 / 17:08:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSeparator1
super testSeparator1.
	self assert: result class equals: PJSeparatorNode .
	self assert: result  separatorValue equals: '{' .
! !

!PPJavaParserTest methodsFor:'testing'!

testBlock1
	super testBlock1.
	self assert: result class equals: PJBlockNode.
	self assert: result statements isEmpty
!

testBlock2
	super testBlock2.
	self assert: result class equals: PJBlockNode.
	self assert: result statements size equals: 2
!

testFloatLiteral1
	super testFloatLiteral1.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '1e1'.
	self assert: result isFloat
!

testFloatLiteral10
	super testFloatLiteral10.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '0.0'.
	self assert: result isFloat not.
!

testFloatLiteral11
	super testFloatLiteral11.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '3.14'.
	self assert: result isFloat not.
!

testFloatLiteral12
	super testFloatLiteral12.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '1e-9d'.
	self assert: result isFloat not.
!

testFloatLiteral13
	super testFloatLiteral13.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '1e137'.
	self assert: result isFloat not.
!

testFloatLiteral2
	super testFloatLiteral2.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '2.'.
	self assert: result isFloat
!

testFloatLiteral3
	super testFloatLiteral3.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '.3'.
	self assert: result isFloat
!

testFloatLiteral4
	super testFloatLiteral4.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '0'.
	self assert: result isFloat
!

testFloatLiteral5
	super testFloatLiteral5.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '3.14'.
	self assert: result isFloat
!

testFloatLiteral6
	super testFloatLiteral6.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '6.022137e+23'.
	self assert: result isFloat
!

testFloatLiteral7
	super testFloatLiteral7.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '1e1'.
	self assert: result isFloat not.
!

testFloatLiteral8
	super testFloatLiteral8.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '2.'.
	self assert: result isFloat not.
!

testFloatLiteral9
	super testFloatLiteral9.
	self assert: result class equals: PJFloatLiteralNode.
	self assert: result literalValue equals: '.3'.
	self assert: result isFloat not.
!

testMethodDeclaration3
	super testMethodDeclaration3.
	self assert: result class equals: PJMethodDeclarationNode.
	self assert: result body class equals: PJBlockNode
!

testMethodDeclaration4
	super testMethodDeclaration4.
	self assert: result class equals: PJMethodDeclarationNode.
	self assert: result body class equals: PJBlockNode.
	self assert: result parameters size equals: 2
!

testNormalParameterDecl1
	super testNormalParameterDecl1.
	self assert: result class equals: PJParameterDeclaratorNode.
	self assert: result identifier class equals: PJIdentifierNode.
	self assert: result arrayLevel equals: 1.
	self assert: result modifiers size equals: 1
!

testNormalParameterDecl2
	super testNormalParameterDecl2.
	self assert: result class equals: PJParameterDeclaratorNode.
	self assert: result identifier class equals: PJIdentifierNode.
	self assert: result arrayLevel equals: 0.
	self assert: result modifiers size equals: 0
!

testStatement1 
	super testStatement1.
	self assert: result class equals: PJExpressionStatementNode
!

testStatement3 
	super testStatement3.
	self assert: result class equals: PJBlockNode.
	self assert: result statements isEmpty
!

testWhileStatement1
	super testWhileStatement1.
	self assert: result class equals: PJWhileStatementNode.
	self assert: result expression class equals: PJBooleanLiteralNode.
!

testWhileStatement2
	super testWhileStatement2.
	self assert: result class equals: PJWhileStatementNode.
	self assert: result statement class equals: PJBlockNode
! !

!PPJavaParserTest methodsFor:'testing-classes'!

testLiteral13
	super testLiteral13.
	self assert: result class equals: PJStringLiteralNode 
!

testMethodDeclaration1
	super testMethodDeclaration1.
	self assert: result class equals: PJMethodDeclarationNode.
	self assert: result body class equals: PJBlockNode
!

testMethodDeclaration2
	super testMethodDeclaration2.
	self assert: result class equals: PJConstructorDeclarationNode.
	self assert: result statements isEmpty
! !

!PPJavaParserTest methodsFor:'testing-literals'!

testAdditiveExpression1
	super testAdditiveExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testAdditiveExpression2
	super testAdditiveExpression2.
	self assert: result class equals: PJInfixOperationNode.
	self assert: result left class equals: PJIntegerLiteralNode.
	self assert: result left literalValue equals: 3.
	self assert: result operator equals: #+.
	self assert: result right class equals: PJIntegerLiteralNode.
	self assert: result right literalValue equals: 5.
!

testAdditiveExpression3
	super testAdditiveExpression3.
	self assert: result class equals: PJInfixOperationNode.
	
	self assert: result left left left class equals: PJIntegerLiteralNode.
	self assert: result left left left literalValue equals: 4.
	
	self assert: result left left right class equals: PJIntegerLiteralNode.
	self assert: result left left right literalValue equals: 8.
	self assert: result left left operator equals: #+.
	
	self assert: result left right class equals: PJIntegerLiteralNode.
	self assert: result left right literalValue equals: 2.
	self assert: result left operator equals: #-.
	
	self assert: result right class equals: PJIntegerLiteralNode.
	self assert: result right literalValue equals: 9.
	self assert: result operator equals: #+.
	
!

testAndExpression1
	super testAndExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testBooleanLiteral1
	super testBooleanLiteral1.
	self assert: result class equals: PJBooleanLiteralNode.
	self assert: result booleanValue equals: true
!

testBooleanLiteral2
	super testBooleanLiteral2.
	self assert: result class equals: PJBooleanLiteralNode.
	self assert: result booleanValue equals: false
!

testConditionalAndExpression1
	super testConditionalAndExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testConditionalOrExpression1
	super testConditionalOrExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testEqualityExpression1
	super testEqualityExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testExclusiveOrExpression1
	super testExclusiveOrExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testExpression2
	super testExpression2.
	self assert: result class equals: PJBooleanLiteralNode
!

testExpression4
	super testExpression4.
	self assert: result class equals: PJIdentifierNode 
!

testExpression5
	super testExpression5.
	self assert: result class equals: PJInfixOperationNode.
	self assert: result left class equals: PJIdentifierNode.
	self assert: result operator equals: #+=.
	self assert: result right class equals: PJIntegerLiteralNode
!

testFormalParameters1
	super testFormalParameters1.
	self assert: (result isKindOf: Collection).
	self assert: result size equals: 2
!

testFormalParameters4
	super testFormalParameters4.
	self assert: (result isKindOf: Collection).
	self assert: result size equals: 4
!

testFormalParameters5
	super testFormalParameters5.
	self assert: result isNil
!

testIdentifier1
	super testIdentifier1.
	self assert: result class equals: PJIdentifierNode.
	self assert: result name equals: 'String'
	
!

testIdentifier2
	super testIdentifier2.
	self assert: result class equals: PJIdentifierNode.
	self assert: result name equals: 'i3'
	
!

testIdentifier3
	super testIdentifier3.
	self assert: result class equals: PJIdentifierNode.
	self assert: result name equals: 'αρετη'
	
!

testIdentifier4
	super testIdentifier4.
	self assert: result class equals: PJIdentifierNode.
	self assert: result name equals: 'MAX_VALUE'
	
!

testIdentifier5
	super testIdentifier5.
	self assert: result class equals: PJIdentifierNode.
	self assert: result name equals: 'isLetterOrDigit'
!

testInclusiveOrExpression1
	super testInclusiveOrExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testInstanceofExpression1
	super testInstanceofExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testLiteral2
	super testLiteral2.
	self assert: result class equals: PJBooleanLiteralNode
!

testLocalVariableDeclarationStatement1
	super testLocalVariableDeclarationStatement1.
	self assert: result class equals: PJLocalVariableDeclarationStatementNode.
	self assert: result type notNil.
	self assert: result declarators size equals: 1.
!

testLocalVariableDeclarationStatement2
	super testLocalVariableDeclarationStatement2.
	self assert: result class equals: PJLocalVariableDeclarationStatementNode.
	self assert: result type notNil.
	self assert: result declarators size equals: 2.
!

testLocalVariableDeclarationStatement3
	super testLocalVariableDeclarationStatement3.
	self assert: result class equals: PJLocalVariableDeclarationStatementNode.
	self assert: result type notNil.
	self assert: result declarators size equals: 3.
!

testMultiplicativeExpression1
	super testMultiplicativeExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testMultiplicativeExpression2
	super testMultiplicativeExpression2.
	self assert: result class equals: PJInfixOperationNode.
	self assert: result left class equals: PJIntegerLiteralNode.
	self assert: result left literalValue equals: 3.
	self assert: result operator equals: #*.
	self assert: result right class equals: PJIntegerLiteralNode.
	self assert: result right literalValue equals: 5.
!

testMultiplicativeExpression3
	super testMultiplicativeExpression3.
	self assert: result class equals: PJInfixOperationNode.
	
	self assert: result left left left class equals: PJIntegerLiteralNode.
	self assert: result left left left literalValue equals: 4.
	
	self assert: result left left right class equals: PJIntegerLiteralNode.
	self assert: result left left right literalValue equals: 8.
	self assert: result left left operator equals: #*.
	
	self assert: result left right class equals: PJIntegerLiteralNode.
	self assert: result left right literalValue equals: 2.
	self assert: result left operator equals: #/.
	
	self assert: result right class equals: PJIntegerLiteralNode.
	self assert: result right literalValue equals: 9.
	self assert: result operator equals: #*.
	
!

testNullLiteral1

	super testNullLiteral1
.
	self assert: result class equals: PJNullLiteralNode .
	self assert: result literalValue equals: 'null'
!

testPrimary1
	super testPrimary1.
	self assert: result class equals: PJBooleanLiteralNode
!

testPrimary2
	super testPrimary2.
	self assert: result class equals: PJStringLiteralNode
!

testPrimaryWithselectors1
	super testPrimaryWithselectors1.
	self assert: result class equals: PJBooleanLiteralNode
!

testPrimaryWithselectors2
	super testPrimaryWithselectors2.
	"
		JK: Seems the functionality is not finished or broken
		see rule primaryWithselectors, calling #object: that throws DNU
	"
	"self assert: result size = 2."
!

testRelationalExpression1
	super testRelationalExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testRelationalExpression2
	super testRelationalExpression2.
	self assert: result class equals: PJInfixOperationNode 
!

testReturnStatement1
	super testReturnStatement1.
	self assert: result class equals: PJReturnStatementNode.
	self assert: (result expression isKindOf: PJExpressionNode)
!

testReturnStatement2
	super testReturnStatement2.
	self assert: result class equals: PJReturnStatementNode.
	self assert: result expression isNil
!

testShiftExpression1
	super testShiftExpression1.
	self assert: result class equals: PJBooleanLiteralNode
!

testStringLiteral1
        super testStringLiteral1.
        self assert: result class equals: PJStringLiteralNode.
        self assert: result literalValue equals: (String new:0)

    "Modified: / 21-04-2015 / 15:53:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testStringLiteral11
	super testStringLiteral11.
	self assert: result class equals: PJStringLiteralNode.
	self assert: result literalValue equals: 'null'
!

testStringLiteral2
	super testStringLiteral2.
	self assert: result class equals: PJStringLiteralNode.
	self assert: result literalValue equals: '\"'
!

testStringLiteral3
	super testStringLiteral3.
	self assert: result class equals: PJStringLiteralNode.
	self assert: result literalValue equals: 'This is a Java string'
!

testUnaryExpression2
	super testUnaryExpression2.
	self assert: result class equals: PJBooleanLiteralNode
!

testUnaryExpressionNotPlusMinus1
	super testUnaryExpressionNotPlusMinus1.
	self assert: result class equals: PJBooleanLiteralNode
!

testVariableDeclarator1
	super testVariableDeclarator1.
	self assert: result class equals: PJVariableDeclaratorNode.
	self assert: result variable class equals: PJIdentifierNode.
	self assert: result arrayLevel equals: 0.
	self assert: result initializer isNil
!

testVariableDeclarator2
	super testVariableDeclarator2.
	self assert: result class equals: PJVariableDeclaratorNode.
	self assert: result variable class equals: PJIdentifierNode.
	self assert: result arrayLevel equals: 2.
	self assert: result initializer isNil
!

testVariableDeclarator3
	super testVariableDeclarator3.
	self assert: result class equals: PJVariableDeclaratorNode.
	self assert: result variable class equals: PJIdentifierNode.
	self assert: result arrayLevel equals: 0.
	self assert: result initializer notNil
! !

!PPJavaParserTest methodsFor:'testing-literals-integer'!

testIfStatement1
	super testIfStatement1.
	self assert: result class equals: PJIfStatementNode.
	self assert: result condition class equals: PJBooleanLiteralNode. 
	self assert: result thenPart class equals: PJBlockNode.
	self assert: result elsePart isNil
!

testIfStatement2
	super testIfStatement2.
	self assert: result class equals: PJIfStatementNode.
	self assert: result condition class equals: PJBooleanLiteralNode. 
	self assert: result thenPart class equals: PJBlockNode.
	self assert: result elsePart class equals: PJBlockNode.
!

testIfStatement3
	super testIfStatement3.
	self assert: result class equals: PJIfStatementNode.
	self assert: result condition class equals: PJBooleanLiteralNode. 
	self assert: result thenPart class equals: PJBlockNode.
	self assert: result elsePart class equals: PJBlockNode.
!

testIfStatement4
	super testIfStatement4.
	self assert: result class equals: PJIfStatementNode.
	self assert: result condition class equals: PJBooleanLiteralNode. 
	self assert: result thenPart class equals: PJExpressionStatementNode.
	self assert: result elsePart isNil
!

testIfStatement5
	super testIfStatement5.
	self assert: result class equals: PJIfStatementNode.
	self assert: result condition class equals: PJInfixOperationNode. 
	self assert: result thenPart class equals: PJBlockNode.
	self assert: result elsePart isNil
!

testIntegerLiteral1
	super testIntegerLiteral1.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 0.
	self assert: result isLong not
!

testIntegerLiteral10
	super testIntegerLiteral10.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 1996.
	self assert: result isLong not
!

testIntegerLiteral11
	super testIntegerLiteral11.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 16711935.
	self assert: result isLong not
!

testIntegerLiteral2
	super testIntegerLiteral2.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 0.
	self assert: result isLong
!

testIntegerLiteral3
	super testIntegerLiteral3.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 511.
	self assert: result isLong
!

testIntegerLiteral4
	super testIntegerLiteral4.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 4294967296.
	self assert: result isLong
!

testIntegerLiteral5
	super testIntegerLiteral5.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 2147483648.
	self assert: result isLong
!

testIntegerLiteral6
	super testIntegerLiteral6.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 49328.
	self assert: result isLong
!

testIntegerLiteral7
	super testIntegerLiteral7.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 2.
	self assert: result isLong not
!

testIntegerLiteral8
	super testIntegerLiteral8.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 250.
	self assert: result isLong not
!

testIntegerLiteral9
	super testIntegerLiteral9.
	self assert: result class equals: PJIntegerLiteralNode.
	self assert: result literalValue equals: 3671771902.
	self assert: result isLong not
! !

