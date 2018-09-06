"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCRewritingVisitor subclass:#PPCTokenDetector
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!

!PPCTokenDetector methodsFor:'as yet unclassified'!

visitActionNode: node	

    (node hasProperty: #trimmingToken) ifTrue: [ 
        | child whitespace |
        self change.
        child := self visitWithTokenVisitor: node child secondChild.
        whitespace := self visitWithTokenVisitor: node child firstChild.
        
        ^ PPCTrimmingTokenNode new
            name: node name;
            child: child;
            whitespace: whitespace;
            tokenClass: node child secondChild tokenClass;
            properties: node properties copy;
            yourself.
    ].

    ^ super visitActionNode: node
!

visitTokenNode: node	
    | child newChild |
    self change.
    child := node child.
    newChild := self visitWithTokenVisitor: node child.
    node replace: child with: newChild.
    
    ^ node
!

visitTrimNode: node
    self visitChildren: node.

    (node child isKindOf: PPCTokenNode) ifTrue: [  
        self change.
        ^ PPCTrimmingTokenNode new
            name: node name;
            child: node child child;
            tokenClass: node child tokenClass;
            whitespace: node trimmer;
            parser: node parser;
            yourself
    ]. 

    ^ node
!

visitWithTokenVisitor: node
    | retval forbiddenNodes copyVisitor tokenVisitor |
    
    copyVisitor := PPCCopyVisitor new.
    tokenVisitor := PPCTokenVisitor new.
    
    forbiddenNodes := openSet copy.
    tokenVisitor forbiddenNodes: forbiddenNodes.

    retval := copyVisitor visit: node.
    retval := tokenVisitor visit: retval.
    ^ retval
! !

