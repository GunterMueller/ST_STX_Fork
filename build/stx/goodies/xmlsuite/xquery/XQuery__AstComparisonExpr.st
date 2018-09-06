"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstComparisonExpr
	instanceVariableNames:'rangeExprLeft valueComp generalComp nodeComp rangeExprRight'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstComparisonExpr methodsFor:'accessing'!

generalComp
    ^ generalComp

    "Created: / 17-03-2006 / 16:43:51 / ked"
!

generalComp:something
    generalComp := something.

    "Created: / 17-03-2006 / 16:43:51 / ked"
!

nodeComp
    ^ nodeComp

    "Created: / 02-04-2006 / 14:02:12 / ked"
!

nodeComp:something
    nodeComp := something.

    "Created: / 02-04-2006 / 14:02:12 / ked"
!

rangeExprLeft
    ^ rangeExprLeft

    "Created: / 17-03-2006 / 16:43:51 / ked"
!

rangeExprLeft:something
    rangeExprLeft := something.

    "Created: / 17-03-2006 / 16:43:51 / ked"
!

rangeExprRight
    ^ rangeExprRight

    "Created: / 17-03-2006 / 16:43:51 / ked"
!

rangeExprRight:something
    rangeExprRight := something.

    "Created: / 17-03-2006 / 16:43:51 / ked"
!

valueComp
    ^ valueComp

    "Created: / 17-03-2006 / 16:43:51 / ked"
!

valueComp:something
    valueComp := something.

    "Created: / 17-03-2006 / 16:43:51 / ked"
! !

!AstComparisonExpr methodsFor:'testing'!

isAstComparisonExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:48 / ked"
! !

!AstComparisonExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstComparisonExpr:self

    "Created: / 06-07-2006 / 19:12:09 / ked"
! !

!AstComparisonExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
