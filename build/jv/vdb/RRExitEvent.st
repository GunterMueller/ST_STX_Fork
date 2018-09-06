"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

RREvent subclass:#RRExitEvent
	instanceVariableNames:'status'
	classVariableNames:''
	poolDictionaries:''
	category:'RR'
!

!RRExitEvent class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!RRExitEvent methodsFor:'accessing'!

status
    ^ status
! !

!RRExitEvent methodsFor:'initialization'!

setStatus: anObject
    status := anObject

    "Created: / 31-07-2018 / 08:33:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

