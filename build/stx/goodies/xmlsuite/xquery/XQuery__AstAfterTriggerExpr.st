"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstAfterTriggerExpr
	instanceVariableNames:'eventTriggerExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstAfterTriggerExpr methodsFor:'accessing'!

eventTriggerExpr
    ^ eventTriggerExpr
!

eventTriggerExpr:something
    eventTriggerExpr := something.
! !

!AstAfterTriggerExpr methodsFor:'testing'!

isAstAfterTriggerExpr
    ^ true
! !

!AstAfterTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstAfterTriggerExpr:self
! !

!AstAfterTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
