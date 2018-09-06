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

RBParseTreeLintRule subclass:#RBCollectSelectNotUsedRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBCollectSelectNotUsedRule class methodsFor:'documentation'!

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

!RBCollectSelectNotUsedRule class methodsFor:'initialization'!

checkNodeIsPossiblyCollectionMessage:aNode
    "rule out some obvious false positives"

    (aNode arguments first isBlock) ifFalse:[^ false].
    ^ true

    "Created: / 31-07-2013 / 14:20:57 / cg"
!

collectSelectSelectors
    ^ #(#select: #collect: #reject:)

    "Created: / 31-07-2013 / 13:25:19 / cg"
! !

!RBCollectSelectNotUsedRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Doesn''t use the result of a "collect:/select:/reject:"'

    "Modified: / 01-03-2012 / 12:42:42 / cg"
!

rationale
        ^ 'If the result of "<code>collect:</code>", "<code>select:</code>" or "<code>reject:</code>"
is not needed, then a simple "<code>do:</code>" should be used.
<p>
ATTENTION: 
<br>this rule leads to false positives if the invoked method
is not related to what the collection protocol suggests 
(i.e. the receiver is not a collection). 
<br>
For example, some GUI components
implement "select:" for selection handling'

    "Created: / 01-03-2012 / 12:41:52 / cg"
! !

!RBCollectSelectNotUsedRule methodsFor:'initialization'!

initialize
    super initialize.

    self matcher 
            matches: '`{:node :dict | node isMessage 
                        and: [ (RBCollectSelectNotUsedRule collectSelectSelectors includes: node selectorString) 
                        and: [ node isUsed not 
                        and: [ RBCollectSelectNotUsedRule checkNodeIsPossiblyCollectionMessage:node ]]]}'
            do: [ :node :answer | node ]

    "Modified: / 31-07-2013 / 16:57:11 / cg"
! !

!RBCollectSelectNotUsedRule methodsFor:'running'!

checkMethod: aContext 
    matcher messages isEmptyOrNil ifTrue:[
        "/ speedup this one - the match setup in #initialize is programmed,
        "/ so the matcher was not able to extract filtering selectors.
        matcher setMessages: self class collectSelectSelectors.
    ].
    super checkMethod: aContext

    "Created: / 31-07-2013 / 13:19:23 / cg"
! !

!RBCollectSelectNotUsedRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

