"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstTransformCopyClause
	instanceVariableNames:'varName exprSingle transformCopyClause'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstTransformCopyClause methodsFor:'accessing'!

exprSingle
    ^ exprSingle

    "Created: / 21-11-2007 / 16:47:39 / janfrog"
!

exprSingle:something

    something ensureIsNotUpdatingExpression.

    exprSingle := something.

    "Created: / 21-11-2007 / 16:47:39 / janfrog"
!

transformCopyClause
    ^ transformCopyClause

    "Created: / 21-11-2007 / 16:47:39 / janfrog"
!

transformCopyClause:something
    transformCopyClause := something.

    "Created: / 21-11-2007 / 16:47:39 / janfrog"
!

varName
    ^ varName

    "Created: / 21-11-2007 / 16:47:39 / janfrog"
!

varName:something
    varName := something.

    "Created: / 21-11-2007 / 16:47:39 / janfrog"
! !

!AstTransformCopyClause methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstTransformCopyClause:self

    "Modified: / 05-12-2007 / 11:20:27 / janfrog"
! !

!AstTransformCopyClause class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
