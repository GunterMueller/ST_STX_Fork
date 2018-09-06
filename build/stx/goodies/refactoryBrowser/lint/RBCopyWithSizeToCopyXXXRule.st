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

RBTransformationRule subclass:#RBCopyWithSizeToCopyXXXRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBCopyWithSizeToCopyXXXRule class methodsFor:'documentation'!

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

!RBCopyWithSizeToCopyXXXRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
    ^ '"x copyFrom:n to:(x size)" -> "x copyFrom:n" (and removeFromIndex:toIndex:)'
!

rationale
    ^ '
If either index is 1 or the size of the collection, then code like: 
<code><pre>
    <I>collection</I> copyFrom:<I>idx</I> to:<I>collection</I> size</pre></code> 
can be simplified to:  
<code><pre>
    <I>aCollection</I> copyFrom:<I>idx</I>
</pre></code>
or even to: 
<code><pre>
    <I>aCollection</I> copy
</pre></code>
if the start index is 1.
<br>
Also, the last <I>n</I> elements can be copied with 
<code><pre>
    <I>aCollection</I> copyLast:<I>n</I>
</pre></code>
<P>Similar rewrites are possible for the <code>removeFromIndex:toIndex:</code> method family.
<P>
The alternatives are easier to read, and there may be tuned versions in the collection protocol.'
!

severity
        ^ SeverityInformation
! !

!RBCopyWithSizeToCopyXXXRule methodsFor:'initialization'!

initialize
        |computeLiteral|
        
        computeLiteral :=
            [:newNode |
                |arg1 arg1Rcvr|
                                
                "/ try to compute n1 + 1 here (if n is a constant)
                arg1 := newNode arg1.
                self assert:(arg1 isMessage).
                self assert:(arg1 selector = '+').
                self assert:(arg1 arg1 isLiteralInteger).
                ((arg1Rcvr := arg1 receiver) isLiteralInteger) ifTrue:[
                    |difference diffNode "tok"|
                    difference := arg1Rcvr value + arg1 arg1 value.
                    diffNode := RBLiteralNode literalToken: ("tok :=" RBLiteralToken value: difference).
                    newNode arguments at:1 put:diffNode.
                ].
                newNode
            ].
                
        super initialize.
        self rewriteRule
                replace: '( `@coll copyFrom:1 to:(`@coll size) )'
                with: '( `@coll copy )';

                replace: '( `@coll copyFrom:1 to:(`@coll size - `@n1) )'
                with: '(`@coll copyButLast:(`@n1) )';

                replace: '( `@coll copyFrom:(`@coll size - `@n1 + 1) )'
                with: '(`@coll copyLast:(`@n1) )';

                replace: '( `@coll copyFrom:(`@coll size - `@n1) )'
                with: '(`@coll copyLast:(`@n1 + 1) )'
                thenDo: computeLiteral;

                replace: '(`@coll copyFrom:`@n1 to:(`@coll size))'
                with: '(`@coll copyFrom:`@n1)';

                replace: '(`@coll copyFrom:(`@coll size - `@n1 + 1) to:(`@coll size))'
                with: '(`@coll copyLast:(`@n1) )';

                replace: '(`@coll copyFrom:(`@coll size + 1 - `@n1) to:(`@coll size))'
                with: '(`@coll copyLast:(`@n1) )';

                replace: '(`@coll copyFrom:(`@coll size - (`@n1 - 1)) to:(`@coll size))'
                with: '(`@coll copyLast:(`@n1) )';

                replace: '(`@coll copyFrom:(`@coll size - `@n1) to:(`@coll size))'
                with: '(`@coll copyLast:(`@n1 + 1) )'
                thenDo: computeLiteral;

                replace: '(`@coll copyTo:(`@coll size))'
                with: '(`@coll copy)';

                replace: '(`@coll removeFromIndex:`@n1 toIndex:(`@coll size))'
                with: '(`@coll removeFromIndex:`@n1)'.
! !

!RBCopyWithSizeToCopyXXXRule methodsFor:'running'!

checkMethod: aContext
    "/ skip methods which implement one of the transform targets.
    ( #( copy copyFrom: copyTo: copyFrom:to: copyButLast: shallowCopy ) includes: aContext selector) 
    ifTrue:[^ self].

    ( #( removeFromIndex: removeToIndex: ) includes: aContext selector) 
    ifTrue:[^ self].
    
    "/ skip implementations inside the collection hierarchy (there are some, which do it for speed).
    ( #( String CharacterArray OrderedCollection Text ) includes: aContext selectedClass theNonMetaclass name)
    ifTrue:[^ self].
    
    super checkMethod: aContext 
! !

!RBCopyWithSizeToCopyXXXRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

