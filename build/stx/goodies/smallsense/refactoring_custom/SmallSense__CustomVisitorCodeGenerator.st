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

CustomCodeGenerator subclass:#CustomVisitorCodeGenerator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomVisitorCodeGenerator class methodsFor:'documentation'!

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

!CustomVisitorCodeGenerator class methodsFor:'accessing'!

description
    ^ 'Generate methods for visitor pattern'.

    "Created: / 24-07-2013 / 16:39:23 / user"
    "Modified: / 01-12-2013 / 00:22:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    ^ 'Visitor and Visited Methods'.

    "Created: / 01-12-2013 / 00:22:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2014 / 22:40:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomVisitorCodeGenerator class methodsFor:'queries'!

availableInContext:aCustomContext
    "Returns true if the generator/refactoring is available in given
     context, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     are available at given point. See class CustomContext for details."

    ^ aCustomContext selectedClasses notEmptyOrNil

    "Modified: / 23-02-2014 / 22:32:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective 
    "Returns true if the generator/refactoring is available in given
     perspective, false otherwise.

     Called by the UI to figure out what generators / refactorings
     to show"
    
    ^ aCustomPerspective isClassPerspective

    "Created: / 26-01-2014 / 21:40:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2014 / 22:33:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == CustomVisitorCodeGenerator.
! !

!CustomVisitorCodeGenerator methodsFor:'code generation-individual methods'!

buildAcceptVisitorMethod: selector withParameter: withParameter forClass: aClass
    "Creates an acceptVisitor: method"

    | comment parameterSelectorPart methodSelector |

    comment := ''.
    userPreferences generateComments ifTrue: [ 
        comment := '"Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"     

    "stub code automatically generated - please change if required"'.
    ].

    methodSelector := 'acceptVisitor: visitor'.
    parameterSelectorPart := ''.
    withParameter ifTrue: [ 
        parameterSelectorPart := ' with: parameter'.
        methodSelector := methodSelector, parameterSelectorPart.
    ].

    model createMethod
        class: aClass;
        protocol: 'visiting';
        source: ('`@methodSelector
            `"comment

            ^ visitor `@selector self `@parameterSelectorPart       
        ');
        replace: '`@methodSelector' with: methodSelector;
        replace: '`@selector' with: selector asSymbol;
        replace: '`"comment' with: comment;
        replace: '`@parameterSelectorPart' with: parameterSelectorPart;
        compile.

    "Created: / 27-07-2014 / 01:08:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 08-10-2014 / 14:47:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomVisitorCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

