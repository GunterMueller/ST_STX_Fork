"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDummyNode
	instanceVariableNames:'dummyValue'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDummyNode methodsFor:'accessing'!

dummyValue
    ^ dummyValue

    "Created: / 28-03-2007 / 20:25:05 / janfrog"
!

dummyValue:something
    dummyValue := something.

    "Created: / 28-03-2007 / 20:25:05 / janfrog"
! !

!AstDummyNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDummyNode:self

    "Created: / 28-03-2007 / 20:24:54 / janfrog"
! !

!AstDummyNode class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
