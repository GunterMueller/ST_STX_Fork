"
 Copyright (C) 2013 Claus Gittinger

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

RBParseTreeLintRule subclass:#RBMultipleDependenciesRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBMultipleDependenciesRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2013 Claus Gittinger

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

!RBMultipleDependenciesRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'

    "Modified: / 31-07-2013 / 14:15:24 / cg"
!

name
        ^ 'Installs multiple dependencies on the same object'

    "Modified: / 31-07-2013 / 14:15:51 / cg"
!

rationale
        ^ 'Checks for "<code>addDependent:</code>" / "<code>onChangeSend:to:</code>" messages to
the same dependent object, possibly leading to multiple update notifications.'

    "Modified: / 31-07-2013 / 14:16:54 / cg"
! !

!RBMultipleDependenciesRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(

                        '| `@temps | 
                                `.@beforeStatements.
                                `@something addDependent:self.
                                `@.Statements. 
                                `@something onChangeSend: `#selector to: self.
                                `.@afterStatements
                        ' 

                        '| `@temps | 
                                `.@beforeStatements.
                                `@something onChangeSend: `#selector to: self. 
                                `@.Statements. 
                                `@something addDependent:self.
                                `.@afterStatements
                        ' 


                        '| `@temps | 
                                `.@beforeStatements.
                                `@something onChangeSend: `#selector1 to: self. 
                                `@.Statements. 
                                `@something onChangeSend: `#selector2 to: self.
                                `.@afterStatements
                        ' 


                        '| `@temps | 
                                `.@beforeStatements.
                                `@something addDependent:self.
                                `@.Statements. 
                                `@something addDependent:self.
                                `.@afterStatements
                        ' 

                )
                do: [ :node :answer | node]

    "Modified: / 31-07-2013 / 17:57:41 / cg"
!

initialize1
        super initialize.
        self matcher 
                matchesAnyMethodOf: #(
                        '`@MethodName: `@args 
                                | `@temps | 
                                `@.Statements. 
                                `@something addDependent:self.
                                `@.Statements. 
                                `@something onChangeSend: `#selector to: self.' 

                        '`@MethodName: `@args 
                                | `@temps | 
                                `@.Statements. 
                                `@something onChangeSend: `#selector to: self. 
                                `@.Statements. 
                                `@something addDependent:self.'

                        '`@MethodName: `@args 
                                | `@temps | 
                                `@.Statements. 
                                `@something onChangeSend: `#selector1 to: self. 
                                `@.Statements. 
                                `@something onChangeSend: `#selector2 to: self.' 

                        '`@MethodName: `@args 
                                | `@temps | 
                                `@.Statements. 
                                `@something addDependent:self.
                                `@.Statements. 
                                `@something addDependent:self.'
                )
                do: [ :node :answer | 
                        answer isNil 
                                ifTrue: [ node body statements last ]
                                ifFalse: [ answer ] ]

    "Created: / 31-07-2013 / 17:51:28 / cg"
! !

!RBMultipleDependenciesRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

