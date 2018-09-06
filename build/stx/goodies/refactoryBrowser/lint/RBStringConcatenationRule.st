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

RBParseTreeLintRule subclass:#RBStringConcatenationRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBStringConcatenationRule class methodsFor:'documentation'!

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

!RBStringConcatenationRule methodsFor:'accessing'!

group
	^ 'Miscellaneous'
!

name
	^ 'String concatenation instead of streams'
!

rationale
        ^ 'Check for string concatenation inside some iteration message. 
Since string concatenation is O(n^2), it may be better to use a stream which has O(n log(n)) behavior,
Assuming that n is large enough. 
<p>
Be careful: for a small number of short strings, the overhead of stream-creation
may outweight the square behavior.
<p>
Also be careful, as this rule often delivers false positives,
complaining about totally reasonable code, 
as it is not smart enough to determine if a concatenation is accumulating or not
(i.e. it is a fresh one in each loop iteration)'

    "Modified: / 02-03-2012 / 00:52:17 / cg"
! !

!RBStringConcatenationRule methodsFor:'initialization'!

initialize
    |concatenationMatcher|

    super initialize.
    concatenationMatcher := ParseTreeSearcher new.
    concatenationMatcher 
        matches:'`@receiver , `@argument'
        do:[:node :answer |
            |doNotComplain parent scope|

            parent := node parent.
            "/ do not complain if this is a return node: it will be executed at most once
            doNotComplain := parent isNil.
            doNotComplain := doNotComplain or:[parent isReturn].
            doNotComplain := doNotComplain or:[parent isAssignment not].

            "/ or it assigns to a block temporary (i.e. is a fresh concatenation each time in the loop)
            doNotComplain := doNotComplain 
                                or:[parent isAssignment 
                                   and:[(scope := parent variable definingSequence) notNil
                                   and:[ scope parent isBlock]]].
            doNotComplain not
        ].

    self matcher 
        matchesAnyOf:#( '``@collection do: [:`each | | `@temps | ``@.Statements]'
             '``@collection do: [:`each | | `@temps | ``@.Statements] separatedBy: [| `@temps1 | ``@.Statements1]'
             '``@number to: ``@endNumber do: [:`i | | `@temps | ``@.Statements]'
             '``@collection detect: [:`each | | `@temps | ``@.Statements]'
             '``@collection detect: [:`each | | `@temps | ``@.Statements] ifNone: [| `@temps1 | ``@.Statements1]'
             '``@collection select: [:`each | | `@temps | ``@.Statements]'
             '``@collection inject: ``@value into: [:`each | | `@temps | ``@.Statements]' )
        do:[:node :answer | 
            answer isNil ifTrue:[
                | argumentsToCheck |

                argumentsToCheck := node arguments.
                "/ Do not check for concatenation in ifNone: block - it is executed at most once!!
                node selector == #detect:ifNone: ifTrue:[
                    argumentsToCheck := argumentsToCheck copyButLast:1
                ].
                (argumentsToCheck
                    contains:[:each | each isBlock and:[ concatenationMatcher executeTree:each initialAnswer:false]]
                ) ifTrue:[
                    node
                ] ifFalse:[ 
                    nil 
                ]
            ] ifFalse:[ 
                answer 
            ]
        ]

    "Modified: / 20-08-2013 / 09:13:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBStringConcatenationRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

