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

RBBlockLintRule subclass:#RBReturnsBooleanAndOtherRule
	instanceVariableNames:'matcher'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBReturnsBooleanAndOtherRule class methodsFor:'documentation'!

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

!RBReturnsBooleanAndOtherRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
	^ 'Returns a boolean and non boolean'
!

rationale
        ^ 'Checks for methods that return a boolean value (true or false) 
and return some other value such as (nil or self). 
If the method is suppose to return a boolean, 
then this signifies that there is one path through the method that might return a non-boolean. 
If the method doesn''t need to return a boolean, 
you should probably rewrite it to return some non-boolean value since other programmers reading your method might assume that it returns a boolean.
<P>
Notice that there are situations, in which a three-way result makes sense;
for example, some dialogs return true/false/nil for "yes" / "no" / "cancelled"'

    "Modified: / 01-03-2012 / 12:09:26 / cg"
! !

!RBReturnsBooleanAndOtherRule methodsFor:'initialization'!

initialize
    super initialize.
    matcher := ParseTreeSearcher new.
    matcher matches:'^ ``@object'
        do:[:node :answer | 
            answer
                add:node value;
                yourself
        ]
! !

!RBReturnsBooleanAndOtherRule methodsFor:'running'!

checkMethod: aContext 
    | hasBool hasSelf |

    "a quick rejector, to avoid many parses (because parsing is very slow)"
    (aContext sourceCode includes: $^) ifFalse:[^ self]. 

    hasBool := false.
    hasSelf := aContext parseTree lastIsReturn not.
    (matcher executeTree: aContext parseTree initialAnswer: Set new) do: [ :each | 
            hasBool := hasBool 
                    or: [ (each isLiteral and: [ #(true false) includes: each value ]) 
                    or: [ (each isMessage and: [ #(and: or:) includes: each selector ]) ] ].
            hasSelf := hasSelf
                    or: [ (each isVariable and: [ each name = 'self' ]) 
                    or: [ (each isLiteral and: [ (#(true false) includes: each value) not ]) ] ] ].
    (hasSelf and: [ hasBool ]) 
            ifTrue: [ result addClass: aContext selectedClass selector: aContext selector ]
! !

!RBReturnsBooleanAndOtherRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

