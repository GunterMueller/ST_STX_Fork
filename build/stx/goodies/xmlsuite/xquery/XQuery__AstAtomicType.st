"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstAtomicType
	instanceVariableNames:'qName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstAtomicType methodsFor:'accessing'!

qName
    ^ qName
!

qName:something
    qName := something.
! !

!AstAtomicType methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAstAtomicType:self
! !

!AstAtomicType class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
