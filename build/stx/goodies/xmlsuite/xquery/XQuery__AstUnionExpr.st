"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstUnionExpr
	instanceVariableNames:'intersectExceptExpr unionExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstUnionExpr methodsFor:'accessing'!

intersectExceptExpr
    ^ intersectExceptExpr

    "Created: / 17-03-2006 / 17:12:40 / ked"
!

intersectExceptExpr:something
    intersectExceptExpr := something.

    "Created: / 17-03-2006 / 17:12:40 / ked"
!

unionExpr
    ^ unionExpr

    "Created: / 17-03-2006 / 17:12:40 / ked"
!

unionExpr:something
    unionExpr := something.

    "Created: / 17-03-2006 / 17:12:40 / ked"
! !

!AstUnionExpr methodsFor:'testing'!

isAstUnionExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstUnionExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstUnionExpr:self

    "Created: / 06-07-2006 / 19:12:14 / ked"
! !

!AstUnionExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
