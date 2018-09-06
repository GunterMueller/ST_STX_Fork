"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PEGFsaPair
	instanceVariableNames:'first second'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaPair class methodsFor:'instance creation'!

with: a with: b
    ^ PEGFsaPair new
        first: a;
        second: b;
        yourself
! !

!PEGFsaPair methodsFor:'accessing'!

first
    ^ first
!

first: anObject
    first := anObject
!

second
    ^ second
!

second: anObject
    second := anObject
! !

!PEGFsaPair methodsFor:'comparing'!

= anObject
    (anObject == self) ifTrue: [ ^ true ].
    (anObject class == self class) ifFalse: [ ^ false ].
    
    ((anObject first == first) and: [anObject second == second]) ifTrue: [ ^ true ].
    ((anObject first == second) and: [anObject second == first]) ifTrue: [ ^ true ].
    
    ^ false	
!

hash
    ^ first hash bitXor: second hash
! !

!PEGFsaPair methodsFor:'enumerating'!

detect: block
    (block value: self first) ifTrue: [ ^ self first ].
    (block value: self second) ifTrue: [ ^ self second ].	
    
    self error: 'not found!!'
! !

!PEGFsaPair methodsFor:'testing'!

contains: block
    ^ (block value: self first) or: [ block value: self second  ]
!

includes: anObject
    ^ self first == anObject or: [ self second == anObject ]
! !

