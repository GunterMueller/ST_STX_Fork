"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDoubleLiteral
	instanceVariableNames:'content'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDoubleLiteral methodsFor:'accessing'!

content
    ^ content

    "Created: / 02-04-2006 / 21:37:21 / ked"
!

content:something
    content := something.

    "Created: / 02-04-2006 / 21:37:21 / ked"
! !

!AstDoubleLiteral methodsFor:'testing'!

isAstDoubleLiteral
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstDoubleLiteral methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDoubleLiteral:self

    "Created: / 06-07-2006 / 19:12:10 / ked"
! !

!AstDoubleLiteral class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
