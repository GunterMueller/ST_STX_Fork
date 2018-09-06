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

RBBlockLintRule subclass:#RBUncommonMessageSendRule
	instanceVariableNames:'literalNames'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBUncommonMessageSendRule class methodsFor:'documentation'!

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

!RBUncommonMessageSendRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
	^ 'Uncommon message send'
!

rationale
    ^ self 
        appendSearchStringsResultAs:'Uncommon selectors:<BR>'
        makingActionString:[:sel |
            '<A ACTION="doit: SystemBrowser default browseAllCallsOn:#%1">%1</A>' bindWith:sel
        ]
        toRationale: 
'Sending messages with a reserved name ("self" or "super"), 
a common literal ("true", "false",...) 
or with an uppercase selector name are usually bugs 
which are introduced through missing statement separators
(most often an uppercase selector is the class name of an intended
message in the next statement).'

    "Modified: / 07-04-2012 / 12:59:09 / cg"
!

test
    "JV: Don't commit this, stc won't compile it then"
    "/^ self self

    "Created: / 07-04-2012 / 12:43:54 / cg"
! !

!RBUncommonMessageSendRule methodsFor:'initialization'!

initialize
    super initialize.
    literalNames := #( #self #super #thisContext #true #false #nil #here ) asIdentitySet

    "Modified: / 07-04-2012 / 12:43:29 / cg"
! !

!RBUncommonMessageSendRule methodsFor:'running'!

checkMethod: aContext
    |method possiblyBad messages|
    
    (method := aContext compiledMethod) notNil ifTrue:[
        method isCompiledMethod ifFalse:[
            method := method method.
        ].
        method := method originalMethodIfWrapped.
        possiblyBad := 
            method 
                literalsDetect:[:checkedLiteral |
                    checkedLiteral isSymbol
                    and:[checkedLiteral isUppercaseFirst
                         or:[ literalNames includes:checkedLiteral ]]
                ]    
                ifNone:[nil].
            
        possiblyBad isNil ifTrue:[^ self].
        messages := method messagesSent.
    ] ifFalse:[
        messages := aContext allMessages "messages".
    ].
    messages do:[:eachSelector |
        self checkMethod:aContext selector:eachSelector
    ]

    "Modified: / 07-04-2012 / 12:56:27 / cg"
    "Modified: / 22-10-2013 / 13:16:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethod: aContext selector: selector
    "check if selector is a 'bad' one"

    (selector isEmpty or: [ literalNames includes: selector ]) ifTrue: [
        result 
                addClass: aContext selectedClass
                selector: aContext selector.
        result addSearchString: selector.
        ^ self.
    ].

    selector first isUppercase ifTrue:[
        "/ Now, check if it is JAVA class access sequence. If so, do not bark,
        "/ Java class names start with uppercase...

        | searcher nodes |

        "/ Search for nodes that sends suspicious message:
        searcher := ParseTreeSearcher new.
        nodes :=  Set new.
        searcher
                matches: 'self `@message: ``@args'
                        do: [:aNode :answer | aNode selectorString = selector ifTrue:[nodes add: aNode] ];
                matches: 'super `@message: ``@args'
                        do: [:aNode :answer | aNode selectorString = selector ifTrue:[nodes add: aNode] ];
                matches: '``@receiver `@message: ``@args'
                        do: [:aNode :answer | aNode selectorString = selector ifTrue:[nodes add: aNode] ].
        searcher executeTree: aContext parseTree initialAnswer: nil.                
        nodes contains:[:node |
            | current |

            current := node.
            [ current isMessage and:[current isUnary ] ] whileTrue:[ current := current receiver ].
            (current isVariable and:[current name = 'JAVA']) ifFalse:[
                result 
                        addClass: aContext selectedClass
                        selector: aContext selector.
                result addSearchString: selector.
                ^ self
            ].
        ].
    ].

    "Created: / 22-10-2013 / 13:16:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBUncommonMessageSendRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

