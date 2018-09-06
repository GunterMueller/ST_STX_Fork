"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstNamespaceDecl
	instanceVariableNames:'prefix nsuri'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstNamespaceDecl methodsFor:'accessing'!

nsuri
    ^ nsuri

    "Created: / 24-12-2006 / 15:05:24 / janfrog"
!

nsuri:anAstURILiteral
    nsuri := anAstURILiteral.

    "Created: / 24-12-2006 / 15:05:24 / janfrog"
!

prefix
    ^ prefix

    "Created: / 24-12-2006 / 15:05:24 / janfrog"
!

prefix:anAstNCName
    prefix := anAstNCName.

    "Created: / 24-12-2006 / 15:05:24 / janfrog"
! !

!AstNamespaceDecl methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstNamespaceDecl:self

    "Created: / 24-12-2006 / 15:06:03 / janfrog"
! !

!AstNamespaceDecl class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
