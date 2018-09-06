"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCRewritingVisitor subclass:#PPCRecognizerComponentVisitor
	instanceVariableNames:'forbiddenNodes'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!

!PPCRecognizerComponentVisitor methodsFor:'accessing'!

forbiddenNodes: nodeSet
    forbiddenNodes := nodeSet.
! !

!PPCRecognizerComponentVisitor methodsFor:'initialization'!

initialize
    super initialize.
    forbiddenNodes := IdentitySet new.
! !

!PPCRecognizerComponentVisitor methodsFor:'traversing'!

beforeAccept: node
    self assert: (forbiddenNodes includes: node) not description: 'Does not look like a token' 
! !

!PPCRecognizerComponentVisitor methodsFor:'visiting'!

visitActionNode: node
    self visitChildren: node.

    self change.
    ^ node child
!

visitSequenceNode: node
    self visitChildren: node.
    self change.
    ^ PPCRecognizingSequenceNode new
        children: node children;
        name: node name;
        properties: node properties;
        yourself	
!

visitStarMessagePredicateNode: node
    self visitChildren: node.
    
    (node message = #isSeparator) ifTrue: [ 
        self change.
        ^ PPCTokenStarSeparatorNode new
            name: node name;
            child: node child;
            message: node message;
            yourself.
    ].
    
    self change.
    ^ PPCTokenStarMessagePredicateNode new
        name: node name;
        message: node message;
        child: node child;
        yourself
!

visitSymbolActionNode: node
    self visitChildren: node.
    
    self change.
    ^ node child
!

visitTokenNode: node
    self visitChildren: node.
    self change.
    ^ node child
! !

