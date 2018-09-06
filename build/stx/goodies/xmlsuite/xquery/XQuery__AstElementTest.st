"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstElementTest
	instanceVariableNames:'elementName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstElementTest methodsFor:'accessing'!

elementName
    ^ elementName

    "Created: / 21-11-2006 / 21:59:15 / ked"
!

elementName:something
    elementName := something.

    "Created: / 21-11-2006 / 21:59:15 / ked"
! !

!AstElementTest methodsFor:'testing'!

isAstElementTest
    ^ true

    "Created: / 21-11-2006 / 21:59:24 / ked"
! !

!AstElementTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstElementTest:self

    "Created: / 21-11-2006 / 21:59:28 / ked"
! !

!AstElementTest class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
