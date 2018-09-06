"
 Copyright (C) 2014 Claus Gittinger

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

RBTransformationRule subclass:#RBOldStyleMessagesRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBOldStyleMessagesRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2014 Claus Gittinger

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

!RBOldStyleMessagesRule methodsFor:'accessing'!

group
        ^ 'Portability Issues'
!

name
        ^ 'Replace oldStyle messages with ANSI conform equivalents'
!

rationale
        ^ 'Some messages like "<code>valueOnUnwindDo:</code>", "<code>valueNowOrOnUnwindDo:</code>",
"<code>handle:do:</code>" and others have been standardized with different names and argument order
in the ANSI Smalltalk standard, after they have been around for years in VisualWorks and Smalltalk/X. 
<P>
Although the old forms are (and will always be) still supported,
your program is more portable to other Smalltalk dialects, if the new forms are used.'
!

severity
        ^ SeverityInformation
! !

!RBOldStyleMessagesRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                replace: '[| `@temps | ``@.Statements. ] valueNowOrOnUnwindDo: ``@block'
                    "->"
                   with: '[| `@temps | ``@.Statements. ] ensure: ``@block';

                replace: '[| `@temps | ``@.Statements. ] valueOnUnwindDo: ``@block'
                    "->"
                   with: '[| `@temps | ``@.Statements. ] ifCurtailed: ``@block';

                replace:'``@err handle:``@handler do: ``@expr'
                    "->"
                   with: '``@expr on: ``@err do: ``@handler'
! !

!RBOldStyleMessagesRule methodsFor:'running'!

shouldIgnoreClass:selectedClass selector:selector
    "do not check code in the basic st/x packages.
     We do not care for this portability here"

    (selectedClass package startsWith:'stx:lib') ifTrue:[
        ^ true
    ].    
    ^ super shouldIgnoreClass:selectedClass selector:selector.
! !

!RBOldStyleMessagesRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

