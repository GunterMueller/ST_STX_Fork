"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDefaultNamespaceDecl
	instanceVariableNames:'type uri'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDefaultNamespaceDecl methodsFor:'accessing'!

type
    ^ type

    "Created: / 24-12-2006 / 15:02:56 / janfrog"
!

type:aSymbol

    self assert:(#(element function) includes:aSymbol).

    type := aSymbol.

    "Created: / 24-12-2006 / 15:02:56 / janfrog"
!

uri
    ^ uri

    "Created: / 24-12-2006 / 15:04:32 / janfrog"
!

uri:anAstURILiteral
    uri := anAstURILiteral.

    "Created: / 24-12-2006 / 15:04:32 / janfrog"
! !

!AstDefaultNamespaceDecl methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDefaultNamespaceDecl:self

    "Created: / 24-12-2006 / 15:06:03 / janfrog"
! !

!AstDefaultNamespaceDecl class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
