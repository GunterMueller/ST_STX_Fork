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

RBParseTreeLintRule subclass:#RBDebuggingCodeLeftInMethodsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBDebuggingCodeLeftInMethodsRule class methodsFor:'documentation'!

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

!RBDebuggingCodeLeftInMethodsRule methodsFor:'accessing'!

group
    ^ 'Bugs - Smalltalk/X'

    "Modified: / 25-08-2010 / 14:29:18 / Jan Vrany <enter your email here>"
    "Modified: / 01-03-2012 / 18:56:44 / cg"
!

name
        ^ 'ST/X debugging code left in methods'

    "Modified: / 07-04-2012 / 13:11:12 / cg"
!

rationale
        ^ 'Breakpoints, logging statements, etc. should not be left in production code.
<br>Also, empty exception handlers, #fixme / #todo markers
and code which is "commented" out by 
<code><pre>    false ifTrue:[...]</pre></code> or <code><pre>    true ifFalse:[...]</pre></code>
<BR>
should not be left in production code.
<P>
Please validate the check results manually: debug code protected by a guarding if 
(which checks for some debug settings)
is perfectly ok. Also, in rare situations, empty exception handlers are permissable.
<P>This is a Smalltalk/X specific rule, and is ignored in TestCase classes.'

    "Modified: / 07-03-2012 / 21:40:33 / cg"
!

severity
        ^ SeverityWarning
! !

!RBDebuggingCodeLeftInMethodsRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '`@any handle:[] do:`@anyBlock'                 "/ an empty handler is BAD and leads to hard to find errors!!
                        '`@any handle:[:ex | ] do:`@anyBlock'           
                        '``@anyBlock on:`@any do:[ ]'                   
                        '``@anyBlock on:`@any do:[:ex | ]'              

                        "/ '`@object checkHaltCountExpired'
                        "/ '`@object clearHaltOnce'
                        "/ '`@object decrementAndCheckHaltCount'
                        "/ '`@object decrementHaltCount'
                        "/ '`@object doExpiredHaltCount'
                        "/ '`@object doExpiredHaltCount: `@object1'
                        "/ '`@object doOnlyOnce: `@object1'
                        '#needsWork'
                        '#todo'     '#TODO' 
                        '#fixme'    '#FIXME'
                        '#checkme'  '#CHECKME'
                        '`@object needsWork'
                        '`@object fixme'

                        '`@object halt'
                        '`@object halt: `@object1'
                        "/ '`@object halt: `@object1 onCount: `@object2'
                        "/ '`@object haltOnCount: `@object1'
                        "/ '`@object haltOnce'
                        "/ '`@object haltOnce: `@object1'
                        "/ '`@object haltOnceEnabled'
                        "/ '`@object hasHaltCount'
                        '`@object breakPoint: `@id'
                        '`@object breakPoint: `@id info: `@info'

                        'true ifTrue: `@object1'                        "/ obviously: leftover guards from development
                        'false ifTrue: `@object1'
                        'true ifTrue: `@object1 ifFalse: `@object2'
                        'false ifTrue: `@object1 ifFalse: `@object2'
                        'true ifFalse: `@object1'
                        'false ifFalse: `@object1'
                        'true ifFalse: `@object1 ifTrue: `@object2'
                        'false ifFalse: `@object1 ifTrue: `@object2'
                        'Transcript `@message: `@object1' )
                do: [ :node :answer | node ]

    "Modified: / 25-08-2010 / 14:30:22 / Jan Vrany <enter your email here>"
    "Modified: / 08-08-2011 / 19:39:37 / cg"
! !

!RBDebuggingCodeLeftInMethodsRule methodsFor:'running'!

shouldIgnoreClass: aClass selector: selector
    aClass isTestCaseLike ifTrue:[^ true].
    ^ super shouldIgnoreClass:aClass selector:selector.
! !

!RBDebuggingCodeLeftInMethodsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

