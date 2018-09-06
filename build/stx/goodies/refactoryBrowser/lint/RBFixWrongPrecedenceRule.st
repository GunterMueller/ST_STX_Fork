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

RBTransformationRule subclass:#RBFixWrongPrecedenceRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBFixWrongPrecedenceRule class methodsFor:'documentation'!

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

!RBFixWrongPrecedenceRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
    ^ 'Wrong precedence with "includes:", "contains:" and "indexOf:"-like messages'
!

rationale
    ^ 'Rewrite 
<code><pre>    includes: expr not</pre></code> 
into:<code><pre>    (includes: expr) not</pre></code>"
<p>
and also:
<code><pre>    (expr and:[coll indexOf: e]) ~~ 0</pre></code> 
is rewritten to:
<code><pre>    (expr and:[ (coll indexOf: e) ~~ 0])</pre></code>
<p>
The later may be easily introduced, then existing code is augmented later
by an additional isNil/notNil/notEmpty check.'
! !

!RBFixWrongPrecedenceRule methodsFor:'initialization'!

initialize
        |checkIndexOfLike|

        checkIndexOfLike :=
            [ :node :owner :context|
                |e2|

                e2 := context at:(RBPatternVariableNode named:'`@expr2') ifAbsent:nil.
                e2 notNil 
                and:[
                    #(
                        #'indexOf:'         #'indexOf:startingAt:'
                        #'identityIndexOf:' #'identityIndexOf:startingAt:'
                        #'lastIndexOf:'     #'lastIndexOf:startingAt:'
                        #'findFirst:'       #'findFirst:startingAt:'
                        #'findLast:'        #'findLast:startingAt:'
                        #'findString:'      #'findString:startingAt:'
                    ) includes: e2 selector
                ]
            ].

        super initialize.
        self rewriteRule
                replace: '(``@collection includes: `@expr not)'
                with: '((``@collection includes: `@expr) not)';

                replace: '(``@collection contains: `@expr not)'
                with: '((``@collection contains: `@expr) not)';


                replace: '(``@expr1 and: [ `@expr2 ] ) ~= 0' 
                with: '(``@expr1 and: [ (`@expr2) ~= 0 ] )'
                when: checkIndexOfLike;

                replace: '(``@expr1 and: [ `@expr2 ] ) ~~ 0' 
                with: '(``@expr1 and: [ (`@expr2) ~~ 0 ] )'
                when: checkIndexOfLike;

                replace: '(``@expr1 and: [ `@expr2 ] ) = 0' 
                with: '(``@expr1 and: [ (`@expr2) = 0 ] )'
                when: checkIndexOfLike;

                replace: '(``@expr1 and: [ `@expr2 ] ) == 0' 
                with: '(``@expr1 and: [ (`@expr2) == 0 ] )'
                when: checkIndexOfLike.
! !

!RBFixWrongPrecedenceRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

