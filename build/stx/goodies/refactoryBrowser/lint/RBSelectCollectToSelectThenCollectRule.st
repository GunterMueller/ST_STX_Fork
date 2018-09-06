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

RBTransformationRule subclass:#RBSelectCollectToSelectThenCollectRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBSelectCollectToSelectThenCollectRule class methodsFor:'documentation'!

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

!RBSelectCollectToSelectThenCollectRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
    ^ '"select+collect" -> "select:thenCollect:"'
!

rationale
    "/ 'Rewrite "<code>detect:ifNone:</code>" into "<code>contains:</code>"'
    ^ 'Code of the form: 
<code><pre>    (aCollection select: [:each | ...] ) collect: [:each | ...]</pre></code> 
and 
<code><pre>    (aCollection collect: [:each | ...] ) select: [:each | ...]</pre></code> 
creates a temporary collection and can be rewritten mot efficiently to  
<code><pre>    aCollection select: [:each | ...]  thenCollect:[:each | ...]</pre></code>
which generates the same result in one operation, without generating a separate collection.
<P>However, notice that this transformation is invalid for receivers which are nor related to collections,
and thus do not implement "select:thenCollect:" / "collect:thenSelect:".
<P>
For example, some UI framework classes may do so (hierarchical trees, etc).
'
!

severity
        ^ SeverityInformation
! !

!RBSelectCollectToSelectThenCollectRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                replace: '( ``@collection select: [:`el | ``@test]) collect: [:`el2 | ``@expr2]'
                with: '( ``@collection select:[:`el | ``@test] thenCollect: [:`el2 | ``@expr2])';

                replace: '( ``@collection collect: [:`el2 | ``@expr2] select: [:`el | ``@test]) collect: [:`el2 | ``@expr2]'
                with: '( ``@collection collect: [:`el2 | ``@expr2] thenSelect:[:`el | ``@test])'.
! !

!RBSelectCollectToSelectThenCollectRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

