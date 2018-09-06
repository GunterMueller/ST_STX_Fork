"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCPlusNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCPlusNode methodsFor:'analysis'!

recognizedSentencesPrim
    ^ 	#()
! !

!PPCPlusNode methodsFor:'as yet unclassified'!

defaultName
    ^ #plus
!

followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet suchThat: aBlock
    | first |
    super followSets: aFollowDictionary firstSets:  aFirstDictionary into: aSet suchThat: aBlock.
    
    first := aFirstDictionary at: self.
    (aFollowDictionary at: child) addAll: (first reject: [:each | each isNullable])
! !

!PPCPlusNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitPlusNode: self
! !

!PPCPlusNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

