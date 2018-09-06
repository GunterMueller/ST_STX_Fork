"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstFunctionDecl
	instanceVariableNames:'name paramList body'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstFunctionDecl methodsFor:'accessing'!

body
    ^ body

    "Created: / 28-12-2006 / 13:47:38 / janfrog"
!

body:something
    body := something.

    "Created: / 28-12-2006 / 13:47:38 / janfrog"
!

name
    ^ name

    "Created: / 28-12-2006 / 13:47:38 / janfrog"
!

name:something
    name := something.

    "Created: / 28-12-2006 / 13:47:38 / janfrog"
!

paramList
    ^ paramList

    "Created: / 28-12-2006 / 13:47:38 / janfrog"
!

paramList:something
    paramList := something.

    "Created: / 28-12-2006 / 13:47:38 / janfrog"
! !

!AstFunctionDecl methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstFunctionDecl:self

    "Created: / 28-12-2006 / 14:03:11 / janfrog"
! !

!AstFunctionDecl class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
