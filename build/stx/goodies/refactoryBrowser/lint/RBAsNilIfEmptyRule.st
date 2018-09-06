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

RBTransformationRule subclass:#RBAsNilIfEmptyRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBAsNilIfEmptyRule class methodsFor:'documentation'!

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

!RBAsNilIfEmptyRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
        ^ 'Simplifies expression to use asNilIfEmpty'
!

rationale
        ^ 'Can replace conditional expressions to use "<code>asNilIfEmpty</code>"'
!

severity
        ^ SeverityInformation
! !

!RBAsNilIfEmptyRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule 
                replace: '``@object isEmpty ifTrue:[nil] ifFalse:[``@object]' 
                with: '``@object asNilIfEmpty'
                when: [ :node |  
                    node receiver receiver isMessage not 
                ];

                replace: '``@object notEmpty ifTrue:[``@object] ifFalse:[nil]' 
                with: '``@object asNilIfEmpty'
                when: [ :node |  
                    node receiver receiver isMessage not 
                ];

                replace: '``@object isEmpty ifFalse:[``@object] ifTrue:[nil]' 
                with: '``@object asNilIfEmpty'
                when: [ :node | 
                    node receiver receiver isMessage not 
                ];

                replace: '``@object notEmpty ifFalse:[nil] ifTrue:[``@object]' 
                with: '``@object asNilIfEmpty'
                when: [ :node |  
                    node receiver receiver isMessage not 
                ];

                replace: '`var isEmpty ifTrue:[ `var := nil ]' 
                with: '`var := `var asNilIfEmpty';

                replace: '`var notEmpty ifFalse:[ `var := nil ]' 
                with: '`var := `var asNilIfEmpty';

                yourself
! !

!RBAsNilIfEmptyRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

