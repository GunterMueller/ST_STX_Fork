"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstInstanceOfExpr
	instanceVariableNames:'treatExpr sequenceType'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstInstanceOfExpr methodsFor:'accessing'!

sequenceType
    ^ sequenceType

    "Created: / 08-03-2009 / 22:15:17 / Jan Kurs <kursj1@fel.cvut.cz>"
!

sequenceType:something
    sequenceType := something.

    "Created: / 08-03-2009 / 22:15:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

treatExpr
    ^ treatExpr
!

treatExpr:something
    treatExpr := something.
! !

!AstInstanceOfExpr methodsFor:'testing'!

isAstInstanceOfExpr
    ^ true

    "Created: / 08-03-2009 / 22:39:17 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstInstanceOfExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    ^ aVisitor visitAstInstanceOfExpr: self

    "Created: / 08-03-2009 / 22:40:07 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstInstanceOfExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
