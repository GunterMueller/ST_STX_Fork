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

RBParseTreeLintRule subclass:#RBToDoFillRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBToDoFillRule class methodsFor:'documentation'!

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
! !

!RBToDoFillRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Use of a "to:do:" loop instead of "from:to:put:"'
!

rationale
        ^ 'Checks for uses of 
<code><pre>    start to:stop do:[:i | coll at: i put: val]</pre></code> to fill a collection, 
when a <code><pre>    coll from:start to:stop put:val</pre></code> could be used. 
The later is a block-fill and usually much faster (especially for arrays and ordered collections).
<P>
But before changing, please check if the filled collection actually is an arrayed collection which does 
support the block-fill "from:to:put:" protocol.'
! !

!RBToDoFillRule methodsFor:'initialization'!

initialize
        super initialize.
        "/ cg: check if stored value is either constant or a variable,
        "/     but if a variable, it should not be the running index (i.e. no false positive on foo at:i put:i)
        "/     thanks to Jan
        self matcher 
                matchesAnyOf: #(
                        '
                        "/ `@.Stmts1.
                        `@start to: `@stop do:[:`i | 
                            `collection 
                                at: `i 
                                put: `{:node | node isLiteral 
                                               or: [node isVariable 
                                                    and:[node name ~= (aDictionary at:(RBPatternVariableNode named:''`i'')) name]] }.].
                        "/ `@.Stmts2
                        '

                        '
                        "/ `@.Stmts1.
                        (`@start to: `@stop) do:[:`i | 
                            `collection 
                                at: `i 
                                put: `{:node | node isLiteral 
                                               or: [node isVariable 
                                                    and:[node name ~= (aDictionary at:(RBPatternVariableNode named:''`i'')) name]] }.].
                        "/ `@.Stmts2
                        '
                )
                do: [ :node :answer | 
                    |collExpr|

                    "/ cg: also check if stored into collection expression is "self" and if so, if it actually responds to from:to:put:
                    collExpr := matcher context at:(RBPatternVariableNode named:'`collection').
                    collExpr isSelf ifTrue:[
                        (matcher currentSearchContext selectedClass respondsTo:#from:to:put:) ifTrue:[
                            node
                        ] ifFalse:[
                            answer
                        ].
                    ] ifFalse:[
                        node 
                    ]
                ]
! !

!RBToDoFillRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

