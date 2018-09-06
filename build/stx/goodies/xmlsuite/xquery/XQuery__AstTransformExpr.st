"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstTransformExpr
	instanceVariableNames:'transformCopyClause modifyExpr returnExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstTransformExpr methodsFor:'accessing'!

modifyExpr
    ^ modifyExpr

    "Created: / 21-11-2007 / 16:47:44 / janfrog"
!

modifyExpr:something

    something ensureIsUpdatingExpression.
    modifyExpr := something.

    "Created: / 21-11-2007 / 16:47:44 / janfrog"
!

returnExpr
    ^ returnExpr

    "Created: / 21-11-2007 / 16:47:44 / janfrog"
!

returnExpr:something

    something ensureIsNotUpdatingExpression.

    returnExpr := something.

    "Created: / 21-11-2007 / 16:47:44 / janfrog"
!

transformCopyClause
    ^ transformCopyClause

    "Created: / 21-11-2007 / 16:47:44 / janfrog"
!

transformCopyClause:something
    transformCopyClause := something.

    "Created: / 21-11-2007 / 16:47:44 / janfrog"
! !

!AstTransformExpr methodsFor:'testing'!

isAstTransformExpr

    ^true

    "Created: / 05-12-2007 / 10:20:13 / janfrog"
!

isUpdatingExpression

^ false

    "Created: / 21-11-2007 / 16:04:29 / janfrog"
! !

!AstTransformExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstTransformExpr:self

    "Modified: / 05-12-2007 / 11:20:03 / janfrog"
! !

!AstTransformExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
