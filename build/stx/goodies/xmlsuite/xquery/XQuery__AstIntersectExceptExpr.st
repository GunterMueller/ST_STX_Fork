"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstIntersectExceptExpr
	instanceVariableNames:'unaryExpr intersectExceptExpr operand'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstIntersectExceptExpr methodsFor:'accessing'!

intersectExceptExpr
    ^ intersectExceptExpr

    "Created: / 17-03-2006 / 18:48:17 / ked"
!

intersectExceptExpr:something
    intersectExceptExpr := something.

    "Created: / 17-03-2006 / 18:48:17 / ked"
!

operand
    ^ operand

    "Created: / 01-12-2006 / 16:44:58 / ked"
!

operand:something
    operand := something.

    "Created: / 01-12-2006 / 16:44:58 / ked"
!

unaryExpr
    ^ unaryExpr

    "Created: / 17-03-2006 / 18:48:17 / ked"
!

unaryExpr:something
    unaryExpr := something.

    "Created: / 17-03-2006 / 18:48:17 / ked"
! !

!AstIntersectExceptExpr methodsFor:'testing'!

isAstIntersectExceptExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstIntersectExceptExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstIntersectExceptExpr:self

    "Created: / 06-07-2006 / 19:12:11 / ked"
! !

!AstIntersectExceptExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
