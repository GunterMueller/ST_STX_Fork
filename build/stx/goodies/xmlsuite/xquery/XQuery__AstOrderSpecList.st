"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstOrderSpecList
	instanceVariableNames:'orderSpec orderSpecList'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstOrderSpecList methodsFor:'accessing'!

orderSpec
    ^ orderSpec

    "Created: / 10-03-2006 / 21:56:10 / ked"
!

orderSpec:something
    orderSpec := something.

    "Created: / 10-03-2006 / 21:56:10 / ked"
!

orderSpecList
    ^ orderSpecList

    "Created: / 10-03-2006 / 21:56:10 / ked"
!

orderSpecList:something
    orderSpecList := something.

    "Created: / 10-03-2006 / 21:56:10 / ked"
! !

!AstOrderSpecList methodsFor:'testing'!

isAstOrderSpecList
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstOrderSpecList methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstOrderSpecList:self

    "Created: / 06-07-2006 / 19:12:12 / ked"
! !

!AstOrderSpecList class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
