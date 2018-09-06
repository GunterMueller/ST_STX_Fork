"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

AnyAtomicTypeToAnyAtomicTypeCast subclass:#DoubleToDecimalCast
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!DoubleToDecimalCast methodsFor:'casting'!

cast
    "If SV is one of the special xs:float or xs:double values NaN, INF, or -INF, an error is raised [err:FOCA0002]"
    | sv |
    sv := atomicValue value.
    ((sv isNaN) or: [sv isInfinite]) ifTrue:
    [
        self raiseError: '[err:FOCA0001]' withMessage: 'NaN, INF, or -INF cannot be casted'.
    ].

    ^ (AnyAtomicTypeToDecimalCast new)
        atomicValue: atomicValue;
        anotherType: anotherType;
        checkedCast.

    "Created: / 17-11-2009 / 16:46:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 22:29:08 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DoubleToDecimalCast class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
