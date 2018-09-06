"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstParenthesizedExpr
	instanceVariableNames:'expr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstParenthesizedExpr methodsFor:'accessing'!

expr
    ^ expr

    "Created: / 08-07-2006 / 18:39:02 / ked"
!

expr:something
    expr := something.

    "Created: / 08-07-2006 / 18:39:02 / ked"
! !

!AstParenthesizedExpr methodsFor:'testing'!

isAstParenthesizedExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
!

isUpdatingExpression
    self children do:
        [:childNode|childNode isUpdatingExpression ifTrue:[^true]].
    ^ false.

    "Created: / 21-11-2007 / 15:00:25 / janfrog"
! !

!AstParenthesizedExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstParenthesizedExpr:self

    "Created: / 08-07-2006 / 18:40:13 / ked"
! !

!AstParenthesizedExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
