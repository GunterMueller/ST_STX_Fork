"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstRelativePathExpr
	instanceVariableNames:'stepExpr divSign relativePathExpr'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstRelativePathExpr methodsFor:'accessing'!

divSign
    ^ divSign

    "Created: / 18-03-2006 / 11:38:04 / ked"
!

divSign:something
    divSign := something.

    "Created: / 18-03-2006 / 11:38:04 / ked"
!

relativePathExpr
    ^ relativePathExpr

    "Created: / 18-03-2006 / 11:38:04 / ked"
!

relativePathExpr:something
    relativePathExpr := something.

    "Created: / 18-03-2006 / 11:38:04 / ked"
!

stepExpr
    ^ stepExpr

    "Created: / 18-03-2006 / 11:38:04 / ked"
!

stepExpr:something
    stepExpr := something.

    "Created: / 18-03-2006 / 11:38:04 / ked"
! !

!AstRelativePathExpr methodsFor:'testing'!

isAstRelativePathExpr
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstRelativePathExpr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstRelativePathExpr:self

    "Created: / 06-07-2006 / 19:12:13 / ked"
! !

!AstRelativePathExpr class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
