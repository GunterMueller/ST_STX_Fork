"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstFLWORExpr
	instanceVariableNames:'flworExpr_ForLet whereClause orderByClause exprSingle'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstFLWORExpr methodsFor:'accessing'!

exprSingle
    ^ exprSingle

    "Created: / 10-03-2006 / 19:27:04 / ked"
!

exprSingle:something
    exprSingle := something.

    "Created: / 10-03-2006 / 19:27:04 / ked"
!

flworExpr_ForLet
    ^ flworExpr_ForLet

    "Created: / 10-03-2006 / 19:27:04 / ked"
!

flworExpr_ForLet:something
    flworExpr_ForLet := something.

    "Created: / 10-03-2006 / 19:27:04 / ked"
!

orderByClause
    ^ orderByClause

    "Created: / 10-03-2006 / 19:27:04 / ked"
!

orderByClause:something
    orderByClause := something.

    "Created: / 10-03-2006 / 19:27:04 / ked"
!

whereClause
    ^ whereClause ifNil:[whereClause := AstBooleanLiteral trueLiteral]

    "Created: / 10-03-2006 / 19:27:04 / ked"
    "Modified: / 28-03-2007 / 20:28:46 / janfrog"
!

whereClause:something
    whereClause := something.

    "Created: / 10-03-2006 / 19:27:04 / ked"
! !

!AstFLWORExpr methodsFor:'testing'!

isAstFLWORExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstFLWORExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstFLWORExpr:self

    "Created: / 06-07-2006 / 19:12:10 / ked"
! !

!AstFLWORExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
