"
 Copyright (C) 2014 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBParseTreeLintRule subclass:#RBAssignmentInConditionRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Experimental Rules'
!

!RBAssignmentInConditionRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2014 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
    UNFINIHSED
    the idea is that if you have an assignment only along one branch of a conditional,
    the value of the variable is harder to understand after the branch (as you have to make sure, that it is not
    left uninitialized.
    However, currently, we get many false positives, especially from lazy getters.
    Should further investigate and improve; possibly not complaining when the if is a nil-check.
"
! !

!RBAssignmentInConditionRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
        ^ 'Assignment inside condition'
!

rationale
        ^ 'Assignments should either be done in both branches of a condition
or outside a condition.
As these assignments may or may not be executed,
in the followup code it may be harder to understand if and how a variable is set.
This is an unfinished lint rule under construction'
! !

!RBAssignmentInConditionRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '`@expr ifTrue: [ `@.Statements1. `var := `@object. `@.Statements2. ]'

                        '`@expr ifFalse: [ `@.Statements1. `var := `@object. `@.Statements2. ]'

                        '`@expr ifTrue: [ `@.Statements1. `var := `@object. `@.Statements2. ]
                                ifFalse: [ `@.Statements3. `var2 := `@object2. `@.Statements4. ]'

                        '`@expr ifFalse: [ `@.Statements1. `var := `@object. `@.Statements2. ]
                                ifTrue: [ `@.Statements3. `var2 := `@object2. `@.Statements4. ]'

                        '`@expr ifNil: [ `@.Statements1. `var := `@object. `@.Statements2. ]'

                        '`@expr ifNotNil: [ `@.Statements1. `var := `@object. `@.Statements2. ]'

                        '`@expr ifNil: [ `@.Statements1. `var := `@object. `@.Statements2. ]
                                ifNotNil: [ `@.Statements3. `var2 := `@object2. `@.Statements4. ]'

                        '`@expr ifNotNil: [ `@.Statements1. `var := `@object. `@.Statements2. ]
                                ifNil: [ `@.Statements3. `var2 := `@object2. `@.Statements4. ]'
                 )
                do: [ :node :answer :owner :context |
                    |rslt isUsedAfter isSetBefore varNode varName containingSequence idx|

                    rslt := answer.    
                    answer isNil ifTrue:[
                        isUsedAfter := isSetBefore := false.

                        varNode := context at:(RBPatternVariableNode named:'`var').
                        varName := varNode name.

                        containingSequence := node detectParentForWhich:[:p | p isSequence].
                        [ isUsedAfter not and:[isSetBefore not and:[containingSequence notNil]] ] whileTrue:[
                            idx := containingSequence statements identityIndexOf:node.

                            "/ check if var is defined before
                            containingSequence statements from:1 to:idx-1 do:[:eachPrefixStatement | 
                                (eachPrefixStatement assigns: varName ) ifTrue:[ isSetBefore := true ].
                            ].

                            "/ check if var is used in statementsFollowing
                            idx := containingSequence statements identityIndexOf:node.
                            containingSequence statements from:idx+1 do:[:eachFollowupStatement | 
                                (eachFollowupStatement references: varName ) ifTrue:[ isUsedAfter := true ].
                            ].

                            containingSequence := containingSequence detectParentForWhich:[:p | p isSequence].
                        ].
                        (isSetBefore not and:[isUsedAfter]) ifTrue:[ 
                            rslt := node
                        ].
                    ].
                    rslt.
                ]
! !

!RBAssignmentInConditionRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

