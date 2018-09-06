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

CustomAccessMethodsCodeGenerator subclass:#CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator class methodsFor:'documentation'!

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

!CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"
    
    ^ 'Access Method(s) for ValueHolder with Change Notification for selected instance variables'

    "Modified: / 13-07-2014 / 17:13:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."
    
    ^ 'Access Method(s) for ValueHolder with Change Notification'

    "Modified: / 13-07-2014 / 17:13:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator methodsFor:'executing'!

buildInContext: aCustomContext
    "Creates access methods XX for given context"

    self executeSubGeneratorOrRefactoringClasses:(Array 
                  with:CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator
                  with:CustomValueHolderWithChangeNotificationSetterMethodsCodeGenerator)
          inContext:aCustomContext

    "Modified: / 13-07-2014 / 17:12:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

