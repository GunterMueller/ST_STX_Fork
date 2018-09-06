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

RBTransformationRule subclass:#RBAtIfAbsentRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBAtIfAbsentRule class methodsFor:'documentation'!

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

!RBAtIfAbsentRule methodsFor:'accessing'!

group
        ^ 'Transformations'

    "Modified: / 01-03-2012 / 08:14:52 / cg"
!

name
    ^ '"at:ifAbsent:" -> "at:ifAbsentPut:"'

    "Modified: / 04-08-2011 / 17:45:12 / cg"
!

rationale
        ^ 'The use of <code>#at:ifAbsentPut:</code> leads to more readable and faster code.'
!

severity
        ^ SeverityInformation
! !

!RBAtIfAbsentRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                replace: '``@dictionary at: ``@key ifAbsent: [
                            | `@temps | 
                            ``@.Statements1.
                            ``@dictionary at: ``@key put: ``@object.
                            ``@.Statements2.
                            ``@object]'
                with: '``@dictionary at: ``@key ifAbsentPut: [
                            | `@temps |
                            ``@.Statements1.
                            ``@.Statements2.
                            ``@object]';

                replace: '``@dictionary at: ``@key ifAbsent: [
                            | `@temps |
                            ``@.Statements.
                            ``@dictionary at: ``@key put: ``@object]'
                with: '``@dictionary at: ``@key ifAbsentPut: [
                            | `@temps |
                            ``@.Statements.
                            ``@object]';

                replace: '`var := ``@dictionary at: ``@key ifAbsent: [ nil ].
                          `var isNil ifTrue:[
                            ``@dictionary at: ``@key put: ``@object.
                          ]'  
                with: '`var := ``@dictionary at: ``@key ifAbsentPut: [ ``@object ]'
! !

!RBAtIfAbsentRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

