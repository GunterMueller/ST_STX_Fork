"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015-2016 Jan Vrany

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

CustomCodeGenerator subclass:#CustomTestCaseCodeGenerator
	instanceVariableNames:'testClassName testSuperName testClassCategory generateSetUp
		generateTearDown samePackageAsTestedClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators'
!

!CustomTestCaseCodeGenerator class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015-2016 Jan Vrany

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

!CustomTestCaseCodeGenerator class methodsFor:'accessing-presentation'!

description
    ^ 'Creates a new test case'

    "Created: / 16-09-2014 / 11:32:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

group
    "Returns a collection strings describing a group to which
     receiver belongs. A groups may be nested hence the array of
     strings. For example for subgroup 'Accessors' in group 'Generators'
     this method should return #('Generators' 'Accessors')."

    "/ By default return an empty array which means the item will appear
    "/ in top-level group.
    ^ #('Testing')

    "Created: / 05-08-2014 / 14:52:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Returns show label describing the receiver. This label
     is used in UI as menu item/tree item label."

    ^ 'New Test Case'

    "Created: / 16-09-2014 / 11:23:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomTestCaseCodeGenerator class methodsFor:'queries'!

availableInContext:aCustomContext 
    | classes |

    classes := aCustomContext selectedClasses.
    ^ classes isEmptyOrNil or:[ classes noneSatisfy: [:cls | cls inheritsFrom: (Smalltalk at:#TestCase) ] ].

    "Modified: / 12-06-2015 / 20:45:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

availableInPerspective:aCustomPerspective 
    ^aCustomPerspective isClassPerspective
! !

!CustomTestCaseCodeGenerator methodsFor:'accessing'!

generateSetUp
    ^ generateSetUp
!

generateSetUp:aBoolean
    generateSetUp := aBoolean.
!

generateTearDown
    ^ generateTearDown
!

generateTearDown:aBoolean
    generateTearDown := aBoolean.
!

samePackageAsTestedClass
    "Returns true when we should assign TestCase class 
    to the same package as tested class."

    ^ samePackageAsTestedClass

    "Created: / 15-11-2014 / 11:54:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

samePackageAsTestedClass: aBoolean
    "see samePackageAsTestedClass"

    samePackageAsTestedClass := aBoolean

    "Created: / 15-11-2014 / 11:56:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

testClassCategory
    ^ testClassCategory
!

testClassCategory:aString
    testClassCategory := aString.
!

testClassName
    ^ testClassName
!

testClassName:aString
    testClassName := aString.
!

testSuperName
    ^ testSuperName
!

testSuperName:aString
    testSuperName := aString.
! !

!CustomTestCaseCodeGenerator methodsFor:'accessing - defaults'!

defaultGenerateSetUp
    "raise an error: this method should be implemented (TODO)"

    ^ false

    "Created: / 16-09-2014 / 10:27:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultGenerateTearDown
    "raise an error: this method should be implemented (TODO)"

    ^ false

    "Created: / 16-09-2014 / 10:27:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultSamePackageAsTestedClass
    "default value for samePackageAsTestedClass"

    ^ true

    "Created: / 15-11-2014 / 12:21:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

defaultSetUpCodeGeneratorClass
    ^ CustomTestCaseSetUpCodeGenerator
!

defaultTearDownCodeGeneratorClass
    ^ CustomTestCaseTearDownCodeGenerator
!

defaultTestSuperName
    ^ 'TestCase'
! !

!CustomTestCaseCodeGenerator methodsFor:'executing - private'!

buildInContext:aCustomContext 
    | classes |

    classes := aCustomContext selectedClasses.
    classes notEmptyOrNil ifTrue: [ 
        classes do: [:cls | 
            | name | 

            name := cls theNonMetaClass name , 'Tests'.
            self generateTestCaseNamed:name forClassUnderTest: cls theNonMetaclass
        ]
    ] ifFalse:[ 
        self generateTestCaseNamed:testClassName forClassUnderTest: nil .  
    ].

    "Modified: / 16-09-2014 / 10:30:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 23:49:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

configureInContext:aCustomContext 
    | classes |

    classes := aCustomContext selectedClasses.
    testSuperName := self defaultTestSuperName.
    classes isEmptyOrNil ifTrue:[
        testClassName := 'NewTestCase'.
        testClassCategory := 'Some Tests'
    ] ifFalse:[
        classes size == 1 ifTrue:[
            testClassName := classes anElement theNonMetaclass name , 'Tests'.
            testClassCategory := classes anElement theNonMetaclass category , '-Tests'.
        ] ifFalse:[
            testClassCategory := 'Some Tests'.
        ].
    ].
    generateSetUp := self defaultGenerateSetUp.
    generateTearDown := self defaultGenerateTearDown.
    samePackageAsTestedClass := self defaultSamePackageAsTestedClass.
    
    "/ Now open the dialog...

    classes size <= 1 ifTrue: [
        dialog 
            addClassNameEntryOn:((AspectAdaptor forAspect:#testClassName) 
                    subject:self)
            labeled:'Class'
            validateBy:nil.
    ].

    dialog 
        addClassNameEntryOn:((AspectAdaptor forAspect:#testSuperName) 
                subject:self)
        labeled:'Superclass'
        validateBy:nil.
    dialog 
        addClassCategoryEntryOn:((AspectAdaptor forAspect:#testClassCategory) 
                subject:self)
        labeled:'Category'
        validateBy:nil.
    dialog addSeparator.
    dialog 
        addCheckBoxOn:((AspectAdaptor forAspect:#generateSetUp) subject:self)
        labeled:'Generate #setUp'.
    dialog 
        addCheckBoxOn:((AspectAdaptor forAspect:#generateTearDown) subject:self)
        labeled:'Generate #tearDown'.
    dialog 
        addCheckBoxOn:((AspectAdaptor forAspect:#samePackageAsTestedClass) subject:self)
        labeled:'Same package as tested class'.   
    dialog addButtons.
    dialog open.

    "Created: / 16-09-2014 / 09:39:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2014 / 11:27:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:03:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generateTestCaseCodeFor:testCase forClassUnderTest:anObject 
    self 
        generateTestCaseSetUpCodeFor: testCase;
        generateTestCaseTearDownCodeFor: testCase.

    "Modified: / 16-09-2014 / 11:16:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateTestCaseNamed:testCaseClassName forClassUnderTest:classUnderTest 
    | testCase |

    (testCase := model createClass)
        superclassName:testSuperName;
        name:testClassName asSymbol;
        category:testClassCategory.

    self samePackageAsTestedClass ifTrue: [ 
        testCase package: classUnderTest package
    ].

    testCase compile.

    self generateTestCaseCodeFor:testCase forClassUnderTest:classUnderTest

    "Created: / 16-09-2014 / 10:28:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2014 / 15:32:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generateTestCaseSetUpCodeFor: testCase   
    generateSetUp ifTrue: [
        | subcontext |

        subcontext := CustomSubContext new.
        subcontext selectedClasses: (Array with: testCase).
        (self defaultSetUpCodeGeneratorClass subGeneratorOrRefactoringOf: self)
            samePackageAsTestedClass: self samePackageAsTestedClass;  
            executeInContext: subcontext.
    ].

    "Created: / 16-09-2014 / 11:15:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-10-2014 / 23:52:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2015 / 23:30:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

generateTestCaseTearDownCodeFor: testCase 
    generateTearDown ifTrue: [
        | subcontext |

        subcontext := CustomSubContext new.
        subcontext selectedClasses: (Array with: testCase).
        (self defaultTearDownCodeGeneratorClass subGeneratorOrRefactoringOf: self) 
            samePackageAsTestedClass: self samePackageAsTestedClass;  
            executeInContext:subcontext.
    ].

    "Created: / 16-09-2014 / 11:15:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-10-2014 / 23:52:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2015 / 22:14:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

updateInContext:aCustomContext 
    aCustomContext selectClassNamed: testClassName

    "Created: / 29-08-2015 / 13:37:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomTestCaseCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

