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

SortedCollection subclass:#CompletionResult
	instanceVariableNames:'context'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core'
!

!CompletionResult class methodsFor:'documentation'!

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

!CompletionResult class methodsFor:'instance creation'!

new
    ^ self sortBlock:[:a :b | a label < b label ].

    "Created: / 26-09-2013 / 11:01:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionResult methodsFor:'accessing'!

context
    ^ context
!

context:aCompletionContext
    context := aCompletionContext.
    self do:[:each | each context: context ].

    "Modified: / 17-10-2013 / 01:13:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionResult methodsFor:'adding & removing'!

add:anObject
    anObject context: context.
    ^ super add: anObject

    "Created: / 17-10-2013 / 01:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addAll:aCollection
    "add all elements of the argument, aCollection to the receiver.
     Returns the argument, aCollection (sigh)."

    aCollection do:[:each | each context: context ].
    ^ super addAll: aCollection

    "Created: / 17-10-2013 / 01:06:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

