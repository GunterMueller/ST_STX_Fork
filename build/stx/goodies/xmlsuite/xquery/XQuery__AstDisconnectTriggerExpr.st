"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDisconnectTriggerExpr
	instanceVariableNames:'targetExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDisconnectTriggerExpr methodsFor:'accessing'!

targetExpr
    ^ targetExpr

    "Created: / 10-04-2012 / 19:28:08 / Adam Senk <senkadam@gmail.com>"
!

targetExpr:something
    targetExpr := something.

    "Created: / 10-04-2012 / 19:27:51 / Adam Senk <senkadam@gmail.com>"
! !

!AstDisconnectTriggerExpr methodsFor:'testing'!

isAstDisconnectTriggerExpr
    ^ true
! !

!AstDisconnectTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDisconnectTriggerExpr:self
! !

!AstDisconnectTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
