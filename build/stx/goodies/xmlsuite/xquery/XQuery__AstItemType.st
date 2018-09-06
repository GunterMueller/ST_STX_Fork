"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstItemType
	instanceVariableNames:'itemTest kindTest atomicType'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstItemType methodsFor:'accessing'!

atomicType
    ^ atomicType
!

atomicType:something
    atomicType := something.
!

itemTest
    ^ itemTest
!

itemTest:something
    itemTest := something.
!

kindTest
    ^ kindTest
!

kindTest:something
    kindTest := something.
! !

!AstItemType methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstItemType:self
! !

!AstItemType class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
