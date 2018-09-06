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

Object subclass:#CustomPerspective
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

CustomPerspective class instanceVariableNames:'theOneAndOnlyInstance'

"
 No other class instance variables are inherited by this class.
"
!

CustomPerspective subclass:#Class
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomPerspective
!

CustomPerspective subclass:#ClassCategory
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomPerspective
!

CustomPerspective subclass:#CodeView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomPerspective
!

CustomPerspective subclass:#InstanceVariable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomPerspective
!

CustomPerspective subclass:#Method
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomPerspective
!

CustomPerspective subclass:#Namespace
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomPerspective
!

CustomPerspective subclass:#Package
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomPerspective
!

CustomPerspective subclass:#Protocol
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomPerspective
!

!CustomPerspective class methodsFor:'documentation'!

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
    Represents a perspective marker from which is pop-up menu invoked.

    When we select for example some class from the class menu in the Browser
    (the STX IDE) then method isClassPerspective should return true and other
    perspectives should return false.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz> 

"
! !

!CustomPerspective class methodsFor:'instance creation'!

flushSingleton
    "flushes the cached singleton"

    theOneAndOnlyInstance := nil

    "
     self flushSingleton
    "
!

instance
    "returns a singleton"

    theOneAndOnlyInstance isNil ifTrue:[
        theOneAndOnlyInstance := self basicNew initialize.
    ].
    ^ theOneAndOnlyInstance.

    "Created: / 26-01-2014 / 10:57:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "returns a singleton"

    ^ self instance.

    "Modified: / 26-01-2014 / 10:57:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomPerspective class methodsFor:'accessing'!

classCategoryPerspective
    ^ CustomPerspective::ClassCategory instance

    "Created: / 14-10-2014 / 10:11:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

classPerspective
    ^ CustomPerspective::Class instance

    "Created: / 26-01-2014 / 10:59:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeViewPerspective
    ^ CustomPerspective::CodeView instance

    "Created: / 14-10-2014 / 10:17:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

instanceVariablePerspective
    ^ CustomPerspective::InstanceVariable instance

    "Created: / 26-01-2014 / 11:00:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodPerspective
    ^ CustomPerspective::Method instance

    "Created: / 24-08-2014 / 11:14:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

namespacePerspective
    ^ CustomPerspective::Namespace instance

    "Created: / 14-10-2014 / 10:18:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

packagePerspective
    ^ CustomPerspective::Package instance

    "Created: / 14-10-2014 / 10:18:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

protocolPerspective
    ^ CustomPerspective::Protocol instance

    "Created: / 14-10-2014 / 10:18:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomPerspective class methodsFor:'testing'!

isAbstract
    ^ self == CustomPerspective

    "Created: / 26-01-2014 / 10:58:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomPerspective methodsFor:'testing'!

isClassCategoryPerspective
    ^ false

    "Created: / 14-10-2014 / 09:33:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

isClassPerspective
    ^ false

    "Created: / 26-01-2014 / 13:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCodeViewPerspective
    ^ false

    "Created: / 14-10-2014 / 09:30:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

isInstanceVariablePerspective
    ^ false

    "Created: / 26-01-2014 / 13:10:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMethodPerspective
    ^ false

    "Created: / 24-08-2014 / 11:12:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

isNamespacePerspective
    ^ false

    "Created: / 14-10-2014 / 09:32:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

isPackagePerspective
    ^ false

    "Created: / 14-10-2014 / 09:32:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

isProtocolPerspective
    ^ false

    "Created: / 14-10-2014 / 09:29:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomPerspective::Class methodsFor:'testing'!

isClassPerspective
    ^ true

    "Created: / 26-01-2014 / 13:10:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomPerspective::ClassCategory methodsFor:'testing'!

isClassCategoryPerspective
    ^ true

    "Created: / 14-10-2014 / 10:09:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomPerspective::CodeView methodsFor:'testing'!

isCodeViewPerspective
    ^ true

    "Created: / 14-10-2014 / 10:10:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomPerspective::InstanceVariable methodsFor:'testing'!

isInstanceVariablePerspective
    ^ true

    "Created: / 26-01-2014 / 13:10:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomPerspective::Method methodsFor:'testing'!

isMethodPerspective
    ^ true

    "Created: / 24-08-2014 / 11:13:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomPerspective::Namespace methodsFor:'testing'!

isNamespacePerspective
    ^ true

    "Created: / 14-10-2014 / 10:10:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomPerspective::Package methodsFor:'testing'!

isPackagePerspective
    ^ true

    "Created: / 14-10-2014 / 10:10:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomPerspective::Protocol methodsFor:'testing'!

isProtocolPerspective
    ^ true

    "Created: / 14-10-2014 / 10:10:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomPerspective class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

