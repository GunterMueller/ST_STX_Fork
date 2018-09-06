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

Object subclass:#CustomClassQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Helpers'
!

!CustomClassQuery class methodsFor:'documentation'!

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
    Helper class for retrieving additional informations from classes.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>

"
! !

!CustomClassQuery methodsFor:'queries'!

methodForSuperclassSelector: aSelector class: aClass
    "retrieve method under given selector in class 
    superclass or in superclass superclass until method is found
    or nil is reached"

    | superclass |

    superclass := aClass superclass.
    [ superclass notNil ] whileTrue: [ 
        | method |

        method := superclass compiledMethodAt: aSelector asSymbol.
        method notNil ifTrue: [ 
            ^ method
        ].
        superclass := superclass superclass.
    ].

    ^ nil

    "Created: / 15-06-2014 / 14:58:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 07-10-2014 / 19:50:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

