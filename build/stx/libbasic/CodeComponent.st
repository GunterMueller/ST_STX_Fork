"{ Package: 'stx:libbasic' }"

Object subclass:#CodeComponent
	instanceVariableNames:'type name properties'
	classVariableNames:'KnownComponents'
	poolDictionaries:''
	category:'System-Support-Projects'
!

!CodeComponent class methodsFor:'documentation'!

documentation
"
    for visualworks compatibility

    [author:]
        cg (cg@CG-PC)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CodeComponent class methodsFor:'initialization'!

initialize
    KnownComponents := IdentityDictionary new.
! !

!CodeComponent class methodsFor:'instance creation'!

type:typeSymbol named:aString
    ^ (KnownComponents at:typeSymbol ifAbsentPut:[Dictionary new])
        at:aString ifAbsentPut:[self new]

    "
     CodeComponent type: #package named: 'JavaConnect-Core' 
    "
!

type:typeSymbol named:aString property:propertySymbol value:propertyValue
    (self type:typeSymbol named:aString) property:propertySymbol value:propertyValue

    "
     CodeComponent type: #package named: 'JavaConnect-Core' property: #postLoadBlock value: '[:package | (Root bindingFor: #JavaWorld) == nil ifTrue:[JavaConnect.JavaPackage initializeJavaWorld.]]'
    "
! !

!CodeComponent methodsFor:'accessing'!

addPropertie:aPropertie
    "add a Propertie"

    properties isNil ifTrue:[
        properties := OrderedCollection new.
    ].
    properties add: aPropertie
!

name
    ^ name
!

name:something
    name := something.
!

property:aPropertySymbol value:anObject
    "add a property"

    properties isNil ifTrue:[
        properties := IdentityDictionary new.
    ].
    properties at:aPropertySymbol put:anObject
!

type
    ^ type
!

type:something
    type := something.
! !

!CodeComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CodeComponent.st,v 1.1 2009-09-25 08:40:44 cg Exp $'
! !

CodeComponent initialize!
