"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

ChangeMethodNameRefactoring subclass:#RenameMethodRefactoring
	instanceVariableNames:'hasPermutedArguments suppressRewriteOfSenders
		rewriteLocalSendersOnly'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RenameMethodRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk renameMethod: aSelector in: aClass to: newSelector permutation: aMap 
        ^(self new)
                model: aRBSmalltalk;
                renameMethod: aSelector
                        in: aClass
                        to: newSelector
                        permuation: aMap;
                yourself
! !

!RenameMethodRefactoring methodsFor:'performing'!

renameSymbols
	| replacer builder |
	self hasPermutedArguments ifTrue: [^self].
	builder := RefactoryBuilder new.
	replacer := ParseTreeRewriter replaceLiteral: oldSelector with: newSelector.
	self 
		convertAllClassesSelect: [:aClass | aClass whichSelectorsReferTo: oldSelector]
		using: replacer
		notifying: builder.
	builder doIt: 'Renaming symbols'
! !

!RenameMethodRefactoring methodsFor:'preconditions'!

myConditions
        ^RBCondition 
            withBlock: [oldSelector numArgs = newSelector numArgs]
            errorString: newSelector printString 
                                , ' doesn''t have the correct number (' , oldSelector numArgs printString , ') of arguments.'
!

preconditions
    | newCondition |

    newSelector ~= oldSelector ifTrue:[
        ^ super preconditions
    ].

    "/ notice & and | mean something completly different here    
    newCondition := (RBCondition 
                            withBlock: [ newSelector = oldSelector ]
                            errorString: 'The selectors are <1?:not >equivalent') 
                    & (RBCondition 
                            withBlock: [permutation asArray ~= (1 to: oldSelector numArgs) asArray]
                            errorString: 'The arguments are <1?:not >permuted').
    ^ newCondition | super preconditions
!

rewriteLocalSendersOnly
    ^ rewriteLocalSendersOnly

    "Created: / 28-02-2007 / 21:22:58 / cg"
!

rewriteLocalSendersOnly:aBoolean
    rewriteLocalSendersOnly := aBoolean

    "Created: / 28-02-2007 / 21:22:49 / cg"
!

suppressRewriteOfSenders
    ^ suppressRewriteOfSenders ? false
!

suppressRewriteOfSenders:aBoolean
    suppressRewriteOfSenders := aBoolean
! !

!RenameMethodRefactoring methodsFor:'printing'!

changeString
    ^ 'Rename %1 to %2 in %3' bindWith:oldSelector with:newSelector with:class printString
!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' renameMethod: #';
		nextPutAll: oldSelector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' to: #';
		nextPutAll: newSelector;
		nextPutAll: ' permuation: '.
	permutation storeOn: aStream.
	aStream nextPut: $)
! !

!RenameMethodRefactoring methodsFor:'queries'!

shouldBeConfirmed

    "/Do not confirm if there are no senders updated, i.e., the refactoring will
    "/only create new method and then remove old method.
    ^self changes changes size ~~ 2

    "Created: / 26-08-2013 / 12:11:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RenameMethodRefactoring methodsFor:'testing'!

hasPermutedArguments
	^hasPermutedArguments isNil 
		ifTrue: [hasPermutedArguments := super hasPermutedArguments]
		ifFalse: [hasPermutedArguments]
!

implementorsCanBePrimitives
	^self hasPermutedArguments not
! !

!RenameMethodRefactoring methodsFor:'transforming'!

parseTreeRewriter
        | replClass rewriteRule oldString newString |

        replClass := RBParser isSmalltalkX ifTrue:[ParseTreeSourceRewriter] ifFalse:[ParseTreeRewriter].
        oldString := self buildSelectorString: oldSelector.
        newString := self buildSelectorString: newSelector
                                withPermuteMap: permutation.
        rewriteRule := self hasPermutedArguments 
                                ifTrue: [replClass new]
                                ifFalse: [replClass replaceLiteral: oldSelector with: newSelector].
        rewriteRule replace: '``@object ' , oldString
                with: '``@object ' , newString.
        ^rewriteRule

    "Modified: / 15-10-2014 / 02:07:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RenameMethodRefactoring class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

