"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#AtomicItem
	instanceVariableNames:'nodeId typeName'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!AtomicItem class methodsFor:'instance creation'!

withBoolean: boolean
    ^ self withValue: boolean asType: 'xs:boolean'.

    "Created: / 21-03-2007 / 14:24:49 / janfrog"
    "Modified: / 05-12-2007 / 15:58:58 / janfrog"
    "Modified: / 05-10-2009 / 14:16:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withNumber: number
"/    ^ self withValue: number asType: 'xs:decimal'.
    ^ (self withValue: number) asGuessedType.

    "Created: / 21-03-2007 / 14:24:29 / janfrog"
    "Modified: / 05-12-2007 / 15:21:08 / janfrog"
    "Modified: / 05-10-2009 / 19:51:51 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withString: string
    ^ self withValue: string asType: 'xs:string'.

    "Created: / 21-03-2007 / 15:45:27 / janfrog"
    "Modified: / 05-12-2007 / 15:59:08 / janfrog"
    "Modified: / 05-10-2009 / 14:16:38 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withValue: value

    ^ self createConstructedItem: value valueType: 'xs:untypedAtomic'.

    "Created: / 05-10-2009 / 14:16:05 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withValue: value asType: type
    ^ self createConstructedItem: value valueType: type.

    "Created: / 05-10-2009 / 14:16:21 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AtomicItem class methodsFor:'private'!

createConstructedItem: value valueType:valueType 
    ^ self new
        nodeId: value;
        typeName: valueType;
        yourself.

    "Created: / 05-10-2009 / 14:31:28 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AtomicItem methodsFor:'accessing'!

nodeId
    ^ nodeId
!

nodeId:something
    nodeId := something.
!

typeName
    ^ typeName
!

typeName:something
    typeName := something.
! !

!AtomicItem methodsFor:'atomic type'!

type
    ^ self typeName

    "Created: / 05-10-2009 / 18:35:19 / Jan Kurs <kursj1@fel.cvut.cz>"
!

value
    ^ nodeId

    "Created: / 05-10-2009 / 14:26:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

value: aValue
    self nodeId: aValue

    "Created: / 21-11-2009 / 20:02:20 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AtomicItem methodsFor:'atomic value operations'!

* anObject
    self halt: 'deprecated??'.

    (anObject class = self class) ifTrue: [
        ^ self nodeId * anObject nodeId.
    ] ifFalse: [
        ^ self nodeId * anObject.
    ]

    "Created: / 05-10-2009 / 15:25:54 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 09-11-2009 / 16:50:47 / Jan Kurs <kursj1@fel.cvut.cz>"
!

+ anObject 
    self halt: 'deprecated??'.
    (anObject class = self class) ifTrue: [
        ^ self nodeId + anObject nodeId.
    ] ifFalse: [
        ^ self nodeId + anObject.
    ]

    "Created: / 05-10-2009 / 15:25:54 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 09-11-2009 / 16:47:14 / Jan Kurs <kursj1@fel.cvut.cz>"
!

- anObject 
    self halt: 'deprecated??'.

    (anObject class = self class) ifTrue: [
        ^ self nodeId - anObject nodeId.
    ] ifFalse: [
        ^ self nodeId - anObject.
    ]

    "Created: / 05-10-2009 / 15:25:54 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 09-11-2009 / 16:50:53 / Jan Kurs <kursj1@fel.cvut.cz>"
!

/ anObject 
    self halt: 'deprecated??'.

    (anObject class = self class) ifTrue: [
        ^ self nodeId / anObject nodeId.
    ] ifFalse: [
        ^ self nodeId / anObject.
    ]

    "Created: / 05-10-2009 / 15:25:54 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 09-11-2009 / 16:50:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

// anObject 
    (anObject class = self class) ifTrue: [
        ^ self nodeId // anObject nodeId.
    ] ifFalse: [
        ^ self nodeId // anObject.
    ]

    "Created: / 05-10-2009 / 15:50:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

< anObject 
    (anObject class = self class) ifTrue: [
        ^ self nodeId < anObject nodeId.
    ] ifFalse: [
        ^ self nodeId < anObject.
    ]

    "Created: / 05-10-2009 / 15:25:54 / Jan Kurs <kursj1@fel.cvut.cz>"
!

<= anObject 
    (anObject class = self class) ifTrue: [
        ^ self nodeId <= anObject nodeId.
    ] ifFalse: [
        ^ self nodeId <= anObject.
    ]

    "Created: / 05-10-2009 / 15:25:54 / Jan Kurs <kursj1@fel.cvut.cz>"
!

= anObject 
    (anObject class = self class) ifTrue: [
        ^ self nodeId = anObject nodeId.
    ] ifFalse: [
        ^ self nodeId = anObject.
    ]

    "Created: / 05-10-2009 / 15:25:54 / Jan Kurs <kursj1@fel.cvut.cz>"
!

> anObject 
    (anObject class = self class) ifTrue: [
        ^ self nodeId > anObject nodeId.
    ] ifFalse: [
        ^ self nodeId > anObject.
    ]

    "Created: / 05-10-2009 / 15:25:54 / Jan Kurs <kursj1@fel.cvut.cz>"
!

>= anObject 
    (anObject class = self class) ifTrue: [
        ^ self nodeId >= anObject nodeId.
    ] ifFalse: [
        ^ self nodeId >= anObject.
    ]

    "Created: / 05-10-2009 / 15:25:54 / Jan Kurs <kursj1@fel.cvut.cz>"
!

\\ anObject 
    (anObject class = self class) ifTrue: [
        ^ self nodeId \\ anObject nodeId.
    ] ifFalse: [
        ^ self nodeId \\ anObject.
    ]

    "Created: / 05-10-2009 / 16:05:05 / Jan Kurs <kursj1@fel.cvut.cz>"
!

~= anObject 
    (anObject class = self class) ifTrue: [
        ^ self nodeId ~= anObject nodeId.
    ] ifFalse: [
        ^ self nodeId ~= anObject.
    ]

    "Created: / 05-10-2009 / 14:01:58 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:36:04 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AtomicItem methodsFor:'casting'!

castAs: anotherTypeName
    ^ CastingRules new cast: self to: anotherTypeName.

    "Created: / 05-10-2009 / 17:28:26 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-11-2009 / 22:43:38 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AtomicItem methodsFor:'converting'!

asDocumentFragment

    | domBuilder |
    domBuilder := XMLv2::DOM3Builder new.
    XQueryResultXMLReader new
            setContentHandler: domBuilder;
            visit: self.
    ^domBuilder document

    "Modified: / 07-06-2009 / 21:26:33 / Jan Kurs <kursj1@fel.cvut.cz>"
!

asGuessedType
    self messageNotUnderstoodSignal
    handle:[:ex |
        ^ self castAs: 'xs:untypedAtomic'.
    ]
    do:[
    
        self nodeId isString ifTrue: [ ^ self castAs: 'xs:string'].

        self nodeId isNumber ifTrue: [ 
            self nodeId isInteger ifTrue: [
                ^ self castAs: 'xs:integer'
            ].
            ^ self castAs: 'xs:float'
        ].

        ^ self castAs: 'xs:untypedAtomic'.
    ].

    "Created: / 05-10-2009 / 18:58:09 / Jan Kurs <kursj1@fel.cvut.cz>"
!

asNumber

    ^ self nodeId asNumber.

    "Created: / 05-10-2009 / 14:41:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

asString

    ^ self stringValue

    "Created: / 05-10-2009 / 15:29:35 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 20:09:31 / Jan Kurs <kursj1@fel.cvut.cz>"
!

atomizedValue
    ^ self

    "Created: / 05-10-2009 / 15:57:18 / Jan Kurs <kursj1@fel.cvut.cz>"
!

doesNotUnderstand: aMessage
    " just forward the message"
    ^ aMessage sendTo: (self nodeId).

    "Created: / 05-10-2009 / 14:55:14 / Jan Kurs <kursj1@fel.cvut.cz>"
!

stringValue
    | datatype |
    datatype := TypeFactory getType: self type.
    ^ datatype toCanonicalLexicalForm: (self nodeId).

"/    (nodeId class isSubclassOf: Number) ifTrue: [ ^ nodeId storeString].
"/
"/    ^ nodeId asString

    "Created: / 05-10-2009 / 14:37:45 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 20:10:02 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AtomicItem methodsFor:'error reporting'!

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

!AtomicItem methodsFor:'item changing - appending'!

appendInto:parentElement 
    parentElement appendAtomicValue: self.

    "Created: / 05-10-2009 / 16:10:56 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AtomicItem methodsFor:'printing'!

printOn:aStream 
    self value printOn: aStream.
    aStream nextPut:$[.
    self type printOn:aStream.
    aStream nextPut:$].
    aStream nextPut:$ .
    aStream nextPut:$-.
    aStream nextPut:$ .
    super printOn:aStream.

    "Created: / 14-02-2007 / 00:03:56 / janfrog"
    "Modified: / 05-10-2009 / 19:36:23 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AtomicItem methodsFor:'testing'!

isAtomicValue
    ^ true

    "Created: / 05-10-2009 / 14:11:14 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isNode
    ^ false

    "Created: / 05-10-2009 / 14:11:09 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isSequenceItem
    ^ true

    "Created: / 05-10-2009 / 14:11:01 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isSubtypeOf: anotherTypeName
    ^ TypeFactory isType: self typeName subtypeOf: anotherTypeName.

    "Created: / 05-10-2009 / 14:11:35 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-11-2009 / 23:50:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isSubtypeOf: anotherTypeName or: anotherTypeName2
    ^ (TypeFactory isType: self typeName subtypeOf: anotherTypeName)
      or: [(TypeFactory isType: self typeName subtypeOf: anotherTypeName2)]

    "Created: / 15-10-2009 / 15:59:56 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isSubtypeOf: anotherTypeName or: anotherTypeName2 or: anotherTypeName3
    ^ (TypeFactory isType: self typeName subtypeOf: anotherTypeName)
      or: [(TypeFactory isType: self typeName subtypeOf: anotherTypeName2)]
      or: [(TypeFactory isType: self typeName subtypeOf: anotherTypeName3)]

    "Created: / 15-10-2009 / 16:00:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isType: anotherTypeName
    ^ self typeName = anotherTypeName.

    "Created: / 05-10-2009 / 17:24:50 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AtomicItem class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
