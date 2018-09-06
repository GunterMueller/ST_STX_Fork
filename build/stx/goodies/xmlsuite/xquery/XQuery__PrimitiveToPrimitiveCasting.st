"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#PrimitiveToPrimitiveCasting
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!PrimitiveToPrimitiveCasting methodsFor:'casting'!

accept: type and: anotherType
    ^ (self isAcceptable:type)
        and: [ self isAcceptable: anotherType ].

    "Created: / 07-11-2009 / 17:20:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

cast: atomicValue to: anotherType
    [
        ^ (self castRuleFor: atomicValue to: anotherType) cast 
    ] 
    on: Exception
    do: [ :ex |
        self raiseError: '[err:FORG0001]' withMessage: ex asString.
    ].

    "Created: / 07-11-2009 / 16:51:22 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 16:55:59 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!PrimitiveToPrimitiveCasting methodsFor:'casting - private'!

castRuleFor: atomicValue to: anotherType
    | name fromType toType castClass |

    fromType := TypeFactory getType: atomicValue typeName.
    toType := anotherType.

    [ castClass isNil ] whileTrue:
    [
        name := 'XQuery::',fromType localName asUppercaseFirst, 'To', toType localName asUppercaseFirst, 'Cast'.
        castClass := Smalltalk classNamed: name.

        (TypeFactory current isType: fromType instanceOf: (TypeFactory getType: 'xs:anyAtomicType')) ifFalse: [
            " generalize fromType at first"
            fromType := TypeFactory current supertypeOf: fromType.
        ] ifTrue: [
            " from type is anyAtomicType, so generalize to type"
            toType := TypeFactory current supertypeOf: toType.
        ]
    ].

    ^ (castClass new)
        atomicValue: atomicValue;
        anotherType: anotherType;
        yourself.

    "Created: / 09-11-2009 / 16:13:05 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isAcceptable: type
    ^ type isPrimitive or: [ type typeName = 'xs:integer' ].

    "Created: / 07-11-2009 / 17:20:40 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 18-11-2009 / 00:24:48 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!PrimitiveToPrimitiveCasting methodsFor:'error reporting'!

raiseError: errorType
    AtomicItemError raiseErrorString: 'Error no.: ', errorType.

    "Created: / 05-10-2009 / 17:20:46 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 16:14:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

raiseError: errorType withMessage: message
    AtomicItemError raiseErrorString: message, ' Error no.: ', errorType.

    "Created: / 05-10-2009 / 17:21:52 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 16:14:25 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!PrimitiveToPrimitiveCasting class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
