"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstZeroOrMultipleOccurrenceIndicator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstZeroOrMultipleOccurrenceIndicator methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"
    "stub code automatically generated - please change if required"
    
    ^aVisitor visitAstZeroOrMultipleOccurrenceIndicator:self
! !

!AstZeroOrMultipleOccurrenceIndicator class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
