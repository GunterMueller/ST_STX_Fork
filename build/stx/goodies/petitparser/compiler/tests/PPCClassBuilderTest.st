"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCClassBuilderTest
	instanceVariableNames:'builder method1 result'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Core'
!

!PPCClassBuilderTest methodsFor:'as yet unclassified'!

foo
    ^ PPCMethod new
        id: #foo; 
        code: '^ 1';
        yourself
!

setUp
    super setUp.
    builder := PPCClassBuilder new.
!

tearDown
    super tearDown.
    result removeFromSystem.
!

testCompileClass
    builder compiledClassName: #PPCGenerated.
    builder compiledSuperclass: Object.
    
    method1 := self foo.
    builder methodDictionary at: #foo put: method1.
    
    builder instvars add: #foo.
    
    builder constants at: #foobar put: #foobar.
    builder constants at: #barbar put: #barbar.
    
    result := builder compileClass.
    
    self assert: result isNil not.
    self assert: result name = #PPCGenerated.
    self assert: result superclass  = Object.
    
    self assert: result methodDictionary size =1.
    self assert: result instanceVariables size = 1.
    self assert: result classVariables size = 2.
    self assert: (result classVariableNamed: #foobar) value = #foobar.
    self assert: (result classVariableNamed: #barbar) value = #barbar.

    self assert: result new foo = 1.	
!

testCompileClass2
    Object subclass: #PPCGenerated
        instanceVariableNames: ''
        classVariableNames: 'foobar'
        category: 'PetitCompiler-generated'.
        
    (Smalltalk at: #PPCGenerated) compileSilently: 'bar ^ 12' classified: 'test'.
    (Smalltalk at: #PPCGenerated) compileSilently: 'foo ^ 123' classified: 'generated'.
    (Smalltalk at: #PPCGenerated) compileSilently: 'foo2 ^ 1234' classified: 'generated'.

    builder compiledClassName: #PPCGenerated.
    builder compiledSuperclass: Object.
    
    method1 := self foo.
    builder methodDictionary at: #foo put: method1.
    
    result := builder compileClass.
    
    self assert: result isNil not.
    self assert: result name = #PPCGenerated.
    self assert: result superclass  = Object.
    self assert: result methodDictionary size = 2.

    self assert: result classVariables size = 0.
    
    self assert: result new foo = 1.	
    self assert: result new bar = 12.	
!

testCompileClass3
    Object subclass: #PPCGenerated
        instanceVariableNames: ''
        classVariableNames: 'foobar'
        category: 'PetitCompiler-generated'.
        
    (Smalltalk at: #PPCGenerated) compileSilently: 'foo ^ 123' classified: 'testing'.

    builder compiledClassName: #PPCGenerated.
    builder compiledSuperclass: Object.
    
    method1 := self foo.
    builder methodDictionary at: #foo put: method1.
    
    result := builder compileClass.
    
    self assert: result isNil not.
    self assert: result name = #PPCGenerated.
    self assert: result superclass  = Object.
    self assert: result methodDictionary size = 1.

    self assert: result new foo = 123.
! !

