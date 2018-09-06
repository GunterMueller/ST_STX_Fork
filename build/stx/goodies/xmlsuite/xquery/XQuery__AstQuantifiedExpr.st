"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstQuantifiedExpr
	instanceVariableNames:'someEvery quantifiedExpr_Impl exprSingle'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstQuantifiedExpr methodsFor:'accessing'!

exprSingle
    ^ exprSingle

    "Created: / 17-03-2006 / 16:14:04 / ked"
!

exprSingle:something
    exprSingle := something.

    "Created: / 17-03-2006 / 16:14:04 / ked"
!

quantifiedExpr_Impl
    ^ quantifiedExpr_Impl

    "Created: / 17-03-2006 / 16:14:04 / ked"
!

quantifiedExpr_Impl:something
    quantifiedExpr_Impl := something.

    "Created: / 17-03-2006 / 16:14:04 / ked"
!

someEvery
    ^ someEvery

    "Created: / 17-03-2006 / 16:14:04 / ked"
!

someEvery:something
    someEvery := something.

    "Created: / 17-03-2006 / 16:14:04 / ked"
! !

!AstQuantifiedExpr methodsFor:'testing'!

isAstQuantifiedExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstQuantifiedExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstQuantifiedExpr:self

    "Created: / 06-07-2006 / 19:12:13 / ked"
! !

!AstQuantifiedExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
