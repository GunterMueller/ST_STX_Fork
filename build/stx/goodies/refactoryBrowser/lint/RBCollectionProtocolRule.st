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

RBParseTreeLintRule subclass:#RBCollectionProtocolRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBCollectionProtocolRule class methodsFor:'documentation'!

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

!RBCollectionProtocolRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Uses "do:" instead of "collect:" or "select:"'

    "Modified: / 01-03-2012 / 11:08:47 / cg"
!

rationale
        ^ 'Checks for uses of "<code>do:</code>" method instead of using one of the "<code>collect:</code>" or "<code>select:</code>" methods. 
These often express the source code''s intentions better.
<p>
Check also for the "<code>select:thenCollect:</code>" and "<code>collect:thenSelect:</code>" methods.
<p>
Notice that this rules may give false positives, if multiple add-messages are contained in a do-loop.'

    "Modified: / 01-03-2012 / 15:04:06 / cg"
! !

!RBCollectionProtocolRule methodsFor:'checking'!

checkMethod:aContext
    "of course, the impementation of contains: should not be blamed upon..."

    |selector|

    selector := aContext selector.

    "/ do not check their implementations (i.e. in collection hierarchy)
    selector == #collect: ifTrue:[ ^ self].
    selector == #select: ifTrue:[ ^ self].
    selector == #reject: ifTrue:[ ^ self].
    super checkMethod:aContext
! !

!RBCollectionProtocolRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
            matchesAnyOf: #(
                    '`@collection do: [:`each | | `@temps | 
                            `@.Statements1. 
                            "/ `@object add: `@arg. 
                            `object add: `@arg. 
                            `@.Statements2]'

                    '`@collection do: [:`each | | `@temps | 
                            `@.Statements1. 
                            `@condition ifTrue: [| `@blockTemps | 
                                            `@.BlockStatements1. 
                                            "/ `@object add: `each. 
                                            `object add: `each. 
                                            `@.BlockStatements2]. 
                            `@.Statements2]'

                    '`@collection do: [:`each | | `@temps | 
                            `@.Statements1. 
                            `@condition ifFalse: [| `@blockTemps | 
                                            `@.BlockStatements1. 
                                            "/ `@object add: `each. 
                                            `object add: `each. 
                                            `@.BlockStatements2]. 
                            `@.Statements2]' )
            do: [ :node :answer | node ]
! !

!RBCollectionProtocolRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

