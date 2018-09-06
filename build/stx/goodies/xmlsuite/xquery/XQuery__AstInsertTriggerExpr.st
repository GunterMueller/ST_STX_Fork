"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstInsertTriggerExpr
	instanceVariableNames:'triggerBodyExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstInsertTriggerExpr methodsFor:'accessing'!

triggerBodyExpr
    ^ triggerBodyExpr
!

triggerBodyExpr:something
    triggerBodyExpr := something.
! !

!AstInsertTriggerExpr methodsFor:'testing'!

isAstInsertTriggerExpr
    ^ true
! !

!AstInsertTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstInsertTriggerExpr:self
! !

!AstInsertTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
