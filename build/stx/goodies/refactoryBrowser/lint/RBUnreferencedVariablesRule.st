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

RBBlockLintRule subclass:#RBUnreferencedVariablesRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBUnreferencedVariablesRule class methodsFor:'documentation'!

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

!RBUnreferencedVariablesRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name
	^ 'Variables not referenced'
!

rationale
    ^ self appendVariableNamesFromResultToRationale:
'Check for variables not referenced. 
If a variable is not used in a class, it should be moved down or deleted.
Occasionally, it is useful to provide a variable in an abstract class for all of its subclasses.'.

    "Modified: / 17-02-2012 / 08:53:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2012 / 18:26:36 / cg"
!

resultClass
    "I will return the set of failing variables"

    ^ VariableEnvironment
!

severity
        ^ SeverityInformation
! !

!RBUnreferencedVariablesRule methodsFor:'running'!

checkClass: aContext 
        | selectedClass isMeta allSubclasses |

        selectedClass := aContext selectedClass.
        isMeta := selectedClass isMeta.
        allSubclasses := selectedClass withAllSubclasses.
        
        selectedClass instVarNames do: 
                [ :each | 
                allSubclasses 
                        detect: [ :class | 
                            (class whichSelectorsAccess: each) notEmpty
                        ]
                        ifNone: 
                                [ result 
                                        addClass: selectedClass
                                        instanceVariable: each ] ].
        isMeta ifFalse: 
                [ selectedClass classPool associationsDo: 
                        [ :each | 
                        (aContext uses: (selectedClass globalKeyForClassVar:each key)) ifFalse: 
                                [ result 
                                        addClass: selectedClass
                                        classVariable: each key ] ] ]
! !

!RBUnreferencedVariablesRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

