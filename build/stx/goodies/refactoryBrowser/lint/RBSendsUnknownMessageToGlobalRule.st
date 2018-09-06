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

RBParseTreeLintRule subclass:#RBSendsUnknownMessageToGlobalRule
	instanceVariableNames:'currentContext'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBSendsUnknownMessageToGlobalRule class methodsFor:'documentation'!

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

!RBSendsUnknownMessageToGlobalRule methodsFor:'accessing'!

group
	^ 'Bugs'
!

name
	^ 'Sends unknown message to global'
!

rationale
        ^ 'Check for unknown messages sent to a known global.

In some cases, the receiver redefines "<code>doesNotUnderstand:</code>" to emulate the 
protocol of another class or to forward messages to a delegate.
For example, Transcript is doing this, to emulate stream protocol.
However, this lint rule knows about that
special behavior of Transcript and does not complain (but only for Transcript).'

    "Created: / 07-03-2012 / 17:43:35 / cg"
!

severity
        ^ SeverityError
! !

!RBSendsUnknownMessageToGlobalRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
        matches:'`{:node :context | node isVariable "and: [ (context selectedClass environment includesKey: node name asSymbol) or:[Smalltalk includesKey: node name asSymbol]]" } `@message: `@args'
        do:[:node :oldAnswer|
            | newAnswer |

            (newAnswer := oldAnswer) isNil ifTrue:[
                | nm cls what context|

                nm := node receiver name asSymbolIfInterned.
                nm notNil ifTrue:[
                    "/ self assert:currentContext notNil.
                    nm isUppercaseFirst ifTrue:[
                        context := currentContext ? matcher currentSearchContext. 
                        context isNil ifTrue:[self breakPoint:#cg].
                        cls := context selectedClass.
                        
                        cls isNil ifTrue:[
                            matcher currentSearchContext notNil ifTrue:[
                                self breakPoint:#cg.
                                cls := matcher currentSearchContext selectedClass.
                            ]
                        ].
                        "/ if we have a class context, check if there is a classVar or private class
                        "/ by that name.
                        cls notNil ifTrue:[
                            cls := cls theNonMetaclass.
                            ((cls classVarNames) includes:nm) ifTrue:[
                                what := cls classVarAt:nm
                            ] ifFalse:[
                                Smalltalk isSmalltalkX ifTrue:[
                                    what := cls privateClassesAt:nm.
                                    what isNil ifTrue:[
                                        what := cls topNameSpace at: nm.
                                    ].
                                ] ifFalse:[
                                    what := cls environment at: nm.
                                ].
                            ]
                        ].    
                        what isNil ifTrue:[
                            what := Smalltalk at:nm
                        ].
                    ].
                ].
                "/ Transcript showCR: '--> ', what printString.
                (what notNil 
                        and:[ what ~~ Preferences 
                        and:[ (what isBehavior not or:[ what isLoaded ]) 
                        and:[ (what respondsTo:node selector) not ]]]) 
                ifTrue:[ 
                    "/ special: check for Transcript, which delegates some stream messages...
                    "/ this is pure heuristics
                    ((what isKindOf:TextCollector) 
                    and:[ (Stream canUnderstand:node selector) ]) ifFalse:[    
                        newAnswer := node 
                    ]
                ]
            ].
            newAnswer
        ]

    "Modified: / 31-07-2013 / 17:47:51 / cg"
    "Modified: / 29-11-2013 / 13:35:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBSendsUnknownMessageToGlobalRule methodsFor:'running'!

checkMethod: aContext
    
    currentContext := aContext.    
    super checkMethod: aContext.
    currentContext := nil.

    "Created: / 08-07-2013 / 11:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBSendsUnknownMessageToGlobalRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

