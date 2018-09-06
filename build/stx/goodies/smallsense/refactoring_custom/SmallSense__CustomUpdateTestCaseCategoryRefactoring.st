"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015-2016 Jan Vrany

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

CustomRefactoring subclass:#CustomUpdateTestCaseCategoryRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Refactorings'
!

!CustomUpdateTestCaseCategoryRefactoring class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015-2016 Jan Vrany

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

!CustomUpdateTestCaseCategoryRefactoring class methodsFor:'accessing-presentation'!

description

    ^ 'Updates TestCase subclasses category with respect to their classes to be tested'

    "Modified: / 08-11-2014 / 18:49:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

label

    ^ 'Update TestCase Category'

    "Modified: / 08-11-2014 / 17:28:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomUpdateTestCaseCategoryRefactoring class methodsFor:'queries'!

availableForClass:aClass

    ^ (aClass isSubclassOf: (Smalltalk at:#TestCase)) and: [ 
        aClass theNonMetaclass name endsWith: 'Tests'  
    ]

    "Created: / 08-11-2014 / 19:03:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 20:43:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

availableInContext:aCustomContext 

    ^ aCustomContext selectedClasses ? #() anySatisfy: [ :class |
        self availableForClass: class
    ]

    "Modified: / 25-01-2015 / 15:10:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableInPerspective: aCustomPerspective 

    ^ aCustomPerspective isClassPerspective

    "Modified: / 08-11-2014 / 17:27:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomUpdateTestCaseCategoryRefactoring methodsFor:'executing - private'!

buildInContext: aCustomContext 
    | testCaseHelper |

    testCaseHelper := CustomTestCaseHelper new.

    aCustomContext selectedClasses ? #() do:[ :class | 
        (self class availableForClass: class) ifTrue: [ 
            | testedClassName |

            testedClassName := (class theNonMetaclass name removeSuffix: 'Tests') asSymbol.
            (model includesClassNamed: testedClassName) ifTrue: [
                | testCategory |

                testCategory := testCaseHelper 
                    testCategory: (model classNamed: testedClassName) category.

                (testCategory = (class category)) ifFalse: [ 
                    refactoryBuilder changeCategoryOf: class to: testCategory
                ]
            ]
        ]
    ]

    "Modified: / 08-11-2014 / 21:33:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

