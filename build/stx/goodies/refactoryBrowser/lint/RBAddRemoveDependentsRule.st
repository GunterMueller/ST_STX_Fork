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

RBBlockLintRule subclass:#RBAddRemoveDependentsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBAddRemoveDependentsRule class methodsFor:'documentation'!

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

!RBAddRemoveDependentsRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
        ^ 'Number of "addDependent:" messages > "removeDependent:"'

    "Modified: / 01-03-2012 / 12:10:07 / cg"
!

rationale
        ^ 'Check that the number of "<code>addDependent:</code>" message sends in a class is
less than or equal to the number of "<code>removeDependent:</code>" messages.
If there are more add messages that may signify that some dependents are not being released,
which may lead to memory leaks.
<P>
Please validate the outcome of this check manually:
control flow (conditional execution paths) are not analyzed by this check.'

    "Modified: / 01-03-2012 / 12:12:15 / cg"
!

resultClass
    "I will return the set of failing classes"

    ^ ClassEnvironment
! !

!RBAddRemoveDependentsRule methodsFor:'running'!

checkClass: aContext 
        | count cls setOfMethodsReferringToDependencyMessages|

        cls := aContext selectedClass.
        setOfMethodsReferringToDependencyMessages := Set new.
        setOfMethodsReferringToDependencyMessages addAll:(cls whichSelectorsReferTo: #addDependent:).
        setOfMethodsReferringToDependencyMessages addAll:(cls whichSelectorsReferTo: #removeDependent:).
        
        count := 0.
        setOfMethodsReferringToDependencyMessages do:[ :sel | 
            (cls compiledMethodAt: sel) messagesDo: [ :each | 
                each = #addDependent: ifTrue: [ count := count + 1 ].
                each = #removeDependent: ifTrue: [ count := count - 1 ] 
            ] 
        ].
        "/ cg: why not count ~~ 0 here???
        count > 0 ifTrue: [ 
            result addClass: cls 
        ]
! !

!RBAddRemoveDependentsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

