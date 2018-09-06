"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstRangeExpr
	instanceVariableNames:'additiveExprFrom additiveExprTo'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstRangeExpr methodsFor:'accessing'!

additiveExprFrom
    ^ additiveExprFrom

    "Created: / 17-03-2006 / 16:44:45 / ked"
!

additiveExprFrom:something
    additiveExprFrom := something.

    "Created: / 17-03-2006 / 16:44:45 / ked"
!

additiveExprTo
    ^ additiveExprTo

    "Created: / 17-03-2006 / 16:44:45 / ked"
!

additiveExprTo:something
    additiveExprTo := something.

    "Created: / 17-03-2006 / 16:44:45 / ked"
! !

!AstRangeExpr methodsFor:'testing'!

isAstRangeExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstRangeExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstRangeExpr:self

    "Created: / 06-07-2006 / 19:12:13 / ked"
! !

!AstRangeExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
