"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstAdditiveExpr
	instanceVariableNames:'multiplicativeExpr operand additiveExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstAdditiveExpr methodsFor:'accessing'!

additiveExpr
    ^ additiveExpr

    "Created: / 02-04-2006 / 14:18:09 / ked"
!

additiveExpr:something
    additiveExpr := something.

    "Created: / 02-04-2006 / 14:18:09 / ked"
!

multiplicativeExpr
    ^ multiplicativeExpr

    "Created: / 02-04-2006 / 14:18:09 / ked"
!

multiplicativeExpr:something
    multiplicativeExpr := something.

    "Created: / 02-04-2006 / 14:18:09 / ked"
!

operand
    ^ operand

    "Created: / 08-07-2006 / 17:38:24 / ked"
!

operand:something
    operand := something.

    "Created: / 08-07-2006 / 17:38:24 / ked"
! !

!AstAdditiveExpr methodsFor:'testing'!

isAstAdditiveExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstAdditiveExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstAdditiveExpr:self

    "Created: / 06-07-2006 / 19:12:08 / ked"
! !

!AstAdditiveExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
