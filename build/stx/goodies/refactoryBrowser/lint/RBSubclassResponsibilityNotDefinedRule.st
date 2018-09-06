"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

RBBlockLintRule subclass:#RBSubclassResponsibilityNotDefinedRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBSubclassResponsibilityNotDefinedRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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
    This rules identifies when several methods in a set of subclasses 
    are defined but not in the superclass. 
    It identifies that an abstract method is missing in the superclass.

"
! !

!RBSubclassResponsibilityNotDefinedRule methodsFor:'accessing'!

group
	^ 'Bugs'
!

name
	^ 'Subclass responsibility not defined'
!

rationale
        ^ 'Checks that all subclassResponsibility methods are defined in all leaf sub-classes.'

    "Modified: / 07-03-2012 / 21:10:37 / cg"
!

severity
        ^ SeverityError
! !

!RBSubclassResponsibilityNotDefinedRule methodsFor:'running'!

checkClass:aContext 
    |theClass allMethodsWithSubclassResponsibility subclasses|

    theClass := aContext selectedClass.
    subclasses := theClass withAllSubclasses.

    allMethodsWithSubclassResponsibility := 
        theClass methodDictionary values 
            select:[:each | 
                each sendsAnySelector:#( #subclassResponsibility #subclassResponsibility:)
            ].

    allMethodsWithSubclassResponsibility do:[:each |
        |mthdSelector|

        mthdSelector := each selector.
        subclasses do:[:class |
            (class subclasses isEmpty "so its a leaf class" 
                and:[ (class whichClassIncludesSelector:mthdSelector) == theClass ])
                ifTrue:[
                    self 
                        addClass:class
                        selector:mthdSelector                        
                        to:result
                ]
        ]
    ]

    "Modified (format): / 22-01-2013 / 18:42:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-02-2017 / 01:28:16 / cg"
! !

!RBSubclassResponsibilityNotDefinedRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

