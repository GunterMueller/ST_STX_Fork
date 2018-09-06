"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstWhereClause
	instanceVariableNames:'exprSingle'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstWhereClause methodsFor:'accessing'!

exprSingle
    ^ exprSingle

    "Created: / 10-03-2006 / 20:06:25 / ked"
!

exprSingle:something

    something ensureIsNotUpdatingExpression.

    exprSingle := something.

    "Created: / 10-03-2006 / 20:06:25 / ked"
    "Modified: / 21-11-2007 / 15:53:22 / janfrog"
! !

!AstWhereClause methodsFor:'testing'!

isAstWhereClause
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstWhereClause methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstWhereClause:self

    "Created: / 06-07-2006 / 19:12:14 / ked"
! !

!AstWhereClause class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
