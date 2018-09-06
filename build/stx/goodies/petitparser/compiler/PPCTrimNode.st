"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCSequenceNode subclass:#PPCTrimNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCTrimNode methodsFor:'accessing'!

child
    
    ^ children at: 2
!

child: anObject
    
    children at: 2 put: anObject
!

defaultName
    ^ #trim
!

trimmer
    ^ children at: 1
!

trimmer: anObject
    children at: 1 put: anObject
! !

!PPCTrimNode methodsFor:'analysis'!

acceptsEpsilon
    ^ self child acceptsEpsilonOpenSet: (IdentitySet with: self).
!

acceptsEpsilonOpenSet: set
    (set includes: self child) ifFalse: [ 
        set add: self child.
        ^ self child acceptsEpsilonOpenSet: set 
    ].
    ^ false
! !

!PPCTrimNode methodsFor:'initialization'!

defaultTrimmer
    | message |
    message := PPCMessagePredicateNode new 
            message: #isSeparator;
            predicate: [ :char | char isSeparator ]
            yourself.
    ^ PPCStarNode new
        child: message;
        yourself.
!

initialize
    super initialize.
    children := Array new: 2.
    children at: 1 put: self defaultTrimmer.
! !

!PPCTrimNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitTrimNode: self
! !

