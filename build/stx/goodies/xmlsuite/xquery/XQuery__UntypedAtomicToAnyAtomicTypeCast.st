"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#UntypedAtomicToAnyAtomicTypeCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!UntypedAtomicToAnyAtomicTypeCast methodsFor:'casting'!

cast
    self checkLexicalForm.
    ^ AtomicItem withValue: atomicValue nodeId asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:21:46 / Jan Kurs <kursj1@fel.cvut.cz>"
!

checkLexicalForm
    (anotherType checkLexicalForm: atomicValue stringValue) ifFalse: [
        self raiseError: '[err:FORG0001]' withMessage: 'lexical form is wrong'.
    ].

    "Created: / 17-11-2009 / 16:52:45 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!UntypedAtomicToAnyAtomicTypeCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
