"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstZeroOrOneOccurrenceIndicator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstZeroOrOneOccurrenceIndicator methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"
    "stub code automatically generated - please change if required"
    
    ^aVisitor visitAstZeroOrOneOccurrenceIndicator:self
! !

!AstZeroOrOneOccurrenceIndicator class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
