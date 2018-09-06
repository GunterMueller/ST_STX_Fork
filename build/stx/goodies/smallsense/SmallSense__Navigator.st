"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

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

AbstractSearchDialog subclass:#Navigator
	instanceVariableNames:'steps'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!Navigator class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

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

!Navigator class methodsFor:'opening'!

open
    | result |    

    result := self new open.
    result isBehavior ifTrue:[ 
        UserPreferences current systemBrowserClass openInClass:result selector: nil.
        ^ self
    ].
    result isMethod ifTrue:[ 
        UserPreferences current systemBrowserClass openInClass: result mclass selector: result selector.
        ^ self
    ].
    result isCollection ifTrue:[ 
        (result allSatisfy:[:e|e isMethod]) ifTrue:[ 
            UserPreferences current systemBrowserClass 
                browseMethods:result 
                title:(self classResources string: 'Implementors of %1' with: result anElement selector storeString) 
                sort:true.
        ].
        ^ self
    ].
    ^ self

    "Created: / 25-01-2015 / 12:46:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 11:13:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Navigator methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == matchingObjectsSelectionHolder ifTrue:[
        self updateMextSearchStepVisibility.
    ].
    ^ super update:something with:aParameter from:changedObject

    "Created: / 23-01-2015 / 22:21:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateMextSearchStepVisibility
    "raise an error: this method should be implemented (TODO)"

    | selection |

    selection := self matchingObjectsSelection.
    matchingObjectsMultiselect ifTrue:[ 
        selection := selection size == 1 ifTrue:[ selection anElement ] ifFalse:[ nil ]
    ].
    selection notNil ifTrue:[ 
        self nextSearchStepVisibleHolder value: (processor canDoNextStepFor: selection)
    ] ifFalse:[ 
        self nextSearchStepVisibleHolder value: false.
    ].

    "Created: / 23-01-2015 / 22:21:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Navigator methodsFor:'change & update-background'!

updateMatchingIgnorePattern
    steps size == 1 ifTrue:[
        ^ super updateMatchingIgnorePattern 
    ].
    self enqueueDelayedUpdateMatchingObjectPOs: (self matchingObjectPOsForPattern: nil)

    "Created: / 24-01-2015 / 00:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2015 / 08:58:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Navigator methodsFor:'event processing'!

keyPressCursorRightInMatchingObjectsView
   self nextSearchStepVisibleHolder value ifTrue:[ 
       self step.
       ^ true.
   ].
   ^ super keyPressCursorRightInMatchingObjectsView

    "Created: / 23-01-2015 / 22:45:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Navigator methodsFor:'initialization'!

initialize
    super initialize.
    steps := OrderedCollection new: 3.
    self push: 
        (NavigatorStep for: 
            (CompositeProcessor 
                    with: ClassSearchProcessor new 
                    with: ImplementorSearchProcessor new))
        update: false.

    "Created: / 10-01-2015 / 07:03:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-01-2015 / 00:25:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Navigator methodsFor:'private-steps'!

push: aNavigatorStep
    self push: aNavigatorStep update: true

    "Created: / 23-01-2015 / 21:01:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-01-2015 / 00:24:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

push: aNavigatorStep update: update
    steps addLast: aNavigatorStep.
    processor := aNavigatorStep processor.
    update ifTrue:[ 
        self matchPatternHolder value: nil.
    ].

    "Created: / 24-01-2015 / 00:24:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2015 / 17:51:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

step
    | selection step |

    selection := self matchingObjectsSelection.
    matchingObjectsMultiselect ifTrue:[ 
        selection := selection size == 1 ifTrue:[ selection anElement ] ifFalse:[ nil ]
    ].
    step := NavigatorStep for: (processor processorForNextStepFor: selection).
    self push: step.

    "Created: / 23-01-2015 / 22:48:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Navigator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

