"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstOneOccurrenceIndicator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstOneOccurrenceIndicator methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"
    "stub code automatically generated - please change if required"
    
    ^aVisitor visitAstOneOccurrenceIndicator:self
! !

!AstOneOccurrenceIndicator class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
