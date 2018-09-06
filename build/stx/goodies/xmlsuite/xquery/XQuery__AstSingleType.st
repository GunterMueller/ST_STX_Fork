"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstSingleType
	instanceVariableNames:'atomicType occurenceIndicator'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstSingleType methodsFor:'accessing'!

atomicType
    ^ atomicType
!

atomicType:something
    atomicType := something.
!

occurenceIndicator
    ^ occurenceIndicator
!

occurenceIndicator:something
    occurenceIndicator := something.
! !

!AstSingleType methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    self error: 'AstSingleType does not accept visitor'.
    ^ aVisitor visitAstSingleType:self

    "Modified: / 14-10-2009 / 23:58:35 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstSingleType class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
