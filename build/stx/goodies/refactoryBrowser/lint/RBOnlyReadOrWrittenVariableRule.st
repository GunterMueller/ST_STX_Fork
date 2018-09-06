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

RBBlockLintRule subclass:#RBOnlyReadOrWrittenVariableRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBOnlyReadOrWrittenVariableRule class methodsFor:'documentation'!

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

!RBOnlyReadOrWrittenVariableRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name
        ^ 'Instance variables is not both read AND written'
!

rationale
    ^ self appendVariableNamesFromResultToRationale:
        'Checks that all instance variables are both read and written. 
If an instance variable is only read, you can replace all of the reads with nil, 
since it couldn''t have been assigned a value. 
If the variable is only written, then we don''t need to store the result since we never use it. 
<P>
This check does not work for some data model classes which may use "<code>instVarAt:</code>" / "<code>instVarAt:put:</code>" 
messages to access instance variables.
<BR>Also be careful for variables which are defined for and used by subclasses
(although, you may consider moving the variable to the subclass then)'
!

resultClass
    "I will return the set of failing variables"

    ^ VariableEnvironment
!

severity
        ^ SeverityInformation
! !

!RBOnlyReadOrWrittenVariableRule methodsFor:'running'!

checkClass: aContext 
        | allSubclasses selectedClass |

        selectedClass := aContext selectedClass.
        allSubclasses := selectedClass withAllSubclasses.
        selectedClass instVarNames do: [ :each | 
                | isRead isWritten |
                isRead := false.
                isWritten := false.
                allSubclasses 
                        detect: [ :class | 
                                isRead ifFalse: [ isRead := (class whichSelectorsRead: each) isEmpty not ].
                                isWritten ifFalse: [ isWritten := (class whichSelectorsAssign: each) isEmpty not ].
                                isRead & isWritten ]
                        ifNone: [
                                result 
                                        addClass: selectedClass
                                        instanceVariable: each ] ]

    "Modified: / 05-08-2011 / 11:37:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBOnlyReadOrWrittenVariableRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

