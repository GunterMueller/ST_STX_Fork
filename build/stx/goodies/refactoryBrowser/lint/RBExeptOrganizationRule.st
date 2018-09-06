"
 Copyright (C) 2013 Claus Gittinger 

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBBlockLintRule subclass:#RBExeptOrganizationRule
	instanceVariableNames:'complaintsPerClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBExeptOrganizationRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2013 Claus Gittinger 

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
    for the automatic regression tests to be found,
    all those unit tests should be in a category named 'tests-regression-*'.
    Otherwise, they will not be found and not executed automatically.
    This checks if classes in the RegressionsTests namespace are also
    in this category.
"
! !

!RBExeptOrganizationRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( #'guidelines' ) "public ST/X and internal eXept code must honor the guidelines"
! !

!RBExeptOrganizationRule methodsFor:'accessing'!

group
        ^ 'Guidelines'
!

name
        ^ 'Regression test in wrong category or private'
!

rationale
    ^ 'Regression tests should be categorized under the "tests-regressionXXX" class category, 
with XXX being possibly empty.
<BR>Reason:<BR>For the automatic regression tests to be found,
all unit tests should be in a category named "tests-regression*".
Otherwise, they will not be found and not executed automatically by the automatic build system.
<P>
Also, for the deployment of compact packages, regression tests should be in a separate
package named "xxx/tests" and not be defined as private classes
(otherwise, they will not be compiled into a separate loadable package,
and will always be deployed with the application)'
!

rationaleWithAnchorForClass:aClass
    |s complaints|
    
    s := self rationale.
    result notNil ifTrue:[
        (complaints := complaintsPerClass at:aClass theNonMetaclass ifAbsent:nil) notNil ifTrue:[
            s := s , '<p>'.
            complaints do:[:each |
                s := s , ((each bindWith:aClass theNonMetaclass name),'<br>')
            ].    
        ].    
    ].
    ^ s
!

resultClass
    "I will return the set of failing classes"

    ^ ClassEnvironment
! !

!RBExeptOrganizationRule methodsFor:'running'!

addClassShouldBeInRegressionTestsNamespace:classArg
    self addComplaint:'"<B>%1</B>" should be in the "RegressionTests" namespace' for:classArg.
    result addClass: classArg 
!

addClassShouldBeInTestsCategory:classArg
    self addComplaint:'"<B>%1</B>" should be in a category starting with "tests-regression" or ending in "-tests"' for:classArg.
    result addClass: classArg 
!

addClassShouldNotBePrivate:classArg
    self addComplaint:'"<B>%1</B>" should not be a private class' for:classArg.
    result addClass: classArg 
!

addComplaint:complaintString for:classArg
    complaintsPerClass isNil ifTrue:[
        complaintsPerClass := Dictionary new.
    ].
    (complaintsPerClass at:classArg theNonMetaclass ifAbsentPut:[Set new]) add:complaintString
!

checkClass: aContext
    |cls|

    cls := aContext selectedClass theNonMetaclass.
    (cls isTestCaseLike) ifTrue: [
        (cls package ~= 'stx:goodies/sunit') ifTrue:[
            cls isPrivate ifTrue:[
                self addClassShouldNotBePrivate:cls 
            ] ifFalse:[    
                cls nameSpace name = #RegressionTests ifFalse:[
                    self addClassShouldBeInRegressionTestsNamespace:cls 
                ].
                ((cls category ? '') startsWith:'tests-Regression') ifFalse:[
                    ((cls category ? '') asLowercase endsWith:'-tests') ifFalse:[
                        self addClassShouldBeInTestsCategory:cls
                    ]    
                ].    
            ].    
        ].
    ].
! !

!RBExeptOrganizationRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

