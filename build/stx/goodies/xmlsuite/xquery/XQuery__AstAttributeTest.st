"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstAttributeTest
	instanceVariableNames:'attribName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstAttributeTest methodsFor:'accessing'!

attribName
    ^ attribName

    "Created: / 21-11-2006 / 21:57:13 / ked"
!

attribName:something
    attribName := something.

    "Created: / 21-11-2006 / 21:57:14 / ked"
! !

!AstAttributeTest methodsFor:'testing'!

isAstAttributeTest
    ^ true

    "Created: / 21-11-2006 / 21:57:19 / ked"
! !

!AstAttributeTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstAttributeTest:self

    "Created: / 21-11-2006 / 21:57:25 / ked"
! !

!AstAttributeTest class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
