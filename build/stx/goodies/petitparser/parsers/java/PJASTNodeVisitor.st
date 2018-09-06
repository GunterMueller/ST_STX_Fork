"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PJASTNodeVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST-Visitors'
!

PJASTNodeVisitor comment:'Abstract visitor with all methods needed to visit a PetitJava AST'
!

!PJASTNodeVisitor methodsFor:'as yet unclassified'!

visitEndOfLineCommentsNode: anEndOfLineCommentNode
	self visitNode: anEndOfLineCommentNode expression
!

visitTraditionalCommentsNode: aCommentNode
	self visitNode: aCommentNode expression
! !

!PJASTNodeVisitor methodsFor:'visiting'!

visitNode: aNode 

	^aNode acceptVisitor: self
! !

!PJASTNodeVisitor methodsFor:'visitor-doubleDispatching'!

visitBlockNode: aBodyNode
	self visitNodes: aBodyNode statements
!

visitBooleanLiteralNode: aBooleanLiteralNode
	self subclassResponsibility
!

visitCharacterLiteralNode: aCharacterLiteralNode
	self subclassResponsibility
!

visitCommentsNode: aCommentNode
	self visitNode: aCommentNode expression
!

visitCompilationUnitNode: aCompilationUnitNode

	self flag: 'TODO'
!

visitExpressionStatementNode: anExpressionStatementNode
	self visitNode: anExpressionStatementNode expression
!

visitFloatLiteralNode: aIntegerLiteralNode
	self subclassResponsibility
!

visitIdentifierNode: anIdentifierNode
	self subclassResponsibility
!

visitIfStatementNode: anIfStatementNode

	self visitNode: anIfStatementNode condition.
	self visitNode: anIfStatementNode thenPart.
	self visitNode: anIfStatementNode elsePart
!

visitImportDeclarationNode: anImportDeclarationNode

	self visitNode: anImportDeclarationNode nameNode
!

visitInfixOperationNode: anInfixOperationNode
	self visitNode: anInfixOperationNode left.
	self visitNode: anInfixOperationNode right
!

visitIntegerLiteralNode: aIntegerLiteralNode
	self subclassResponsibility
!

visitLocalVariableDeclarationStatementNode: aLocalVariableDeclarationStatementNode
	self visitNode: aLocalVariableDeclarationStatementNode type.
	self visitNodes: aLocalVariableDeclarationStatementNode modifiers.
	self visitNode: aLocalVariableDeclarationStatementNode declarators
!

visitMethodDeclarationNode: aMethodDeclarationNode
	self visitNode: aMethodDeclarationNode returnType.
	self visitNode: aMethodDeclarationNode simpleName.
	self visitNode: aMethodDeclarationNode block
!

visitNameNode: aNameNode
	"this is a leaf, so no further traversing"
!

visitNodes: aCollection
	aCollection do: [:each | each acceptVisitor: self]
!

visitNullLiteralNode: aNullLiteralNode
	self subclassResponsibility
!

visitPackageDeclarationNode: aPackageDeclarationNode

	self visitNode: aPackageDeclarationNode nameNode
!

visitParameterDeclaratorNode: aParameterDeclaratorNode
	self visitNode: aParameterDeclaratorNode identifier.
	self visitNodes: aParameterDeclaratorNode modifiers
!

visitReturnStatementNode: aReturnStatementNode
	self visitNode: aReturnStatementNode expression
!

visitSeparatorNode: aSeparatorNode
	self subclassResponsibility
!

visitStringLiteralNode: aStringLiteralNode
	self subclassResponsibility
!

visitVariableDeclaratorNode: aVariableDeclaratorNode
	self visitNode: aVariableDeclaratorNode variable.
	self visitNode: aVariableDeclaratorNode initializer
!

visitWhileStatementNode: aWhileStatementNode

	self visitNode: aWhileStatementNode expression.
	self visitNode: aWhileStatementNode statement
! !

