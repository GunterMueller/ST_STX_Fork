"{ Encoding: utf8 }"

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

RBTransformationRule subclass:#RBCopyEliminationRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBCopyEliminationRule class methodsFor:'documentation'!

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

!RBCopyEliminationRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
    ^ '"(a copyFrom:1 to:n) = b" -> "a startsWith:b"'
!

rationale
    ^ '
Eliminate copy operations if they are used to compare slices of a collection 
against another collection. 
Code like: 
<code><pre>    (collection copyFrom:1 to:3) = ''abc''</pre></code>
and:
<code><pre>    (collection copyTo:3) = ''abc''</pre></code> 
can be simplified to  
<code><pre>    aCollection startsWith:''abc''</pre></code>
<P>
Also,
<code><pre>    (collection copyLast:3) = ''abc''</pre></code> 
is better written as:
<code><pre>    aCollection endsWith:''abc''</pre></code>
<P>
The alternative code avoids the creation of a temporary throw-away collection.'

    "Modified: / 16-11-2016 / 23:41:02 / cg"
!

severity
        ^ SeverityInformation
! !

!RBCopyEliminationRule methodsFor:'initialization'!

initialize
    |rule checkAction|

    super initialize.
    
    rule := self rewriteRule.

    "/ beginners tend to write stuff like this: 
    "/      (k copyFrom:1 to:3) = 'MAC'
    checkAction :=
        [ :node | 
            |ok comparedCollectionArg copyExpr copyExprArg2|

            ok := false.
            comparedCollectionArg := node arg1.
            (comparedCollectionArg isLiteralString 
              or:[comparedCollectionArg isLiteralByteArray
              or:[comparedCollectionArg isLiteralArray]]
            ) ifTrue:[
                copyExpr := node receiver.
                copyExprArg2 := copyExpr arguments at:2.
                copyExprArg2 isLiteralInteger ifTrue:[
                    "endindex = size of collection?"
                    ok := copyExprArg2 value = comparedCollectionArg value size.    
                ]
            ].
            ok
        ].

    rule
        replace: '( ( `@coll copyFrom:1 to:`@n1 ) = `@expr )' 
        with: '( `@coll startsWith: `@expr )'
        when: checkAction.

    checkAction :=
        [ :node | 
            |ok comparedCollectionArg copyExpr copyExprArg1|

            ok := false.
            comparedCollectionArg := node arg1.
            (comparedCollectionArg isLiteralString 
              or:[comparedCollectionArg isLiteralByteArray
              or:[comparedCollectionArg isLiteralArray]]
            ) ifTrue:[
                copyExpr := node receiver.
                copyExprArg1 := copyExpr arguments at:1.
                copyExprArg1 isLiteralInteger ifTrue:[
                    "endindex = size of collection?"
                    ok := copyExprArg1 value = comparedCollectionArg value size.    
                ]
            ].
            ok
        ].

    "/ or:
    "/      (k copyTo:3) = 'MAC'
    rule
        replace: '( ( `@coll copyTo:`@n1 ) = `@expr )' 
        with: '( `@coll startsWith: `@expr )'
        when: checkAction.

    "/ or:
    "/      (k copyLast:3) = 'MAC'
    rule
        replace: '( ( `@coll copyLast:`@n1 ) = `@expr )' 
        with: '( `@coll endsWith: `@expr )'
        when: checkAction.

    "Modified: / 16-11-2016 / 23:37:09 / cg"
! !

!RBCopyEliminationRule methodsFor:'running'!

checkMethod: aContext
    "/ quick check for the method's sent messages.
    
    super checkMethod: aContext. 
! !

!RBCopyEliminationRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

