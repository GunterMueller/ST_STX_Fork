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

Object subclass:#CustomContext
	instanceVariableNames:'model perspective'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomContext class methodsFor:'documentation'!

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

!CustomContext class methodsFor:'instance creation'!

new
    "Returns an initialized instance"

    ^ self basicNew initialize.

    "Modified: / 19-11-2014 / 09:36:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomContext class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == CustomContext.
! !

!CustomContext methodsFor:'accessing'!

model
    "Returns a class model on we operate e.g. RBNamespace, CustomNamespace"

    ^ model

    "Modified (comment): / 19-11-2014 / 10:00:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

model: anRBNamespace
    "see model"

    model := anRBNamespace

    "Modified (format): / 19-11-2014 / 10:01:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

perspective
    "see CustomPerspective"

    ^ perspective

    "Modified (comment): / 24-12-2014 / 22:39:02 / root"
!

perspective: aPerspective
    "see CustomPerspective"

    perspective := aPerspective

    "Created: / 27-12-2014 / 12:02:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomContext methodsFor:'accessing-selection'!

selectClassNamed: className
    self selectClassesNamed: { className }

    "Created: / 29-08-2015 / 13:21:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectClassNamed: className selector: selector
    self subclassResponsibility

    "Created: / 29-08-2015 / 13:21:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectClassesNamed: classNames
    self subclassResponsibility

    "Created: / 29-08-2015 / 13:20:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedClassCategories
    "a collection with selected class categories"

    self subclassResponsibility

    "Created: / 05-05-2014 / 00:13:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedClasses
    "a collection with selected classes"

    self subclassResponsibility

    "Created: / 26-04-2014 / 13:13:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 26-04-2014 / 22:38:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedCodes
    "a collection with source codes (CustomSourceCodeSelection) 
    with selected interval (exact position in source code) and
    corresponding class, method, selector."

    self subclassResponsibility

    "Created: / 18-08-2014 / 21:28:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedMethods
    "a collection with selected methods"

    self subclassResponsibility

    "Created: / 05-05-2014 / 00:12:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedPackages
    "a collection with selected packages"

    self subclassResponsibility

    "Created: / 05-05-2014 / 00:12:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedProtocols
    "a collection with selected method protocols"
    
    self subclassResponsibility

    "Created: / 05-05-2014 / 00:14:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedVariables
    "a collection with selected variables"

    self subclassResponsibility

    "Created: / 05-05-2014 / 00:14:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomContext methodsFor:'initialization'!

initialize

    model := SmallSense::CustomNamespace onEnvironment: BrowserEnvironment new.

    "Modified: / 19-11-2014 / 09:35:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:07:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomContext methodsFor:'instance creation'!

copyWithModel: aModel
    "Returs shallow copy with custom class model. It is useful
    if we need to keep object immutability when we receive it
    as method parameter. Setting just model could have side effect,
    because the sender probably does not expect object to be modified,
    but only read."

    ^ self copy model: aModel; yourself

    "Created: / 25-11-2014 / 19:46:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomContext methodsFor:'private'!

asRBClass: cls 
    "For given real class, return a corresponding RBClass"

    ^ Object isMetaclass 
        ifTrue:[ model metaclassNamed: cls theNonMetaclass name ]
        ifFalse:[ model classNamed: cls name ]

    "Created: / 14-11-2014 / 19:26:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 19-11-2014 / 09:39:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

asRBMethod: aMethod
    | rbClass |

    rbClass := self asRBClass: aMethod mclass.
    ^ rbClass methodFor: aMethod selector

    "Created: / 14-11-2014 / 20:17:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomContext methodsFor:'testing'!

isInteractiveContext
    "Return true, if this generator/refactoring context is interactive,
     i.e., if it may interact with user (like asking for class name or
     similar) or not. 

     Generally speaking, only top-level context is interactive an only
     if generator/refactoring was triggerred from menu.
    "
    ^ false

    "Created: / 16-09-2014 / 09:22:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomContext class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

