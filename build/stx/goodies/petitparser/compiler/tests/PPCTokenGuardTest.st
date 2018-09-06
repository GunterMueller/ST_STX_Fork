"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCTokenGuardTest
	instanceVariableNames:'guard compiler node tokenNode'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Guards'
!


!PPCTokenGuardTest methodsFor:'as yet unclassified'!

setUp
    super setUp.
    compiler := PPCMockCompiler new.
!

testMakesSense
    tokenNode := PPCTokenNode new
        child: 'foo' asParser asCompilerTree.
    node := PPCPlusNode new
        child: tokenNode;
        yourself.	
    guard := PPCTokenGuard on: node.
    
    self assert: guard makesSense.
!

testMakesSense2
    node := PPCPlusNode new
        child: ('foo' asParser asCompilerTree);
        yourself.	
    guard := PPCTokenGuard on: node.
    
    self assert: guard makesSense not.
! !

!PPCTokenGuardTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

