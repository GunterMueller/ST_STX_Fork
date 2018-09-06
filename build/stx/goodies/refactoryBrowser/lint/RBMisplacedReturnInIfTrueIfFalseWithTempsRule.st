"{ Encoding: utf8 }"

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

RBParseTreeLintRule subclass:#RBMisplacedReturnInIfTrueIfFalseWithTempsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBMisplacedReturnInIfTrueIfFalseWithTempsRule class methodsFor:'documentation'!

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

!RBMisplacedReturnInIfTrueIfFalseWithTempsRule methodsFor:'accessing'!

group
    ^ 'Bugs - Smalltalk/X'

    "Modified: / 25-08-2010 / 14:29:23 / Jan Vrany <enter your email here>"
    "Modified: / 01-03-2012 / 18:57:06 / cg"
!

name
        ^ 'Misplaced ^ in ifTrue:ifFalse:'

    "Modified: / 25-08-2010 / 09:58:58 / Jan Vrany <enter your email here>"
!

rationale
        ^ '
Checks for misplaced "^" in "ifTrue:ifFalse:". 
<BR>Code like
<PRE><CODE>    ^ boolean ifTrue:[ ^ value ] ifFalse: [ ^ other ]</CODE></PRE>

(i.e. a return in a return block) is not correctly handled by stc (and sometimes even by the JITTER)
and should be rewritten as:
<pre><code>    boolean ifTrue:[ ^ value ] ifFalse: [ ^ other ]</code></pre>

or alternatively:

<pre><code>    ^ boolean ifTrue:[ value ] ifFalse: [ other ]</code></pre>

<P>
We are aware of the fact, that this sould be fixed in the compilers,
instead of letting the programmer care for this. "mea culpa" - we are ashamed!!
'

    "Modified: / 25-08-2010 / 10:08:11 / Jan Vrany <enter your email here>"
! !

!RBMisplacedReturnInIfTrueIfFalseWithTempsRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '^ `@cond 
                                ifTrue:[| `@ttemps| `@.TStatements. ^ `@tretval]
                                ifFalse:[| `@ftemps| `@.FStatements. ^ `@fretval]'

                        '^ `@cond 
                                ifFalse:[| `@ftemps| `@.FStatements. ^ `@fretval]
                                ifTrue:[| `@ttemps| `@.TStatements. ^ `@tretval]'

                        '^ `@cond 
                                ifTrue:[| `@ttemps| `@.TStatements. ^ `@tretval]'

                        '^ `@cond 
                                ifFalse:[| `@ftemps| `@.FStatements. ^ `@fretval]')

                do: [ :node :answer | node ]

    "Modified: / 25-08-2010 / 10:51:02 / Jan Vrany"
! !

!RBMisplacedReturnInIfTrueIfFalseWithTempsRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBMisplacedReturnInIfTrueIfFalseWithTempsRule.st,v 1.7 2015-03-02 12:55:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBMisplacedReturnInIfTrueIfFalseWithTempsRule.st,v 1.7 2015-03-02 12:55:07 cg Exp $'
!

version_SVN
    ^ '$Id: RBMisplacedReturnInIfTrueIfFalseWithTempsRule.st,v 1.7 2015-03-02 12:55:07 cg Exp $'
! !

