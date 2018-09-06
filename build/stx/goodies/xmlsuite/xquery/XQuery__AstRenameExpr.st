"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstRenameExpr
	instanceVariableNames:'targetExpr newNameExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstRenameExpr methodsFor:'accessing'!

newNameExpr
    ^ newNameExpr
!

newNameExpr:something
    newNameExpr := something.
!

targetExpr
    ^ targetExpr
!

targetExpr:something
    targetExpr := something.
! !

!AstRenameExpr methodsFor:'testing'!

isAstRenameExpr

^true
!

isUpdatingExpression

^true

    "Created: / 21-11-2007 / 14:20:38 / janfrog"
! !

!AstRenameExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstRenameExpr:self
! !

!AstRenameExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
