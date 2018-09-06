"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstReplaceValueOfExpr
	instanceVariableNames:'targetExpr sourceExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstReplaceValueOfExpr methodsFor:'accessing'!

sourceExpr
    ^ sourceExpr
!

sourceExpr:something
    sourceExpr := something.
!

targetExpr
    ^ targetExpr
!

targetExpr:something
    targetExpr := something.
! !

!AstReplaceValueOfExpr methodsFor:'testing'!

isAstReplaceValueOfExpr

^ true
!

isUpdatingExpression

^true

    "Created: / 13-02-2012 / 20:54:07 / Adam Senk <senkadam@gmail.com>"
! !

!AstReplaceValueOfExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstReplaceValueOfExpr:self
! !

!AstReplaceValueOfExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
