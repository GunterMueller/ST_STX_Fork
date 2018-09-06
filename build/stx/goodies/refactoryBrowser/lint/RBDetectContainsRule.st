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

RBParseTreeLintRule subclass:#RBDetectContainsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBDetectContainsRule class methodsFor:'documentation'!

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

!RBDetectContainsRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Uses "do:" instead of "contains:" or "detect:"'

    "Modified: / 01-03-2012 / 11:08:59 / cg"
!

rationale
        ^ 'Checks for uses of the "<code>do:</code>"-method,
instead of the "<code>contains:</code>" or "<code>detect:</code>" methods.
<P>
Please check the result of this rule, as it sometimes delivers false positives
(when multiple different values are returned from inside the do-loop)'

    "Modified: / 01-03-2012 / 11:16:23 / cg"
! !

!RBDetectContainsRule methodsFor:'checking'!

checkMethod:aContext
    |sel|

    sel := aContext selector.
    "/ do not check their implementations (i.e. in collection hierarchy)
    sel == #contains: ifTrue:[ ^ self].
    sel == #detect:ifNone: ifTrue:[ ^ self].
    sel == #detect: ifTrue:[ ^ self].
    super checkMethod:aContext.
! !

!RBDetectContainsRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
        matchesAnyOf:#( '`@collection do: [:`each | | `@temps | 
                                `@.Statements1. 
                                `@condition ifFalse: [| `@BlockTemps | `@.BlockStatements1. ^`each]. 
                                `@.Statements2]'
             '`@collection do: [:`each | | `@temps | 
                                `@.Statements1. 
                                `@condition ifTrue: [| `@BlockTemps | `@.BlockStatements1.  ^`each]. 
                                `@.Statements2]'
             '`@collection do: [:`each | | `@temps | 
                                `@.Statements1. 
                                `@condition ifFalse: [| `@BlockTemps | `@.BlockStatements1. ^true]. 
                                `@.Statements2]'
             '`@Collection do: [:`each | | `@temps | 
                                `@.Statements1. 
                                `@condition ifTrue: [| `@BlockTemps | `@.BlockStatements1.  ^true]. 
                                `@.Statements2]'
             '`@collection do: [:`each | | `@temps | 
                                `@.Statements1. 
                                `@condition ifFalse: [| `@BlockTemps | `@.BlockStatements1. ^false]. 
                                `@.Statements2]'
             '`@collection do: [:`each | | `@temps | 
                                `@.Statements1. 
                                `@condition ifTrue: [| `@BlockTemps | `@.BlockStatements1.  ^false]. 
                                `@.Statements2]' )
        do:[:node :answer | node ]
! !

!RBDetectContainsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

