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

RBTransformationRule subclass:#RBBetweenAndRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBBetweenAndRule class methodsFor:'documentation'!

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

!RBBetweenAndRule methodsFor:'accessing'!

group
        ^ 'Transformations'

    "Modified: / 01-03-2012 / 08:14:49 / cg"
!

name
	^ '"a >= b and: [a <= c]" -> "a between: b and: c"'
!

rationale
        ^ 'Can rewrite expressions like <code><pre>    a >= b and: [a <= c]</pre></code>
to <code><pre>    a between: b and: c</pre></code> which is more readable.'
!

severity
        ^ SeverityInformation
! !

!RBBetweenAndRule methodsFor:'initialization'!

initialize
	super initialize.
	self rewriteRule
		replace: '``@a >= ``@b and: [``@a <= ``@c]' with: '``@a between: ``@b and: ``@c';
		replace: '``@a >= ``@b & (``@a <= ``@c)' with: '``@a between: ``@b and: ``@c';
		replace: '``@b <= ``@a and: [``@a <= ``@c]' with: '``@a between: ``@b and: ``@c';
		replace: '``@b <= ``@a & (``@a <= ``@c)' with: '``@a between: ``@b and: ``@c';
		replace: '``@a <= ``@c and: [``@a >= ``@b]' with: '``@a between: ``@b and: ``@c';
		replace: '``@a <= ``@c & (``@a >= ``@b)' with: '``@a between: ``@b and: ``@c';
		replace: '``@c >= ``@a and: [``@a >= ``@b]' with: '``@a between: ``@b and: ``@c';
		replace: '``@c >= ``@a & (``@a >= ``@b)' with: '``@a between: ``@b and: ``@c';
		replace: '``@a >= ``@b and: [``@c >= ``@a]' with: '``@a between: ``@b and: ``@c';
		replace: '``@a >= ``@b & (``@c >= ``@a)' with: '``@a between: ``@b and: ``@c';
		replace: '``@b <= ``@a and: [``@c >= ``@a]' with: '``@a between: ``@b and: ``@c';
		replace: '``@b <= ``@a & (``@c >= ``@a)' with: '``@a between: ``@b and: ``@c';
		replace: '``@a <= ``@c and: [``@b <= ``@a]' with: '``@a between: ``@b and: ``@c';
		replace: '``@a <= ``@c & (``@b <= ``@a)' with: '``@a between: ``@b and: ``@c';
		replace: '``@c >= ``@a and: [``@b <= ``@a]' with: '``@a between: ``@b and: ``@c';
		replace: '``@c >= ``@a & (``@b <= ``@a)' with: '``@a between: ``@b and: ``@c'
! !

!RBBetweenAndRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

