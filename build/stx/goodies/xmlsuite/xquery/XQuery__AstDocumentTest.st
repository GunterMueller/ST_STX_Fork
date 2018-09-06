"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDocumentTest
	instanceVariableNames:'elementTest'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDocumentTest methodsFor:'accessing'!

elementTest
    ^ elementTest

    "Created: / 21-11-2006 / 21:55:04 / ked"
!

elementTest:something
    elementTest := something.

    "Created: / 21-11-2006 / 21:55:04 / ked"
! !

!AstDocumentTest methodsFor:'testing'!

isAstDocumentTest
    ^ true

    "Created: / 21-11-2006 / 21:55:13 / ked"
! !

!AstDocumentTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDocumentTest:self

    "Created: / 21-11-2006 / 21:55:21 / ked"
! !

!AstDocumentTest class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
