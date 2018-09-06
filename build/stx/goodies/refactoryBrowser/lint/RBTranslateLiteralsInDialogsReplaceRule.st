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

RBTransformationRule subclass:#RBTranslateLiteralsInDialogsReplaceRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBTranslateLiteralsInDialogsReplaceRule class methodsFor:'documentation'!

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

!RBTranslateLiteralsInDialogsReplaceRule methodsFor:'accessing'!

group
    ^ 'Transformations - Smalltalk/X'

    "Modified: / 01-03-2012 / 19:42:09 / cg"
!

name
    ^ 'Add translations to strings in dialogs (ST/X specific)'

    "Modified: / 01-03-2012 / 19:39:38 / cg"
!

rationale
        |noResources realClass|

        noResources := false.
        class notNil ifTrue:[
            realClass := class realClass.
            "/ additional: mention the fact that resources/classResources are not present
            (realClass canUnderstand:#'classResources') ifFalse:[
                ((realClass isMeta not and:[(realClass allInstVarNames includes:'resources')])
                or:[ (realClass isMeta and:[(realClass allInstVarNames includes:'ClassResources') ])])
                ifFalse:[
                    noResources := true
                ]
            ]
        ].

        ^ 'Add code to perform national language translation on literal strings passed to dialog boxes.
Literal strings shown to users in dialogs, such as
<code><pre>    Dialog request:''aMessage''</pre></code> 
should translated using the resource mechanism, i.e. rewritten to 
<code><pre>    Dialog request:(resources string:''aMessage'')</pre></code>
<P>'
,(noResources ifTrue:[
    'Notice that the above suggestion seems to not work for methods of "',class realClass name,'".
Because it does not inherit from ApplicationModel or StandardSystemView, 
there is no "resources" instance variable or "classResources" getter method.
So you should either consider moving UI code from model classes to UI classes or pass in a resource dictionary as argument.
<P>'
] ifFalse:[ 
    '' 
])
, '
This transformation covers only the most common and obvious such occurrences. 
If in doubt, check all string constants for being possibly shown in the UI.
<P>
This rule is ignored in TestCase classes.'

    "Created: / 01-03-2012 / 19:39:24 / cg"
! !

!RBTranslateLiteralsInDialogsReplaceRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                replace: '`@dialog request: `#label'
                        with: '`@dialog request: (resources string: `#label)';

                replace: '`@dialog request: `#label initialAnswer: `#def'
                        with: '`@dialog request: (resources string: `#label) initialAnswer: `#def';

                replace: '`@dialog request: `#label default: `#def'
                        with: '`@dialog request: (resources string: `#label) default: `#def';

                replace: '`@dialog confirm: `#label '
                        with: '`@dialog confirm: (resources string: `#label) ';

"/                replace: '`@dialog information: `{:node| node isLiteral and:[node value notNil]}'
"/                        with: '`@dialog information: (resources string: `#label)';

                replace: '`@dialog information: `#label'
                    with: '`@dialog information: (resources string: `#label)'
                    when: [ :node :owner|
                        node isLiteral and:[node value notNil].
                    ];    

                replace: '`@dialog warn: `#label '
                        with: '`@dialog warn: (resources string: `#label)'

    "Modified: / 01-03-2012 / 19:41:59 / cg"
! !

!RBTranslateLiteralsInDialogsReplaceRule methodsFor:'running'!

shouldIgnoreClass: aClass selector: selector
    aClass isTestCaseLike ifTrue:[^ true].
    ^ super shouldIgnoreClass:aClass selector:selector.
! !

!RBTranslateLiteralsInDialogsReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

