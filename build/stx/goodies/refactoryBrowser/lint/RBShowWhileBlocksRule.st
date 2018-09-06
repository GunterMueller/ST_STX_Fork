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

RBTransformationRule subclass:#RBShowWhileBlocksRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBShowWhileBlocksRule class methodsFor:'documentation'!

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

!RBShowWhileBlocksRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
        ^ 'Move assignment out of "showWhile:" blocks'

    "Modified: / 07-04-2012 / 13:12:27 / cg"
!

rationale
        ^ 'Moves an assignment or return out of "<code>showWhile:</code>" blocks.
E.g. replaces<CODE><PRE>    someCursor showWhile:[ ... var := expr. ]</PRE></CODE>
with: <CODE><PRE>    var := someCursor showWhile:[ ... ]</PRE></CODE>'

    "Modified: / 07-04-2012 / 13:12:27 / cg"
! !

!RBShowWhileBlocksRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                replace: '``@cursor showWhile: [| `@temps | ``@.Statements. `var := ``@object]'
                        with: '`var := ``@cursor showWhile: [| `@temps | ``@.Statements. ``@object]';

                replace: '``@cursor showWhile: [| `@temps | ``@.Statements. ^``@object]'
                        with: '^``@cursor showWhile: [| `@temps | ``@.Statements. ``@object]'
! !

!RBShowWhileBlocksRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBShowWhileBlocksRule.st,v 1.4 2014-11-28 20:11:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBShowWhileBlocksRule.st,v 1.4 2014-11-28 20:11:08 cg Exp $'
!

version_SVN
    ^ '$Id: RBShowWhileBlocksRule.st,v 1.4 2014-11-28 20:11:08 cg Exp $'
! !

