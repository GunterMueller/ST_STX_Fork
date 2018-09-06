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

RBTransformationRule subclass:#RBUseBindWithRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBUseBindWithRule class methodsFor:'documentation'!

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

!RBUseBindWithRule class methodsFor:'tagging'!

tagsBasic
    "this rule is broken; it suggests highly unefficient replacements"

    ^#( #broken )
! !

!RBUseBindWithRule methodsFor:'accessing'!

group
        ^ 'Transformations'

    "Modified: / 01-03-2012 / 08:14:47 / cg"
!

name
        ^ 'Use bindWith: to construct textual messages with embedded printstrings'
!

rationale
        ^ 'When generating textual messages with embedded printstrings,
it is more efficient to use "<code>bindWith:</code>"
instead of concatenating the strings. 
<P>
Concatenation is harder to read and also may also create additional 
garbage objects with a non-linear time and space complexity.
<P>Rewrites messages similar to:<CODE><PRE>    (''..'' , obj printString, ''..'')</PRE></CODE> 
into:<CODE><PRE>    ''..%1..'' bindWith: obj</PRE></CODE>.'
! !

!RBUseBindWithRule methodsFor:'initialization'!

initialize
        |rewriteString|

        rewriteString :=
            [:newNode |
                |commaExpr commaExprReceiver|

                "/ compute concatenated literal string
                commaExpr := newNode receiver.
                self assert:(commaExpr isMessageWithSelector:#',').
                
                commaExprReceiver := commaExpr receiver.

                "/ convert: (('string1' , 'string2') , more) -> ('string1string2' , more)
                ((commaExprReceiver isMessageWithSelector:#',')
                    and:[ (commaExprReceiver receiver isLiteralString) 
                    and:[ (commaExprReceiver arg1 isLiteralString)
                ]]) ifTrue:[
                    |s1 s2 newString1 newCommaExpr|
                    s1 := commaExprReceiver receiver value.
                    s2 := commaExprReceiver arg1 value.
                    newString1 := s1,s2.
                    commaExpr arg1 isLiteralString ifTrue:[
                        newString1 := newString1,commaExpr arg1 value.
                        newNode receiver:(RBLiteralNode literalToken:("tok :=" RBLiteralToken value:newString1)).
                    ] ifFalse:[    
                        newCommaExpr := commaExpr copy.
                        newCommaExpr receiver:(RBLiteralNode literalToken:("tok :=" RBLiteralToken value:newString1)).
                        newNode receiver:newCommaExpr.
                    ].
                ] ifFalse:[
                    "/ convert: ((more , 'string2') , 'string3') -> (more , 'string2string3')
                    ((commaExprReceiver isMessageWithSelector:#',')
                        and:[ (commaExprReceiver arg1 isLiteralString)
                        and:[ commaExpr arg1 isLiteralString
                    ]]) ifTrue:[
                        |s2 s3 newString newCommaExpr|
                        s2 := commaExprReceiver arg1 value.
                        s3 := commaExpr arg1 value.
                        newString := s2,s3.
                        newCommaExpr := commaExpr copy.
                        newCommaExpr receiver:commaExprReceiver receiver copy.
                        newCommaExpr arg1:(RBLiteralNode literalToken:("tok :=" RBLiteralToken value:newString)).
                        newNode receiver:newCommaExpr.
                    ] ifFalse:[
                        self breakPoint:#cg.
                        "/ self halt.
                    ].    
                ].    
                newNode
            ].

        super initialize.
        self rewriteRule
                replace: '( ``@string1 , ``@object printString , ``@string2 )' 
                   with: '( (``@string1 , ''<%1>'', ``@string2) bindWith: ``@object )'
                 thenDo: rewriteString;

                replace: '( ``@string1 , ``@object asString , ``@string2 )' 
                   with: '( (``@string1 , ''<%1>'', ``@string2) bindWith: ``@object )'
                 thenDo: rewriteString;
                 
"/                replace: '( ``@string1 , ``@object , ``@string2 )' 
"/                   with: '( (``@string1 , ''<%1>'', ``@string2) bindWith: ``@object )'
"/                 thenDo: rewriteString;
                yourself.
! !

!RBUseBindWithRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

