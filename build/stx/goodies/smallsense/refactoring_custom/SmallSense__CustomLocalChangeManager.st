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

CustomChangeManager subclass:#CustomLocalChangeManager
	instanceVariableNames:'executedChanges'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomLocalChangeManager class methodsFor:'documentation'!

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
!

documentation
"
    Unlike CustomBrowserChangeManager this implementation should not affect
    global Browser changes collector, Browser menus and the change file (st.chg).

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz> 

"
! !

!CustomLocalChangeManager class methodsFor:'instance creation'!

new

    ^ self basicNew initialize

    "Created: / 31-05-2014 / 19:34:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomLocalChangeManager methodsFor:'initialization'!

initialize

    executedChanges := OrderedCollection new.

    "Created: / 31-05-2014 / 19:31:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomLocalChangeManager methodsFor:'performing-changes'!

performChange: aRefactoringChange
    "Applies code change (add/change/remove class/method ...) to the system"

    Class withoutUpdatingChangesDo:[ 
        executedChanges add: aRefactoringChange execute
    ]

    "Modified: / 30-11-2014 / 18:21:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

undoChanges
    "undo all changes made by performChange: method"

    Class withoutUpdatingChangesDo:[ 
        executedChanges reversed do: [ :change | 
            change execute
        ]
    ].

    executedChanges removeAll

    "Created: / 19-10-2014 / 14:59:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 30-11-2014 / 15:40:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomLocalChangeManager class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

