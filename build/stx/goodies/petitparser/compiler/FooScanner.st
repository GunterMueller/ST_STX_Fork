"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCScanner subclass:#FooScanner
	instanceVariableNames:''
	classVariableNames:'MaxSymbolNumber Tokens'
	poolDictionaries:''
	category:'PetitCompiler-Scanner'
!

!FooScanner class methodsFor:'as yet unclassified'!

initialize
    super initialize.
    
    MaxSymbolNumber := 3.
    Tokens := #(#A1 #A2 #B).
! !

!FooScanner methodsFor:'distinct'!

nextTokenA
    "a"
    self resetDistinct.
    
    self step.
    self peek == $a ifFalse: [ ^ self return ].

    self recordDistinctMatch: #a.

    ^ self returnDistinct
!

nextTokenAAorA
    "aa / a"
    self resetDistinct.
    
    self step.
    (self peek == $a) ifFalse: [ ^ self returnDistinct ].
    self recordDistinctMatch: #a.	

    self step.
    (self peek == $a) ifFalse: [ ^ self returnDistinct ].
    self recordDistinctMatch: #aa.	

    ^ self returnDistinct.
!

nextTokenAAplusA
    "(aa)+a"
    self resetDistinct.
    
    self step.
    self peek == $a ifFalse: [ ^ self returnDistinct ].

    self step.
    self peek == $a ifFalse: [ ^ self returnDistinct. ].

    [ 
        self recordDistinctMatch: nil.

        self step.
        self peek == $a ifFalse: [ ^ self returnDistinct ].
        self recordDistinctMatch: #AAplusA.

        self step.
        self peek == $a.
    ] whileTrue.

    ^ self returnDistinct
!

nextTokenAAstarA
    "(aa)*a"
    self resetDistinct.
    
    self step.
    self peek == $a ifFalse: [ ^ self returnDistinct ].

    [ 
        self recordDistinctMatch: #AAstarA.

        self step.
        self peek == $a ifFalse: [ ^ self returnDistinct ].
        self recordDistinctMatch: nil.

        self step.
        self peek == $a	
    ] whileTrue.
    
    ^ self returnDistinct
!

nextTokenABorBC
    "a"
    self resetDistinct.
    
    self step.
    (self peek == $a) ifTrue: [ 

        self step.
        self peek == $b ifFalse: [ ^ self returnDistinct ].
        self recordDistinctMatch: #ab.

        ^ self returnDistinct
    ].

    (self peek == $b) ifTrue: [ 
        self step.
        self peek == $c ifFalse: [ ^ self returnDistinct ].
        self recordDistinctMatch: #bc.	

        ^ self returnDistinct
    ].

    ^ self returnDistinct
!

nextTokenABstarA
    "(ab)*a"
    self resetDistinct.
    
    self step.
    self peek == $a ifFalse: [ ^ self returnDistinct ].

    [ 
        self recordDistinctMatch: #ABstarA.
        
        self step.
        self peek == $b ifFalse: [ ^ self returnDistinct ].
        self recordDistinctMatch: nil.
    
        self step.
        self peek == $a.
    ] whileTrue.

    ^ self returnDistinct
!

nextTokenA_Bstar_A
    "ab"
    self resetDistinct.
    
    self step.
    self peek == $a ifFalse: [ ^ self returnDistinct ].

    [
        self step.
        self peek == $b.
    ] whileTrue.


    self peek == $a ifFalse: [ ^ self returnDistinct ].
    self recordDistinctMatch: #A_Bstar_A.

    ^ self returnDistinct.
!

nextTokenAorAA
    "aa / a"
    self resetDistinct.
    
    self step.
    (self peek == $a) ifTrue: [ 
        self recordDistinctMatch: #a.	
        ^ self returnDistinct
    ].

    self step.
    (self peek == $a) ifTrue: [ 
        self recordDistinctMatch: #aa.	
        ^ self returnDistinct
    ].
!

nextTokenAorB
    "a"
    self resetDistinct.
    
    self step.
    (self peek == $a) ifTrue: [ 
        self recordDistinctMatch: #a.	
        ^ self returnDistinct
    ].
    (self peek == $b) ifTrue: [ 
        self recordDistinctMatch: #b.	
        ^ self returnDistinct
    ].

    ^ self returnDistinct
!

nextTokenAstarA
    "a*a"
    [
        self step.
        self peek == $a.
    ] whileTrue.

    self peek == $a ifFalse: [ ^ self returnDistinct ].
    self recordDistinctMatch: #AstarA.
    ^ self returnDistinct
!

nextTokenAstarB
    "a*b"
    self resetDistinct.
    
    [ 
        self step.
        self peek == $a.
    ] whileTrue.

    self peek == $b ifFalse: [ ^ self returnDistinct ].
    self recordDistinctMatch: #AstarB.
    ^ self returnDistinct
! !

!FooScanner methodsFor:'initialization'!

initialize
    super initialize.
! !

!FooScanner methodsFor:'mutlivalue'!

nextMultiTokenA
    "a|a"
    self reset.
    
    self step.
    self peek == $a ifFalse: [ ^ self ].
    
    self recordMatch: 1. "A1 in matches"
    self recordMatch: 2. "A2 in matches"
!

nextTokenAB
    "ab"
    self reset.
    
    self step.
    self peek == $a ifFalse: [ ^ self ].
    
    self step.
    self peek == $b ifFalse: [ ^ self ].
    self recordMatch: 3. "ID of #B"
    
    ^ self
!

nextTokenAuorA
    "a | a"
    self reset.
    
    self step.
    (self peek == $a) ifTrue: [ 
        self recordMatch: 1.	
        self recordMatch: 2.
        ^ self
    ].

    ^ self
! !


FooScanner initialize!
