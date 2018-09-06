"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstNCName
	instanceVariableNames:'content'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstNCName methodsFor:'accessing'!

content
    ^ content

    "Created: / 02-04-2006 / 21:31:41 / ked"
!

content:something
    content := something.

    "Created: / 02-04-2006 / 21:31:41 / ked"
! !

!AstNCName methodsFor:'testing'!

isAstNCName
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstNCName methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstNCName:self

    "Created: / 06-07-2006 / 19:12:11 / ked"
! !

!AstNCName class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
