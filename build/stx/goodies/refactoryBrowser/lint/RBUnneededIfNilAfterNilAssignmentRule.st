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

RBTransformationRule subclass:#RBUnneededIfNilAfterNilAssignmentRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBUnneededIfNilAfterNilAssignmentRule class methodsFor:'documentation'!

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

!RBUnneededIfNilAfterNilAssignmentRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name
        ^ 'Avoid unneeded isNil checks after assignment of nil'
!

rationale
        ^ 'Eliminates an isNil check after an assignment of nil.
<br>This should make the code a bit more readable.'
! !

!RBUnneededIfNilAfterNilAssignmentRule methodsFor:'initialization'!

initialize
        super initialize.

        self rewriteRule
                replace:'
``@.PreStatements.
``@condExpr ifTrue:[
    ``@.Statements1.
    `var := ``@assignedExpr
] ifFalse:[
    `var := nil
].
`var notNil ifTrue:[
    ``@.Statements2.
].
``@.PostStatements.
'
                with:'
``@.PreStatements.
``@condExpr ifTrue:[
    ``@.Statements1.
    `var := ``@assignedExpr.
    `var notNil ifTrue:[
        ``@.Statements2.
    ].
] ifFalse:[
    `var := nil
].
``@.PostStatements.
'.

        "inspired by the following code:

                dialog accepted ifTrue:[
                    rule := dialog selectionAsRule
                ] ifFalse:[
                    rule := nil.
                ].
                rule notNil ifTrue:[
                    rule := rule copy.
                    self smalllintRunRule:rule onEnvironment:rbenvironment.
                ].

        "
! !

!RBUnneededIfNilAfterNilAssignmentRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

