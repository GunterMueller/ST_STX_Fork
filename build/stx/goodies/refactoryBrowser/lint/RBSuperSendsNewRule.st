"{ Encoding: utf8 }"

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

RBBlockLintRule subclass:#RBSuperSendsNewRule
	instanceVariableNames:'matcher'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBSuperSendsNewRule class methodsFor:'documentation'!

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

!RBSuperSendsNewRule methodsFor:'accessing'!

group
        ^ 'Bugs - Squeak'

    "Modified: / 01-03-2012 / 18:57:34 / cg"
!

name
	^ 'Sends super new initialize'
!

rationale
    ^ 'Finds code which leads to double initialization (because super new already calls the initialize).
<P>Notice that this is (currently) a Squeak specific rule,
because in Squeak, the inherited implementation of new (from Behavior) 
already sends the initialize message, 
whereas in Smalltalk/X, it does not, and classes have to make this explicit.
Future versions of ST/X may be changed to do this as well,
as proper initialization seems to be a trouble spot in some cases.'

    "Created: / 04-08-2011 / 17:21:23 / cg"
! !

!RBSuperSendsNewRule methodsFor:'initialization'!

initialize
    super initialize.
    matcher := ParseTreeSearcher new.
    matcher 
        matchesAnyOf:#( 
            'super new initialize'
            '(super new: `@expr) initialize'
            'self new initialize'
            '(self new: `@expr) initialize' 
        )
        do:[:answer :node | true ].
! !

!RBSuperSendsNewRule methodsFor:'running'!

checkMethod: aContext
    |class|

    class := aContext selectedClass.
    class isMeta ifTrue: [ ^ self ].
    (matcher executeTree: aContext parseTree initialAnswer: false) ifTrue: [ 
        result addClass: class selector: aContext selector 
    ]
! !

!RBSuperSendsNewRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBSuperSendsNewRule.st,v 1.10 2015-03-02 13:16:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBSuperSendsNewRule.st,v 1.10 2015-03-02 13:16:09 cg Exp $'
!

version_SVN
    ^ '$Id: RBSuperSendsNewRule.st,v 1.10 2015-03-02 13:16:09 cg Exp $'
! !

