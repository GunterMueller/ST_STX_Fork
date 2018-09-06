"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#CrossTypeHierarchyCasting
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!CrossTypeHierarchyCasting methodsFor:'casting'!

accept: type and: anotherType
    ^ type isXMLType and: [ anotherType isXMLType ].

    "Created: / 07-11-2009 / 17:20:20 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 18-11-2009 / 00:47:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

cast: atomicValue to: anotherType
    [
        | atomicValueType fromPrimitiveType toPrimitiveType typeFactory |
        typeFactory := TypeFactory current.
        atomicValueType := typeFactory getType: atomicValue type.
        fromPrimitiveType := typeFactory primitiveTypeFor: atomicValueType.
        toPrimitiveType := typeFactory primitiveTypeFor: anotherType.


        ^ ((atomicValue castAs: fromPrimitiveType typeName) castAs: toPrimitiveType typeName) castAs: anotherType typeName
    ] 
    on: Exception
    do: [ :ex |
        self raiseError: '[err:FORG0001]' withMessage: ex asString.
    ].

    "Created: / 07-11-2009 / 16:51:22 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 18:27:13 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!CrossTypeHierarchyCasting methodsFor:'error reporting'!

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

!CrossTypeHierarchyCasting class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
