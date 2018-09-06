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

CustomCodeGenerator subclass:#CustomTestCaseTearDownCodeGenerator
	instanceVariableNames:'samePackageAsTestedClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomTestCaseTearDownCodeGenerator class methodsFor:'documentation'!

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

!CustomTestCaseTearDownCodeGenerator class methodsFor:'accessing-presentation'!

description
    ^ 'Generates initial #tearDown for TestCases'

    "Modified: / 05-08-2014 / 14:50:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
    ^ 'TestCase tearDown method'

    "Modified: / 05-08-2014 / 14:51:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomTestCaseTearDownCodeGenerator class methodsFor:'queries'!

availableInContext:aCustomContext
    ^ aCustomContext selectedClasses anySatisfy: [:cls | cls isMetaclass not and:[ cls inheritsFrom: (Smalltalk at:#TestCase) ] ]

    "Modified: / 12-06-2015 / 20:46:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective
    ^ aCustomPerspective isClassPerspective

    "Modified: / 05-08-2014 / 13:49:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomTestCaseTearDownCodeGenerator methodsFor:'accessing'!

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

!CustomTestCaseTearDownCodeGenerator methodsFor:'accessing - defaults'!

defaultSamePackageAsTestedClass
    "default value for samePackageAsTestedClass"

    ^ true

    "Created: / 15-11-2014 / 12:21:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseTearDownCodeGenerator methodsFor:'executing'!

buildForClass: class
    | source category superHasSetup current package |

    current := class.
    superHasSetup := false.
    [ superHasSetup not and:[ current isNil not ] ] whileTrue:[
        superHasSetup := current includesSelector: #tearDown.
        superHasSetup ifFalse:[
            current := current superclass.
        ].

    ].
    superHasSetup ifTrue:[ 
        source := 'tearDown
    "Add your own code here..."

    super tearDown.  
'.
        category := (current compiledMethodAt: #tearDown) category.
    ] ifFalse:[ 
        source := 'tearDown
    "Add your own code here..."

    "/ super tearDown.
'.
        category := ((Smalltalk at:#TestCase) compiledMethodAt: #tearDown ) category.
    ].

    package := PackageId noProjectID.
    samePackageAsTestedClass ? self defaultSamePackageAsTestedClass ifTrue: [ 
        package := class package
    ].

    model createMethod
        class: class;
        source: source;
        category: category;
        package: package;
        compile.

    "Created: / 05-08-2014 / 14:17:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2015 / 18:34:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 20:46:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buildInContext:aCustomContext
    aCustomContext selectedClasses do:[:cls |  
        (cls isMetaclass not and:[ cls inheritsFrom: (Smalltalk at:#TestCase) ]) ifTrue:[ 
            self buildForClass: cls.
        ].
    ]

    "Modified: / 12-06-2015 / 20:44:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

