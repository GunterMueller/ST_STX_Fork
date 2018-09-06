"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstPathExpr
	instanceVariableNames:'startSign relativePathExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstPathExpr methodsFor:'accessing'!

relativePathExpr
    ^ relativePathExpr

    "Created: / 17-03-2006 / 19:08:04 / ked"
!

relativePathExpr:something
    relativePathExpr := something.

    "Created: / 17-03-2006 / 19:08:04 / ked"
!

startSign
    ^ startSign

    "Created: / 17-03-2006 / 19:08:04 / ked"
!

startSign:something
    startSign := something.

    "Created: / 17-03-2006 / 19:08:04 / ked"
! !

!AstPathExpr methodsFor:'testing'!

isAstPathExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstPathExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstPathExpr:self

    "Created: / 06-07-2006 / 19:12:12 / ked"
! !

!AstPathExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
