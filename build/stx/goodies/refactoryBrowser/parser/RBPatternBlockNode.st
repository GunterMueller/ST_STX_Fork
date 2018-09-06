"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBBlockNode subclass:#RBPatternBlockNode
	instanceVariableNames:'valueBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!


!RBPatternBlockNode methodsFor:'accessing'!

sentMessages
	^OrderedCollection new
! !

!RBPatternBlockNode methodsFor:'enumeration'!

allNonPatternMessageNodesDo:aBlock
    "/ intentionally left blank

    "Created: / 16-11-2016 / 18:25:53 / cg"
!

variableNodesDo:aBlock
    "/ intentionally left blank

    "Created: / 16-11-2016 / 19:59:43 / cg"
! !

!RBPatternBlockNode methodsFor:'matching'!

addArgumentWithNameBasedOn: aString 
	| name index vars |
	name := aString.
	vars := self allDefinedVariables.
	index := 0.
	[vars includes: name] whileTrue: 
			[index := index + 1.
			name := name , index printString].
	arguments := arguments copyWith: (RBVariableNode named: name)
!

copyInContext: aDictionary 
	^self replacingBlock value: aDictionary
!

createBlock
        | source m |

        source := self formattedCode.
        
        Smalltalk isSmalltalkX ifTrue:[
            "/ generate a real method, which returns the block and call it. 
            "/ this will execute faster, because the previous evaluate may choose 
            "/ to only return an interpreted AST block, whereas that one gets jitted
            m := Compiler compile:'__patternBlock ^',source forClass:self class install:false.
            ^ m valueWithReceiver:self arguments:#() selector: #__patternBlock.
        ].
        ^Compiler evaluate: source

    "Modified: / 31-07-2013 / 14:27:51 / cg"
    "Modified (format): / 31-07-2013 / 17:48:52 / cg"
    "Modified: / 15-10-2014 / 12:11:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createMatchingBlock
        |numArgs|

        (numArgs := self arguments size) > 2 
                ifTrue: 
                        [self 
                                error: 'Search blocks can only contain arguments for the node and the matching dictionary'].
        numArgs == 0 
                ifTrue: [self error: 'Search blocks must contain one argument for the node'].
        numArgs = 1 
                ifTrue: [self addArgumentWithNameBasedOn: 'aDictionary'].
        ^self createBlock

    "Modified: / 31-07-2013 / 16:56:53 / cg"
!

createReplacingBlock
	self arguments size > 1 
		ifTrue: 
			[self 
				error: 'Replace blocks can only contain an argument for the matching dictionary'].
	self arguments size = 0 
		ifTrue: [self addArgumentWithNameBasedOn: 'aDictionary'].
	^self createBlock
!

match: aNode inContext: aDictionary 
	^self matchingBlock value: aNode value: aDictionary
!

matchingBlock
	^valueBlock isNil 
		ifTrue: [valueBlock := self createMatchingBlock]
		ifFalse: [valueBlock]
!

replacingBlock
	^valueBlock isNil 
		ifTrue: [valueBlock := self createReplacingBlock]
		ifFalse: [valueBlock]
! !

!RBPatternBlockNode methodsFor:'testing-matching'!

isPatternNode
        ^true

    "Created: / 16-11-2016 / 18:00:48 / cg"
! !

!RBPatternBlockNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

