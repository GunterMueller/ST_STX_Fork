"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGElementDefinition subclass:#RGVariableDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGVariableDefinition comment:'A variable definition'
!


!RGVariableDefinition methodsFor:'accessing'!

environment

    ^ self parent environment 
!

fullName
    "Keeps a unique description for the receiver. As annotation to avoid converting each time is invoked"
    
    ^self annotationNamed: self class fullNameKey
        ifAbsentPut:[ (self parentName, '->', self name) asSymbol ]
! !

!RGVariableDefinition methodsFor:'comparing'!

= aRGVariableDefinition
    "This variable look for equality of the key properties of the receiver"

    ^(super = aRGVariableDefinition)
        and:[ self name == aRGVariableDefinition name ]
!

hash

    ^super hash bitXor: self name hash
! !

!RGVariableDefinition methodsFor:'testing'!

isClassInstanceVariable

    ^false
!

isClassVariable

    ^false
!

isInstanceVariable

    ^false
!

isPoolVariable

    ^false
!

isVariable

    ^true
! !

!RGVariableDefinition class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

