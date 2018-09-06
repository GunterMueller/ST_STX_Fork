"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#TypeFactory
	instanceVariableNames:'typeHierarchy'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!

TypeFactory class instanceVariableNames:'default'

"
 No other class instance variables are inherited by this class.
"
!

!TypeFactory class methodsFor:'documentation'!

documentation
"
    This should be entry point to all XQuery types.

    It is only utility class - no instances are allowed.

    [author:]
        Honza (kursj1@fel.cvut.cz)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!TypeFactory class methodsFor:'instance creation'!

current
    ^ TypeFactoryQuery query.

    "Created: / 01-11-2009 / 18:49:53 / Jan Kurs <kursj1@fel.cvut.cz>"
!

default
    "TODO: only for develop purposes"
"/    Transcript showCR: ' !!!!!!!! TYPE SUBSYSTEM WARNING !!!!!!!! : Default TypeFactory accessed!!'.
    default ifNil: [ 
        default:= self new 
    ].
    ^ default.

    "Created: / 01-11-2009 / 18:50:50 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-11-2009 / 12:15:46 / Jan Kurs <kursj1@fel.cvut.cz>"
!

new
    ^ self basicNew initialize.

    "Created: / 01-11-2009 / 18:20:30 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeFactory class methodsFor:'execution'!

current: factory do: block    
    ^TypeFactoryQuery answer: factory do: block

    "Created: / 01-11-2009 / 18:55:15 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeFactory class methodsFor:'testing'!

isNumeric: typeName
    ^ self current isNumeric: typeName.

    "Created: / 30-12-2009 / 14:00:20 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeFactory class methodsFor:'type accessing'!

getType: typeName
    ^ self current getType: typeName.

    "Modified: / 01-11-2009 / 19:01:06 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isType: typeName subtypeOf: supertypeName
    self assert: typeName isString.
    self assert: supertypeName isString.

    ^ self current isType: (self getType: typeName) subtypeOf: (self getType: supertypeName)

    "Modified: / 07-11-2009 / 23:43:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isType: typeName supertypeOf: subtypeName
    ^ self isType: subtypeName subtypeOf: typeName

    "Created: / 08-11-2009 / 14:42:13 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 14:44:44 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeFactory methodsFor:'accessing'!

typeHierarchy
    typeHierarchy ifNil:
    [
        typeHierarchy := TypeHierarchy new.
    ].
    ^ typeHierarchy

    "Modified: / 05-11-2009 / 21:38:07 / Jan Kurs <kursj1@fel.cvut.cz>"
!

typeHierarchy:something
    typeHierarchy := something.
! !

!TypeFactory methodsFor:'bult-in types creation'!

getXSByte
    ^ (DerivedAtomicType new)
        typeName: 'xs:byte';
        yourself.

    "Created: / 06-11-2009 / 12:54:15 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSInt
    ^ (DerivedAtomicType new)
        typeName: 'xs:int';
        yourself.

    "Created: / 06-11-2009 / 12:56:53 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSInteger
    ^ (DerivedAtomicType new)
        typeName: 'xs:integer';
        lexicalFormChecker: self xsIntegerLexicalForm;
        canonicalLexicalFormConverter: IntegerFormatter;
        yourself.

    "Created: / 06-11-2009 / 11:35:54 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 18:21:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSLong
    ^ (DerivedAtomicType new)
        typeName: 'xs:long';
        yourself.

    "Created: / 06-11-2009 / 12:56:00 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSNegativeInteger
    ^ (DerivedAtomicType new)
        typeName: 'xs:negativeInteger';
        yourself.

    "Created: / 06-11-2009 / 13:28:11 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSNonNegativeInteger
    ^ (DerivedAtomicType new)
        typeName: 'xs:nonNegativeInteger';
        yourself.

    "Created: / 06-11-2009 / 12:46:56 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSNonPositiveInteger
    ^ (DerivedAtomicType new)
        typeName: 'xs:nonPositiveInteger';
        yourself.

    "Created: / 06-11-2009 / 13:26:40 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSPositiveInteger
    ^ (DerivedAtomicType new)
        typeName: 'xs:positiveInteger';
        yourself.

    "Created: / 06-11-2009 / 12:55:10 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSShort
    ^ (DerivedAtomicType new)
        typeName: 'xs:short';
        yourself.

    "Created: / 06-11-2009 / 12:16:46 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSUnsignedByte
    ^ (DerivedAtomicType new)
        typeName: 'xs:unsignedByte';
        yourself.

    "Created: / 06-11-2009 / 12:53:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSUnsignedInt
    ^ (DerivedAtomicType new)
        typeName: 'xs:unsignedInt';
        yourself.

    "Created: / 06-11-2009 / 12:50:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSUnsignedLong
    ^ (DerivedAtomicType new)
        typeName: 'xs:unsignedLong';
        yourself.

    "Created: / 06-11-2009 / 13:23:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getXSUnsignedShort
    ^ (DerivedAtomicType new)
        typeName: 'xs:unsignedShort';
        yourself.

    "Created: / 06-11-2009 / 12:53:04 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeFactory methodsFor:'error reporting'!

raiseError
    TypeError raise.

    "Created: / 01-11-2009 / 18:29:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

raiseErrorWithMessage: message
    TypeError raiseErrorString: message.

    "Created: / 01-11-2009 / 18:28:10 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeFactory methodsFor:'initialization'!

initialize
    "Initialize Built-in Types according to the XML Schema spec"

    self initializeNodes.
    self initializePrimitiveTypes.
    self initializeDerivedTypes.

    "Created: / 01-11-2009 / 18:21:50 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-11-2009 / 20:53:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

initializeDerivedTypes
    "Initialize Built-in derived types according to the XML Schema spec"
    | parent subtype |

    parent := self getType: 'xs:decimal'.
    subtype := self getXSInteger.
    self typeHierarchy addSubtype: subtype toType: parent.

    parent := self getType: 'xs:integer'.
    subtype := self getXSLong.
    self typeHierarchy addSubtype: subtype toType: parent.
    subtype := self getXSNonPositiveInteger.
    self typeHierarchy addSubtype: subtype toType: parent.
    subtype := self getXSNonNegativeInteger.
    self typeHierarchy addSubtype: subtype toType: parent.

    parent := self getType: 'xs:nonPositiveInteger'.
    subtype := self getXSNegativeInteger.
    self typeHierarchy addSubtype: subtype toType: parent.


    parent := self getType: 'xs:long'.
    subtype := self getXSInt.
    self typeHierarchy addSubtype: subtype toType: parent.
    subtype := self getXSShort.
    self typeHierarchy addSubtype: subtype toType: parent.
    subtype := self getXSByte.
    self typeHierarchy addSubtype: subtype toType: parent.


    parent := self getType: 'xs:nonNegativeInteger'.
    subtype := self getXSUnsignedLong.
    self typeHierarchy addSubtype: subtype toType: parent.
    subtype := self getXSUnsignedInt.
    self typeHierarchy addSubtype: subtype toType: parent.
    subtype := self getXSUnsignedShort.
    self typeHierarchy addSubtype: subtype toType: parent.
    subtype := self getXSUnsignedByte.
    self typeHierarchy addSubtype: subtype toType: parent.
    subtype := self getXSPositiveInteger.
    self typeHierarchy addSubtype: subtype toType: parent.

    "Created: / 01-11-2009 / 18:22:18 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-11-2009 / 13:29:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

initializeNodes
    "Initialize Built-in derived types according to the XML Schema spec"
    | node |

    node := TypeNode instance.
    self typeHierarchy addType: node.
    TypeNode subclasses do:
    [:subclass |
        | type |
        type := subclass instance.
        self typeHierarchy addSubtype: type toType: node.
    ]

    "Created: / 06-11-2009 / 20:48:08 / Jan Kurs <kursj1@fel.cvut.cz>"
!

initializePrimitiveTypes
    "Initialize Built-in primitive types according to the XML Schema spec"
    | anyAtomic |

    anyAtomic := TypeXSAnyAtomicType instance.
    self typeHierarchy addType: anyAtomic.
    TypeXSAnyAtomicType subclasses do:
    [:subclass |
        | type |
        type := subclass instance.
        self typeHierarchy addSubtype: type toType: anyAtomic.
    ]

    "Created: / 01-11-2009 / 18:22:12 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-11-2009 / 20:57:51 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeFactory methodsFor:'lexical form'!

xsIntegerLexicalForm
    ^ (LexicalFormChecker new)
        checkBlock:
        [ :form |
                "HOTFIX - regex would be much better"
                form conform: [:character | 
                    ('[0-9+]' match: character asString ignoreCase: true)
                    or: [character asString = '-'].
                ]
        ];
        yourself.

    "Created: / 06-11-2009 / 14:05:38 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 16-11-2009 / 18:47:02 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeFactory methodsFor:'testing'!

isNumeric: typeName
    | type |
    type := self getType: typeName.

    ^ (self isType: type subtypeOf: (self getType: 'xs:decimal')) or: 
      [self isType: type subtypeOf: (self getType: 'xs:float')] or: 
      [self isType: type subtypeOf: (self getType: 'xs:double')].

    "Created: / 07-11-2009 / 23:34:06 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 14:02:19 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isType: type instanceOf: anotherType
    self assert: type isXMLType.
    self assert: anotherType isXMLType.

    ^type = anotherType.

    "Created: / 08-11-2009 / 14:32:46 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isType: type subtypeOf: anotherType
    self assert: type isXMLType.
    self assert: anotherType isXMLType.

    ^type = anotherType
        ifTrue:
            [true]
        ifFalse: [
            | supertype |
            supertype := type supertype.
            supertype ifNil: [ false ]
                      ifNotNil: [ self isType: supertype subtypeOf: anotherType]
        ].

    "Created: / 06-11-2009 / 11:28:15 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-11-2009 / 23:54:15 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isType: type supertypeOf: anotherType

    ^ self isType: anotherType subtypeOf: type

    "Created: / 06-11-2009 / 11:28:52 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeFactory methodsFor:'type accessing'!

getType: typeName
    "typeName is string name of the requiered type"

    ^ (self typeHierarchy getTypeByName: typeName) value

    "this ugly if cascade is temporary solution - it should be replaced.
        It is neccessary to create proper type system at first"
"/    | qName |
"/
"/    (typeName = 'item') ifTrue: [ ^ TypeItem instance ].
"/    (typeName = 'node') ifTrue: [ ^ TypeNode instance ].
"/    (typeName = 'attribute') ifTrue: [ ^ TypeAttribute instance ].
"/    (typeName = 'comment') ifTrue: [ ^ TypeComment instance ].
"/    (typeName = 'document') ifTrue: [ ^ TypeDocument instance ].
"/    (typeName = 'element') ifTrue: [ ^ TypeElement instance ].
"/    (typeName = 'processing-instruction') ifTrue: [ ^ TypeProcessingInstruction instance ].
"/    (typeName = 'text') ifTrue: [ ^ TypeText instance ].
"/
"/    "This work only for the primitive types not for derived types!!"
"/    qName := QName withQNameString: typeName.
"/    ^ (Smalltalk classNamed: 'XQuery::TypeXS', qName localName asUppercaseFirst) instance.

"/    (typeName = 'xs:anyAtomicType') ifTrue: [ ^ TypeXSAnyAtomicType instance ].
"/    (typeName = 'xs:untypedAtomic') ifTrue: [ ^ TypeXSUntypedAtomic instance ].
"/    (typeName = 'xs:dateTime') ifTrue: [ ^ TypeXSDateTime instance ].
"/    (typeName = 'xs:time') ifTrue: [ ^ TypeXSTime instance ].
"/    (typeName = 'xs:QName') ifTrue: [ ^ TypeXSQName instance ].
"/    (typeName = 'xs:string') ifTrue: [ ^ TypeXSString instance ].
"/    (typeName = 'xs:normalizedString') ifTrue: [ ^ TypeXSNormalizedString instance ].
"/    (typeName = 'xs:token') ifTrue: [ ^ TypeXSToken instance ].
"/    (typeName = 'xs:Name') ifTrue: [ ^ TypeXSName instance ].
"/    (typeName = 'xs:NCName') ifTrue: [ ^ TypeXSNCName instance ].
"/    (typeName = 'xs:decimal') ifTrue: [ ^ TypeXSDecimal instance ].
"/    (typeName = 'xs:integer') ifTrue: [ ^ TypeXSInteger instance ].
"/    (typeName = 'xs:float') ifTrue: [ ^ TypeXSFloat instance ].
"/    (typeName = 'xs:double') ifTrue: [ ^ TypeXSDouble instance ].
"/    (typeName = 'xs:boolean') ifTrue: [ ^ TypeXSBoolean instance ].
"/    (typeName = 'xs:untyped') ifTrue: [ ^ TypeXSUntyped instance ].
"/    (typeName = 'xs:anyURI') ifTrue: [ ^ TypeXSAnyURI instance ].

"/    ^ TypeItem instance.
"/    ^ self shouldNeverBeReached.

    "Created: / 01-11-2009 / 17:51:02 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-11-2009 / 22:31:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primitiveTypeFor: type
    " return the parent which is primitive type "
    | primType |

    primType := type.


    [ primType isPrimitive ] whileFalse:
    [
        primType := self supertypeOf: primType.
    ].

    ^ primType.

    "Created: / 18-11-2009 / 00:52:54 / Jan Kurs <kursj1@fel.cvut.cz>"
!

subtypesOf: type
    | typeEntry subtypes |
    self assert: type isXMLType.

    typeEntry := self typeHierarchy getType: type.
    subtypes := OrderedCollection with: type value.

    typeEntry children do: [ :item |
        subtypes addAll: (self subtypesOf: item value).
    ].

    ^ subtypes.

    "Created: / 05-11-2009 / 22:40:54 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 08-11-2009 / 14:45:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

supertypeOf: type
    self assert: type isXMLType.

    ^ (self typeHierarchy getType: type) parent value.

    "Created: / 05-11-2009 / 23:08:39 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 08-11-2009 / 14:44:46 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeFactory class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
