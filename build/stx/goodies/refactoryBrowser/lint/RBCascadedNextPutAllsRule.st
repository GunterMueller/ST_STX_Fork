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

RBTransformationRule subclass:#RBCascadedNextPutAllsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBCascadedNextPutAllsRule class methodsFor:'documentation'!

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

!RBCascadedNextPutAllsRule methodsFor:'accessing'!

group
        ^ 'Transformations'

    "Modified: / 01-03-2012 / 08:14:47 / cg"
!

name
        ^ 'Use cascaded "nextPutAll:" instead of "," in "nextPutAll:"'

    "Modified: / 01-03-2012 / 19:23:02 / cg"
!

rationale
        ^ 'When writing multiple strings to a stream,
it is more efficient to use multiple "<code>nextPutAll:</code>" messages
instead of concatenating the strings first and then sending them. 
Concatenation creates additional 
garbage objects with a non-linear time and space complexity.
<P>Rewrites messages similar to:<CODE><PRE>    aStream nextPutAll:(s1 , s2)</PRE></CODE> into:<CODE><PRE>    aStream nextPutAll:s1; nextPutAll:s2</PRE></CODE>.
<p>
However, there are rare situations where it makes a difference: when writing to
a Socket, every <code>nextPutAll:</code> is written as a single packet on the network,
and concatenation may be required to ensure this.
'

    "Created: / 01-03-2012 / 19:24:52 / cg"
! !

!RBCascadedNextPutAllsRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                replace: '``@rcvr nextPutAll: ``@object1 , ``@object2' 
                   with: '``@rcvr nextPutAll: ``@object1; nextPutAll: ``@object2';
                   
                replace: '``@rcvr nextPutLine: ``@object1 , ``@object2' 
                   with: '``@rcvr nextPutAll: ``@object1; nextPutLine: ``@object2';
                   
                replace: '``@rcvr nextPutAll: ``@object1 , ``@object2 , ``@object3' 
                   with: '``@rcvr nextPutAll: ``@object1; nextPutAll: ``@object2 ; nextPutAll: ``@object3';

                replace: '``@rcvr nextPutLine: ``@object1 , ``@object2 , ``@object3' 
                   with: '``@rcvr nextPutAll: ``@object1; nextPutAll: ``@object2 ; nextPutLine: ``@object3';

                replace: '``@rcvr nextPutAll: ``@object1 , ``@object2 , ``@object3 , ``@object4' 
                   with: '``@rcvr nextPutAll: ``@object1; nextPutAll: ``@object2 ; nextPutAll: ``@object3 ; nextPutAll: ``@object4';

                replace: '``@rcvr nextPutLine: ``@object1 , ``@object2 , ``@object3 , ``@object4' 
                   with: '``@rcvr nextPutAll: ``@object1; nextPutAll: ``@object2 ; nextPutAll: ``@object3 ; nextPutLine: ``@object4';

                replace: '``@rcvr show: ``@object1 , ``@object2' 
                   with: '``@rcvr show: ``@object1; show: ``@object2';

                replace: '``@rcvr showCR: ``@object1 , ``@object2' 
                   with: '``@rcvr show: ``@object1; showCR: ``@object2';

                replace: '``@rcvr show: ``@object1 , ``@object2 , ``@object3' 
                   with: '``@rcvr show: ``@object1; show: ``@object2; show: ``@object3';

                replace: '``@rcvr showCR: ``@object1 , ``@object2 , ``@object3' 
                   with: '``@rcvr show: ``@object1; show: ``@object2; showCR: ``@object2'.
! !

!RBCascadedNextPutAllsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

