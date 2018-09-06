"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstNameTest
	instanceVariableNames:'qname wildcard'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstNameTest methodsFor:'accessing'!

qname
    ^ qname

    "Created: / 12-10-2006 / 21:57:36 / ked"
!

qname:something
    qname := something.

    "Created: / 12-10-2006 / 21:57:36 / ked"
!

wildcard
    ^ wildcard

    "Created: / 12-10-2006 / 21:57:36 / ked"
!

wildcard:something
    wildcard := something.

    "Created: / 12-10-2006 / 21:57:36 / ked"
! !

!AstNameTest methodsFor:'testing'!

isAstNameTest
    ^ true

    "Created: / 12-10-2006 / 21:57:47 / ked"
! !

!AstNameTest methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstNameTest:self

    "Created: / 12-10-2006 / 21:58:21 / ked"
! !

!AstNameTest class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
