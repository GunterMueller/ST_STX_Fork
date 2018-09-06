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

RBParseTreeLintRule subclass:#RBContainsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBContainsRule class methodsFor:'documentation'!

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

!RBContainsRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Uses "detect:ifNone:" instead of "contains:"'

    "Modified: / 01-03-2012 / 11:08:28 / cg"
!

rationale
    ^ 'Checks for the code fragment: 
<code><pre>    (aCollection detect: [:each | ''some condition''] ifNone: [nil]) ~= nil</pre></code> 
This can be simplified to <code><pre>    aCollection contains: [:each | ''some condition'']</pre></code> 
Not only is the "<code>contains:</code>" variant shorter, it better signifies what the code is doing.'

    "Modified: / 01-03-2012 / 11:19:48 / cg"
! !

!RBContainsRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
"/ cg: disabled; they are also covered by a corresponding
"/     transformation rule, which displays the same rationale, but in addition offers to rewrite the code.
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) isNil'
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) notNil'
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) = nil'
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) == nil'
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) ~= nil'
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [nil]) ~~ nil'
"/                        "/ cg: added
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: nil) isNil'
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: nil) notNil'
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: nil) = nil'
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: nil) == nil'
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: nil) ~= nil'
"/                        '(`@object detect: [:`each | | `@temps| `@.Statements] ifNone: nil) ~~ nil'

                        '`@object detect: [:`each | | `@temps| `@.Statements] ifNone: [| `@temps1 | `@.Statements2. ^`@anything]' )
                do: [ :node :answer | node ]
! !

!RBContainsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

