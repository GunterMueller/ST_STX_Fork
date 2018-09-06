"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

StringToAnyAtomicTypeCast subclass:#StringToBooleanCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!StringToBooleanCast methodsFor:'casting'!

cast
    | value bValue |
    self normalizeWhitespaces.
    self checkLexicalForm .
    value := atomicValue nodeId.

    ((value = 'true') or: [value = '1']) ifTrue:
    [
        bValue := true.
    ] 
    ifFalse: 
    [
        self assert: ((value = 'false') or: [value = '0']) message: 'unsupported value for boolean'.
        bValue := false.
    ].

    ^ AtomicItem withValue: bValue asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:27:13 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 20:06:06 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!StringToBooleanCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
