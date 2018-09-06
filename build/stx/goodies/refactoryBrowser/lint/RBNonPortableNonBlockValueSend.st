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

RBTransformationRule subclass:#RBNonPortableNonBlockValueSend
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBNonPortableNonBlockValueSend class methodsFor:'documentation'!

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

!RBNonPortableNonBlockValueSend methodsFor:'accessing'!

group
        ^ 'Portability Issues'
!

name
    ^ 'Portability problem / Possible Bug with non-block argument to "at:ifAbsent:" and similar messages'
!

rationale
        ^ 'Portability:
<br>
ST/X, VisualWorks, Dolphin and Squeak implement a #value message in Object,
which allows for a non block argument (typically a constant) to be passed as second argument
to <code>#at:ifAbsent:</code>, <code>#detect:ifNone:</code> and similar messages.
<P>The same is true for <code>#ifXXX:</code> messages, where non-block arguments
can assume that the #value message is understood.
<P>
Such code does not work in old Smalltalk dialects (such as VSE).
<P>
Possible Bug:
<br>
Be aware that there is a slight danger of getting an unexpected result, 
if the object does in fact implement "#value" and that method does not return "self".
<br>
Two examples for this are Associations and ValueHolders (and of course: blocks).
In this case, it does make a difference, and you will get the association/valueholder/block 
with "...:[ foo ]" whereas you will get its (internal) value with "...:foo".
<br>To avoid confusion, we recommend using a block argument in any case, 
and add an explicit #value inside (i.e. change to "...:[ foo value]"), if that is your intention.'
!

severity
        ^ SeverityInformation
!

tagsBasic
    ^ #( 
        portability 
        vse 
    )
! !

!RBNonPortableNonBlockValueSend methodsFor:'initialization'!

initialize
    |"isNonBlockArg1" isNonBlockArg2 isNonBlockArg3 isNonBlockArg4 
     isLiteralArg1 isLiteralArg2 areBothLiteralArgs12 "areBothNonBlockArgs12"|

    isLiteralArg1 := [:node | node arguments first isLiteral ].
    isLiteralArg2 := [:node | node arguments second isLiteral ].
    areBothLiteralArgs12 := [:node | node arguments first isLiteral
                                      and:[ node arguments second isLiteral ] ].

    "/ isNonBlockArg1 := [:node | node arguments first isBlock not ].
    isNonBlockArg2 := [:node | node arguments second isBlock not ].
    isNonBlockArg3 := [:node | node arguments third isBlock not ].
    isNonBlockArg4 := [:node | node arguments fourth isBlock not ].
    "/ areBothNonBlockArgs12 := [:node | node arguments first isBlock not
    "/                                  and:[ node arguments second isBlock not ] ].
    
    super initialize.

    self rewriteRule
        replace: '``@boolean ifTrue: ``@expr1 ifFalse: ``@expr2'
        with:    '``@boolean ifTrue: [``@expr1] ifFalse: ``@expr2'
        when:isLiteralArg1 "isNonBlockArg1";

        replace: '``@boolean ifFalse: ``@expr1 ifTrue: ``@expr2'
        with:    '``@boolean ifFalse: [``@expr1] ifTrue: ``@expr2'
        when:isLiteralArg1 "isNonBlockArg1";

        replace: '``@boolean ifTrue: ``@expr1 ifFalse: ``@expr2'
        with:    '``@boolean ifTrue: ``@expr1 ifFalse: [``@expr2 ]'
        when:isLiteralArg2 "isNonBlockArg2";

        replace: '``@boolean ifFalse: ``@expr1 ifTrue: ``@expr2'
        with:    '``@boolean ifFalse: ``@expr1 ifTrue: [``@expr2 ]'
        when:isLiteralArg2 "isNonBlockArg2";

        replace: '``@boolean ifTrue: ``@expr1 ifFalse: ``@expr2'
        with:    '``@boolean ifTrue: [``@expr1] ifFalse: [``@expr2 ]'
        when:areBothLiteralArgs12 "areBothNonBlockArgs12";

        replace: '``@boolean ifFalse: ``@expr1 ifTrue: ``@expr2'
        with:    '``@boolean ifFalse: [``@expr1] ifTrue: [``@expr2 ]'
        when:areBothLiteralArgs12 "areBothNonBlockArgs12";

        replace: '``@collection at: ``@key ifAbsent: ``@object'
        with:    '``@collection at: ``@key ifAbsent: [``@object ]'
        when:isNonBlockArg2;

        replace: '``@collection atIndex: ``@key ifAbsent: ``@object'
        with:    '``@collection atIndex: ``@key ifAbsent: [``@object ]'
        when:isNonBlockArg2;

        replace: '``@coll identityIndexOf: ``@el ifAbsent: ``@object'
        with:    '``@coll identityIndexOf: ``@el ifAbsent: [``@object ]'
        when:isNonBlockArg2;

        replace: '``@coll identityIndexOf: ``@el startingAt: ``@start ifAbsent: ``@object'
        with:    '``@coll identityIndexOf: ``@el startingAt: ``@start ifAbsent: [``@object ]'
        when:isNonBlockArg3;

        replace: '``@coll lastIdentityIndexOf: ``@el ifAbsent: ``@object'
        with:    '``@coll lastIdentityIndexOf: ``@el ifAbsent: [``@object ]'
        when:isNonBlockArg2;

        replace: '``@coll lastIdentityIndexOf: ``@el startingAt: ``@start ifAbsent: ``@object'
        with:    '``@coll lastIdentityIndexOf: ``@el startingAt: ``@start ifAbsent: [``@object ]'
        when:isNonBlockArg3;

        replace: '``@coll indexOf: ``@el ifAbsent: ``@object'
        with:    '``@coll indexOf: ``@el ifAbsent: [``@object ]'
        when:isNonBlockArg2;

        replace: '``@coll indexOf: ``@el startingAt: ``@start ifAbsent: ``@object'
        with:    '``@coll indexOf: ``@el startingAt: ``@start ifAbsent: [``@object ]'
        when:isNonBlockArg3;

        replace: '``@coll indexOfAny: ``@el startingAt: ``@start ifAbsent: ``@object'
        with:    '``@coll indexOfAny: ``@el startingAt: ``@start ifAbsent: [``@object ]'
        when:isNonBlockArg3;

        replace: '``@coll indexOfAnyOf: ``@el startingAt: ``@start ifAbsent: ``@object'
        with:    '``@coll indexOfAnyOf: ``@el startingAt: ``@start ifAbsent: [``@object ]'
        when:isNonBlockArg3;

        replace: '``@coll lastIndexOf: ``@el ifAbsent: ``@object'
        with:    '``@coll lastIndexOf: ``@el ifAbsent: [``@object ]'
        when:isNonBlockArg2;

        replace: '``@coll lastIndexOf: ``@el startingAt: ``@start ifAbsent: ``@object'
        with:    '``@coll lastIndexOf: ``@el startingAt: ``@start ifAbsent: [``@object ]'
        when:isNonBlockArg3;

        replace: '``@coll nextIndexOf: ``@el from: ``@start to: ``@stop ifAbsent: ``@object'
        with:    '``@coll nextIndexOf: ``@el from: ``@start to: ``@stop ifAbsent: [``@object ]'
        when:isNonBlockArg4;

        replace: '``@coll prevIndexOf: ``@el from: ``@start to: ``@stop ifAbsent: ``@object'
        with:    '``@coll prevIndexOf: ``@el from: ``@start to: ``@stop ifAbsent: [``@object ]'
        when:isNonBlockArg4;

        replace: '``@coll detect: ``@check ifNone: ``@object'
        with:    '``@coll detect: ``@check ifNone: [``@object ]'
        when:isNonBlockArg2;

        replace: '``@coll detect: ``@check startingAt: ``@start ifNone: ``@object'
        with:    '``@coll detect: ``@check startingAt: ``@start ifNone: [``@object ]'
        when:isNonBlockArg3;

        replace: '``@coll findFirst: ``@check ifNone: ``@object'
        with:    '``@coll findFirst: ``@check ifNone: [``@object ]'
        when:isNonBlockArg2;

        replace: '``@coll findLast: ``@check ifNone: ``@object'
        with:    '``@coll findLast: ``@check ifNone: [``@object ]'
        when:isNonBlockArg2.
! !

!RBNonPortableNonBlockValueSend methodsFor:'running'!

checkMethod: aContext
    "do not check code in the basic st/x packages.
     We do not care for this portability here"
     
    (aContext compiledMethod package startsWith:'stx:lib') ifTrue:[
        ^ nil
    ].    
    ^ super checkMethod:aContext.
! !

!RBNonPortableNonBlockValueSend class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

