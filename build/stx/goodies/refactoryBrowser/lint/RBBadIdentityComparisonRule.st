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

RBParseTreeLintRule subclass:#RBBadIdentityComparisonRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBBadIdentityComparisonRule class methodsFor:'documentation'!

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

!RBBadIdentityComparisonRule methodsFor:'accessing'!

group
        ^ 'Bugs'

    "Modified: / 07-03-2012 / 22:14:34 / cg"
!

name
        ^ 'Float and String instances should not be compared using == or ~~'

    "Modified: / 07-03-2012 / 22:15:12 / cg"
!

rationale
        ^ 'Floats and strings are value types and should be compared by value, not by identity.
<br>Operations on floats typically create new instances, for example
"<code>1.0 + 1.0</code>" is equal to 2.0, but not identical.
Floats and Strings are seldom identical to another instance with the equal values.
<P>
Please change the code to use "=" and "~=" instead.'

    "Modified: / 08-03-2012 / 02:40:48 / cg"
! !

!RBBadIdentityComparisonRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '`{ :node | |val| node isLiteral and: [ (val := node value) isFloat or:[ val isString and:[val isSymbol not]]] } == `@expr'
                        '`{ :node | |val| node isLiteral and: [ (val := node value) isFloat or:[ val isString and:[val isSymbol not]]] } ~~ `@expr'
                        '`@expr == `{ :node | |val| node isLiteral and: [ (val := node value) isFloat or:[ val isString and:[val isSymbol not]]] }'
                        '`@expr ~~ `{ :node | |val| node isLiteral and: [ (val := node value) isFloat or:[ val isString and:[val isSymbol not]]] }' )
                do: [ :node :answer | node ]

    "Modified: / 08-03-2012 / 02:29:08 / cg"
! !

!RBBadIdentityComparisonRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBBadIdentityComparisonRule.st,v 1.4 2013-01-24 10:27:37 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBBadIdentityComparisonRule.st,v 1.4 2013-01-24 10:27:37 vrany Exp $'
! !

