"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UntypedAtomicToAnyAtomicTypeCast subclass:#UntypedAtomicToBooleanCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!UntypedAtomicToBooleanCast methodsFor:'casting'!

cast
    | value bValue |
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
! !

!UntypedAtomicToBooleanCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
