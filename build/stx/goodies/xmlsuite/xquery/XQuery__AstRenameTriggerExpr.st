"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstRenameTriggerExpr
	instanceVariableNames:'triggerBodyExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstRenameTriggerExpr methodsFor:'accessing'!

triggerBodyExpr
    ^ triggerBodyExpr
!

triggerBodyExpr:something
    triggerBodyExpr := something.
! !

!AstRenameTriggerExpr methodsFor:'testing'!

isAstRenameTriggerExpr
    ^ true
! !

!AstRenameTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstRenameTriggerExpr:self
! !

!AstRenameTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
