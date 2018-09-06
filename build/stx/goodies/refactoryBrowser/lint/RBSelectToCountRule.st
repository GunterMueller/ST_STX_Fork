"
 Copyright (C) 2015 Claus Gittinger

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

RBTransformationRule subclass:#RBSelectToCountRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBSelectToCountRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2015 Claus Gittinger

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

!RBSelectToCountRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
    ^ '"select+size" -> "count:" or "occurrencesOf:"'
!

rationale
    "/ 'Rewrite "<code>detect:ifNone:</code>" into "<code>contains:</code>"'
    ^ 'Code using: 
<code><pre>    (aCollection select: [:each | each ...] ) size</pre></code> 
can be simplified to  <code><pre>    aCollection count:[:each | each ...]</pre></code>
or even to <code><pre>    aCollection occurrencesOf:something</pre></code>.
<p>Not only does the "<code>occurrencesOf:</code>" variant signify what the code is doing, it is also much faster.'
!

severity
        ^ SeverityInformation
! !

!RBSelectToCountRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                replace: '( ``@collection select: [:`el | `el = `var]) size'
                with: '( ``@collection occurrencesOf:`var)';

                replace: '( ``@collection select: [:`el | `el = `#lit]) size'
                with: '( ``@collection occurrencesOf:`#lit)';

                replace: '( ``@collection select: [:`el | ``@test]) size'
                with: '( ``@collection count:[:`el | ``@test])';

                replace: '( ``@collection count: [:`el | `el = `#lit])'
                with: '( ``@collection occurrencesOf:`#lit)'.
! !

!RBSelectToCountRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

