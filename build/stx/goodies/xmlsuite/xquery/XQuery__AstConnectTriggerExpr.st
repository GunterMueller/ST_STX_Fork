"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstConnectTriggerExpr
	instanceVariableNames:'triggerDefExpr targetExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstConnectTriggerExpr methodsFor:'accessing'!

targetExpr

    ^targetExpr

    "Created: / 24-03-2012 / 23:23:53 / Adam Senk <senkadam@gmail.com>"
!

targetExpr: something

    targetExpr:= something.

    "Created: / 24-03-2012 / 23:23:32 / Adam Senk <senkadam@gmail.com>"
!

triggerDefExpr

    ^triggerDefExpr

    "Created: / 24-03-2012 / 23:22:26 / Adam Senk <senkadam@gmail.com>"
!

triggerDefExpr: something

    triggerDefExpr:= something.

    "Created: / 24-03-2012 / 23:23:05 / Adam Senk <senkadam@gmail.com>"
! !

!AstConnectTriggerExpr methodsFor:'testing'!

isAstConnectTriggerExpr
    ^true.

    "Created: / 24-03-2012 / 23:56:57 / Adam Senk <senkadam@gmail.com>"
!

isUpdatingExpression

^true

    "Created: / 25-03-2012 / 14:52:45 / Adam Senk <senkadam@gmail.com>"
! !

!AstConnectTriggerExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstConnectTriggerExpr:self

    "Created: / 25-03-2012 / 12:23:42 / Adam Senk <senkadam@gmail.com>"
! !

!AstConnectTriggerExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
