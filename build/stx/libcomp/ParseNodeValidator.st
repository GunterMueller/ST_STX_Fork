"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

ParseNodeVisitor subclass:#ParseNodeValidator
	instanceVariableNames:'stack source'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!ParseNodeValidator class methodsFor:'documentation'!

documentation
"
    A helper class used to validate parse tree, i.e. parent instvar,
    startPosition/endPositions. Useful only for Parser debugging/hacking.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ParseNodeValidator class methodsFor:'validation'!

validate: aParseNode source: source

    ^self basicNew validate: aParseNode source: source

    "Created: / 27-07-2011 / 13:43:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateClass: cls stopOnError: stopOnError

    | validate |

    validate := [:mth|
        [ 
            | src |
            src := mth source.
            self validate: (Parser parseMethod: src) tree source: src.
        ] on: Error do:[:ex|
            Transcript 
                cr;
                show: mth printString;
                show: '...FAILED!!';
                cr.                        
            stopOnError ifTrue:[
                ex pass
            ].
        ].
    ].
    cls theMetaclass methodsDo: validate.
    cls theNonMetaclass methodsDo: validate.

    "Created: / 01-08-2011 / 12:47:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateImage

    self validateImage: false.

    "Created: / 20-07-2011 / 20:41:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateImage: stopOnError

    | i |
    i := 0.

    Smalltalk allClassesDo:[:cls|
        cls isLoaded ifTrue:[
            i == 50 ifTrue:[
                Transcript cr.
                i := 0.
            ].
            i := i + 1.
            Transcript nextPut:$..
            self validateClass: cls stopOnError: stopOnError
        ].
    ].

    "Created: / 20-07-2011 / 20:42:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNodeValidator methodsFor:'validation'!

validate: tree source: src

    tree isNil ifTrue:[^self].

    source := src.
    stack := Stack with: nil.

    ^self visit: tree

    "Created: / 27-07-2011 / 13:43:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateNode:node 

    self assert: node startPosition isInteger.
    self assert: node endPosition isInteger.
    self assert: node parent == stack top

    "Modified: / 27-07-2011 / 13:47:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNodeValidator methodsFor:'visiting'!

visit:anObject 
    |accept stmt|

    accept := 
            [:node | 
            stack push:node.
            node acceptVisitor:self.
            stack pop.
            self validateNode:node. ].
    ^ anObject isStatementNode 
        ifTrue:
            [ stmt := anObject.
            [ stmt isNil ] whileFalse:
                    [ accept value:stmt.
                    stmt := stmt nextStatement. ] ]
        ifFalse:[ accept value:anObject. ]

    "Created: / 25-07-2011 / 23:14:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitBlockNode:anObject

    self assert: (source at: anObject startPosition) == $[.
    self assert: (source at: anObject endPosition) == $].

    super visitBlockNode: anObject.

    "Modified: / 25-07-2011 / 22:38:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 20-08-2011 / 23:21:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 21-08-2011 / 13:52:50 / cg"
!

visitVariableNode:anObject

    | s e |
    s := anObject startPosition.
    e := anObject endPosition.
    (s ~~ -1 and:[e ~~ -1 and:[                       
        #(MethodVariable InstanceVariable) includes: anObject type]]) ifTrue:[
            self assert: anObject name = 
                (source copyFrom: anObject startPosition to: anObject endPosition).
    ].

    super visitVariableNode: anObject.

    "Created: / 20-08-2011 / 23:21:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 13:51:55 / cg"
    "Modified: / 25-08-2011 / 14:03:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNodeValidator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/ParseNodeValidator.st,v 1.8 2011-08-25 13:38:46 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/ParseNodeValidator.st,v 1.8 2011-08-25 13:38:46 vrany Exp $'
! !

