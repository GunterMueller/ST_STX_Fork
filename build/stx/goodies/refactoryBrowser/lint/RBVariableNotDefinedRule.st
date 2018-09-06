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

RBBlockLintRule subclass:#RBVariableNotDefinedRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBVariableNotDefinedRule class methodsFor:'documentation'!

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

!RBVariableNotDefinedRule methodsFor:'accessing'!

group
	^ 'Bugs'
!

name
        ^ 'Undefined variable'
!

rationale
    ^ self appendVariableNamesFromResultToRationale:
        'This check looks for references to global variables that are not defined. 
This may be a spelling error or a reference to a class which has been removed
or is not yet loaded.'

    "Modified: / 01-03-2012 / 21:37:32 / cg"
!

severity
        ^ SeverityError
! !

!RBVariableNotDefinedRule methodsFor:'running'!

checkMethod: aContext
    Smalltalk isSmalltalkX ifTrue:[
        |anyUnknown unknownGlobals classVarNames|

        classVarNames := aContext selectedClass allClassVarNames.
        anyUnknown := nil.
        aContext compiledMethod 
            literalsDo:[:literal |
                (anyUnknown isNil
                    and:[ literal isSymbol 
                    and:[ literal isUppercaseFirst
                    and:[ (classVarNames includes:literal) not
                    and:[ (Smalltalk includesKey:literal) not ]]]])
                ifTrue:[ anyUnknown := literal ].    
            ].    
        anyUnknown notNil ifTrue:[
            "/ sigh - now we ough to parse it.
            unknownGlobals := aContext compiledMethod usedGlobals 
                                reject:[:each | (Smalltalk includesKey:each) ].
            unknownGlobals notEmpty ifTrue:[
                result 
                        addClass: aContext selectedClass
                        selector: aContext selector.
                unknownGlobals do:[:globalName | result addSearchString: globalName ] 
            ].    
        ].    
    ] ifFalse:[
        aContext compiledMethod literals do:[ :literal |
            |globalName|

            (literal isVariableBinding and: [ (globalName := literal key) notNil ]) ifTrue:[ 
                ((Smalltalk globals 
                    associationAt: globalName
                    ifAbsent: [  ]) == literal
                 or:[ (Undeclared 
                            associationAt: globalName
                            ifAbsent: [  ]) == literal ]
                ) ifFalse:[ 
                    (aContext selectedClass bindingOf: globalName) == literal ifFalse:[ 
                        result 
                                addClass: aContext selectedClass
                                selector: aContext selector.
                        result addSearchString: globalName 
                    ] 
                ] 
            ]
        ]
    ]
! !

!RBVariableNotDefinedRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

