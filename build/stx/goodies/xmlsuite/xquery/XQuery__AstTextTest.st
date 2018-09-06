"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstTextTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstTextTest methodsFor:'testing'!

isAstTextTest
    ^ true

    "Created: / 21-11-2006 / 21:56:13 / ked"
! !

!AstTextTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstTextTest:self

    "Created: / 21-11-2006 / 21:56:20 / ked"
! !

!AstTextTest class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
