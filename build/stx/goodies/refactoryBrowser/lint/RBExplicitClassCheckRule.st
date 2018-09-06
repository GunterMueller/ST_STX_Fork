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

RBParseTreeLintRule subclass:#RBExplicitClassCheckRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBExplicitClassCheckRule class methodsFor:'documentation'!

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

!RBExplicitClassCheckRule methodsFor:'accessing'!

group
    "/ result class == Array ifTrue:[^ 'xxx'].
        ^ 'Miscellaneous'
!

name
        ^ 'Explicit class check instead of "isXXX"'
!

rationale
        ^ 'Explicit comparison against an object''s class may limit later reuse of
your code, as it breaks the duckTyping principle, that any object can take a role
if it implements the protocol - not when they inherit or are member of a particular
class. 
<br>For example, in testing the class via #class or #iskindOf:, 
you make it impossible to use your code with mimicri objects,
wrappers, debugging-mock objects, facade-players and maybe future extension objects 
coming from third parties.
<P>
Instead of checking with<PRE><CODE>    obj class == Foo</CODE></PRE>
or <PRE><CODE>    obj isKindOf: Foo</CODE></PRE>you should define a test method in Object as <CODE><PRE>    isFoo
        ^ false
</PRE></CODE>
and redefne in your Foo-class to return true.
<br>
Then use "<code>obj isFoo</code>" instead.'
! !

!RBExplicitClassCheckRule methodsFor:'initialization'!

initialize
    |checkIfBehavior|
    
    super initialize.

    checkIfBehavior :=
        [:varNode |
            |varName val|
            
            varName := varNode name asSymbolIfInterned.
            varName notNil
            and:[ (val := Smalltalk at:varName) notNil 
            and:[ val isBehavior]]
        ].
    "/ should find these, when uncommented:    
    "/      checkIfBehavior class == Array.    
    "/      checkIfBehavior isKindOf: Array.    
    "/      checkIfBehavior class == Array.    
    self matcher 
        matchesAnyOf: #(
                '`@expr class == `V'
                '`@expr class = `V'
                '`@expr class ~~ `V'
                '`@expr class ~= `V'

                '`V == `@expr class'
                '`V = `@expr class'
                '`V ~~ `@expr class'
                '`V ~= `@expr class'

                '`@expr isMemberOf: `V'
                '`@expr isKindOf: `V'
                '`@expr class isSubclassOf: `V'
                '`@expr class inheritsFrom: `V'
                '`@expr class includesBehavior: `V'
                )
        do: [:node :answer| 
            |rslt varNode exprNode allowThis|

            allowThis := false.
            
            "/ rslt := answer.
            "/ cg: the answer isNil check has the consequence of only finding the 
            "/     very first occurrence in the source.
            "/     Why was this done?
            true "answer isNil" ifTrue:[
                matcher context isEmptyOrNil ifTrue:[
                    "/ I have no idea, how this happens; but it does.
                    "/ hack: extract varNode from the node
                    (node selector == #'==') ifTrue:[
                        (node receiver isVariable) ifTrue:[
                            varNode := node receiver.
                            exprNode := node arg1 receiver.
                        ] ifFalse:[
                            varNode := node arg1.
                            exprNode := node receiver receiver.
                        ].    
                    ] ifFalse:[
                        varNode := node arg1.
                        exprNode := node receiver.
                        exprNode isMessage ifTrue:[
                            exprNode := exprNode receiver
                        ].    
                    ].
                ] ifFalse:[    
                    varNode := matcher context at:(RBPatternVariableNode named:'`V').
                    exprNode := matcher context at:(RBPatternVariableNode named:'`@expr').
                ].
                "/ allow "self class == foo", for isXXX kind of queries
                (node selector == #'==' and:[exprNode isSelf]) ifTrue:[
                    "/ 
                    allowThis := true.
                ].
                allowThis ifFalse:[
                    (checkIfBehavior value:varNode) ifTrue:[
                        rslt := node
                    ].    
                ].    
            ].
            rslt.
        ]
! !

!RBExplicitClassCheckRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

