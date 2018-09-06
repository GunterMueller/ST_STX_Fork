"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Validator subclass:#Binder
	instanceVariableNames:'objectsStack product pendingMapping idMapping characterObject'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Binding'
!


!Binder methodsFor:'SAX2 interface'!

endDocument

    "Created: / 02-05-2005 / 17:03:42 / janfrog"
!

endElement: localName namespace: qName prefix: namespace

    | context |
    context := contextStack top.
    super endElement: localName namespace: qName prefix: namespace.
    context pattern bindingInfo endElementIn: self

    "Created: / 02-05-2005 / 15:40:26 / janfrog"
    "Modified: / 14-06-2005 / 10:32:15 / masca"
!

processAttribute:attr usingPattern:pattern 
    |dataType contentPattern|

    contextStack push:(self newContextFor:pattern).
    contextStack top nextPutText:attr value.
    characterObject := contextStack top currentPattern 
                objectFromCharacters:attr value.
    contentPattern := pattern pcDataContentPattern.
    contentPattern isListPattern ifFalse:[
        dataType := contentPattern dataType.
        dataType isKeyRef ifTrue:[
            objectsStack pop.
            objectsStack push:(idMapping at:attr value
                        ifAbsent:[
                            BindingError raiseErrorString:'Forward references unsupported (yet)'
                        ]).
        ].
        dataType isKey ifTrue:[
            self mapId:attr value toObject:self topObject
        ].
    ].
    (contextStack top pattern bindingInfo)
            startElementIn:self;
            endElementIn:self.

    "This should help parsing empty string elements. See getAndEraseCharacterObject for
    details on this issue."
    characterObject := nil.

    contextStack pop.

    "Created: / 02-05-2005 / 15:44:22 / janfrog"
    "Modified: / 02-05-2005 / 17:44:56 / janfrog"
    "Modified: / 06-06-2005 / 14:13:58 / masca"
!

startDocument

    objectsStack := Stack new.
    idMapping := Dictionary new.
    pendingMapping := Dictionary new.

    super startDocument

    "Modified: / 02-05-2005 / 15:16:19 / janfrog"
!

startElement:localName namespace:namespace prefix:qName attributes:anAttributes

    super startElement:localName namespace:namespace prefix:qName attributes:anAttributes.
    contextStack top pattern bindingInfo startElementIn: self

     "/   self pushObject: bindingInfo ivClass new
     "/   nic - pockat na content (je to primitivni typ)
     "/   nic - pockat na content (ma creator z contentu)
     "/   nic - nema binding

    "Created: / 02-05-2005 / 15:23:14 / janfrog"
! !

!Binder methodsFor:'accessing'!

characterObject
    ^ characterObject

    "Created: / 02-05-2005 / 16:00:06 / janfrog"
!

getAndEraseCharacterObject
    "Answer the object that has been created from character data."
    "Answering an empty string when the character object is nil may be considered a dirty hack.
    This situation should only appear when <element></element> encountered, which should be really
    interpreted as an empty string (the character data inside).
    Maybe future will show us this is not the way..."

    | object |
    object := characterObject.
    characterObject := nil.
    ^object ifNil: [String new]

    "Created: / 19-05-2005 / 11:16:13 / masca"
    "Modified: / 06-06-2005 / 14:15:20 / masca"
!

newContextFor:aPattern

    ^aPattern newBinderContext
        validator:self;
        yourself

    "Created: / 02-05-2005 / 14:55:15 / janfrog"
!

popObject

    ^objectsStack pop

    "Created: / 02-05-2005 / 15:13:33 / janfrog"
!

pushObject: anObject

    ^objectsStack push: anObject

    "Created: / 02-05-2005 / 15:13:33 / janfrog"
!

result
    "Answers root object of bound structure"

    pendingMapping isEmpty ifFalse: [ValidationError raiseErrorString: 'Unresolved id mappings'].
    ^product

    "Created: / 02-05-2005 / 14:57:30 / janfrog"
!

topObject

    ^objectsStack top

    "Created: / 02-05-2005 / 15:13:33 / janfrog"
! !

!Binder methodsFor:'mapping'!

inTopObjectAt: aString addObjectAt: id usingCollectionClass: collectionClass
    "See inTopObjectAt:putObjectAt:, this is for collections."

    | object |
    object := idMapping at: id ifAbsent: [nil].
    object
        ifNil: [ | collection |
            collection := pendingMapping at: id ifAbsentPut: OrderedCollection new.
            collection add: [:anObject | self inTopObjectAt: aString add: anObject usingCollectionClass: collectionClass]]
        ifNotNil: [self inTopObjectAt: aString add: object usingCollectionClass: collectionClass]

    "Created: / 02-05-2005 / 15:13:33 / janfrog"
    "Modified: / 02-05-2005 / 17:29:18 / janfrog"
!

inTopObjectAt: aString putObjectAt: id
    "Call when IDREF is found. Will resolve the id and store it in topObject or
    schedule the store after the ID will be resolved."

    | object |
    object := idMapping at: id ifAbsent: [nil].
    object
        ifNil: [ | collection |
            collection := pendingMapping at: id ifAbsentPut: OrderedCollection new.
            collection add: [:anObject | self inTopObjectAt: aString put: anObject]]
        ifNotNil: [self inTopObjectAt: aString put: object]

    "Created: / 02-05-2005 / 15:13:33 / janfrog"
    "Modified: / 02-05-2005 / 17:28:53 / janfrog"
!

mapId: aString toObject: anObject
    "Call when ID is found. Will allow future (and past) IDREFs to identically
    point to anObject."

    | pending |
    idMapping at: aString put: anObject.

    pending := pendingMapping at: aString ifAbsent: [^self].
    pending do: [:e | e value: anObject].
    pendingMapping removeKey: aString

    "Created: / 02-05-2005 / 15:13:33 / janfrog"
    "Modified: / 02-05-2005 / 17:28:03 / janfrog"
! !

!Binder methodsFor:'processing'!

inTopObjectAt:aString add:anObject usingCollectionClass: collectionClass 

    | target index |

    self hasTopObject ifFalse:[
        self error:'Root element cannot be a collection'
    ].

    target := self topObject.
    index := target class instVarOffsetOf:aString.
    (target instVarAt:index) 
        ifNil:[ target instVarAt:index put:(collectionClass with:anObject)]
        ifNotNil:[ (target instVarAt:index) add:anObject ]

    "Created: / 02-05-2005 / 15:13:33 / janfrog"
!

inTopObjectAt: aString put: anObject

    self hasTopObject ifFalse: [
        product := anObject.
        ^self].
    [
        self topObject instVarNamed: aString put: anObject
    ] on:Error do:[:ex|
        BindingError raiseErrorString:'Are you sure that ',self topObject printString
            , ' (instance of ',self topObject class name, ')'
                , 'has instvar named ',aString,'?'
    ]

    "Created: / 02-05-2005 / 15:13:33 / janfrog"
    "Modified: / 08-06-2005 / 12:43:39 / masca"
!

inTopObjectPut: anObject usingSelector:selector

    self hasTopObject ifFalse: [
        product := anObject.
        ^self].

    self topObject 
        perform:selector with: anObject

    "Created: / 16-05-2005 / 11:59:03 / masca"
!

processCharacters:aString 
    super processCharacters:aString.
    characterObject := contextStack top currentPattern 
                objectFromCharacters:aString.
    contextStack top currentPattern bindingInfo charactersIn:self.

    "Created: / 07-06-2005 / 15:30:01 / masca"
!

putTopObjectAt: aString in: anObject

    self hasTopObject ifFalse: [^self].
    anObject instVarNamed: aString put: self topObject

    "Created: / 13-05-2005 / 13:29:53 / masca"
! !

!Binder methodsFor:'testing'!

hasTopObject

    ^objectsStack isEmpty not

    "Created: / 02-05-2005 / 15:13:33 / janfrog"
! !

!Binder class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__Binder.st,v 1.1.1.1 2005-11-01 22:07:11 vranyj1 Exp $'
! !
