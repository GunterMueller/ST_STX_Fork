"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstOrExpr
	instanceVariableNames:'andExpr orExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstOrExpr methodsFor:'accessing'!

andExpr
    ^ andExpr

    "Created: / 17-03-2006 / 16:24:56 / ked"
!

andExpr:something
    andExpr := something.

    "Created: / 17-03-2006 / 16:24:57 / ked"
!

orExpr
    ^ orExpr

    "Created: / 17-03-2006 / 16:24:57 / ked"
!

orExpr:something
    orExpr := something.

    "Created: / 17-03-2006 / 16:24:57 / ked"
! !

!AstOrExpr methodsFor:'testing'!

isAstOrExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstOrExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstOrExpr:self

    "Created: / 06-07-2006 / 19:12:12 / ked"
! !

!AstOrExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
