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

RBParseTreeLintRule subclass:#RBPlatformDependentUserInteractionRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Squeak'
!

!RBPlatformDependentUserInteractionRule class methodsFor:'documentation'!

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

!RBPlatformDependentUserInteractionRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^ #( 
        portability "/ code is not portable
        squeak      "/ code is Squeak specific
        pharo       "/ code is Pharo specific
    )  
! !

!RBPlatformDependentUserInteractionRule methodsFor:'accessing'!

group
        ^ 'Bugs - Squeak'

    "Modified: / 01-03-2012 / 18:57:30 / cg"
!

name
	^ 'Platform dependent user interaction'
!

rationale
        ^ 'The method uses platform dependent user interactions which are not portable across different 
operating system implementations.
<p>
This rule is completely Squeak-specific and does not make any sense in ST/X 
(because the checked dialog messages are not implemented in ST/X anyway)'
!

severity
        ^ SeverityError
! !

!RBPlatformDependentUserInteractionRule methodsFor:'initialization'!

initialize
	super initialize.
	self matcher 
		matchesAnyOf: #(
			'FillInTheBlank multiLineRequest: `@object1 centerAt: `@object2 initialAnswer: `@object3 answerHeight: `@object4'
			'FillInTheBlank request: `@object1 initialAnswer: `@object2 centerAt: `@object3'
			'FillInTheBlank request: `@object1 initialAnswer: `@object2'
			'FillInTheBlank request: `@object1'
			'FillInTheBlank requestPassword: `@object1'
			'PopUpMenu confirm: `@object1 orCancel: `@object2'
			'PopUpMenu confirm: `@object1 trueChoice: `@object2 falseChoice: `@object3'
			'PopUpMenu confirm: `@object1'
			'PopUpMenu inform: `@object1'
			'PopUpMenu initialize'
			'PopUpMenu labelArray: `@object1 lines: `@object2'
			'PopUpMenu labelArray: `@object1'
			'PopUpMenu labels: `@object1 lines: `@object2'
			'PopUpMenu labels: `@object1'
			'PopUpMenu withCaption: `@object1 chooseFrom: `@object2'
			'SelectionMenu fromArray: `@object1'
			'SelectionMenu labelList: `@object1 lines: `@object2 selections: `@object3'
			'SelectionMenu labelList: `@object1 lines: `@object2'
			'SelectionMenu labelList: `@object1 selections: `@object2'
			'SelectionMenu labelList: `@object1'
			'SelectionMenu labels: `@object1 lines: `@object2 selections: `@object3'
			'SelectionMenu labels: `@object1 lines: `@object2'
			'SelectionMenu labels: `@object1 selections: `@object2'
			'SelectionMenu selections: `@object1 lines: `@object2'
			'SelectionMenu selections: `@object1' )
		do: [ :node :answer | node ]
! !

!RBPlatformDependentUserInteractionRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

