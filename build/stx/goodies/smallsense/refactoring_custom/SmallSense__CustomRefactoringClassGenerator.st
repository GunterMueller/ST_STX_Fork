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

CustomNewClassGenerator subclass:#CustomRefactoringClassGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomRefactoringClassGenerator class methodsFor:'documentation'!

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

!CustomRefactoringClassGenerator class methodsFor:'accessing-presentation'!

description

    ^ 'Create new class which should perform some refactoring'

    "Modified: / 09-11-2014 / 00:51:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

group

    ^ #(Generators)

    "Created: / 08-11-2014 / 17:19:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

label

    ^ 'New Refactoring'

    "Modified: / 08-11-2014 / 17:18:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoringClassGenerator methodsFor:'accessing - ui'!

defaultClassName

    ^ 'CustomXXXRefactoring'

    "Created: / 08-11-2014 / 17:15:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

newClassNameLabel

    ^ 'Enter class name for new refactoring'

    "Created: / 08-11-2014 / 17:16:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoringClassGenerator methodsFor:'executing - private'!

buildForClass: aClass

    aClass
        superclassName: CustomRefactoring name;
        category: CustomRefactoring category

    "Created: / 08-11-2014 / 17:15:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 21:05:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

