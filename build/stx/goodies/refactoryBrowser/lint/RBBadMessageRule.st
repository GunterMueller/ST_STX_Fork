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

RBBlockLintRule subclass:#RBBadMessageRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBBadMessageRule class methodsFor:'documentation'!

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

!RBBadMessageRule methodsFor:'accessing'!

group
	^ 'Miscellaneous'
!

name
	^ 'Sends "questionable" message'
!

rationale
    ^ 'Check methods for sending messages that perform low level things. 
You might want to limit the number of such messages in your application. 
<P>
For example, using "<code>become:</code>" throughout your application might not be the best thing. 
Also, messages such as "<code>isKindOf:</code>" can signify a lack of polymorphism,
and "<code>instVarAt:</code>" may introduce a dependency on a particular object layout.
Finally, "<code>halt</code>" and similar messages might be due to leftover debug code.
<p>
You can see (and change) which methods are considered "questionable" by editing the 
<A INFO="Click to browse this method"
   ACTION="doit: SystemBrowser default openInClass:%1 selector:#badSelectors">
<CODE>%1>>badSelectors</CODE></A>
method.'
        bindWith:self class name

    "Modified: / 07-09-2011 / 21:49:47 / cg"
! !

!RBBadMessageRule methodsFor:'private'!

badSelectors
        ^ #( #become: #primBecome: #becomeNil #becomeSameAs:
             #changeClassToThatOf: #changeClassTo:
             #replaceReferencesTo:with:
             #respondsTo: 
             #isMemberOf: #isKindOf:
             #performMethod: 
             #performMethod:arguments: 
             #performMethod:with: 
             #performMethod:with:with: 
             #performMethod:with:with:with: 
             #allOwners #allOwnersWeakly: 
             #firstOwner 
             #ownerAfter: 
             #instVarAt: #instVarAt:put: 
             #allInstances #allInstancesDo: #nextInstance #nextObject 
             #halt #halt:)

    "Modified: / 02-03-2012 / 03:02:11 / cg"
! !

!RBBadMessageRule methodsFor:'running'!

checkClass:aContext 
    |selectors|

    selectors := self badSelectors 
                    inject:Set new
                    into:[:set :each | 
                        set
                            addAll:(aContext selectedClass whichSelectorsReferTo:each);
                            yourself
                    ].
    selectors do:[:each | 
        self 
            addClass:aContext selectedClass
            selector:each
            to:result
    ].
    selectors isEmpty ifFalse:[
        result searchStrings:self badSelectors
    ]
! !

!RBBadMessageRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

