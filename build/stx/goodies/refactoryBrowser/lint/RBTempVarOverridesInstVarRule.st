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

RBBlockLintRule subclass:#RBTempVarOverridesInstVarRule
	instanceVariableNames:'matcher badArgNames vars'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBTempVarOverridesInstVarRule class methodsFor:'documentation'!

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

!RBTempVarOverridesInstVarRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
        ^ 'Instance variable overridden (hidden) by temporary variable'
!

rationale
    ^ self
        appendSearchStringsResultAs:'Hidden instance variables:<BR>'
        makingActionString:[:sel | sel]
        toRationale: 
'Block- or temporary variables that override (hide) 
an instance variable. 
<br>This is not by itself a problem, 
but may cause problems if you later want to use the instance variable inside the method.'
! !

!RBTempVarOverridesInstVarRule methodsFor:'initialization'!

initialize
    super initialize.

    matcher := ParseTreeSearcher new.
    matcher 
        matchesArgument:'`var'
        do:[:aNode :answer | 
            "/ see checkMethod, which sets up the vars instance.

            |v isBad|

            v := aNode name.
            (isBad := vars includes:v) ifTrue:[
                badArgNames := badArgNames ? Set new.
                badArgNames add:v
            ].
            answer or:[ isBad ]
        ]

    "Modified: / 25-11-2016 / 08:33:44 / cg"
! !

!RBTempVarOverridesInstVarRule methodsFor:'running'!

checkMethod: aContext 
    |tree method badArgDefinitions|

    "a quick rejector, to avoid many parses (because parsing is very slow)"
    (aContext sourceCode includes:$|) ifFalse:[^ self].
    
    vars := aContext instVarNames.
    (matcher 
        executeTree:(tree := aContext parseTree)
        initialAnswer: false
    ) ifTrue:[
        method := aContext compiledMethod.

        "/ find the definition of varName
        badArgDefinitions := tree arguments select:[:arg | badArgNames includes:arg name].

        result 
            addClass:(aContext selectedClass) selector:(aContext selector).
        badArgDefinitions do:[:argDef |
            result
                addSearchAction:(RBEnvironmentStringSelectAction 
                                selectFrom:argDef start to:argDef stop 
                                inMethod:method);
                addSearchString:argDef name.
        ].
    ]

    "Modified: / 25-11-2016 / 08:35:40 / cg"
! !

!RBTempVarOverridesInstVarRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

