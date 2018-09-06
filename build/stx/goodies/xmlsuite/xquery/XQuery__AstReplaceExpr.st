"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstReplaceExpr
	instanceVariableNames:'targetExpr sourceExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstReplaceExpr methodsFor:'accessing'!

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

!AstReplaceExpr methodsFor:'testing'!

isAstReplaceExpr

^true
!

isUpdatingExpression

^true

    "Created: / 21-11-2007 / 14:20:26 / janfrog"
! !

!AstReplaceExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstReplaceExpr:self
! !

!AstReplaceExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
