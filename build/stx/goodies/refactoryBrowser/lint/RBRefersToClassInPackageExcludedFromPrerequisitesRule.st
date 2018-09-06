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

RBParseTreeLintRule subclass:#RBRefersToClassInPackageExcludedFromPrerequisitesRule
	instanceVariableNames:'currentContext'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBRefersToClassInPackageExcludedFromPrerequisitesRule class methodsFor:'documentation'!

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
! !

!RBRefersToClassInPackageExcludedFromPrerequisitesRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( stx )

    "Created: / 01-12-2014 / 11:49:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBRefersToClassInPackageExcludedFromPrerequisitesRule methodsFor:'accessing'!

group
        ^ 'Bugs - Smalltalk/X'

    "Modified: / 01-12-2014 / 11:44:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
        ^ 'Refers to a class which is excluded from prerequsites'

    "Modified: / 02-12-2014 / 11:04:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rationale
        ^ 'Check for references to a class whose package is excluded from prerequisites.

If not properly guarded, this may lead to runtime errors if the referenced class''s 
package is not loaded. 
<P>You should either update the prerequisites of the package to 
include the other package, or make this method an extension (i.e. move it to the other
package).
<P>If the dependency is really not wanted, then such a class 
reference should be guarded by some code that checks for package availability and
handle cases when the package is not loaded.'

    "Created: / 07-03-2012 / 17:43:35 / cg"
    "Modified: / 02-12-2014 / 11:04:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBRefersToClassInPackageExcludedFromPrerequisitesRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
        matches:'`{:node :context | node isVariable }'
        do:[:node :oldAnswer |
            | newAnswer |

            (newAnswer := oldAnswer) isNil ifTrue:[
                | nm cls what |

                nm := node name asSymbolIfInterned.
                nm notNil ifTrue:[
                    self assert:currentContext notNil.
                    (nm isUppercaseFirst and:[currentContext notNil]) ifTrue:[
                        cls := currentContext selectedClass.
                        cls notNil ifTrue:[
                            cls := cls theNonMetaclass.
                            ((cls classVarNames) includes:nm) ifTrue:[
                                what := nil
                            ] ifFalse:[
                                Smalltalk isSmalltalkX ifTrue:[
                                    what := cls privateClassesAt:nm.
                                    what isNil ifTrue:[
                                        what := cls topNameSpace at: nm.
                                    ].
                                ].
                                what isNil ifTrue:[
                                    what := Smalltalk at:nm
                                ].
                            ]
                        ]    
                    ].
                ].

                "/ Check if it's really a class...
                (what notNil 
                    and:[ what isBehavior 
                    and:[ what name = node name or:[ what nameWithoutNameSpacePrefix = node name ] ] ]
                ) ifTrue:[ 
                    | currentPackageDefinition referencedPackageDefinition mthd|

                    "/ cg: the checked method could be an extension of that very package
                    mthd := currentContext compiledMethod.
                    "/ method could be nil in case it's a new method which does not exist yet.
                    mthd notNil ifTrue:[ 
                        currentPackageDefinition := ProjectDefinition definitionClassForPackage: mthd "cls" package.  
                        referencedPackageDefinition := ProjectDefinition definitionClassForPackage: what package.  
                        (currentPackageDefinition notNil and:[ referencedPackageDefinition notNil ]) ifTrue:[ 
                            (currentPackageDefinition excludedFromPreRequisites includes: referencedPackageDefinition package) ifTrue:[ 
                                newAnswer := node.
                            ].
                        ].
                    ].
                ]
            ].
            newAnswer
        ]

    "Modified: / 31-07-2013 / 17:47:51 / cg"
    "Modified: / 21-08-2015 / 18:35:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBRefersToClassInPackageExcludedFromPrerequisitesRule methodsFor:'redefinable utilities'!

resultSelectionIntervalsForSource:aString tree:anRBMethodNode in: aClass do:aBlock
    | savedContext |

    savedContext := currentContext.
    [ 
        currentContext := SmalllintContext new.
        currentContext selectedClass: aClass.
        currentContext selector: anRBMethodNode selector.
        super resultSelectionIntervalsForSource:aString tree:anRBMethodNode in: aClass do:aBlock
    ] ensure:[ 
        currentContext := savedContext
    ].

    "Created: / 02-12-2014 / 11:20:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBRefersToClassInPackageExcludedFromPrerequisitesRule methodsFor:'running'!

checkMethod: aContext
    
    currentContext := aContext.    
    super checkMethod: aContext.
    currentContext := nil.

    "Created: / 08-07-2013 / 11:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBRefersToClassInPackageExcludedFromPrerequisitesRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

