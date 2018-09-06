"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

MethodRefactoring subclass:#ChangeMethodNameRefactoring
	instanceVariableNames:'newSelector oldSelector permutation implementors'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!ChangeMethodNameRefactoring class methodsFor:'instance creation'!

renameMethod: aSelector in: aClass to: newSelector permuation: aMap 
	^self new renameMethod: aSelector
		in: aClass
		to: newSelector
		permuation: aMap
! !

!ChangeMethodNameRefactoring methodsFor:'accessing'!

newSelector
	^newSelector
!

suppressRewriteOfSenders
    ^ false
! !

!ChangeMethodNameRefactoring methodsFor:'initialize-release'!

renameMethod: aSelector in: aClass to: newSel permuation: aMap 
	oldSelector := aSelector asSymbol.
	newSelector := newSel asSymbol.
	class := self classObjectFor: aClass.
	permutation := aMap
! !

!ChangeMethodNameRefactoring methodsFor:'performing'!

renameSymbols
! !

!ChangeMethodNameRefactoring methodsFor:'preconditions'!

myConditions
	^self subclassResponsibility
!

preconditions
        "This refactoring only preserves behavior if all implementors are renamed."

        | conditions impl rewriteOkCondition|

        conditions := self myConditions 
                                & (RBCondition definesSelector: oldSelector in: class) 
                                & (RBCondition isValidMethodName: newSelector for: class).

        conditions := self implementors 
                                inject: conditions
                                into: 
                                        [:condition :each | |notUnderstood|

                                        notUnderstood := (RBCondition hierarchyOf: each canUnderstand: newSelector) not.
                                        notUnderstood mayProceed:true.
                                        condition & notUnderstood].

        rewriteOkCondition := RBCondition withBlock: 
                                        [
                                         impl := self implementors.
                                         impl size > 1 ifTrue:[ 
                                            self 
                                                refactoringWarning: ('This will modify <1p> implementors.' expandMacrosWith: impl size)
                                                with:impl
                                         ].
                                         true
                                        ].

        ^ conditions & rewriteOkCondition
! !

!ChangeMethodNameRefactoring methodsFor:'private'!

implementors
	implementors isNil 
		ifTrue: [implementors := self model allImplementorsOf: oldSelector].
	^implementors
!

modifyImplementorParseTree: parseTree in: aClass 
	| oldArgs |
	oldArgs := parseTree arguments.
	parseTree arguments: (permutation collect: [:each | oldArgs at: each]).
	parseTree selector: newSelector
!

onlyRenameTheseImplementors:aCollectionOfClasses
    implementors := aCollectionOfClasses collect:[:cls | self classObjectFor: cls]
!

parseTreeRewriter
	| rewriteRule oldString newString |
	rewriteRule := ParseTreeRewriter new.
	oldString := self buildSelectorString: oldSelector.
	newString := self buildSelectorString: newSelector
				withPermuteMap: permutation.
	rewriteRule replace: '``@object ' , oldString
		with: '``@object ' , newString.
	^rewriteRule
! !

!ChangeMethodNameRefactoring methodsFor:'testing'!

hasPermutedArguments
	oldSelector numArgs = newSelector numArgs ifFalse: [^true].
	1 to: oldSelector numArgs
		do: [:i | (permutation at: i) = i ifFalse: [^true]].
	^false
!

implementorsCanBePrimitives
	^false
! !

!ChangeMethodNameRefactoring methodsFor:'transforming'!

removeRenamedImplementors
        self implementors do: [:each | 
            each removeMethod: oldSelector
        ]
!

renameImplementors
        self implementors do:[:each | 
            | parseTree |

            parseTree := each parseTreeFor: oldSelector.
            parseTree isNil ifTrue: [
                self refactoringError: 'Could not parse source code.'
            ].
            (self implementorsCanBePrimitives not and:[ parseTree isPrimitive ]) ifTrue:[ 
                self refactoringError: ('<1p>''s implementation of #<2s> is a primitive' 
                                                expandMacrosWith: each
                                                with: oldSelector)
            ].

            self modifyImplementorParseTree: parseTree in: each.
            each compileTree: parseTree classified: (each protocolsFor: oldSelector)
        ]
!

renameMessageSends
	self convertAllReferencesTo: oldSelector using: self parseTreeRewriter
!

transform
        oldSelector == newSelector ifTrue: [^self].

        self renameImplementors.
        self suppressRewriteOfSenders ifFalse:[
            self renameMessageSends.
        ].
        self removeRenamedImplementors
! !

!ChangeMethodNameRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/ChangeMethodNameRefactoring.st,v 1.18 2009-11-06 18:18:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/ChangeMethodNameRefactoring.st,v 1.18 2009-11-06 18:18:03 cg Exp $'
! !
