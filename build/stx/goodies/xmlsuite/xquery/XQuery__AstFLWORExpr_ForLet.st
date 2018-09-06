"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstFLWORExpr_ForLet
	instanceVariableNames:'forClause letClause flworExpr_ForLet'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstFLWORExpr_ForLet methodsFor:'accessing'!

flworExpr_ForLet
    ^ flworExpr_ForLet

    "Created: / 10-03-2006 / 19:40:04 / ked"
!

flworExpr_ForLet:something
    flworExpr_ForLet := something.

    "Created: / 10-03-2006 / 19:40:04 / ked"
!

forClause
    ^ forClause

    "Created: / 10-03-2006 / 19:40:03 / ked"
!

forClause:something
    forClause := something.

    "Created: / 10-03-2006 / 19:40:03 / ked"
!

letClause
    ^ letClause

    "Created: / 10-03-2006 / 19:40:03 / ked"
!

letClause:something
    letClause := something.

    "Created: / 10-03-2006 / 19:40:04 / ked"
! !

!AstFLWORExpr_ForLet methodsFor:'private'!

forClausesOn: aStream

    forClause ifNotNil:[forClause forClausesOn: aStream]

    "Created: / 28-03-2007 / 19:48:42 / janfrog"
!

forLetClausesOn:aStream 

    aStream nextPut: self.

    flworExpr_ForLet ifNotNil:[ flworExpr_ForLet forLetClausesOn:aStream ]

    "Created: / 28-03-2007 / 16:43:51 / janfrog"
    "Modified: / 28-03-2007 / 17:59:59 / janfrog"
!

letClausesOn: aStream

    letClause ifNotNil:[letClause letClausesOn: aStream]

    "Created: / 28-03-2007 / 19:48:31 / janfrog"
! !

!AstFLWORExpr_ForLet methodsFor:'testing'!

isAstFLWORExpr_ForLet
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstFLWORExpr_ForLet methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstFLWORExpr_ForLet:self

    "Created: / 06-07-2006 / 19:12:10 / ked"
! !

!AstFLWORExpr_ForLet class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
