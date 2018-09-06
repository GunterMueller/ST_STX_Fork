"{ Package: 'stx:goodies/ring/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#RGGlobalDefinitionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel-Tests'
!

RGGlobalDefinitionTest comment:'SUnit tests for global definitions (pools, global variables)'
!


!RGGlobalDefinitionTest methodsFor:'testing'!

testEquality
    | global1 global2 |
    
    global1 := RGGlobalVariableDefinition named: #Transcript.
    global2 := RGGlobalVariableDefinition named: #Transcript.
    self assert: global1 = global2.
    
    global2 := RGGlobalVariableDefinition named: #Transcript2.
    self deny: global1 = global2.
!

testGlobalVariableDefinition
    | global  |
    
    global:= RGGlobalVariableDefinition named:  #Transcript.
    self assert: (global isGlobalVariable).
    self assert: (global parent = Smalltalk globals).
!

testPoolDefinition
    | pool newClass |
    pool := RGClassDefinition newSharedPoolNamed:#TextConstants.
    self assert: pool isPool.
    self assert: pool users isEmpty.
    self assert: pool parent equals: Smalltalk globals.
    newClass := RGClassDefinition named: #OrderedCollection.
    pool addUser: newClass.
    self assert: pool users size equals: 1.
    self assert: (pool includesUser: newClass).
    self assert: (newClass sharedPoolNamed: #TextConstants) isPoolVariable.
    pool := RGClassDefinition named: #TextConstants.
    pool superclassName: #SharedPool.
    self assert: pool isPool.
    self assert: pool users isEmpty
! !

!RGGlobalDefinitionTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

