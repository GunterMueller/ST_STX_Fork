"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#StringToAnyAtomicTypeCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!StringToAnyAtomicTypeCast methodsFor:'casting'!

cast
    self normalizeWhitespaces.
    self checkLexicalForm.
    ^ AtomicItem withValue: atomicValue nodeId asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:21:46 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 20:05:56 / Jan Kurs <kursj1@fel.cvut.cz>"
!

checkLexicalForm
    (anotherType checkLexicalForm: atomicValue stringValue) ifFalse: [
        self raiseError: '[err:FORG0001]' withMessage: 'lexical form is wrong'.
    ].

    "Created: / 17-11-2009 / 16:52:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

normalizeWhitespaces
    atomicValue value: atomicValue value trim.

    "Created: / 21-11-2009 / 20:02:34 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!StringToAnyAtomicTypeCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
