"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#BindingInfo
	instanceVariableNames:'name type parent className creator readConverter writeConverter'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Binding'
!


!BindingInfo methodsFor:'accessing'!

instanceVariableClass

    type = 'Set' ifTrue:[^Set].
    type = 'OrderedCollection' ifTrue:[^OrderedCollection].
    type = 'Dictionary' ifTrue:[^Dictionary].

    ^self objectClass

    "Created: / 16-05-2005 / 16:38:06 / masca"
!

readConverter
    ^ readConverter

    "Created: / 16-05-2005 / 11:36:21 / masca"
!

readConverter:aStringOrSymbol 

    aStringOrSymbol ifNotNil:[
        readConverter := aStringOrSymbol asSymbol
    ]

    "Created: / 16-05-2005 / 11:36:21 / masca"
!

writeConverter
    ^ writeConverter

    "Created: / 16-05-2005 / 11:36:21 / masca"
!

writeConverter:aStringOrSymbol

    aStringOrSymbol ifNotNil:[
        writeConverter := aStringOrSymbol asSymbol
    ]

    "Created: / 16-05-2005 / 11:36:21 / masca"
! !

!BindingInfo methodsFor:'initialization'!

initializeFromAttributes:attributes

    | uri |
    uri := SchemaParser bindingNamespace.

    name := attributes getValueByURI:uri localName:'iv'.
    className := attributes getValueByURI: uri localName: 'class'.
    type := attributes getValueByURI:uri localName:'type'.
    parent := attributes getValueByURI:uri localName:'parent'.
    readConverter := attributes getValueByURI:uri localName:'readConverter'.
    readConverter ifNotNil:[readConverter := readConverter asSymbol].
    writeConverter := attributes getValueByURI:uri localName:'writeConverter'.
    writeConverter ifNotNil:[writeConverter := writeConverter asSymbol].

    "Created: / 02-05-2005 / 13:17:12 / janfrog"
    "Modified: / 02-05-2005 / 16:35:29 / janfrog"
    "Modified: / 07-06-2005 / 15:46:57 / masca"
! !

!BindingInfo methodsFor:'merging'!

mergeWith:anotherInfo

    ^self class new
        name:(self name ? anotherInfo name);
        type:(self type ? anotherInfo type);
        parent:(self parent ? anotherInfo parent);
        className:(self className ? anotherInfo className);
        creator:(self creator ? anotherInfo creator);
        readConverter:(self readConverter ? anotherInfo readConverter);
        writeConverter:(self writeConverter ? anotherInfo writeConverter);
        yourself.

    "Created: / 12-05-2005 / 17:05:19 / masca"
    "Modified: / 16-05-2005 / 11:36:16 / masca"
! !

!BindingInfo methodsFor:'printing'!

printOn:aStream

    aStream 
        nextPutAll:'Binding info' ; cr;
        nextPutAll:'name ' ; nextPutAll: name printString ; cr;
        nextPutAll:'type ' ; nextPutAll: type printString ; cr;
        nextPutAll:'parent ' ; nextPutAll: parent printString ; cr;
        nextPutAll:'className ' ; nextPutAll: className printString ; cr;
        nextPutAll:'creator ' ; nextPutAll: creator printString

    "Created: / 13-05-2005 / 14:41:45 / masca"
! !

!BindingInfo methodsFor:'private'!

className
    ^ className

    "Created: / 12-05-2005 / 17:05:24 / masca"
!

className:something
    className := something.

    "Created: / 12-05-2005 / 17:04:29 / masca"
!

createdInstanceFrom: anObject
    "Create an instance of a class from aString, using creator."

    | selector ivClass |
    selector := creator asSymbolIfInterned.
    ivClass := self objectClass.

    (selector isNil or: [ivClass isNil or: [(ivClass respondsTo: selector) not]])
        ifTrue: [BindingError raiseErrorString: 'Invalid creator binding'].

    ^ivClass perform: selector with: anObject

    "Created: / 02-05-2005 / 15:54:01 / janfrog"
!

creator
    ^ creator

    "Created: / 12-05-2005 / 17:05:24 / masca"
!

creator:something
    creator := something.

    "Created: / 12-05-2005 / 17:04:29 / masca"
!

name
    ^ name

    "Created: / 02-05-2005 / 17:05:47 / janfrog"
!

name:something
    name := something.

    "Created: / 12-05-2005 / 17:04:29 / masca"
!

objectClass
    "Answers class or nil, if no class specified"
    
    ^ className ifNotNil:[ Smalltalk at:(className asSymbolIfInterned) ]

    "Created: / 02-05-2005 / 15:38:10 / janfrog"
!

parent
    ^ parent

    "Created: / 12-05-2005 / 17:05:24 / masca"
!

parent:something
    parent := something.

    "Created: / 12-05-2005 / 17:04:29 / masca"
!

storeObject:anObject in:aBinder

    self hasConverters 
        ifTrue:[^aBinder inTopObjectPut:anObject usingSelector:self writeConverter].

    type = 'Set' 
        ifTrue:[^aBinder inTopObjectAt:name add:anObject usingCollectionClass:Set].
    type = 'OrderedCollection' 
        ifTrue:[^aBinder inTopObjectAt:name add:anObject usingCollectionClass:OrderedCollection].

    type = 'Dictionary' 
        ifTrue:[^aBinder inTopObjectAt:name add:anObject usingCollectionClass:Dictionary].

    aBinder inTopObjectAt:name put:anObject

    "Created: / 02-05-2005 / 15:50:23 / janfrog"
    "Modified: / 07-06-2005 / 16:00:05 / masca"
!

type
    ^ type

    "Created: / 12-05-2005 / 17:05:24 / masca"
!

type:something
    type := something.

    "Created: / 12-05-2005 / 17:04:29 / masca"
! !

!BindingInfo methodsFor:'processing'!

charactersIn: aBinder

    | object |
    self hasPrimitiveContent ifTrue: [
        object := aBinder getAndEraseCharacterObject.
        self storeObject: object in: aBinder
    ]

    "Created: / 14-05-2005 / 22:32:13 / janfrog"
    "Modified: / 19-05-2005 / 11:16:22 / masca"
!

endElementIn: aBinder

    | object |
    self hasBinding ifFalse: [^self].
    self hasComplexContent ifTrue: [object := aBinder popObject].
    self hasPrimitiveContent ifTrue: [object := aBinder getAndEraseCharacterObject].
    self hasCreatorContent ifTrue: [object := self createdInstanceFrom: aBinder getAndEraseCharacterObject].

    object ifNil: [^self].
    self hasParentVariable ifTrue: [aBinder putTopObjectAt: parent in: object].
    self storeObject: object in: aBinder

    "Created: / 02-05-2005 / 15:40:42 / janfrog"
    "Modified: / 19-05-2005 / 11:16:43 / masca"
!

startElementIn: aBinder

    self hasComplexContent ifTrue: [aBinder pushObject: self objectClass new]

    "Created: / 02-05-2005 / 15:38:18 / janfrog"
! !

!BindingInfo methodsFor:'queries'!

hasBinding

    ^name notNil 
        or: [className notNil
                or:[self hasConverters]]

    "Created: / 02-05-2005 / 15:46:53 / janfrog"
    "Modified: / 16-05-2005 / 11:42:29 / masca"
!

hasComplexContent

    ^className notNil and: [creator isNil]

    "Created: / 02-05-2005 / 15:32:06 / janfrog"
!

hasConverters
    ^ readConverter notNil and:[ writeConverter notNil ]

    "Created: / 16-05-2005 / 11:42:39 / masca"
    "Modified: / 16-05-2005 / 15:12:17 / masca"
!

hasCreatorContent

    ^name notNil and:[creator notNil]

    "Created: / 02-05-2005 / 15:34:31 / janfrog"
!

hasParentVariable

    ^parent notNil

    "Created: / 13-05-2005 / 13:25:07 / masca"
!

hasPrimitiveContent

    ^(name notNil and:[className isNil])
        or:[self hasConverters]

    "Created: / 02-05-2005 / 15:33:21 / janfrog"
    "Modified: / 07-06-2005 / 15:57:58 / masca"
!

isValidObject: anObject
    "Answer whether the given object fits the binding info."

    | ivClass |

"/(anObject isKindOf: OrderedCollection) ifTrue: [self halt].
    ivClass := self instanceVariableClass.
    ^ivClass isNil or: [anObject isKindOf: ivClass].
    "
    ivClass ifNil: [^true].
    type ifNotNil: [(anObject isKindOf: ivClass) ifTrue: [^true]].
    ^anObject isKindOf: self objectClass
    "

    "Created: / 25-08-2005 / 12:21:15 / masca"
    "Modified: / 25-08-2005 / 13:45:54 / masca"
! !

!BindingInfo methodsFor:'serialization'!

serializeContent: aBlock with: anObject

    type = 'Set' ifTrue:[^anObject do: [:e | aBlock value: e]].
    type = 'OrderedCollection' ifTrue:[^anObject do: [:e | aBlock value: e]].
    type = 'Dictionary' ifTrue:[^anObject associations do:[:a|aBlock value:a]].
    

    aBlock value:anObject

    "Created: / 02-05-2005 / 16:53:10 / janfrog"
    "Modified: / 13-05-2005 / 14:12:55 / masca"
! !

!BindingInfo class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__BindingInfo.st,v 1.1.1.1 2005-11-01 22:07:12 vranyj1 Exp $'
! !
