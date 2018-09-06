"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

InlineMethodRefactoring subclass:#InlineMethodFromComponentRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!InlineMethodFromComponentRefactoring methodsFor:'testing'!

isOverridden
	^(self inlineClass allSubclasses 
		detect: [:each | each directlyDefinesMethod: self inlineSelector]
		ifNone: [nil]) notNil
! !

!InlineMethodFromComponentRefactoring methodsFor:'transforming'!

abstractVariableReferences
	| refactoring |
	refactoring := AbstractVariablesRefactoring 
				model: self model
				abstractVariablesIn: inlineParseTree
				from: inlineClass
				toAll: (Array with: class).
	self performComponentRefactoring: refactoring.
	inlineParseTree := refactoring parseTree
!

addArgumentToSelector: aSymbol 
	^aSymbol isInfix 
		ifTrue: [#value:value:]
		ifFalse: [(aSymbol , 'value:') asSymbol]
!

addSelfReferenceToInlineParseTree
	| variableName rewriter newArguments |
	variableName := self newNameForSelf.
	rewriter := ParseTreeRewriter rename: 'self' to: variableName.
	(rewriter executeTree: inlineParseTree) 
		ifTrue: [inlineParseTree := rewriter tree].
	newArguments := inlineParseTree arguments asOrderedCollection.
	newArguments addFirst: (RBVariableNode named: variableName).
	inlineParseTree
		arguments: newArguments;
		selector: (self addArgumentToSelector: inlineParseTree selector).
	sourceMessage receiver replaceWith: (RBVariableNode named: variableName)
!

addSelfReferenceToSourceMessage
	| newArguments |
	newArguments := sourceMessage arguments asOrderedCollection.
	newArguments addFirst: sourceMessage receiver copy.
	sourceMessage
		arguments: newArguments;
		selector: (self addArgumentToSelector: sourceMessage selector)
!

checkSuperMessages
	inlineParseTree superMessages isEmpty 
		ifFalse: 
			[self 
				refactoringError: 'Cannot inline method since it sends a super message']
!

findSelectedMessage
	sourceParseTree := class parseTreeFor: sourceSelector.
	sourceParseTree isNil 
		ifTrue: [self refactoringError: 'Could not parse sources'].
	sourceMessage := sourceParseTree whichNodeIsContainedBy: sourceInterval.
	sourceMessage isNil 
		ifTrue: 
			[self 
				refactoringError: 'The selection doesn''t appear to be a message send'].
	sourceMessage isCascade 
		ifTrue: [sourceMessage := sourceMessage messages last].
	sourceMessage isMessage 
		ifFalse: 
			[self 
				refactoringError: 'The selection doesn''t appear to be a message send']
!

inlineClass
        | imps |

        inlineClass notNil ifTrue: [^inlineClass].
        imps := (self model allImplementorsOf: self inlineSelector) asOrderedCollection.
        imps size = 1 ifTrue: [^inlineClass := imps first].
        imps isEmpty ifTrue: [
            self refactoringError: 'Nobody defines a method named ' , self inlineSelector
        ].
        inlineClass := self requestImplementorToInline: imps.
        inlineClass isNil ifTrue: [self refactoringError: 'No implementor selected'].
        ^inlineClass

    "Modified (format): / 30-04-2016 / 17:42:11 / cg"
!

newNameForSelf
	| variableName index originalName nonMetaClass |
	nonMetaClass := inlineClass nonMetaclass.
	variableName := originalName := (nonMetaClass name first isVowel 
						ifTrue: ['an']
						ifFalse: ['a']) , nonMetaClass name.
	index := 1.
	
	[variableName := self safeVariableNameBasedOn: variableName.
	inlineParseTree allDefinedVariables includes: variableName] 
			whileTrue: 
				[variableName := originalName , index printString.
				index := index + 1].
	^variableName
!

renameSelfReferences
	self addSelfReferenceToSourceMessage.
	self addSelfReferenceToInlineParseTree.
!

safeVariableNameBasedOn: aString 
	"Creates an unused variable name containing aString"

	| baseString newString i allTempVars |
	allTempVars := inlineParseTree allTemporaryVariables.
	baseString := aString copy.
	baseString at: 1 put: baseString first asLowercase.
	newString := baseString.
	i := 0.
	
	[(allTempVars includes: newString) 
		or: [class definesInstanceVariable: newString]] 
			whileTrue: 
				[i := i + 1.
				newString := baseString , i printString].
	^newString
!

transform
	self abstractVariableReferences.
	self renameSelfReferences.
	super transform
! !

!InlineMethodFromComponentRefactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

