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

RBParseTreeLintRule subclass:#RBCodeCruftLeftInMethodsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Squeak'
!

!RBCodeCruftLeftInMethodsRule class methodsFor:'documentation'!

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

!RBCodeCruftLeftInMethodsRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( squeak pharo)
! !

!RBCodeCruftLeftInMethodsRule methodsFor:'accessing'!

group
        ^ 'Bugs - Squeak'

    "Modified: / 01-03-2012 / 18:57:25 / cg"
!

name
        ^ 'Debugging code left in method'

    "Modified: / 07-04-2012 / 13:20:15 / cg"
!

rationale
        ^ 'Breakpoints, logging statements, etc. should not be left in production code.
<P>
This also includes code which is "commented" out by 
<code><pre>    false ifTrue:[...]</pre></code> or <code><pre>    true ifFalse:[...]</pre></code>
<P>This is a Squeak/Pharo specific rule, please use the corresponding rule for ST/X.'
!

severity
        ^ SeverityError
! !

!RBCodeCruftLeftInMethodsRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '`@object breakPoint: `@object1'
                        '`@object breakPoint: `@object1 info: `@object2'
                        '`@object todo: `@object1'
                        '`@object todo'
"/                        '`@object checkHaltCountExpired'
"/                        '`@object clearHaltOnce'
"/                        '`@object decrementAndCheckHaltCount'
"/                        '`@object decrementHaltCount'
"/                        '`@object doExpiredHaltCount'
"/                        '`@object doExpiredHaltCount: `@object1'
"/                        '`@object doOnlyOnce: `@object1'
                        '`@object halt'
                        '`@object halt: `@object1 onCount: `@object2'
"/                        '`@object haltOnCount: `@object1'
"/                        '`@object haltOnce'
"/                        '`@object haltOnce: `@object1'
"/                        '`@object haltOnceEnabled'
"/                        '`@object hasHaltCount'
"/                        '`@object haltIf: `@object1'
"/                        '`@object inspectOnCount: `@object1'
"/                        '`@object inspectOnce'
"/                        '`@object inspectUntilCount: `@object1'
"/                        '`@object rearmOneShot'
"/                        '`@object removeHaltCount'
"/                        '`@object setHaltCountTo: `@object1'
"/                        '`@object setHaltOnce'
"/                        '`@object toggleHaltOnce'
                        '`@object flag: `@object1'
"/                        '`@object isThisEverCalled'
"/                        '`@object isThisEverCalled: `@object1'
"/                        '`@object logEntry'
"/                        '`@object logExecution'
"/                        '`@object logExit'
                        '`@object needsWork'
                        'true ifTrue: `@object1'
                        'false ifTrue: `@object1'
                        'true ifTrue: `@object1 ifFalse: `@object2'
                        'false ifTrue: `@object1 ifFalse: `@object2'
                        'true ifFalse: `@object1'
                        'false ifFalse: `@object1'
                        'true ifFalse: `@object1 ifTrue: `@object2'
                        'false ifFalse: `@object1 ifTrue: `@object2'
                        'Transcript `@message: `@object1' )
                do: [ :node :answer | node ]

    "Modified: / 07-09-2011 / 06:09:52 / cg"
! !

!RBCodeCruftLeftInMethodsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

