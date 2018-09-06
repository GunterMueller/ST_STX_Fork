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

RBBlockLintRule subclass:#RBRuleIgnoredRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBRuleIgnoredRule class methodsFor:'documentation'!

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

!RBRuleIgnoredRule methodsFor:'accessing'!

group
    ^ 'Miscellaneous'

    "Modified: / 24-08-2010 / 21:46:43 / Jan Vrany <enter your email here>"
    "Modified (format): / 04-08-2011 / 19:43:12 / cg"
!

rationale
        ^ 'Method is annotated as "ignoring lint rule" by an #ignore:rationale:author: annotation.
<br>Ignoring lint rules is not the best practice. Rethink your decision.'

    "Modified: / 25-08-2010 / 14:22:27 / Jan Vrany <enter your email here>"
! !

!RBRuleIgnoredRule methodsFor:'running'!

checkMethod:aContext 
    aContext compiledMethod 
        annotationsAt: #ignore:rationale:author: 
        do:[:ann|
            self addClass: aContext selectedClass selector: aContext selector to: result.
            ^ self
        ].

    "Modified: / 24-08-2010 / 21:52:23 / Jan Vrany <enter your email here>"
    "Modified (format): / 04-08-2011 / 19:43:46 / cg"
!

name

    ^ 'Ignoring SmallLint rules'

    "Modified: / 25-08-2010 / 14:22:13 / Jan Vrany <enter your email here>"
!

shouldIgnoreClass: class selector: selector

    ^false.

    "Created: / 24-08-2010 / 21:50:56 / Jan Vrany <enter your email here>"
! !

!RBRuleIgnoredRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBRuleIgnoredRule.st,v 1.6 2014-11-28 19:51:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBRuleIgnoredRule.st,v 1.6 2014-11-28 19:51:06 cg Exp $'
!

version_SVN
    ^ '$Id: RBRuleIgnoredRule.st,v 1.6 2014-11-28 19:51:06 cg Exp $'
! !

