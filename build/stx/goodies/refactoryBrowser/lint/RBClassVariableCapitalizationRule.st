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

RBBlockLintRule subclass:#RBClassVariableCapitalizationRule
	instanceVariableNames:'badClassVarNames badClassInstVarNames badPoolVarNames'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBClassVariableCapitalizationRule class methodsFor:'documentation'!

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

!RBClassVariableCapitalizationRule methodsFor:'accessing'!

badClassInstVarNames 
    ^ badClassInstVarNames ? #()
!

badClassVarNames 
    ^ badClassVarNames ? #()
!

badPoolVarNames 
    ^ badPoolVarNames ? #()
!

group
        ^ 'Intention Revealing'
!

name
	^ 'Class variable capitalization'
!

rationale
    ^ String streamContents:[:s |
        |vars putNames|

        putNames :=
            [:cls :names |
                s 
                    nextPutAll:'<br>&nbsp;&nbsp;'; 
                    nextPutAll:'<A INFO="Click to browse this class"';
                    nextPutAll:('ACTION="doit: SystemBrowser default openInClass:%1">
<CODE>%1</CODE></A>' bindWith:cls name);
                    nextPutAll:': ';
                    nextPutAll:(names asStringCollection asStringWith:', ').
            ].
            
        s nextPutAll:'Class and pool variable names should start with an uppercase letter.
<br>Class instance variables usually start with a lowercase letter (debatable).'.
        (vars := badClassVarNames) notEmptyOrNil ifTrue:[
            s nextPutAll:'<p>Class vars (should be uppercase): '.
            badClassVarNames keysAndValuesDo:putNames.    
        ].    
        (vars := badClassInstVarNames) notEmptyOrNil ifTrue:[
            s nextPutAll:'<p>Class inst vars (usually lowercase): '.
            badClassInstVarNames keysAndValuesDo:putNames.    
        ].    
        (vars := badPoolVarNames) notEmptyOrNil ifTrue:[
            s nextPutAll:'<p>Pool vars (should be uppercase): '.
            badPoolVarNames keysAndValuesDo:putNames.    
        ].    
    ].
!

resultClass
    "I will return the set of failing variables"

    ^ VariableEnvironment
! !

!RBClassVariableCapitalizationRule methodsFor:'running'!

checkClass: aContext
        |cls|

        cls := aContext selectedClass.
        ("aContext selectedClass isTrait"false) ifTrue: [ ^ self ].
        cls isMeta ifTrue:[
            ^ self
        ].
        
        cls theMetaclass instVarNames do: [ :each | 
            each first isUppercase ifTrue: [
                badClassInstVarNames isNil ifTrue:[
                    badClassInstVarNames := Dictionary new
                ].
                (badClassInstVarNames at:cls ifAbsentPut:[Set new]) add:each.
                result addClass: cls classVariable: each 
            ] 
        ].
        
        cls classVarNames do: [ :each | 
            each first isUppercase ifFalse: [
                badClassVarNames isNil ifTrue:[
                    badClassVarNames := Dictionary new
                ].
                (badClassVarNames at:cls ifAbsentPut:[Set new]) add:each.
                result addClass: cls classVariable: each 
            ] 
        ].
        
        "/ isn't this an issue to be reported in the pool class?
        cls sharedPoolNames do: [ :each | 
            each first isUppercase ifFalse: [ 
                badPoolVarNames isNil ifTrue:[
                    badPoolVarNames := Dictionary new
                ].
                (badPoolVarNames at:cls ifAbsentPut:[Set new]) add:each.
                result addClass: cls classVariable: each 
            ] 
        ]

    "Modified: / 16-04-2010 / 15:05:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-10-2011 / 11:43:04 / cg"
! !

!RBClassVariableCapitalizationRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

