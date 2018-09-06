"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#DecimalToIntegerCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!DecimalToIntegerCast methodsFor:'casting'!

cast
    | value |
    "If ST is xs:decimal, xs:float or xs:double, then TV is SV with the fractional part discarded 
        and the value converted to xs:integer. 
        Thus, casting 3.1456 returns 3 and -17.89 returns -17. Casting 3.124E1 returns 31."

    value := atomicValue value truncated.
    ^ AtomicItem withValue: value asType: anotherType typeName.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:29:23 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DecimalToIntegerCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
