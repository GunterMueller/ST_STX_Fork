"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

MethodRefactoring subclass:#TemporaryToInstanceVariableRefactoring
	instanceVariableNames:'selector temporaryVariableName'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!TemporaryToInstanceVariableRefactoring class methodsFor:'instance creation'!

class: aClass selector: aSelector variable: aVariableName 
	^self new 
		class: aClass
		selector: aSelector
		variable: aVariableName
!

model: aRBSmalltalk class: aClass selector: aSelector variable: aVariableName 
	^(self new)
		model: aRBSmalltalk;
		class: aClass
			selector: aSelector
			variable: aVariableName;
		yourself
! !

!TemporaryToInstanceVariableRefactoring methodsFor:'initialize-release'!

class: aClass selector: aSelector variable: aVariableName 
	class := self classObjectFor: aClass.
	selector := aSelector.
	temporaryVariableName := aVariableName
! !

!TemporaryToInstanceVariableRefactoring methodsFor:'preconditions'!

checkForValidTemporaryVariable
        | parseTree |
        parseTree := class parseTreeFor: selector.
        (parseTree allTemporaryVariables includes: temporaryVariableName) 
                ifFalse: 
                        [self refactoringError: temporaryVariableName 
                                                , ' isn''t a valid temporary variable name'].
        (parseTree allArgumentVariables includes: temporaryVariableName) 
                ifTrue: 
                        [self refactoringError: temporaryVariableName , ' is a block parameter'].
        (RBReadBeforeWrittenTester isVariable: temporaryVariableName
                readBeforeWrittenIn: parseTree) 
                        ifTrue: 
                                [self 
                                        refactoringWarning: ('<1s> could be read before it is written.<n>Proceed anyway?' 
                                                        expandMacrosWith: temporaryVariableName)]
!

preconditions
        ^(RBCondition definesSelector: selector in: class) 
                & (RBCondition hierarchyOf: class
                                definesVariable: temporaryVariableName asString) not 
                        & (RBCondition withBlock: 
                                                [self checkForValidTemporaryVariable.
                                                true])
! !

!TemporaryToInstanceVariableRefactoring methodsFor:'printing'!

printOn: aStream 
    temporaryVariableName notNil ifTrue:[
        aStream nextPutAll: 'Convert local "'.
        aStream nextPutAll: temporaryVariableName.
        aStream nextPutAll: '" to instVar in: '.
        class storeOn: aStream.
"/        aStream nextPutAll: ' >> '.
    ]
!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' selector: #';
		nextPutAll: selector;
		nextPutAll: ' variable: ''';
		nextPutAll: temporaryVariableName;
		nextPut: $'.
	aStream nextPut: $)
! !

!TemporaryToInstanceVariableRefactoring methodsFor:'transforming'!

sourceWithTemporaryRemovedUsing:parseTree 
    |varNode right leftIndex rightIndex left|

    varNode := parseTree body temporaries 
                detect:[ :node | node name = temporaryVariableName. ].
    leftIndex := varNode start - 1.
    rightIndex := varNode stop + 1.
    (source at:rightIndex) isSeparator ifTrue:[ 
        [ (source at:leftIndex) isSeparator. ] whileTrue:[ leftIndex := leftIndex - 1. ].
    ] ifFalse:[ 
        (source at:leftIndex) isSeparator ifTrue:[ 
            [ (source at:rightIndex) isSeparator. ] whileTrue:[ rightIndex := rightIndex + 1. ].
        ].
    ].
    (source at:rightIndex) == $| ifTrue:[ 
        [ (source at:leftIndex) isSeparator. ] whileTrue:[ leftIndex := leftIndex - 1. ].
    ] ifFalse:[ 
        (source at:leftIndex) == $| ifTrue:[ 
            [ (source at:rightIndex) isSeparator. ] whileTrue:[ rightIndex := rightIndex + 1. ].
        ].
    ].
    left := source copyTo:leftIndex.
    right := source copyFrom:rightIndex.
    ^ left , right.
!

transform
    |parseTree matcher protocols newSource|

    parseTree := class parseTreeFor:selector.
    parseTree isNil ifTrue:[ 
        self refactoringError:'Could not parse method'.
    ].
    protocols := class protocolsFor:selector.

    "/ cg: why was this done in original code ?
    "/ class removeMethod: selector.
    class addInstanceVariable:temporaryVariableName.
    (RBParser isSmalltalkX) ifTrue:[ 
        source isNil ifTrue:[ 
            source := (class methodFor:selector) source.
        ].
        newSource := self sourceWithTemporaryRemovedUsing:parseTree.
        class compileTree:parseTree usingSource:newSource.
    ] ifFalse:[ 
        (matcher := ParseTreeRewriter removeTemporaryNamed:temporaryVariableName) 
            executeTree:parseTree.
        class compileTree:matcher tree classified:protocols.
    ].
! !

!TemporaryToInstanceVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/TempToInstVarRefactoring.st,v 1.14 2004-06-18 08:15:18 ca Exp $'
! !
