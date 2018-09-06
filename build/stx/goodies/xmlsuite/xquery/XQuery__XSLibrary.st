"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

SmalltalkFunctionLibrary subclass:#XSLibrary
	instanceVariableNames:'genericTypeConstructor'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Libraries'
!


!XSLibrary class methodsFor:'defaults'!

genericTypeConstructorName
    ^ 'generic-type'

    "Created: / 28-10-2009 / 12:40:26 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XSLibrary class methodsFor:'function library API'!

namespaceURI
    "Superclass XQuery::FunctionLibrary class says that I am responsible to implement this method"

    ^'http://www.w3.org/2001/XMLSchema'.

    "Modified: / 18-09-2009 / 16:20:25 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XSLibrary methodsFor:'defaults'!

genericTypeConstructor
    genericTypeConstructor ifNil:
    [

        genericTypeConstructor := ExternalFunction new
            setFunctionLibrary: self;
            setLocalName: self genericTypeConstructorName;
            yourself
    ].
    ^ genericTypeConstructor

    "Created: / 28-10-2009 / 12:33:36 / Jan Kurs <kursj1@fel.cvut.cz>"
!

genericTypeConstructorName
    ^ self class genericTypeConstructorName.

    "Created: / 28-10-2009 / 12:40:43 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XSLibrary methodsFor:'function library API'!

defaultPrefix
    "Superclass XQuery::FunctionLibrary says that I am responsible to implement this method"

    ^'xs'

    "Modified: / 18-09-2009 / 16:18:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

evaluate: function inContext:context withParameters: parameters forInterpreter: interpreter

    [ 
        ^ super evaluate: function 
                inContext: context 
                withParameters: parameters 
                forInterpreter: interpreter
    ] 
    on: Error do:
    [
        " Function not known, try default type constructor"
        | params |
        params := OrderedCollection withAll: parameters.
        params add: (XQuerySequence withString: (self defaultPrefix, ':', function localName)).

        ^ super evaluate: self genericTypeConstructor
                inContext: context
                withParameters: params
                forInterpreter: interpreter.

    ]

    "Modified: / 24-12-2009 / 16:36:46 / Jan Kurs <kursj1@fel.cvut.cz>"
!

functionLocalNames
    "Superclass XQuery::FunctionLibrary says that I am responsible to implement this method"

    ^ (TypeFactory getType: 'xs:anyAtomicType') subtypes collect:
    [ :subtype |
        subtype localName.                    
    ]

    "Modified: / 24-12-2009 / 16:37:14 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XSLibrary methodsFor:'xs:*'!

genericTypeInContext: context withParameters: parameters forInterpreter: interpreter
    "xs:generic-type($typeValue as anyAtomicType, $typeName as String) as typeName"

    | typeValue typeName |

    (parameters size = 2) ifFalse:
    [   
        TypeError raise.
    ].

    (parameters first first atomizedValue isSubtypeOf: 'xs:anyAtomicType') ifFalse:
    [
        TypeError raise.
    ].

    typeValue := parameters first first atomizedValue.
    typeName := parameters second first.

    ^XQuerySequence with: (typeValue castAs: typeName value).

    "Created: / 28-10-2009 / 12:29:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 27-12-2009 / 13:43:11 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XSLibrary class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
