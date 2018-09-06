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

Object subclass:#CustomMenuBuilder
	instanceVariableNames:'perspective menu submenuLabel afterMenuItemLabelled
		generatorOrRefactoringFilter resources navigationState manager
		errorPrinter'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-UI'
!

!CustomMenuBuilder class methodsFor:'documentation'!

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
    Injects menu item with submenu filled with generators or refactorings to the given menu.
    Basically helps to extend system browser (NewSystemBrowser) context menu (for example
    the menu which pop-ups after right-click on the class list).

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>
"
! !

!CustomMenuBuilder class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!CustomMenuBuilder class methodsFor:'building'!

buildMenuForContext:context filter: filter
    ^ self new buildMenuForContext:context filter: filter

    "Created: / 26-08-2014 / 10:12:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomMenuBuilder methodsFor:'accessing'!

afterMenuItemLabelled
    "Returns menu item label after which will be placed 
     new menu item with generators or refactorings"
    
    ^ afterMenuItemLabelled

    "Modified (comment): / 28-12-2014 / 23:22:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

afterMenuItemLabelled:aLabel 
    "see afterMenuItemLabeled"
    
    afterMenuItemLabelled := aLabel

    "Modified (comment): / 28-12-2014 / 23:20:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

errorPrinter
    "Returns printer (like Transcript) which should print/show errors while menu building.
    Better to print errors silently than destroy IDE functionality with recurring errors."

    ^ errorPrinter

    "Modified (comment): / 01-02-2015 / 19:38:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

errorPrinter: aPrinter
    "see errorPrinter"

    errorPrinter := aPrinter.

    "Modified (comment): / 01-02-2015 / 19:38:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generatorOrRefactoringFilter
    "Returns one argument block which is used to filter generators or refactorings"

    ^ generatorOrRefactoringFilter

    "Modified (comment): / 28-12-2014 / 23:23:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generatorOrRefactoringFilter: aOneArgBlock
    "see generatorOrRefactoringFilter"

    generatorOrRefactoringFilter := aOneArgBlock

    "Modified (comment): / 28-12-2014 / 23:25:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

groupsSortBlock
    "Returns a block used to sort generator or refactoring groups"

    ^ [ :a :b | 
        a size = b size ifTrue: [ 
            | i | 

            i := 1.

            [ i < a size and: [ (a at:i) = (b at:i) ] ] whileTrue: [
                i := i + 1 
            ].

            (a at:i) < (b at:i)
        ] ifFalse: [
            a size < b size
        ]
    ]

    "Created: / 28-12-2014 / 20:56:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

manager
    "Returns generator or refactoring manager which is used to access them.
    See CustomManager for more details."

    ^ manager

    "Modified (comment): / 28-12-2014 / 23:26:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

manager: aManager
    "see manager"

    manager := aManager

    "Modified (comment): / 28-12-2014 / 23:27:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

menu
    "Returns menu (instance of class Menu) in which is created new
    menu item with submenu filled with generators or refactorings"

    ^ menu

    "Modified (comment): / 28-12-2014 / 23:28:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

menu: aMenu
    "see menu"

    menu := aMenu

    "Modified (comment): / 28-12-2014 / 23:28:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

navigationState
    "see Tools::NavigationState"

    ^ navigationState

    "Modified (comment): / 28-12-2014 / 23:29:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

navigationState: aNavigationState
    "see Tools::NavigationState"

    navigationState := aNavigationState

    "Created: / 28-12-2014 / 10:09:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 28-12-2014 / 23:29:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

perspective
    "see CustomPerspective"

    ^ perspective

    "Modified (comment): / 28-12-2014 / 23:30:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

perspective: aCustomPerspective
    "see CustomPerspective"

    perspective := aCustomPerspective

    "Modified (comment): / 28-12-2014 / 23:30:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

resources
    "Used to translate menu labels (resources string:)"

    ^ resources

    "Modified (comment): / 28-12-2014 / 23:31:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

resources: someResources
    "see resources"

    resources := someResources

    "Modified (comment): / 28-12-2014 / 23:32:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

submenuLabel
    "Returns label of menu item which contains submenu with generators or refactorings"

    ^ submenuLabel

    "Modified (comment): / 28-12-2014 / 23:33:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

submenuLabel: aLabel
    "see submenuLabel"

    submenuLabel := aLabel

    "Modified (comment): / 28-12-2014 / 23:33:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMenuBuilder methodsFor:'building'!

buildMenu
    | item context submenuChannel |

    (menu isNil or: [ perspective isNil ]) ifTrue: [ 
        self error: 'Attributes named menu and perspective are required.'
    ].

    item := MenuItem label: (resources string: submenuLabel).
    context := SmallSense::CustomBrowserContext 
                    perspective: perspective
                    state: navigationState.

    submenuChannel := [ self buildMenuForContext: context filter: generatorOrRefactoringFilter ].
    "Do not show empty context menu"
    submenuChannel value hasItems ifTrue: [ 
        item submenuChannel: submenuChannel.
        self 
            placeMenuItem: item 
            afterMenuItemLabeled: afterMenuItemLabelled 
            forMenu: menu 
    ]

    "Created: / 27-12-2014 / 17:20:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-01-2015 / 15:57:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:07:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buildMenuForContext: context filter: filter 
    | submenu generatorsAndRefactorings groups groupsMap |

    submenu := Menu new.
    generatorsAndRefactorings := manager generatorsAndRefactoringsSelect: [ :generatorOrRefactoring |
        [ (generatorOrRefactoring availableInPerspective: context perspective)
            and: [ filter value: generatorOrRefactoring ]
            and: [ generatorOrRefactoring availableForProgrammingLanguagesInContext: context ]
            and: [ generatorOrRefactoring label notNil ]
        ] on: Error do: [ :error |
            errorPrinter showCR: 'An error occured when selecting code generators/refactorings.'.
            errorPrinter showCR: 'Class: ', generatorOrRefactoring name, ' Error: ', error asString.  
            false
        ].
    ].

    "/ Now, group them by group.
    groupsMap := Dictionary new.
    groups := OrderedCollection new.
    generatorsAndRefactorings do:[:each |
        | group |

        group := each group.
        (groupsMap includesKey: group) ifTrue:[ 
            (groupsMap at: group) add: each.
        ] ifFalse:[ 
            groupsMap at: group put: (OrderedCollection with: each).
            groups add: group.
        ].
    ].

    groups sort: self groupsSortBlock.

    groups do:[:name |  
        | items |

        items := groupsMap at: name.
        items sort:[ :a :b | a label < b label ].
        items do:[:each | 
            | item |

            item := MenuItem label: (resources string: each label)
                    itemValue:[ each executeInContextWithWaitCursor: context ].
            item enabled:[ each availableInContext: context ].
            submenu addItem:item.
        ].
    ] separatedBy:[ 
        submenu addSeparator.
    ].

    ^ submenu

    "Created: / 26-08-2014 / 10:13:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-02-2015 / 20:18:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

placeMenuItem: aMenuItem afterMenuItemLabeled: aLabel forMenu: aMenu
    "Places a menu item after another menu item identified by label
    within given menu."    
    | index |

    index := aMenu indexOfMenuItemForWhich:[:each | each label = aLabel ].
    index ~~ 0 ifTrue:[
        "Labeled item found"
        aMenu addItem: aMenuItem beforeIndex: index + 1.
    ] ifFalse:[
        aMenu addItem: aMenuItem.
    ].

    "Created: / 27-12-2014 / 18:45:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMenuBuilder methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    menu := Menu new.
    submenuLabel := 'Unknown menu label'.
    generatorOrRefactoringFilter := [ :generatorOrRefactoring | true ].
    resources := self class classResources.
    manager := SmallSense::CustomManager current.
    errorPrinter := Transcript

    "Modified: / 01-02-2015 / 19:31:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:07:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomMenuBuilder class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

