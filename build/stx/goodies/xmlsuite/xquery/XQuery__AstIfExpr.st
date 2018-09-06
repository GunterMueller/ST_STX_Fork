"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstIfExpr
	instanceVariableNames:'expr trueExprSingle falseExprSingle'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstIfExpr methodsFor:'accessing'!

expr
    ^ expr

    "Created: / 17-03-2006 / 16:23:00 / ked"
!

expr:something
    expr := something.

    "Created: / 17-03-2006 / 16:23:00 / ked"
!

falseExprSingle
    ^ falseExprSingle

    "Created: / 17-03-2006 / 16:23:00 / ked"
!

falseExprSingle:something
    falseExprSingle := something.

    "Created: / 17-03-2006 / 16:23:00 / ked"
!

trueExprSingle
    ^ trueExprSingle

    "Created: / 17-03-2006 / 16:23:00 / ked"
!

trueExprSingle:something
    trueExprSingle := something.

    "Created: / 17-03-2006 / 16:23:00 / ked"
! !

!AstIfExpr methodsFor:'testing'!

isAstIfExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:48 / ked"
!

isUpdatingExpression
    self children do:
        [:childNode|childNode isUpdatingExpression ifTrue:[^true]].
    ^ false.

    "Created: / 21-11-2007 / 15:02:04 / janfrog"
! !

!AstIfExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstIfExpr:self

    "Created: / 06-07-2006 / 19:12:11 / ked"
! !

!AstIfExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
