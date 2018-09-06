"
 Copyright (C) 2016 Claus Gittinger

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

RBTransformationRule subclass:#RBTempVarEliminationRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBTempVarEliminationRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2016 Claus Gittinger

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

!RBTempVarEliminationRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
    ^ 'Eliminate unnecessary temporary variables'

    "Modified: / 19-11-2016 / 13:17:42 / cg"
!

rationale
    ^ 'Eliminate unnecessary temporary variables used with isNil/notNil checks.'

    "Created: / 01-03-2012 / 19:11:22 / cg"
    "Modified: / 19-11-2016 / 13:18:16 / cg"
!

severity
        ^ SeverityInformation
! !

!RBTempVarEliminationRule methodsFor:'initialization'!

initialize
    super initialize.

    self rewriteRule

        replaceMethod: '
            `@method: `@args
                | `temp |
                `@.statements.
                `temp := ``@expr.
                ^ `temp isNil'
        with: 
            '`@method: `@args
    `@.statements.
    ^ ``@expr isNil';

        replaceMethod: '
            `@method: `@args
                | `temp |
                `@.statements.
                `temp := ``@expr.
                ^ `temp notNil'
        with: 
            '`@method: `@args
    `@.statements.
    ^ ``@expr notNil';

        replaceMethod: '
            `@method: `@args
                | `temp |
                `@.statements.
                `temp := ``@expr1.
                ^ `temp == ``@expr2'
        with: 
            '`@method: `@args
    `@.statements.
    ^ ``@expr1 == ``@expr2';

        replaceMethod: '
            `@method: `@args
                | `temp |
                `@.statements.
                `temp := ``@expr1.
                ^ `temp ~~ ``@expr2'
        with: 
            '`@method: `@args
    `@.statements.
    ^ ``@expr1 ~~ ``@expr2';

        yourself

    "Modified: / 19-11-2016 / 18:50:58 / cg"
!

sourceIntervalForNode:aMatchedNode inTree:aParseTree source:fullSource
    |body|

    "/ only return the interval of the body
    body := aMatchedNode body.
    ^ body start to:body stop

    "Created: / 19-11-2016 / 13:42:10 / cg"
! !

!RBTempVarEliminationRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

