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

RBBlockLintRule subclass:#RBInvalidLocalIdentifierRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X-STC'
!

!RBInvalidLocalIdentifierRule class methodsFor:'documentation'!

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

!RBInvalidLocalIdentifierRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    "/ marked as obsolete, as this stc bug was fixed in 6.2.5
    ^#( stx stc projectchecker obsolete)

    "Created: / 29-05-2014 / 15:21:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBInvalidLocalIdentifierRule methodsFor:'accessing'!

group
        ^ 'Bugs - Smalltalk/X'

    "Modified: / 29-05-2014 / 14:33:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
        ^ 'Invalid local variable identifier (for stc pre 6.2.5)'

    "Modified: / 29-05-2014 / 15:05:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rationale
        ^ 'Checks for methods with argument and local variable names starting with an underscore character.
Due to a bug in stc compiler, such may return incorrect value in certain cases.
<br>This stc bug was fixed in ST/X version 6.2.5'.

    "Modified: / 29-05-2014 / 14:41:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severity
        ^ SeverityError

    "Modified: / 29-05-2014 / 14:33:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBInvalidLocalIdentifierRule methodsFor:'running'!

checkMethod:aContext 
    | tree variables |

    "a quick rejector, to avoid many parses (because parsing is very slow)"
    (aContext sourceCode includes: $_) ifFalse:[^ self]. 

    tree := aContext parseTree.
    variables := tree allTemporaryVariables.
    variables do:[:variable | 
        variable first == $_ ifTrue:[ 
            result addClass: aContext selectedClass selector: aContext selector.
        ].
    ].

    "Modified: / 29-05-2014 / 15:08:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBInvalidLocalIdentifierRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

