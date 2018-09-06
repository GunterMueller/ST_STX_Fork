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

RBTransformationRule subclass:#RBMinMaxRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBMinMaxRule class methodsFor:'documentation'!

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

!RBMinMaxRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
        ^ 'Rewrite "ifTrue:ifFalse:" using "min:/max:"'

    "Modified: / 01-03-2012 / 19:19:47 / cg"
!

rationale
        ^ 'The use of the messages <code>#min:</code> and <code>#max:</code> 
improves code readability and avoids heavily nested conditionals.'
!

severity
        ^ SeverityInformation
! !

!RBMinMaxRule methodsFor:'initialization'!

initialize
	super initialize.
	self rewriteRule
		replace: '``@a < ``@b ifTrue: [``@a] ifFalse: [``@b]' with: '``@a min: ``@b';
		replace: '``@a <= ``@b ifTrue: [``@a] ifFalse: [``@b]' with: '``@a min: ``@b';
		replace: '``@a > ``@b ifTrue: [``@a] ifFalse: [``@b]' with: '``@a max: ``@b';
		replace: '``@a >= ``@b ifTrue: [``@a] ifFalse: [``@b]' with: '``@a max: ``@b';
		replace: '``@a < ``@b ifTrue: [``@b] ifFalse: [``@a]' with: '``@a max: ``@b';
		replace: '``@a <= ``@b ifTrue: [``@b] ifFalse: [``@a]' with: '``@a max: ``@b';
		replace: '``@a > ``@b ifTrue: [``@b] ifFalse: [``@a]' with: '``@a min: ``@b';
		replace:  '``@a >= ``@b ifTrue: [``@b] ifFalse: [``@a]' with: '``@a min: ``@b';
		replace: '`a < ``@b ifTrue: [`a := ``@b]' with: '`a := `a max: ``@b';
		replace: '`a <= ``@b ifTrue: [`a := ``@b]' with: '`a := `a max: ``@b';
		replace: '`a < ``@b ifFalse: [`a := ``@b]' with: '`a := `a min: ``@b';
		replace: '`a <= ``@b ifFalse: [`a := ``@b]' with: '`a := `a min: ``@b';
		replace: '`a > ``@b ifTrue: [`a := ``@b]' with: '`a := `a min: ``@b';
		replace: '`a >= ``@b ifTrue: [`a := ``@b]' with: '`a := `a min: ``@b';
		replace: '`a > ``@b ifFalse: [`a := ``@b]' with: '`a := `a max: ``@b';
		replace: '`a >= ``@b ifFalse: [`a := ``@b]' with: '`a := `a max: ``@b';
		replace: '``@b < `a ifTrue: [`a := ``@b]' with: '`a := `a min: ``@b';
		replace: '``@b <= `a ifTrue: [`a := ``@b]' with: '`a := `a min: ``@b';
		replace: '``@b < `a ifFalse: [`a := ``@b]' with: '`a := `a max: ``@b';
		replace: '``@b <= `a ifFalse: [`a := ``@b]' with: '`a := `a max: ``@b';
		replace: '``@b > `a ifTrue: [`a := ``@b]' with: '`a := `a max: ``@b';
		replace: '``@b >= `a ifTrue: [`a := ``@b]' with: '`a := `a max: ``@b';
		replace: '``@b > `a ifFalse: [`a := ``@b]' with: '`a := `a min: ``@b';
		replace: '``@b >= `a ifFalse: [`a := ``@b]' with: '`a := `a min: ``@b'
! !

!RBMinMaxRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

