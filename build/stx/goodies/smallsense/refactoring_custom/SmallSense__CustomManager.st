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

Object subclass:#CustomManager
	instanceVariableNames:'generatorsOrRefactoringsProvider'
	classVariableNames:'Current'
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomManager class methodsFor:'documentation'!

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
    Starting point for accessing generators and refactoring classes.
    Class method 'current' provides current system setup.
    Instance methods basically returns or iterates some subset of generators or refactoring classes.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>
"
! !

!CustomManager class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    Current := self new

    "Modified: / 25-01-2014 / 14:54:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-12-2014 / 12:12:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomManager class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!CustomManager class methodsFor:'accessing'!

current
    "Returns my global instance within system"

    ^ Current

    "Created: / 25-01-2014 / 14:55:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-12-2014 / 12:12:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomManager methodsFor:'accessing'!

generatorsAndRefactorings
    "Returns all generators and refactorings from generatorsOrRefactoringsProvider"

    ^ OrderedCollection streamContents:[ :s |
        self generatorsAndRefactoringsDo: [ :each |
            s nextPut: each .
        ]  
    ]

    "Created: / 25-01-2014 / 15:02:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-12-2014 / 11:55:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generatorsAndRefactoringsForContext: aCustomContext
    "Returns generators and refactorings available for given context"

    ^ OrderedCollection streamContents:[ :s |
        self generatorsAndRefactoringsForContext: aCustomContext do: [ :each |
            s nextPut: each .
        ]  
    ]

    "Created: / 25-01-2014 / 15:06:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-12-2014 / 11:57:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generatorsAndRefactoringsForPerspective: aCustomPerspective
    "Returns generators and refactorings available for given perspective"

    ^ OrderedCollection streamContents:[ :s |
        self generatorsAndRefactoringsForPerspective: aCustomPerspective do: [ :each |
            s nextPut: each .
        ]  
    ]

    "Created: / 26-01-2014 / 13:18:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-01-2014 / 23:35:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-12-2014 / 11:57:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generatorsAndRefactoringsSelect: aBlock
    "Returns generators and refactorings classes for which the block returns true"

    ^ OrderedCollection streamContents:[ :stream |
        self generatorsAndRefactoringsDo: [ :each |
            (aBlock value: each) ifTrue: [ 
                stream nextPut: each
            ]
        ]  
    ]

    "Created: / 28-12-2014 / 13:03:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generatorsOrRefactoringsProvider
    "Returns an iterator (implements generatorsAndRefactoringsDo:) from where generators or refactorings will be taken."

    ^ generatorsOrRefactoringsProvider

    "Modified (comment): / 28-12-2014 / 12:05:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generatorsOrRefactoringsProvider: aProvider
    "see generatorsOrRefactoringsProvider"

    generatorsOrRefactoringsProvider := aProvider

    "Modified (comment): / 28-12-2014 / 12:06:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomManager methodsFor:'enumerating'!

generatorsAndRefactoringsDo: aBlock
    "Evaluates a block on all installed generator and refactoring classes.
     NOTE: the block gets the generator/refactoring class. not an instance."

    generatorsOrRefactoringsProvider generatorsAndRefactoringsDo: [ :each |
        each isAbstract ifFalse:[
            aBlock value: each 
        ].
    ]

    "Created: / 25-01-2014 / 15:01:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-01-2014 / 13:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 11:52:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generatorsAndRefactoringsForContext: aCustomContext do: aBlock
    "Evaluates a block on generator and refactoring classes available for given context"

    self generatorsAndRefactoringsDo: [ :each |
        (each availableInContext: aCustomContext) ifTrue:[ 
            aBlock value: each 
        ].
    ]

    "Created: / 25-01-2014 / 15:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-12-2014 / 12:08:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generatorsAndRefactoringsForPerspective: aCustomPerspective do: aBlock
    "Evaluates a block on generator and refactoring classes available for given perspective"

    self generatorsAndRefactoringsDo: [ :each |
        (each availableInPerspective: aCustomPerspective) ifTrue:[ 
            aBlock value: each 
        ].
    ]

    "Created: / 26-01-2014 / 13:18:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-12-2014 / 12:08:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomManager methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    generatorsOrRefactoringsProvider := CustomCodeGeneratorOrRefactoring

    "Modified: / 28-12-2014 / 11:53:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomManager class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


CustomManager initialize!
