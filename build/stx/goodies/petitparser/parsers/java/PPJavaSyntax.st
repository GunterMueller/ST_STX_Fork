"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PPJavaLexicon subclass:#PPJavaSyntax
	instanceVariableNames:'compilationUnit annotations packageDeclaration importDeclaration
		typeDeclaration qualifiedName annotation
		classOrInterfaceDeclaration classDeclaration interfaceDeclaration
		normalClassDeclaration enumDeclaration classModifiers
		typeParameters type typeList classBody jsuper interfaces
		typeParameter typeBound enumBody enumConstants
		enumBodyDeclarations enumConstant arguments classBodyDeclaration
		normalInterfaceDeclaration annotationTypeDeclaration
		interfaceModifiers interfaceBody interfaceBodyDeclaration block
		fieldDeclaration methodDeclaration methodModifiers
		formalParameters throws qualifiedNameList
		explicitConstructorInvocation blockStatement fieldModifiers
		variableDeclarators variableDeclarator variableInitializer
		interfaceFieldDeclaration interfaceMethodDeclaration
		classOrInterfaceType primitiveType typeArguments typeArgument
		formalParameterDecls ellipsisParameterDecl normalParameterDecl
		variableModifiers nonWildcardTypeArguments primary
		elementValuePairs elementValue elementValuePair
		conditionalExpression elementValueArrayInitializer
		annotationTypeBody annotationTypeElementDeclaration
		annotationMethodDeclaration localVariableDeclarationStatement
		statement localVariableDeclaration expression parExpression
		ifStatement assertStatement basicForStatement
		enhancedForStatement forInit expressionList forStatement
		whileStatement catches catchClause formalParameter doStatement
		tryStatement switchBlockStatementGroup switchLabel
		switchStatement synchronizedStatement returnStatement
		throwStatement breakStatement continueStatement
		expressionStatement labeledStatement emptyStatement
		assignmentOperator conditionalOrExpression
		conditionalAndExpression inclusiveOrExpression
		exclusiveOrExpression andExpression equalityExpression
		instanceofExpression relationalExpression shiftExpression
		relationalOperator additiveExpression shiftOperator
		multiplicativeExpression unaryExpression
		unaryExpressionNotPlusMinus castExpression selector innerCreator
		superSuffix identifierSuffix creator classCreatorRest
		arrayCreator createdName arrayInitializer constructorDeclaration
		constructorModifiers methodNotConstructorDeclaration wildcard
		emptySquaredParenthesis methodModifierNotAnnotation
		classModifierNotAnnotation unaryNegationExpression
		unaryPostfixExpression primaryWithselectors
		startMethodDeclaration identifierWithAccessors
		normalParametersWithElipsisDecls normalParametersDecls
		blockStatements statementWithoutTrailingSubstatement integralType
		floatingPointType numericType finally'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-Core'
!

PPJavaSyntax comment:'Parses Java code into lots of arrays. This parser has a full java gramar coverage'
!

!PPJavaSyntax class methodsFor:'as yet unclassified'!

parseMethod: aString
	^ self new parseMethod: aString
!

parseMethod: aString onError: aBlock
	^ self new parseMethod: aString onError: aBlock
! !

!PPJavaSyntax methodsFor:'accessing'!

start
	"Default start production."

	^ compilationUnit end
! !

!PPJavaSyntax methodsFor:'as yet unclassified'!

fieldAccessExpression 


	^(
" Primary.Identifier"
	(primary , (self tokenFor: '.'), identifier)
"Super.Identifier"
	/((self tokenFor: 'super'), superSuffix )
"ClassName.super.Identifier"
	/(identifier,(self tokenFor: '.'),(self tokenFor: 'super'),superSuffix)
	)plus.
!

finally
^ ((self tokenFor: 'finally'), block).
!

integralType
	^ (self tokenFor: 'byte')
		/ (self tokenFor: 'short')
		/ (self tokenFor: 'int')
		/ (self tokenFor: 'long')
		/ (self tokenFor: 'char')
! !

!PPJavaSyntax methodsFor:'grammar'!

arguments 

	^(self tokenFor: '('),
		expressionList optional,
	(self tokenFor: ')')
!

arrayCreator

	^ 	(	(self tokenFor: 'new') , createdName ,
			emptySquaredParenthesis plus,
			arrayInitializer)
			
		/(	(self tokenFor: 'new'), createdName ,
			((self tokenFor: '['), expression , (self tokenFor: ']')) plus,
			emptySquaredParenthesis star)
!

arrayInitializer 

	^ (self tokenFor: '{'),
		(variableInitializer , ((self tokenFor: ','), variableInitializer ) star) optional,
		(self tokenFor: ',') optional,
	   (self tokenFor: '}')
!

block 

	^ (self tokenFor: '{') ,
		blockStatements,
	 (self tokenFor: '}')
!

classCreatorRest 

	^	arguments , classBody optional
!

compilationUnit 

	^ (annotations optional, packageDeclaration) optional , importDeclaration star , typeDeclaration plus
!

createdName 

	^ classOrInterfaceType 
	/	primitiveType 
!

creator
		
	^	(	(self tokenFor: 'new'), nonWildcardTypeArguments optional , classOrInterfaceType , classCreatorRest)
		/	arrayCreator
!

elementValue 

	^conditionalExpression
	/ annotation 
	/ elementValueArrayInitializer
!

elementValueArrayInitializer

	^ (self tokenFor: '{') ,
		(elementValue , 
			((self tokenFor: ',') , elementValue ) star
		) optional ,
		((self tokenFor: ',') optional ),
	  (self tokenFor: '}')
!

elementValuePair 

	^ identifier , (self tokenFor: '=') , elementValue 
!

elementValuePairs 

	^ elementValuePair , ((self tokenFor: ',') , elementValuePair ) star
!

explicitConstructorInvocation

	^ (
		(	nonWildcardTypeArguments optional,
			((self tokenFor: 'this') / (self tokenFor: 'super')))
		
		/	(primary ,
			(self tokenFor: '.') ,
			nonWildcardTypeArguments optional,
			(self tokenFor: 'super'))) ,
		
		arguments , 
		(self tokenFor: ';')
!

identifierWithAccessors
	^ identifier,
	((self tokenFor: '.'), identifier ) star,
	identifierSuffix optional
!

importDeclaration 

^	((self tokenFor: 'import') , (self tokenFor: 'static') optional , identifier),
	(	(	(self tokenFor: '.') , (self tokenFor: '*'))
		/(	((self tokenFor: '.') , identifier) plus , ((self tokenFor: '.') , (self tokenFor: '*')) optional)
	),
	(self tokenFor: ';')
!

innerCreator 

	^	(self tokenFor: '.'), (self tokenFor: 'new'),
		nonWildcardTypeArguments optional,
		identifier ,
		typeArguments optional,
		classCreatorRest 
!

interfaces

	^ (self tokenFor: 'implements') , typeList
!

jsuper

	^ (self tokenFor: 'extends') , type
!

nonWildcardTypeArguments 

	^(self tokenFor: '<'),
		typeList ,
	(self tokenFor: '>')
!

packageDeclaration 

	^ (self tokenFor: 'package') , qualifiedName , (self tokenFor: ';')
!

primary 

	^		parExpression 
		/(	(self tokenFor: 'this'),
			((self tokenFor: '.'), identifier ) star,
			identifierSuffix optional)
		/	identifierWithAccessors
		/(	(self tokenFor: 'super'), superSuffix )
		/	literal
		/	creator
		/(	primitiveType,
			emptySquaredParenthesis star,
			(self tokenFor: '.'), (self tokenFor: 'class'))
		/(	(self tokenFor: 'void'), (self tokenFor: '.'), (self tokenFor: 'class'))
			
!

qualifiedName 

	^ identifier , ((self tokenFor: '.'), identifier ) star
!

typeBound 

	^ type , ((self tokenFor: '&') , type) star
!

typeDeclaration

	^ (self tokenFor: ';') / classOrInterfaceDeclaration
!

typeList 

	^ type , ((self tokenFor: ','), type) star
!

typeParameter 

	^ identifier , ((self tokenFor: 'extends') , typeBound) optional
!

typeParameters 

	^ (self tokenFor: '<') , 
			typeParameter , 
			((self tokenFor: ',') , typeParameter) star , 
		(self tokenFor: '>')
!

unaryExpressionNotPlusMinus 
	
	^ unaryNegationExpression
	 /castExpression
	 /unaryPostfixExpression
!

variableInitializer 

	^	arrayInitializer 
	/	expression	
! !

!PPJavaSyntax methodsFor:'grammar-annotations'!

annotation 

	^(self tokenFor: '@') , qualifiedName ,
	((self tokenFor: '(') , 
		(elementValuePairs / elementValue) optional , 
		(self tokenFor: ')') ) optional
!

annotationMethodDeclaration
	self flag: 'check whether method modifiers are the right modifiers to use'.
	
	^ methodModifiers ,
	type ,
	identifier ,
	(self tokenFor: '('), (self tokenFor: ')'),
	((self tokenFor: 'default'), elementValue ) optional ,
	(self tokenFor: ';')
!

annotationTypeBody

	^ (self tokenFor: '{')  ,
	(annotationTypeElementDeclaration star),
	(self tokenFor: '}')
!

annotationTypeDeclaration 

	^ interfaceModifiers , (self tokenFor: '@'),
	(self tokenFor: 'interface') ,
	identifier ,
	annotationTypeBody
!

annotationTypeElementDeclaration
	
	^ annotationMethodDeclaration
	/ interfaceFieldDeclaration 
	/ normalClassDeclaration
	/ enumDeclaration 
	/ annotationTypeDeclaration 
	/ (self tokenFor: ';')
!

annotations 
	
	^ annotation plus
! !

!PPJavaSyntax methodsFor:'grammar-classes'!

classBody 

	^ (self tokenFor: '{') , classBodyDeclaration star , (self tokenFor: '}')
!

classBodyDeclaration 

	^ (self tokenFor: ';')
	/ ((self tokenFor: 'static') optional , block)
	/ fieldDeclaration
	/ methodDeclaration
	/ classDeclaration 
	/ interfaceDeclaration 
	
!

classDeclaration 

	^ normalClassDeclaration 
	/ enumDeclaration
!

classOrInterfaceDeclaration

	^ classDeclaration 
	/ interfaceDeclaration
!

classOrInterfaceType 

	^ identifier ,
	typeArguments optional,
	((self tokenFor: '.'), identifier , typeArguments optional ) star
!

ellipsisParameterDecl

	^ variableModifiers ,
	type ,
	('...' asParser token trim) ,
	identifier
!

fieldDeclaration
		
		^ fieldModifiers , type , variableDeclarators , (self tokenFor: ';')
!

fieldModifiers

	^ ((self tokenFor: 'volatile') /
		(self tokenFor: 'final') /
		(self tokenFor: 'protected') /
		(self tokenFor: 'private') /
		(self tokenFor: 'public') /
		(self tokenFor: 'static') /
		(self tokenFor: 'transient') /
		annotation) star
!

floatingPointType
	^ (self tokenFor: 'float')
		/ (self tokenFor: 'double').
		
!

formalParameter 

	^ variableModifiers ,
	type ,
	identifier ,
	emptySquaredParenthesis star
!

formalParameterDecls
	
	^ ellipsisParameterDecl
	/  normalParametersWithElipsisDecls 
	/  normalParametersDecls 
!

formalParameters 

	^ (self tokenFor: '(') ,
	formalParameterDecls optional ,
	(self tokenFor: ')')
!

normalClassDeclaration 

	^ classModifiers , (self tokenFor: 'class') , identifier ,
		typeParameters optional,
		jsuper optional,
		interfaces optional ,
		classBody
!

normalParameterDecl

	^ variableModifiers ,
	type ,
	identifier ,
	emptySquaredParenthesis star
!

normalParametersDecls
	
	^ normalParameterDecl , 
		((self tokenFor: ',') , normalParameterDecl) star
!

normalParametersWithElipsisDecls
	
	^ (normalParameterDecl , 
		(self tokenFor: ',')) plus , 
		ellipsisParameterDecl
!

numericType 
	^  integralType / floatingPointType
!

primitiveType 

	^ (self tokenFor: 'boolean')  / numericType
		
!

type 

	^ (	classOrInterfaceType 
		/ primitiveType
	), 
	emptySquaredParenthesis star
!

typeArgument 

	^ type
	/ wildcard
!

typeArguments 

	^ (self tokenFor: '<') , 
		(typeArgument , ((self tokenFor: ','), typeArgument) star ) , 
	(self tokenFor: '>')
!

variableDeclarator 

	^ identifier ,
	((self tokenFor: '[') , (self tokenFor: ']')) star ,
	((self tokenFor: '=') , variableInitializer) optional
!

variableDeclarators

	^ variableDeclarator , ((self tokenFor: ','), variableDeclarator) star
!

wildcard 

	^ (self tokenFor: '?') ,
		(	((self tokenFor: 'extends')/(self tokenFor: 'super')), 
			type 
		) optional
! !

!PPJavaSyntax methodsFor:'grammar-classes-enum'!

enumBody 

	^ (self tokenFor: '{') ,
		enumConstants optional ,
		(self tokenFor: ',') optional ,
		enumBodyDeclarations optional ,
		(self tokenFor: '}')
!

enumBodyDeclarations 

	^ (self tokenFor: ';') , classBodyDeclaration star
!

enumConstant

	^ annotations optional , identifier , arguments optional , classBody optional 
!

enumConstants 

	^ enumConstant , ((self tokenFor: ',') , enumConstant) star
!

enumDeclaration 

	^ classModifiers ,
	   (self tokenFor: 'enum'),
	   identifier ,
	   interfaces optional,
	   enumBody
! !

!PPJavaSyntax methodsFor:'grammar-classes-interface'!

interfaceBody

	^ (self tokenFor: '{') , interfaceBodyDeclaration star , (self tokenFor: '}')
!

interfaceBodyDeclaration 

	^ interfaceFieldDeclaration
	/ interfaceMethodDeclaration
	/ interfaceDeclaration 
	/ classDeclaration 
	/ (self tokenFor: ';')
!

interfaceDeclaration 

	^normalInterfaceDeclaration 
	/ annotationTypeDeclaration
!

interfaceFieldDeclaration 

	^ fieldModifiers , 
	type ,
	variableDeclarators ,
	(self tokenFor: ';')
!

interfaceMethodDeclaration 

	^ methodModifiers ,
	typeParameters optional,
	((self tokenFor: 'void') / type) ,
	identifier ,
	formalParameters ,
	emptySquaredParenthesis star ,
	throws optional ,
	(self tokenFor: ';')
!

interfaceModifiers

	^ ((self tokenFor: 'abstract')
		/(self tokenFor: 'protected') 
		/(self tokenFor: 'private') 
		/(self tokenFor: 'public') 
		/(self tokenFor: 'static')
		/(self tokenFor: 'strictfp') 
		/annotation) star
!

normalInterfaceDeclaration

	^ interfaceModifiers , 
	(self tokenFor: 'interface') , 
	identifier , 
	typeParameters optional , 
	((self tokenFor: 'extends') , typeList ) optional ,
	interfaceBody
! !

!PPJavaSyntax methodsFor:'grammar-classes-method'!

constructorDeclaration

	^ constructorModifiers optional , 
	   typeParameters optional , 
	   identifier,
	   formalParameters ,
	   throws optional , 
	   (self tokenFor: '{' ) , 
			explicitConstructorInvocation optional ,
			blockStatement star ,
	   (self tokenFor: '}')
	
!

constructorModifiers 

	^ ((self tokenFor: 'protected')
		/ (self tokenFor: 'private')
		/ (self tokenFor: 'public')
		/ annotation) plus
!

methodDeclaration

	^ constructorDeclaration 
	/ methodNotConstructorDeclaration
!

methodModifierNotAnnotation

	^ (self tokenFor: 'abstract')
		/ (self tokenFor: 'final')
		/ (self tokenFor: 'native')
		/ (self tokenFor: 'protected')
		/ (self tokenFor: 'private')
		/ (self tokenFor: 'public')
		/ (self tokenFor: 'static')
		/ (self tokenFor: 'strictfp') 
		/ (self tokenFor: 'synchronized') 
!

methodModifiers 

	^ (	methodModifierNotAnnotation
		/ annotation) star
!

methodNotConstructorDeclaration

	^ methodModifiers,
	   typeParameters optional,
	   ((self tokenFor: 'void') / type),
	   identifier,
	   formalParameters ,
	   emptySquaredParenthesis star ,
	   throws optional,
	   (block / (self tokenFor: ';'))
!

parseMethod: aString 
	^ self parseMethod: aString onError: [ :msg :pos | self error: msg ]
!

parseMethod: aString onError: aBlock
	^ startMethodDeclaration parse: aString onError: aBlock
!

qualifiedNameList 

	^ qualifiedName , ((self tokenFor: ',') , qualifiedName ) star
!

startMethodDeclaration

	^ methodDeclaration end
!

throws 

	^ (self tokenFor: 'throws') , qualifiedNameList
! !

!PPJavaSyntax methodsFor:'grammar-expressions'!

additiveExpression

	^ multiplicativeExpression , 
	(( (self tokenFor: '+') / (self tokenFor: '-') ) , multiplicativeExpression ) star
!

andExpression

	^ equalityExpression , ((self tokenFor: '&') , equalityExpression) star
!

assignmentOperator 

	^ (self tokenFor: '=')
	/ (self tokenFor: '>>>=')
	/	(self tokenFor: '>>=')
	/	(self tokenFor: '<<=')
	/	(self tokenFor: '&=')
	/	(self tokenFor: '^=')
	/	(self tokenFor: '|=')
	/	(self tokenFor: '-=')
	/	(self tokenFor: '+=')
	/	(self tokenFor: '%=')
	/	(self tokenFor: '/=')
	/	(self tokenFor: '*=')
		
!

castExpression

	^ ((self tokenFor: '('), 
			primitiveType ,
		(self tokenFor: ')'), unaryExpression )
		
	/ ((self tokenFor: '('),
			type,
		(self tokenFor: ')'), unaryExpressionNotPlusMinus )
!

conditionalAndExpression 

	^inclusiveOrExpression ,
	((self tokenFor: '&&'), inclusiveOrExpression ) star
!

conditionalExpression 

	^conditionalOrExpression ,
	((self tokenFor: '?'), expression , (self tokenFor: ':'), conditionalExpression ) optional
!

conditionalOrExpression 

	^conditionalAndExpression ,
	((self tokenFor: '||'), conditionalAndExpression ) star
!

equalityExpression

	^ instanceofExpression , 
	(((self tokenFor: '!!=') / (self tokenFor: '==')) , instanceofExpression) star
!

exclusiveOrExpression

	^ andExpression , ((self tokenFor: '^') , andExpression) star
!

expression 

	^ conditionalExpression , 
	(assignmentOperator , expression) optional
!

identifierSuffix 

	^ (		emptySquaredParenthesis plus , (self tokenFor: '.'), (self tokenFor: 'class'))
		/	(((self tokenFor: '[') , expression , (self tokenFor: ']')) plus)
		/	arguments 
		/	((self tokenFor: '.'),
			(	(self tokenFor: 'class')
			/	(self tokenFor: 'this')
			/	((self tokenFor: 'super'), arguments)
			/	(nonWildcardTypeArguments , identifier , arguments)))
		/	innerCreator
!

inclusiveOrExpression

	^ exclusiveOrExpression , 
	((self tokenFor: '|') , exclusiveOrExpression) star
!

instanceofExpression

	^  relationalExpression , 
	((self tokenFor: 'instanceof') , type) optional
!

multiplicativeExpression

	^ unaryExpression , 
	(( (self tokenFor: '*') 
	   / (self tokenFor: '/') 
	   / (self tokenFor: '%') ) , unaryExpression ) star
!

parExpression

	^ (self tokenFor: '(') , expression , (self tokenFor: ')')
!

primaryWithselectors
	^ primary, selector star
!

relationalExpression

	^  shiftExpression , 
	(relationalOperator , shiftExpression) star
!

relationalOperator

	^ (self tokenFor: '<=')
	/ (self tokenFor: '>=')
	/	(self tokenFor: '<')
	/	(self tokenFor: '>')
!

selector 

	^	(	(self tokenFor: '.') , identifier, arguments optional )
		/(	(self tokenFor: '.'), (self tokenFor: 'this'))
		/(	(self tokenFor: '.'), (self tokenFor: 'super'), superSuffix)
		/	innerCreator 
		/(	(self tokenFor: '['), expression , (self tokenFor: ']'))
!

shiftExpression

	^ additiveExpression,
	(shiftOperator , additiveExpression) star
!

shiftOperator 
	self flag: 'maybe it should be detokenized, check the behavior with javac'.

	^ (self tokenFor: '<<')
	/ (self tokenFor: '>>>')
	/	(self tokenFor: '>>')
!

statementWithoutTrailingSubstatement 

	^ (block/ emptyStatement/ expressionStatement/assertStatement/switchStatement/ doStatement/ breakStatement).
!

superSuffix 

	^ arguments 
	/ (	(self tokenFor: '.'), typeArguments optional ,
		identifier ,
		arguments optional)
!

unaryExpression 

	^ (((self tokenFor: '++')
		/(self tokenFor: '+')
		/(self tokenFor: '--')
		/(self tokenFor: '-')),
			unaryExpression)
	/unaryExpressionNotPlusMinus
!

unaryNegationExpression
	^ ((self tokenFor: '~') / (self tokenFor: '!!')), unaryExpression
!

unaryPostfixExpression
	^ primaryWithselectors,
	  ( (self tokenFor: '++')
	   /(self tokenFor: '--')) optional
! !

!PPJavaSyntax methodsFor:'grammar-modifiers'!

classModifierNotAnnotation

	^	(self tokenFor: 'abstract') 
	/	(self tokenFor: 'final') 
	/	(self tokenFor: 'protected') 
	/	(self tokenFor: 'private') 
	/	(self tokenFor: 'public') 
	/	(self tokenFor: 'static')
	/	(self tokenFor: 'strictfp') 
		
!

classModifiers

	^ (classModifierNotAnnotation 
		/annotation) star
!

variableModifiers 

	^((self tokenFor: 'final') 
	  / annotation) star
! !

!PPJavaSyntax methodsFor:'grammar-statements'!

assertStatement 

	^ (self tokenFor: 'assert') , expression , 
	((self tokenFor: ':'), expression ) optional ,
	(self tokenFor: ';')
!

basicForStatement

	^ (self tokenFor: 'for') ,
	(self tokenFor: '('),
		forInit optional, (self tokenFor: ';'),
		expression , (self tokenFor: ';'),
		expressionList optional,
	(self tokenFor: ')'),
	statement
		
!

blockStatement  

	^ localVariableDeclarationStatement
	/ classOrInterfaceDeclaration 
	/ statement
!

blockStatements

	^ (blockStatement star).
!

breakStatement 

	^ (self tokenFor: 'break') , identifier optional , (self tokenFor: ';')
!

catchClause

	^ (self tokenFor: 'catch') ,
	(self tokenFor: '(') ,
		formalParameter ,
	(self tokenFor: ')'), 
	block
	
!

catches  

		^ catchClause plus
!

continueStatement 

	^ (self tokenFor: 'continue') , identifier optional , (self tokenFor: ';')
!

doStatement

	^(self tokenFor: 'do') , statement ,
	(self tokenFor: 'while') , parExpression ,
	(self tokenFor: ';')
!

emptyStatement 

	^ (self tokenFor: ';')
!

enhancedForStatement

	^ (self tokenFor: 'for') , 
	(self tokenFor: '(') , 
		variableModifiers , 
		type , 
		identifier , 
		(self tokenFor: ':'),
		expression,
	(self tokenFor: ')'),
	statement
!

expressionList 

	^ expression , ((self tokenFor: ','), expression ) star
!

expressionStatement 

	^ expression , (self tokenFor: ';')
!

forInit

	^ localVariableDeclaration 
	/ expressionList 
!

forStatement

	^ enhancedForStatement 
	/ basicForStatement
!

ifStatement

	^(self tokenFor: 'if') , parExpression , statement , 
	((self tokenFor: 'else'), statement ) optional
!

labeledStatement 

	^ identifier , (self tokenFor: ':') , statement 
!

localVariableDeclaration

	^ variableModifiers , type , variableDeclarators 
!

localVariableDeclarationStatement

	^ localVariableDeclaration , (self tokenFor: ';')
!

returnStatement 

	^ (self tokenFor: 'return') , expression optional , (self tokenFor: ';')
!

statement 

	^ statementWithoutTrailingSubstatement
	/ ifStatement
	/ forStatement
	/ whileStatement
	/ tryStatement
	/ synchronizedStatement
	/ returnStatement
	/ throwStatement
	/ continueStatement
	/ labeledStatement
	
!

switchBlockStatementGroup
	
	^ switchLabel , blockStatement star
!

switchLabel 

	^ ((self tokenFor: 'case') , expression , (self tokenFor: ':'))
	/ ((self tokenFor: 'default'), (self tokenFor: ':'))
!

switchStatement

	^(self tokenFor: 'switch') , parExpression , 
	(self tokenFor: '{'),
		switchBlockStatementGroup star ,
	(self tokenFor: '}')
!

synchronizedStatement 

	^ (self tokenFor: 'synchronized') , parExpression , block
!

throwStatement 

	^ (self tokenFor: 'throw') , expression , (self tokenFor: ';')
!

tryStatement 

	^ (self tokenFor: 'try') , block ,
	(	(catches , (self tokenFor: 'finally') , block)
		/ catches
		/ finally 
	).
!

whileStatement

	^(self tokenFor: 'while') , parExpression , statement
! !

