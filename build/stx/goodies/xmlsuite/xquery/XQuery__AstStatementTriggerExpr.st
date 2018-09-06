"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstStatementTriggerExpr
	instanceVariableNames:'triggerNameAndTargetExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstStatementTriggerExpr methodsFor:'accessing'!

triggerNameAndTargetExpr
    ^ triggerNameAndTargetExpr
!

triggerNameAndTargetExpr:something
    triggerNameAndTargetExpr := something.
! !

!AstStatementTriggerExpr methodsFor:'testing'!

isAstStatementTriggerExpr
    ^ true
! !

!AstStatementTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstStatementTriggerExpr:self
! !

!AstStatementTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
