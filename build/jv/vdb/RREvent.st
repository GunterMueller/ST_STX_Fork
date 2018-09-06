"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

Announcement subclass:#RREvent
	instanceVariableNames:'rr'
	classVariableNames:''
	poolDictionaries:''
	category:'RR'
!

!RREvent class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!RREvent methodsFor:'accessing'!

rr
    ^ rr
! !

!RREvent methodsFor:'initialization'!

setRR: aRR
    rr := aRR

    "Created: / 31-07-2018 / 08:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

