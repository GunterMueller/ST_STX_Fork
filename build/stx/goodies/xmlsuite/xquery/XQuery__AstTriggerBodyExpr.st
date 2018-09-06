"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstTriggerBodyExpr
	instanceVariableNames:'triggerBodyString'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstTriggerBodyExpr methodsFor:'accessing'!

triggerBodyString
    ^ triggerBodyString
!

triggerBodyString:something
    triggerBodyString := something.
! !

!AstTriggerBodyExpr methodsFor:'testing'!

isAstTriggerBodyExpr
    ^ true
! !

!AstTriggerBodyExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstTriggerBodyExpr:self
! !

!AstTriggerBodyExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
