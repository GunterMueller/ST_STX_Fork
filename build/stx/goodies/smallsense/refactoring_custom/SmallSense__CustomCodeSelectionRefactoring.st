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

CustomRefactoring subclass:#CustomCodeSelectionRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Refactorings'
!

!CustomCodeSelectionRefactoring class methodsFor:'documentation'!

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
    Template class for refactorings which operates on selected source code in the text editor.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>
"
! !

!CustomCodeSelectionRefactoring class methodsFor:'queries'!

availableInContext:aCustomContext
    "Returns true if the generator/refactoring is available in given
     context, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     are available at given point. See class CustomContext for details."

    ^ aCustomContext selectedCodes ? #() anySatisfy: [ :selectedCode | 
        selectedCode selectedSourceCode notEmptyOrNil
    ]

    "Created: / 21-08-2014 / 23:28:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:01:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective
    "Returns true if the generator/refactoring is available in given
     perspective, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     to show"

    ^ aCustomPerspective isCodeViewPerspective

    "Created: / 21-08-2014 / 23:28:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-10-2014 / 10:29:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == CustomCodeSelectionRefactoring.
! !

