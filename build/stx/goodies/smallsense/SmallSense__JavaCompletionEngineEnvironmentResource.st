"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

TestResource subclass:#JavaCompletionEngineEnvironmentResource
	instanceVariableNames:'booted'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!JavaCompletionEngineEnvironmentResource class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

!JavaCompletionEngineEnvironmentResource methodsFor:'running'!

setUp
    JavaVM isNil ifTrue:[ 
        self signalInitializationError.
    ].
    
    booted := JavaVM booted.

    JavaVM booted ifFalse:[ 
        [
            JavaVM boot.                            
        ] on: Error do:[:ex | 
            self signalInitializationError.
        ].
    ].

    "Created: / 22-05-2014 / 17:21:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    booted ifFalse:[ 
        Java flushAllJavaResources
    ].

    "Created: / 22-05-2014 / 17:21:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

