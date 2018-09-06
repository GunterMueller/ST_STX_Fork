"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstBaseUriDecl
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstBaseUriDecl methodsFor:'accessing'!

value
    ^ value
!

value:something
    value := something.
! !

!AstBaseUriDecl methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstBaseUriDecl:self
! !

!AstBaseUriDecl class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
