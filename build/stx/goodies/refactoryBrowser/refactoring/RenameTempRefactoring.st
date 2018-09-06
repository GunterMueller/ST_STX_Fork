"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

MethodRefactoring subclass:#RenameTemporaryRefactoring
	instanceVariableNames:'selector interval oldName newName parseTree
		okToRenameAsKnownVariable newSource'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RenameTemporaryRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk renameTemporaryFrom: anInterval to: newName in: aClass selector: aSelector 
	^(self new)
		model: aRBSmalltalk;
		class: aClass
			selector: aSelector
			interval: anInterval
			newName: newName;
		yourself
!

renameTemporaryFrom: anInterval to: newName in: aClass selector: aSelector 
	^self new
		class: aClass
		selector: aSelector
		interval: anInterval
		newName: newName
! !

!RenameTemporaryRefactoring methodsFor:'accessing'!

newSource
    "only valid if source was given AND transformation has been executed"

    ^ newSource
!

okToRenameAsKnownVariable:something
    okToRenameAsKnownVariable := something.
! !

!RenameTemporaryRefactoring methodsFor:'initialize-release'!

class: aClass selector: aSelector interval: anInterval newName: aString 
	class := self classObjectFor: aClass.
	selector := aSelector.
	interval := anInterval.
	newName := aString
! !

!RenameTemporaryRefactoring methodsFor:'performing'!

whichNodeDefines: aParseTree 
	^self
		whichVariableNode: aParseTree
		inInterval: interval
		name: oldName
! !

!RenameTemporaryRefactoring methodsFor:'preconditions'!

preconditions
        |cond|

        cond := (RBCondition definesSelector: selector in: class)
                & (RBCondition isValidTemporaryVariableName: "isValidInstanceVariableName:" newName for: class). 

        "/ added to allow for a local to be renamed into an instVar (for removal)
        okToRenameAsKnownVariable ~~ true ifTrue:[
            cond := cond 
                        & (RBCondition definesInstanceVariable: newName in: class) not 
                        & (RBCondition definesClassVariable: newName in: class) not. 
        ].

        ^ cond 
            & (RBCondition withBlock: 
                                    [| methodSource |
                                    interval first > interval last 
                                            ifTrue: [self refactoringError: 'Invalid variable name'].
                                    methodSource := source notNil ifTrue:[source] ifFalse:[class sourceCodeFor: selector].
                                    methodSource size >= interval last 
                                            ifFalse: [self refactoringError: 'Invalid range for variable'].
                                    oldName := methodSource copyFrom: interval first to: interval last.
                                    true])

    "Modified: / 06-08-2012 / 12:01:06 / cg"
! !

!RenameTemporaryRefactoring methodsFor:'printing'!

printOn: aStream 
    oldName notNil ifTrue:[
        aStream nextPutAll: 'Rename Temporary "'.
        aStream nextPutAll: oldName.
        aStream nextPutAll: '" to: "'.
        aStream nextPutAll: newName.
        aStream nextPutAll: '" in: '.
"/        class storeOn: aStream.
"/        aStream nextPutAll: ' >> '.
        aStream nextPutAll: selector.
    ]
!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' renameTemporaryFrom: '.
	interval storeOn: aStream.
	aStream
		nextPutAll: ' to: ''';
		nextPutAll: newName;
		nextPutAll: ''' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' selector: #';
		nextPutAll: selector.
	aStream nextPut: $)
! !

!RenameTemporaryRefactoring methodsFor:'transforming'!

renameNode: aParseTree
        "this generates a new prettyprinted version of the sourcecode.
        Normally, you don't want that"

        (aParseTree whoDefines: newName) notNil 
                ifTrue: [self refactoringError: newName , ' is already defined'].
        (aParseTree allDefinedVariables includes: newName) 
                ifTrue: [self refactoringError: newName , ' is already defined'].
        (ParseTreeRewriter rename: oldName to: newName) executeTree: aParseTree
!

renameNodeInOriginalSource: aParseTree
        "this rewrites the variable in the original sourcecode.
        Normally, this is what you want"

        |rw newSourceCode|

        (aParseTree whoDefines: newName) notNil 
                ifTrue: [self refactoringError: newName , ' is already defined'].
        (aParseTree allDefinedVariables includes: newName) 
                ifTrue: [self refactoringError: newName , ' is already defined'].

        rw := ParseTreeSourceRewriter rename: oldName to: newName.
        rw executeTree: aParseTree.
        newSourceCode := rw executeReplacementsInSource:source.
        "/ rw forgetReplacements.
        ^ newSourceCode
!

transform
        | definingNode variableNode|

        source notNil ifTrue:[
            parseTree := RBParser 
                            parseMethod:source
                            onError:[:aString :pos | self refactoringError:aString].
            RBParser flushCachedTreeFor:source.
        ] ifFalse:[
            parseTree := class parseTreeFor: selector.
        ].
        variableNode := self 
                                whichVariableNode: parseTree
                                inInterval: interval
                                name: oldName.
        (variableNode isNil or: [variableNode isVariable not]) 
                ifTrue: [self refactoringError: oldName , ' isn''t a valid variable'].
        variableNode name = oldName 
                ifFalse: [self refactoringError: 'Invalid selection'].
        definingNode := variableNode whoDefines: oldName.
        definingNode isNil 
                ifTrue: [self refactoringError: oldName , ' isn''t defined by the method'].

        (RBParser isSmalltalkX and:[source notNil]) ifTrue:[
            " do it in the original source, without formatting "
            newSource := self renameNodeInOriginalSource: definingNode.
            class notNil ifTrue:[ class compileTree: parseTree usingSource:newSource ].
        ] ifFalse:[
            self renameNode: definingNode.
            class notNil ifTrue:[ class compileTree: parseTree ]
        ].
! !

!RenameTemporaryRefactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

