"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstReplaceTriggerExpr
	instanceVariableNames:'triggerBodyExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstReplaceTriggerExpr methodsFor:'accessing'!

triggerBodyExpr
    ^ triggerBodyExpr
!

triggerBodyExpr:something
    triggerBodyExpr := something.
! !

!AstReplaceTriggerExpr methodsFor:'testing'!

isAstReplaceTriggerExpr
    ^ true
! !

!AstReplaceTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstReplaceTriggerExpr:self
! !

!AstReplaceTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
