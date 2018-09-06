"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

SharedPool subclass:#HGDebugFlags
	instanceVariableNames:''
	classVariableNames:'Debug Trace'
	poolDictionaries:''
	category:'SCM-Mercurial-Internal'
!

!HGDebugFlags class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGDebugFlags class methodsFor:'accessing'!

debug
    ^Debug

    "Created: / 08-02-2014 / 11:37:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debug: aBoolean
    Debug := aBoolean

    "
     self debug:true; trace:true
     self debug:false; trace:false
    "
    "Created: / 08-02-2014 / 11:36:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace
    ^Trace

    "Created: / 03-03-2013 / 17:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace: aBoolean
    Trace := aBoolean
    "
     self debug:true; trace:true
     self debug:false; trace:false
    "

    "Created: / 08-02-2014 / 11:36:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGDebugFlags class methodsFor:'class initialization'!

initialize
    | debug trace |

    debug := OperatingSystem getEnvironment:'STX_LIBSCM_MERCURIAL_DEBUG'.
    Debug := debug notNil and:[debug ~= '0'].

    trace := OperatingSystem getEnvironment:'STX_LIBSCM_MERCURIAL_TRACE'.
    Trace := trace notNil and:[trace ~= '0'].

    "
     Trace := true.
     Debug := true.
     HGDebugFlags initialize
    "

    "Modified: / 09-03-2013 / 22:11:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGDebugFlags class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


HGDebugFlags initialize!
