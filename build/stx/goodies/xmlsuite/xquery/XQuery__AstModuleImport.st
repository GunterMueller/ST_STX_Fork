"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstModuleImport
	instanceVariableNames:'prefix uri'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstModuleImport methodsFor:'accessing'!

prefix
    ^ prefix

    "Created: / 01-12-2008 / 09:56:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

prefix:something
    prefix := something.

    "Created: / 01-12-2008 / 09:56:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

uri
    ^ uri

    "Created: / 01-12-2008 / 09:56:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

uri:something
    uri := something.

    "Created: / 01-12-2008 / 09:56:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!AstModuleImport methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstModuleImport:self

    "Created: / 01-12-2008 / 09:53:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!AstModuleImport class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
