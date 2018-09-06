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

CustomCodeGenerator subclass:#CustomAccessMethodsCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomAccessMethodsCodeGenerator class methodsFor:'documentation'!

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

!CustomAccessMethodsCodeGenerator class methodsFor:'accessing-presentation'!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #(Accessors)

    "Created: / 22-08-2014 / 18:45:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomAccessMethodsCodeGenerator class methodsFor:'queries'!

availableInContext:aCustomContext

    ^ aCustomContext selectedClasses notEmptyOrNil

    "Modified: / 11-05-2014 / 17:37:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective

    ^ aCustomPerspective isClassPerspective or: [
        aCustomPerspective isInstanceVariablePerspective
    ]

    "Modified: / 11-05-2014 / 16:44:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAccessMethodsCodeGenerator class methodsFor:'testing'!

isAbstract
    ^ self == CustomAccessMethodsCodeGenerator

    "Modified: / 01-07-2014 / 16:19:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAccessMethodsCodeGenerator methodsFor:'accessing'!

protocol
    "Returns protocol name in which will belong getter method"

    ^ 'accessing'

    "Created: / 12-05-2014 / 23:26:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAccessMethodsCodeGenerator methodsFor:'code generation'!

sourceForClass: aClass variableName: aName
    "Should return getter method source code for given class and variable name"

    self subclassResponsibility

    "Created: / 12-05-2014 / 22:44:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-05-2014 / 20:33:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAccessMethodsCodeGenerator methodsFor:'executing'!

buildInContext: aCustomContext
    | selectedVariables |

    selectedVariables := aCustomContext selectedVariables.

    aCustomContext selectedClasses do: [ :class | 
        | variableNames |    

        variableNames := class instVarNames.

        selectedVariables notEmptyOrNil ifTrue: [
            variableNames := variableNames select: [ :variableName | 
                selectedVariables includes: variableName
            ]
        ].

        variableNames do:[ :variableName |
            | source |

            source := self sourceForClass: class variableName: variableName.

            model
                compile: source 
                in: (self methodClass: class) 
                classified: self protocol
        ]
    ]

    "Modified: / 25-01-2015 / 14:39:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAccessMethodsCodeGenerator methodsFor:'protected'!

argNameForMethodName: aMethodName
    "Returns argument name based on given method name"

    ((aMethodName size > 2) and:[ (aMethodName startsWith:'is') and:[ (aMethodName at:3) isUppercase ]])
    ifTrue:[
        ^ 'aBoolean'
    ].

    ^ 'something'

    "Created: / 04-07-2014 / 10:24:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

defaultMethodNameFor: aVarName
    "Creates getter method name for retrieving default variable value"

    ^ 'default', aVarName asUppercaseFirst

    "Created: / 29-06-2014 / 23:26:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

methodClass: aClass
    "Returns class for which will be generated a getter method.
    By overriding this is possible for example to specify only metaclass of given class."

    ^ aClass

    "Created: / 29-06-2014 / 22:52:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

methodNameFor: aVarName
    "Creates getter method name for given variable name"

    | methodName |

    methodName := aVarName.
    aVarName isUppercaseFirst ifTrue:[
        (aVarName conform:[:ch | ch isLetter not or:[ch isUppercase]]) ifFalse:[      "/ allow all-uppercase for class-vars
            methodName := methodName asLowercaseFirst. 
        ]
    ].

    ^ methodName

    "Created: / 12-05-2014 / 22:04:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

varTypeOf: aVarName class: aClass
    "Returns variable type as string for given variable name and class"

    | classesClassVars varType |

    classesClassVars := aClass theNonMetaclass allClassVarNames.

    varType := (classesClassVars includes: aVarName) 
        ifTrue:['static'] 
        ifFalse:[
            (aClass isMeta ifTrue:['classInstVar'] ifFalse:['instance'])].

    ^ varType

    "Created: / 12-05-2014 / 21:40:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 21:30:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAccessMethodsCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

