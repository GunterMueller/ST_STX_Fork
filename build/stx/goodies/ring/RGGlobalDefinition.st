"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGDefinition subclass:#RGGlobalDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGGlobalDefinition comment:'An RGGlobalDefinition is an abstract superclass for representing classes, global variables and shared pools'
!

!RGGlobalDefinition methodsFor:'accessing'!

parent
    "Retrieves the namespace in which the receiver is known"
    
    ^self environment
! !

!RGGlobalDefinition methodsFor:'comparing'!

= aRGGlobalDefinition
    "This method look for equality of the properties of the receiver"
    "Verifies the class and the name of the receiver"

    ^self class = aRGGlobalDefinition class
        and:[ self name == aRGGlobalDefinition name ]
!

hash
    "Hash is re-implemented because #= is re-implemented"
    
    ^self class hash bitXor: (self name hash)
! !

