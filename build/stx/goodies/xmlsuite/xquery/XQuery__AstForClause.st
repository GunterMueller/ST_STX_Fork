"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstForClause
	instanceVariableNames:'varName positionalVar exprSingle forClause'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstForClause methodsFor:'accessing'!

exprSingle
    ^ exprSingle

    "Created: / 02-04-2006 / 22:01:49 / ked"
!

exprSingle:something

   something ensureIsNotUpdatingExpression. 

    exprSingle := something.

    "Created: / 02-04-2006 / 22:01:50 / ked"
    "Modified: / 05-12-2007 / 10:10:52 / janfrog"
!

forClause
    ^ forClause

    "Created: / 02-04-2006 / 22:01:50 / ked"
!

forClause:something
    forClause := something.

    "Created: / 02-04-2006 / 22:01:50 / ked"
!

positionalVar
    ^ positionalVar

    "Created: / 02-04-2006 / 22:01:49 / ked"
!

positionalVar:something
    positionalVar := something.

    "Created: / 02-04-2006 / 22:01:49 / ked"
!

varName
    ^ varName

    "Created: / 02-04-2006 / 22:01:49 / ked"
!

varName:something
    varName := something.

    "Created: / 02-04-2006 / 22:01:49 / ked"
! !

!AstForClause methodsFor:'private'!

forClausesOn: aStream

    aStream nextPut: self.
    forClause ifNotNil:[forClause forClausesOn: aStream]

    "Created: / 28-03-2007 / 19:34:37 / janfrog"
!

forLetClausesOn: aStream

    aStream nextPut:
        (AstFLWORExpr_ForLet new
            forClause: self)

    "Created: / 28-03-2007 / 18:16:46 / janfrog"
! !

!AstForClause methodsFor:'testing'!

isAstForClause
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstForClause methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstForClause:self

    "Created: / 06-07-2006 / 19:12:10 / ked"
! !

!AstForClause class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
