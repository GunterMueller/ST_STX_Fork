"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstMultiplicativeExpr
	instanceVariableNames:'unionExpr operand multiplicativeExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstMultiplicativeExpr methodsFor:'accessing'!

multiplicativeExpr
    ^ multiplicativeExpr

    "Created: / 17-03-2006 / 17:03:47 / ked"
!

multiplicativeExpr:something
    multiplicativeExpr := something.

    "Created: / 17-03-2006 / 17:03:47 / ked"
!

operand
    ^ operand

    "Created: / 17-03-2006 / 17:03:47 / ked"
!

operand:something
    operand := something.

    "Created: / 17-03-2006 / 17:03:47 / ked"
!

unionExpr
    ^ unionExpr

    "Created: / 17-03-2006 / 17:03:47 / ked"
!

unionExpr:something
    unionExpr := something.

    "Created: / 17-03-2006 / 17:03:47 / ked"
! !

!AstMultiplicativeExpr methodsFor:'testing'!

isAstMultiplicativeExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstMultiplicativeExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstMultiplicativeExpr:self

    "Created: / 06-07-2006 / 19:12:11 / ked"
! !

!AstMultiplicativeExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
