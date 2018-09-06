"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PPJavaSyntax subclass:#PPJavaParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-Core'
!

PPJavaParser comment:'A parser which creates an AST upor parsing the code'
!

!PPJavaParser methodsFor:'accessing'!

annotation 

	^ super annotation ==> [:nodes | PJAnnotationNode typeName: nodes second]
!

classModifierNotAnnotation 

	^super classModifierNotAnnotation ==> [:tokenKeyword | PJModifierNode keyword: tokenKeyword inputValue]
!

formalParameters 

	^ super formalParameters ==> [:nodes | nodes second]
!

methodModifierNotAnnotation 

	^super methodModifierNotAnnotation ==> [:tokenKeyword | PJModifierNode keyword: tokenKeyword inputValue]
!

qualifiedName
	^ super qualifiedName
		==> [ :nodes | 
			nodes second notEmpty
				ifTrue: [ self nameFromQualified: (Array with: nodes first withAll: (nodes second collect: [ :e | e second value ])) ]
				ifFalse: [ PJSimpleNameNode identifier: nodes first value ] ]
! !

!PPJavaParser methodsFor:'as yet unclassified'!

endOfLineComment 
^ super endOfLineComment ==> [ :nodes | PJEndOfLineCommentsNode comment:  nodes second .].
!

floatingPointLiteral

	 ^super floatingPointLiteral trim ==> [ :token | PJFloatLiteralNode newFrom: token inputValue ]
!

separator	

 ^super separator trim ==> [:token | PJSeparatorNode separatorValue: (token inputValue)]
!

traditionalComment
^ super traditionalComment ==> [ :nodes | PJTraditionalCommentsNode comment:  (nodes second ).].
! !

!PPJavaParser methodsFor:'grammar-classes'!

normalClassDeclaration 

	^ super normalClassDeclaration 
! !

!PPJavaParser methodsFor:'grammar-classes-method'!

block
	^ super block ==> [ :nodes | 
			| blockNode |
			blockNode := PJBlockNode new.
			blockNode statements: nodes second.
			blockNode]
!

constructorDeclaration 

        ^ super constructorDeclaration ==> [:nodes |
                |constructor|
                
                constructor := PJConstructorDeclarationNode named: nodes third name.
                constructor
                        statements: (nodes at: 8);
                        modifiers: nodes first;
                        returnType: nodes second;
                        parameters: nodes fourth.
                constructor]

    "Modified: / 21-04-2015 / 15:52:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expressionStatement 
	^ super expressionStatement ==> [ :nodes | 
			| expressionStatementNode |
			expressionStatementNode := PJExpressionStatementNode new.
			expressionStatementNode expression: nodes first.
			expressionStatementNode]
!

localVariableDeclaration
	^ super localVariableDeclaration ==> [ :nodes | 
			| declarationNode |
			declarationNode := PJLocalVariableDeclarationStatementNode new.
			declarationNode
				type: nodes second;
				declarators: (nodes third second collect: [:each | each second]) asOrderedCollection.
			declarationNode declarators addFirst: nodes third first.
			declarationNode]
!

localVariableDeclarationStatement 
	^ super localVariableDeclarationStatement ==> [ :nodes | nodes first]
!

methodNotConstructorDeclaration 

        ^ super methodNotConstructorDeclaration ==> [:nodes |
                        | methodDeclarationNode |
                        methodDeclarationNode := PJMethodDeclarationNode named: nodes fourth name.
                        methodDeclarationNode modifiers: nodes first.
                        methodDeclarationNode returnType: nodes third.
                        methodDeclarationNode body: (nodes at: 8).
                        methodDeclarationNode parameters: nodes fifth.
                        methodDeclarationNode   
                                
                                 ]

    "Modified: / 21-04-2015 / 15:52:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

normalParameterDecl  

	^ super normalParameterDecl ==> [:nodes |
		| declarator |
		
		declarator := PJParameterDeclaratorNode new.
		declarator
			modifiers: nodes first;
			type: nodes second;
			identifier: nodes third;
			arrayLevel: nodes fourth size.
		declarator]
!

normalParametersDecls
	^ super normalParametersDecls ==> [ :nodes | 
			| declarationNode |
			((nodes second collect: [ :element | element second ]) asOrderedCollection)
				addFirst: nodes first; yourself]
!

nullLiteral
	 ^super nullLiteral trim ==> [:token | PJNullLiteralNode literalValue: (token inputValue)]
!

returnStatement
	^ super returnStatement ==> [ :nodes | 
			| returnNode |
			returnNode := PJReturnStatementNode new.
			returnNode expression: nodes second.
			returnNode]
!

variableDeclarator 

	^ super variableDeclarator ==> [:nodes |
		| declarator |
		
		declarator := PJVariableDeclaratorNode new.
		declarator
			variable: nodes first;
			arrayLevel: nodes second size.
		nodes third ifNotNilDo: [:node | declarator initializer: node second].	
		declarator]
! !

!PPJavaParser methodsFor:'grammar-literals-boolean'!

booleanLiteral 

 ^ super booleanLiteral trim ==> [:token | 
		| value |
		(token inputValue = 'false') 
			ifTrue:  [ value := false]
			ifFalse: [(token inputValue = 'true') 
				ifTrue: [value := true]
				ifFalse: [self error: 'A Boolean Literal must be either false or true']].
		PJBooleanLiteralNode booleanValue: value.]
! !

!PPJavaParser methodsFor:'grammar-literals-string'!

additiveExpression 

	^ super additiveExpression ==> self infixOpProcessor  .
!

andExpression 

	^ super andExpression ==> self infixOpProcessor
!

characterLiteral 
 ^super characterLiteral trim ==> [:token | PJCharacterLiteralNode literalValue: (token inputValue allButFirst allButLast)]
!

classOrInterfaceType 
	self flag: 'NA: temporary hack, should interpret nodes instead of returning first'.
	^ super classOrInterfaceType ==> [ :nodes | nodes first ]
!

conditionalAndExpression 

	^ super conditionalAndExpression ==> self infixOpProcessor
!

conditionalExpression 

 ^super conditionalExpression ==> [:node | node second ifNil: [node first] ifNotNil: [node]]
!

conditionalOrExpression 

	^ super conditionalOrExpression ==> self infixOpProcessor
!

equalityExpression 

	^ super equalityExpression ==> self infixOpProcessor
!

exclusiveOrExpression 

	^ super exclusiveOrExpression ==> self infixOpProcessor
!

expression 

 ^super expression ==> [:node | node second ifNil: [node first] ifNotNil: [
		|operation| 
		operation := PJInfixOperationNode new.
		operation
			left: node first;
			operator: node second first inputValue asSymbol;
			right: node second second.
		operation]]
!

identifier 

 ^super identifier ==> [:token | PJIdentifierNode newWithName: token inputValue]
!

identifierWithAccessors 

	^ super identifierWithAccessors ==> [:node | node second isEmpty & node third isNil ifTrue: [node first] ifFalse: [node]]
!

ifStatement  

 ^super ifStatement ==> [:node |
	| statementNode |
	statementNode := PJIfStatementNode new.
	statementNode
		condition: node second;
		thenPart: node third.
	node fourth ifNotNil: [
		statementNode elsePart: node fourth second].
	statementNode]
!

inclusiveOrExpression 

 ^super inclusiveOrExpression ==> self infixOpProcessor
!

infixOpProcessor 

	^ [:node |
		(node second asOrderedCollection addFirst: node first; yourself) fold: [:left :current |
			|operation| 
			operation := PJInfixOperationNode new.
			operation
			left: left;
			operator: current first inputValue asSymbol;
			right: current second.
			operation]]
!

instanceofExpression 

 ^super instanceofExpression ==> [:node | node second ifNil: [node first] ifNotNil: [node]]
!

integerLiteral 

 ^super integerLiteral trim ==> [ :token | PJIntegerLiteralNode newFrom: token inputValue ]
!

multiplicativeExpression 
	^ super multiplicativeExpression ==> self infixOpProcessor
!

parExpression 

 ^super parExpression ==> [ :nodes | nodes second ]
!

primaryWithselectors 
	^ super primaryWithselectors ==> [:node |
		"JK: I have no idea, what this fold is supposed to do, 
		 but #object: causes DNU, so I commented it out
		"
		node first ]
		"(node second asOrderedCollection addFirst: node first; yourself) fold: [:inner :outer | outer object: inner]]
		"
!

primitiveType 

 ^super primitiveType ==> [:token | PJPrimitiveTypeNode type: token inputValue]
!

relationalExpression 

 ^super relationalExpression ==> self infixOpProcessor
!

shiftExpression 

 ^super shiftExpression ==> [:node | node second ifEmpty: [node first] ifNotEmpty: [node]]
!

stringLiteral 

 ^super stringLiteral trim ==> [:token | PJStringLiteralNode literalValue: (token inputValue allButFirst allButLast)]
!

type
	^ super type
		==> [ :nodes | 
			| pjtype |
			nodes second notEmpty
				ifTrue: [ pjtype := PJArrayTypeNode elementType: nodes first dimensions: nodes second size ]
				ifFalse: [ pjtype := nodes first ].
			pjtype ]
!

unaryPostfixExpression 
	^ super unaryPostfixExpression ==> [:node | node second ifNil: [node first] ifNotNil: [node]]
!

whileStatement  

 ^super whileStatement ==> [ :nodes |
	| while | 
	while := PJWhileStatementNode new.
	while expression: nodes second.
	while statement: nodes third.
	while ]
! !

!PPJavaParser methodsFor:'private'!

nameFromQualified: aCollection

	^(aCollection size = 1)
		ifTrue: [PJSimpleNameNode identifier: aCollection first]
          ifFalse: [
			PJQualifiedNameNode 
				name: (PJSimpleNameNode identifier: aCollection last)
				qualifier: (self nameFromQualified: aCollection allButLast ).]
! !

