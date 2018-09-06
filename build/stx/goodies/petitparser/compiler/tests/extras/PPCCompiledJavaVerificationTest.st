"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPCCompiledJavaVerificationTest
	instanceVariableNames:'parser result context resource fileResources'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Java'
!

!PPCCompiledJavaVerificationTest class methodsFor:'as yet unclassified'!

resources
    ^ (OrderedCollection with: PPCompiledJavaResource with: PPCResources)
        addAll: super resources;
        yourself
! !

!PPCCompiledJavaVerificationTest methodsFor:'accessing'!

compiledJavaSyntax
    ^ (Smalltalk at: #PPCompiledJavaSyntax) new
!

context	
    ^ context := PPCProfilingContext new
!

javaSyntax
    ^ PPJavaSyntax new
! !

!PPCCompiledJavaVerificationTest methodsFor:'setup'!

setUp
    super setUp.
    fileResources := (self resources detect: [:e | e = PPCResources ]) current.
! !

!PPCCompiledJavaVerificationTest methodsFor:'tests'!

testJava
    | compiledParser normalParser |
    normalParser := self javaSyntax.
    compiledParser := self compiledJavaSyntax.
    
    fileResources javaSourcesBig do: [ :source |
        result := normalParser parse: source.
        result isPetitFailure not ifTrue: [ 
            self assert: (compiledParser parse: source withContext: self context)
                  equals: result
        ]
    ].
!

testJavaMath
    | compiledParser normalParser source |
    normalParser := self javaSyntax.
    
    source := fileResources javaLangMath.
    result := normalParser parse: source.
    
    result isPetitFailure not ifTrue: [ 
        compiledParser := self compiledJavaSyntax.
        self assert: (compiledParser parse: source withContext: self context)
              equals: result
    ]
!

testJavaTimer
    | compiledParser normalParser source |
    normalParser := self javaSyntax.
    
    source := fileResources javaUtilTimer.
    result := normalParser parse: source.
    
    result isPetitFailure not ifTrue: [ 
        compiledParser := self compiledJavaSyntax.
        self assert: (compiledParser parse: source withContext: self context)
              equals: result
    ]
! !

