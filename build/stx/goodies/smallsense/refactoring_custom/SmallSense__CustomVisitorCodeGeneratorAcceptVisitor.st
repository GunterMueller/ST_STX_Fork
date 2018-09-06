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

CustomVisitorCodeGenerator subclass:#CustomVisitorCodeGeneratorAcceptVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomVisitorCodeGeneratorAcceptVisitor class methodsFor:'documentation'!

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

!CustomVisitorCodeGeneratorAcceptVisitor class methodsFor:'accessing'!

description
    ^ 'Method for visitor pattern - acceptVisitor'.

    "Created: / 09-03-2014 / 20:38:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 27-07-2014 / 00:58:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

label
    ^ 'Visitor Method'.

    "Created: / 09-03-2014 / 20:38:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomVisitorCodeGeneratorAcceptVisitor methodsFor:'executing'!

buildInContext: aCustomContext
    "Builds acceptVisitor method"

    aCustomContext selectedClasses do: [ :class | 
        | selector |

        selector := ('visit', class nameWithoutPrefix) asMutator.

        self
            buildAcceptVisitorMethod: selector
            withParameter: false
            forClass: class
    ].

    "Created: / 19-03-2014 / 18:32:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 03-08-2014 / 23:31:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

