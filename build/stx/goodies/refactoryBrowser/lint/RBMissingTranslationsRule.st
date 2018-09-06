"{ Encoding: utf8 }"

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

RBParseTreeLintRule subclass:#RBMissingTranslationsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBMissingTranslationsRule class methodsFor:'documentation'!

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

!RBMissingTranslationsRule methodsFor:'accessing'!

group
    ^ 'Bugs - Smalltalk/X'

    "Modified: / 01-03-2012 / 18:57:04 / cg"
!

name
        ^ 'Missing translations in dialogs'

    "Modified: / 07-04-2012 / 13:11:32 / cg"
!

rationale
        ^ 'Literal strings shown to users in dialogs 
(such as "<code>Dialog request:''aMessage''</code>") should be translated 
to a national language using the resource mechanism. 
eg. by rewriting it to "<code>Dialog request:(resources string:''aMessage'')</code>".
<P>
This check covers only the most common and obvious such occurrences. 
If in doubt, check string constants. 
Remember: Lint is not a replacement for a visual GUI inspection done by a human.
<P>
This rule is ignored in TestCase classes.'

    "Modified: / 06-03-2012 / 18:38:23 / cg"
! !

!RBMissingTranslationsRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher
                matchesAnyOf: #(
                        '`@dialog request: `#label'
                        '`@dialog request: `#label initialAnswer: `#value'
                        '`@dialog requestFileName: `#label'
                        '`@dialog requestFileName: `#label default: `#value'
                        '`@dialog requestFileName: `#label pattern: `#value'
                        '`@dialog confirm: `#label'
                        '`@dialog confirm: `#label default: `#value'
                        '`@dialog confirm: `#label initialAnswer: `#value'
                        '`@dialog confirm: `#label title: `#title'
                        '`@dialog confirm: `#label withCancel: `#withCancel'
                        '`@dialog confirmWithCancel: `#label'
                        '`@dialog confirmWithCancel: `#label default: `#value'
                        '`@dialog confirmWithCancel: `#label initialAnswer: `#value'
                        '`@dialog information: `{:node| node isLiteral and:[node value notNil]}'
                        '`@dialog information: `#label title: `#title'
                        '`@dialog warn: `#label'
                        '`@dialog warn: `#label title: `#title'
"/                        '`@menu add: `#label action: `#sym'
"/                        '`@menu add: `#label selector: `#sym arguments: `@stuff'
"/                        '`@menu add: `#label subMenu: `@stuff target: `@targ selector: `#sel argumentList: `@args'
"/                        '`@menu add: `#label subMenu: `@stuff'
"/                        '`@menu add: `#label target: `@targ action: `#sel'
"/                        '`@menu add: `#label target: `@targ selector `#sel argument: `@arg'
"/                        '`@menu add: `#label target: `@targ selector `#sel arguments: `@arg'
"/                        '`@menu add: `#label target: `@targ selector `#sel'
"/                        '`@menu addList: `{ :n | n isLiteral and: [ n value isArray and: [ n value anySatisfy: [ :row | (row isKindOf: Array) and: [ row first isLiteral ] ] ] ] }'
"/                        '`@menu addTitle: `#label updatingSelector: `#sel updateTarget: `@targ'
"/                        '`@menu addTitle: `#label'
"/                        '`@menu addWithLabel: `#label enablement: `#esel action: `#sel'
"/                        '`@menu addWithLabel: `#label enablementSelector: `#esel target: `@targ selector: `#sel argumentList: `@args'
"/                        '`@menu balloonTextForLastItem: `#label'
"/                        '`@menu labels: `#lit lines: `@lines selections: `@sels'
"/                        '`@menu title: `#title' 
                )
                do: [ :node :answer | node ]

    "Modified: / 01-03-2012 / 17:03:00 / cg"
! !

!RBMissingTranslationsRule methodsFor:'running'!

shouldIgnoreClass: aClass selector: selector
    aClass isTestCaseLike ifTrue:[^ true].
    ^ super shouldIgnoreClass:aClass selector:selector.
! !

!RBMissingTranslationsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

