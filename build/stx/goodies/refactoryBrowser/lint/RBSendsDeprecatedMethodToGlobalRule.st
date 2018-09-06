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

RBParseTreeLintRule subclass:#RBSendsDeprecatedMethodToGlobalRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Squeak'
!

!RBSendsDeprecatedMethodToGlobalRule class methodsFor:'documentation'!

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

!RBSendsDeprecatedMethodToGlobalRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( squeak pharo)
! !

!RBSendsDeprecatedMethodToGlobalRule methodsFor:'accessing'!

group
        ^ 'Bugs - Squeak'

    "Modified: / 01-03-2012 / 18:57:31 / cg"
!

name
	^ 'Sends a deprecated message to a known global'
!

rationale
        ^ 'Checks for sends of deprecated messages that might be removed in upcoming releases of Squeak/Pharo.
<P>This is a Squeak/Pharo specific rule, which does not make sense in ST/X'
!

selectors
	^ #(deprecated: deprecated:on:in: deprecated:explanation: deprecated:block: greaseDeprecatedApi:details:)
!

severity
        ^ SeverityError
! !

!RBSendsDeprecatedMethodToGlobalRule methodsFor:'initialization'!

initialize
    |nav patterns pattern wellKnownGlobals|

    super initialize.
    patterns := OrderedCollection new.
    wellKnownGlobals := IdentityDictionary new.
    Smalltalk 
        keysAndValuesDo:[:k :v | 
            v isBehavior ifFalse:[
                (wellKnownGlobals at:v class ifAbsentPut:[ Set new ]) add:k
            ]
        ].
    "
    #( #deprecated: 'deprecated:explanation:' 'deprecated:block:' ) do:[:sym | 
        (nav allCallsOn:sym) do:[:mr | 
            mr classIsMeta ifTrue:[
                mr actualClass 
                    withAllSubclassesDo:[:cls | 
                        patterns add:(String 
                                    streamContents:[:s | 
                                        s
                                            nextPutAll:cls theNonMetaclass name;
                                            nextPutAll:(self genericPatternForSelector:mr methodSymbol)
                                    ])
                    ]
            ] ifFalse:[
                wellKnownGlobals 
                    keysAndValuesDo:[:gcls :gnames | 
                        (gcls includesBehavior:mr actualClass) ifTrue:[
                            gnames do:[:gname | 
                                pattern := String 
                                            streamContents:[:s | 
                                                s nextPutAll:gname.
                                                s nextPutAll:(self genericPatternForSelector:mr methodSymbol)
                                            ]
                            ].
                            patterns add:pattern
                        ]
                    ]
            ]
        ]
    ].
    "
    patterns
        add:'self beep: `@object1';
        add:'self beep'.
    self matcher matchesAnyOf:patterns do:[:node :answer | node ]
! !

!RBSendsDeprecatedMethodToGlobalRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

