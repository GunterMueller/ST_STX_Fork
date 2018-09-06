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

RBParseTreeLintRule subclass:#RBSearchingLiteralRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBSearchingLiteralRule class methodsFor:'documentation'!

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

!RBSearchingLiteralRule class methodsFor:'defaults'!

numCompareLimit
    "that number of sequential compares is considered 'ok'"

    ^ 2
! !

!RBSearchingLiteralRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Uses "or: ..." instead of a searching literal'

    "Modified: / 01-03-2012 / 11:15:48 / cg"
!

rationale
        ^ 'Check for code comparing a value against a list of values using
multiple comparisons: <code><pre>    (foo = ''..'' or:[ foo = ''..''])</pre></code> 
instead of using: <pre><code>    #(...) includes:foo</code></pre>
This rule checks if more than ',self class numCompareLimit asString,' such compares are used in one expression.
<p>
Notice, that from a performance point of view, doing a small number of identity compares
is much faster than searching in a collection. So the above should not be taken dogmatic.'

    "Created: / 01-03-2012 / 11:13:16 / cg"
! !

!RBSearchingLiteralRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher
                matchesAnyOf: #(
                        '``@object = `#literal or: [``@expression]' 
                        '``@object == `#literal or: [``@expression]' 
                        '`#literal = ``@object or: [``@expression]' 
                        '`#literal == ``@object or: [``@expression]' 
                        '``@expression | (``@object = `#literal)' 
                        '``@expression | (``@object == `#literal)' 
                        '``@expression | (`#literal = ``@object)' 
                        '``@expression | (`#literal == ``@object)')
                do: [ :node :answer | 
                        answer isNil 
                            ifTrue: [
                                    ((self countSearchingLiteralExpression: node) > self class numCompareLimit)
                                        ifTrue: [ node ]
                                        ifFalse: [ nil ] ]
                            ifFalse: [ answer ] ]
! !

!RBSearchingLiteralRule methodsFor:'private'!

countSearchingLiteralExpression: aMessageNode 
        | equalNode expressionNode n|
        equalNode := aMessageNode selector = #| 
                                ifTrue: [aMessageNode arguments first]
                                ifFalse: [aMessageNode receiver].
        expressionNode := equalNode receiver isLiteral 
                                ifTrue: [equalNode arguments first]
                                ifFalse: [equalNode receiver].
        n := self countSearchingLiteralExpression: aMessageNode for: expressionNode nAlready:0.
        "/ Transcript showCR:n.
        ^ n
!

countSearchingLiteralExpression: aSearchingNode for: anObjectNode nAlready:nAlready 
    | argument arguments selector receiver n1 n2|

    aSearchingNode isMessage ifFalse: [^0].

    arguments := aSearchingNode arguments.
    arguments size = 1 ifFalse: [^0].
    argument := arguments first.

    selector := aSearchingNode selector.
    receiver := aSearchingNode receiver.

    (#(#= #==) includes: selector) ifTrue:[ 
        ((receiver = anObjectNode and: [ argument isLiteral]) 
            or:[ argument = anObjectNode and: [receiver isLiteral]]) ifTrue:[
            ^ nAlready + 1
        ].
        ^ 0
    ].

    selector = #| ifTrue: [
        n1 := self countSearchingLiteralExpression: receiver for: anObjectNode nAlready:nAlready.
        n1 > 0 ifTrue:[
            ^ self countSearchingLiteralExpression: argument for: anObjectNode nAlready:n1.
        ].
        ^ 0
    ].

    selector = #or: ifFalse: [^0].
    argument isBlock ifFalse: [^0].
    argument body statements size = 1 ifFalse: [^0].
    n1 := self countSearchingLiteralExpression: receiver for: anObjectNode nAlready:nAlready. 
    n1 > 0 ifTrue:[
        ^ self countSearchingLiteralExpression: argument body statements first for: anObjectNode nAlready:n1.
    ].
    ^ 0
! !

!RBSearchingLiteralRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

