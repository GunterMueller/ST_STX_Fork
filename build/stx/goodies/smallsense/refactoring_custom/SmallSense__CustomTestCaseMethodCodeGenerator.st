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

CustomCodeGenerator subclass:#CustomTestCaseMethodCodeGenerator
	instanceVariableNames:'testMethodSelectors'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomTestCaseMethodCodeGenerator class methodsFor:'documentation'!

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

!CustomTestCaseMethodCodeGenerator class methodsFor:'accessing-presentation'!

description
    "Returns more detailed description of the receiver"

    ^ 'Creates test method for TestCase from method selection'

    "Created: / 24-08-2014 / 16:16:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #('Testing')

    "Created: / 05-08-2014 / 14:14:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ 'Test method'

    "Created: / 24-08-2014 / 16:14:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseMethodCodeGenerator class methodsFor:'queries'!

availableInContext:aCustomContext
    "Returns true if the generator/refactoring is available in given
     context, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     are available at given point. See class CustomContext for details."

    ^ aCustomContext selectedMethods notEmptyOrNil

    "Created: / 24-08-2014 / 16:18:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective
    "Returns true if the generator/refactoring is available in given
     perspective, false otherwise.
     
     Called by the UI to figure out what generators / refactorings
     to show"

    ^ aCustomPerspective isMethodPerspective

    "Created: / 24-08-2014 / 16:16:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseMethodCodeGenerator methodsFor:'accessing'!

testMethodSelector:aSelector 
    "Returns how the test case method will be called for particular selector
     belonging to method to be tested."
    
    ^ testMethodSelectors at:aSelector asSymbol ifAbsent: [ 
        self createTestMethodSelectorFor: aSelector asSymbol  
    ].

    "Created: / 15-10-2014 / 08:19:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

testMethodSelector:aSelector put:aTestMethodName 
    "Sets test method name - see testMethodName:."
    
    testMethodSelectors at:aSelector asSymbol put:aTestMethodName

    "Created: / 15-10-2014 / 08:21:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseMethodCodeGenerator methodsFor:'converting'!

createTestMethodSelectorFor:aMethodSelector 
    "Returns test method selector created from method selector to be tested"
    
    |testSelector|

    testSelector := 'test_'.
    aMethodSelector asString do:[:character | 
        character isUppercase ifTrue:[
            testSelector := testSelector , '_'.
        ].
        testSelector := testSelector , character asString toLowerCase
    ].
    testSelector replaceAll:$: with:$_.
    ^testSelector

    "Created: / 15-10-2014 / 09:04:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseMethodCodeGenerator methodsFor:'executing - private'!

buildInContext: aCustomContext

    aCustomContext selectedMethods do:[ :method | 
        | class className |

        class := method mclass owningClassOrYourself.

        className := class theNonMetaclass name.
        (className endsWith: 'Tests') ifFalse: [ 
            | testClass |

            className := className, 'Tests'.
            testClass := Smalltalk classNamed: className.
            testClass notNil ifTrue: [ 
                | testSelector |

                testSelector := self testMethodSelector: method selector. 
                (testClass includesSelector: testSelector asSymbol) ifFalse: [
                    model createMethod
                        package: method package;
                        class: testClass;
                        protocol: 'tests';
                        source: (testSelector, '                            
                            "/ something ', (method methodDefinitionTemplate asString), '.    
                            self assert: 1 = 2.
                        ');
                        compile
                ].
            ].
        ].
    ].

    "Created: / 24-08-2014 / 16:24:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-11-2014 / 15:01:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 25-01-2015 / 15:18:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

configureInContext:aCustomContext

    aCustomContext selectedMethods do:[:selectedMethod |
        | selector |

        selector := selectedMethod selector asSymbol.
        (testMethodSelectors includesKey: selector) ifFalse: [ 
            testMethodSelectors 
                at: selector 
                put: (self createTestMethodSelectorFor: selector).
        ].

        dialog 
            addSelectorNameEntryOn:(DictionaryAdaptor new
                                        subject:testMethodSelectors; 
                                        aspect:selector)
            labeled:selector asString
            validateBy:nil.
    ].

    dialog addButtons.
    dialog open.

    "Created: / 15-10-2014 / 08:59:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseMethodCodeGenerator methodsFor:'initialization'!

initialize

    super initialize.
    testMethodSelectors := Dictionary new.

    "Created: / 15-10-2014 / 08:22:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseMethodCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

