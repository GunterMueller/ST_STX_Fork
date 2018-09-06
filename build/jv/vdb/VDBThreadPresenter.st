"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractPresenter subclass:#VDBThreadPresenter
	instanceVariableNames:'thread name'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Presentation'
!

!VDBThreadPresenter class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBThreadPresenter methodsFor:'accessing'!

icon
    thread isRunning ifTrue:[ ^ VDBIconLibrary threadRunning16x16 ].
    thread isStopped ifTrue:[ ^ VDBIconLibrary threadStopped16x16 ].
    thread isTerminated ifTrue:[ ^ VDBIconLibrary threadTerminated16x16 ].

    ^ nil

    "Created: / 22-09-2014 / 22:00:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    name isNil ifTrue:[ 
        thread isRunning ifFalse:[
            name := thread name.
        ]
    ].
    ^ '%1 [%2]' bindWith: (name notNil ifTrue:[name] ifFalse:['thread ' , thread id printString]) with: thread status

    "Created: / 22-09-2014 / 00:14:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-07-2017 / 14:23:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subject
    "Return an instance of GDB object that this presenter displays."

    ^ thread

    "Modified: / 05-02-2018 / 13:08:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

thread
    ^ thread
! !

!VDBThreadPresenter methodsFor:'initialization'!

setThread: aGDBThread
    thread := aGDBThread.

    "Created: / 21-09-2014 / 23:39:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-07-2017 / 14:21:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBThreadPresenter methodsFor:'protocol-accessing'!

fetchChildren
    "should compute the list of children via the model.
     Be aware, that the somewhat stupid 'optimization' of how the model is fetched may lead to
     a O(n*log n) or even O(n^2) behavior here.
     *** to optimize: redefine by subClass"

     thread isDead ifTrue:[ ^ #() ].
     thread isRunning ifTrue:[ ^ #() ].
     ^ thread stack collect:[ :f | VDBFramePresenter new setFrame: f; parent: self ]

    "Created: / 21-09-2014 / 23:42:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-09-2014 / 00:04:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBThreadPresenter methodsFor:'testing'!

isThreadPresenter
    ^ true

    "Created: / 21-09-2014 / 23:54:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBThreadPresenter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

