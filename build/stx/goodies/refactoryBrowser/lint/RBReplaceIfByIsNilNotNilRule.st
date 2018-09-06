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

RBTransformationRule subclass:#RBReplaceIfByIsNilNotNilRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBReplaceIfByIsNilNotNilRule class methodsFor:'documentation'!

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

!RBReplaceIfByIsNilNotNilRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
    ^ 'Eliminate unnecessary ifs based on isNil/notNil'

    "Modified: / 19-11-2016 / 11:34:28 / cg"
!

rationale
    ^ 'Eliminate unnecessary "<code>if</code>" messages based on an isNil/notNil check.
<P>
Code like:<CODE><PRE>    expr isNil ifTrue:[^ false].
    ^ true</PRE></CODE>
is better written as:<CODE><PRE>    ^ expr notNil.</PRE></CODE>'

    "Created: / 01-03-2012 / 19:11:22 / cg"
    "Modified: / 19-11-2016 / 18:40:11 / cg"
!

severity
        ^ SeverityInformation
!

sourceIntervalForNode:aMatchedNode inTree:aParseTree source:fullSource
    "redefined, to only return the interval for the selector;
     not the whole expression node 
     (which may spawn many many lines if the block is large)."

    aMatchedNode isMethod ifTrue:[
        |last2|

        "/ only return the interval of the last statement
        "/ see my match-rules in initialize...
        last2 := aMatchedNode body statements last:2.
        ^ last2 first start to:last2 last stop
    ].

    ^ aMatchedNode receiver start to:aMatchedNode selectorParts last stop.
    "/ ^ aMatchedNode selectorParts first start to:aMatchedNode selectorParts last stop.
    "/ ^ super sourceIntervalForNode:aMatchedNode inTree:aParseTree source:fullSource.

    "Created: / 19-11-2016 / 13:23:36 / cg"
! !

!RBReplaceIfByIsNilNotNilRule methodsFor:'initialization'!

initialize
    super initialize.

    "/ you won't believe: I actually found some of those...
    self rewriteRule
        replace: '``@object isNil ifTrue:[^ false] ifFalse:[^ true]' 
           with: '^ ``@object notNil';

        replace: '``@object isNil ifFalse:[^ true] ifTrue:[^ false]' 
           with: '^ ``@object notNil';

        replace: '``@object isNil ifTrue:[^ true] ifFalse:[^ false]' 
           with: '^ ``@object isNil';

        replace: '``@object isNil ifFalse:[^ false] ifTrue:[^ true]' 
           with: '^ ``@object isNil';

        replace: '``@object notNil ifTrue:[^ true] ifFalse:[^ false]' 
           with: '^ ``@object notNil';

        replace: '``@object notNil ifFalse:[^ false] ifTrue:[^ true]' 
           with: '^ ``@object notNil';

        replace: '``@object notNil ifTrue:[^ false] ifFalse:[^ true]' 
           with: '^ ``@object isNil';

        replace: '``@object notNil ifFalse:[^ true] ifTrue:[^ false]' 
           with: '^ ``@object isNil';

        replaceMethod: '
            `@method: `@args
                | `@temps |
                `@.statements.
                ``@object notNil ifTrue:[^ true].
                ^ false'
        with: 
            '`@method: `@args
                | `@temps |
                `@.statements. 
                ^ ``@object notNil';

        replaceMethod: '
            `@method: `@args
                | `@temps |
                `@.statements.
                ``@object isNil ifTrue:[^ true].
                ^ false'
        with: 
            '`@method: `@args
                | `@temps |
                `@.statements. 
                ^ ``@object isNil';

        replaceMethod: '
            `@method: `@args
                | `@temps |
                `@.statements.
                ``@object notNil ifTrue:[^ false].
                ^ true'
        with: 
            '`@method: `@args
                | `@temps |
                `@.statements. 
                ^ ``@object isNil';

        replaceMethod: '
            `@method: `@args
                | `@temps |
                `@.statements.
                ``@object isNil ifTrue:[^ false].
                ^ true'
        with: 
            '`@method: `@args
                | `@temps |
                `@.statements. 
                ^ ``@object notNil';

"/ those are not needed; there is already another rule, which replaces
"/ 'expr == nil' with 'expr isNil'

"/        replace: '``@object == nil ifTrue:[^ false] ifFalse:[^ true]' 
"/           with: '^ ``@object notNil';
"/
"/        replace: '``@object == nil ifFalse:[^ true] ifTrue:[^ false]' 
"/           with: '^ ``@object notNil';
"/
"/        replace: '``@object == nil ifTrue:[^ true] ifFalse:[^ false]' 
"/           with: '^ ``@object isNil';
"/
"/        replace: '``@object == nil ifFalse:[^ false] ifTrue:[^ true]' 
"/           with: '^ ``@object isNil';
"/
"/        replace: '``@object ~~ nil ifTrue:[^ true] ifFalse:[^ false]' 
"/           with: '^ ``@object notNil';
"/
"/        replace: '``@object ~~ nil ifFalse:[^ false] ifTrue:[^ true]' 
"/           with: '^ ``@object notNil';
"/
"/        replace: '``@object ~~ nil ifTrue:[^ false] ifFalse:[^ true]' 
"/           with: '^ ``@object isNil';
"/
"/        replace: '``@object ~~ nil ifFalse:[^ true] ifTrue:[^ false]' 
"/           with: '^ ``@object isNil';
"/
"/        replace: '``@object == nil ifTrue:[^ false] ifFalse:[^ true]' 
"/           with: '^ ``@object notNil';
"/
"/        replace: '``@object = nil ifFalse:[^ true] ifTrue:[^ false]' 
"/           with: '^ ``@object notNil';
"/
"/        replace: '``@object = nil ifTrue:[^ true] ifFalse:[^ false]' 
"/           with: '^ ``@object isNil';
"/
"/        replace: '``@object = nil ifFalse:[^ false] ifTrue:[^ true]' 
"/           with: '^ ``@object isNil';
"/
"/        replace: '``@object ~= nil ifTrue:[^ true] ifFalse:[^ false]' 
"/           with: '^ ``@object notNil';
"/
"/        replace: '``@object ~= nil ifFalse:[^ false] ifTrue:[^ true]' 
"/           with: '^ ``@object notNil';
"/
"/        replace: '``@object ~= nil ifTrue:[^ false] ifFalse:[^ true]' 
"/           with: '^ ``@object isNil';
"/
"/        replace: '``@object ~= nil ifFalse:[^ true] ifTrue:[^ false]' 
"/           with: '^ ``@object isNil';

        yourself

    "Modified: / 19-11-2016 / 13:15:46 / cg"
! !

!RBReplaceIfByIsNilNotNilRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

