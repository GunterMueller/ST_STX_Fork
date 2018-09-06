"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDeleteTriggerExpr
	instanceVariableNames:'triggerBodyExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDeleteTriggerExpr methodsFor:'accessing'!

triggerBodyExpr
    ^ triggerBodyExpr
!

triggerBodyExpr:something
    triggerBodyExpr := something.
! !

!AstDeleteTriggerExpr methodsFor:'testing'!

isAstDeleteTriggerExpr
    ^ true
! !

!AstDeleteTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDeleteTriggerExpr:self
! !

!AstDeleteTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
