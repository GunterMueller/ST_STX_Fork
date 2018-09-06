"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstExpr
	instanceVariableNames:'exprSingle expr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstExpr methodsFor:'accessing'!

expr
    ^ expr

    "Created: / 10-03-2006 / 19:05:00 / ked"
!

expr:something
    expr := something.

    "Created: / 10-03-2006 / 19:05:00 / ked"
!

exprSingle
    ^ exprSingle

    "Created: / 10-03-2006 / 19:05:00 / ked"
!

exprSingle:something
    exprSingle := something.

    "Created: / 10-03-2006 / 19:05:00 / ked"
! !

!AstExpr methodsFor:'testing'!

isAstExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
!

isUpdatingExpression
    self children do:
        [:childNode|childNode isUpdatingExpression ifTrue:[^true]].
    ^ false.

    "Modified: / 21-11-2007 / 14:55:11 / janfrog"
! !

!AstExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstExpr:self

    "Created: / 06-07-2006 / 19:12:10 / ked"
! !

!AstExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
