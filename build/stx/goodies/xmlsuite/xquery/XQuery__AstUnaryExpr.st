"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstUnaryExpr
	instanceVariableNames:'operand unaryExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstUnaryExpr methodsFor:'accessing'!

operand
    ^ operand

    "Created: / 08-07-2006 / 17:39:00 / ked"
!

operand:something
    operand := something.

    "Created: / 08-07-2006 / 17:39:00 / ked"
!

unaryExpr
    ^ unaryExpr

    "Created: / 02-04-2006 / 15:20:41 / ked"
!

unaryExpr:something
    unaryExpr := something.

    "Created: / 02-04-2006 / 15:20:41 / ked"
! !

!AstUnaryExpr methodsFor:'testing'!

isAstUnaryExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstUnaryExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstUnaryExpr:self

    "Created: / 06-07-2006 / 19:12:14 / ked"
! !

!AstUnaryExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
