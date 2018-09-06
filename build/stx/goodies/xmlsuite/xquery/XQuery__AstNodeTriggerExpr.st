"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstNodeTriggerExpr
	instanceVariableNames:'triggerNameAndTargetExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstNodeTriggerExpr methodsFor:'accessing'!

triggerNameAndTargetExpr
    ^ triggerNameAndTargetExpr
!

triggerNameAndTargetExpr:something
    triggerNameAndTargetExpr := something.
! !

!AstNodeTriggerExpr methodsFor:'testing'!

isAstNodeTriggerExpr
    ^ true
! !

!AstNodeTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstNodeTriggerExpr:self
! !

!AstNodeTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
