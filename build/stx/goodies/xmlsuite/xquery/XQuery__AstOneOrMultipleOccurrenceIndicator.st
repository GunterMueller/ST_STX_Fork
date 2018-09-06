"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstOneOrMultipleOccurrenceIndicator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstOneOrMultipleOccurrenceIndicator methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"
    "stub code automatically generated - please change if required"
    
    ^aVisitor visitAstOneOrMultipleOccurrenceIndicator:self
! !

!AstOneOrMultipleOccurrenceIndicator class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
