"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstStringLiteral
	instanceVariableNames:'content'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstStringLiteral methodsFor:'accessing'!

content
    ^ content

    "Created: / 02-04-2006 / 21:33:03 / ked"
!

content:something
    content := something.

    "Created: / 02-04-2006 / 21:33:03 / ked"
! !

!AstStringLiteral methodsFor:'testing'!

isAstStringLiteral
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstStringLiteral methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstStringLiteral:self

    "Created: / 06-07-2006 / 19:12:14 / ked"
! !

!AstStringLiteral class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
