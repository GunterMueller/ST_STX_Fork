"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstParam
	instanceVariableNames:'name type'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstParam methodsFor:'accessing'!

name
    ^ name

    "Created: / 28-12-2006 / 13:45:53 / janfrog"
!

name:something
    name := something.

    "Created: / 28-12-2006 / 13:45:53 / janfrog"
!

type
    ^ type

    "Created: / 28-12-2006 / 13:45:53 / janfrog"
!

type:something
    type := something.

    "Created: / 28-12-2006 / 13:45:53 / janfrog"
! !

!AstParam methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstParam:self

    "Created: / 28-12-2006 / 14:03:11 / janfrog"
! !

!AstParam class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
