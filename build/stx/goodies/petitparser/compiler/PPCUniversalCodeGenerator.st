"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCCodeGenerator subclass:#PPCUniversalCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors-CodeGenerators'
!

!PPCUniversalCodeGenerator methodsFor:'guards'!

addGuard: node ifTrue: trueBlock ifFalse: falseBlock
    |  guard id |
    (self guards not or: [(guard := PPCGuard on: node) makesSense not]) ifTrue: [ ^ false].
    id := codeGen idFor: node.

"	falseBlock isNil ifFalse: [ 
        compiler add: 'context atEnd'.
        compiler addOnLine: ' ifTrue: ['.
        compiler indent.
        falseBlock value.
        compiler dedent.
        compiler addOnLine: '].'.
    ]."
    
    guard id: (codeGen idFor: guard defaultName: #guard).
    guard compileGuard: codeGen.

    trueBlock isNil ifFalse: [ 
        codeGen codeOnLine: ' ifTrue: ['.
        codeGen indent.
        trueBlock value.
        codeGen dedent.
        falseBlock isNil 	ifTrue: [ codeGen codeOnLine: '].' ]
                              	ifFalse: [ codeGen code: ']'. ]
    ].
    falseBlock isNil ifFalse: [ 
        codeGen codeOnLine: ' ifFalse: ['.
        codeGen indent.
        falseBlock value.
        codeGen dedent.
        codeGen codeOnLine: '].'.
    ].
    ^ true
!

addGuardTrimming: node
    |  guard firsts id |
    (self guards not or: [(guard := PPCGuard on: node) makesSense not]) ifTrue: [ ^ false].

    id := codeGen idFor: node.
    firsts := node firstSetWithTokens.

    
    (firsts allSatisfy: [ :e | e isTrimmingTokenNode ]) ifTrue: [  
        "If we start with trimming, we should invoke the whitespace parser"
        self compileTokenWhitespace: firsts anyOne.
        ^ true
    ].
    ^ false
! !

!PPCUniversalCodeGenerator methodsFor:'initialization'!

initialize
    super initialize.
    
    codeGen := PPCUniversalCodeGen new
! !

!PPCUniversalCodeGenerator methodsFor:'visiting'!

visitStarNode: node
    self addGuard: node child ifTrue: nil ifFalse: [ codeGen codeReturn: '#()' ].

    super visitStarNode: node
! !

