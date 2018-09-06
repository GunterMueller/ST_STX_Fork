"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDeleteExpr
	instanceVariableNames:'targetExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDeleteExpr methodsFor:'accessing'!

targetExpr
    ^ targetExpr
!

targetExpr:something
    targetExpr := something.
! !

!AstDeleteExpr methodsFor:'testing'!

isAstDeleteExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
!

isUpdatingExpression

^true

    "Created: / 21-11-2007 / 14:19:09 / janfrog"
! !

!AstDeleteExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDeleteExpr:self

    "Created: / 06-07-2006 / 19:12:08 / ked"
! !

!AstDeleteExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
