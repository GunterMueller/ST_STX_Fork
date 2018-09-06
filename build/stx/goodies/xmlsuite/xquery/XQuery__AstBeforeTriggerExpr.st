"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstBeforeTriggerExpr
	instanceVariableNames:'eventTriggerExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstBeforeTriggerExpr methodsFor:'accessing'!

eventTriggerExpr
    ^ eventTriggerExpr
!

eventTriggerExpr:something
    eventTriggerExpr := something.
! !

!AstBeforeTriggerExpr methodsFor:'testing'!

isAstBeforeTriggerExpr
    ^ true
! !

!AstBeforeTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstBeforeTriggerExpr:self
! !

!AstBeforeTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
