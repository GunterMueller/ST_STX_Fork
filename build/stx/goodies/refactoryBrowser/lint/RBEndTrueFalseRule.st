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

RBParseTreeLintRule subclass:#RBEndTrueFalseRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBEndTrueFalseRule class methodsFor:'documentation'!

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

!RBEndTrueFalseRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name
        ^ 'Same statements at begin or end of "ifTrue:ifFalse:" blocks'

    "Modified: / 01-03-2012 / 11:57:49 / cg"
!

rationale
        ^ 'Checks for "<code>ifTrue:ifFalse:</code>" blocks that have the same code at the beginning or end. 
While you might not originally write such code, as it is modified, it is easier to create such code. 
Instead of having the same code in two places, you should move it outside the blocks.
<P>Notice that if the duplicate code includes a side effect on a variable that is used as condition
of the if, carefully investigate before moving the assignment in front of the if.
<P>This rule is too stupid to detect such code as yet.'

    "Modified: / 01-03-2012 / 11:57:40 / cg"
!

severity
        ^ SeverityInformation
! !

!RBEndTrueFalseRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher
                matchesAnyOf: #(
                        '`@object 
                                ifTrue: [| `@temps1 | `@.Statements1. `.Statement] 
                                ifFalse: [| `@temps2 | `@.Statements2. `.Statement]' 
                        '`@object 
                                ifTrue: [| `@temps1 | `.Statement. `@.Statements1] 
                                ifFalse: [| `@temps2 | `.Statement. `@.Statements2]' 
                        '`@object 
                                ifFalse: [| `@temps1 | `@.Statements1. `.Statement] 
                                ifTrue: [| `@temps2 | `@.Statements2. `.Statement]' 
                        '`@object 
                                ifFalse: [| `@temps1 | `.Statement. `@.Statements1] 
                                ifTrue: [| `@temps2 | `.Statement. `@.Statement2]') 
                do: [ :node :answer | 
                        answer isNil 
                                ifTrue: [
                                        | statement |
                                        statement := node arguments first body statements last.
                                        (statement isVariable and: [ statement = node arguments last body statements last ]) 
                                                ifFalse: [ node ]
                                                ifTrue: [ nil ] ]
                                ifFalse: [ answer ] ]

    "Modified: / 01-03-2012 / 12:00:56 / cg"
! !

!RBEndTrueFalseRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

