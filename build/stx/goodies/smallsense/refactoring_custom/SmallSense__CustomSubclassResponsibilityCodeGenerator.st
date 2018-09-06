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

CustomCodeGenerator subclass:#CustomSubclassResponsibilityCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomSubclassResponsibilityCodeGenerator class methodsFor:'documentation'!

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

!CustomSubclassResponsibilityCodeGenerator class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"

    ^ 'Generates method stubs marked by: self subclassResponsibility'

    "Modified: / 08-04-2014 / 21:40:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ 'Subclass responsibility methods'

    "Modified: / 08-04-2014 / 21:38:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSubclassResponsibilityCodeGenerator class methodsFor:'queries'!

availableInContext: aCustomContext
    "Returns true if the generator/refactoring is available in given
     context, false otherwise. 

     Called by the UI to figure out what generators / refactorings 
     are available at given point. See class CustomContext for details."

    ^ aCustomContext selectedClasses notEmptyOrNil

!

availableInPerspective:aCustomPerspective 
    "Returns true if the generator/refactoring is available in given
     perspective, false otherwise.

     Called by the UI to figure out what generators / refactorings
     to show"

    ^ aCustomPerspective isClassPerspective

! !

!CustomSubclassResponsibilityCodeGenerator methodsFor:'code generation'!

createSubclassResponsibilityForClass: anRBClass

    | missingRequiredSelectors classQuery |

    classQuery := CustomClassQuery new.
    self determineIsClassAbstract: anRBClass.
    missingRequiredSelectors := self missingRequiredProtocolFor: anRBClass.

    missingRequiredSelectors isCollection ifTrue: [
        missingRequiredSelectors do: [ :selector |
            | superclassMethod |

            superclassMethod := (classQuery methodForSuperclassSelector: selector class: anRBClass).

            model createMethod
                class: anRBClass;
                protocol: superclassMethod category;
                source: ('`@selector

                    self shouldImplement');
                replace: '`@selector' with: superclassMethod methodDefinitionTemplate asSymbol;
                compile. 
        ]
    ]

    "Created: / 09-04-2014 / 20:16:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-12-2014 / 23:19:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 06:41:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomSubclassResponsibilityCodeGenerator methodsFor:'executing'!

buildInContext:aCustomContext

    aCustomContext selectedClasses do: [ :class |
        self
            createSubclassResponsibilityForClass: class theNonMetaclass;
            createSubclassResponsibilityForClass: class theMetaclass.
    ]

    "Created: / 08-04-2014 / 21:33:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 13-05-2014 / 22:04:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSubclassResponsibilityCodeGenerator methodsFor:'private'!

determineIsClassAbstract: aClass
    "For model class (RBClass, RBMetaclass) determines if the class is abstract or not.
    Original RBAbstractClass >> isAbstract implementation returns mostly wrong guess,
    especially for newly created classes."

    aClass isBehavior ifTrue: [
        "Nothing to do a for real class"
        ^ self
    ].

    aClass isDefined ifTrue: [ 
        aClass isAbstract: aClass realClass isAbstract
    ] ifFalse: [ 
        "For newly created class lets assume thats not abstract"
        aClass isAbstract: false  
    ].

    "Created: / 14-12-2014 / 23:19:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

missingRequiredProtocolFor:aClass
    "return the missing required protocol; 
     that is the set of selectors which send #subclassResponsibility in a superclass and 
     have no implementation in aClass or in any class between aClass and that superclass"

    |requiredSelectors implementedSelectors|

    aClass isAbstract ifTrue:[
        "abstract classes are not responsible for methods to be defined in subclasses"    
        ^ #().
    ].

    requiredSelectors := IdentitySet new.
    implementedSelectors := IdentitySet withAll:(aClass methodDictionary keys).

    aClass allSuperclassesDo:[:eachSuperClass |
        eachSuperClass methodDictionary keysAndValuesDo:[:eachSelector :eachMethod |
            (eachMethod sendsAnySelector:#( #subclassResponsibility #subclassResponsibility: )) ifTrue:[
                (implementedSelectors includes:eachSelector) ifFalse:[
                    requiredSelectors add:eachSelector.
                ]
            ] ifFalse:[
                (requiredSelectors includes:eachSelector) ifFalse:[
                    implementedSelectors add:eachSelector.
                ].
            ].
        ]
    ].
    ^ requiredSelectors

    "Created: / 11-05-2015 / 06:41:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomSubclassResponsibilityCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

