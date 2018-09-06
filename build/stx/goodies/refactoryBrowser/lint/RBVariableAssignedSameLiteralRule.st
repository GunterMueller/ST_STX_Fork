"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

RBBlockLintRule subclass:#RBVariableAssignedSameLiteralRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBVariableAssignedSameLiteralRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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
! !

!RBVariableAssignedSameLiteralRule methodsFor:'accessing'!

group
	^ 'Miscellaneous'
!

name
        ^ 'Variable is always assigned the same literal value'
!

rationale
    ^ self appendVariableNamesFromResultToRationale:
        'If a variable is only assigned the same literal value then that variable is either nil or that literal value. 
If the variable is always initialized with that literal value, 
then you could replace each variable reference with a message send to get the value. 
If the variable can also be nil, then you might want to replace that variable with another 
that stores true or false depending on whether the old variable had been assigned.
<P>
Be careful: often this kind of code is found with lazy initialization or to manage local
resources (such as background processes). It is questionable, if this lint-rule is too strict and should 
actually be ignored in most places.'
!

resultClass
    "I will return the set of failing variables"

    ^ VariableEnvironment
! !

!RBVariableAssignedSameLiteralRule methodsFor:'running'!

checkClass: aContext 
    | allSubclasses containsNonLiteralAssigns foundMoreThanOne foundOne valueAssigned|
    
    allSubclasses := aContext selectedClass withAllSubclasses.
           
    aContext selectedClass instVarNames do:[ :each | 
        |searcher|

        (each endsWith:'*') ifFalse:[
            searcher := ParseTreeSearcher new.
            searcher 
                matches: each , ' := ``@object'
                do:[ :assignNode :setOfValues |
                    |rightSide|

                    (containsNonLiteralAssigns or:[foundMoreThanOne]) ifFalse:[
                        rightSide := assignNode value.
                        rightSide isLiteral ifTrue:[ 
                            foundOne ifFalse:[
                                foundOne := true.
                                valueAssigned := rightSide value.
                            ] ifTrue:[
                                rightSide value = valueAssigned ifTrue:[
                                    "/ go on 
                                ] ifFalse:[
                                    foundMoreThanOne := true.   
                                ].
                            ].
                        ] ifFalse:[    
                            containsNonLiteralAssigns := true 
                        ]. 
                    ].
                ].
            containsNonLiteralAssigns := foundOne := foundMoreThanOne := false.

            allSubclasses do:[:eachClass |

                eachClass selectors do:[:selector |
                    | tree |

                    (containsNonLiteralAssigns | foundMoreThanOne) ifFalse:[

                        tree := eachClass parseTreeFor: selector.
                        tree notNil ifTrue:[
                            searcher 
                                executeTree: tree
                                initialAnswer: Set new.
                        ] ifFalse:[
                            Transcript showCR:'huch - unparsable method: ',selector
                        ].
                    ]
                ]    

            ]. 
            (containsNonLiteralAssigns not & foundMoreThanOne not) ifTrue:[
                result 
                    addClass: aContext selectedClass
                    instanceVariable: each 
            ]    
        ]    
    ]
! !

!RBVariableAssignedSameLiteralRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

