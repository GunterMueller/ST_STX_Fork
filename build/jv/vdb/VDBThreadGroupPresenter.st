"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractPresenter subclass:#VDBThreadGroupPresenter
	instanceVariableNames:'threadGroup'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Presentation'
!

!VDBThreadGroupPresenter class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBThreadGroupPresenter methodsFor:'accessing'!

icon
    threadGroup isRunning ifTrue:[ ^ VDBIconLibrary threadGroupRunning16x16 ].
    threadGroup isStopped ifTrue:[ ^ VDBIconLibrary threadGroupStopped16x16 ].
    threadGroup isDead    ifTrue:[ ^ VDBIconLibrary threadGroupTerminated16x16 ].
    ^ nil

    "Created: / 22-09-2014 / 22:13:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-09-2014 / 00:55:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    | executableOrThreadGrouppId pidOrEmpty state |

    threadGroup executable notNil ifTrue:[ 
        executableOrThreadGrouppId := threadGroup executable contractTo: 30 
    ] ifFalse:[ 
        executableOrThreadGrouppId := 'thread group ', threadGroup id.
    ].

    (threadGroup type = 'process' and:[ threadGroup pid notNil ]) ifTrue:[
        pidOrEmpty := 'pid ', threadGroup pid printString , ', '.
    ].
    threadGroup isStopped ifTrue:[ 
        state := 'stopped'
    ] ifFalse:[ 
    threadGroup isRunning ifTrue:[ 
        state := 'running'
    ] ifFalse:[ 
    threadGroup isFinished ifTrue:[ 
        state := 'finished'
    ] ifFalse:[ 
    threadGroup isTerminated ifTrue:[ 
        state := 'terminated'
    ] ifFalse:[ 
        state := 'not run'
    ]]]].

    ^ '%1 [%2%3]' bindWith: executableOrThreadGrouppId 
                      with: pidOrEmpty ? ''
                      with: state

    "Created: / 22-09-2014 / 00:14:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-06-2017 / 07:47:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subject
    "Return an instance of GDB object that this presenter displays."

    ^ threadGroup

    "Modified: / 05-02-2018 / 13:08:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadGroup
    ^ threadGroup
! !

!VDBThreadGroupPresenter methodsFor:'initialization'!

setThreadGroup: aGDBThreadGroup
    threadGroup := aGDBThreadGroup

    "Created: / 21-09-2014 / 23:38:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBThreadGroupPresenter methodsFor:'protocol-accessing'!

fetchChildren
    "should compute the list of children via the model.
     Be aware, that the somewhat stupid 'optimization' of how the model is fetched may lead to
     a O(n*log n) or even O(n^2) behavior here.
     *** to optimize: redefine by subClass"

    ^ threadGroup threads collect:[ :t | VDBThreadPresenter new setThread: t; parent: self ]

    "Created: / 21-09-2014 / 23:41:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBThreadGroupPresenter methodsFor:'protocol-displaying'!

heightOn:aGC

    "/ Following is a performance optimization. We know
    "/ that label will be a string, so passing any string
    "/ would do (this in the end asks a font metrics).
    "/ 
    "/ This saves us a lot of time when system generates
    "/ a lot of events since #label sends ask GDB dof details
    height isNil ifTrue:[
        height := self heightOf:'%1 [%2%3]' on:aGC
    ].
    ^ height

    "Created: / 15-01-2018 / 09:54:22 / jv"
! !

!VDBThreadGroupPresenter methodsFor:'testing'!

isThreadGroupPresenter
    ^ true

    "Created: / 21-09-2014 / 23:54:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBThreadGroupPresenter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

