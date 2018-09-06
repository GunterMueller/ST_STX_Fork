"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstLetClause
	instanceVariableNames:'varName exprSingle letClause'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstLetClause methodsFor:'accessing'!

exprSingle
    ^ exprSingle

    "Created: / 10-03-2006 / 19:57:14 / ked"
!

exprSingle:something

    something ensureIsNotUpdatingExpression.
    
    exprSingle := something.

    "Created: / 10-03-2006 / 19:57:14 / ked"
    "Modified: / 21-11-2007 / 15:49:28 / janfrog"
!

letClause
    ^ letClause

    "Created: / 10-03-2006 / 19:57:14 / ked"
!

letClause:something
    letClause := something.

    "Created: / 10-03-2006 / 19:57:14 / ked"
!

varName
    ^ varName

    "Created: / 10-03-2006 / 19:57:14 / ked"
!

varName:something
    varName := something.

    "Created: / 10-03-2006 / 19:57:14 / ked"
! !

!AstLetClause methodsFor:'private'!

forLetClausesOn: aStream

    aStream nextPut:
        (AstFLWORExpr_ForLet new
            letClause: self)

    "Created: / 28-03-2007 / 18:17:05 / janfrog"
!

letClausesOn: aStream

    aStream nextPut: self.
    letClause ifNotNil:[letClause letClausesOn: aStream]

    "Created: / 28-03-2007 / 19:35:00 / janfrog"
! !

!AstLetClause methodsFor:'testing'!

isAstLetClause
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstLetClause methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstLetClause:self

    "Created: / 06-07-2006 / 19:12:11 / ked"
! !

!AstLetClause class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
