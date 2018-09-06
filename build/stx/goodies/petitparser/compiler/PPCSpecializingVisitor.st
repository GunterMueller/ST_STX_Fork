"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCRewritingVisitor subclass:#PPCSpecializingVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!


!PPCSpecializingVisitor methodsFor:'visiting'!

visitActionNode: node
    ("(node hasProperty: #trimmingToken) not and: [" node block isSymbol "]") ifTrue: [ 
        self change.
        ^ PPCSymbolActionNode new
            block: node block;
            name: node name;
            child: node child;
            yourself
    ].

    ^ super visitActionNode: node
!

visitForwardNode: node

    self visitChildren: node.

    node name ifNil: [ 
        self change.
        ^ node child.
    ].

    node child name ifNil: [  
        self change.
        node child name: node name.
        ^ node child
    ].

    (node child name = node name) ifTrue: [ 
        self change.
        ^ node child
    ].

    ^ node
!

visitNotNode: node
    self visitChildren: node.

    (node child isKindOf: PPCAbstractLiteralNode) ifTrue: [  
        self change.
        ^ PPCNotLiteralNode new
            name: node name;
            literal: node child literal;
            yourself
    ]. 

    (node child isKindOf: PPCMessagePredicateNode) ifTrue: [  
        self change.
        ^ PPCNotMessagePredicateNode new
            name: node name;
            message: node child message;
            yourself
    ].

    (node child isKindOf: PPCCharSetPredicateNode) ifTrue: [  
        self change.
        ^ PPCNotCharSetPredicateNode new
            name: node name;
            predicate: node child predicate;
            yourself
    ].

    (node child isKindOf: PPCCharacterNode) ifTrue: [  
        self change.
        ^ PPCNotCharacterNode new
            name: node name;
            character: node child character;
            yourself
    ].

    ^ node

    "Modified: / 23-04-2015 / 12:02:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPredicateNode: node
    | charSet |
    
    (node predicate class == PPCharSetPredicate) ifTrue: [ 
        charSet := node predicate.
    ].
    charSet := PPCharSetPredicate on: node predicate.


    (charSet equals: (PPCharSetPredicate on: [ :char | char isLetter])) ifTrue: [ 
        change := true.
        ^ PPCMessagePredicateNode new
            name: node name;
            message: #isLetter;
            predicate: node predicate;
            yourself
    ].


    (charSet equals: (PPCharSetPredicate on: [ :char | char isDigit])) ifTrue: [ 
        change := true.
        ^ PPCMessagePredicateNode new
            name: node name;
            message: #isDigit;
            predicate: node predicate;
            yourself
    ].

    (charSet equals: (PPCharSetPredicate on: [ :char | char isAlphaNumeric])) ifTrue: [ 
        change := true.
        ^ PPCMessagePredicateNode new
            name: node name;
            message: #isAlphaNumeric;
            predicate: node predicate;
            yourself
    ].

    (charSet equals: (PPCharSetPredicate on: [ :char | char isSeparator])) ifTrue: [ 
        change := true.
        ^ PPCMessagePredicateNode new
            name: node name;
            message: #isSeparator;
            predicate: node predicate;
            yourself
    ].

    (charSet equals: (PPCharSetPredicate on: [ :char | true ])) ifTrue: [ 
        change := true.
        ^ PPCAnyNode new
            name: node name;
            yourself
    ].


    change := true.
    ^ PPCCharSetPredicateNode new
        name: node name;
        predicate: charSet;
        yourself.
!

visitStarNode: node
    self visitChildren: node.

    (node child isKindOf: PPCMessagePredicateNode) ifTrue: [ 
        self change.
        ^ PPCStarMessagePredicateNode new
            name: node name;
            child: node child;
            message: node child message;
            yourself
    ].

    (node child isKindOf: PPCAnyNode) ifTrue: [ 
        self change.
        ^ PPCStarAnyNode new
            name: node name;
            child: node child;
            yourself
    ]. 

    (node child isKindOf: PPCCharSetPredicateNode) ifTrue: [ 
        self change.
        ^ PPCStarCharSetPredicateNode new
            name: node name;
            predicate: node child predicate;
            child: node child;
            yourself
    ].

    ^ node
!

visitTokenConsumeNode: node
    "Let the Scanner to handle this stuff"
    ^ node
!

visitTokenizingParserNode: node
    self visitChild: node parser of: node.
    ^ node
!

visitTrimmingTokenNode: node

    self visitChildren: node.

    (node child isKindOf: PPCCharacterNode) ifTrue: [ 
        self change.
        ^ PPCTrimmingCharacterTokenNode new
            child: node child;               
            whitespace: node whitespace;
            tokenClass: node tokenClass;
            name: node name;
            yourself
    ].

    ^ node

    "Modified: / 21-05-2015 / 14:41:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSpecializingVisitor class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

