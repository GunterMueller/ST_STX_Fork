"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: SmallSense }"

CustomRefactoring subclass:#CustomReplaceIfNilWithIfTrueRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Refactorings'
!

!CustomReplaceIfNilWithIfTrueRefactoring class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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

!CustomReplaceIfNilWithIfTrueRefactoring class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"

    ^ 'Search for ifNil:ifNotNil: expressions and replace it with isNil ifTrue:ifFalse: expression'

    "Created: / 07-08-2014 / 21:50:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ 'Replace ifNil:ifNotNil: with isNil ifTrue:ifFalse:'

    "Created: / 07-08-2014 / 21:51:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomReplaceIfNilWithIfTrueRefactoring class methodsFor:'queries'!

availableInContext:aCustomContext
    "Returns true if the generator/refactoring is available in given
     context, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     are available at given point. See class CustomContext for details."

    ^ true

    "Created: / 07-08-2014 / 21:01:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective
    "Returns true if the generator/refactoring is available in given
     perspective, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     to show"

    ^ true

    "Created: / 07-08-2014 / 22:14:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomReplaceIfNilWithIfTrueRefactoring methodsFor:'executing'!

buildInContext: aCustomContext
    "Performs a refactoring within given context scope"

    refactoryBuilder
        replace: '``@receiver ifNil: ``@nilBlock ifNotNil: ``@notNilBlock'
        with: '``@receiver isNil ifTrue: ``@nilBlock ifFalse: ``@notNilBlock'
        inContext: aCustomContext

    "Created: / 23-08-2014 / 00:17:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomReplaceIfNilWithIfTrueRefactoring class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

