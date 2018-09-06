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

RBTransformationRule subclass:#RBNotEliminationRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBNotEliminationRule class methodsFor:'documentation'!

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

!RBNotEliminationRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
        ^ 'Eliminate unnecessary nots'

    "Modified: / 01-03-2012 / 19:07:31 / cg"
!

rationale
    ^ 'Eliminate unnecessary "<code>not</code>" messages. 
Also convert some "<code>ifFalse:</code>" forms into corresponding positive 
"<code>ifTrue:</code>" conditional constructs, 
<br>and "<code>select:</code>" into "<code>reject:</code>" messages.
<p>
For example, <code><pre>    expr isEmpty ifFalse:[...]</pre></code> 
is rewritten to: <code><pre>    expr notEmpty ifTrue:[...]</pre></code>
<br>
and <code><pre>    coll select:[ condition not ]</pre></code> 
to <code><pre>    coll reject:[ condition ]</pre></code>
<P>
Experience showed that positive conditionals are easier to read and understand.'

    "Created: / 01-03-2012 / 19:11:22 / cg"
!

severity
        ^ SeverityInformation
!

sourceIntervalForNode:aMatchedNode inTree:aParseTree source:fullSource
    "redefined, to only return the interval for the selector;
     not the whole expression node 
     (which may spawn many many lines if the block is large)."

    ^ aMatchedNode receiver start to:aMatchedNode selectorParts last stop.
    "/ ^ aMatchedNode selectorParts first start to:aMatchedNode selectorParts last stop.
    "/ ^ super sourceIntervalForNode:aMatchedNode inTree:aParseTree source:fullSource.
! !

!RBNotEliminationRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                replace: '``@object not not' 
                   with: '``@object';

                replace: '``@object not ifTrue: ``@block' 
                   with: '``@object ifFalse: ``@block';

                replace: '``@object not ifFalse: ``@block' 
                   with: '``@object ifTrue: ``@block';

                "/ begin added by cg: - we found positive if-conditions easier to read
                replace: '``@object notNil ifFalse: ``@block' 
                   with: '``@object isNil ifTrue: ``@block';

                replace: '``@object isNil ifFalse: ``@block'
                   with: '``@object notNil ifTrue: ``@block';

                replace: '``@object notEmpty ifFalse: ``@block'
                   with: '``@object isEmpty ifTrue: ``@block';

                replace: '``@object isEmpty ifFalse: ``@block'
                   with: '``@object notEmpty ifTrue: ``@block';

                replace: '``@object notEmptyOrNil ifFalse: ``@block'
                   with: '``@object isEmptyOrNil ifTrue: ``@block';

                replace: '``@object isEmptyOrNil ifFalse: ``@block'
                   with: '``@object notEmptyOrNil ifTrue: ``@block';

"/                replace: '( `@expr1 == `@expr2  ifFalse: `@ifNotEqExpr )'
"/                with: '( `@expr1 ~~ `@expr2  ifTrue: `@ifNotEqExpr )';

                replace: '( `@expr1 == `@expr2  ifFalse: `@ifNotEqExpr ifTrue: `@ifEqExpr )'
                with: '( `@expr1 ~~ `@expr2  ifTrue: `@ifNotEqExpr ifFalse: `@ifEqExpr)';

                replace: '( `@expr1 ~~ `@expr2  ifFalse: `@ifEqExpr )'
                with: '( `@expr1 == `@expr2  ifTrue: `@ifEqExpr )';

                replace: '( `@expr1 ~~ `@expr2  ifFalse: `@ifEqExpr ifTrue: `@ifNotEqExpr )'
                with: '( `@expr1 == `@expr2  ifTrue: `@ifEqExpr ifFalse: `@ifNotEqExpr)';

                replace: '( ( `@expr1 not and:[ `@expr2 not ] ) ifTrue: `@bothFalse )'
                with: '( ( `@expr1 or:[ `@expr2 ] ) ifFalse: `@bothFalse )';

                replace: '( ( `@expr1 not and:[ `@expr2 not ] ) ifFalse: `@notBothFalse )'
                with: '( ( `@expr1 or:[ `@expr2 ] ) ifTrue: `@notBothFalse )';

                replace: '( ( `@expr1 not and:[ `@expr2 not ] ) ifTrue: `@bothFalse ifFalse: `@notBothFalse )'
                with: '( ( `@expr1 or:[ `@expr2 ] ) ifFalse: `@bothFalse ifTrue: `@notBothFalse)';

                replace: '( ( `@expr1 not and:[ `@expr2 not ] ) ifFalse: `@notBothFalse ifTrue: `@bothFalse)'
                with: '( ( `@expr1 or:[ `@expr2 ] ) ifTrue: `@notBothFalse ifFalse: `@bothFalse)';
                "/ end added by cg:

                replace: '``@collection select: [:`each | | `@temps | ``@.Statements. ``@object not]'
                   with: '``@collection reject: [:`each | | `@temps | ``@.Statements. ``@object]';

                replace: '``@collection reject: [:`each | | `@temps | ``@.Statements. ``@object not]'
                   with: '``@collection select: [:`each | | `@temps | ``@.Statements. ``@object]';

                replace: '[| `@temps | ``@.Statements. ``@object not] whileTrue: ``@block'
                   with: '[| `@temps | ``@.Statements. ``@object] whileFalse: ``@block';

                replace: '[| `@temps | ``@.Statements. ``@object not] whileFalse: ``@block'
                   with: '[| `@temps | ``@.Statements. ``@object] whileTrue: ``@block';

                replace: '[| `@temps | ``@.Statements. ``@object not] whileTrue'
                   with: '[| `@temps | ``@.Statements. ``@object] whileFalse';

                replace: '[| `@temps | ``@.Statements. ``@object not] whileFalse'
                   with: '[| `@temps | ``@.Statements. ``@object] whileTrue';

                replace: '(``@a <= ``@b) not' 
                   with: '``@a > ``@b';

                replace: '(``@a < ``@b) not' 
                   with: '``@a >= ``@b';

                replace: '(``@a = ``@b) not' 
                   with: '``@a ~= ``@b';

                replace: '(``@a == ``@b) not' 
                   with: '``@a ~~ ``@b';

                replace: '(``@a ~= ``@b) not' 
                   with: '``@a = ``@b';

                replace: '(``@a ~~ ``@b) not'
                   with: '``@a == ``@b';

                replace: '(``@a >= ``@b) not'
                   with: '``@a < ``@b';

                replace: '(``@a > ``@b) not'
                   with: '``@a <= ``@b';

                replace: '``@object isEmpty not'
                   with: '``@object notEmpty';
                   
                replace: '``@object notEmpty not'
                   with: '``@object isEmpty';

                replace: '``@object isEmptyOrNil not'
                   with: '``@object notEmptyOrNil';

                replace: '``@object notEmptyOrNil not'
                   with: '``@object isEmptyOrNil';

                yourself    

    "Modified: / 01-03-2012 / 20:22:56 / cg"
! !

!RBNotEliminationRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

