"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstCastableExpr
	instanceVariableNames:'castExpr singleType'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstCastableExpr methodsFor:'accessing'!

castExpr
    ^ castExpr
!

castExpr:something
    castExpr := something.
!

singleType
    ^ singleType
!

singleType:something
    singleType := something.
! !

!AstCastableExpr methodsFor:'visiting'!

acceptVisitor:aVisitor
    "Superclass XQuery::AstNode says that I am responsible to implement this method"

    ^ aVisitor visitAstCastableExpr:self

    "Modified: / 05-07-2009 / 16:33:53 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstCastableExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
