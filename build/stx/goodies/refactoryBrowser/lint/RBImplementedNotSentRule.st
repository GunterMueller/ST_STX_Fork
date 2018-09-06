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

RBBlockLintRule subclass:#RBImplementedNotSentRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBImplementedNotSentRule class methodsFor:'documentation'!

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

!RBImplementedNotSentRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name
	^ 'Methods implemented but not sent'
!

rationale
    ^ 'Check for methods that are never sent. If you are sure that a method is not sent, it can be removed.
<P>
Be very careful with performs, unloaded classes, packages or customers which may use it.
Also, some methods are only called via UI or menu specifications and the message selector
may be hidden in a literal array or even constructed at runtime.
<P>
If in doubt, add a breakpoint or mark it as obsolete and leave it in the system for a while.
(and run a coverage analysis to check if the code is ever called).
If the code has at any time in the past been published to others,
you should consider it being used by somebody and you may break that person''s code.
<P>
A proven strategy (and therefore recommended) is to mark the method as "obsolete" 
(see the "visibility" menu in the browser''s method list) 
and to add a "self obsoleteMethodWarning" to the beginning of the code.
The obsolete attribute will show it in the browser as such - the "self obsoleteMethodWarning" will write a 
message to the Transcript whenever executed. 
Leave it it that way for the next few releases, so that others get a chance to migrate.'

    "Modified: / 01-03-2012 / 11:56:20 / cg"
!

severity
        ^ SeverityInformation
! !

!RBImplementedNotSentRule methodsFor:'running'!

checkMethod: aContext
    "Check if there are any senders. 
     Furthermore methods with pragmas are likely to be sent through reflection, 
     thus do not report those. 
     Also test methods are sent through reflection, so ignore those as well."

    (aContext uses: aContext selector)
            ifTrue: [ ^ self ].
    (aContext compiledMethod annotations isEmpty)
            ifFalse: [ ^ self ].
    (aContext selectedClass isMeta not
            and: [ aContext includesBehaviorNamed: #TestCase ])
                    ifTrue: [ ^ self ].
    result 
            addClass: aContext selectedClass
            selector: aContext selector

    "Modified: / 05-08-2011 / 13:49:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBImplementedNotSentRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

