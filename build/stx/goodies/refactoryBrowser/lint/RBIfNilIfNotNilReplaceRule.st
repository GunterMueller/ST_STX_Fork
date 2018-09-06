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

RBTransformationRule subclass:#RBIfNilIfNotNilReplaceRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBIfNilIfNotNilReplaceRule class methodsFor:'documentation'!

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

!RBIfNilIfNotNilReplaceRule methodsFor:'accessing'!

group
    ^ 'Transformations - Smalltalk/X'

    "Modified: / 01-03-2012 / 18:56:56 / cg"
!

name
    ^ 'Use "isNil ifTrue:..." instead of "ifNil:ifNotNil:" (performance hint)'

    "Modified: / 15-09-2011 / 11:34:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 19:27:54 / cg"
!

rationale
    ^ 'Due to a bug/limitation in the <i>stc</i> compiler, 
<i>stc</i> does not optimize "<code>ifNil:</code>", "<code>ifNotNil:</code>" etc. 
Use "<code>isNil ifTrue:</code>" instead, such code is optimized (inlined) by <i>stc</i> and generates much faster code.'

    "Created: / 04-08-2011 / 19:24:07 / cg"
    "Modified: / 30-01-2012 / 11:22:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2012 / 19:29:01 / cg"
! !

!RBIfNilIfNotNilReplaceRule methodsFor:'initialization'!

initialize
    super initialize.
    self rewriteRule 
        replace:'``@cond ifNil:``@block' with:'``@cond isNil ifTrue:``@block';
        replace:'``@cond ifNotNil:``@block' with:'``@cond notNil ifTrue:``@block';

        replace:'``@cond ifNil:``@block1 ifNotNil:``@block2' with:'``@cond isNil ifTrue:``@block1 ifFalse: ``@block2';
        replace:'``@cond ifNotNil:``@block1 ifNil:``@block2' with:'``@cond isNil ifTrue:``@block2 ifFalse: ``@block1';

        yourself

    "Modified (format): / 04-08-2011 / 19:27:13 / cg"
    "Modified: / 30-01-2012 / 19:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBIfNilIfNotNilReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBIfNilIfNotNilReplaceRule.st,v 1.6 2013-01-24 10:18:50 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBIfNilIfNotNilReplaceRule.st,v 1.6 2013-01-24 10:18:50 vrany Exp $'
! !

