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

RBBlockLintRule subclass:#RBInconsistentMethodClassificationRule
	instanceVariableNames:'wrongClassificationInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBInconsistentMethodClassificationRule class methodsFor:'documentation'!

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

!RBInconsistentMethodClassificationRule methodsFor:'accessing'!

appendSearchStringsResultAs:what toRationale:aRationale
    (result notNil) ifTrue:[
        |methods prevSelector|
        
        methods := OrderedCollection new.
        result methodsInto:methods.
        methods sortBySelector:#selector.
        methods sort:[:a :b | 
                        a selector == b selector 
                        and:[ a mclass isSubclassOf:b mclass]].
        methods sortBySelector:#selector.
        
        ^ String streamContents:[:s |
            s nextPutAll:aRationale. 
            s nextPutAll:'<p>'; nextPutAll:what; nextPutAll:' '.
            methods do:[:mthd |
                |mcls msel|

                mcls := mthd mclass. msel := mthd selector.
                (msel ~~ prevSelector and:[prevSelector notNil]) ifTrue:[
                    s nextPutAll:'<P>'.
                ].    
                s nextPutAll:'<br>&nbsp;&nbsp;&nbsp;&nbsp;'.
                s nextPutAll:mcls name.
                s nextPutAll:' >> '.
                s nextPutAll:msel.
                s nextPutAll:' { <I>'.
                s nextPutAll: mthd category.
                s nextPutAll:' </I>}'.
                s cr.
                prevSelector := msel.
            ].    
        ]
    ].
    ^ aRationale
!

group
	^ 'Miscellaneous'
!

name
	^ 'Inconsistent method classification'
!

rationale
    ^ self 
        appendSearchStringsResultAs:'Inconsistent classification:' 
        toRationale: 
'By convention, methods should be put into a protocol (method category) that is equivalent to the one of the superclass
(of course, if the superclass has poor categorization, you should fix that one first, if it is your''s).'
!

resultClass
    ^ super resultClass.
    "/ ^ MultiEnvironment
!

severity
        ^ SeverityInformation
! !

!RBInconsistentMethodClassificationRule methodsFor:'running'!

checkMethod: aContext 
    | selector selectedClass superClass superProtocol ownerProtocol |

    selector := aContext selector.
    selectedClass := aContext selectedClass.
    selectedClass superclass isNil ifTrue: [^ self].
    
    superClass := selectedClass superclass whichClassIncludesSelector: selector.
    superClass isNil ifTrue: [^ self].

    superProtocol := superClass whichCategoryIncludesSelector: selector.
    ownerProtocol := selectedClass whichCategoryIncludesSelector: selector.

    superProtocol = ownerProtocol ifFalse: [
        "/ cg: the '*' stuff is probably too squeak specific
        (superProtocol isEmptyOrNil 
            or: [ superProtocol first = $* 
            or: [ ownerProtocol isEmptyOrNil 
            or: [ ownerProtocol first = $* ]]]
        ) ifFalse: [ 
            "/ wrongClassificationInfo isNil ifTrue:[
            "/     wrongClassificationInfo := Dictionary new.
            "/ ].    
            "/ (wrongClassificationInfo at:selectedClass name ifAbsentPut:[Set new])
            "/     add:selector.

            result 
                addClass: superClass selector: selector "into: superProtocol";
                addClass: selectedClass selector: selector "into: superProtocol" 
        ] 
    ] 

    "Modified (comment): / 01-03-2012 / 22:48:02 / cg"
! !

!RBInconsistentMethodClassificationRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

