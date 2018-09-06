"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstQName
	instanceVariableNames:'content'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstQName methodsFor:'accessing'!

content
    ^ content

    "Created: / 02-04-2006 / 21:27:57 / ked"
!

content:something
    content := something.

    "Created: / 02-04-2006 / 21:27:57 / ked"
! !

!AstQName methodsFor:'testing'!

isAstQName
    ^ true

    "Modified: / 12-10-2006 / 21:57:46 / ked"
! !

!AstQName methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstQName:self

    "Created: / 06-07-2006 / 19:12:13 / ked"
! !

!AstQName class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
