"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCCodeGenerator subclass:#PPCTokenizingCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors-CodeGenerators'
!


!PPCTokenizingCodeGenerator methodsFor:'accessing'!

guards
    self flag: 'Hack alert, the codeGenerator needs refactoring so that we can remove this method'.
    self halt: 'deprecated'.
    "When tokenizing, do not use guards"
    ^ false
! !

!PPCTokenizingCodeGenerator methodsFor:'initialization'!

initialize
    super initialize.
    
    codeGen := PPCTokenizingCodeGen new
! !

!PPCTokenizingCodeGenerator methodsFor:'visiting'!

visitAndNode: node
    | mementoVar  |
    
    mementoVar := codeGen allocateTemporaryVariableNamed: 'memento'.
    codeGen remember: node child to: mementoVar.

    codeGen 
          codeEvaluateAndAssign:[ self visit:node child ]
          to:self retvalVar.

    codeGen restore: node child from: mementoVar.
    codeGen codeReturn.
!

visitChoiceNode: node
"       true ifTrue: [ ^ super visitChoiceNode: node ]."
    | possibleError memento |
    possibleError := true.

    memento := codeGen allocateTemporaryVariableNamed: 'memento'.
    codeGen codeScannerRememberTo: memento.

    node children do: [ :child |
        | tokenMethodName |

        child acceptsEpsilon "false" ifTrue: [  
            possibleError := false.
            codeGen codeEvaluateAndAssign:[ self visit:child ] to:self retvalVar.
            codeGen codeReturn.
            "makes no sense to compile more..."
            ^ self
        ] ifFalse: [
            child firstSetWithTokens do: [ :first |
                "For each child, for each first compile this:"
            
                tokenMethodName := codeGen idFor: first.
                codeGen codeIf: '(scanner ', tokenMethodName asString, ')' then: [ 
                    codeGen codeEvaluateAndAssignParsedValueOf:[ self visit:child ] to:self retvalVar.
                    codeGen codeIf: 'error' then: [ 
                        codeGen codeClearError.
                        codeGen codeScannerRestoreFrom: memento.
                    ] else: [ 
                        codeGen codeReturn: self retvalVar.
                    ]
                ]
            ]
        ]
    ].
    possibleError ifTrue: [
        codeGen codeError: 'no choice found'.
    ]

    "Modified: / 31-07-2015 / 08:07:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitDeterministicChoiceNode: node
    | dictionary isInlined |
    dictionary := IdentityDictionary new.
    
"	codeGen currentMethod methodName asSymbol = #'ch' ifTrue: [ self halt ]."
    isInlined := node isMarkedForInline.
    
    node children do: [ :child |
        | firstSet |
        firstSet := child firstSetWithTokens.
        self assert: firstSet size = 1.
        dictionary at: child put: firstSet anyOne.
    ].
    "Tokens are unique"
    self assert: dictionary values asSet size = node children size.
    
    node children do: [ :child |
        | tokenMethodName |
        tokenMethodName := codeGen idFor: (dictionary at: child).
        codeGen code: '(scanner ', tokenMethodName asString, ')'.
        codeGen codeOnLine: ' ifTrue: ['.
        codeGen indent.
        codeGen codeReturnParsedValueOf:[ self visit:child ].
        codeGen dedent.
        isInlined ifTrue:[
            codeGen code: '] ifFalse: ['
        ] ifFalse:[
            codeGen code: '].'.
        ]
    ].
    codeGen codeError: 'no choice found'.
    isInlined ifTrue:[
        node children size timesRepeat: [ codeGen addOnLine: ']' ].
        codeGen codeOnLine: '.'.
    ]

    "Modified: / 21-05-2015 / 15:31:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitTokenConsumeNode: node
    | id |
    id := codeGen idFor: node.
    codeGen codeReturn: 'scanner ', id, ' ifNil: [ error := true ].'.
!

visitTokenNode: node
    self error: 'should not happen!!'
!

visitTokenizingParserNode: node
    codeGen codeHaltIfShiftPressed.
    codeGen 
          codeEvaluateAndAssign:[ self visit:node parser ]
          to:self retvalVar.
    codeGen codeReturn.
!

visitTrimmingTokenCharacterNode: node
    self error: 'should not happen!!'
!

visitTrimmingTokenNode: node
    self error: 'should not happen!!'
! !

!PPCTokenizingCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

