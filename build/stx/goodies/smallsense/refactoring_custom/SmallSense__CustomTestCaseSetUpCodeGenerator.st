"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015-2017 Jan Vrany

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

CustomCodeGenerator subclass:#CustomTestCaseSetUpCodeGenerator
	instanceVariableNames:'samePackageAsTestedClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomTestCaseSetUpCodeGenerator class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015-2017 Jan Vrany

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

!CustomTestCaseSetUpCodeGenerator class methodsFor:'accessing-presentation'!

description
    ^ 'Generates initial #setUp for test cases'

    "Modified: / 16-09-2014 / 11:24:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #('Testing')

    "Created: / 05-08-2014 / 14:14:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    ^ 'TestCase setUp method'

    "Modified: / 05-08-2014 / 14:13:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomTestCaseSetUpCodeGenerator class methodsFor:'queries'!

availableInContext:aCustomContext
    ^ aCustomContext selectedClasses anySatisfy: [:cls | cls isMetaclass not and:[ cls inheritsFrom: (Smalltalk at:#TestCase) ] ]

    "Modified: / 12-06-2015 / 20:46:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective
    ^ aCustomPerspective isClassPerspective

    "Modified: / 05-08-2014 / 13:49:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomTestCaseSetUpCodeGenerator methodsFor:'accessing'!

samePackageAsTestedClass
    "Returns true when we should assign TestCase class 
    to the same package as tested class."

    ^ samePackageAsTestedClass

    "Created: / 15-11-2014 / 11:54:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

samePackageAsTestedClass: aBoolean
    "see samePackageAsTestedClass"

    samePackageAsTestedClass := aBoolean

    "Created: / 15-11-2014 / 11:56:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseSetUpCodeGenerator methodsFor:'accessing - defaults'!

defaultSamePackageAsTestedClass
    "default value for samePackageAsTestedClass"

    ^ true

    "Created: / 15-11-2014 / 12:21:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseSetUpCodeGenerator methodsFor:'executing'!

buildForClass:class 
    | source  category  superHasSetup  current  package |

    current := class.
    superHasSetup := false.
    [
        superHasSetup not and:[ current isNil not ]
    ] whileTrue:[
        superHasSetup := current includesSelector:#setUp.
        superHasSetup ifFalse:[
            current := current superclass.
        ].
    ].
    source := self methodSource:superHasSetup.
    superHasSetup ifTrue:[
        category := (current compiledMethodAt:#setUp) category.
    ] ifFalse:[
        category := ((Smalltalk at:#TestCase) compiledMethodAt:#setUp) category.
    ].
    package := PackageId noProjectID.
    samePackageAsTestedClass ? self defaultSamePackageAsTestedClass ifTrue:[
        package := class package
    ].
    (model createMethod)
        class:class;
        source:source;
        category:category;
        package:package;
        compile.

    "Created: / 07-08-2017 / 14:21:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buildInContext:aCustomContext
    aCustomContext selectedClasses do:[:cls |  
        (cls isMetaclass not and:[ cls inheritsFrom: (Smalltalk at:#TestCase) ]) ifTrue:[ 
            self buildForClass: cls.
        ].
    ]

    "Modified: / 12-06-2015 / 20:46:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomTestCaseSetUpCodeGenerator methodsFor:'private'!

methodSource:callSuper 
    | source |

    callSuper ifTrue:[
        source := 'setUp
    super setUp.

    "Add your own code here..."
'.
    ] ifFalse:[
        source := 'setUp
    "/ super setUp.

    "Add your own code here..."
'.
    ].
    ^ source
! !

