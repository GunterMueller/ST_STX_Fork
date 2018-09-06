"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstQuantifiedExpr_Impl
	instanceVariableNames:'varName exprSingle quantifiedExpr_Impl'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstQuantifiedExpr_Impl methodsFor:'accessing'!

exprSingle
    ^ exprSingle

    "Created: / 17-03-2006 / 16:16:55 / ked"
!

exprSingle:something
    exprSingle := something.

    "Created: / 17-03-2006 / 16:16:55 / ked"
!

quantifiedExpr_Impl
    ^ quantifiedExpr_Impl

    "Created: / 17-03-2006 / 16:16:55 / ked"
!

quantifiedExpr_Impl:something
    quantifiedExpr_Impl := something.

    "Created: / 17-03-2006 / 16:16:55 / ked"
!

varName
    ^ varName

    "Created: / 17-03-2006 / 16:16:55 / ked"
!

varName:something
    varName := something.

    "Created: / 17-03-2006 / 16:16:55 / ked"
! !

!AstQuantifiedExpr_Impl methodsFor:'private'!

quantifiedExprImplsOn:aStream 
    aStream nextPut:self.
    quantifiedExpr_Impl 
        ifNotNil:[ quantifiedExpr_Impl quantifiedExprImplsOn:aStream ].

    "Created: / 28-03-2007 / 22:32:05 / janfrog"
! !

!AstQuantifiedExpr_Impl methodsFor:'testing'!

isAstQuantifiedExpr_Impl
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstQuantifiedExpr_Impl methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstQuantifiedExpr_Impl:self

    "Created: / 06-07-2006 / 19:12:13 / ked"
! !

!AstQuantifiedExpr_Impl class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
