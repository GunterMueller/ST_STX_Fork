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

RBParseTreeLintRule subclass:#RBMissingTranslationsInMenusRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Squeak'
!

!RBMissingTranslationsInMenusRule class methodsFor:'documentation'!

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

!RBMissingTranslationsInMenusRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( squeak pharo)
! !

!RBMissingTranslationsInMenusRule methodsFor:'accessing'!

group
        ^ 'Bugs - Squeak'

    "Modified: / 01-03-2012 / 18:57:27 / cg"
!

name
	^ 'Menus missing translations'
!

rationale
        ^ 'Literal strings shown to users in menus should be translated.
<P>This is a Squeak/Pharo specific rule, which does not make sense in ST/X'
! !

!RBMissingTranslationsInMenusRule methodsFor:'initialization'!

initialize
	super initialize.
	self matcher
		matchesAnyOf: #(
			'`@menu add: `#label action: `#sym'
			'`@menu add: `#label selector: `#sym arguments: `@stuff'
			'`@menu add: `#label subMenu: `@stuff target: `@targ selector: `#sel argumentList: `@args'
			'`@menu add: `#label subMenu: `@stuff'
			'`@menu add: `#label target: `@targ action: `#sel'
			'`@menu add: `#label target: `@targ selector `#sel argument: `@arg'
			'`@menu add: `#label target: `@targ selector `#sel arguments: `@arg'
			'`@menu add: `#label target: `@targ selector `#sel'
			'`@menu addList: `{ :n | n isLiteral and: [ n value isArray and: [ n value anySatisfy: [ :row | (row isKindOf: Array) and: [ row first isLiteral ] ] ] ] }'
			'`@menu addTitle: `#label updatingSelector: `#sel updateTarget: `@targ'
			'`@menu addTitle: `#label'
			'`@menu addWithLabel: `#label enablement: `#esel action: `#sel'
			'`@menu addWithLabel: `#label enablementSelector: `#esel target: `@targ selector: `#sel argumentList: `@args'
			'`@menu balloonTextForLastItem: `#label'
			'`@menu labels: `#lit lines: `@lines selections: `@sels'
			'`@menu title: `#title' )
		do: [ :node :answer | node ]
! !

!RBMissingTranslationsInMenusRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

