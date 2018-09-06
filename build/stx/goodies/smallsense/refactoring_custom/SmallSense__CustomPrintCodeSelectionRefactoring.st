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

CustomCodeSelectionRefactoring subclass:#CustomPrintCodeSelectionRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Refactorings'
!

!CustomPrintCodeSelectionRefactoring class methodsFor:'documentation'!

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

!CustomPrintCodeSelectionRefactoring class methodsFor:'accessing-presentation'!

description

    ^ 'Wraps selected source code with Transcript showCR: to be printed out'

    "Modified: / 15-11-2014 / 16:21:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

label

    ^ 'Wrap with Transcript showCR: '

    "Modified: / 15-11-2014 / 16:21:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomPrintCodeSelectionRefactoring methodsFor:'executing - private'!

buildInContext:aCustomContext

    refactoryBuilder 
          replace:'`@expression'
          with:'(Transcript showCR: (`@expression) asString)'
          inContext:aCustomContext

    "Modified: / 15-11-2014 / 16:36:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

