"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDecimalLiteral
	instanceVariableNames:'content'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDecimalLiteral methodsFor:'accessing'!

content
    ^ content

    "Created: / 02-04-2006 / 21:36:14 / ked"
!

content:something
    content := something.

    "Created: / 02-04-2006 / 21:36:14 / ked"
! !

!AstDecimalLiteral methodsFor:'testing'!

isAstDecimalLiteral
    ^ true

    "Modified: / 12-10-2006 / 21:57:45 / ked"
! !

!AstDecimalLiteral methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDecimalLiteral:self

    "Created: / 06-07-2006 / 19:12:09 / ked"
! !

!AstDecimalLiteral class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
