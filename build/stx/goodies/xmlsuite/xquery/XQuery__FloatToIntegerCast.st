"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#FloatToIntegerCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!FloatToIntegerCast methodsFor:'casting'!

cast
    | value |
    "If ST is xs:decimal, xs:float or xs:double, then TV is SV with the fractional part discarded 
        and the value converted to xs:integer. 
        Thus, casting 3.1456 returns 3 and -17.89 returns -17. Casting 3.124E1 returns 31."

    value := atomicValue nodeId truncated.
    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 18:10:43 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!FloatToIntegerCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
