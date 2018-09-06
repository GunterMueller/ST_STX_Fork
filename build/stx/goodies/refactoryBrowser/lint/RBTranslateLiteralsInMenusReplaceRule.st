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

RBTransformationRule subclass:#RBTranslateLiteralsInMenusReplaceRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Squeak'
!

!RBTranslateLiteralsInMenusReplaceRule class methodsFor:'documentation'!

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

!RBTranslateLiteralsInMenusReplaceRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( squeak pharo)
! !

!RBTranslateLiteralsInMenusReplaceRule methodsFor:'accessing'!

group
    ^ 'Transformations - Squeak'

    "Modified: / 01-03-2012 / 18:57:40 / cg"
!

name
    ^ 'Add translations to strings in menus (squeak specific)'

    "Modified: / 04-08-2011 / 20:54:08 / cg"
!

rationale
    ^ 'This is a Squeak specific rule which does not make sense in ST/X'

    "Modified: / 04-08-2011 / 20:54:08 / cg"
! !

!RBTranslateLiteralsInMenusReplaceRule methodsFor:'initialization'!

initialize
	super initialize.
	self rewriteRule
		replace: '`@menu add: `#label action: `#sym'
			with: '`@menu add: `#label translated action: `#sym';
		replace: '`@menu add: `#label selector: `#sym arguments: `@stuff'
			with: '`@menu add: `#label translated selector: `#sym arguments: `@stuff';
		replace: '`@menu add: `#label subMenu: `@stuff'
			with: '`@menu add: `#label translated subMenu: `@stuff';
		replace: '`@menu add: `#label subMenu: `@stuff target: `@targ selector: `#sel argumentList: `@args'
			with: '`@menu add: `#label translated subMenu: `@stuff target: `@targ selector: `#sel argumentList: `@args';
		replace: '`@menu add: `#label target: `@targ action: `#sel'
			with: '`@menu add: `#label translated target: `@targ action: `#sel';
		replace: '`@menu add: `#label target: `@targ selector `#sel'
			with: '`@menu add: `#label translated target: `@targ selector `#sel';
		replace: '`@menu add: `#label target: `@targ selector `#sel argument: `@arg'
			with: '`@menu add: `#label translated target: `@targ selector `#sel argument: `@arg';
		replace: '`@menu add: `#label target: `@targ selector `#sel arguments: `@arg'
			with: '`@menu add: `#label translated target: `@targ selector `#sel arguments: `@arg';
		replace: '`@menu addTitle: `#label'
			with: '`@menu addTitle: `#label translated';
		replace: '`@menu addTitle: `#label updatingSelector: `#sel updateTarget: `@targ'
			with: '`@menu addTitle: `#label translated updatingSelector: `#sel updateTarget: `@targ';
		replace: '`@menu addWithLabel: `#label enablement: `#esel action: `#sel'
			with: '`@menu addWithLabel: `#label translated enablement: `#esel action: `#sel';
		replace: '`@menu addWithLabel: `#label enablementSelector: `#esel target: `@targ selector: `#sel argumentList: `@args'
			with: '`@menu addWithLabel: `#label translated enablementSelector: `#esel target: `@targ selector: `#sel argumentList: `@args';
		replace: '`@menu balloonTextForLastItem: `#label'
			with: '`@menu balloonTextForLastItem: `#label translated';
		replace: '`@menu labels: `#lit lines: `@lines selections: `@sels'
			with: '`@menu labels: (`#lit collect: [ :l | l translated ]) lines: `@lines selections: `@sels';
		replace: '`@menu title: `#title'
			with: '`@menu title: `#title translated'
! !

!RBTranslateLiteralsInMenusReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBTranslateLiteralsInMenusReplaceRule.st,v 1.5 2014-12-17 18:56:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBTranslateLiteralsInMenusReplaceRule.st,v 1.5 2014-12-17 18:56:53 cg Exp $'
!

version_SVN
    ^ '$Id: RBTranslateLiteralsInMenusReplaceRule.st,v 1.5 2014-12-17 18:56:53 cg Exp $'
! !

