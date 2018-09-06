"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDropTriggerExpr
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDropTriggerExpr methodsFor:'accessing'!

name
    ^ name
!

name:something
    name := something.
! !

!AstDropTriggerExpr methodsFor:'testing'!

isAstDropTriggerExpr
    ^ true
! !

!AstDropTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDropTriggerExpr:self
! !

!AstDropTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
