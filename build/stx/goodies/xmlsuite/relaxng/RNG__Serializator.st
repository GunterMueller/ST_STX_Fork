"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#Serializator
	instanceVariableNames:'schema currentNode objects rootObject idMapping'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Serialization'
!


!Serializator class methodsFor:'instance creation'!

for:aSchema

    ^self new schema:aSchema

    "Created: / 29-04-2005 / 10:10:48 / janfrog"
! !

!Serializator methodsFor:'accessing'!

idMapping
    ^ idMapping

    "Created: / 26-05-2005 / 13:28:25 / masca"
!

popObject

    ^objects pop

    "Created: / 29-04-2005 / 10:09:27 / janfrog"
!

pushObject: anObject

    ^objects push: anObject

    "Created: / 29-04-2005 / 10:09:27 / janfrog"
!

schema
    ^ schema

    "Created: / 29-04-2005 / 10:08:28 / janfrog"
!

schema:aSchema
    schema := aSchema.

    "Created: / 29-04-2005 / 10:08:28 / janfrog"
!

topObject

    ^objects top

    "Created: / 29-04-2005 / 10:09:27 / janfrog"
! !

!Serializator methodsFor:'experiments'!

visitCollectionNode: collectionNode

    collectionNode hasBinding ifTrue: [ |object |
        object := self topObjectUsing: collectionNode bindingInfo.
        (collectionNode pattern isValidObject: object)
            ifFalse: [^SerializationError raiseErrorString: 'Invalid class'].
        collectionNode bindingInfo
            serializeContent: [:o |
                self pushObject: o.
                o acceptVisitor: self.
                self popObject.
                currentNode := currentNode parent]
            with: object
    ].

    "Created: / 25-08-2005 / 14:25:47 / masca"
! !

!Serializator methodsFor:'private'!

addElementNode: nameString namespace: nsString

    | element |
    element := XML::Element tag: (XML::NodeTag new qualifier: '' ns: nsString type: nameString).
    currentNode addNode: element.
    currentNode := element.
    ^element

    "Created: / 29-04-2005 / 16:16:39 / janfrog"
!

addText: aString

    aString isString ifFalse:[self halt].

    ^currentNode addNode: (self textNodeFromString: aString)

    "Created: / 02-05-2005 / 16:31:13 / janfrog"
    "Modified: / 16-05-2005 / 13:57:05 / masca"
!

checkKeyData: aPattern

    | key dataType |
    aPattern isForAttribute ifFalse:[^nil].
    dataType := aPattern pcDataContentPattern dataType.

    (dataType isKey and: [(idMapping includesKey: self topObject) not])
        ifTrue: [
            key := aPattern hasBinding
                ifTrue: [self topObjectUsing: aPattern bindingInfo]
                ifFalse: [currentNode tag type , self topObject identityHash printString].
            idMapping at: self topObject put: key.
            ^key]
        ifFalse: [
            dataType isKeyRef
                ifTrue: [
                    key := idMapping
                        at: self topObject
                        ifAbsent: [SerializationError raiseErrorString: 'Cannot find key for reference'].
                    currentNode
                        attributes: OrderedCollection new;
                        elements: #().
                    ^key
                ]
            ].
    ^nil

    "Created: / 29-04-2005 / 15:50:49 / janfrog"
    "Modified: / 02-05-2005 / 18:04:54 / janfrog"
    "Modified: / 16-05-2005 / 11:50:53 / masca"
!

recoverState: anArray

    | keptObjects |
    keptObjects := anArray at: 1.
    objects size > keptObjects ifTrue: [objects removeLast: (objects size - keptObjects)].

    currentNode := anArray at: 2.
    currentNode attributes: (anArray at: 3) copy.
    currentNode elements: (anArray at: 4) copy

    "Created: / 29-04-2005 / 13:45:26 / janfrog"
!

saveState

    ^Array
        with: objects size
        with: currentNode
        with: currentNode attributes copy asOrderedCollection
        with: currentNode elements copy asOrderedCollection

    "Created: / 29-04-2005 / 13:42:57 / janfrog"
!

textNodeFromString: aString

    ^XML::Text text: aString

    "Created: / 02-05-2005 / 16:31:56 / janfrog"
! !

!Serializator methodsFor:'processing'!

topObjectAt: aString

    | obj |
    aString ifNil:[SerializationError raiseErrorString:
                        'Instvar name is nil...'].
    obj := self hasTopObject
        ifTrue: [
            [
                self topObject instVarNamed: aString
            ] on:NonIntegerIndexError do:[
                SerializationError raiseErrorString:
                    self topObject printString 
                        , ' ( instance of ',self topObject class name , ')'
                            ,' has no instvar named ',aString
            ]
        ]
        ifFalse:[rootObject].
    obj
        ifNil:[SerializationError raiseErrorString:'nil value in instvar named ',aString
                , ' in object ', self topObject printString. ^self].
    ^obj

    "Modified: / 29-04-2005 / 11:01:26 / janfrog"
    "Modified: / 16-05-2005 / 15:45:53 / masca"
!

topObjectUsing: aBindingInfo

    self hasTopObject ifFalse:[^rootObject].

    ^aBindingInfo hasConverters
        ifTrue:[
            | topObject |
            topObject := self hasTopObject ifTrue:[self topObject] ifFalse:[rootObject].
            topObject 
                perform:aBindingInfo readConverter
                ifNotUnderstood:[
                    SerializationError raiseErrorString:'Failed to retrieve data by readConverter'
                ]                
        ] ifFalse:[
            self topObjectAt:aBindingInfo name
        ]

    "Modified: / 29-04-2005 / 11:01:26 / janfrog"
    "Created: / 16-05-2005 / 11:50:37 / masca"
    "Modified: / 25-08-2005 / 16:59:55 / masca"
! !

!Serializator methodsFor:'serialization'!

serialize: anObject

    objects := Stack new.
    currentNode := XML::Document new.
    rootObject := anObject.
    idMapping := IdentityDictionary new.

    self visitElement: schema rootPattern node firstChild pattern.

    currentNode isDocument ifFalse: [SerializationError raiseErrorString: 'Improper nesting (bug in serialization code)'].
    ^currentNode

    "Created: / 29-04-2005 / 10:14:19 / janfrog"
    "Modified: / 02-05-2005 / 17:04:52 / janfrog"
!

serialize: anObject using: aSchema

    schema := aSchema.
    ^self serialize: anObject

    "Created: / 29-04-2005 / 10:18:27 / janfrog"
    "Modified: / 29-04-2005 / 11:34:32 / janfrog"
! !

!Serializator methodsFor:'support'!

visitAttribute: aPattern

    | attribute object |

    attribute := XML::Attribute new tag:
        (XML::NodeTag new qualifier: '' ns: aPattern namespace type: aPattern localName).
    aPattern hasBinding
        ifTrue: [
            object := self topObjectUsing: aPattern bindingInfo.
            object ifNil:[
                ^SerializationError raiseErrorString:'Bound attribute is nil'.
            ].
            attribute value: (aPattern node firstChild pattern charactersFromObject: object)]
        ifFalse: [
            attribute value: (self checkKeyData: aPattern)
        ].

    attribute value
        ifNil: [
            SerializationError raiseErrorString: 'Unknown attribute for serialization']
        ifNotNil: [
            | atts |
            atts := currentNode attributes.
            atts isEmpty ifTrue:[currentNode attributes:(atts := XMLv2::Attributes new)].
            atts add:attribute
        ].

    "Created: / 29-04-2005 / 10:48:55 / janfrog"
    "Modified: / 02-05-2005 / 17:09:57 / janfrog"
    "Modified: / 16-05-2005 / 13:49:07 / masca"
!

visitData: aPattern

    | binding |
    binding := aPattern bindingInfo hasBinding 
                ifTrue:[aPattern bindingInfo]
                ifFalse:[aPattern node parent pattern  bindingInfo].
    binding hasBinding 
        ifFalse:[^SerializationError raiseErrorString: 'Invalid data binding'].
    self topObject 
        ifNil:[^SerializationError raiseErrorString: 'No data'].

    self addText: (aPattern charactersFromObject: self topObject)

    "Created: / 29-04-2005 / 11:31:04 / janfrog"
    "Modified: / 02-05-2005 / 17:06:42 / janfrog"
    "Modified: / 16-05-2005 / 13:55:26 / masca"
!

visitElement: aPattern

    | object |

    aPattern hasBinding ifFalse: [
        self addElementNode: aPattern localName namespace: aPattern namespace.

        (self checkKeyData: aPattern)
            ifNil: [aPattern node childrenDo: [:e | e acceptVisitor: self]].
        currentNode := currentNode parent.
        ^self
    ].

    object := self topObjectUsing: aPattern bindingInfo.
    (aPattern isValidObject: object)
        ifFalse: [^SerializationError raiseErrorString: 'Invalid class'].
    "(aPattern hasComplexContentModel and:[(object isKindOf: aPattern bindingInfo instanceVariableClass) not])    
        ifTrue: [^SerializationError raiseErrorString: 'Invalid class']."

    aPattern bindingInfo
        serializeContent: [:o |
            self addElementNode: aPattern localName namespace: aPattern namespace.
            self pushObject: o.
            aPattern node childrenDo: [:e | e acceptVisitor: self].
            self popObject.
            currentNode := currentNode parent]
        with: object

    "Created: / 29-04-2005 / 10:17:15 / janfrog"
    "Modified: / 02-05-2005 / 17:06:04 / janfrog"
    "Modified: / 25-08-2005 / 14:17:28 / masca"
! !

!Serializator methodsFor:'testing'!

hasTopObject

    ^objects isEmpty not

    "Created: / 29-04-2005 / 10:12:26 / janfrog"
! !

!Serializator methodsFor:'visiting'!

visitChoiceNode: aChoiceNode

    | state errors |
    state := self saveState.
    errors := Set new.

    aChoiceNode children do: [:e |
        [
            e acceptVisitor: self.
            ^self
        ]
            on: SerializationError
            do: [:ex | errors add:ex errorString. ex return].
        self recoverState: state
    ].

    SerializationError raiseErrorString: 
        (errors inject:'No choice matches: ' into:[:msg :errMsg| msg , '[',errMsg,']'])

    "Created: / 02-05-2005 / 16:46:12 / janfrog"
    "Modified: / 08-06-2005 / 14:16:01 / masca"
!

visitEmptyNode: anEmptyNode

    ^self

    "Created: / 02-05-2005 / 16:49:51 / janfrog"
!

visitGroupNode: aGroupNode

    aGroupNode children do: [:e |
        e acceptVisitor: self
    ]

    "Created: / 02-05-2005 / 16:45:56 / janfrog"
!

visitOneOrMoreNode: aOneOrMoreNode

    "self topObject isEmpty ifTrue: [SerializationError raiseErrorString: 'Need at least one item in collection']."
    self visitGroupNode: aOneOrMoreNode

    "Created: / 02-05-2005 / 16:45:37 / janfrog"
!

visitOptionalNode: anOptionalNode

    | state |
    state := self saveState.

    [
        anOptionalNode children do: [:e | e acceptVisitor: self].
        ^self
    ]
        on: SerializationError
        do: [:ex |
            self recoverState: state.
            ex return]

    "Created: / 02-05-2005 / 16:45:24 / janfrog"
!

visitPatternNode: aPatternNode

    | pattern |
    pattern := aPatternNode pattern.

    pattern isPCDataPattern ifTrue: [^self visitData: pattern].
    pattern isForElement ifTrue: [^self visitElement: pattern].
    pattern isForAttribute ifTrue: [^self visitAttribute: pattern].

    SerializationError raiseErrorString: 'Unknown pattern type'

    "Created: / 02-05-2005 / 16:42:11 / janfrog"
!

visitZeroOrMoreNode: aZeroOrMoreNode

    | state |
    state := self saveState.

    [
        self visitGroupNode: aZeroOrMoreNode.
        ^self
    ]
        on: SerializationError
        do: [:ex |
            self recoverState: state.
            ex return]

    "Created: / 02-05-2005 / 16:45:55 / janfrog"
    "Modified: / 25-08-2005 / 14:36:59 / masca"
! !

!Serializator class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__Serializator.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
