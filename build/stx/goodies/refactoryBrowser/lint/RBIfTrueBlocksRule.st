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

RBParseTreeLintRule subclass:#RBIfTrueBlocksRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBIfTrueBlocksRule class methodsFor:'documentation'!

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

!RBIfTrueBlocksRule methodsFor:'accessing'!

group
	^ 'Miscellaneous'
!

name
	^ 'Non-blocks in special messages'
!

rationale
        ^ 'Checks for methods that don''t use blocks in the special ifXXX messages. 
Beginners who do not yet understand blocks (the difference between powerful- and powerless brackets)
sometimes write code like: <code><pre>    aBoolean ifTrue: (self doSomething)</pre></code>
instead of the correct: <code><pre>    aBoolean ifTrue: [self doSomething]</pre></code>
<p>
Such non-block argument errors are nutty, because the value from the "if" is correct,
but both the if- and else arguments are evaluated (care for side effects).
<br>
Also, in very rare cases, the "doSomething" method is actually returning a block,
which is to be evaluated by the "if". 
But such use should be annotated by a comment, or written as "<code>[ self doSomething value ]</code>"
as it is quite difficult to see.
<P>
Notice, that sometimes if-expressions are constructed by purpose without blocks, 
if alternative constant values are to be computed. 
For example:
<CODE><PRE>    (test ifTrue:1 ifFalse:0)</PRE></CODE>
computes 0/1 depending on the test.
This relies on the fact that every object understands #value and returns
itself by default (see Object >> value).
However, if used this way, you have to be absolutely certain that neither argument
ever evaluates to a block or association.
<P>
Be aware that the compilers are usually smart enough to generate good code 
(i.e. eliminate block construction where possible), 
so any performance argument against the use of blocks instead of constants is hardly ever valid.
<P>
Also be aware, that not all Smalltalk dialects support #value in the Object class,
so such code will not work on old VSE Smalltalk.'

    "Modified: / 16-11-2016 / 22:19:34 / cg"
! !

!RBIfTrueBlocksRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '`@condition ifTrue: `{:node | node isBlock not and:[node isLiteral not]} ifFalse: `@block'
                        '`@condition ifTrue: `@block ifFalse: `{:node | node isBlock not and:[node isLiteral not]}'
                        '`@condition ifFalse: `{:node | node isBlock not and:[node isLiteral not]} ifTrue: `@block'
                        '`@condition ifFalse: `@block ifTrue: `{:node | node isBlock not and:[node isLiteral not]}'
                        '`@condition ifTrue: `{:node | node isBlock not and:[node isLiteral not]}'
                        '`@condition ifFalse: `{:node | node isBlock not and:[node isLiteral not]}'
                        '`@condition and: `{:node | node isBlock not}'
                        '`@condition or: `{:node | node isBlock not}'
                        '`{:node | node isBlock not} whileTrue'
                        '`{:node | node isBlock not} whileFalse'
                        '`{:node | node isBlock not} whileTrue: `@block'
                        '`{:node | node isBlock not} whileFalse: `@block'
                        '`@block whileTrue: `{:node | node isBlock not}'
                        '`@block whileFalse: `{:node | node isBlock not}'
                        '`@block doWhile: `{:node | node isBlock not}'
                        '`@block doUntil: `{:node | node isBlock not}'
                        '`@from to: `@to do: `{:node | node isBlock not}'
                        '`@from to: `@to by: `@by do: `{:node | node isBlock not}'
                        '`@condition ifNil: `{:node | node isBlock not}'
                        '`@condition ifNotNil: `{:node | node isBlock not}'
                        '`@condition ifNil: `{:node | node isBlock not} ifNotNil: `@block'
                        '`@condition ifNil: `@block ifNotNil: `{:node | node isBlock not}'
                        '`@condition ifNotNil: `{:node | node isBlock not} ifNil: `@block'
                        '`@condition ifNotNil: `@block ifNil: `{:node | node isBlock not}' )
                do: [ :node :answer | node ]

    "Modified: / 16-11-2016 / 22:21:47 / cg"
! !

!RBIfTrueBlocksRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

