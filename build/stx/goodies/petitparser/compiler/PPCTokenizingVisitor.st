"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCRewritingVisitor subclass:#PPCTokenizingVisitor
	instanceVariableNames:'tokens'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!


!PPCTokenizingVisitor methodsFor:'hooks'!

afterAccept: node retval: parserNode
    self isRoot ifTrue: [ 
        | tokensNode whitespaceNode |
        self change.
"		tokens addLast: self eofToken."
        tokens do: [ :token | token unmarkForInline ].
        whitespaceNode := tokens detect: [ :e | e isTrimmingTokenNode ] ifNone: [ nil ].
        whitespaceNode notNil ifTrue: [ 
                whitespaceNode := whitespaceNode whitespace copy
                    unmarkForInline;
                    name: 'consumeWhitespace';
                    yourself.
                "whitespaceNode := PPCTokenWhitespaceNode new
                    child: whitespaceNode;
                    yourself"
        ] ifFalse: [ 
                whitespaceNode := PPCNilNode new
                    name: 'consumeWhitespace';
                    yourself 
        ].
        
        tokensNode := PPCListNode new
            children: tokens asArray;
            name: 'nextToken';
            yourself.
            
        ^ PPCTokenizingParserNode new
            parser: parserNode;
            whitespace: whitespaceNode;
            tokens: tokensNode;
            name: #mainParser;
            yourself ].
    ^ parserNode
    
    "Modified: / 12-05-2015 / 01:37:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

eofToken
    | ws  |
    self error: 'deprecated?'.
    ws := PPCStarNode new
        child: (PPCMessagePredicateNode new
            message: #isSeparator;
            yourself);
        yourself.
    
    ^ PPCTrimmingTokenNode new
        child: PPCEndOfFileNode new;
        whitespace: ws;
        tokenClass: PPToken;
        name: 'eof'
        yourself.
! !

!PPCTokenizingVisitor methodsFor:'initialization'!

initialize
    super initialize.
    tokens := OrderedCollection new.
! !

!PPCTokenizingVisitor methodsFor:'testing'!

isRoot
    ^ openSet size = 1
! !

!PPCTokenizingVisitor methodsFor:'tokens'!

addToken: token
    (tokens contains: [:e | e == token] ) ifFalse: [ 
        tokens addLast: token
    ]
! !

!PPCTokenizingVisitor methodsFor:'visiting'!

visitActionNode: node
    (node hasProperty: #trimmingToken) ifTrue: [ 
        self halt: 'can this happen?'.
        self change.
        self addToken: node.
        
        ^ PPCTokenConsumeNode new
            child: node;
            yourself	
    ].

    ^ super visitActionNode: node
!

visitTokenConsumeNode: node
    "
        Seems, it might happen, that if I create the consume node, 
        I will ge to it later. This would create a token consume node for the
        child, thus having tokenConsumNode with tokenConsumNode as a child...
    "
    ^ node
!

visitTokenNode: node
    self change.
    self addToken: node.
    
    self assert: node acceptsEpsilon not description: 'Sorry, but the epsilon tokens are not allowed'.
    
    ^ PPCTokenConsumeNode new
        child: node;
        name: node name;
        yourself.
!

visitTrimmingTokenNode: node
    self change.
    self addToken: node.
    
    ^ PPCTokenConsumeNode new
        child: node;
        name: node name;
        yourself.
! !

!PPCTokenizingVisitor class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

