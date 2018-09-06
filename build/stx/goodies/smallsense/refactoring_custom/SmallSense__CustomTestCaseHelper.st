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

Object subclass:#CustomTestCaseHelper
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Helpers'
!

!CustomTestCaseHelper class methodsFor:'documentation'!

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
    Helper class with utility methods used in TestCase generators/refactoring.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz> 
"
! !

!CustomTestCaseHelper methodsFor:'helpers'!

testCategory: aCategory
    "Returns category based on given category in which should be TestCase located
    e.g. from Category creates Category-Tests"
    | suffix |

    suffix := '-Tests'.

    (aCategory asString endsWith: suffix) ifTrue: [
        ^ aCategory    
    ].

    ^ aCategory asString, suffix.

    "Created: / 30-08-2014 / 20:01:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 08-11-2014 / 21:09:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

