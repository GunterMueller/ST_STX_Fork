"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

Object subclass:#VDBEvaluator
	instanceVariableNames:'debugger'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Tools'
!

!VDBEvaluator class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBEvaluator methodsFor:'accessing - mimicry'!

currentNameSpace: ignored
    self assert: ignored isNil

    "Created: / 21-03-2018 / 22:40:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

moreSharedPools:ignored
    self assert: ignored isNil

    "Created: / 21-03-2018 / 22:41:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBEvaluator methodsFor:'evaluation'!

evaluate:aString in: context receiver: receiver notifying: requestor logged:logged ifFail:failBlock
    ^ debugger evaluate: aString

    "Created: / 21-03-2018 / 22:41:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBEvaluator methodsFor:'initialization'!

setDebugger: aGDBDebugger
    debugger := aGDBDebugger

    "Created: / 21-03-2018 / 22:14:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBEvaluator methodsFor:'instance creation'!

new

    "/ This is hack to overcome the fact that TextView and other expect
    "/ class that they instantiate themselves. This is indeed weird interface, 
    "/ but well, we cannot change that easily due to backward compatibility.
    "/ See
    "/ 
    "/      Workspace >> #executeDoIt:
    "/ 
    ^ self

    "Created: / 21-03-2018 / 22:36:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

