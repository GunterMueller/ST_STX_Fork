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

RBBlockLintRule subclass:#RBMethodSourceContainsLinefeedsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBMethodSourceContainsLinefeedsRule class methodsFor:'documentation'!

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

!RBMethodSourceContainsLinefeedsRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( squeak pharo )

    "Created: / 25-07-2012 / 15:57:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBMethodSourceContainsLinefeedsRule methodsFor:'accessing'!

group
        ^ 'Pharo Bugs'
!

name
	^ 'Method source contains linefeeds'
!

rationale
        ^ 'Pharo code should not contain linefeed characters.
This rule is not relevant for ST/X.'
!

severity
        ^ SeverityError
! !

!RBMethodSourceContainsLinefeedsRule methodsFor:'running'!

checkMethod: aContext 
        aContext isNil ifTrue:[self breakPoint:#cg]. "/ My guess: happens when two rules are executed in parallel
        (aContext sourceCode includes: Character lf) ifTrue: 
                [ result 
                        addClass: aContext selectedClass
                        selector: aContext selector ]
! !

!RBMethodSourceContainsLinefeedsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
