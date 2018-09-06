"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBStatementNode subclass:#RBSTXPrimitiveCCodeNode
	instanceVariableNames:'codeToken'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!


!RBSTXPrimitiveCCodeNode methodsFor:'accessing'!

codeToken
    "return the value of the instance variable 'codeToken' (automatically generated)"

    ^ codeToken
!

codeToken:something
    "set the value of the instance variable 'codeToken' (automatically generated)"

    codeToken := something.
!

formattedCode
    ^ codeToken value  " is already formatted "
!

start
    ^ codeToken start.
!

stop
    ^ codeToken stop.
! !

!RBSTXPrimitiveCCodeNode methodsFor:'comparing'!

= anObject 
        self == anObject ifTrue: [^true].
        self class = anObject class ifFalse: [^false].
        ^ self codeToken value = anObject codeToken value
! !

!RBSTXPrimitiveCCodeNode methodsFor:'testing'!

isSTXPrimitiveCCode
        ^true
! !

!RBSTXPrimitiveCCodeNode methodsFor:'visitor'!

acceptVisitor: aProgramNodeVisitor 
        ^aProgramNodeVisitor acceptSTXPrimitiveCCodeNode: self
! !

!RBSTXPrimitiveCCodeNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBSTXPrimitiveCCodeNode.st,v 1.5 2006-01-31 16:48:03 cg Exp $'
! !
