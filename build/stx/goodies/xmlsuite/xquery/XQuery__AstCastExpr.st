"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstCastExpr
	instanceVariableNames:'unaryExpr singleType'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstCastExpr methodsFor:'accessing'!

singleType
    ^ singleType
!

singleType:something
    singleType := something.
!

unaryExpr
    ^ unaryExpr
!

unaryExpr:something
    unaryExpr := something.
! !

!AstCastExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstCastExpr:self
! !

!AstCastExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
