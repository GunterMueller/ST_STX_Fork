"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCRewritingVisitor subclass:#PPCTokenVisitor
	instanceVariableNames:'forbiddenNodes'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!

!PPCTokenVisitor methodsFor:'as yet unclassified'!

visitActionNode: node	

    (node hasProperty: #trimmingToken) ifTrue: [ 
        | child newChild | 
        "trimming token in token, remove it"
        self change.
        
        child := node child secondChild.
        newChild := self visit: child.
        
        child name isNil ifTrue: [ 
            newChild name: node name.
            ^ newChild.
        ].
        ^ PPCForwardNode new
            child: newChild;
            name: node name;
            yourself
    ].

    ^ super visitActionNode: node
!

visitTokenNode: node
    "token in token, remove the token"
    self visitChildren: node.
    
    node child name isNil ifTrue: [ 
        self change.
        node child name: node name.
        ^ node child
    ].

 	self change.
    ^ PPCForwardNode new
        child: node child;
        name: node name;
        yourself	
! !

!PPCTokenVisitor methodsFor:'traversing'!

afterAccept: node retval: retval

    (retval name isNil not and: [ (retval name endsWith: '_ws') ]) ifTrue: [ 
        self change.
        ^ PPCTokenWhitespaceNode new
            child: retval;
            yourself
    ].
    ^ super afterAccept: node retval: retval
!

beforeAccept: node
    self assert: (forbiddenNodes includes: node) not description: 'Does not look like a token' 
!

forbiddenNodes: nodeSet
    forbiddenNodes := nodeSet.
! !

