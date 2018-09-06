"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstFilterExpr
	instanceVariableNames:'primaryExpr predicateList'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstFilterExpr methodsFor:'accessing'!

predicateList
    ^ predicateList

    "Created: / 18-03-2006 / 21:10:25 / ked"
!

predicateList:something
    predicateList := something.

    "Created: / 18-03-2006 / 21:10:25 / ked"
!

primaryExpr
    ^ primaryExpr

    "Created: / 18-03-2006 / 21:10:25 / ked"
!

primaryExpr:something
    primaryExpr := something.

    "Created: / 18-03-2006 / 21:10:25 / ked"
! !

!AstFilterExpr methodsFor:'testing'!

isAstFilterExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstFilterExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstFilterExpr:self

    "Created: / 06-07-2006 / 19:12:10 / ked"
! !

!AstFilterExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
