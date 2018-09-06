"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RGDefinition
	instanceVariableNames:'annotations name'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGDefinition comment:'I am the root class of the Ring meta-model.A Ring definition has a name, can be annotated and knows its environment'
!

!RGDefinition class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!RGDefinition class methodsFor:'annotations'!

authorKey

    ^#author
!

fullNameKey

    ^#fullName
!

timeStampKey

    ^#timestamp
! !

!RGDefinition class methodsFor:'class initialization'!

named: aName

    ^self new
        name: aName asSymbol;
        yourself
! !

!RGDefinition methodsFor:'accessing'!

environment
    "If the receiver has not namespace assigned the default is used"
    "self class environment = Smalltalk globals"

    ^ self annotationNamed: #environment ifAbsent: [ self class environment ]
!

environment: namespace

    namespace = self class environment
        ifFalse:[ self annotationNamed: #environment put: namespace ]
!

fullName

    ^self name
!

name

    ^name
!

name: anObject
    "a symbol or a string should be expected"
    
    name:= anObject
!

rootEnvironment
    "Retrieves the runtime environment of an RGObject"
    "If the receiver is defined in an RGContainer the runtime environment is the one associated to its container"
    | parent |
    
    parent:= self environment.
    [ parent isRingObject ]
        whileTrue:[ parent:= parent environment ].

    ^parent
! !

!RGDefinition methodsFor:'annotations'!

annotationNamed: annotationName 
    "Answer the value of the annotation named <annotationName>, or 
    nil if the annotation is not defined for the receiver."
    
    ^ self
        annotationNamed: annotationName
        ifAbsent: [ nil ]
!

annotationNamed: annotationName ifAbsent: exceptionBlock 
    "Answer the value of the annotation named <annotationName>. If the 
    annotation is not defined for the receiver, answer the result of 
    evaluating the <exceptionBlock>."

    self hasAnnotations
        ifFalse: [ ^exceptionBlock value ].

    ^self annotations
            at: annotationName
            ifAbsent: [ exceptionBlock value ]
!

annotationNamed: annotationName ifAbsentPut: blockValue 

    ^self annotations
        at: annotationName
        ifAbsentPut: blockValue
!

annotationNamed: annotationName put: value 

    self annotations
        at: annotationName
        put: value
!

annotationNames
    
    self hasAnnotations
        ifFalse:[ ^OrderedCollection new ].
    ^annotations keys
!

annotations

    ^annotations ifNil:[ annotations:= Dictionary new ]

    "Modified: / 02-09-2015 / 12:02:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasAnnotationNamed: annotationName
    "Answer <true> if the receiver contains the annotation named <annotationName>. "
    
    self hasAnnotations	
        ifFalse:[ ^false ].
    ^annotations includesKey: annotationName
!

hasAnnotations

    ^annotations notNil
!

removeAnnotationNamed: annotationName 
    "Remove the annotation named <annotationName>. Fails quietly if there 
    is no annotation with the given name."
    
    (self hasAnnotationNamed: annotationName)
        ifTrue:[ annotations removeKey: annotationName ]
! !

!RGDefinition methodsFor:'converting'!

asRingDefinition
    ^ self
! !

!RGDefinition methodsFor:'testing types'!

isAccess 

    ^false
!

isComment

    ^false
!

isGlobalVariable

    ^false
!

isInheritance

    ^false
!

isInvocation

    ^false
!

isMethod

    ^false
!

isNamespace

    ^false
!

isOrganization 

    ^false
!

isPackage

    ^false
!

isPool

    ^false
!

isReference 

    ^false
!

isRingObject

    ^true
!

isSlice

    ^false
!

isVariable

    ^false
! !

