"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPNode subclass:#PPCLRPAction
	instanceVariableNames:'block textBlock interpretedBlock keywordEnd'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!

!PPCLRPAction class methodsFor:'instance creation'!

block: aBlock
    |retval|
    retval := self new.
    retval block: aBlock.
    retval textBlock: aBlock copy. 
    ^ retval
! !

!PPCLRPAction methodsFor:'accessing'!

block
    ^ block
!

block: anObject
    block := anObject
!

keywordEnd
    keywordEnd ifNil: [ self halt: 'Error in setting up range info for styling' ].
    ^ keywordEnd
!

keywordEnd: anObject
    keywordEnd := anObject
!

textBlock
    ^ textBlock
!

textBlock: anObject
    textBlock := anObject
! !

!PPCLRPAction methodsFor:'printing'!

printOn: aStream

    aStream nextPutAll: self class name.
    aStream nextPutAll: ' : '.
    aStream nextPutAll: self block asString.
! !

!PPCLRPAction methodsFor:'visiting'!

acceptVisitor: aLRPNodeVisitor
    aLRPNodeVisitor visitActionNode: self.
! !

