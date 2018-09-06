"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstDirAttributeListElem
	instanceVariableNames:'qName dirAttributeValue'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstDirAttributeListElem methodsFor:'accessing'!

dirAttributeValue
    ^ dirAttributeValue
!

dirAttributeValue:something
    dirAttributeValue := something.
!

qName
    ^ qName
!

qName:something
    qName := something.
! !

!AstDirAttributeListElem methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstDirAttributeListElem:self
! !

!AstDirAttributeListElem class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
