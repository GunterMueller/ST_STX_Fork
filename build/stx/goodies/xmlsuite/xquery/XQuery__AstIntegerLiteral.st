"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstIntegerLiteral
	instanceVariableNames:'content'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstIntegerLiteral methodsFor:'accessing'!

content
    ^ content

    "Created: / 02-04-2006 / 21:34:29 / ked"
!

content:something
    content := something.

    "Created: / 02-04-2006 / 21:34:29 / ked"
! !

!AstIntegerLiteral methodsFor:'testing'!

isAstIntegerLiteral
    ^ true

    "Modified: / 12-10-2006 / 21:57:47 / ked"
! !

!AstIntegerLiteral methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstIntegerLiteral:self

    "Created: / 06-07-2006 / 19:12:11 / ked"
! !

!AstIntegerLiteral class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
