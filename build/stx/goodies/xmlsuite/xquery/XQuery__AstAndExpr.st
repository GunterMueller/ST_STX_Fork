"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstAndExpr
	instanceVariableNames:'comparisonExpr andExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstAndExpr methodsFor:'accessing'!

andExpr
    ^ andExpr

    "Created: / 17-03-2006 / 16:39:56 / ked"
!

andExpr:something
    andExpr := something.

    "Created: / 17-03-2006 / 16:39:56 / ked"
!

comparisonExpr
    ^ comparisonExpr

    "Created: / 17-03-2006 / 16:39:56 / ked"
!

comparisonExpr:something
    comparisonExpr := something.

    "Created: / 17-03-2006 / 16:39:56 / ked"
! !

!AstAndExpr methodsFor:'testing'!

isAstAndExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstAndExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstAndExpr:self

    "Created: / 06-07-2006 / 19:12:08 / ked"
! !

!AstAndExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
