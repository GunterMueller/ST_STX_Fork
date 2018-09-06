"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AstNode subclass:#AstSequenceType
	instanceVariableNames:'itemType occurrenceIndicator'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-AST'
!


!AstSequenceType class methodsFor:'accessing'!

emptySequence
    ^#emptyseq.

    "Created: / 10-05-2009 / 11:10:21 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstSequenceType methodsFor:'accessing'!

itemType
    ^ itemType
!

itemType:something
    itemType := something.
!

occurrenceIndicator
    ^occurrenceIndicator
!

occurrenceIndicator:something 
    " grammar could set occurence indicator to nil - in that case
        let it be one occurence indicator."
    
    something isNil 
        ifTrue:[occurrenceIndicator := AstOneOccurrenceIndicator new.]
        ifFalse:[occurrenceIndicator := something.].

    "Modified: / 10-05-2009 / 16:32:14 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstSequenceType methodsFor:'empty sequence'!

isWithEmptySequence
    ^ itemType = self class emptySequence.

    "Created: / 10-05-2009 / 14:58:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withEmptySequence
    itemType := self class emptySequence.

    "Created: / 10-05-2009 / 11:09:33 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstSequenceType methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"
    ^ aVisitor visitAstSequenceType:self

    "Modified: / 14-10-2009 / 23:58:20 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AstSequenceType class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
