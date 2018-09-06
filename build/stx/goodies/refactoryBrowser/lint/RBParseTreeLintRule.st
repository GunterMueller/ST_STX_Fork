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

RBBasicLintRule subclass:#RBParseTreeLintRule
	instanceVariableNames:'matcher'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!

!RBParseTreeLintRule class methodsFor:'documentation'!

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

!RBParseTreeLintRule class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == RBParseTreeLintRule.
! !

!RBParseTreeLintRule class methodsFor:'testing'!

isVisible
    ^ (self name ~= #RBParseTreeLintRule) and:[self isBroken not]

    "Modified: / 26-07-2012 / 13:42:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBParseTreeLintRule methodsFor:'accessing'!

isClassScope
    "true if I am or contain only class-rules"

    ^ false
!

matcher
	^ matcher
!

resultClass
	^ ParseTreeEnvironment
!

scope

    ^'method check'
! !

!RBParseTreeLintRule methodsFor:'converting'!

skippedInLiteralEncoding

    ^super skippedInLiteralEncoding , #( matcher )

    "Created: / 27-02-2013 / 09:34:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBParseTreeLintRule methodsFor:'initialization'!

initialize
        super initialize.
        matcher := ParseTreeSearcher new
! !

!RBParseTreeLintRule methodsFor:'running'!

checkMethod: aContext 
    matcher currentSearchContext:aContext.

    (matcher canMatchMethod: aContext compiledMethod) ifTrue: [ 
        (matcher executeTree: aContext parseTree initialAnswer: nil) notNil ifTrue: [ 
            result addClass:(aContext selectedClass) selector:(aContext selector) 
        ]
    ]

    "Modified: / 08-07-2013 / 11:25:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 16-11-2016 / 19:41:47 / cg"
!

resetResult
	super resetResult.
	self result matcher: self matcher
! !

!RBParseTreeLintRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

