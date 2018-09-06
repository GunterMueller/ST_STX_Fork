"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

RBParseTreeRule subclass:#RBReplaceRule
	instanceVariableNames:'verificationBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!


!RBReplaceRule methodsFor:'accessing'!

verificationBlock
    ^ verificationBlock
!

verificationBlock:something
    verificationBlock := something.
! !

!RBReplaceRule methodsFor:'copying'!

copyMatchDo:aBlock
    "Creates of copy of receiver, that evaluates given block on
     every match, passing matching node as an argument"

    ^ RBSearchRule new
            searchForTree: searchTree 
            thenDo: [:node :answer :owner :context|
                "/ cg: changed to allow an additional argument (the owner) which provides the
                "/ context. So match blocks can get to the currentClass/selector etc.
                (verificationBlock valueWithOptionalArgument: node and:owner and:context) ifTrue:[
                    aBlock valueWithOptionalArgument: node and:owner.
                ].
                true
            ]

    "Modified: / 02-02-2012 / 22:57:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBReplaceRule methodsFor:'initialize-release'!

initialize
	super initialize.
	verificationBlock := [:aNode | true]
! !

!RBReplaceRule methodsFor:'matching'!

canMatch: aProgramNode 
        ^verificationBlock valueWithOptionalArgument: aProgramNode and:owner
!

foundMatchFor: aProgramNode 
	self subclassResponsibility
! !

!RBReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RBReplaceRule.st,v 1.10 2015-02-20 12:13:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RBReplaceRule.st,v 1.10 2015-02-20 12:13:33 cg Exp $'
! !

