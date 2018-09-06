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

CustomCodeGenerator subclass:#CustomInspectorTabCodeGenerator
	instanceVariableNames:'tabLabel tabPriority'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomInspectorTabCodeGenerator class methodsFor:'documentation'!

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

!CustomInspectorTabCodeGenerator class methodsFor:'accessing-presentation'!

description
    ^ 'Generates a new method defining an inspector tab for Inspector2'

    "Modified: / 25-11-2014 / 00:02:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    ^ 'Inspector tab definition'

    "Modified: / 25-11-2014 / 00:02:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomInspectorTabCodeGenerator class methodsFor:'queries'!

availableInContext:aCustomContext 
    ^ true

    "Modified: / 24-11-2014 / 23:50:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective 
    ^ aCustomPerspective isClassPerspective

    "Modified: / 25-11-2014 / 00:01:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomInspectorTabCodeGenerator methodsFor:'accessing'!

tabLabel
    ^ tabLabel
!

tabLabel:aString
    tabLabel := aString.
!

tabPriority
    ^ tabPriority
!

tabPriority:anInteger
    tabPriority := anInteger.
! !

!CustomInspectorTabCodeGenerator methodsFor:'executing - private'!

buildInContext:aCustomContext 
    aCustomContext selectedClasses do:[:cls | 
        self buildInContext: aCustomContext forClass: cls  
    ]

    "Modified: / 25-11-2014 / 00:42:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buildInContext: aCustomContext forClass: anRBClass
    | selector |

    selector := String streamContents: [:s | tabLabel asCollectionOfWordsDo:[:w | s nextPutAll: (w select:[:c | c isAlphaNumeric ]) asUppercaseFirst ] ].

    model 
    compile: 'inspector2Tab',selector,'
    <inspector2Tab>

    ^ (self newInspector2Tab)
        label:',tabLabel storeString,';
        priority:',tabPriority storeString,';
        "/ view: [ ... ];
        "/ application: [ ... ];
        "/ text: [ ... ];
        yourself   
    ' 
    in: anRBClass
    classified: 'inspecting'.

    "Created: / 25-11-2014 / 00:42:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

configureInContext:aCustomContext
    "Perform neccessary configuration for given context, such as
     computing default values for parameters. This may interact with
     user by means of opening a dialog.

     This method is called only for interactive contexts. When using
     non interactively, a caller must do the configuration itself by means
     of accessors."

    "/ To be overridden by subclasses

    | labelHolder priorityHolder |

    tabLabel := 'New Tab Label'.
    tabPriority := 50.

    labelHolder := (AspectAdaptor forAspect:#tabLabel) subject:self.
    priorityHolder := (AspectAdaptor forAspect:#tabPriority) subject:self.

    dialog 
        addInputFieldOn: labelHolder
        labeled: 'Tab label:'
        validatedBy: nil.

    dialog 
        addInputFieldOn: (TypeConverter onNumberValue: priorityHolder minValue: 1 maxValue: 100)
        labeled: 'Tab priority:'
        validatedBy: nil.

    dialog addButtons.
    dialog open.

    "Created: / 25-11-2014 / 00:51:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

