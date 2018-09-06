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

CustomContext subclass:#CustomSubContext
	instanceVariableNames:'selectedClasses selectedClassCategories selectedProtocols
		selectedMethods selectedPackages selectedVariables selectedCodes'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomSubContext class methodsFor:'documentation'!

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

!CustomSubContext methodsFor:'accessing'!

selectedClassCategories: classCategories
    "Sets the list of class categories" 

    selectedClassCategories := classCategories.

    "Modified (comment): / 29-11-2014 / 18:32:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedClasses: classes
    "Sets the list of classes"

    selectedClasses := classes

    "Created: / 26-04-2014 / 16:05:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-11-2014 / 19:26:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 20:23:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedCodes: something
    "Sets the list of code selections - instances of CustomSourceCodeSelection" 

    selectedCodes := something.

    "Created: / 18-08-2014 / 23:53:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 29-11-2014 / 18:33:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedMethods: methods
    "Sets the list of methods"

    selectedMethods := methods.

    "Modified: / 25-11-2014 / 20:27:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedPackages: packages
    "Sets the list of packages" 

    selectedPackages := packages.

    "Modified (comment): / 29-11-2014 / 18:31:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedProtocols: protocols
    "Sets the list of method protocols (i.e. categories)" 

    selectedProtocols := protocols.

    "Modified (comment): / 29-11-2014 / 18:34:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedVariables: variables
    "Sets the list of class variable names" 

    selectedVariables := variables.

    "Modified (comment): / 29-11-2014 / 18:36:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSubContext methodsFor:'accessing-selection'!

selectClassNamed:className selector:selector

    "Modified: / 29-08-2015 / 13:22:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectClassesNamed:classNames

    "Modified: / 29-08-2015 / 13:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedClassCategories

    ^ selectedClassCategories

    "Modified: / 05-05-2014 / 20:31:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedClasses
    "Returns the list of classes"

    "classes is supposed to be a collection of RBClass/RBMetaclass. However, if real classes
     are passed, they are converted to RBClasses here for your convenience"

    ^ selectedClasses ? #() collect: [ :class | 
        class isBehavior
            ifTrue:[ self asRBClass: class ] 
            ifFalse:[ class ]
    ]

    "Created: / 19-12-2013 / 12:24:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 25-11-2014 / 20:24:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedCodes

    ^ selectedCodes

    "Created: / 18-08-2014 / 23:52:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedMethods
    "Returns the list of methods"

    "methods is supposed to be a collection of RBMethod. However, if real methods (Method)
     are passed, they are converted to RBMethod here for your convenience"

    ^ selectedMethods ? #() collect: [ :method | 
        method isMethod 
            ifTrue:[ self asRBMethod: method ] 
            ifFalse:[ method ]  
    ]

    "Modified (comment): / 25-11-2014 / 20:26:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedPackages

    ^ selectedPackages

    "Modified: / 05-05-2014 / 20:32:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedProtocols
    ^ selectedProtocols

    "Modified: / 05-05-2014 / 20:31:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedVariables

    ^ selectedVariables

    "Modified: / 05-05-2014 / 20:32:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSubContext methodsFor:'initialization'!

initialize

    super initialize.
    selectedClasses := OrderedCollection new.

    "Created: / 19-12-2013 / 12:37:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-11-2014 / 10:19:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSubContext class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

