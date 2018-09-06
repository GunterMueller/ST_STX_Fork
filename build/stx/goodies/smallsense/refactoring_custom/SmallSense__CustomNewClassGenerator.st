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

CustomCodeGenerator subclass:#CustomNewClassGenerator
	instanceVariableNames:'newClassName'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomNewClassGenerator class methodsFor:'documentation'!

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
    Template class for generators which needs to create a new class.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>
"
! !

!CustomNewClassGenerator class methodsFor:'queries'!

availableInContext:aCustomContext

    ^ true

    "Created: / 08-11-2014 / 16:50:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective

    ^ aCustomPerspective isClassPerspective

    "Created: / 08-11-2014 / 16:50:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == CustomNewClassGenerator.
! !

!CustomNewClassGenerator methodsFor:'accessing'!

newClassName
    "Returns a name of the new class to be created."

    ^ newClassName

    "Created: / 08-11-2014 / 16:58:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 09-11-2014 / 01:20:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

newClassName: aClassName
    "see newClassName"

    newClassName := aClassName.

    "Created: / 08-11-2014 / 16:59:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 09-11-2014 / 01:20:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNewClassGenerator methodsFor:'accessing - ui'!

defaultClassName
    "Returns class name which will be displayed in dialog input box"

    self subclassResponsibility

    "Created: / 08-11-2014 / 16:56:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 09-11-2014 / 01:21:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

newClassNameLabel
    "Returns a label of the dialog for the new class to be created"

    self subclassResponsibility

    "Created: / 08-11-2014 / 16:57:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 09-11-2014 / 01:22:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNewClassGenerator methodsFor:'executing - private'!

buildForClass: aClass
    "Subclass can modify the newly created class in here"

    self subclassResponsibility

    "Created: / 08-11-2014 / 17:06:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 09-11-2014 / 01:24:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

buildInContext:aCustomContext
    | class |

    class := model createClass
        name: self newClassName asSymbol;
        yourself.

    self buildForClass: class.

    class compile.

    self executeSubGeneratorOrRefactoringClasses: (Array 
            with: CustomSubclassResponsibilityCodeGenerator
        )
        inContext: (CustomSubContext new
            selectedClasses: (Array with: class);
            yourself
        )

    "Created: / 08-11-2014 / 17:10:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-12-2014 / 18:13:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

configureInContext: aCustomContext
    | initialClassName counter |

    initialClassName := self defaultClassName.
    counter := 1.
    [ (Smalltalk at: initialClassName asSymbol) notNil ] whileTrue:[ 
        initialClassName := self defaultClassName , counter printString.
        counter := counter + 1.
    ].
    newClassName := dialog 
                        requestClassName: self newClassNameLabel 
                        initialAnswer: self defaultClassName.

    "Created: / 08-11-2014 / 17:01:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-11-2014 / 21:24:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomNewClassGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

