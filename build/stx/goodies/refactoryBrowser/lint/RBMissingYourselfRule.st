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

RBParseTreeLintRule subclass:#RBMissingYourselfRule
	instanceVariableNames:'problemNode'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBMissingYourselfRule class methodsFor:'documentation'!

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

!RBMissingYourselfRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
	^ 'Possible missing "; yourself"'
!

rationale
    |text1 text2 text3 target|

    text1 := 'Checks for missing "<code>; yourself</code>" as final message in a cascade.
'.

    text2 := ''.
    problemNode notNil ifTrue:[
        target := problemNode parent parent.
        "/ target is either a return, an assignment or a message
        target notNil ifTrue:[
            text2 := '<p>'.
            target isReturn ifTrue:[
                text2 := text2 , 'Here, the return'
            ] ifFalse:[
                target isAssignment ifTrue:[
                    text2 := text2 , 'Here, the assigned'
                ] ifFalse:[
                    text2 := text2 , 'Here, the argument'
                ].
            ].
            text2 := text2 , ' value will be the answer from '.
            text2 := text2 , '"<i><b>' , problemNode selector , '</b></i>", '.
            text2 := text2 , 'not the result of "<i>' , problemNode parent receiver formattedCode , '</i>".'.
            text2 := text2 , '<br>This may be ok (if that last message returns the receiver),'.
            text2 := text2 , 'but makes the code here vulnerable to any change there.<p>'.
        ].
    ].

    text3 := 
'This lint rule tries to locate common coding mistakes such as the notorious: 
<code><pre>    anArray := (Array new: 2) 
                    at: 1 put: 1; 
                    at: 2 put: 2</pre></code> 
In this example, <i>anArray</i> would be assigned to 2, not the array object
(due to the - possibly bad - decision to return the argument from the "<code>at:put:</code>" message).
<BR>It should be rewritten to:<code><pre>    anArray := (Array new: 2) 
                    at: 1 put: 1; 
                    at: 2 put: 2;
                    yourself</pre></code>so that the last cascade message returns the original array
for the assignment.

<P>
This check may also bark at code, where the last expression in a block (which is its return value) is such 
an expression. Most of the time, this can be ignored; especially: if the caller is a collection enumerator
or the cascade-message happens to return the receiver.
<BR>
Notice, that the checker does not know or check if the block''s value is actually needed/used
and what value is returned by the last cascade message.'.

    ^ text1,text2,text3.

    "Modified: / 06-03-2012 / 18:53:24 / cg"
! !

!RBMissingYourselfRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matches: '`{:node | 
                                node isMessage 
                                    and: [node parent isCascade 
                                    and: [node isDirectlyUsed 
                                    and: [node selector ~~ #yourself]]]}'
                do: [ :node :answer |
                    problemNode := node.
                    node 
                ]

    "Modified: / 06-03-2012 / 18:52:16 / cg"
! !

!RBMissingYourselfRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

