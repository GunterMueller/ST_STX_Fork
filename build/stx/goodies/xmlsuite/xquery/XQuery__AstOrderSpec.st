"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstOrderSpec
	instanceVariableNames:'exprSingle orderModifier'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstOrderSpec methodsFor:'accessing'!

exprSingle
    ^ exprSingle

    "Created: / 10-03-2006 / 21:58:46 / ked"
!

exprSingle:something

    something ensureIsNotUpdatingExpression.
    exprSingle := something.

    "Created: / 10-03-2006 / 21:58:46 / ked"
    "Modified: / 21-11-2007 / 15:55:28 / janfrog"
!

orderModifier
    ^ orderModifier

    "Created: / 10-03-2006 / 21:58:46 / ked"
!

orderModifier:something
    orderModifier := something.

    "Created: / 10-03-2006 / 21:58:47 / ked"
! !

!AstOrderSpec methodsFor:'testing'!

isAstOrderSpec
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstOrderSpec methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstOrderSpec:self

    "Created: / 06-07-2006 / 19:12:12 / ked"
! !

!AstOrderSpec class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
