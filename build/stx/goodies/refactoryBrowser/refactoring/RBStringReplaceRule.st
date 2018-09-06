"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

RBReplaceRule subclass:#RBStringReplaceRule
	instanceVariableNames:'replaceTree actionOnReplacedNode'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!

!RBStringReplaceRule class methodsFor:'documentation'!

documentation
"
    cg: added actionOnReplacedNode,
    an optional action which gets the replaced node.
    see copyXXX lint rule for an example
"    
! !

!RBStringReplaceRule class methodsFor:'instance creation'!

searchFor: searchString replaceWith: replaceString 
	^self new searchFor: searchString replaceWith: replaceString
!

searchFor: searchString replaceWith: replaceString keepComments:keepComments
        ^self new searchFor: searchString replaceWith: replaceString keepComments:keepComments
!

searchFor: searchString replaceWith: replaceString thenDo:actionOnReplacedNode
        ^self new searchFor: searchString replaceWith: replaceString thenDo:actionOnReplacedNode
!

searchFor: searchString replaceWith: replaceString when: aBlock 
	^self new 
		searchFor: searchString
		replaceWith: replaceString
		when: aBlock
!

searchForMethod: searchString replaceWith: replaceString
	^self new searchForMethod: searchString replaceWith: replaceString
!

searchForMethod: searchString replaceWith: replaceString when: aBlock 
	^self new 
		searchForMethod: searchString
		replaceWith: replaceString
		when: aBlock
!

searchForTree: searchString replaceWith: replaceString 
	^self new searchForTree: searchString replaceWith: replaceString
!

searchForTree: searchString replaceWith: replaceString when: aBlock 
	^self new 
		searchForTree: searchString
		replaceWith: replaceString
		when: aBlock
! !

!RBStringReplaceRule methodsFor:'accessing'!

replaceString
    "reconstruct the replacement string from the replacement node-tree"

    ^ replaceTree formattedCode
! !

!RBStringReplaceRule methodsFor:'initialize-release'!

actionOnReplacedNode:something
    actionOnReplacedNode := something.
!

methodReplaceString: replaceString 
        replaceTree := RBParser parseRewriteMethod: replaceString
!

replaceString: replaceString 
        replaceTree := RBParser parseRewriteExpression: replaceString.
        searchTree isSequence = replaceTree isSequence 
                ifFalse: 
                        [searchTree isSequence 
                                ifTrue: [replaceTree := RBSequenceNode statements: (Array with: replaceTree)]
                                ifFalse: [searchTree := RBSequenceNode statements: (Array with: searchTree)]]
!

replaceString: replaceString keepComments:keepComments
        replaceTree := RBParser parseRewriteExpression: replaceString keepComments:keepComments.
        searchTree isSequence = replaceTree isSequence 
                ifFalse: 
                        [searchTree isSequence 
                                ifTrue: [replaceTree := RBSequenceNode statements: (Array with: replaceTree)]
                                ifFalse: [searchTree := RBSequenceNode statements: (Array with: searchTree)]]
!

searchFor: searchString replaceWith: replaceString 
	self searchString: searchString.
	self replaceString: replaceString
!

searchFor: searchString replaceWith: replaceString keepComments:keepComments
        self searchString: searchString.
        self replaceString: replaceString keepComments:keepComments
!

searchFor: searchString replaceWith: replaceString thenDo:actionOnReplacedNode
        self searchString: searchString.
        self replaceString: replaceString.
        self actionOnReplacedNode:actionOnReplacedNode. 
!

searchFor: searchString replaceWith: replaceString when: aBlock 
	self searchFor: searchString replaceWith: replaceString.
	verificationBlock := aBlock
!

searchForMethod: searchString replaceWith: replaceString 
	self methodSearchString: searchString.
	self methodReplaceString: replaceString
!

searchForMethod: searchString replaceWith: replaceString when: aBlock 
	self searchForMethod: searchString replaceWith: replaceString.
	verificationBlock := aBlock
!

searchForTree: aBRProgramNode replaceWith: replaceNode 
	searchTree := aBRProgramNode.
	replaceTree := replaceNode
!

searchForTree: aBRProgramNode replaceWith: replaceString when: aBlock 
	self searchForTree: aBRProgramNode replaceWith: replaceString.
	verificationBlock := aBlock
! !

!RBStringReplaceRule methodsFor:'matching'!

foundMatchFor: aProgramNode
    | newTree |

    newTree := replaceTree copyInContext: self context.
    newTree copyCommentsFrom: aProgramNode.

    actionOnReplacedNode notNil ifTrue:[
        newTree := actionOnReplacedNode value:newTree.
    ].    
    (owner notNil and:[owner isRewritingOriginalSource]) ifTrue:[
        owner addReplacement:((RBReplaceStringInOriginalSource new)
                                    oldNode: aProgramNode;
                                    newNode: newTree).
    ].

    ^newTree

    "Modified (format): / 26-03-2012 / 14:12:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBStringReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

